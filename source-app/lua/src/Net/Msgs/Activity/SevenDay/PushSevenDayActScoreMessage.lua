local PushSevenDayActScoreMessage = BaseClass("PushSevenDayActScoreMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, activityId)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActSevenDayData:UpdateDayActScore(t)
  end
end

PushSevenDayActScoreMessage.OnCreate = OnCreate
PushSevenDayActScoreMessage.HandleMessage = HandleMessage
return PushSevenDayActScoreMessage
