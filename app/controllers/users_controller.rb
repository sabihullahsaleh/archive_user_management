class UsersController < ApplicationController
  include JSONAPI::Errors

  before_action :subjected_user, only: [:archive, :unarchive, :destroy]

  def index
    if params[:filter].present?
      if params[:filter].downcase == 'archived'
        render jsonapi: User.archived
      elsif params[:filter].downcase == 'unarchived'
        render jsonapi: User.unarchived
      else
        render json: { message: 'Unrecognized Parameter.' }, status: :unprocessable_entity  
      end
    else
     render jsonapi: User.all
    end
  end

  #users/:id/archive
  def archive
    if is_archiveable
      user_success = @user.archive!
      if user_success
        @user.archived_by = current_user.id
        if @user.save
          UserMailer.with(user: @user, archived_by: @user.archived_from).archive_email.deliver_now
          render json: { message: 'Successfully Archived' }, status: :ok  
        else
          render jsonapi_errors: @user.errors, status: :unprocessable_entity
        end
      end
    else
      render json: { message: 'Either User is already archived or you are trying to archive yourself.' }, status: :unprocessable_entity  
    end
  end

  #users/:id/unarchive
  def unarchive
    if is_unarchiveable
      user_success = @user.unarchive!
      if user_success
        @user.unarchived_by = current_user.id
        @user.unarchived_at = Time.now.utc
        @user.archived_by = nil
        if @user.save
          UserMailer.with(user: @user, unarchived_by: @user.unarchived_from).unarchive_email.deliver_now
          render json: { message: 'Successfully UnArchived' }, status: :ok  
        else
          render jsonapi_errors: @user.errors, status: :unprocessable_entity
        end
      end
    else
      render json: { message: 'Either User is already archived or you are trying to unarchive yourself.' }, status: :unprocessable_entity  
    end
  end

  def destroy
    temp_user = @user
    if @user && is_deletable && @user.destroy
      UserMailer.with(user: temp_user, deleted_by: current_user).delete_user_email.deliver_now
      render json: { message: 'Successfully Destroyed' }, status: :ok  
    else
      render json: { message: 'Unable to destroy' }, status: :unprocessable_entity  
    end
  end
  
  private
  def render_jsonapi_internal_server_error(exception)
    # Call your exception notifier here. Example:
    # Raven.capture_exception(exception)
    super(exception)
  end

  def subjected_user
    @user = User.find_by(id: params[:id])
    if !@user.present?
        render jsonapi_errors: @user.errors, status: :unprocessable_entity
    end
  end

  def is_archiveable
    !@user.archived? && @user.id != current_user.id
  end

  def is_unarchiveable
    @user.archived? && @user.id != current_user.id
  end

  def is_deletable
     @user.id != current_user.id
  end

  # def user_params
  #   params.require(:users).permit(:id, :email) #email incase we receive email in request as data
  # end
end
