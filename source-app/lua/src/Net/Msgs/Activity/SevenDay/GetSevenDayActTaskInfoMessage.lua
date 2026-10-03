local GetSevenDayActTaskInfoMessage = BaseClass("GetSevenDayActTaskInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    local errorCode = t.errorCode
    if errorCode ~= SeverErrorCode then
      UIUtil.ShowTips(Localization:GetString(t.errorCode))
    end
  else
    DataCenter.ActDoomCommanderDataManager:ParseServerData(t)
  end
end

GetSevenDayActTaskInfoMessage.OnCreate = OnCreate
GetSevenDayActTaskInfoMessage.HandleMessage = HandleMessage
return GetSevenDayActTaskInfoMessage
