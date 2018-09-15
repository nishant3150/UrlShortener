require 'test_helper'

class ShortenedLinksControllerTest < ActionDispatch::IntegrationTest
  test "index action should be success" do
    get "/shortened_links"
    assert_response :success
  end

  test "show action should be success" do
    get "/shortened_links/1"
    assert_response :success
  end

  test "new action should be success" do
    get "/shortened_links/new"
    assert_response :success
  end

  test "create action should be success" do
    assert_difference -> { ShortenedLink.count } do
      post "/shortened_links", params: { shortened_link: { name: 'Test', original_url: 'abc.com' }}
    end
    assert_response :redirect
  end

  test "create action should fail for duplicate url" do
    assert_no_difference -> { ShortenedLink.count } do
      post "/shortened_links", params: { shortened_link: { name: 'Test', original_url: 'google.co.in' }}
    end
    assert_response :redirect, message = { notice: ERROR_MSG[:LINK_EXIST] }
  end

  test "create action should fail for invalid url" do
    assert_no_difference -> { ShortenedLink.count } do
      post "/shortened_links", params: { shortened_link: { name: 'Test', original_url: 'abc def' }}
    end
    assert_response :redirect, message = { notice: ERROR_MSG[:INVALID_URL] }
  end

  test "create action should fail for empty fileds" do
    assert_no_difference -> { ShortenedLink.count } do
      post "/shortened_links", params: { shortened_link: { name: '', original_url: ' ' }}
    end
    assert_response :redirect, message = { notice: ERROR_MSG[:EMPTY_DATA] }
  end

  test "edit action should be success" do
    get "/shortened_links/1/edit"
    assert_response :success
  end

  test "update action should be success" do
    put "/shortened_links/1", params: { shortened_link: { name: 'Test-1' }}
    assert_response :redirect
  end

  test "destroy action should be success" do
    delete "/shortened_links/1"
    assert_response :redirect
    assert_equal 1, ShortenedLink.count
  end

end
