# frozen_string_literal: true

module Api
  module V1
    class TasksController < Api::BaseController
      before_action :task_not_found, only: %i[show update destroy]

      def index
        cache_key = "tasks_#{params[:status]}_#{Task.maximum(:updated_at)}"

        @tasks = Rails.cache.fetch(cache_key, expires_in: 1.hour) do
          Task.select(:id, :name, :status).by_status(params[:status])
        end
      end

      def show; end

      def create
        @task = Task.new(task_params)

        render json: { success: false, message: 'Failed to create task.', errors: @task.errors.full_messages.to_sentence }, status: :unprocessable_entity unless @task.save
      end

      def update
        return if @task.update(task_params) && @task.valid?

        render json: { success: false, message: 'Failed to update task.', errors: @task.errors.full_messages.to_sentence },
               status: :unprocessable_entity
      end

      def destroy
        begin
          @task.destroy!
        rescue ActiveRecord::RecordNotDestroyed => e
          Rails.logger.error("An unexpected error occurred: #{e.message}")
          return render json: { success: false, message: 'Failed to destroy task.', errors: e.message }, status: :unprocessable_entity
        end

        render json: { success: true, message: 'Task has been successfully destroyed.' }, status: :ok
      end

      private

      def task_params
        params.require(:task).permit(:name, :description, :status, :project_id)
      end

      def task_not_found
        @task = Task.find_by(id: params[:id])
        resource_not_found(@task)
      end
    end
  end
end
