class TopController < ApplicationController
  def index

  end

  def policy
    @selected_menu[:policy] = "selected-menu"
  end
end
