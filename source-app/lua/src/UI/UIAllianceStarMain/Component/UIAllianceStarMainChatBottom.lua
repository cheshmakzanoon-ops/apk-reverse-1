local base = UIBaseContainer
local UIAllianceStarMainChatBottom = BaseClass("UIAllianceStarMainChatBottom", base)
local UIEmojiArea = require("UI.UIChatNewV2.Component.UIChatViewEmojiArea_v2")
local UIFuncArea = require("UI.UIChatNewV2.Component.UIChatViewFuncArea_v2")
local UIReplyArea = require("UI.UIChatNewV2.Component.UIChatViewReplyArea_v2")
local PanelTypeEnum = _ENV.PanelTypeEnum
local Regex = CS.System.Text.RegularExpressions.Regex
local UIChatItemCell = require("UI.UIAllianceStarMain.Component.UIAllianceStarMainChatItemCell")
local Localization = CS.GameEntry.Localization
local POST_TYPE_BLACK_LIST = {
  PostType.Text_MemberJoin,
  PostType.Text_MemberQuit,
  PostType.Text_ChatRoomSystemMsg,
  PostType.Text_AllianceMemberInOut,
  PostType.Text_AllianceRankChange,
  PostType.Text_AllianceOfficialChange,
  PostType.Text_AllianceOfficialSet,
  PostType.Text_AllianceOfficialCancel
}
local compBook = {
  {
    path = "",
    name = "layoutElement",
    type = UILayoutElement
  },
  {
    path = "areaInput",
    name = "areaInput",
    type = UIBaseContainer
  },
  {
    path = "areaInput/btnBack",
    name = "btnBack",
    type = UIButton,
    onClick = function(self)
      self:OnClickBack()
    end
  },
  {
    path = "areaInput/btnSend",
    name = "btnSend",
    type = UIButton,
    onClick = function(self)
      self:OnClickSend()
    end
  },
  {
    path = "areaInput/btnKeyboard",
    name = "btnKeyboard",
    type = UIButton,
    onClick = function(self)
      self:OnClickBtnKeyboard()
    end,
    active = false
  },
  {
    path = "areaInput/btnEmoji",
    name = "btnEmoji",
    type = UIButton,
    onClick = function(self)
      self:OnClickEmoji()
    end
  },
  {
    path = "areaInput/btnFuncs",
    name = "btnFuncs",
    type = UIButton,
    onClick = function(self)
      self:OnClickFuncs()
    end
  },
  {
    path = "areaInput/inputMsgMobile/holder",
    name = "inputMsgHolder",
    type = UIText,
    textKey = 2900000
  },
  {
    path = "areaInput/inputMsgMobile/text",
    name = "inputMsgText",
    type = UIText
  },
  {
    path = "areaInput/inputMsgPC/Text Area",
    name = "inputMsgPCTextArea",
    type = UIBaseContainer
  },
  {
    path = "areaInput/inputMsgPC/Text Area/Placeholder",
    name = "inputMsgPCHolder",
    type = UIText
  },
  {
    path = "areaInput/inputMsgPC/Text Area/Text",
    name = "inputMsgPCText",
    type = UIText
  },
  {
    path = "areaInput/inputMsgPC",
    name = "inputMsgPCBg",
    type = UIImage
  },
  {
    path = "areaInput/btnFuncs/reddot",
    name = "areaFuncRedDot",
    type = UIBaseContainer
  },
  {
    path = "areaEmoji",
    name = "areaEmoji",
    type = UIEmojiArea,
    active = false
  },
  {
    path = "areaFunc",
    name = "areaFunc",
    type = UIFuncArea,
    active = false
  },
  {
    path = "page",
    name = "page",
    type = UIChatItemCell,
    active = true
  }
}
local __BLANK_HEIGHT = 35
local __DEFAULT_INPUT_HEIGHT = 135
local __DEFAULT_INPUT_MSG_HEIGHT = 81
local __CHAR_EXTRA_HEIGHT = 0.8
local emojiHeight = 550
local funcsHeight_1Line = 210
local funcsHeight_2Line = 383
local isShowImmediately = true

function UIAllianceStarMainChatBottom:OnCreate()
  base.OnCreate(self)
  self:InitData()
  self:ComponentDefine()
  self:SetInputCompsActive(true)
  self.inputMsgUnity:SetText("")
  if self.IsOnAndroidOrIOS() then
    self:SetInputHeightDataByLineCount_Mobile()
  end
  self:SetPopUpPanelDataByType(PanelTypeEnum.None)
  self:SetMobileKeyboardActive(false)
  self:SetReply(nil)
  self:__UpdateHeight(isShowImmediately)
end

function UIAllianceStarMainChatBottom:InitData()
  self.inputLineCount = 1
  self.inputHeight = 135
  self.replayAreaHeight = 0
  self.charHeight = 44
  self.keyboardHeight = 0
  self.forceHiddenKeyboard = false
  self.mobilId = nil
  self.emojiAreaHight = 0
  self.funcsAreaHeight = 0
end

function UIAllianceStarMainChatBottom:OnDestroy()
  self:DestroyData()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAllianceStarMainChatBottom:DestroyData()
  self.forceHiddenKeyboard = nil
  self.mobilId = nil
end

