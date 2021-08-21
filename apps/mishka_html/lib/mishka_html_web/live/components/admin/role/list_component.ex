defmodule MishkaHtmlWeb.Admin.Role.ListComponent do
  use MishkaHtmlWeb, :live_component

  def render(assigns) do
    ~L"""
      <div class="col bw admin-blog-post-list">

        <div class="table-responsive">
            <table class="table vazir">
                <thead>
                    <tr>
                        <th scope="col" id="div-image">نام</th>
                        <th scope="col" id="div-title">نام نمایش</th>
                        <th scope="col" id="div-category">ثبت</th>
                        <th scope="col" id="div-opration">عملیات</th>
                    </tr>
                </thead>
                <tbody>
                    <%= for {item, color} <- Enum.zip(@roles, Stream.cycle(["wlist", "glist"])) do %>
                    <tr class="blog-list vazir <%= if color == "glist", do: "odd-list-of-blog-posts" %>">
                        <td class="align-middle text-center" id="<%= "title-#{item.id}" %>">
                            <%= item.name %>
                        </td>
                        <td class="align-middle text-center">
                            <%= item.display_name %>
                        </td>
                        <td class="align-middle text-center">
                            <%= live_component @socket, MishkaHtmlWeb.Public.TimeConverterComponent,
                                span_id: "inserted-#{item.id}-component",
                                time: item.inserted_at
                            %>
                        </td>

                        <td  class="align-middle text-center" id="<%= "opration-#{item.id}" %>">
                            <%= live_redirect "مدیریت دسترسی ها",
                            to: Routes.live_path(@socket, MishkaHtmlWeb.AdminUserRolePermissionsLive, id: item.id),
                            class: "btn btn-outline-info vazir"
                            %>
                            <a class="btn btn-outline-danger vazir" phx-click="delete" phx-value-id="<%= item.id %>">حذف</a>
                        </td>
                    </tr>
                    <% end %>
                </tbody>
            </table>
            <div class="space20"></div>
            <div class="col-sm-10">
                <%= if @roles.entries != [] do %>
                <%= live_component @socket, MishkaHtmlWeb.Public.PaginationComponent ,
                                id: :pagination,
                                pagination_url: @pagination_url,
                                data: @roles,
                                filters: @filters,
                                count: @count
                %>
            </div>
            <% end %>
        </div>

      </div>
    """
  end

  def handle_event("close", _, socket) do
    {:noreply, push_patch(socket, to: socket.assigns.return_to)}
  end
end
