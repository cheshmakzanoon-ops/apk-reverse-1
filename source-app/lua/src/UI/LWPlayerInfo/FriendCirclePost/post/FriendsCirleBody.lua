local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local FriendsCirleBody = BaseClass("FriendsCirleBody", IChatItemPost)
local base = IChatItemPost
local FriendsCirlePhoto = require("UI.LWPlayerInfo.FriendCirclePost.post.FriendsCirlePhoto")
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
local NormalPadding = Vector2(40, 20)
local emojiOff = 10
local color = Color.New(0.3215686274509804, 0.3215686274509804, 0.3215686274509804, 1.0)
local reColor = Color.New(0.5058823529411764, 0.5411764705882353, 0.5137254901960784, 1.0)

function FriendsCirleBody:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function FriendsCirleBody:ComponentDefine()
  self._root = self:AddComponent(UIBaseContainer, "")
  self._bubbleBg = self:AddComponent(UIBaseContainer, bubble_bg)
  self._defaultBubbleImg = self:AddComponent(UIImage, bubble_default_path)
  self._specialBubbleImg = self:AddComponent(UIImage, bubble_special_path)
  self._replyTxt = self:AddComponent(UITextMeshProUGUIEx, reply_path)
  self._dialogTxt = self:AddComponent(UITextMeshProUGUIEx, dialog_path)
  self._dialogTxt:SetAlignment(CS.TMPro.TextAlignmentOptions.TopLeft)
  self._emojiGo = self:AddComponent(UIBaseContainer, emoji_go_path)
  self._emojiImg = self:AddComponent(UIImage, emoji_image_path)
  self._replyClicker = self:AddComponent(UIEventTrigger, reply_path)
  self._moreBtn = self:AddComponent(UIButton, more_btn_path)
  self._moreBtnText = self:AddComponent(UIText, more_btn_txt_path)
  self._rootPhoto = self:AddComponent(UIBaseContainer, "RootPhoto")
  self._photoComponent = self:AddComponent(FriendsCirlePhoto, "RootPhoto/FriendsCirlePhoto")
  self._moreBtn:SetOnClick(function()
    self:OnFoldClick()
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
  self._container = self._root
  ChatInterface.SetEmojiTextProperty(self._replyTxt)
  ChatInterface.SetEmojiTextProperty(self._dialogTxt)
  self._bubbleBg:SetActive(false)
end

function FriendsCirleBody:ChangeBubble()
  if self.frame._contentViewScript.darkModeSupport then
    local colorHex = ChatUIThemeConfig.MomentColor[ChatInterface.GetChatTheme()].bodyText
    self._dialogTxt:SetColorHex(colorHex)
    local replyColor = ChatUIThemeConfig.MomentColor[ChatInterface.GetChatTheme()].replyColor
    self._replyTxt:SetColorHex(replyColor)
    self.frame._traText:SetColorHex(colorHex)
  else
    self._dialogTxt:SetColor(color)
    self.frame._traText:SetColor(color)
    self._replyTxt:SetColor(reColor)
  end
end

function FriendsCirleBody:OnTranslationFinish(chatData)
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

function FriendsCirleBody:OnFoldClick()
  self.isTextFolding = not self.isTextFolding
  self._chatData.isTextFolding = self.isTextFolding
  local roomChatData = self:GetRoomChatData()
  roomChatData.isTextFolding = self.isTextFolding
  self:UpdateLayout()
  self:TryFoldText()
  self:UpdateTextFoldState()
  self:UpdateSize()
end

function FriendsCirleBody:GetRoomChatData()
  local room = ChatInterface.getRoomData(self._chatData.roomId)
  if room then
    return room:getChatDataBySeqId(self._chatData.seqId)
  else
    return self._chatData
  end
end

function FriendsCirleBody:UpdateUserInfoWithNew()
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

function FriendsCirleBody:OnLoaded()
  local chatdata = self:ChatData()
  if chatdata == nil then
    return
  end
  self._chatData = chatdata
  if self._chatData.isTextFolding == nil then
    self._chatData.isTextFolding = true
  end
  self.isTextFolding = self._chatData.isTextFolding
  self._emojiGo:SetActive(false)
  self._dialogTxt:SetActive(false)
  self._replyTxt:SetActive(false)
  self.emoji = self:GetEmojiData()
  self.isSingleEmoji = false
  if self.emoji then
    self.isSingleEmoji = true
    self:UpdateEmoji(self.emoji)
  elseif self:CheckUpdateSingleEmoji() then
    self.isSingleEmoji = true
    self:UpdateEmoji(self.emoji)
  else
    self:UpdateDialog()
  end
  self:UpdateReply()
  self:UpdateLayout()
  self:TryFoldText()
  self._photoComponent:OnLoaded(chatdata, self.chatPhotoSource)
  local uploadPicVer = chatdata:getExtra() and chatdata:getExtra().picVer
  if uploadPicVer ~= nil and uploadPicVer ~= -1 then
    self._rootPhoto:SetActive(true)
    self._photoComponent:UpdatePhoto()
    self._rootPhoto:SetSizeDeltaXY(self._photoComponent:GetImageWidth(), self._photoComponent:GetImageHight())
  else
    self._rootPhoto:SetActive(false)
    self._rootPhoto:SetSizeDeltaXY(0, 0)
  end
  self:UpdateTextFoldState()
  if ChatInterface.getMoment():GetIsMomentBody(self._chatData.post) then
    local isClick = self.frame._contentViewScript.headCanClick
    self.frame._chatHead:SetCanClick(isClick)
  else
    self.frame._chatHead:SetCanClick(true)
  end
  if ChatInterface.getMoment():GetIsMomentBody(self._chatData.post) and not self._chatData.notClick then
    self.frame:SetOnAnchorClick(function()
      self:OnItemCLick()
    end)
  end
end

function FriendsCirleBody:CheckUpdateSingleEmoji()
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

function FriendsCirleBody:UpdateDialog()
  local dialog = self:GetDialogData()
  if dialog == nil then
    self._dialogTxt:SetActive(false)
    return
  end
  self._dialogTxt:SetActive(true)
  self._dialogTxt:SetFontSize(32)
  self._dialogTxt:SetText_NotNative(dialog)
end

function FriendsCirleBody:GetDialogData()
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

function FriendsCirleBody:UpdateReply()
  local reply = self:GetReplyData()
  if reply == nil then
    self._replyTxt:SetActive(false)
    return
  end
  self._replyTxt:SetActive(true)
  self._replyTxt:SetText_NotNative(reply)
end

function FriendsCirleBody:GetReplyData()
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

function FriendsCirleBody:UpdateEmoji(emoji)
  if emoji == nil then
    self._emojiGo:SetActive(false)
  end
  self._emojiGo:SetActive(true)
  self._emojiImg:LoadSprite(emoji)
end

function FriendsCirleBody:GetEmojiData()
  if not self._chatData or not self._chatData:IsLWEmoji() then
    return
  end
  local rawStr = self._chatData.msg
  return self:GetEmojiId(rawStr)
end

function FriendsCirleBody:GetEmojiId(rawStr)
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

function FriendsCirleBody:UpdateLayout()
  local maxWidth = self.frame:GetTextMaxWidth()
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
  pos.x = 10
  self._dialogTxt:SetAnchoredPosition(pos)
  self._emojiGo:SetAnchoredPositionXY(pos.x, pos.y + emojiOff)
  pos.y = self:GetContentBottomY()
  if self._chatData:GetTranslateState() == 2 and (not self.isTextFolding or not self.isShowReadMore) then
    local translateAreaWidth, translateAreaHeight = self.frame:ResizeTranslationArea()
    pos.y = pos.y - translateAreaHeight
  end
  if self._moreBtn.activeSelf then
    self._moreBtn:SetAnchoredPosition(pos)
    pos.y = pos.y - self._moreBtn:GetSizeDelta().y
  end
  self._rootPhoto:SetAnchoredPosition(pos)
end

function FriendsCirleBody:OnRecycle()
  self._photoComponent:OnRecycle()
end

function FriendsCirleBody:OnItemCLick()
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UILWSingleMomentDetailView) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSingleMomentDetailView)
  end
  local source
  if self.frame then
    source = self.frame:GetSource()
  end
  local param = {
    chatData = self._chatData,
    source = source
  }
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSingleMomentDetailView, {anim = true}, param)
end