function UIAllianceStarMainChatBottom:ComponentDefine()
  self:DefineCompsByBook(compBook)
  local inputMsgMobile = self:AddComponent(UIInput, "areaInput/inputMsgMobile")
  local inputMsgPC = self:AddComponent(UIInput, "areaInput/inputMsgPC")
  inputMsgMobile:SetActive(self:IsOnAndroidOrIOS())
  inputMsgPC:SetActive(not self:IsOnAndroidOrIOS())
  self.inputMsgUnity = self:IsOnAndroidOrIOS() and inputMsgMobile or inputMsgPC
  local holderColor = ChatUIThemeConfig.InputHolderColor[ChatInterface.GetChatTheme()]
  local textColor = ChatUIThemeConfig.InputTextColor[ChatInterface.GetChatTheme()]
  local mobilBackGroundColor = ChatUIThemeConfig.MobilBackGroundColor[ChatInterface.GetChatTheme()]
  if self:IsOnAndroidOrIOS() then
    self.inputMsgMobile = self.inputMsgUnity.gameObject:GetComponent(typeof(CS.Mopsicus.Plugins.MobileInputField))
    self.mobilId = self.inputMsgMobile:GetMobilId()
    
    function self.OnTextChangeFromPlatform(str)
      self:OnInputMsgChanged(str)
      self:OnInputMsgChanged_UpadteHeight_Mobile(str)
    end
    
    function self.OnShowKeyboard(mobilId, isShow, height)
      if ChatInterface.GetMobilSupportMultiple() and mobilId ~= self.mobilId then
        return
      end
      local postALNoticeWindow = UIManager:GetInstance():GetWindow(UIWindowNames.UIPostAllianceNotice)
      if postALNoticeWindow and postALNoticeWindow.State == 2 then
        return
      end
      local keyboardHeight = self:__CalcKeyboardHeight(height)
      self:SetMobileKeyboardActive(isShow, keyboardHeight)
      self:__UpdateHeight(isShowImmediately)
    end
    
    if ChatInterface.GetMobilSupportMultiple() then
      self.inputMsgMobile.OnShowKeyboard = self.OnShowKeyboard
      self.inputMsgMobile.OnTextChangeFromPlatform = self.OnTextChangeFromPlatform
    else
      CS.Mopsicus.Plugins.MobileInput.OnShowKeyboard = self.OnShowKeyboard
      CS.Mopsicus.Plugins.MobileInput.OnTextChangeFromPlatform = self.OnTextChangeFromPlatform
    end
    
    function self.__mobileInputField_OnReturnPressed()
      __ChatPostBI(ChatBIEnum.ChatMsgSendClick, {source = "keyboard"})
      self:OnClickSend(true)
    end
    
    self.inputMsgMobile.OnReturnPressedEvent:AddListener(self.__mobileInputField_OnReturnPressed)
    self.hiddenKeyboard = nil
    self.inputMsgMobile:SetMobilTextColor(textColor.r, textColor.g, textColor.b, textColor.a)
    self.inputMsgMobile:SetMobilPlaceholderColor(holderColor.r, holderColor.g, holderColor.b, holderColor.a)
    self.inputMsgMobile:SetMobilBackGroundColor(mobilBackGroundColor.r, mobilBackGroundColor.g, mobilBackGroundColor.b, mobilBackGroundColor.a)
    self:SetUMIVisible(true)
    self:SetUMIFocus(false)
    self.areaEmoji:SetMobilInputId(self.mobilId)
  else
    self.inputMsgUnity.unity_tmpinput.placeholder.color = Color.New(holderColor.r, holderColor.g, holderColor.b, holderColor.a)
    self.inputMsgUnity.unity_tmpinput.textComponent.color = Color.New(textColor.r, textColor.g, textColor.b, textColor.a)
    self.inputMsgPCBg:SetColor(Color.New(mobilBackGroundColor.r, mobilBackGroundColor.g, mobilBackGroundColor.b, mobilBackGroundColor.a))
    self.inputMsgPCText:SetSupportSpriteTagOnly(false)
    self.inputMsgPCText:SetSupportSpriteEmoji(true)
  end
  self.areaReply = self:AddComponent(UIReplyArea, "areaReply_TMP")
  self.areaReply:SetActive(false)
  self.inputMsgUnity:SetOnValueChange(function(value)
    if CS.SDKManager.IS_UNITY_EDITOR() or Config.IsPC() then
      self:OnInputMsgChanged(value)
      self:OnInputMsgChanged_UpadteHeight_PC(value)
    end
  end)
  self.areaEmoji:SetDeleteCallBack(function()
    self:DeleteButtonClick()
  end)
  self.areaEmoji:SetSendCallBack(function()
    self:SendMessage()
  end)
  self.prePanelType = nil
  if self:IsOnAndroidOrIOS() then
    self:SetInputFieldTextToMid()
  end
  self.resetPopPanelType = PanelTypeEnum.None
end

function UIAllianceStarMainChatBottom:SetHolderColor(holderColor, textColor, mobilBackGroundColor)
  if self:IsOnAndroidOrIOS() then
    self.inputMsgMobile:SetMobilPlaceholderColor(holderColor.r, holderColor.g, holderColor.b, holderColor.a)
    self.inputMsgMobile:SetMobilTextColor(textColor.r, textColor.g, textColor.b, textColor.a)
    self.inputMsgMobile:SetMobilBackGroundColor(mobilBackGroundColor.r, mobilBackGroundColor.g, mobilBackGroundColor.b, mobilBackGroundColor.a)
  else
    self.inputMsgUnity.unity_tmpinput.placeholder.color = Color.New(holderColor.r, holderColor.g, holderColor.b, holderColor.a)
    self.inputMsgUnity.unity_tmpinput.textComponent.color = Color.New(textColor.r, textColor.g, textColor.b, textColor.a)
    self.inputMsgPCBg:SetColor(Color.New(mobilBackGroundColor.r, mobilBackGroundColor.g, mobilBackGroundColor.b, mobilBackGroundColor.a))
  end
end

function UIAllianceStarMainChatBottom:ComponentDestroy()
  self:SetUMIFocus(false)
  if self:IsOnAndroidOrIOS() then
    if self.__mobileInputField_OnReturnPressed then
      self.inputMsgMobile.OnReturnPressedEvent:RemoveListener(self.__mobileInputField_OnReturnPressed)
      self.__mobileInputField_OnReturnPressed = nil
    end
    if ChatInterface.GetMobilSupportMultiple() then
      self.inputMsgMobile.OnShowKeyboard = nil
      self.inputMsgMobile.OnTextChangeFromPlatform = nil
    else
      CS.Mopsicus.Plugins.MobileInput.OnShowKeyboard = nil
      CS.Mopsicus.Plugins.MobileInput.OnTextChangeFromPlatform = nil
    end
    self.OnTextChangeFromPlatform = nil
    self.OnShowKeyboard = nil
    self.hiddenKeyboard = nil
  end
  self.resetPopPanelType = PanelTypeEnum.None
  self.prePanelType = nil
  self:ClearCompsByBook(compBook)
