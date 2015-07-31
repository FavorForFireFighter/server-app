class BusStopPhoto < ActiveRecord::Base
  belongs_to :bus_stop
  belongs_to :user

  #TODO define photo size and file type
  has_attached_file :photo, styles: { medium: "300x300>", thumb: "100x100>" }
  validates_attachment :photo, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png"] }
end
