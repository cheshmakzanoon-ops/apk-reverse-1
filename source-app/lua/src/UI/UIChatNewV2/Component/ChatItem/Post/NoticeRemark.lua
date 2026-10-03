local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local ChatItemPost_NoticeRemark = BaseClass("ChatItemPost_NoticeRemark", IChatItemPost)
local base = IChatItemPost
local bubble_bg = "Bg"
local bubble_default_path = "Bg/BubbleDefault"
local bubble_special_path = "Bg/BubbleSpecial"
local reply_path = "ReplyText"
local dialog_path = "DialogText"
local emoji_go_path = "Emoji"
local emoji_image_path = "Emoji/EmojiImg"
local vertical_path = ""
local remarkTime = "RemarkTimeText"
local LayoutRebuilder = CS.UnityEngine.UI.LayoutRebuilder
local Localization = CS.GameEntry.Localization

function ChatItemPost_NoticeRemark:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatItemPost_NoticeRemark:ComponentDefine()
  self._root = self:AddComponent(UIBaseContainer, "")
  self._bubbleBg = self:AddComponent(UIBaseContainer, bubble_bg)
  self._defaultBubbleImg = self:AddComponent(UIImage, bubble_default_path)
  self._specialBubbleImg = self:AddComponent(UIImage, bubble_special_path)
  self._replyTxt = self:AddComponent(UITextMeshProUGUIEx, reply_path)
  self._dialogTxt = self:AddComponent(UITextMeshProUGUIEx, dialog_path)
  self._emojiGo = self:AddComponent(UIBaseContainer, emoji_go_path)
  self._emojiImg = self:AddComponent(UIImage, emoji_image_path)
  self._container = self._root
  self:ChangeBubble(nil, nil)
  ChatInterface.SetEmojiTextProperty(self._replyTxt)
  ChatInterface.SetEmojiTextProperty(self._dialogTxt)
end

function ChatItemPost_NoticeRemark:ChangeBubble(bubbleId, bubbleET)
  local bubbleRes, msgColor, replyColor = DataCenter.DecorationDataManager:GetChatBubbleAndMsgColor(bubbleId, bubbleET)
  local chatData = self:ChatData()
  if not chatData then
    return
  end
  if bubbleRes and msgColor and replyColor then
    self._defaultBubbleImg:SetActive(false)
    self._specialBubbleImg:SetActive(true)
    if bubbleId == ChatDefaultBubbleId and chatData:isMyChat() then
      local color = ChatUIThemeConfig.TextColor[ChatInterface.GetChatTheme()]
      replyColor = ChatUIThemeConfig.TextReplyColor[ChatInterface.GetChatTheme()]
      self._dialogTxt:SetColor(color)
      self._replyTxt:SetColor(replyColor)
      self._specialBubbleImg:LoadSprite(ChatInterface.GetChatUIPath("ChatItems/sj_liaotian_bubble_1b.png"))
    else
      self._specialBubbleImg:LoadSprite(bubbleRes)
      self._specialBubbleImg:SetAlpha(ChatUIThemeConfig.ChatAlpha[ChatInterface.GetChatTheme()])
      self._dialogTxt:SetColor(msgColor)
      self._replyTxt:SetColor(replyColor)
    end
    if self.frame and self.frame._traText then
      self.frame._traText:SetColor(msgColor)
      self.frame._dividingLine:SetColor(Color.New(msgColor.r, msgColor.g, msgColor.b, 0.5))
    end
  else
    self._defaultBubbleImg:SetActive(true)
    if chatData:isMyChat() then
      replyColor = ChatUIThemeConfig.TextReplyColor[ChatInterface.GetChatTheme()]
      self._defaultBubbleImg:LoadSprite(ChatInterface.GetChatUIPath("ChatItems/sj_liaotian_bubble_1b.png"))
    else
      replyColor = ChatUIThemeConfig.TextReplyColor2[ChatInterface.GetChatTheme()]
      self._defaultBubbleImg:LoadSprite(ChatInterface.GetChatUIPath("ChatItems/sj_liaotian_bubble_1.png"))
    end
    self._specialBubbleImg:SetActive(false)
    local color = ChatUIThemeConfig.TextColor[ChatInterface.GetChatTheme()]
    self._dialogTxt:SetColor(color)
    self._replyTxt:SetColor(replyColor)
    if self.frame and self.frame._traText then
      self.frame._traText:SetColor(color)
      self.frame._dividingLine:SetColor(Color.New(color.r, color.g, color.b, 0.5))
    end
  end
end

