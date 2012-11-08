require File.dirname(__FILE__) + '/../test_helper'

class QueriesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:queries)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_query
    assert_difference('Query.count') do
      post :create, :query => { }
    end

    assert_redirected_to query_path(assigns(:query))
  end

  def test_should_show_query
    get :show, :id => queries(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => queries(:one).id
    assert_response :success
  end

  def test_should_update_query
    put :update, :id => queries(:one).id, :query => { }
    assert_redirected_to query_path(assigns(:query))
  end

  def test_should_destroy_query
    assert_difference('Query.count', -1) do
      delete :destroy, :id => queries(:one).id
    end

    assert_redirected_to queries_path
  end
end