end

function UIAllianceStarMainChatBottom:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GF_window_opened, self.OnWindowOpened)
  self:AddUIListener(EventId.GF_window_closed, self.OnWindowClosed)
  self:AddUIListener(EventId.SetReplyChatMsg, self.OnSetReply)
  self:AddUIListener(EventId.Chat_Emoji_Clcik, self.OnEmojiClick)
  self:AddUIListener(ChatEventEnum.CHAT_CLOSE_POP_UP_KEYBOARD, self.OnClosePopUpKeyboard)
  self:AddUIListener(EventId.RefreshBagRedDot, self.UpdateRedPacketDot)
  self:AddUIListener(EventId.UMIRefreshCharHeight, self.SetCharHeight)
  self:AddUIListener(ChatEventEnum.CHAT_ROOM_SEL, self.SelectRoom)
  if self:IsOnEditorOrPC() and not self.updateTimer then
    function self.updateTimer()
      self:OnUpdate()
    end
    
    UpdateManager:GetInstance():AddUpdate(self.updateTimer)
  end
  self:AddUIListener(ChatEventEnum.CHAT_INIT_PULL_DONE, self.RefreshEntries)
  self:AddUIListener(ChatEventEnum.CHAT_DEL_MSG, self.OnChatDelMsg)
  self:AddUIListener(EventId.RefreshBargainShopMessageSetting, self.RefreshEntries)
  self:AddUIListener(EventId.CHAT_REFRESH_VIEW, self.RefreshEntries)
  self:AddUIListener(EventId.ChatUserInfoUpdate, self.RefreshEntries)
  self:AddUIListener(EventId.CHAT_RECIEVE_ROOM_MSG, self.OnReceiveChatMessage)
end

function UIAllianceStarMainChatBottom:OnRemoveListener()
  if self:IsOnEditorOrPC() and self.updateTimer then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.updateTimer = nil
  end
  self:RemoveUIListener(EventId.GF_window_opened, self.OnWindowOpened)
  self:RemoveUIListener(EventId.GF_window_closed, self.OnWindowClosed)
  self:RemoveUIListener(EventId.SetReplyChatMsg, self.OnSetReply)
  self:RemoveUIListener(ChatEventEnum.CHAT_CLOSE_POP_UP_KEYBOARD, self.OnClosePopUpKeyboard)
  self:RemoveUIListener(EventId.RefreshBagRedDot, self.UpdateRedPacketDot)
  self:RemoveUIListener(EventId.UMIRefreshCharHeight, self.SetCharHeight)
  self:RemoveUIListener(EventId.Chat_Emoji_Clcik, self.OnEmojiClick)
  self:RemoveUIListener(ChatEventEnum.CHAT_ROOM_SEL, self.SelectRoom)
  self:RemoveUIListener(ChatEventEnum.CHAT_INIT_PULL_DONE, self.RefreshEntries)
  self:RemoveUIListener(ChatEventEnum.CHAT_DEL_MSG, self.OnChatDelMsg)
  self:RemoveUIListener(EventId.RefreshBargainShopMessageSetting, self.RefreshEntries)
  self:RemoveUIListener(EventId.CHAT_REFRESH_VIEW, self.RefreshEntries)
  self:RemoveUIListener(EventId.ChatUserInfoUpdate, self.RefreshEntries)
  self:RemoveUIListener(EventId.CHAT_RECIEVE_ROOM_MSG, self.OnReceiveChatMessage)
  base.OnRemoveListener(self)
end

function UIAllianceStarMainChatBottom:OnUpdate()
  if self:IsOnEditorOrPC() and CS.UnityEngine.Input.GetKeyDown(CS.UnityEngine.KeyCode.Return) and self.btnSend:GetActive() then
    __ChatPostBI(ChatBIEnum.ChatMsgSendClick, {source = "keyboard"})
    self:OnClickSend(true)
    self.inputMsgUnity.unity_tmpinput:ActivateInputField()
  end
end

function UIAllianceStarMainChatBottom:OnEmojiClick(info)
  if self:IsOnAndroidOrIOS() then
    if ChatInterface.GetMobilSupportMultiple() and self.mobilId ~= info.mobilInputId then
      return
    end
    local str = "\\u" .. info.text
    self.inputMsgMobile:InsertTextAndScroll(str)
  else
    local str = "\\u" .. info.text
    local unicodeStr = Regex.Unescape(str)
    self.inputMsgUnity:InsertStrInCaretPos(unicodeStr)
  end
end

function UIAllianceStarMainChatBottom:OnEnable()
  base.OnEnable(self)
  self:InitFuncsRedDotData()
  self:SetFuncsRedDotState()
  self:SetInputFieldTextHeight()
  self:RefreshChatItemCell()
  TimerManager:GetInstance():DelayFrameInvoke(function()
    self:RefreshEntries()
  end, 2)
end

function UIAllianceStarMainChatBottom:OnDisable()
  self.chatBottomFuncData = nil
  base.OnDisable(self)
end

function UIAllianceStarMainChatBottom:ResetInputAndReply(room)
  self:OnSetReply(room and room.temp and room:GetCacheData().replyMsg or nil)
  self:SetInputActive(not room or room.group ~= ChatGroupType.GROUP_ALLIANCE_NOTICE)
  local curText = room and room.temp and room:GetCacheData().text or ""
  self:SetDiffInputMsgText(curText)
end

