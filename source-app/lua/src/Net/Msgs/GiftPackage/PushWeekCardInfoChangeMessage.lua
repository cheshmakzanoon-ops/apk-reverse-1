local PushWeekCardInfoChangeMessage = BaseClass("PushWeekCardInfoChangeMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.WeekCardManager:UpdateOneWeekCard(t)
  end
end

PushWeekCardInfoChangeMessage.OnCreate = OnCreate
PushWeekCardInfoChangeMessage.HandleMessage = HandleMessage
return PushWeekCardInfoChangeMessage
