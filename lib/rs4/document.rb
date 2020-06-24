module RS4
  # A prepared document populates a reusable template with
  # merge field values. The Document object is used to deserialize
  # the JSON response
  class Document
    INVESTOR_ROLE = :Investor
    ISSUER_ROLE = :Sender

    EXECUTED_STATE = :executed

    attr_accessor :id
    attr_accessor :current_signer_id
    attr_accessor :name
    attr_accessor :filename
    attr_accessor :executed_at
    attr_accessor :expired_at
    attr_accessor :sent_at
    attr_accessor :state
    attr_accessor :thumbnail_url
    attr_accessor :sender
    attr_accessor :recipients
    attr_accessor :audits
    attr_accessor :page_image_urls
    attr_accessor :signed_pdf_url
    attr_accessor :tags
    attr_accessor :merge_field_values
    attr_accessor :embed_codes
    attr_accessor :in_person
    attr_accessor :shared_with
    attr_accessor :identity_method
    attr_accessor :passcode_pin_enabled
    attr_accessor :original_file_url

    def initialize(document_args = {})
      @id = document_args[:id]
      @current_signer_id = document_args[:current_signer_id]
      @name = document_args[:name]
      @filename = document_args[:filename]
      @executed_at = document_args[:executed_at]
      @expired_at = document_args[:expired_at]
      @sent_at = document_args[:sent_at]
      @state = document_args[:state]
      @thumbnail_url = document_args[:thumbnail_url]
      @sender = document_args[:sender]
      @recipients = document_args[:recipients]
      @audits = document_args[:audits]
      @page_image_urls = document_args[:page_image_urls]
      @signed_pdf_url = document_args[:signed_pdf_url]
      @tags = document_args[:tags]
      @merge_field_values = document_args[:merge_field_values]
      @embed_codes = document_args[:embed_codes]
      @in_person = document_args[:in_person]
      @shared_with = document_args[:shared_with]
      @identity_method = document_args[:identity_method]
      @passcode_pin_enabled = document_args[:passcode_pin_enabled]
      @original_file_url = document_args[:original_file_url]
    end

    # There _may_ be more than one signer URL associated with a given
    # document. The exact amount depends on the template configuration:
    # how many roles have been created.
    #
    # For example, POA agreement will have two unique sign URLs and they
    # must be delivered to their intended individual
    def get_signer_urls(roles = [])
      signer_urls = {}

      filtered_recipients = roles.none? ? @recipients : @recipients.select { |role| roles.include? role[:role_name].to_sym }

      filtered_recipients.each do |recipient|
        role_name = recipient.dig(:role_name)
        sign_url = recipient.dig(:sign_url)

        if role_name
          signer_urls[role_name.to_sym] = sign_url
        else
          Rails.logger.error("No role name found. #{recipient.inspect}")
        end
      end

      signer_urls
    end

    class << self
      def get_document(document_guid)
        return unless document_guid

        path = "documents/#{document_guid}"

        response = RS4.configuration.request_handler.execute(path, :get)

        unless response.class == RS4::RequestError || response.nil? # .class == Net::HTTPOK
          raw_document = response.dig(:document) # JSON.parse(response.body, symbolize_names: true)

          # Document.new(raw_document[:document])
          Document.new(raw_document) if raw_document
        end
      end

      def get_documents
        path = 'documents'
        response = RS4.configuration.request_handler.execute(path, :get)

        unless response.class == RS4::RequestError || response.nil?
          documents = []

          response.dig(:documents).each do |document_hash|
            # document_hash = raw_document.pluck(:document)
            documents << Document.new(document_hash)
          end
        end

        documents
      end
    end
  end
end
