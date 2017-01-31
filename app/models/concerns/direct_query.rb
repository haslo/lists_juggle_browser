module Concerns
  module DirectQuery
    extend ActiveSupport::Concern

    class_methods do
      def fetch_query(relation, attributes)
        fetch_relation = relation.select(attributes.values)
        fetched_array = ActiveRecord::Base.connection.select_rows(fetch_relation.to_sql)
        fetched_array.map do |fetched_row|
          ResultHash.new(Hash[fetched_row.each_with_index.map{|item,index| [attributes.keys[index], item]}])
        end
      end
    end

    class ResultHash < ::Hash
      def initialize(hash)
        hash.each do |key, value|
          self[key] = value
        end
      end
      def method_missing(symbol, *args)
        if has_key?(symbol)
          define_singleton_method(symbol) do
            self[symbol]
          end
          self[symbol]
        else
          super
        end
      end
    end

  end
end
