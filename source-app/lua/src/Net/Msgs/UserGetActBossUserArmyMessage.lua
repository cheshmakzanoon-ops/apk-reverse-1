local UserGetActBossUserArmyMessage = BaseClass("UserGetActBossUserArmyMessage", SFSBaseMessage)
local base = SFSBaseMessage

function UserGetActBossUserArmyMessage:OnCreate(uid)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("uid", tostring(uid))
end

function UserGetActBossUserArmyMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(t.errorCode))
  else
    EventManager:GetInstance():Broadcast(EventId.OnActBossArmyInfoRefresh, t)
  end
end

return UserGetActBossUserArmyMessage
