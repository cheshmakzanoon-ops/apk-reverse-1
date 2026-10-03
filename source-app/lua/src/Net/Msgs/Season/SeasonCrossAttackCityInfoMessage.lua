local SeasonCrossAttackCityInfoMessage = BaseClass("SeasonCrossAttackCityInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonCrossAttackCityInfoMessage:OnCreate()
  base.OnCreate(self)
end

function SeasonCrossAttackCityInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  if t.infos then
    DataCenter.SeasonDataManager.ActCrossAttackDesertInfo = t.infos
    EventManager:GetInstance():Broadcast(EventId.LWSeasonCrossAttackCityInfo)
  end
end

return SeasonCrossAttackCityInfoMessage
