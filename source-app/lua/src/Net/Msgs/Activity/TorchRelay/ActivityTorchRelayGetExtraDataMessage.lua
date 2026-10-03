local ActivityTorchRelayGetExtraDataMessage = BaseClass("ActivityTorchRelayGetExtraDataMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", tonumber(param.activityId))
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActivityTorchRelayManager:OnGetExtraDataCallback(t)
  end
end

ActivityTorchRelayGetExtraDataMessage.OnCreate = OnCreate
ActivityTorchRelayGetExtraDataMessage.HandleMessage = HandleMessage
return ActivityTorchRelayGetExtraDataMessage