function ChatItemPost_NoticeRemark:UpdateUserInfoWithNew()
  if self.frame and self.frame._userInfo then
    self:ChangeBubble(self.frame._userInfo.chatBubbleId, self.frame._userInfo.chatBubbleET)
  end
end

function ChatItemPost_NoticeRemark:OnLoaded()
  local chatdata = self:ChatData()
  if chatdata == nil then
    return
  end
  self._chatData = chatdata
  self._emojiGo:SetActive(false)
  self._dialogTxt:SetActive(false)
  self._replyTxt:SetActive(false)
  local emoji = self:GetEmojiData()
  if emoji then
    self:UpdateEmoji()
  else
    self:UpdateDialog()
  end
  self:UpdateReply()
  self:UpdateLayout()
end

function ChatItemPost_NoticeRemark:UpdateDialog()
  local dialog = self:GetDialogData()
  if dialog == nil then
    self._dialogTxt:SetActive(false)
    return
  end
  self._dialogTxt:SetActive(true)
  self._dialogTxt:SetText(dialog)
end

function ChatItemPost_NoticeRemark:GetDialogData()
  if not self._chatData then
    return
  end
  local message = self._chatData:getSuperParsedResult()
  if message == nil then
    message = self._chatData:getMessageWithExtra(false)
    self._chatData:setSuperParsedResult(message)
  end
  return message
end

function ChatItemPost_NoticeRemark:UpdateReply()
  local reply = self:GetReplyData()
  if reply == nil then
    self._replyTxt:SetActive(false)
    return
  end
  self._replyTxt:SetActive(true)
  self._replyTxt:SetText(reply)
end

function ChatItemPost_NoticeRemark:GetReplyData()
  if not self._chatData then
    return
  end
  local replyMsg = self._chatData.replyMsg
  if not replyMsg then
    return
  end
  local sender = ChatInterface.getUserData(replyMsg.uid)
  local senerName = sender and sender.userName or replyMsg.userName
  return string.format("%s %s: %s", Localization:GetString("2900032"), senerName, replyMsg.msg)
end

function ChatItemPost_NoticeRemark:UpdateEmoji()
  local emoji = self:GetEmojiData()
  if emoji == nil then
    self._emojiGo:SetActive(false)
  end
  self._emojiGo:SetActive(true)
  self._emojiImg:LoadSprite(emoji)
end

function ChatItemPost_NoticeRemark:GetEmojiData()
  if not self._chatData or not self._chatData:IsLWEmoji() then
    return
  end
  local rawStr = self._chatData.msg
  return self:GetEmojiId(rawStr)
end

function ChatItemPost_NoticeRemark:GetEmojiId(rawStr)
  if not rawStr then
    return
  end
  local spl = string.split(rawStr, ":")
  if #spl ~= 3 then
    return
  end
  local lineData = LocalController:instance():getLine(TableName.LW_EMOJI, spl[2])
  if not lineData then
    return
  end
  if lineData.sort < 1 then
    return
  end
  return "Assets/Main/Sprites/UI/LWChatEmoji/Default/" .. tostring(lineData.path) .. ".png"
end

function ChatItemPost_NoticeRemark:UpdateLayout()
  local maxWidth = self.frame:GetChatItemMaxWidth() - 50
  local reply = self:GetReplyData()
  if reply then
    local preferredValues = self._replyTxt.unity_tmpro:GetPreferredValues(maxWidth, 0)
    if maxWidth < preferredValues.x then
      self._replyTxt.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Horizontal, maxWidth)
    else
      self._replyTxt.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Horizontal, preferredValues.x)
    end
  end
  local dialog = self:GetDialogData()
  if dialog then
    local preferredValues = self._dialogTxt.unity_tmpro:GetPreferredValues(maxWidth, 0)
    if maxWidth < preferredValues.x then
      self._dialogTxt.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Horizontal, maxWidth)
    else
      self._dialogTxt.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Horizontal, preferredValues.x)
    end
    self._dialogTxt.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Vertical, preferredValues.y)
  end
  local emoji = self:GetEmojiData()
  if emoji then
    self._emojiGo:SetSizeDelta(Vector2.New(65, 65))
  end
  local pos = self._replyTxt:GetAnchoredPosition()
  if reply then
    pos.y = pos.y - self._replyTxt:GetSizeDelta().y
  end
  pos.x = 30
  self._dialogTxt:SetAnchoredPosition(pos)
  self._emojiGo:SetAnchoredPosition(pos)
end

function ChatItemPost_NoticeRemark:OnRecycle()
end

return ChatItemPost_NoticeRemark
