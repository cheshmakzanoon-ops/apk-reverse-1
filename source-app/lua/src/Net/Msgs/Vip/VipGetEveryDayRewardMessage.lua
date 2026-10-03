local VipGetEveryDayRewardMessage = BaseClass("VipGetEveryDayRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, actId)
  base.OnCreate(self)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.VIPManager:GetEveryDayRewardMessageHandle(message)
  end
end

VipGetEveryDayRewardMessage.OnCreate = OnCreate
VipGetEveryDayRewardMessage.HandleMessage = HandleMessage
return VipGetEveryDayRewardMessage
