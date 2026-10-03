local VipGetRewardInfoMessage = BaseClass("VipGetRewardInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif message.boxRewardArr ~= nil then
    DataCenter.VIPManager:UpdateVipBoxRewardInfo(message.boxRewardArr)
  end
end

VipGetRewardInfoMessage.OnCreate = OnCreate
VipGetRewardInfoMessage.HandleMessage = HandleMessage
return VipGetRewardInfoMessage
