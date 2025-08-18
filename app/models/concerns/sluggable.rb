module Sluggable
  extend ActiveSupport::Concern

  included do
    before_save :set_slug, if: :should_generate_new_slug?
  end

  # Tell Rails to use the slug in URLs
  def to_param
    slug
  end

  private

  def should_generate_new_slug?
    # Generate a slug if the name changed or if the slug is currently blank.
    name_changed? || slug.blank?
  end

  def set_slug
    base_slug = name.parameterize
    candidate_slug = base_slug
    counter = 2
    # Loop until we find a unique slug
    while self.class.where.not(id: id).exists?(slug: candidate_slug)
      candidate_slug = "#{base_slug}-#{counter}"
      counter += 1
    end
    self.slug = candidate_slug
  end
end
