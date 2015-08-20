class BusStopPhoto < ActiveRecord::Base
  belongs_to :bus_stop
  belongs_to :user

  #TODO define photo size and file type
  has_attached_file :photo,
                    styles: {medium: "300x300>", thumb: "100x100>"}
                    #:storage => :s3,
                    #:s3_permissions => :private,
                    #:s3_credentials => "#{Rails.root}/config/s3.yml",
                    #:path => ":attachment/:id/:style.:extension"
  validates_attachment :photo, content_type: {content_type: ["image/jpg", "image/jpeg", "image/png"]}
  validates :photo, attachment_presence: true
  validates :title, presence: true
end
