# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def resource_not_found(resource)
    return if resource

    render json: { success: false, message: 'The requested record does not exist.' }, status: :not_found
  end
end
