local AllianceTrainAssignMessage = BaseClass("AllianceTrainAssignMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, playerUid)
  base.OnCreate(self)
  self.sfsObj:PutInt("trainPlatformId", 1)
  self.sfsObj:PutUtfString("targetUserId", playerUid)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  EventManager:GetInstance():Broadcast(EventId.AllianceTrainAssignMessageSuccess)
end

AllianceTrainAssignMessage.OnCreate = OnCreate
AllianceTrainAssignMessage.HandleMessage = HandleMessage
return AllianceTrainAssignMessage
