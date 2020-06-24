module RS4
  class ReusableTemplate
    attr_accessor :id
    attr_accessor :name
    attr_accessor :creator
    attr_accessor :expires_in
    attr_accessor :signer_sequencing
    attr_accessor :shared_with
    attr_accessor :distribution_method
    attr_accessor :identity_method
    attr_accessor :kba
    attr_accessor :passcode
    attr_accessor :filename
    attr_accessor :tags
    attr_accessor :user_id
    attr_accessor :roles
    attr_accessor :merge_field_components
    attr_accessor :created_at
    attr_accessor :updated_at
    attr_accessor :thumbnail_url
    attr_accessor :page_image_urls

    def initialize(options = {})
      @id = options[:id]
      @name = name
      @creator = options[:creator]
      @expires_in = options[:expires_in]
      @signer_sequencing = options[:signer_sequencing]
      @shared_with = options[:shared_with]
      @distribution_method = options[:distribution_method]
      @identity_method = options[:identity_method]
      @kba = options[:kba]
      @passcode = options[:passcode]
      @filename = options[:filename]
      @tags = options[:tags]
      @user_id = options[:user_id]
      @roles = options[:roles]
      @merge_field_components = options[:merge_field_components]
      @created_at = options[:created_at]
      @updated_at = options[:updated_at]
      @thumbnail_url = options[:thumbnail_url]
      @page_image_urls = options[:page_image_urls]
    end

    class << self
      def get_reusable_template(template_guid)
        return unless template_guid

        path = "reusable_templates/#{template_guid}"

        response = RS4.configuration.request_handler.execute(path, :get)

        unless response.class == RS4::RequestError || response.nil?
          # parsed_response = JSON.parse(response.read_body, symbolize_names: true)

          template_hash = response.dig(:reusable_template)

          RS4::ReusableTemplate.new(template_hash)
        end
      end

      def get_reusable_templates(options = {})
        base_path = 'reusable_templates'

        query = CGI.unescape(options.to_query)

        path = query.empty? ? base_path : "#{base_path}?#{query}"

        RS4.configuration.request_handler.execute(path, :get)
      end

      def send_document(template_guid, options = {})
        path = "reusable_templates/#{template_guid}/send_document"

        body = options

        body[:in_person] = true

        response = RS4.configuration.request_handler.execute(path, :post, body)

        Rails.logger.info("RS4::ReusableTemplate::send_document:: #{response.inspect}")

        unless response.class == RS4::RequestError || response.nil?
          # parsed_response = JSON.parse(response.read_body, symbolize_names: true)

          document_hash = response.dig(:document)

          return RS4::Document.new(document_hash)
        end
      end
    end
  end
end