function FriendsCirleBody:HandleClick()
  return ChatInterface.getMoment():GetIsMomentBody(self._chatData.post)
end

function FriendsCirleBody:JumpReplyMsg()
end

function FriendsCirleBody:GetImageHight()
  if self._rootPhoto:GetActive() then
    return self._photoComponent:GetImageHight()
  end
  return 0
end

function FriendsCirleBody:TryFoldText()
  self.isShowReadMore = false
  local dialog = self:GetDialogData()
  if dialog and self._dialogTxt.activeSelf then
    self._dialogTxt.unity_tmpro:ForceMeshUpdate()
    local textInfo = self._dialogTxt.unity_tmpro.textInfo
    local lineCount = textInfo.lineCount
    if 3 < lineCount then
      if self.isTextFolding then
        self._dialogTxt.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Vertical, textInfo.lineInfo[0].lineHeight * 3)
      end
      self.isShowReadMore = true
    end
  end
  if self.isShowReadMore then
    self._moreBtn:SetActive(true)
  else
    self._moreBtn:SetActive(false)
  end
  local pos = self._replyTxt:GetAnchoredPosition()
  local reply = self:GetReplyData()
  if reply then
    pos.y = pos.y - self._replyTxt:GetSizeDelta().y
  end
  pos.x = 10
  self._dialogTxt:SetAnchoredPosition(pos)
  self._emojiGo:SetAnchoredPositionXY(pos.x, pos.y + emojiOff)
  pos.y = self:GetContentBottomY()
  local ResizeTranslationArea
  if self._chatData:GetTranslateState() == 2 and (not self.isTextFolding or not self.isShowReadMore) then
    local translateAreaWidth, translateAreaHeight = self.frame:ResizeTranslationArea()
    pos.y = pos.y - translateAreaHeight
  end
  if self._moreBtn.activeSelf then
    self._moreBtn:SetAnchoredPosition(pos)
    pos.y = pos.y - self._moreBtn:GetSizeDelta().y
  end
  self._rootPhoto:SetAnchoredPosition(pos)
  if self.chatItemPostLayoutCS then
    self.chatItemPostLayoutCS.padding = self.isShowReadMore and HasFoldPadding or NormalPadding
  end
