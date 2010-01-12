# monkey patch for activerecord dependency in Cramp::Model
module Cramp
  module Model
    module Quoting
      def quoted_date(value)
        if value.acts_like?(:time)
          zone_conversion_method = :getutc # modified line
          value.respond_to?(zone_conversion_method) ? value.send(zone_conversion_method) : value
        else
          value
        end.to_s(:db)
      end
    end
  end
end
