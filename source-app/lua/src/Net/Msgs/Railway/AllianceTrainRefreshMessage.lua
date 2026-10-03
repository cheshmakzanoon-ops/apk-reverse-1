local AllianceTrainRefreshMessage = BaseClass("AllianceTrainRefreshMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self.sfsObj:PutInt("trainPlatformId", 1)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  EventManager:GetInstance():Broadcast(EventId.AllianceTrainRefreshCallback)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  if message.remainFreeCount then
    DataCenter.LWAllyStationDataManager:UpdateFreeRefreshTimes(message.remainFreeCount)
  end
  EventManager:GetInstance():Broadcast(EventId.AllianceTrainRefreshMessageSuccess, message.count)
end

AllianceTrainRefreshMessage.OnCreate = OnCreate
AllianceTrainRefreshMessage.HandleMessage = HandleMessage
return AllianceTrainRefreshMessage
