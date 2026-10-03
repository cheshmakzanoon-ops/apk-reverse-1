local AllianceTrainInviteListMessage = BaseClass("AllianceTrainInviteListMessage", SFSBaseMessage)
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
  EventManager:GetInstance():Broadcast(EventId.AllianceTrainInviteList, message.list)
end

AllianceTrainInviteListMessage.OnCreate = OnCreate
AllianceTrainInviteListMessage.HandleMessage = HandleMessage
return AllianceTrainInviteListMessage
