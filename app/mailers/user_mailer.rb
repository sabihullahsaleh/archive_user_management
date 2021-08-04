class UserMailer < ApplicationMailer
    def archive_email
        @user = params[:user]
        @archived_by_user = params[:archived_by]
        mail(to: @user.email, subject: 'You have been archived')
    end

    def unarchive_email
        @user = params[:user]
        @unarchived_by_user = params[:unarchived_by]
        mail(to: @user.email, subject: 'You have been unarchived')
    end

    def delete_user_email
        @user = params[:user]
        @deleted_by_user = params[:deleted_by]
        mail(to: @user.email, subject: 'You have been unarchived')
    end
end