function UIAllianceStarMainChatBottom:__CalcKeyboardHeight(height)
  local layer = UIManager:GetInstance():GetLayer(UILayer.Normal.Name)
  local uiFullHeight = layer.rectTransform.rect.height
  local keyboardHeight = uiFullHeight * height / Screen.height
  return keyboardHeight
end

function UIAllianceStarMainChatBottom:__UpdateHeight(immediately, isSkipRefreshMidArea)
  immediately = true
  if self.__heightTween then
    self.__heightTween:Kill()
  end
  local height = self.inputHeight + self.replayAreaHeight + math.max(math.max(self.emojiAreaHight, self.keyboardHeight, self.funcsAreaHeight), __BLANK_HEIGHT)
  if ChatInterface.IsTranslateAllOpen() then
    self:UpdateMsgContainerPosition(height)
  end
  if immediately then
    self.layoutElement.unity_LayoutElement.minHeight = height
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.transform.parent)
    if not ChatInterface.IsTranslateAllOpen() and self.holder and self.holder.middle and self.holder.middle.scrollMsgs and not isSkipRefreshMidArea then
      self.holder.middle.scrollMsgs:ScrollToTail()
    end
  else
    self.__heightTween = self.layoutElement.unity_LayoutElement:DOMinSize(Vector2(0, height), 0.2):OnComplete(function()
      self.__heightTween = nil
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.transform.parent)
      if not ChatInterface.IsTranslateAllOpen() and self.holder and self.holder.middle and self.holder.middle.scrollMsgs then
        self.holder.middle.scrollMsgs:ScrollToTail()
      end
    end):OnUpdate(function()
      if not ChatInterface.IsTranslateAllOpen() and self.holder and self.holder.middle and self.holder.middle.scrollMsgs then
        self.holder.middle.scrollMsgs:ScrollToTail()
      end
    end)
  end
end

function UIAllianceStarMainChatBottom:UpdateMsgContainerPosition(height)
  self.lastHeight = self.nowHeight
  self.nowHeight = height
  if self.holder and self.holder.middle and self.holder.middle.scrollMsgs then
    local containerTrans = self.holder.middle.scrollMsgs._scrollView.unity_looplistview2.ContainerTrans
    local anchoredPosition = containerTrans.anchoredPosition
    if self.lastHeight then
      anchoredPosition.y = anchoredPosition.y + self.nowHeight - self.lastHeight
      containerTrans.anchoredPosition = anchoredPosition
    end
  end
end

function UIAllianceStarMainChatBottom:SetPopUpPanelDataByType(boardType, isIgnoreSetFocus)
  local curBoardType = boardType or PanelTypeEnum.None
  self.areaEmoji:SetActive(curBoardType == PanelTypeEnum.EmojiPanel)
  self.btnKeyboard:SetActive(curBoardType == PanelTypeEnum.EmojiPanel)
  self.areaFunc:SetActive(curBoardType == PanelTypeEnum.FuncsPanel)
  if not isIgnoreSetFocus and curBoardType ~= PanelTypeEnum.Keyboard then
    self:SetUMIFocus(false)
  end
  self.emojiAreaHight = 0
  self.funcsAreaHeight = 0
  if curBoardType == PanelTypeEnum.None then
    self.holder.middle:SetClickZoneActive(false, self.prePanelType)
  elseif curBoardType == PanelTypeEnum.EmojiPanel then
    self:ShowEmojiPanel()
  elseif curBoardType == PanelTypeEnum.FuncsPanel then
    self.areaFunc:ClearLoadingFuncItem()
    self:ShowFuncsPanel()
  end
  self.prePanelType = curBoardType
end

function UIAllianceStarMainChatBottom:ShowEmojiPanel()
  local isBtnGray = self:GetDiffInputMsgText() == ""
  self.areaEmoji:SendDeleteBtnSetGray(isBtnGray)
  self.areaEmoji:UpdateItems()
  self.holder.middle:SetClickZoneActive(true, PanelTypeEnum.EmojiPanel, function()
    self.resetPopPanelType = PanelTypeEnum.None
    self:SetPopUpPanelDataByType(PanelTypeEnum.None)
    self:__UpdateHeight(isShowImmediately)
  end)
  self.emojiAreaHight = emojiHeight
end

function UIAllianceStarMainChatBottom:ShowFuncsPanel()
  self.areaFunc:ShowFuncsPanel()
  self.holder.middle:SetClickZoneActive(true, PanelTypeEnum.FuncsPanel, function()
    self.resetPopPanelType = PanelTypeEnum.None
    self:SetPopUpPanelDataByType(PanelTypeEnum.None)
    self:__UpdateHeight(isShowImmediately)
  end)
  local curRoomFuncTypes = self.areaFunc:GetCurRoomFuncsTypes()
  if curRoomFuncTypes == nil then
    return
  end
  if #curRoomFuncTypes <= 4 then
    self.funcsAreaHeight = funcsHeight_1Line
  else
    self.funcsAreaHeight = funcsHeight_2Line
  end
end

function UIAllianceStarMainChatBottom:SetMobileKeyboardActive(active, keyboardHeight)
  if active then
    self:SetPopUpPanelDataByType(PanelTypeEnum.Keyboard)
    self.holder.middle:SetClickZoneActive(true, PanelTypeEnum.Keyboard, function()
      self:SetUMIFocus(false)
      self.resetPopPanelType = PanelTypeEnum.None
      self:__UpdateHeight(isShowImmediately)
    end)
    self.keyboardHeight = keyboardHeight
  else
    self.holder.middle:SetClickZoneActive(false, PanelTypeEnum.Keyboard)
    self.keyboardHeight = 0
    if self.resetPopPanelType and self.resetPopPanelType ~= PanelTypeEnum.None then
      self:SetPopUpPanelDataByType(self.resetPopPanelType, true)
    end
  end
end

