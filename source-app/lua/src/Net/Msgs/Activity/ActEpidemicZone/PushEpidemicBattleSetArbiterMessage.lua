local PushEpidemicBattleSetArbiterMessage = BaseClass("PushEpidemicBattleSetArbiterMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushEpidemicBattleSetArbiterMessage:OnCreate()
  base.OnCreate(self)
end

function PushEpidemicBattleSetArbiterMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.ActEpidemicZoneManager:HandleBattleArbiterActiveState(t)
end

return PushEpidemicBattleSetArbiterMessage
