local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local ChatItemPost_NormalChatNew = BaseClass("NormalChatNew", IChatItemPost)
local base = IChatItemPost
local StringUtils = CS.StringUtils
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
local Localization = CS.GameEntry.Localization
local HasFoldPadding = Vector2(40, 60)
local NormalPadding = Vector2(40, 30)
local AtHighlightColor = Color.FromHex("249bc5")

function ChatItemPost_NormalChatNew:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatItemPost_NormalChatNew:ComponentDefine()
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
  self._freedBackBtn = self:AddComponent(UIButton, "freedbackBtn")
  self._freedBackBtnText = self:AddComponent(UITextMeshProUGUIEx, "freedbackBtn/freedbackBtnText")
  self._moreBtnText:SetColor(ChatUIThemeConfig.MoreBtnColor[ChatInterface.GetChatTheme()])
  self._moreBtn:SetOnClick(function()
    self:OnFoldClick()
  end)
  self._freedBackBtn:SetOnClick(function()
    self:OnFreedBackClick()
  end)
  self.isTextFolding = true
  local lastClickTime
  self._replyClicker:OnPointerDown(function(eventData)
    lastClickTime = SafeLocalOsTime()
    self.clickReply = false
  end)
  self._replyClicker:OnPointerUp(function(eventData)
    if lastClickTime and SafeLocalOsTime() - lastClickTime < 1 then
      self.clickReply = true
    end
  end)
  self._dialogTxt:OnCharactorPointerClick(function(index)
    self:HandleAtNameClick(index)
  end)
  self._container = self._root
  ChatInterface.SetEmojiTextProperty(self._replyTxt)
  ChatInterface.SetEmojiTextProperty(self._dialogTxt)
end

function ChatItemPost_NormalChatNew:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.CHAT_ON_TRANSLATION_FINISH, self.OnTranslationFinish)
end

function ChatItemPost_NormalChatNew:OnRemoveListener()
  self:RemoveUIListener(EventId.CHAT_ON_TRANSLATION_FINISH, self.OnTranslationFinish)
  base.OnRemoveListener(self)
end

function ChatItemPost_NormalChatNew:OnFreedBackClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UITransFeedbackView, {anim = true}, self._chatData)
end

function ChatItemPost_NormalChatNew:FreedBack(isShow)
  if self.isEmojiOnly then
    return
  end
  self.showFreedBack = isShow
  self._freedBackBtn:SetActive(isShow)
  self:UpdateFreedBack()
  local sizeDelta = self._dialogTxt:GetSizeDelta()
  local maxX = sizeDelta.x
  if self.showFreedBack then
    local freedBackPreferredValues = self._freedBackBtnText.unity_tmpro:GetPreferredValues()
    local freedBackX = freedBackPreferredValues.x + 40
    maxX = math.max(sizeDelta.x, freedBackX)
  else
  end
  if self.isShowReadMore then
    local preferredValues = self._moreBtnText.unity_tmpro:GetPreferredValues()
    maxX = math.max(maxX, preferredValues.x)
  end
  self._dialogTxt.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Horizontal, maxX)
end

function ChatItemPost_NormalChatNew:ChangeBubble(bubbleId, bubbleET)
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
  self.bubbleId = bubbleId
  self:UpdateAtStringColor()
end

function ChatItemPost_NormalChatNew:OnTranslationFinish(chatData)
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

function ChatItemPost_NormalChatNew:OnFoldClick()
  self.isTextFolding = not self.isTextFolding
  self._chatData.isTextFolding = self.isTextFolding
  self:UpdateLayout()
  self:TryFoldText()
  self:UpdateTextFoldState()
  self:UpdateSize()
  self:UpdateAtStringColor()
end

function ChatItemPost_NormalChatNew:UpdateUserInfoWithNew()
  if self.frame and self.frame._userInfo then
    if self.frame._userInfo.uid == LuaEntry.Player.uid then
      local currentSkinId = DataCenter.DecorationDataManager:GetCurrentSkinByType(DecorationType.DecorationType_Chat_Bubble)
      local curskindData = DataCenter.DecorationDataManager:GetSkinDataById(currentSkinId)
      if curskindData == nil then
        self:ChangeBubble(nil, nil)
      else
        self:ChangeBubble(curskindData.skinId, curskindData.expireTime)
      end
    else
      self:ChangeBubble(self.frame._userInfo.chatBubbleId, self.frame._userInfo.chatBubbleET)
    end
  end
