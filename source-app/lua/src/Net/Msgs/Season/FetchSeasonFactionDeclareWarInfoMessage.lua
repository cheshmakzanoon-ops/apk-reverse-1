local FetchSeasonFactionDeclareWarInfoMessage = BaseClass("FetchSeasonFactionDeclareWarInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function FetchSeasonFactionDeclareWarInfoMessage:OnCreate()
  base.OnCreate(self)
end

function FetchSeasonFactionDeclareWarInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.timeInfos then
    DataCenter.SeasonFactionWarDataManager.timeInfos = t.timeInfos
  end
  if t.actObj then
    DataCenter.SeasonFactionWarDataManager.declareWarActObj = t.actObj
    DataCenter.SeasonFactionWarDataManager.attackCampId = t.actObj.attackCampId
    if t.actObj.attackCampId == 1 then
      DataCenter.SeasonFactionWarDataManager.defenceCampId = SeasonFactionType.Gendarmerie
    else
      DataCenter.SeasonFactionWarDataManager.defenceCampId = SeasonFactionType.Rebels
    end
    DataCenter.SeasonFactionWarDataManager:UpdateStepAndStepTime(t.actObj.currStep, t.actObj.stepEndTime)
    if t.actObj.timeInfos then
      DataCenter.SeasonFactionWarDataManager.timeInfos = t.actObj.timeInfos
    end
  end
  if toInt(t.campId) > 0 then
    DataCenter.SeasonFactionWarDataManager.myCampId = t.campId
  end
  EventManager:GetInstance():Broadcast(EventId.LWSeasonFactionDeclareInfoUpdate)
end

return FetchSeasonFactionDeclareWarInfoMessage
