defmodule MishkaUser.Token.PhoenixToken do
  alias MishkaUser.Token.TokenManagemnt

  @type token() :: String.t()
  @type id() :: String.t()
  @type user_info() :: map()
  @type params() :: map()
  @type result() :: map() | tuple() | atom()
  @type time() :: integer()
  @type clime() :: map() | tuple() | struct()
  # ["access", "refresh", "current"]

  # create a token with Phoenix token by type
  @spec create_token(id(), :access | :refresh) :: {:ok, :access | :refresh, token()}

  def create_token(id, :access) do
    token =
      Phoenix.Token.sign(
        MishkaApiWeb.Endpoint,
        System.get_env("SECRET_ACCESS_TOKEN_SALT"),
        %{id: id, type: "access"},
        key_digest: :sha256
      )

    # save reresh token on disk db
    {:ok, :access, token}
  end

  def create_token(id, :refresh) do
    token =
      Phoenix.Token.sign(
        MishkaApiWeb.Endpoint,
        System.get_env("SECRET_REFRESH_TOKEN_SALT"),
        %{id: id, type: "refresh"},
        key_digest: :sha256
      )

    # save reresh token on disk db
    {:ok, :refresh, token}
  end

  # add create_token(id, params, :current)

  def create_refresh_acsses_token(user_info) do
    create_new_refresh_token({:ok, :delete_old_token, %{"id" => user_info.id}})
  end

  @spec refresh_token(token()) ::
          {:error, :more_device}
          | {:error, :verify_token, :refresh, :expired | :invalid | :missing | :token_otp_state}
          | %{
              access_token: %{clime: clime(), token: token()},
              refresh_token: %{clime: clime(), token: token()}
            }

  def refresh_token(token) do
    verify_token(token, :refresh)
    |> delete_old_token(token)
    |> create_new_refresh_token()
  end

  defp delete_old_token({:ok, :verify_token, :refresh, clime}, token) do
    # Save and Delete old token on disk
    TokenManagemnt.delete_child_token(clime["id"], token)
    TokenManagemnt.delete_token(clime["id"], token)

    {:ok, :delete_old_token, clime}
  end

  defp delete_old_token({:error, error_function, :refresh, action}, _token),
    do: {:error, error_function, action}

  defp create_new_refresh_token({:ok, :delete_old_token, clime}) do
    case TokenManagemnt.count_refresh_token(clime["id"]) do
      {:ok, :count_refresh_token} ->
        {:ok, :refresh, refresh_token} = create_token(clime["id"], :refresh)
        {:ok, :access, access_token} = create_token(clime["id"], :access)
        refresh_token_id = Ecto.UUID.generate()

        [
          %{
            user_id: clime["id"],
            type: "refresh",
            token_id: refresh_token_id,
            token: refresh_token,
            exp: token_expire_time(:refresh).unix_time
          },
          %{
            user_id: clime["id"],
            type: "access",
            token_id: Ecto.UUID.generate(),
            token: access_token,
            exp: token_expire_time(:access).unix_time
          }
        ]
        |> Enum.map(fn x ->
          rel = if x.type == "access", do: refresh_token_id, else: nil

          save_token(
            %{
              id: x.user_id,
              token_id: x.token_id,
              type: x.type,
              token: x.token,
              os: "linux",
              create_time: System.system_time(:second),
              last_used: System.system_time(:second),
              exp: x.exp,
              rel: rel
            },
            x.user_id
          )

          {:ok, String.to_atom(x.type), x.token,
           %{"exp" => x.exp, "typ" => x.type, "id" => x.user_id}}
        end)
        |> get_refresh_and_access_token()

      _ ->
        {:error, :more_device}
    end
  end

  defp create_new_refresh_token({:error, error_function, action}),
    do: {:error, error_function, :refresh, action}

  defp get_refresh_and_access_token([
         {:ok, :refresh, refresh_token, refresh_clime},
         {:ok, :access, access_token, access_clime}
       ]) do
    %{
      refresh_token: %{token: refresh_token, clime: refresh_clime},
      access_token: %{token: access_token, clime: access_clime}
    }
  end

  @spec verify_token(token(), :access | :refresh) ::
          {:error, :verify_token, :access | :refresh,
           :expired | :invalid | :missing | :token_otp_state}
          | {:ok, :verify_token, :access | :refresh, map}

  def verify_token(token, :refresh) do
    Phoenix.Token.verify(
      MishkaApiWeb.Endpoint,
      System.get_env("SECRET_REFRESH_TOKEN_SALT"),
      token,
      max_age: token_expire_time(:refresh).age
    )
    |> verify_token_condition(:refresh)
    |> verify_token_on_state(token)
  end

  def verify_token(token, :access) do
    Phoenix.Token.verify(MishkaApiWeb.Endpoint, System.get_env("SECRET_ACCESS_TOKEN_SALT"), token,
      max_age: token_expire_time(:access).age
    )
    |> verify_token_condition(:access)
    |> verify_token_on_state(token)
  end

  defp verify_token_condition(state, type) do
    state
    |> case do
      {:ok, clime} -> {:ok, :verify_token, type, clime}
      {:error, action} -> {:error, :verify_token, type, action}
    end
  end

  defp verify_token_on_state({:ok, :verify_token, type, clime}, token) do
    case TokenManagemnt.get_token(clime.id, token) do
      nil ->
        {:error, :verify_token, type, :token_otp_state}

      state ->
        {:ok, :verify_token, type,
         Map.new(state, fn {k, v} -> {Atom.to_string(k), v} end)
         |> Map.merge(%{"id" => clime.id})}
    end
  end

  defp verify_token_on_state({:error, :verify_token, type, action}, _token),
    do: {:error, :verify_token, type, action}

  @spec save_token(user_info(), id()) :: :ok

  def save_token(element, user_id) do
    TokenManagemnt.save(
      %{
        id: element.id,
        token_info: %{
          token_id: element.token_id,
          type: element.type,
          token: element.token,
          os: element.os,
          create_time: element.create_time,
          last_used: element.create_time,
          access_expires_in: element.exp,
          rel: element.rel
        }
      },
      user_id
    )
  end

  @spec delete_refresh_token(token()) ::
          {:ok, :delete_refresh_token}
          | {:error, :delete_refresh_token, :expired | :invalid | :missing | :token_otp_state}

  def delete_refresh_token(token) do
    verify_token(token, :refresh)
    |> delete_old_token(token)
    |> case do
      {:ok, :delete_old_token, _clime} -> {:ok, :delete_refresh_token}
      {:error, _error_function, action} -> {:error, :delete_refresh_token, action}
    end
  end

  defp token_expire_time(:refresh) do
    %{
      unix_time: DateTime.utc_now() |> DateTime.add(1_124_000, :second) |> DateTime.to_unix(),
      age: 1_124_000
    }
  end

  defp token_expire_time(:access) do
    %{
      unix_time: DateTime.utc_now() |> DateTime.add(3600, :second) |> DateTime.to_unix(),
      age: 3600
    }
  end
end
