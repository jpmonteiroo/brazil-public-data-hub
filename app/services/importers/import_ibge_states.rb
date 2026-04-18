module Importers
  class ImportIbgeStates < ApplicationService
    def initialize(indicator:)
      @indicator = indicator
    end

    def call
      states = fetched_states

      save_country_snapshot(states)
      save_state_snapshots(states)

      states.size
    end

    private

    def fetched_states
      Clients::IbgeClient.call(resource: Constants::Sync::IBGE_STATES_RESOURCE)
    end

    def save_country_snapshot(states)
      IndicatorSnapshot.find_or_initialize_by(
        indicator: @indicator,
        reference_date: reference_date,
        place_code: Constants::PublicData::COUNTRY_PLACE_CODE
      ).tap do |snapshot|
        snapshot.value = states.size
        snapshot.place_name = Constants::PublicData::COUNTRY_NAME
        snapshot.place_type = Constants::PublicData::COUNTRY_PLACE_TYPE
        snapshot.raw_payload = {
          total: states.size,
          states: states.map { |state| { id: state["id"], sigla: state["sigla"], nome: state["nome"] } }
        }
        snapshot.fetched_at = Time.current
        snapshot.save!
      end
    end

    def save_state_snapshots(states)
      states.each do |state|
        IndicatorSnapshot.find_or_initialize_by(
          indicator: @indicator,
          reference_date: reference_date,
          place_code: state["sigla"]
        ).tap do |snapshot|
          snapshot.value = 1
          snapshot.place_name = state["nome"]
          snapshot.place_type = Constants::PublicData::STATE_PLACE_TYPE
          snapshot.raw_payload = state
          snapshot.fetched_at = Time.current
          snapshot.save!
        end
      end
    end

    def reference_date
      @reference_date ||= Date.current
    end
  end
end
