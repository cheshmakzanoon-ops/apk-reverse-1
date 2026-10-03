local GhostParkourSendRecordEmojiMessage = BaseClass("GhostParkourSendRecordEmojiMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GhostParkourSendRecordEmojiMessage:OnCreate(emojiId, ownerUuid, targetUid, targetUuid)
  base.OnCreate(self)
  self.sfsObj:PutInt("emojiId", emojiId)
  self.sfsObj:PutLong("ownerRecordUuid", ownerUuid)
  self.sfsObj:PutUtfString("targetUid", targetUid)
  self.sfsObj:PutLong("targetRecordUuid", targetUuid)
end

function GhostParkourSendRecordEmojiMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    DataCenter.LWBattleManager:ShowTipsId(errCode)
  else
    DataCenter.LWBattleManager:ShowTipsId("ghost_parkour_message_tips")
  end
end

return GhostParkourSendRecordEmojiMessage