function UIAllianceStarMainChatBottom:SetInputCompsActive(active)
  if not active then
    self:SetUMIFocus(false)
  end
  self.inputMsgUnity:SetActive(active)
  self.btnEmoji:SetActive(active)
  self.areaFunc:ClearLoadingFuncItem()
  self:SetSendOrFuncActive(active)
end

function UIAllianceStarMainChatBottom:SetSendOrFuncActive(active, str)
  local text
  text = str or self:GetDiffInputMsgText()
  local isOn = string.IsNullOrEmpty(text)
  local send = active and not string.IsNullOrEmpty(text)
  self.btnSend:SetActive(true)
  self.btnFuncs:SetActive(false)
  if ChatInterface.IsUnlockEmojiInput() and self.areaEmoji:GetActive() then
    self.areaEmoji:SendDeleteBtnSetGray(active and isOn)
  end
end

function UIAllianceStarMainChatBottom:SetReply(replyMsg)
  if replyMsg then
    self.areaReply:SetActive(true)
    local replyH = self.areaReply:GetReplyMsgHeight(replyMsg)
    self.replayAreaHeight = replyH < 40 and 100 or 140
    self.areaReply:SetSizeDeltaXY(self.areaReply:GetSizeDelta().x, self.replayAreaHeight)
    self.areaReply:SetReply(replyMsg)
  else
    self.replayAreaHeight = 0
    self.areaReply:SetActive(false)
  end
  self.areaInput:SetAnchoredPositionXY(self.areaInput:GetAnchoredPositionX(), -self.replayAreaHeight)
  self.areaInput:SetAnchoredPositionXY(self.areaInput:GetAnchoredPositionX(), -self.replayAreaHeight)
  self.areaEmoji:SetOffsetMaxXY(0, -self.inputHeight - self.replayAreaHeight)
  self.areaFunc:SetOffsetMaxXY(0, -self.inputHeight - self.replayAreaHeight)
  local currRoom = self.holder:GetSelectedRoom()
  if currRoom then
    currRoom:SetTempReply(replyMsg)
  end
end

function UIAllianceStarMainChatBottom:CountChatLinesInEditorAndPC(str)
  self.inputMsgUnity.unity_tmpinput:InputFieldContentForceMeshUpdate()
  return self.inputMsgUnity.unity_tmpinput:GetInputFieldLineCount()
end

function UIAllianceStarMainChatBottom:OnInputMsgChanged_UpadteHeight_PC(value)
  if not self:IsOnEditorOrPC() then
    return
  end
  local curLineCount = self:CountChatLinesInEditorAndPC(value)
  curLineCount = math.min(math.max(curLineCount, 1), 6)
  self.inputLineCount = curLineCount
  self:SetInputHeightDataByLineCount_PC(curLineCount)
  self:__UpdateHeight(isShowImmediately)
end

function UIAllianceStarMainChatBottom:SetInputHeightDataByLineCount_PC(lineCount)
  local extraHeight = 0
  for i = 2, lineCount do
    local curLineHeight = self.inputMsgUnity.unity_tmpinput:GetInputFieldLineHeightByNum(i)
    extraHeight = extraHeight + curLineHeight + __CHAR_EXTRA_HEIGHT
  end
  self.inputHeight = __DEFAULT_INPUT_HEIGHT + extraHeight
  self.areaInput:SetSizeDeltaXY(self.areaInput:GetSizeDelta().x, self.inputHeight)
  self.inputMsgUnity:SetSizeDeltaXY(self.inputMsgUnity:GetSizeDelta().x, __DEFAULT_INPUT_MSG_HEIGHT + extraHeight)
  local textTotalHeight = 0
  for i = 1, lineCount do
    local curLineHeight = self.inputMsgUnity.unity_tmpinput:GetInputFieldLineHeightByNum(i)
    textTotalHeight = textTotalHeight + curLineHeight + __CHAR_EXTRA_HEIGHT
  end
  self.inputMsgPCTextArea:SetSizeDeltaXY(self.inputMsgPCTextArea:GetSizeDelta().x, textTotalHeight)
  self.areaInput:SetAnchoredPositionXY(self.areaInput:GetAnchoredPositionX(), -self.replayAreaHeight)
  self.areaEmoji:SetOffsetMaxXY(0, -self.inputHeight - self.replayAreaHeight)
  self.areaFunc:SetOffsetMaxXY(0, -self.inputHeight - self.replayAreaHeight)
end

function UIAllianceStarMainChatBottom:OnInputMsgChanged_UpadteHeight_Mobile(value)
  if not self:IsOnAndroidOrIOS() then
    return
  end
  local curLineCount = self.inputMsgMobile.lineCount
  curLineCount = math.min(math.max(curLineCount, 1), 6)
  if self.inputLineCount ~= curLineCount then
    self.inputLineCount = curLineCount
    self:SetInputHeightDataByLineCount_Mobile()
    self:__UpdateHeight(isShowImmediately)
  end
end

function UIAllianceStarMainChatBottom:SetInputHeightDataByLineCount_Mobile()
  local extraHeight = (self.charHeight + __CHAR_EXTRA_HEIGHT) * (self.inputLineCount - 1)
  self.inputHeight = __DEFAULT_INPUT_HEIGHT + extraHeight
  self.areaInput:SetSizeDeltaXY(self.areaInput:GetSizeDelta().x, self.inputHeight)
  self.inputMsgUnity:SetSizeDeltaXY(self.inputMsgUnity:GetSizeDelta().x, __DEFAULT_INPUT_MSG_HEIGHT + extraHeight)
  self:SetInputFieldTextHeight()
  self.areaInput:SetAnchoredPositionXY(self.areaInput:GetAnchoredPositionX(), -self.replayAreaHeight)
  self.areaEmoji:SetOffsetMaxXY(0, -self.inputHeight - self.replayAreaHeight)
  self.areaFunc:SetOffsetMaxXY(0, -self.inputHeight - self.replayAreaHeight)
end

