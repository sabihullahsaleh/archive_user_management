class User < ApplicationRecord
  has_secure_password
  acts_as_archival

  belongs_to :archived_from, class_name: 'User', foreign_key: :archived_by, optional: true
  belongs_to :unarchived_from, class_name: 'User', foreign_key: :unarchived_by, optional: true

  after_archive :set_unarchive_flags
  # after_unarchive :send_unarchive_email



  validates :email,
    presence: true,
    uniqueness: true

  def set_unarchive_flags
    self.unarchived_by = nil
    self.unarchived_at = nil
    self.save
  end  

  # def send_archive_email
  #   UserMailer.with(user: self, archived_by: self.archived_from).archive_email.deliver_now
  # end

  # def send_unarchive_email
  #   UserMailer.with(user: self, archived_by: self.unarchived_from).unarchive_email.deliver_now
  # end
end
