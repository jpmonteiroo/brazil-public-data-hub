module Dashboard
  class SyncRunComponent
    attr_reader :sync_run

    def initialize(sync_run:)
      @sync_run = sync_run
    end

    def to_partial_path
      "dashboard/components/sync_run_component"
    end

    def badge_classes
      case sync_run.status
      when "success"
        "bg-emerald-50 text-emerald-700 ring-emerald-200"
      when "failed"
        "bg-rose-50 text-rose-700 ring-rose-200"
      when "running"
        "bg-amber-50 text-amber-700 ring-amber-200"
      else
        "bg-slate-100 text-slate-700 ring-slate-200"
      end
    end
  end
end