function UIAllianceStarMainChatBottom:GetInputFieldTextHeightByLineCount(lineCount)
  return (self.charHeight + __CHAR_EXTRA_HEIGHT) * lineCount
end

function UIAllianceStarMainChatBottom:SetInputFieldTextHeight()
  local textTotalHeight = self:GetInputFieldTextHeightByLineCount(self.inputLineCount)
  self.inputMsgText:SetSizeDeltaXY(self.inputMsgText:GetSizeDelta().x, textTotalHeight)
  self.inputMsgHolder:SetSizeDeltaXY(self.inputMsgHolder:GetSizeDelta().x, textTotalHeight)
end

function UIAllianceStarMainChatBottom:SetInputFieldTextToMid()
  local toMidOffset = (__DEFAULT_INPUT_MSG_HEIGHT - self.charHeight - __CHAR_EXTRA_HEIGHT) / 2
  self.inputMsgText:SetAnchoredPositionXY(self.inputMsgText:GetAnchoredPositionX(), toMidOffset)
  self.inputMsgHolder:SetAnchoredPositionXY(self.inputMsgHolder:GetAnchoredPositionX(), toMidOffset)
end

function UIAllianceStarMainChatBottom:InitFuncsRedDotData()
  self.chatBottomFuncData = {
    {
      funcType = ChatBottomFuncConfig.RedPackage,
      redDotNum = 0
    }
  }
  self:UpdateRedPacketDotData()
end

function UIAllianceStarMainChatBottom:SetFuncsRedDotState()
  local redPacketDotState = CommonUtil.PlayerPrefsGetInt(SettingKeys.CHAT_BOTTOM_FUNC_RED_DOT_BY_RED_PACKET, 0)
  self.areaFuncRedDot:SetActive(0 < redPacketDotState and 0 < self:GetTotalFuncRedDotNum())
end

function UIAllianceStarMainChatBottom:UpdateRedPacketDotData()
  local count = DataCenter.RedPacketManager:GetRedPackRedDot()
  self:SetFuncRedDotNumByType(ChatBottomFuncConfig.RedPackage, count)
end

function UIAllianceStarMainChatBottom:GetFuncRedDotNumByType(funcType)
  for _, funcData in ipairs(self.chatBottomFuncData) do
    if funcData.funcType == funcType then
      return funcData.redDotNum
    end
  end
end

function UIAllianceStarMainChatBottom:SetFuncRedDotNumByType(funcType, redDotNum)
  for _, funcData in ipairs(self.chatBottomFuncData) do
    if funcData.funcType == funcType then
      funcData.redDotNum = redDotNum
      return
    end
  end
end

function UIAllianceStarMainChatBottom:GetTotalFuncRedDotNum()
  local sum = 0
  for _, funcData in ipairs(self.chatBottomFuncData) do
    sum = sum + funcData.redDotNum
  end
  return sum
end

function UIAllianceStarMainChatBottom:OnClickBack()
  self.resetPopPanelType = PanelTypeEnum.None
  self:SetPopUpPanelDataByType(PanelTypeEnum.None)
  self:__UpdateHeight(isShowImmediately, true)
  self.view:OnClickBack()
end

function UIAllianceStarMainChatBottom:DeleteButtonClick()
  if self:IsOnAndroidOrIOS() then
    self.inputMsgMobile:DeleteButtonClick()
  end
end

function UIAllianceStarMainChatBottom:SendMessage()
  self:OnClickSend()
end

function UIAllianceStarMainChatBottom:OnClickSend(keyboard)
  if string.IsNullOrEmpty(self:GetDiffInputMsgText()) then
    return
  end
  if not keyboard then
    __ChatPostBI(ChatBIEnum.ChatMsgSendClick, {source = "button"})
  end
  self.view.ctrl:SendMessage(self:GetDiffInputMsgText(), 0, PostType.Text_Normal, {isSendEmoji = false})
  self:SetDiffInputMsgText("")
  if ChatInterface.IsTranslateAllOpen() and self.holder and self.holder.middle and self.holder.middle.scrollMsgs then
    self.holder.middle.scrollMsgs:ScrollToTail()
  end
end

function UIAllianceStarMainChatBottom:OnClickEmoji()
  if not self.areaEmoji:GetActive() then
    self.resetPopPanelType = PanelTypeEnum.EmojiPanel
    self:SetPopUpPanelDataByType(PanelTypeEnum.EmojiPanel)
  else
    self.resetPopPanelType = PanelTypeEnum.None
    self:SetPopUpPanelDataByType(PanelTypeEnum.None)
  end
  self:__UpdateHeight(isShowImmediately)
end

function UIAllianceStarMainChatBottom:OnClickFuncs()
  CommonUtil.PlayerPrefsSetInt(SettingKeys.CHAT_BOTTOM_FUNC_RED_DOT_BY_RED_PACKET, 0)
  self.areaFuncRedDot:SetActive(false)
  if not self.areaFunc:GetActive() then
    self.resetPopPanelType = PanelTypeEnum.FuncsPanel
    self:SetPopUpPanelDataByType(PanelTypeEnum.FuncsPanel)
  else
    self.resetPopPanelType = PanelTypeEnum.None
    self:SetPopUpPanelDataByType(PanelTypeEnum.None)
  end
  self:__UpdateHeight(isShowImmediately)
end

function UIAllianceStarMainChatBottom:OnClickBtnKeyboard()
  self.resetPopPanelType = PanelTypeEnum.None
  self:SetUMIFocus(true)
end

function UIAllianceStarMainChatBottom:OnInputMsgChanged(value)
  local currRoom = self.holder:GetSelectedRoom()
  if currRoom then
    currRoom:SetTempText(value)
  end
  self:SetSendOrFuncActive(true, value)
end

function UIAllianceStarMainChatBottom:OnClosePopUpKeyboard()
  self:SetPopUpPanelDataByType(PanelTypeEnum.None)
  self:__UpdateHeight(isShowImmediately)
