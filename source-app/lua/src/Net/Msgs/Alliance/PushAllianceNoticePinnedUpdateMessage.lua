local PushAllianceNoticePinnedUpdateMessage = BaseClass("PushAllianceNoticePinnedUpdateMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllianceNoticeManager:UpdateNoticePinned(t)
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_ALLIANCE_NOTICEDATA_UPDATE, {
      uuid = t.uuid,
      isSkipRefreshTmpShow = true
    })
  end
end

PushAllianceNoticePinnedUpdateMessage.OnCreate = OnCreate
PushAllianceNoticePinnedUpdateMessage.HandleMessage = HandleMessage
return PushAllianceNoticePinnedUpdateMessage
