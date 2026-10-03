local VipAddLoginScoreMessage = BaseClass("VipAddLoginScoreMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.VIPManager:UpdateVipInfo(message, true)
  end
end

VipAddLoginScoreMessage.OnCreate = OnCreate
VipAddLoginScoreMessage.HandleMessage = HandleMessage
return VipAddLoginScoreMessage
