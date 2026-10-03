local FetchSeasonFactionVsInfoMessage = BaseClass("FetchSeasonFactionVsInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FetchSeasonFactionVsInfoMessage:OnCreate()
  base.OnCreate(self)
end

function FetchSeasonFactionVsInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  if t.defence and t.attack then
    DataCenter.SeasonFactionWarDataManager:UpdateAttackGroupInfo(t.defence, t.attack)
    DataCenter.SeasonFactionWarDataManager:UpdateStepAndStepTime(t.currStep, t.endTime or t.stepEndTime)
  end
end

return FetchSeasonFactionVsInfoMessage
