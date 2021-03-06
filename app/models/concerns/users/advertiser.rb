module Users
  module Advertiser
    extend ActiveSupport::Concern

    included do
      has_many :campaigns
      has_many :creatives
      has_many :impressions_as_advertiser, class_name: "Impression", foreign_key: "advertiser_id"
    end

    def advertiser?
      roles.include? ENUMS::USER_ROLES["advertiser"]
    end

    def small_images(wrapped = false)
      list = images.search_metadata_format(ENUMS::IMAGE_FORMATS::SMALL)
      return list unless wrapped
      list.map { |i| Image.new(i) }
    end

    def large_images(wrapped = false)
      list = images.search_metadata_format(ENUMS::IMAGE_FORMATS::LARGE)
      return list unless wrapped
      list.map { |i| Image.new(i) }
    end

    def wide_images(wrapped = false)
      list = images.search_metadata_format(ENUMS::IMAGE_FORMATS::WIDE)
      return list unless wrapped
      list.map { |i| Image.new(i) }
    end

    def impressions_count_as_advertiser(start_date = nil, end_date = nil)
      return 0 unless advertiser?
      campaigns.map { |c| c.daily_impressions_counts(start_date, end_date).sum }.sum
    end

    def clicks_count_as_advertiser(start_date = nil, end_date = nil)
      return 0 unless advertiser?
      campaigns.map { |c| c.daily_clicks_counts(start_date, end_date).sum }.sum
    end

    def click_rate_as_advertiser(start_date = nil, end_date = nil)
      impressions_count = impressions_count_as_advertiser(start_date, end_date)
      return 0 if impressions_count.zero?
      clicks_count = clicks_count_as_advertiser(start_date, end_date)
      (clicks_count / impressions_count.to_f) * 100
    end
  end
end
