local PushTrendsRedNumMessage = BaseClass("PushTrendsRedNumMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, id)
  base.OnCreate(self)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.WorldTrendManager:SetWorldTrendRedNum(message)
  end
end

PushTrendsRedNumMessage.OnCreate = OnCreate
PushTrendsRedNumMessage.HandleMessage = HandleMessage
return PushTrendsRedNumMessage
