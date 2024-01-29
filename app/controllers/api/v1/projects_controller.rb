# frozen_string_literal: true

module Api
  module V1
    class ProjectsController < Api::BaseController
      before_action :project_not_found, only: %i[show update destroy]

      def index
        generate_cache_key('projects')

        @projects = Rails.cache.fetch(@cache_key, expires_in: 1.hour) do
          Project.select(:id, :name)
        end
      end

      def get_projects_with_tasks
        generate_cache_key('projects_with_tasks')

        @projects = Rails.cache.fetch(@cache_key, expires_in: 1.hour) do
          Project.select(:id, :name).includes(:tasks)
        end
      end

      def show; end

      def create
        @project = Project.new(project_params)

        render json: { success: false, message: 'Failed to create project.', errors: @project.errors.full_messages.to_sentence }, status: :unprocessable_entity unless @project.save
      end

      def update
        render json: { success: false, message: 'Failed to update project.', errors: @project.errors.full_messages.to_sentence }, status: :unprocessable_entity unless @project.update(project_params)
      end

      def destroy
        begin
          @project.destroy!
        rescue ActiveRecord::RecordNotDestroyed => e
          Rails.logger.error("An unexpected error occurred: #{e.message}")
          return render json: { success: false, message: 'Failed to destroy project.', errors: e.message }, status: :unprocessable_entity
        end

        render json: { success: true, message: 'Project has been successfully destroyed.' }, status: :ok
      end

      private

      def project_params
        params.require(:project).permit(:name, :description)
      end

      def project_not_found
        @project = Project.find_by(id: params[:id])
        resource_not_found(@project)
      end

      def generate_cache_key(name)
        @cache_key = "#{name}_#{Project.maximum(:updated_at)}"
      end
    end
  end
end
