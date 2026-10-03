local PushMultiWeekCardInfoChangeMessage = BaseClass("PushMultiWeekCardInfoChangeMessage", SFSBaseMessage)
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
    DataCenter.WeekCardManager:UpdateWeekCardList(t)
  end
end

PushMultiWeekCardInfoChangeMessage.OnCreate = OnCreate
PushMultiWeekCardInfoChangeMessage.HandleMessage = HandleMessage
return PushMultiWeekCardInfoChangeMessage
