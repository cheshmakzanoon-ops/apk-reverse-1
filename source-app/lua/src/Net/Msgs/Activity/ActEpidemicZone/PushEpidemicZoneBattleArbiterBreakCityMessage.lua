local PushEpidemicZoneBattleArbiterBreakCityMessage = BaseClass("PushEpidemicZoneBattleArbiterBreakCityMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushEpidemicZoneBattleArbiterBreakCityMessage:OnCreate()
  base.OnCreate(self)
end

function PushEpidemicZoneBattleArbiterBreakCityMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ActEpidemicZoneManager:HandleBattleArbiterBreakCity(t)
end

return PushEpidemicZoneBattleArbiterBreakCityMessage
