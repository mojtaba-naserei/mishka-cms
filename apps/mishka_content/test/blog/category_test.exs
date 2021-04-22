defmodule MishkaContentTest.Blog.CategoryTest do
  use ExUnit.Case, async: true
  doctest MishkaDatabase
  alias MishkaContent.Blog.Category


  setup do
    # Explicitly get a connection before each test
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(MishkaDatabase.Repo)
  end

  @category_info %{
    "title" => "Test Category",
    "short_description" => "Test category description",
    "main_image" => "https://test.com/png.png",
    "description" => "Test category description",
    "alias_link" => "test-category-test",
  }


  describe "Happy | Blog Category CRUD DB (▰˘◡˘▰)" do
    test "create a category" do
      {:ok, :add, :category, _data} = assert Category.create(@category_info)
    end

    test "edit a category" do
      {:ok, :add, :category, data} = assert Category.create(@category_info)
      {:ok, :edit, :category, _edit_data} = assert Category.edit(Map.merge(%{title: "Test 123 test Test"}, %{id: data.id}))
    end

    test "delete a category" do
      {:ok, :add, :category, data} = assert Category.create(@category_info)
      {:ok, :delete, :category, _struct} = assert Category.delete(data.id)
    end

    test "show by id" do
      {:ok, :add, :category, data} = assert Category.create(@category_info)
      {:ok, :get_record_by_id, :category, _record_info} = assert Category.show_by_id(data.id)
    end

    test "show by alias link" do
      {:ok, :add, :category, data} = assert Category.create(@category_info)
      {:ok, :get_record_by_field, :category, _record_info} = assert Category.show_by_alias_link(data.alias_link)
    end

    test "categories" do
      {:ok, :add, :category, _data} = assert Category.create(@category_info)
      1 = assert length(Category.categories())
      1 = assert length(Category.categories(:active))
    end
  end


  describe "UnHappy | Blog Category CRUD DB ಠ╭╮ಠ" do
    test "create a category" do
      user_not_right = Map.drop(@category_info, ["title"])
      {:error, :add, :category, _changeset} = assert Category.create(user_not_right)
    end


    test "category posts" do
      # it will be changed by Pginate
      {:ok, :add, :category, data} = assert Category.create(@category_info)
      [] = assert Category.posts(:basic_data, data.id, 1, 10)
      [] = assert Category.posts(:basic_data, data.id, 1, 10, :active)
      [] = assert Category.posts(:extra_data, data.id, 1, 10)
      [] = assert Category.posts(:extra_data, data.id, 1, 10, :active)
    end
  end


end
