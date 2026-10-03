local PushDailyQuestMessage = BaseClass("PushDailyQuestMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  if message.dailyQuest ~= nil then
    for k, v in pairs(message.dailyQuest) do
      DataCenter.DailyTaskManager:UpdateOneDailyTaskInfo(v)
      EventManager:GetInstance():Broadcast(EventId.DailyQuestSuccess)
    end
  end
end

PushDailyQuestMessage.OnCreate = OnCreate
PushDailyQuestMessage.HandleMessage = HandleMessage
return PushDailyQuestMessage
