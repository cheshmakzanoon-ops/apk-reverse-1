local ActivityTorchRelayGrowUpMessage = BaseClass("ActivityTorchRelayGrowUpMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", tonumber(param.activityId))
  self.sfsObj:PutInt("attType", tonumber(param.type))
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActivityTorchRelayManager:OnGrowUpCallback(t)
  end
end

ActivityTorchRelayGrowUpMessage.OnCreate = OnCreate
ActivityTorchRelayGrowUpMessage.HandleMessage = HandleMessage
return ActivityTorchRelayGrowUpMessage
