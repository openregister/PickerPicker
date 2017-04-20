class TestController < ApplicationController
  def index
    @options = JSON.parse(File.read(Rails.root.join("app", "assets", "static", "locations-list.json")))
  end
end
