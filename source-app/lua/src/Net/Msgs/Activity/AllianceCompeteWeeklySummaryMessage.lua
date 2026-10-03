local AllianceCompeteWeeklySummaryMessage = BaseClass("AllianceCompeteWeeklySummaryMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode then
    return
  end
  DataCenter.AllianceCompeteDataManager:RefreshWeeklySummaryMsg(message)
end

AllianceCompeteWeeklySummaryMessage.OnCreate = OnCreate
AllianceCompeteWeeklySummaryMessage.HandleMessage = HandleMessage
return AllianceCompeteWeeklySummaryMessage
