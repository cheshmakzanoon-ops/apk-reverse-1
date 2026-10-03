local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local base = IChatItemPost
local EasterEggComment = BaseClass("EasterEggComment", base)
local M = EasterEggComment
local myChatDefaultBubblePath = "Assets/Main/Sprites/UI/UIDecoration/UIDecoration/sj_liaotian_bubble_1b.png"
local bubble_bg = "Bg"
local bubble_default_path = "Bg/BubbleDefault"
local bubble_special_path = "Bg/BubbleSpecial"
local reply_path = "ReplyText"
local dialog_path = "DialogText"
local emoji_go_path = "Emoji"
local emoji_image_path = "Emoji/EmojiImg"
local more_btn_path = "MoreBtn"
local more_btn_txt_path = "MoreBtn/MoreBtnText"
local LayoutRebuilder = CS.UnityEngine.UI.LayoutRebuilder
local Localization = CS.GameEntry.Localization
local HasFoldPadding = Vector2(40, 60)
local NormalPadding = Vector2(40, 30)

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function M:ComponentDefine()
  self._root = self:AddComponent(UIBaseContainer, "")
  self._bubbleBg = self:AddComponent(UIBaseContainer, bubble_bg)
  self._defaultBubbleImg = self:AddComponent(UIImage, bubble_default_path)
  self._specialBubbleImg = self:AddComponent(UIImage, bubble_special_path)
  self._replyTxt = self:AddComponent(UITextMeshProUGUIEx, reply_path)
  self._dialogTxt = self:AddComponent(UITextMeshProUGUIEx, dialog_path)
  self._emojiGo = self:AddComponent(UIBaseContainer, emoji_go_path)
  self._emojiImg = self:AddComponent(UIImage, emoji_image_path)
  self._replyClicker = self:AddComponent(UIEventTrigger, reply_path)
  self._moreBtn = self:AddComponent(UIButton, more_btn_path)
  self._moreBtnText = self:AddComponent(UIText, more_btn_txt_path)
  self._moreBtnText:SetColor(ChatUIThemeConfig.MoreBtnColor[ChatUIThemeConfig.ChatMode.Normal])
  self._moreBtn:SetOnClick(function()
    self:OnFoldClick()
  end)
  self.compNo1Flag = self:AddComponent(UIBaseContainer, "Bg/No1Flag")
  self.isTextFolding = true
  local lastClickTime
  self._replyClicker:OnPointerDown(function(eventData)
    lastClickTime = SafeLocalOsTime()
    self.clickReply = false
  end)
  self._replyClicker:OnPointerUp(function(eventData)
    if lastClickTime and SafeLocalOsTime() - lastClickTime < 2 then
      self.clickReply = true
    end
  end)
  self._container = self._root
  ChatInterface.SetEmojiTextProperty(self._replyTxt)
  ChatInterface.SetEmojiTextProperty(self._dialogTxt)
end

function M:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.CHAT_ON_TRANSLATION_FINISH, self.OnTranslationFinish)
end

function M:OnRemoveListener()
  self:RemoveUIListener(EventId.CHAT_ON_TRANSLATION_FINISH, self.OnTranslationFinish)
  base.OnRemoveListener(self)
end

function M:OnTranslationFinish(chatData)
  if chatData == nil then
    return
  end
  if self._chatData == nil then
    return
  end
  if chatData.seqId ~= self._chatData.seqId then
    return
  end
  self:OnFoldClick()
end

function M:OnFoldClick()
  self.isTextFolding = not self.isTextFolding
  self._chatData.isTextFolding = self.isTextFolding
  self:UpdateLayout()
  self:TryFoldText()
  self:UpdateTextFoldState()
  self:UpdateSize()
end

function M:OnLoaded()
  local chatdata = self:ChatData()
  if chatdata == nil then
    return
  end
  self._chatData = chatdata
  if self._chatData.isTextFolding == nil then
    self._chatData.isTextFolding = true
  end
  self.isTextFolding = self._chatData.isTextFolding
  self.emoji = self:GetEmojiData()
  if self.emoji then
    self:UpdateEmoji(self.emoji)
    self._dialogTxt:SetActive(false)
  elseif self:CheckUpdateSingleEmoji() then
    self:UpdateEmoji(self.emoji)
    self._dialogTxt:SetActive(false)
  else
    self:UpdateDialog()
    self._emojiGo:SetActive(false)
  end
  self.compNo1Flag:SetActive(self._chatData:getSeqId() == 1)
  self:ChangeBubble()
  self:UpdateReply()
  self:UpdateLayout()
  self:TryFoldText()
  self:UpdateTextFoldState()
end

function M:CheckUpdateSingleEmoji()
  local isNewSingleEmoji = false
  local dialog = self:GetDialogData()
  local str = ChatInterface.GetOldEmojiStr(dialog)
  if not string.IsNullOrEmpty(str) then
    self.emoji = self:GetEmojiId(str)
    if self.emoji then
      isNewSingleEmoji = true
    end
  end
  return isNewSingleEmoji
end

function M:UpdateDialog()
  local dialog = self:GetDialogData()
  if dialog == nil then
    self._dialogTxt:SetActive(false)
    return
  end
  self._dialogTxt:SetActive(true)
  self._dialogTxt:SetFontSize(32)
  self._dialogTxt:SetText_NotNative(dialog)
end

function M:GetDialogData()
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

function M:UpdateReply()
  local reply = self:GetReplyData()
  if reply == nil then
    self._replyTxt:SetActive(false)
    return
  end
  self._replyTxt:SetActive(true)
  self._replyTxt:SetText_NotNative(reply)
