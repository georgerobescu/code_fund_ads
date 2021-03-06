module MMDB
  class << self
    def lookup(ip_address)
      return MaxMindDB::Result.new({}) unless mmdb

      begin
        result = mmdb.lookup(ip_address)
      rescue => e
        Rails.logger.error "Error performing lookup on ip address! #{ip_address} #{e}"
        result = MaxMindDB::Result.new({})
      end

      result
    end

    private

    def mmdb_path
      Dir.glob(DownloadAndExtractMaxmindFileJob::MAXMIND_DIR.join("**/GeoLite2-City.mmdb")).first
    end

    def mmdb
      @mmdb ||= create_mmdb
    end

    def create_mmdb
      return nil unless mmdb_path.present?
      MaxMindDB.new mmdb_path
    end
  end
end
