require 'swagger_helper'
require 'rails_helper'

RSpec.describe 'Participants API', type: :request do

  path '/api/v1/participants' do

    # GET /participants
    get('list participants') do
      response(200, 'Success') do
      end
    end

    # POST /participants
    post('create participant') do

      response(201, 'Create successful') do
      end

      response(422, 'Invalid request') do
      end
    end
  end

  path '/api/v1/participants/{id}' do
    parameter name: 'id', in: :path, type: :integer, description: 'id of the participant'

    # GET /participants/:id
    get('show participant') do

      response(200, 'Show participant') do
      end

      response(404, 'Not found') do
      end
    end

    # DELETE /participants/:id
    delete('delete participant') do
      response(204, 'Delete successful') do
      end

      response(404, 'Not found') do
      end
    end
  end

  path '/api/v1/participants/{id}/permissions' do

    # PATCH /participants/:id/permissions
    patch('update participant permissions') do

      response(200, 'Update successful') do
      end

      response(404, 'Not found') do
      end
    end
  end

  path '/api/v1/participants/{id}/handle' do

    # PATCH /participants/:id/handle
    patch('update participant handle') do

      response(200, 'Update successful') do
      end

      response(404, 'Not found') do
      end
    end
  end
end