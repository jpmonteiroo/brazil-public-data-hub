module Constants
  module Dashboard
    DATE_FORMAT = "%d/%m/%Y".freeze
    HISTORY_LIMIT = 8
    RECENT_SYNC_LIMIT = 10
    COUNTRY_PLACE_CODE = "BR".freeze
    STATE_PLACE_TYPE = "state".freeze
    SYNC_NOTICE = "Sincronização iniciada com sucesso.".freeze

    INDICATOR_SLUGS = {
      selic: "selic",
      ibc_br: "ibc_br",
      states_count: "states_count"
    }.freeze

    HERO_STAT_CARDS = [
      { indicator_key: :selic, title: "Selic", badge_text: "BCB", badge_classes: "bg-cyan-400/15 text-cyan-100", variant: :dark },
      { indicator_key: :ibc_br, title: "IBC-Br", badge_text: "Atividade", badge_classes: "bg-white/10 text-slate-200", variant: :dark },
      { indicator_key: :states_count, title: "Estados", badge_text: "IBGE", badge_classes: "bg-emerald-400/15 text-emerald-100", variant: :dark }
    ].freeze

    STAT_CARDS = [
      { indicator_key: :selic, title: "Taxa Selic", badge_text: "BCB", badge_classes: "bg-cyan-50 text-cyan-700" },
      { indicator_key: :ibc_br, title: "IBC-Br", badge_text: "Atividade", badge_classes: "bg-indigo-50 text-indigo-700" },
      { indicator_key: :states_count, title: "Estados do Brasil", badge_text: "IBGE", badge_classes: "bg-emerald-50 text-emerald-700" }
    ].freeze

    SERIES_PANELS = [
      { indicator_key: :selic, eyebrow: "Serie temporal", title: "Histórico da Selic", tone: :cyan },
      { indicator_key: :ibc_br, eyebrow: "Serie temporal", title: "Histórico do IBC-Br", tone: :indigo }
    ].freeze
  end

  module PublicData
    COUNTRY_NAME = "Brasil".freeze
    COUNTRY_PLACE_CODE = "BR".freeze
    COUNTRY_PLACE_TYPE = "country".freeze
    STATE_PLACE_TYPE = "state".freeze
  end

  module Clients
    BCB_BASE_URL = "https://api.bcb.gov.br/dados/serie".freeze
    IBGE_BASE_URL = "https://servicodados.ibge.gov.br/api/v1".freeze
  end

  module Sync
    RECENT_ITEMS_LIMIT = 10
    RUNNING_STATUS = "running".freeze
    SUCCESS_STATUS = "success".freeze
    FAILED_STATUS = "failed".freeze

    DATA_SOURCE_SLUGS = {
      bcb: "bcb",
      ibge: "ibge"
    }.freeze

    INDICATOR_SLUGS = {
      states_count: "states_count"
    }.freeze

    IBGE_STATES_RESOURCE = "localidades/estados".freeze
  end
end
