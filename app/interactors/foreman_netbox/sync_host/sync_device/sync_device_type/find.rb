# frozen_string_literal: true

module ForemanNetbox
  module SyncHost
    module SyncDevice
      module SyncDeviceType
        class Find
          include ::Interactor
          include SyncDeviceType::Concerns::Productname

          def call
            return unless slug

            context.device_type = ForemanNetbox::API.client.dcim.device_types.find_by(params)
          rescue NetboxClientRuby::LocalError, NetboxClientRuby::ClientError, NetboxClientRuby::RemoteError => e
            Foreman::Logging.exception("#{self.class} error:", e)
            context.fail!(error: "#{self.class}: #{e}")
          end

          private

          def params
            {
              slug: slug
            }
          end

          def slug
            @slug ||= productname&.parameterize
          end
        end
      end
    end
  end
end