end

function ChatItemPost_NormalChatNew:RemoveEmojiCode(text)
  return text:gsub("\238[\128-\191][\128-\191]", "")
end

function ChatItemPost_NormalChatNew:OnLoaded()
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
    self.isEmojiOnly = true
  elseif self:CheckUpdateSingleEmoji() then
    self:UpdateEmoji(self.emoji)
    self._dialogTxt:SetActive(false)
    self.isEmojiOnly = true
  else
    self:UpdateDialog()
    self._emojiGo:SetActive(false)
    local dialog = self:GetDialogData()
    if not string.IsNullOrEmpty(dialog) then
      local notEmojiText = self:RemoveEmojiCode(dialog)
      dialog = StringUtils.GetNotEmojiText(notEmojiText)
    end
    self.isEmojiOnly = string.IsNullOrEmpty(dialog) and true or false
  end
  self._freedBackBtn:SetActive(false)
  self:UpdateReply()
  self:UpdateLayout()
  self:TryFoldText()
  self:UpdateTextFoldState()
  self:UpdateAtStringColor()
  self.showFreedBack = false
end

function ChatItemPost_NormalChatNew:UpdateFreedBack()
  if self.chatItemPostLayoutCS then
    self.chatItemPostLayoutCS.padding = (self.isShowReadMore or self.showFreedBack) and HasFoldPadding or NormalPadding
  end
end

function ChatItemPost_NormalChatNew:CheckUpdateSingleEmoji()
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

function ChatItemPost_NormalChatNew:UpdateDialog()
  local dialog = self:GetDialogData()
  if dialog == nil then
    self._dialogTxt:SetActive(false)
    return
  end
  self._dialogTxt:SetActive(true)
  self._dialogTxt:SetFontSize(32)
  self._dialogTxt:SetText_NotNative(dialog)
end

function ChatItemPost_NormalChatNew:GetDialogData()
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

function ChatItemPost_NormalChatNew:UpdateReply()
  local reply = self:GetReplyData()
  if reply == nil then
    self._replyTxt:SetActive(false)
    return
  end
  self._replyTxt:SetActive(true)
  self._replyTxt:SetText_NotNative(reply)
end

function ChatItemPost_NormalChatNew:GetReplyData()
  if not self._chatData then
    return
  end
  local replyMsg = self._chatData.replyMsg
  if not replyMsg then
    return
  end
  local sender = ChatInterface.getUserData(replyMsg.uid)
  local senerName = sender and sender.userName or replyMsg.userName
  return string.format("%s %s: %s", Localization:GetString("2900032"), senerName, ChatManager2:GetReplyMsgByChatMsg(replyMsg))
end

function ChatItemPost_NormalChatNew:UpdateEmoji(emoji)
  if emoji == nil then
    self._emojiGo:SetActive(false)
    return
  end
  self._emojiGo:SetActive(true)
  self._emojiImg:LoadSprite(emoji)
end

function ChatItemPost_NormalChatNew:GetEmojiData()
  if not self._chatData or not self._chatData:IsLWEmoji() then
    return
  end
  local rawStr = self._chatData.msg
  return self:GetEmojiId(rawStr)
end

function ChatItemPost_NormalChatNew:GetEmojiId(rawStr)
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

function ChatItemPost_NormalChatNew:UpdateLayout()
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

function ChatItemPost_NormalChatNew:OnRecycle()
end

function ChatItemPost_NormalChatNew:HandleClick()
  self:UpdateAtStringColor()
  if self.onClickAtName then
    self.onClickAtName = nil
    return true
  end
  if self.clickReply then
    self.clickReply = false
    self:JumpReplyMsg()
    return true
  end
  return false
end

