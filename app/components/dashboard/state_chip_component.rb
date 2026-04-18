module Dashboard
  class StateChipComponent
    attr_reader :state

    def initialize(state:)
      @state = state
    end

    def to_partial_path
      "dashboard/components/state_chip_component"
    end
  end
end
