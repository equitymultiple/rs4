module RS4
  class MockRequest
    class << self
      def execute(path, method = :get, _body = {})
        mockument = {
          id: SecureRandom.uuid,
          current_signer_id: 0,
          name: 'noname',
          filename: 'noname.pdf',
          executed_at: Date.today,
          expired_at: Date.today + 1.day,
          sent_at: Date.today,
          state: 'draft',
          thumbnail_url: 'google.com',
          sender: 'sender',
          recipients: [
            {
              role_name: 'Investor',
              sign_url: 'www.google.com'
            }
          ],
          audits: nil,
          page_image_urls: 'google.com',
          signed_pdf_url: 'google.com/pdf.pdf',
          tags: nil,
          merge_field_values: nil,
          embed_codes: nil,
          in_person: true,
          shared_with: nil,
          identity_method: nil,
          passcode_pin_enabled: false,
          original_file_url: 'google.com'
        }

        if _body&.dig(:roles)&.any?

          mockument[:recipients] = []

          _body[:roles].each do |role|
            mockument[:recipients] << {
              role_name: role[:name],
              sign_url: 'www.google.com'
            }
          end
        end

        mockplate = {
          id: SecureRandom.uuid,
          name: 'template',
          creator: 'creator',
          expires_in: Date.today + 1.day,
          signer_sequencing: false,
          shared_with: nil,
          distribution_method: nil,
          identity_method: nil,
          kba: nil,
          passcode: nil,
          filename: 'template.pdf',
          tags: nil,
          user_id: 1,
          roles: [],
          merge_field_components: [],
          created_at: Date.today,
          updated_at: Date.today,
          thumbnail_url: 'google.com/pdf.pdf',
          page_image_urls: 'google.com/image'
        }

        case path
        when %r{reusable_templates/[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}/send_document}
          return {
            document: mockument
          }
        when %r{reusable_templates/[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}}
          return {
            reusable_template: mockplate
          }
        when /reusable_templates/
          results = {
            reusable_templates: []
          }

          i = 0
          while i < 3
            mockplate[:id] = SecureRandom.uuid
            results[:reusable_templates] << mockplate
            i += 1
          end

          return results
        when %r{documents/[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}}
          return {
            document: mockument
          }

        when /documents/
          Rails.logger.info("#{method} documents")

          results = {
            documents: []
          }
          i = 0
          while i < 3
            results[:documents] << mockument
            i += 1
          end

          return results

        end
      end
    end
  end
end
