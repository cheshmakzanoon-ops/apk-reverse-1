local base = UIBaseContainer
local UIChatViewReplyArea_v2 = BaseClass("UIChatViewReplyArea_v2", base)
local compBook = {
  {
    path = "board/txtReplyH",
    name = "txtReplyH",
    type = UIText
  },
  {
    path = "board/btnClose",
    name = "btnClose",
    type = UIButton,
    onClick = function(self)
      self:OnClickClose()
    end
  }
}

function UIChatViewReplyArea_v2:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIChatViewReplyArea_v2:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIChatViewReplyArea_v2:ComponentDefine()
  self:DefineCompsByBook(compBook)
  local dlgComponent = ChatInterface.isTestingServer() and UITextMeshProUGUIEx or UIText
  self.txtReply = self:AddComponent(dlgComponent, "board/txtReply")
  if ChatInterface.isTestingServer() then
    ChatInterface.SetEmojiTextProperty(self.txtReply)
  end
end

function UIChatViewReplyArea_v2:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function UIChatViewReplyArea_v2:SetReply(chatMsg)
  if not chatMsg then
    return
  end
  local sender = ChatInterface.getUserData(chatMsg.senderUid)
  if not sender then
    return
  end
  local text = sender.userName .. ": " .. ChatManager2:GetReplyMsgByChatMsg(chatMsg)
  self.txtReply:SetText(text)
end

function UIChatViewReplyArea_v2:GetReplyMsgHeight(chatMsg)
  if not chatMsg then
    return 100
  end
  local sender = ChatInterface.getUserData(chatMsg.senderUid)
  if not sender then
    return 100
  end
  local text = sender.userName .. ": " .. ChatManager2:GetReplyMsgByChatMsg(chatMsg)
  self.txtReplyH:SetText(text)
  self.txtReplyH:SetActive(false)
  self.txtReplyH:SetActive(true)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.txtReplyH.rectTransform)
  return self.txtReplyH.rectTransform.rect.height
end

function UIChatViewReplyArea_v2:OnClickClose()
  EventManager:GetInstance():Broadcast(EventId.SetReplyChatMsg, nil)
end

return UIChatViewReplyArea_v2
