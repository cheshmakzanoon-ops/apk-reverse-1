local UIChatReplyMsgView = BaseClass("UIChatReplyMsgView", UIBaseContainer)
local base = UIBaseContainer
local compBook = {
  {
    path = "txtReply",
    name = "txtReply",
    type = UIText
  },
  {
    path = "txtReplyH",
    name = "txtReplyH",
    type = UIText
  },
  {
    path = "btnClose",
    name = "btnClose",
    type = UIButton,
    onClick = function(self)
      EventManager:GetInstance():Broadcast(EventId.SetReplyChatMsg, nil)
    end
  }
}

function UIChatReplyMsgView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIChatReplyMsgView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIChatReplyMsgView:ComponentDefine()
  self:DefineCompsByBook(compBook)
end

function UIChatReplyMsgView:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function UIChatReplyMsgView:SetReply(chatData)
  if not chatData then
    return
  end
  local sender = ChatInterface.getUserData(chatData.senderUid)
  if not sender then
    return
  end
  local text = sender.userName .. ": " .. chatData.msg
  self.txtReply:SetText(text)
end

function UIChatReplyMsgView:GetReplyMsgHeight(chatData)
  if not chatData then
    return 100
  end
  local sender = ChatInterface.getUserData(chatData.senderUid)
  if not sender then
    return 100
  end
  local text = sender.userName .. ": " .. chatData.msg
  self.txtReplyH:SetText(text)
  self.txtReplyH:SetActive(false)
  self.txtReplyH:SetActive(true)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.txtReplyH.rectTransform)
  return self.txtReplyH.rectTransform.rect.height
end

return UIChatReplyMsgView
