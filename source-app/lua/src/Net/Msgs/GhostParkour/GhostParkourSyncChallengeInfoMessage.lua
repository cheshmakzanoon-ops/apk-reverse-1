local GhostParkourSyncChallengeInfoMessage = BaseClass("GhostParkourSyncChallengeInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GhostParkourSyncChallengeInfoMessage:OnCreate(uuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
end

function GhostParkourSyncChallengeInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    DataCenter.LWBattleManager:ShowTipsId(errCode)
  else
    Logger.Log("\228\184\138\228\188\160\230\136\144\229\138\159!")
    local uuid = t.uuid
    EventManager:GetInstance():Broadcast(EventId.GhostParkourOnFileUploadSynced, uuid)
  end
end

return GhostParkourSyncChallengeInfoMessage