function ChatItemPost_NormalChatNew:JumpReplyMsg()
  if self._chatData == nil then
    return
  end
  if self._chatData.replyMsg == nil then
    return
  end
  if self._chatData.replyMsg.seqId == nil or self._chatData.replyMsg.seqId == 0 then
    return
  end
  if ChatManager2:GetInstance().Restrict:isInRestrictList(self._chatData.replyMsg.uid, RestrictType.BLOCK) then
    return
  end
  local seqId = self._chatData.replyMsg.seqId
  local roomId = self._chatData.roomId
  local roomMgr = ChatManager2:GetInstance().Room
  roomMgr:GotoJumpMessage(roomId, seqId)
end

function ChatItemPost_NormalChatNew:TryFoldText()
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

function ChatItemPost_NormalChatNew:UpdateTextFoldState()
  if self.isTextFolding then
    self._moreBtnText:SetText(Localization:GetString("message_show_more"))
  else
    self._moreBtnText:SetText(Localization:GetString("message_show_less"))
  end
  local sizeDelta = self._dialogTxt:GetSizeDelta()
  local maxX = sizeDelta.x
  if self.showFreedBack then
    local freedBackPreferredValues = self._freedBackBtnText.unity_tmpro:GetPreferredValues()
    local freedBackX = freedBackPreferredValues.x + 40
    maxX = math.max(sizeDelta.x, freedBackX)
  end
  if self.isShowReadMore then
    local preferredValues = self._moreBtnText.unity_tmpro:GetPreferredValues()
    maxX = math.max(maxX, preferredValues.x)
  end
  self._dialogTxt.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Horizontal, maxX)
  if self._chatData:GetTranslateState() == 2 then
    if self.isTextFolding and self.isShowReadMore then
      self.hideTranslation = true
    else
      self.hideTranslation = false
    end
  end
  self.frame:UpdateTranslateContent()
end

function ChatItemPost_NormalChatNew:UpdateAtStringColor()
  if self._chatData == nil then
    return
  end
  local template = DataCenter.DecorationTemplateManager:GetTemplate(self.bubbleId)
  local color = AtHighlightColor
  if template and template.id and AtColors[template.id] then
    color = AtColors[template.id]
  end
  local matches = self._chatData:GetAtInfoMatches()
  if matches == nil or not next(matches) then
    return
  end
  local list = {}
  for i = 1, #matches, 3 do
    local min = matches[i]
    local max = matches[i + 1]
    table.insert(list, min)
    table.insert(list, max)
  end
  self._dialogTxt.unity_tmpro:SetTextColorRange(list, color)
end

function ChatItemPost_NormalChatNew:UpdateAtInputTag()
  if CS.GameDefines.isArabicTMPFix == false then
    return
  end
  self._dialogTxt.unity_tmpro:SetInputHtmlTagEmpty()
  if self._chatData == nil then
    return
  end
  local template = DataCenter.DecorationTemplateManager:GetTemplate(self.bubbleId)
  local color = AtHighlightColor
  if template and template.id and AtColors[template.id] then
    color = AtColors[template.id]
  end
  local colorStr = string.format("%02X%02X%02X", color.r * 255, color.g * 255, color.b * 255)
  local matches = self._chatData:GetAtInfoMatches()
  if matches == nil or not next(matches) then
    return
  end
  for i = 1, #matches, 3 do
    local min = matches[i]
    local max = matches[i + 1]
    self._dialogTxt.unity_tmpro:AddInputHtmlTag("color=#" .. colorStr, "/color", min, max)
  end
end

function ChatItemPost_NormalChatNew:HandleChatHeadLongPress()
end

function ChatItemPost_NormalChatNew:HandleAtNameClick(index)
  if self._chatData == nil then
    return
  end
  local matches = self._chatData:GetAtInfoMatches()
  if matches == nil then
    return
  end
  local num = index + 1
  for i = 1, #matches, 3 do
    local min = matches[i]
    local max = matches[i + 1]
    local uid = matches[i + 2]
    if num >= min and num <= max then
      if uid ~= "atAll" then
        self.onClickAtName = true
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, uid)
      end
      return
    end
  end
end

return ChatItemPost_NormalChatNew