end

function UIAllianceStarMainChatBottom:OnSetReply(replyMsg)
  self:SetReply(replyMsg)
  self:__UpdateHeight(isShowImmediately)
end

local __IGNORE_WHITE_LIST = {
  UIWindowNames.UIChatNew_v2,
  UIWindowNames.UICommonIntroTip,
  UIWindowNames.UICommonUseItemTip,
  UIWindowNames.UICommonMessageSpecialBar,
  UIWindowNames.UICommonMessageBar,
  UIWindowNames.UICommonSingleMsgBar,
  UIWindowNames.UIPermanentTips,
  UIWindowNames.UINoticeTips,
  UIWindowNames.UINoticeHeroTips,
  UIWindowNames.UICommonBuyItem,
  UIWindowNames.UICommonUseResItemTips,
  UIWindowNames.UICommonItemProbability,
  UIWindowNames.LWUIMasteryExpGet,
  UIWindowNames.UIGetDuelScoreTip,
  UIWindowNames.UIOfficialMessageBar,
  UIWindowNames.UICommonMessageBarOld,
  UIWindowNames.UIAttackUnitsTips,
  UIWindowNames.LWUITCExpGet,
  UIWindowNames.UIBattleMessageBar
}

function UIAllianceStarMainChatBottom:SetInputActive(active)
  self.inputMsgUnity.gameObject:SetActive(active)
  self.inputMsgHolder.gameObject:SetActive(active)
  self.btnEmoji.gameObject:SetActive(active)
  self:SetSendOrFuncActive(active)
end

function UIAllianceStarMainChatBottom:SetInputMsgText(textId)
  local id = textId or 2900000
  self.inputMsgHolder:SetLocalText(id)
  self.inputMsgPCHolder:SetLocalText(id)
end

function UIAllianceStarMainChatBottom:IsCover(wind)
  if not wind then
    return false
  end
  local isBottom = true
  local windowStack = UIManager.Instance.windowStack
  while wind and isBottom do
    wind = windowStack:next(wind)
    if wind and wind.value then
      local config = UIManager.Instance:GetWindowConfig(wind.value.Name)
      if config ~= nil and config.Layer == UILayer.Normal then
        isBottom = false
      end
    end
  end
  return isBottom
end

function UIAllianceStarMainChatBottom:GetWindowIsBottom()
  if UIManager.Instance:HasWindowByLayer(UILayer.Dialog) then
    return false
  end
  local window = UIManager.Instance:GetWindow(self.view.__name)
  if window then
    local wind = UIManager.Instance.windowStack:find(window)
    return self:IsCover(wind)
  end
  return false
end

function UIAllianceStarMainChatBottom:SetKeyboardActive(isOn)
  self:SetUMIVisible(isOn)
  self.forceHiddenKeyboard = not isOn
end

function UIAllianceStarMainChatBottom:OnWindowOpened(windowName)
  if self.forceHiddenKeyboard then
    return
  end
  if table.indexof(__IGNORE_WHITE_LIST, windowName) then
    return
  end
  if not self.inputMsgMobile then
    return
  end
  if not self.inputMsgUnity or IsNull(self.inputMsgUnity.gameObject) or not self.inputMsgUnity.gameObject.activeSelf then
    return
  end
  if windowName == UIWindowNames.UICommonMessageTip then
    self:SetUMIFocus(false)
    self:SetUMIVisible(false)
    self.hiddenKeyboard = true
    return
  end
  local isCover = self:GetWindowIsBottom()
  if not isCover then
    self:SetUMIFocus(isCover)
    self:SetUMIVisible(isCover)
    self.hiddenKeyboard = true
  end
end

function UIAllianceStarMainChatBottom:OnWindowClosed(windowName)
  if self.forceHiddenKeyboard then
    return
  end
  if not self.inputMsgMobile then
    return
  end
  local isCover = self:GetWindowIsBottom()
  if isCover and self.hiddenKeyboard then
    self:SetUMIVisible(isCover)
    self.hiddenKeyboard = false
  end
end

function UIAllianceStarMainChatBottom:UpdateRedPacketDot()
  self:InitFuncsRedDotData()
  self:SetFuncsRedDotState()
  self.areaFunc:ShowFuncsPanel()
end

function UIAllianceStarMainChatBottom:SetCharHeight()
  if self:IsOnAndroidOrIOS() then
    self.charHeight = self:__CalcKeyboardHeight(self.inputMsgMobile.charHeight)
  end
end

function UIAllianceStarMainChatBottom:SelectRoom()
  if self.areaFunc:GetActive() then
    self.areaFunc:ClearLoadingFuncItem()
    self.areaFunc:ShowFuncsPanel()
  end
end

function UIAllianceStarMainChatBottom:IsOnAndroidOrIOS()
  return (CS.SDKManager.IS_UNITY_ANDROID() or CS.SDKManager.IS_UNITY_IOS()) and not CS.SDKManager.IS_UNITY_EDITOR()
end

function UIAllianceStarMainChatBottom:IsOnEditorOrPC()
  return CS.SDKManager.IS_UNITY_EDITOR() or Config.IsPC()
end

function UIAllianceStarMainChatBottom:SetUMIVisible(state)
  if not self:IsOnAndroidOrIOS() then
    return
  end
  self.inputMsgMobile:SetVisible(state)
end

function UIAllianceStarMainChatBottom:SetUMIFocus(state)
  if self:IsOnAndroidOrIOS() then
    self.inputMsgMobile:SetFocus(state)
  elseif self.inputMsgUnity.unity_tmpinput then
    if state then
      self.inputMsgUnity.unity_tmpinput:ActivateInputField()
    else
      self.inputMsgUnity.unity_tmpinput:DeactivateInputField()
    end
  end
end

function UIAllianceStarMainChatBottom:SetDiffInputMsgText(text)
  if self:IsOnAndroidOrIOS() then
    self.inputMsgMobile.Text = text
  else
    self.inputMsgUnity:SetText(text)
  end
