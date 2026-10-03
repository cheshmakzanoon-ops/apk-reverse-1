local ChatItemReplyNode = BaseClass("ChatItemReplyNode", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local ContentSizeFitter = CS.UnityEngine.UI.ContentSizeFitter
local LayoutRebuilder = CS.UnityEngine.UI.LayoutRebuilder
local layoutText = "%s %s: %s"
local compBook = {
  {
    path = "txtReplyH",
    name = "txtReplyH",
    type = UIText
  },
  {
    path = "txtReplyW",
    name = "txtReplyW",
    type = UIText
  },
  {
    path = "txtReply",
    name = "layout",
    type = UILayoutElement
  }
}

function ChatItemReplyNode:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:SetActive(false)
end

function ChatItemReplyNode:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ChatItemReplyNode:ComponentDefine()
  self:DefineCompsByBook(compBook)
  local component = ChatInterface.isTestingServer() and UITextMeshProUGUIEx or UIText
  self.txtReply = self:AddComponent(component, "txtReply")
  if ChatInterface.isTestingServer() then
    ChatInterface.SetEmojiTextProperty(self.txtReply)
  end
  self.fitter = self.layout.rectTransform:GetComponent(typeof(ContentSizeFitter))
end

function ChatItemReplyNode:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function ChatItemReplyNode:GetReplyTextSize(chatData, maxWidth, width)
  if not chatData then
    return 0
  end
  local replyMsg = chatData.replyMsg
  if not replyMsg then
    return 0
  end
  local sender = ChatInterface.getUserData(replyMsg.uid)
  local senerName = sender and sender.userName or replyMsg.userName
  local text = string.format(layoutText, Localization:GetString("2900032"), senerName, replyMsg.msg)
  self.txtReplyW:SetText(text)
  LayoutRebuilder.ForceRebuildLayoutImmediate(self.txtReplyW.rectTransform)
  return Vector2.New(self.txtReplyW.rectTransform.rect.width, self.txtReplyH.rectTransform.rect.height)
end

function ChatItemReplyNode:SetReply(chatData, maxWidth, txtWidth, hight)
  if not chatData then
    return
  end
  local replyMsg = chatData.replyMsg
  if not replyMsg then
    return
  end
  local sender = ChatInterface.getUserData(replyMsg.uid)
  local senerName = sender and sender.userName or replyMsg.userName
  local text = string.format(layoutText, Localization:GetString("2900032"), senerName, replyMsg.msg)
  LayoutRebuilder.ForceRebuildLayoutImmediate(self.txtReplyW.rectTransform)
  local width = self.txtReplyW:GetWidth()
  if maxWidth < width then
    width = math.max(txtWidth, maxWidth)
  end
  self.txtReply.rectTransform.sizeDelta = Vector2.New(width, hight)
  LayoutRebuilder.ForceRebuildLayoutImmediate(self.txtReply.rectTransform)
  self.txtReply:SetText(text)
  return width
end

function ChatItemReplyNode:SetSize(width, height)
  self.layout:SetPreferredHeight(height)
  self:SetSizeDeltaXY(width, height)
end

function ChatItemReplyNode:SetReplyTextAlpha(alpha)
  self.txtReply:SetAlpha(alpha)
end

function ChatItemReplyNode:SetReplyTextColor(color)
  self.txtReply:SetColor(color)
end

return ChatItemReplyNode
