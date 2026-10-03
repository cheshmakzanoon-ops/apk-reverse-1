local InvasionBossUserMarchRecordMessage = BaseClass("InvasionBossUserMarchRecordMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uid)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("uid", tostring(uid))
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    EventManager:GetInstance():Broadcast(EventId.OnOtherArmyInfoRefresh, t)
  end
end

InvasionBossUserMarchRecordMessage.OnCreate = OnCreate
InvasionBossUserMarchRecordMessage.HandleMessage = HandleMessage
return InvasionBossUserMarchRecordMessage
