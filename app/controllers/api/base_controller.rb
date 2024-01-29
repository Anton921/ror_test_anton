# frozen_string_literal: true

module Api
  class BaseController < ApplicationController
    before_action :authenticate_user!
    skip_before_action :verify_authenticity_token
    respond_to :json

    def authenticate_user!(*)
      if user_signed_in?
        super
      else
        respond_to do |format|
          format.json do
            render json: { success: false, message: 'You need to sign in or sign up before continuing.' },
                   status: 401
          end
        end
      end
    end
  end
end
