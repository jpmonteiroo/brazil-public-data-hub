module Dashboard
  class StatCardComponent
    attr_reader :title, :value, :reference, :badge_text, :badge_classes, :variant

    def initialize(title:, value:, reference:, badge_text:, badge_classes:, variant: :light)
      @title = title
      @value = value
      @reference = reference
      @badge_text = badge_text
      @badge_classes = badge_classes
      @variant = variant
    end

    def to_partial_path
      "dashboard/components/stat_card_component"
    end

    def dark?
      variant == :dark
    end

    def container_classes
      if dark?
        "rounded-3xl border border-white/10 bg-white/10 p-5 backdrop-blur"
      else
        "rounded-3xl border border-slate-200/70 bg-white/85 p-6 shadow-[0_16px_40px_rgba(15,23,42,0.06)] backdrop-blur"
      end
    end

    def title_classes
      dark? ? "text-xs font-medium uppercase tracking-[0.2em] text-slate-300" : "text-sm font-medium text-slate-500"
    end

    def value_classes
      dark? ? "mt-3 text-3xl font-semibold text-white" : "mt-4 text-3xl font-semibold tracking-tight text-slate-950"
    end

    def reference_classes
      dark? ? "mt-2 text-sm text-slate-300" : "mt-4 text-sm text-slate-500"
    end
  end
end
