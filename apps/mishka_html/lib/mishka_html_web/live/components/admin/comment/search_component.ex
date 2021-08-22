defmodule MishkaHtmlWeb.Admin.Comment.SearchComponent do
  use MishkaHtmlWeb, :live_component


  def render(assigns) do
    ~L"""
      <div class="clearfix"></div>
      <div class="col space30"> </div>
      <hr>
      <div class="clearfix"></div>
      <div class="col space30"> </div>
      <h2 class="vazir">
      <%= MishkaTranslator.Gettext.dgettext("html_live_component", "جستجوی پیشرفته") %>
      </h2>
      <div class="clearfix"></div>
      <div class="col space30"> </div>
      <div class="col space10"> </div>
      <form  phx-change="search">
        <div class="row vazir admin-list-search-form">
              <div class="col-md-1">
                <label for="country" class="form-label"><%= MishkaTranslator.Gettext.dgettext("html_live_component", "وضعیت") %></label>
                <div class="col space10"> </div>
                <select class="form-select" name="status" id="ContentStatus">
                  <option value=""><%= MishkaTranslator.Gettext.dgettext("html_live_component", "انتخاب") %></option>
                  <option value="inactive"><%= MishkaTranslator.Gettext.dgettext("html_live_component", "غیر فعال") %></option>
                  <option value="active"><%= MishkaTranslator.Gettext.dgettext("html_live_component", "فعال") %></option>
                  <option value="archived"><%= MishkaTranslator.Gettext.dgettext("html_live_component", "آرشیو شده") %></option>
                  <option value="soft_delete"><%= MishkaTranslator.Gettext.dgettext("html_live_component", "حذف با پرچم") %></option>
                </select>
              </div>

              <div class="col-md-1">
                <label for="country" class="form-label"><%= MishkaTranslator.Gettext.dgettext("html_live_component", "انتخاب") %>اولویت</label>
                <div class="col space10"> </div>
                <select class="form-select" name="priority" id="PostVisibility">
                  <option value=""><%= MishkaTranslator.Gettext.dgettext("html_live_component", "انتخاب") %></option>
                  <option value="none"><%= MishkaTranslator.Gettext.dgettext("html_live_component", "بدون اولویت") %></option>
                  <option value="low"><%= MishkaTranslator.Gettext.dgettext("html_live_component", "پایین") %></option>
                  <option value="medium"><%= MishkaTranslator.Gettext.dgettext("html_live_component", "متوسط") %></option>
                  <option value="high"><%= MishkaTranslator.Gettext.dgettext("html_live_component", "بالا") %></option>
                  <option value="featured"><%= MishkaTranslator.Gettext.dgettext("html_live_component", "ویژه") %></option>
                </select>
              </div>


              <div class="col-md-2">
                <label for="country" class="form-label"><%= MishkaTranslator.Gettext.dgettext("html_live_component", "بخش") %></label>
                <div class="col space10"> </div>
                <select class="form-select" name="section" id="CommentSection">
                  <option value="blog_post"><%= MishkaTranslator.Gettext.dgettext("html_live_component", "مطالب") %></option>
                </select>
              </div>

              <div class="col">
                <label for="country" class="form-label"><%= MishkaTranslator.Gettext.dgettext("html_live_component", "شناسه بخش") %></label>
                <div class="space10"> </div>
                <input type="text" class="title-input-text form-control" name="section_id" id="SectionId">
                <div class="col space10"> </div>
              </div>

              <div class="col">
                <label for="country" class="form-label"><%= MishkaTranslator.Gettext.dgettext("html_live_component", "شناسه وابستگی") %></label>
                <div class="space10"> </div>
                <input type="text" class="title-input-text form-control" name="sub" id="Sub">
                <div class="col space10"> </div>
              </div>

              <div class="col-md-1">
                <label for="country" class="form-label"><%= MishkaTranslator.Gettext.dgettext("html_live_component", "تعداد") %></label>
                <div class="col space10"> </div>
                <select class="form-select" id="countrecords" name="count">
                  <option value="10"><%= MishkaTranslator.Gettext.dgettext("html_live_component", "انتخاب") %></option>
                  <option value="20"><%= MishkaTranslator.Gettext.dgettext("html_live_component", "%{count} عدد", count: 20) %></option>
                  <option value="30"><%= MishkaTranslator.Gettext.dgettext("html_live_component", "%{count} عدد", count: 30) %></option>
                  <option value="40"><%= MishkaTranslator.Gettext.dgettext("html_live_component", "%{count} عدد", count: 40) %></option>
                </select>
              </div>

              <div class="col-sm-2">
                  <label for="country" class="form-label vazir"><%= MishkaTranslator.Gettext.dgettext("html_live_component", "عملیات سریع") %></label>
                  <div class="col space10"> </div>
                  <button type="button" class="vazir col-sm-8 btn btn-primary reset-admin-search-btn" phx-click="reset"><%= MishkaTranslator.Gettext.dgettext("html_live_component", "ریست") %></button>
              </div>
        </div>
      </form>
    """
  end

  def handle_event("close", _, socket) do
    {:noreply, push_patch(socket, to: socket.assigns.return_to)}
  end
end
