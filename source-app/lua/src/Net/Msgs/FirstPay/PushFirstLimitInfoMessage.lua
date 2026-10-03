local PushFirstLimitInfoMessage = BaseClass("PushFirstLimitInfoMessage", SFSBaseMessage)
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
  elseif message.limit_time_gift ~= nil then
    DataCenter.FirstPayManager:UpdateData(message.limit_time_gift)
  end
end

PushFirstLimitInfoMessage.OnCreate = OnCreate
PushFirstLimitInfoMessage.HandleMessage = HandleMessage
return PushFirstLimitInfoMessage