end

function UIAllianceStarMainChatBottom:GetDiffInputMsgText()
  if self:IsOnAndroidOrIOS() then
    if not self.inputMsgMobile then
      Logger.LogError("inputMsgMobile\231\169\186")
    end
    if not self.inputMsgMobile.Text then
      Logger.LogError("inputMsgMobileText\231\169\186")
    end
    return self.inputMsgMobile and self.inputMsgMobile.Text
  else
    return self.inputMsgUnity:GetText()
  end
end

function UIAllianceStarMainChatBottom:RefreshChatItemCell()
  self.page:InitEmojiText()
  self:RefreshEntries()
end

local function __GetTextColor(textColorSelfAlliance)
  if textColorSelfAlliance == true then
    return ChatColorAlliance
  end
  return ChatColorNormal
end

local function __CreateEntry_GMEmpty()
  local param = {}
  param.uid = ChatGMUserId
  param.name = Localization:GetString("290046", Localization:GetString("100619"))
  param.head = ChatGMUserIcon
  param.headPicVer = 0
  param.sign = ""
  return param
end

local function __CreateEntry_Empty(channelName, roomId)
  local param = {}
  param.uid = LuaEntry.Player:GetUid()
  param.name = Localization:GetString("290046", channelName)
  param.head = LuaEntry.Player:GetPic()
  param.headPicVer = LuaEntry.Player.picVer
  param.sign = ""
  param.isEmpty = true
  if roomId == ChatGMRoomId then
    param.uid = ChatGMUserId
    param.head = ChatGMUserIcon
    param.headPicVer = 0
  end
  return param
end

local function __CreateEntry_Chat(roomId, chatData)
  local _senderUid = chatData.senderUid
  local _userinfo = ChatInterface.getUserData(_senderUid)
  local name = _userinfo:GetUserName()
  if name == _userinfo.uid then
    name = " "
  end
  if chatData:isFromAI() then
    name = chatData:getSenderName()
  end
  local param = {}
  param.uid = _userinfo.uid
  param.textColorSelfAlliance = false
  param.name = name
  param.des = chatData:getMessageWithExtra(false)
  local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  if allianceData ~= nil and _userinfo.allianceSimpleName == allianceData.abbr and allianceData.abbr ~= "" then
    param.textColorSelfAlliance = true
  end
  param.shareData = chatData:getMessageParam(false)
  param.roomId = chatData.roomId
  param.seqId = chatData.seqId
  local head = _userinfo.headPic or ""
  if _userinfo:IsGmUser() then
    head = _userinfo:GetGMIcon()
  end
  param.head = head
  param.headPicVer = _userinfo.headPicVer or 0
  param.time = chatData.serverTime
  param.sign = chatData.senderUid .. chatData.msg .. math.ceil(param.time / 10000)
  return param
end

local function __CreateThreeEntries(roomId)
  local data1, data2, data3
  if roomId == nil or roomId == "" then
    return data1, data2, data3
  end
  local lastThreeMsg = ChatInterface.getRoomMgr():GetLastChatMsgs(roomId, 3)
  if not lastThreeMsg or #lastThreeMsg <= 0 then
    if roomId == ChatGMRoomId then
      data1 = __CreateEntry_GMEmpty()
    else
      local roomData = ChatInterface.getRoomData(roomId)
      data1 = __CreateEntry_Empty(roomData and roomData:getRoomName() or "")
    end
    return data1, data2, data3
  else
    if lastThreeMsg[1] then
      data1 = __CreateEntry_Chat(roomId, lastThreeMsg[1])
    end
    if lastThreeMsg[2] then
      data2 = __CreateEntry_Chat(roomId, lastThreeMsg[2])
    end
    if lastThreeMsg[3] then
      data3 = __CreateEntry_Chat(roomId, lastThreeMsg[3])
    end
  end
  return data1, data2, data3
end

function UIAllianceStarMainChatBottom:RefreshEntries()
  local roomId = ChatInterface.getRoomMgr():GetAllianceRoomId()
  local chat1, chat2, chat3 = __CreateThreeEntries(roomId)
  if not ChatInterface.getRoomMgr():IsExistRoomId(roomId) then
    chat1 = {
      name = Localization:GetString("2700020"),
      des = "",
      uid = nil
    }
  end
  local page = self.page
  if page then
    page:SetChatTextAndColor(3, "", "")
    page:SetChatTextAndColor(2, "", "")
    page:SetChatTextAndColor(1, "", "")
    if chat1 then
      local showName1 = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(chat1.uid, chat1.name)
      page:SetChatTextAndColor(3, showName1, chat1.des, __GetTextColor(chat1.textColorSelfAlliance), chat1)
    end
    if chat2 then
      local showName2 = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(chat2.uid, chat2.name)
      page:SetChatTextAndColor(2, showName2, chat2.des, __GetTextColor(chat2.textColorSelfAlliance), chat2)
    end
    if chat3 then
      local showName3 = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(chat3.uid, chat3.name)
      page:SetChatTextAndColor(1, showName3, chat3.des, __GetTextColor(chat3.textColorSelfAlliance), chat3)
    end
  end
end

function UIAllianceStarMainChatBottom:OnChatDelMsg(serverData)
  if self.page and self.page.GetDataById and self.page:GetDataById(serverData.roomid, serverData.seqId) then
    self:RefreshEntries()
  end
end

function UIAllianceStarMainChatBottom:OnReceiveChatMessage(chatData)
  if not chatData then
    return
  end
  if table.indexof(POST_TYPE_BLACK_LIST, chatData.post) then
    return
  end
  if not ChatManager2:GetInstance().Restrict:GetMsgIsCanShow(chatData) then
    return
  end
  self:RefreshEntries()
  self.view:CheckAddAllyBubble(chatData)
end

return UIAllianceStarMainChatBottom
