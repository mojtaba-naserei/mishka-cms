defmodule MishkaHtmlWeb.AdminCommentsLive do
  use MishkaHtmlWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "مدیریت نظرات")}
  end

end
