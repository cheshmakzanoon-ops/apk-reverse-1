local DecoratorProgressUpgradeMessage = BaseClass("DecoratorProgressUpgradeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function DecoratorProgressUpgradeMessage:OnCreate(buildUuid, num)
  base.OnCreate(self)
  self.sfsObj:PutLong("buildUuid", buildUuid)
  self.sfsObj:PutInt("num", num)
end

function DecoratorProgressUpgradeMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.BuildManager:HandleDecorationUpgradeMessage(t)
  end
  EventManager:GetInstance():Broadcast(EventId.DecoratorProgressUpgradeMessageOnReceive)
end

return DecoratorProgressUpgradeMessage
