class Micropost < ApplicationRecord
  belongs_to :user
  default_scope ->{order created_at: :desc}
  scope :find_post_by_id, ->(id){where user_id: id}
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.micropost.max_length}
  validate  :picture_size

  private

  def picture_size
    errors.add(:picture, t("vld_size_micopost")) if picture.size > Settings.micropost.size.megabytes
  end
end
