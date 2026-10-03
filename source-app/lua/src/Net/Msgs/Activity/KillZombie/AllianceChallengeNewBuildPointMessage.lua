local AllianceChallengeNewBuildPointMessage = BaseClass("AllianceChallengeNewBuildPointMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AllianceChallengeNewBuildPointMessage:OnCreate(configId)
  base.OnCreate(self)
  self.sfsObj:PutInt("configId", configId)
end

function AllianceChallengeNewBuildPointMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message ~= nil then
    local errorCode = message.errorCode
    if errorCode ~= nil then
      UIUtil.ShowTipsId(errorCode)
    end
    EventManager:GetInstance():Broadcast(EventId.ChallengeZombieGetLaunchStationPoint, message)
  end
end

return AllianceChallengeNewBuildPointMessage
