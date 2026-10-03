local IChatItem = require("UI.UIChatNew.Component.ChatItem.IChatItem")
local ChatItemHelpStopFire = BaseClass("ChatItemHelpStopFire", IChatItem)
local ChatHead = require("UI.UIChatNew.Component.ChatHead")
local ChatUserName = require("UI.UIChatNew.Component.ChatItem.ChatUserName")
local base = IChatItem
local _cp_anchorTransform = "ChatAnchor"
local _cp_chatShareNode = "ChatAnchor/ChatShareNode"
local _cp_chatUserName = "ChatNameLayout"
local _cp_chatShareTitle = "ChatAnchor/ChatShareNode/Image/ShareTitle"
local _cp_chatShareSubTitle = "ChatAnchor/ChatShareNode/Image/SubTitle"
local _cp_chatShareMsg = "ChatAnchor/ChatShareNode/ShareIconNode/ShareMsg/ShareMsg"
local _cp_chatShareMsgNode = "ChatAnchor/ChatShareNode/ShareIconNode/ShareMsg"

function ChatItemHelpStopFire:ComponentDefine()
  self._rectTransform = self.rectTransform
  self._anchorTransform = self.transform:Find(_cp_anchorTransform):GetComponent(typeof(CS.UnityEngine.RectTransform))
  self._chatHead = self:AddComponent(ChatHead, "ChatHead")
  self._chatUserName = self:AddComponent(ChatUserName, _cp_chatUserName)
  self._chatShareNode = self:AddComponent(UIButton, _cp_chatShareNode)
  self._chatShareTitle = self:AddComponent(UIText, _cp_chatShareTitle)
  self._chatShareSubTitle = self:AddComponent(UIText, _cp_chatShareSubTitle)
  self._chatShareMsg = self:AddComponent(UITextMeshProUGUIEx, _cp_chatShareMsg)
  self._chatShareMsgNode = self:AddComponent(UIBaseContainer, _cp_chatShareMsgNode)
  self._chatShareNode:SetOnClick(BindCallback(self, self.ExecuteChatEvent))
end

function ChatItemHelpStopFire:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatItemHelpStopFire:UpdateItem(chatData, index)
  base.UpdateItem(self, chatData, index)
  self._chatData = chatData
  self.seqId = chatData:getSeqId()
  self._userInfo = ChatManager2:GetInstance().User:getChatUserInfo(self._chatData.senderUid, true)
  self:RefreshView()
end

function ChatItemHelpStopFire:RefreshView()
  local message = self._chatData:getMessageWithExtra(true)
  message = string.gsub(message, "[(]", "<u>(")
  message = string.gsub(message, "[)]", ")</u>")
  self._chatShareMsg:SetAlignment(CS.TMPro.TextAlignmentOptions.TopLeft)
  self._chatShareMsg:SetText(message)
  self._chatShareTitle:SetLocalText("outfire_msg_tittle")
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self._chatShareMsgNode.rectTransform)
  if self._chatShareMsg and self._chatShareMsg.rectTransform then
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self._chatShareMsg.rectTransform)
    local height = self._chatShareMsg:GetHeight()
    height = height or 50
    self:SetSize(Vector2.New(500, height + 110))
  end
end

function ChatItemHelpStopFire:SetSize(_size)
  local rect_sizeDelta_cx, _ = self._rectTransform:Get_sizeDelta()
  self._rectTransform:Set_sizeDelta(rect_sizeDelta_cx, Mathf.Ceil(_size.y))
  self._chatShareNode.rectTransform:Set_sizeDelta(_size.x, _size.y - 20)
  self._anchorTransform:Set_sizeDelta(Mathf.Ceil(_size.x), _size.y)
  self:SetTransPosY(self._anchorTransform, 0)
  self:SetTransPosY(self._chatShareNode.rectTransform, -37, 2)
end

function ChatItemHelpStopFire:ExecuteChatEvent()
  if not self:CheckTopViewSlideStateWhenClick() then
    return
  end
  if self.isInDrag == true then
    return
  end
  if self._chatData.post == 43 or self._chatData.msg == "90800159" or self._chatData.msg == "90800185" then
    return
  end
  if self._chatData.post > 0 then
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_SHARE_EXECUTE_CMD, self._chatData)
  else
    self:ShowTips()
  end
end

return ChatItemHelpStopFire
