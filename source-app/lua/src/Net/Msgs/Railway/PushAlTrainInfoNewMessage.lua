local PushAlTrainInfoNewMessage = BaseClass("PushAlTrainInfoNewMessage", SFSBaseMessage)
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
  DataCenter.LWAllyStationDataManager:PushAllyTrainAdd(message)
end

PushAlTrainInfoNewMessage.OnCreate = OnCreate
PushAlTrainInfoNewMessage.HandleMessage = HandleMessage
return PushAlTrainInfoNewMessage
