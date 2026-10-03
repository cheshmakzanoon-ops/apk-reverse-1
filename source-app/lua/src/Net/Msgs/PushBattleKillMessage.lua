local PushBattleKillMessage = BaseClass("PushBattleKillMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushBattleKillMessage:OnCreate()
  base.OnCreate(self)
end

function PushBattleKillMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.WorldBattleManager:OnHandlePvpBattleDamage(t)
  end
end

return PushBattleKillMessage
