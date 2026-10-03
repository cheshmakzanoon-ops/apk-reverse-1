local UILWChatUnreadJumpTip = BaseClass("UILWChatUnreadJumpTip", UIBaseContainer)
local base = UIBaseContainer
local root_path = "Root"
local text_path = "Root/Text"

function UILWChatUnreadJumpTip:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UILWChatUnreadJumpTip:OnDestroy()
  self.unreadJumpRoomId = nil
  self.unreadJumpSeqId = nil
  base.OnDestroy(self)
end

function UILWChatUnreadJumpTip:ComponentDefine()
  self.root = self:AddComponent(UIBaseComponent, root_path)
  self.textUnread = self:AddComponent(UIText, text_path)
  self.clickBtn = self:AddComponent(UIButton, root_path)
  self.clickBtn:SetOnClick(function()
    self:OnClick()
  end)
  self.unreadJumpRoomId = nil
  self.unreadJumpSeqId = nil
end

function UILWChatUnreadJumpTip:InitView(roomId, seqId, count, tipType)
  self.unreadJumpRoomId = roomId
  self.unreadJumpSeqId = seqId
  self.tipType = tipType
  self.count = count
  local strCount = tostring(count)
  if 999 < count then
    strCount = "999+"
  end
  if tipType == ChatTipType.At then
    self.textUnread:SetLocalText("at_notice_chatroom")
  else
    self.textUnread:SetText(CS.GameEntry.Localization:GetString("last_msg_btn", strCount))
  end
  local preferredValues = self.textUnread.unity_tmpro:GetPreferredValues()
  self.textUnread.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Horizontal, preferredValues.x)
end

function UILWChatUnreadJumpTip:OnClick()
  if self.tipType == ChatTipType.At then
    self:OnClickAtMessage()
  else
    self:OnClickUnReadMessage()
  end
end

function UILWChatUnreadJumpTip:OnClickUnReadMessage()
  ChatManager2:GetInstance().Room:JumpMsgPullLast(self.unreadJumpRoomId, self.unreadJumpSeqId)
  self:SetActive(false)
end

function UILWChatUnreadJumpTip:OnClickAtMessage()
  ChatManager2:GetInstance().Room:ClearJumpMsgRoom()
  ChatManager2:GetInstance().Room:JumpMsgPullLast(self.unreadJumpRoomId, self.unreadJumpSeqId)
  local room = ChatManager2:GetInstance().Room:GetRoomData(self.unreadJumpRoomId)
  local lastSeqId = room:GetAtSeqId()
  room:ClearAtSeqId()
  local seqId = room:GetAtSeqId()
  if seqId then
    self:InitView(self.unreadJumpRoomId, seqId, self.count, ChatTipType.At)
  elseif not seqId and lastSeqId and self.count > 0 and lastSeqId > self.count then
    self:InitView(self.unreadJumpRoomId, self.count, lastSeqId - self.count, ChatTipType.Unread)
  else
    self:SetActive(false)
  end
end

return UILWChatUnreadJumpTip