end

function M:GetReplyData()
  if not self._chatData then
    return
  end
  local replyMsg = self._chatData.replyMsg
  if not replyMsg then
    return
  end
  local senderName = ""
  local replySender = ChatInterface.getUserData(replyMsg.uid)
  local isAnonymous = replyMsg.isAnonymous
  if isAnonymous then
    if replySender and replySender.curlAnonymousHead then
      local lastestAnonymousHead = replySender.curAnonymousHead
      local curAnonymousInfo = string.split(lastestAnonymousHead, ";")
      senderName = DataCenter.ActEasterEggManager:GetTranslateName(curAnonymousInfo[1])
    else
      senderName = DataCenter.ActEasterEggManager:GetTranslateName(replyMsg.userName)
    end
  else
    senderName = replySender and replySender.userName or replyMsg.userName
  end
  return string.format("%s %s: %s", Localization:GetString("2900032"), senderName, replyMsg.msg)
end

function M:UpdateEmoji(emoji)
  if emoji == nil then
    self._emojiGo:SetActive(false)
    return
  end
  self._emojiGo:SetActive(true)
  self._emojiImg:LoadSprite(emoji)
end

function M:GetEmojiData()
  if not self._chatData or not self._chatData:IsLWEmoji() then
    return
  end
  local rawStr = self._chatData.msg
  return self:GetEmojiId(rawStr)
end

function M:GetEmojiId(rawStr)
  if not rawStr then
    return
  end
  local spl = string.split(rawStr, ":")
  if #spl ~= 3 then
    return
  end
  local lineData = LocalController:instance():tryGetLine(TableName.LW_EMOJI, spl[2])
  if not lineData then
    return
  end
  if lineData.sort < 1 then
    return
  end
  return "Assets/Main/Sprites/UI/LWChatEmoji/Default/" .. tostring(lineData.path) .. ".png"
end

function M:UpdateLayout()
  local maxWidth = self.frame:GetChatItemMaxWidth() - 250
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
  if self.emoji then
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

function M:OnRecycle()
end

function M:HandleClick()
  if self.clickReply then
    self.clickReply = false
    self:JumpReplyMsg()
    return true
  end
  return false
end

function M:JumpReplyMsg()
  if self._chatData == nil then
    return
  end
  if self._chatData.replyMsg == nil then
    return
  end
  if self._chatData.replyMsg.seqId == nil or self._chatData.replyMsg.seqId == 0 then
    return
  end
  local seqId = self._chatData.replyMsg.seqId
  DataCenter.ActEasterEggManager:SetIsOnLikeDescendOrder(false)
  local roomData = ChatManager2:GetInstance().Room:GetEasterEggRoom()
  local isExist = roomData:isExistSeqId(seqId)
  if isExist then
    EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_MOVE_TO_SPECIAL_CHAT_DATA, seqId)
  else
    local topLikeChatData = DataCenter.ActEasterEggManager:GetTopLikeChatData()
    DataCenter.ActEasterEggManager:SetIsJumpTopLikeChatData(topLikeChatData and topLikeChatData:getSeqId() == seqId)
    local roomId = self._chatData.roomId
    if topLikeChatData and topLikeChatData:getSeqId() == seqId then
      ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.HistoryRoomGoto, roomId, roomData:GetOriginalFirstSeqId(), 1)
    else
      ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.HistoryRoomGoto, roomId, seqId, 1)
    end
  end
end

function M:TryFoldText()
  self.isShowReadMore = false
  local dialog = self:GetDialogData()
  if dialog and self._dialogTxt.activeSelf then
    self._dialogTxt.unity_tmpro:ForceMeshUpdate()
    local textInfo = self._dialogTxt.unity_tmpro.textInfo
    local lineCount = textInfo.lineCount
    if 10 < lineCount then
      if self.isTextFolding then
        self._dialogTxt.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Vertical, textInfo.lineInfo[0].lineHeight * 10)
      end
      self.isShowReadMore = true
    end
  end
  if self.isShowReadMore then
    self._moreBtn:SetActive(true)
  else
    self._moreBtn:SetActive(false)
  end
  if self.chatItemPostLayoutCS then
    self.chatItemPostLayoutCS.padding = self.isShowReadMore and HasFoldPadding or NormalPadding
  end
end

function M:UpdateTextFoldState()
  if self.isTextFolding then
    self._moreBtnText:SetText(Localization:GetString("message_show_more"))
  else
    self._moreBtnText:SetText(Localization:GetString("message_show_less"))
  end
  if self.isShowReadMore then
    local sizeDelta = self._dialogTxt:GetSizeDelta()
    local preferredValues = self._moreBtnText.unity_tmpro:GetPreferredValues()
    self._dialogTxt.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Horizontal, math.max(sizeDelta.x, preferredValues.x))
  end
  if self._chatData:GetTranslateState() == 2 then
    if self.isTextFolding and self.isShowReadMore then
      self.hideTranslation = true
    else
      self.hideTranslation = false
    end
  end
  self.frame:UpdateTranslateContent()
end

function M:ChangeBubble()
  if not self._chatData then
    return
  end
  if not self._chatData:isMyChat() then
    self._defaultBubbleImg:LoadSprite("Assets/Main/Sprites/UI/LWChat_v2/DefaultSkin/ChatItems/sj_liaotian_bubble_1.png")
  else
    self._defaultBubbleImg:LoadSprite("Assets/Main/Sprites/UI/LWChat_v2/DefaultSkin/ChatItems/sj_liaotian_bubble_1b.png")
  end
end

return M
