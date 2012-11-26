module Exlibris
  module Primo
    module XmlUtil
      require 'nokogiri'

      def self.included(klass)
        klass.class_eval do
          extend Config
        end
      end

      module Config
        def xml_options
          @xml_options ||= {
            :encoding => 'UTF-8',
            :indent => 0,
            :save_with => Nokogiri::XML::Node::SaveOptions::AS_XML | Nokogiri::XML::Node::SaveOptions::NO_DECLARATION
          }
        end
      end

      # Returns an XML string and takes any args that are
      # understood by Nokogiri::XML::Builder.
      def build_xml options={}, &block
        Nokogiri::XML::Builder.new(options.merge(:encoding => 'UTF-8'), &block).to_xml(xml_options).strip
      end
      protected :build_xml

      def xml_options
        @xml_options ||= self.class.xml_options
      end
      protected :xml_options

      attr_reader :raw_xml
      protected :raw_xml

      def xml
        @xml ||= Nokogiri::XML(raw_xml)
      end

      def to_hash
        Hash.from_xml(to_xml)
      end
      protected :to_hash

      def to_xml
        xml.to_xml
      end
      protected :to_xml

      def to_json
        to_hash.to_json
      end
      protected :to_json
    end
  end
end