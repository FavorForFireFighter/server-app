class BusStopPhoto < ActiveRecord::Base
  belongs_to :bus_stop
  belongs_to :user

  has_attached_file :photo,
                    styles: {medium: "300x300>", thumb: "100x100>"}
  validates_attachment :photo, content_type: {content_type: ["image/jpg", "image/jpeg", "image/png"]}
  validates :photo, attachment_presence: true
  validates :title, presence: true

end
