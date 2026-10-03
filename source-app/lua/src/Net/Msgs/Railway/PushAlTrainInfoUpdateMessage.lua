local PushAlTrainInfoUpdateMessage = BaseClass("PushAlTrainInfoUpdateMessage", SFSBaseMessage)
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
  DataCenter.LWAllyStationDataManager:PushAllyTrainRefresh(message)
end

PushAlTrainInfoUpdateMessage.OnCreate = OnCreate
PushAlTrainInfoUpdateMessage.HandleMessage = HandleMessage
return PushAlTrainInfoUpdateMessage
