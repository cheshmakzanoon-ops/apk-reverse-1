local ActivityTorchRelayServerCheckMessage = BaseClass("ActivityTorchRelayServerCheckMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", tonumber(param.activityId))
  self.sfsObj:PutUtfString("content", param.contentStr)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActivityTorchRelayManager:OnInGameServerCheckCallback(t)
  end
end

ActivityTorchRelayServerCheckMessage.OnCreate = OnCreate
ActivityTorchRelayServerCheckMessage.HandleMessage = HandleMessage
return ActivityTorchRelayServerCheckMessage
