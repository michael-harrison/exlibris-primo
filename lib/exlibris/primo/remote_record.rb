module Exlibris
  module Primo
    class RemoteRecord
      include MissingResponse

      def initialize record_id, attributes
        @record = Exlibris::Primo::WebService::Request::FullView.new(attributes.merge(:doc_id => record_id)).call.record
      end

      def method_missing(method, *args, &block)
        if @record.respond_to? method
          self.class.send(:define_method, method) { |*args, &block|
            @record.send method, *args, &block
          }
          send method, *args, &block
        else
          super
        end
      end

      #
      # Tell users that we respond to methods that the record responds to.
      #
      def respond_to?(method, include_private=false)
        (super || @record.respond_to?(method, include_private)) ? true : false
      end
    end
  end
end