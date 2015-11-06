require 'rexml/document'
module Fluent
  class FileParser
    class XmlParser < Parser
      Plugin.register_parser("xml", self)

      config_param :time_xpath,   :string, :default => '[]'
      config_param :attr_xpaths,  :string, :default => '[]'
      config_param :value_xpaths, :string, :default => '[]'
      config_param :time_format,  :string, :default => nil
      def configure(conf)
        super
        @time_xpath   = json_parse(conf['time_xpath'])
        @attr_xpaths  = json_parse(conf['attr_xpaths'])
        @value_xpaths = json_parse(conf['value_xpaths'])
        @time_format  = conf['time_format']
        @time_parser  = TimeParser.new(@time_format)
      end

      def parse(text)
        begin
          doc = REXML::Document.new(text)
          $log.debug doc
          # parse time field
          @time = @time_parser.parse(doc.elements[@time_xpath[0]].method(@time_xpath[1]).call)
          record = {}
          attrs = @attr_xpaths.map do |attr_xpath|
            if attr_xpath[0].nil? # when null is specified
              attr_xpath[1] # second parameter is used as the attribute name
            else # otherwise, the target attribute name is extracted from XML
              doc.elements[attr_xpath[0]].method(attr_xpath[1]).call
            end
          end
          values = @value_xpaths.map do |value_xpath|
            if value_xpath[0].nil? # when null is specified
              value_xpath[1] # second parameter is used as the target value
            else # otherwise, the target value is extracted from XML
              doc.elements[value_xpath[0]].method(value_xpath[1]).call
            end
          end
          attrs.size.times do |i|
            record[attrs[i]] = values[i]
          end
          yield @time, record
        rescue REXML::ParseException => e
          $log.warn "Parse error", :error => e.to_s
          $log.debug_backtrace(e.backtrace)
        rescue Exception => e
          $log.warn "error", :error => e.to_s
          $log.debug_backtrace(e.backtrace)
        end
      end

      def json_parse message
        begin
          y = Yajl::Parser.new
          y.parse(message)
        rescue
          $log.error "JSON parse error", :error => $!.to_s, :error_class => $!.class.to_s
          $log.warn_backtrace $!.backtrace         
        end
      end
    end
  end
end
