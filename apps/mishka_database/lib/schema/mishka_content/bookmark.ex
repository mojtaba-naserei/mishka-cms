defmodule MishkaDatabase.Schema.MishkaContent.Bookmark do
  use Ecto.Schema


  import Ecto.Changeset
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "bookmarks" do

    field(:status, ContentStatusEnum, null: false, default: :active)
    field(:section, BookmarkSection, null: false, null: false)
    field(:section_id, :binary_id, primary_key: false, null: false)
    field(:extra, :map, null: true)

    belongs_to :users, MishkaDatabase.Schema.MishkaUser.User, foreign_key: :user_id, type: :binary_id

    timestamps(type: :utc_datetime)
  end

  @all_fields ~w(status section section_id extra user_id)a
  @all_required ~w(status section section_id user_id)a

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @all_fields)
    |> validate_required(@all_required, message: "can't be blank")
    |> MishkaDatabase.validate_binary_id(:user_id)
    |> MishkaDatabase.validate_binary_id(:section_id)
    |> foreign_key_constraint(:users, message: "you can't delete it because there is a dependency")
    |> unique_constraint(:section, name: :index_bookmarks_on_section_and_section_id_and_user_id, message: "this requested already been bookmarked.")
  end

end
