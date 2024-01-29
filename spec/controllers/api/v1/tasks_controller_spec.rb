# frozen_string_literal: true

# spec/controllers/api/v1/tasks_controller_spec.rb
require 'rails_helper'

RSpec.describe Api::V1::TasksController, type: :controller do
  render_views

  let(:user) { create(:user) }
  let(:task) { create(:task, user:) }

  before do
    sign_in user
  end

  describe 'GET #index' do
    it 'returns a success response' do
      create_list(:task, 3)
      get :index, format: :json
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['success']).to be_truthy
      expect(JSON.parse(response.body)['tasks'].size).to eq(3)
    end

    it 'returns tasks filtered by status' do
      create_list(:task, 2, status: 'new_task')
      create_list(:task, 3, status: 'in_progress')
      get :index, params: { status: 'new_task' }, format: :json
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['success']).to be_truthy
      expect(JSON.parse(response.body)['tasks'].size).to eq(2)
    end
  end

  describe 'GET #show' do
    let(:task) { create(:task) }

    it 'returns a success response' do
      get :show, params: { id: task.id }, format: :json
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['success']).to be_truthy
      expect(JSON.parse(response.body)['task']['id']).to eq(task.id)
    end

    it 'returns not found for non-existent task' do
      get :show, params: { id: 'non_existent_id' }, format: :json
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['success']).to be_falsey
      expect(JSON.parse(response.body)['message']).to eq('The requested record does not exist.')
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new task' do
        project = create(:project)
        task_attributes = attributes_for(:task, project_id: project.id)
        post :create, params: { task: task_attributes }, format: :json
        expect(response).to have_http_status(:ok)
        expect(Task.count).to eq(1)
        expect(Task.first.name).to eq(task_attributes[:name])
      end
    end

    context 'with invalid params' do
      it 'returns unprocessable entity status' do
        post :create, params: { task: { name: '' } }, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT #update' do
    let(:task) { create(:task) }

    context 'with valid params' do
      it 'updates the task' do
        new_name = 'Updated Task Name'
        put :update, params: { id: task.id, task: { name: new_name } }, format: :json
        expect(response).to have_http_status(:ok)
        expect(task.reload.name).to eq(new_name)
      end
    end

    context 'with invalid params' do
      it 'returns unprocessable entity status' do
        put :update, params: { id: task.id, task: { name: '' } }, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:task) { create(:task) }

    it 'destroys the task' do
      delete :destroy, params: { id: task.id }, format: :json
      expect(response).to have_http_status(:ok)
      expect(Task.count).to eq(0)
    end
  end
end
