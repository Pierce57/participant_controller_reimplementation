class Api::V1::ParticipantsController < ApplicationController
  # Return a list of participants for a user or assignment
  # params - user_id
  #          assignment_id
  # GET /participants/:user_id
  # GET /participants/:assignment_id
  def index
    # # Validate and find user if user_id is provided
    # user = find_user if params[:user_id].present?
    # return if params[:user_id].present? && user.nil?

    # # Validate and find assignment if assignment_id is provided
    # assignment = find_assignment if params[:assignment_id].present?
    # return if params[:assignment_id].present? && assignment.nil?

    # filter_participants(user, assignment)

    # render json: participants, status: :ok
    # glory to the machine
    # Filter by user_id if provided
    user = User.find_by(id: params[:user_id]) if params[:user_id].present?
    return render json: { error: 'User not found' }, status: :not_found if params[:user_id].present? && user.nil?

    # Filter by assignment_id if provided
    assignment = Assignment.find_by(id: params[:assignment_id]) if params[:assignment_id].present?
    return render json: { error: 'Assignment not found' }, status: :not_found if params[:assignment_id].present? && assignment.nil?

    # Fetch participants based on filters
    participants = Participant.all
    participants = participants.where(user_id: user.id) if user
    participants = participants.where(assignment_id: assignment.id) if assignment

    render json: participants.order(:id), status: :ok
  end

  # Return a specified participant
  # params - id
  # GET /participants/:id
  def show
    participant = Participant.find(params[:id])

    render json: participant, status: :ok
  end

  # Create a participant
  # POST /participants
  def create
    user = find_user
    return unless user

    assignment = find_assignment
    return unless assignment

    participant = build_participant(user, assignment)

    if participant.save
      render json: participant, status: :created
    else
      render json: participant.errors, status: :unprocessable_entity
    end
  end

  # Delete a specified participant
  # params - id
  # DELETE /participants/:id
  def destroy
    participant = Participant.find(params[:id])

    if participant.destroy
      render json: { message: deletion_message(params) }, status: :ok
    else
      render json: participant.errors, status: :unprocessable_entity
    end
  end

  # Permitted parameters for creating a Participant object


  private

  def participant_params
    params.require(:participant).permit(:user_id, :assignment_id, :team_id, :join_team_request_id,
                                        :permission_granted, :topic, :current_stage, :stage_deadline)
  end

  def filter_participants(user, assignment)
    participants = Participant.all
    participants = participants.where(user_id: user.id) if user
    participants = participants.where(assignment_id: assignment.id) if assignment
    participants.order(:id)
  end

  def find_user
    user = User.find_by(id: participant_params[:user_id])
    render json: { error: 'User not found' }, status: :not_found unless user
    user
  end

  def find_assignment
    assignment = Assignment.find_by(id: participant_params[:assignment_id])
    render json: { error: 'Assignment not found' }, status: :not_found unless assignment
    assignment
  end

  def deletion_message(params)
    if params[:team_id].nil?
      "Participant #{params[:id]} in Assignment #{params[:assignment_id]} has been deleted successfully!"
    else
      "Participant #{params[:id]} in Team #{params[:team_id]} of Assignment #{params[:assignment_id]} has been deleted successfully!"
    end
  end

  def build_participant(user, assignment)
    Participant.new(participant_params).tap do |participant|
      participant.user_id = user.id
      participant.assignment_id = assignment.id
    end
  end
end
