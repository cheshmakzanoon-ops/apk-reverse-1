local AllianceNoticePinnedUpdateMessage = BaseClass("AllianceNoticePinnedUpdateMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uuid, pinned)
  base.OnCreate(self)
  if uuid then
    self.sfsObj:PutUtfString("uuid", tostring(uuid))
  end
  if pinned then
    self.sfsObj:PutInt("pinned", tostring(pinned))
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.AllianceNoticeManager:UpdateNoticePinned(t)
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_ALLIANCE_NOTICEDATA_UPDATE, {
    uuid = t.uuid,
    isSkipRefreshTmpShow = true
  })
end

AllianceNoticePinnedUpdateMessage.OnCreate = OnCreate
AllianceNoticePinnedUpdateMessage.HandleMessage = HandleMessage
return AllianceNoticePinnedUpdateMessage
