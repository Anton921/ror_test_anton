# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::ProjectsController, type: :controller do
  render_views

  let(:user) { create(:user) }
  let(:project) { create(:project, user:) }

  before do
    sign_in user
  end

  describe 'GET #index' do
    it 'returns a successful response' do
      get :index, format: :json
      expect(response).to have_http_status(:ok)
    end

    it 'returns a JSON response with projects' do
      projects = create_list(:project, 5)
      get :index, format: :json
      json_response = JSON.parse(response.body)
      expect(json_response['success']).to be_truthy
      expect(json_response['projects'].length).to eq(5)
      expect(json_response['projects'][0]['id']).to eq(projects.first.id)
      expect(json_response['projects'][0]['name']).to eq(projects.first.name)
    end
  end

  describe 'GET #get_projects_with_tasks' do
    it 'returns a successful response' do
      get :get_projects_with_tasks, format: :json
      expect(response).to have_http_status(:ok)
    end

    it 'returns a JSON response with projects and their tasks' do
      project = create(:project, :with_tasks)
      get :get_projects_with_tasks, format: :json
      json_response = JSON.parse(response.body)
      expect(json_response['success']).to be_truthy
      expect(json_response['projects'].length).to eq(1)
      expect(json_response['projects'][0]['id']).to eq(project.id)
      expect(json_response['projects'][0]['name']).to eq(project.name)
      expect(json_response['projects'][0]['tasks'].length).to eq(project.tasks.length)
    end
  end

  describe 'GET #show' do
    it 'returns a successful response' do
      project = create(:project)
      get :show, params: { id: project.id }, format: :json
      expect(response).to have_http_status(:ok)
    end

    it 'returns a JSON response with the project' do
      project = create(:project)
      get :show, params: { id: project.id }, format: :json
      json_response = JSON.parse(response.body)
      expect(json_response['success']).to be_truthy
      expect(json_response['project']['id']).to eq(project.id)
      expect(json_response['project']['name']).to eq(project.name)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new project' do
        project_attributes = attributes_for(:project)
        post :create, params: { project: project_attributes }, format: :json
        expect(response).to have_http_status(:ok)
        expect(Project.count).to eq(1)
        expect(Project.first.name).to eq(project_attributes[:name])
      end
    end

    context 'with invalid params' do
      it 'returns unprocessable entity status' do
        post :create, params: { project: { name: '' } }, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT #update' do
    let(:project) { create(:project) }

    context 'with valid params' do
      it 'updates the project' do
        new_name = 'Updated Project Name'
        put :update, params: { id: project.id, project: { name: new_name } }, format: :json
        expect(response).to have_http_status(:ok)
        expect(project.reload.name).to eq(new_name)
      end
    end

    context 'with invalid params' do
      it 'returns unprocessable entity status' do
        put :update, params: { id: project.id, project: { name: '' } }, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:project) { create(:project) }

    it 'destroys the project' do
      delete :destroy, params: { id: project.id }, format: :json
      expect(response).to have_http_status(:ok)
      expect(Project.count).to eq(0)
    end
  end
end
