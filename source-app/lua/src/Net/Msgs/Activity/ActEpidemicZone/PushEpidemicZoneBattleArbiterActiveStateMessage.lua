local PushEpidemicZoneBattleArbiterActiveStateMessage = BaseClass("PushEpidemicZoneBattleArbiterActiveStateMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushEpidemicZoneBattleArbiterActiveStateMessage:OnCreate()
  base.OnCreate(self)
end

function PushEpidemicZoneBattleArbiterActiveStateMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ActEpidemicZoneManager:HandleBattleArbiterActiveState(t)
end

return PushEpidemicZoneBattleArbiterActiveStateMessage
