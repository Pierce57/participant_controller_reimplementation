require 'swagger_helper'

RSpec.describe 'Participants API', type: :request do

  path '/api/v1/participants/{id}' do
    get 'Retrieve a participant' do
      tags 'Participants'
      produces 'application/json'

      # Path parameter for participant ID
      parameter name: :id, in: :path, type: :integer, description: 'Participant ID', required: true

      response '200', 'Participant found' do
        let(:participant) { create(:participant) } # Assuming you're using FactoryBot
        let(:id) { participant.id } # Use the created participant's ID

        # Define the expected response schema
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 user_id: { type: :integer },
                 assignment_id: { type: :integer },
                 handle: { type: :string },
                 join_team_request_id: { type: :integer, nullable: true },
                 team_id: { type: :integer, nullable: true },
                 permission_granted: { type: :boolean },
                 topic: { type: :string, nullable: true },
                 current_stage: { type: :string, nullable: true },
                 stage_deadline: { type: :string, nullable: true, format: 'date-time' }
               },
               required: %w[id user_id assignment_id]

        # Run the test
        run_test!
      end
    end
  end
        

      path '/api/v1/participants' do
        post('create participant') do
          tags 'Participants'
          consumes 'application/json'
          parameter name: :participant, in: :body, schema: {
            type: :object,
            properties: {
              user_id: { type: :integer },
              assignment_id: { type: :integer },
              team_id: { type: :integer, nullable: true }
            },
            required: ['user_id', 'assignment_id']
          }
      
          response(201, 'participant created') do
            let(:user) { User.create(email: 'test@example.com', password: 'password') }
            let(:assignment) { Assignment.create(title: 'Test Assignment') }
            let(:participant) { { user_id: user.id, assignment_id: assignment.id } }
      
            run_test!
          end
      
          response(422, 'invalid request') do
            let(:participant) { { user_id: nil, assignment_id: nil } }
            run_test!
          end
        end
      end

end