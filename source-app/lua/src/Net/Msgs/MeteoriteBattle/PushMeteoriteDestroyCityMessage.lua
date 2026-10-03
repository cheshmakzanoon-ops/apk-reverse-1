local PushMeteoriteDestroyCityMessage = BaseClass("PushMeteoriteDestroyCityMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushMeteoriteDestroyCityMessage:OnCreate()
  base.OnCreate(self)
end

function PushMeteoriteDestroyCityMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActMeteoriteBattleManager:TryShowFlyTip(t.mailId, t.login)
  end
end

return PushMeteoriteDestroyCityMessage
