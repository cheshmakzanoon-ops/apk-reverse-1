local VipInfoMessage = BaseClass("VipInfoMessage", SFSBaseMessage)
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
  elseif message.vipInfo ~= nil then
    DataCenter.VIPManager:UpdateVipInfo(message.vipInfo, false)
  end
end

VipInfoMessage.OnCreate = OnCreate
VipInfoMessage.HandleMessage = HandleMessage
return VipInfoMessage