end

function FriendsCirleBody:SetTransHight(hight)
  self.transHight = hight
  local pos = self._replyTxt:GetAnchoredPosition()
  local reply = self:GetReplyData()
  if reply then
    pos.y = pos.y - self._replyTxt:GetSizeDelta().y
  end
  pos.x = 10
  pos.y = self:GetContentBottomY()
  if self._chatData:GetTranslateState() == 2 and (not self.isTextFolding or not self.isShowReadMore) then
    local translateAreaWidth, translateAreaHeight = self.frame:ResizeTranslationArea()
    pos.y = pos.y - translateAreaHeight
  end
  if self._moreBtn.activeSelf then
    self._moreBtn:SetAnchoredPosition(pos)
    pos.y = pos.y - self._moreBtn:GetSizeDelta().y
  end
  self._rootPhoto:SetAnchoredPosition(pos)
end

function FriendsCirleBody:GetContentBottomY()
  local posY
  if self.isSingleEmoji then
    posY = self._emojiGo:GetAnchoredPosition().y - self._emojiGo:GetSizeDelta().y
  else
    posY = self._dialogTxt:GetAnchoredPosition().y - self._dialogTxt:GetSizeDelta().y
  end
  return posY
end

function FriendsCirleBody:UpdateTextFoldState()
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

function FriendsCirleBody:SetChatPhotoSource(chatPhotoSource)
  self.chatPhotoSource = chatPhotoSource
end

return FriendsCirleBody
