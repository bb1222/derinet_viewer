class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  DATA_WRAPPER = DataWrapper.new

  def tree
    render text: DATA_WRAPPER.get_tree(params["word"]).to_json
  end

  def suggestions
    render text: DATA_WRAPPER.get_suggestions(params["word"]).to_json
  end

end
