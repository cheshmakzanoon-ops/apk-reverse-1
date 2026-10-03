local base = UIBaseContainer
local LWUIActEasterEggChatBottom = BaseClass("LWUIActEasterEggChatBottom", base)
local M = LWUIActEasterEggChatBottom
local LWUIActEasterEggEmojiArea_v2 = require("UI.LWUIActEasterEgg.LWUIActEasterEggChat.Component.LWUIActEasterEggEmojiArea_v2")
local UIReplyArea = require("UI.LWUIActEasterEgg.LWUIActEasterEggChat.Component.LWUIActEasterEggChatReplyArea_v2")
local PanelTypeEnum = _ENV.PanelTypeEnum
local Regex = CS.System.Text.RegularExpressions.Regex
local __EMOJI_HEIGHT = 410
local __DEFAULT_INPUT_MSG_HEIGHT = 81
local __CHAR_EXTRA_HEIGHT = 0.8
local __ANONYMOUS_AREA_HEIGHT = 150
local __DEFAULT_INPUT_HEIGHT = 95

function M:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:SetInputCompsActive(true)
  if self.IsOnAndroidOrIOS() then
    self:SetInputHeightDataByLineCount_Mobile()
  end
  self:SetPopUpPanelDataByType(PanelTypeEnum.None)
  self:SetMobileKeyboardActive(false)
  self:SetInputMsgText()
  self:SetDiffInputMsgText("")
  self:__UpdateHeight()
  self:RefreshAnonymousState()
end

function M:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function M:ComponentDefine()
  self.layoutElement = self:AddComponent(UILayoutElement, "")
  self.areaInput = self:AddComponent(UIBaseContainer, "areaInput")
  self.btnSend = self:AddComponent(UIButton, "areaInput/btnSend")
  self.btnSend:SetOnClick(function()
    self:OnClickSend()
  end)
  self.btnKeyboard = self:AddComponent(UIButton, "areaInput/btnKeyboard")
  self.btnKeyboard:SetOnClick(function()
    self:OnClickBtnKeyboard()
  end)
  self.btnKeyboard:SetActive(false)
  self.btnEmoji = self:AddComponent(UIButton, "areaInput/btnEmoji")
  self.btnEmoji:SetOnClick(function()
    self:OnClickEmoji()
  end)
  self.inputMsgHolder = self:AddComponent(UIText, "areaInput/inputMsgMobile/holder")
  self.inputMsgHolder:SetLocalText(2900000)
  self.inputMsgText = self:AddComponent(UIText, "areaInput/inputMsgMobile/text")
  self.inputMsgPCTextArea = self:AddComponent(UIBaseContainer, "areaInput/inputMsgPC/Text Area")
  self.inputMsgPCHolder = self:AddComponent(UITextMeshProUGUIEx, "areaInput/inputMsgPC/Text Area/Placeholder")
  self.inputMsgPCText = self:AddComponent(UITextMeshProUGUIEx, "areaInput/inputMsgPC/Text Area/Text")
  self.inputMsgPCBg = self:AddComponent(UIImage, "areaInput/inputMsgPC")
  self.areaEmoji = self:AddComponent(LWUIActEasterEggEmojiArea_v2, "areaEmoji")
  self.areaEmoji:SetActive(false)
  self.btnSetting = self:AddComponent(UIButton, "areaAnonymous/Root/btnSetting")
  self.btnSetting:SetOnClick(function()
    self:OnBtnSettingClick()
  end)
  self.btnAnonymous = self:AddComponent(UIButton, "areaAnonymous/Root/btnAnonymous")
  self.btnAnonymous:SetOnClick(function()
    self:OnBtnAnonymousClick()
  end)
  self.compIconBtnOn = self:AddComponent(UIBaseContainer, "areaAnonymous/Root/btnAnonymous/iconBtnOn")
  self.compSunglasses = self:AddComponent(UIBaseContainer, "areaAnonymous/Root/AnonymousIcon/sunglasses")
  self.textAnonymousTitle = self:AddComponent(UITextMeshProUGUIEx, "areaAnonymous/Root/Title")
  self.textAnonymousTitle:SetLocalText("activity_99144_ui_57")
  local inputMsgMobile = self:AddComponent(UIInput, "areaInput/inputMsgMobile")
  local inputMsgPC = self:AddComponent(UIInput, "areaInput/inputMsgPC")
  inputMsgMobile:SetActive(self:IsOnAndroidOrIOS())
  inputMsgPC:SetActive(not self:IsOnAndroidOrIOS())
  self.inputMsgUnity = self:IsOnAndroidOrIOS() and inputMsgMobile or inputMsgPC
  if self:IsOnAndroidOrIOS() then
    self.inputMsgMobile = self.inputMsgUnity.gameObject:GetComponent(typeof(CS.Mopsicus.Plugins.MobileInputField))
    self.mobilId = self.inputMsgMobile:GetMobilId()
    
    function self.OnTextChangeFromPlatform(str)
      self:OnInputMsgChanged(str)
      self:OnInputMsgChanged_UpadteHeight_Mobile(str)
    end
    
    function self.OnShowKeyboard(mobilId, isShow, height, navHeight)
      if ChatInterface.GetMobilSupportMultiple() and mobilId ~= self.mobilId then
        return
      end
      local keyboardHeight = self:__CalcKeyboardHeight(height)
      self:SetMobileKeyboardActive(isShow, keyboardHeight)
      self:__UpdateHeight()
    end
    
    if ChatInterface.GetMobilSupportMultiple() then
      self.inputMsgMobile.OnShowKeyboard = self.OnShowKeyboard
      self.inputMsgMobile.OnTextChangeFromPlatform = self.OnTextChangeFromPlatform
    else
      CS.Mopsicus.Plugins.MobileInput.OnShowKeyboard = self.OnShowKeyboard
      CS.Mopsicus.Plugins.MobileInput.OnTextChangeFromPlatform = self.OnTextChangeFromPlatform
    end
    
    function self.__mobileInputField_OnReturnPressed()
      self:OnClickSend()
    end
    
    self.inputMsgMobile.OnReturnPressedEvent:AddListener(self.__mobileInputField_OnReturnPressed)
    self.hiddenKeyboard = nil
    self:SetUMIVisible(false)
    self:SetUMIFocus(false)
    self.areaEmoji:SetMobilInputId(self.mobilId)
  else
    ChatInterface.SetEmojiTextProperty(self.inputMsgPCText)
  end
  local holderColor = ChatUIThemeConfig.InputHolderColor[ChatUIThemeConfig.ChatMode.Normal]
  local textColor = ChatUIThemeConfig.InputTextColor[ChatUIThemeConfig.ChatMode.Normal]
  local mobilBackGroundColor = ChatUIThemeConfig.MobilBackGroundColor[ChatUIThemeConfig.ChatMode.Normal]
  self:SetHolderColor(holderColor, textColor, mobilBackGroundColor)
  self.areaReply = self:AddComponent(UIReplyArea, "areaReply_TMP")
  self.areaReply:SetActive(false)
  self.areaEmoji:SetDeleteCallBack(function()
    self:DeleteButtonClick()
  end)
  self.areaEmoji:SetSendCallBack(function()
    self:OnClickSend()
  end)
  self.prePanelType = nil
  if self:IsOnAndroidOrIOS() then
    self:SetInputFieldTextToMid()
  end
  self.resetPopPanelType = PanelTypeEnum.None
  self.inputMsgUnity:SetOnValueChange(function(value)
    if CS.SDKManager.IS_UNITY_EDITOR() or Config.IsPC() then
      self:OnInputMsgChanged(value)
      self:OnInputMsgChanged_UpadteHeight_PC(value)
    end
  end)
  self.inputMsgUnity:SetText("")
end

function M:ComponentDestroy()
  self.layoutElement = nil
  self.areaInput = nil
  self.btnSend = nil
  self.btnBack = nil
  self.btnKeyboard = nil
  self.btnEmoji = nil
  self.inputMsgHolder = nil
  self.inputMsgText = nil
  self.inputMsgPCTextArea = nil
  self.inputMsgPCHolder = nil
  self.inputMsgPCText = nil
  self.inputMsgPCBg = nil
  self.areaEmoji = nil
  self.inputMsgUnity = nil
  self.btnSetting = nil
  self.btnAnonymous = nil
  self.compIconBtnOn = nil
  self.compSunglasses = nil
  self.textAnonymousTitle = nil
end

function M:DataDefine()
  self.inputLineCount = 1
  self.inputHeight = __DEFAULT_INPUT_HEIGHT
  self.replyAreaHeight = 0
  self.charHeight = 44
  self.keyboardHeight = 0
  self.mobilId = nil
  self.emojiAreaHight = 0
end

function M:DataDestroy()
  self.resetPopPanelType = PanelTypeEnum.None
  self:SetPopUpPanelDataByType(PanelTypeEnum.None)
  self:__UpdateHeight()
  self.mobilId = nil
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
  self.prePanelType = nil
end

function M:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GF_window_opened, self.OnWindowOpened)
  self:AddUIListener(EventId.GF_window_closed, self.OnWindowClosed)
  self:AddUIListener(EventId.SetReplyChatMsg, self.OnSetReply)
  self:AddUIListener(EventId.Chat_Emoji_Clcik, self.OnEmojiClick)
  self:AddUIListener(ChatEventEnum.CHAT_CLOSE_POP_UP_KEYBOARD, self.OnClosePopUpKeyboard)
  self:AddUIListener(EventId.UMIRefreshCharHeight, self.SetCharHeight)
  self:AddUIListener(EventId.EasterEggGetActivityUpdateAnonymousState, self.RefreshAnonymousState)
  if self:IsOnEditorOrPC() and not self.updateTimer then
    function self.updateTimer()
      self:OnUpdate()
    end
    
    UpdateManager:GetInstance():AddUpdate(self.updateTimer)
  end
end

function M:OnRemoveListener()
  if self:IsOnEditorOrPC() and self.updateTimer then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.updateTimer = nil
  end
  self:RemoveUIListener(EventId.GF_window_opened, self.OnWindowOpened)
  self:RemoveUIListener(EventId.GF_window_closed, self.OnWindowClosed)
  self:RemoveUIListener(EventId.SetReplyChatMsg, self.OnSetReply)
  self:RemoveUIListener(EventId.Chat_Emoji_Clcik, self.OnEmojiClick)
  self:RemoveUIListener(ChatEventEnum.CHAT_CLOSE_POP_UP_KEYBOARD, self.OnClosePopUpKeyboard)
  self:RemoveUIListener(EventId.UMIRefreshCharHeight, self.SetCharHeight)
  self:RemoveUIListener(EventId.EasterEggGetActivityUpdateAnonymousState, self.RefreshAnonymousState)
  base.OnRemoveListener(self)
end

function M:OnEnable()
  base.OnEnable(self)
  self:SetInputFieldTextHeight()
end

function M:OnDisable()
  base.OnDisable(self)
end

function M:__UpdateHeight()
  local finalKeyboardHeight = self.keyboardHeight == 0 and 0 or self.keyboardHeight - 125
  local height = self.inputHeight + self.replyAreaHeight + math.max(finalKeyboardHeight, self.emojiAreaHight + __ANONYMOUS_AREA_HEIGHT)
  self.layoutElement.unity_LayoutElement.minHeight = height
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.transform.parent)
end

function M:OnUpdate()
  if self:IsOnEditorOrPC() and CS.UnityEngine.Input.GetKeyDown(CS.UnityEngine.KeyCode.Return) and self.btnSend:GetActive() then
    self:OnClickSend()
    self.inputMsgUnity.unity_tmpinput:ActivateInputField()
  end
end

function M:OnInputMsgChanged_UpadteHeight_PC(value)
  if not self:IsOnEditorOrPC() then
    return
  end
  local curLineCount = self:CountChatLinesInEditorAndPC(value)
  curLineCount = math.min(math.max(curLineCount, 1), 6)
  self.inputLineCount = curLineCount
  self:SetInputHeightDataByLineCount_PC(curLineCount)
  self:__UpdateHeight()
end

function M:CountChatLinesInEditorAndPC(str)
  self.inputMsgUnity.unity_tmpinput:InputFieldContentForceMeshUpdate()
  return self.inputMsgUnity.unity_tmpinput:GetInputFieldLineCount()
end

function M:SetInputHeightDataByLineCount_PC(lineCount)
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
  self.areaInput:SetAnchoredPositionXY(self.areaInput:GetAnchoredPositionX(), -self.replyAreaHeight)
  self.areaEmoji:SetAnchoredPositionXY(self.areaEmoji:GetAnchoredPositionX(), -self.inputHeight - self.replyAreaHeight)
end

function M:OnInputMsgChanged_UpadteHeight_Mobile(value)
  if not self:IsOnAndroidOrIOS() then
    return
  end
  local curLineCount = self.inputMsgMobile.lineCount
  curLineCount = math.min(math.max(curLineCount, 1), 6)
  if self.inputLineCount ~= curLineCount then
    self.inputLineCount = curLineCount
    self:SetInputHeightDataByLineCount_Mobile()
    self:__UpdateHeight()
  end
end

function M:SetInputHeightDataByLineCount_Mobile()
  local extraHeight = (self.charHeight + __CHAR_EXTRA_HEIGHT) * (self.inputLineCount - 1)
  self.inputHeight = __DEFAULT_INPUT_HEIGHT + extraHeight
  self.areaInput:SetSizeDeltaXY(self.areaInput:GetSizeDelta().x, self.inputHeight)
  self.inputMsgUnity:SetSizeDeltaXY(self.inputMsgUnity:GetSizeDelta().x, __DEFAULT_INPUT_MSG_HEIGHT + extraHeight)
  self:SetInputFieldTextHeight()
  self.areaInput:SetAnchoredPositionXY(self.areaInput:GetAnchoredPositionX(), -self.replyAreaHeight)
  self.areaEmoji:SetAnchoredPositionXY(self.areaEmoji:GetAnchoredPositionX(), -self.inputHeight - self.replyAreaHeight)
end

function M:SetInputFieldTextHeight()
  local textTotalHeight = self:GetInputFieldTextHeightByLineCount(self.inputLineCount)
  self.inputMsgText:SetSizeDeltaXY(self.inputMsgText:GetSizeDelta().x, textTotalHeight)
  self.inputMsgHolder:SetSizeDeltaXY(self.inputMsgHolder:GetSizeDelta().x, textTotalHeight)
end

function M:GetInputFieldTextHeightByLineCount(lineCount)
  return (self.charHeight + __CHAR_EXTRA_HEIGHT) * lineCount
end

function M:SetInputFieldTextToMid()
  local toMidOffset = (__DEFAULT_INPUT_MSG_HEIGHT - self.charHeight - __CHAR_EXTRA_HEIGHT) / 2
  self.inputMsgText:SetAnchoredPositionXY(self.inputMsgText:GetAnchoredPositionX(), toMidOffset)
  self.inputMsgHolder:SetAnchoredPositionXY(self.inputMsgHolder:GetAnchoredPositionX(), toMidOffset)
end

function M:SetCharHeight()
  if self:IsOnAndroidOrIOS() then
    self.charHeight = self:__CalcKeyboardHeight(self.inputMsgMobile.charHeight)
  end
end

function M:__CalcKeyboardHeight(height)
  local layer = UIManager:GetInstance():GetLayer(UILayer.Normal.Name)
  local uiFullHeight = layer.rectTransform.rect.height
  local keyboardHeight = uiFullHeight * height / Screen.height
  return keyboardHeight
end

function M:OnClosePopUpKeyboard()
  self:SetPopUpPanelDataByType(PanelTypeEnum.None)
  self:__UpdateHeight()
end

function M:SetDiffInputMsgText(text)
  if self:IsOnAndroidOrIOS() then
    self.inputMsgMobile.Text = text
  else
    self.inputMsgUnity:SetText(text)
  end
end

function M:GetDiffInputMsgText()
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

function M:SetUMIVisible(state)
  if not self:IsOnAndroidOrIOS() then
    return
  end
  self.inputMsgMobile:SetVisible(state)
end

function M:SetUMIFocus(state)
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

function M:IsOnAndroidOrIOS()
  return (CS.SDKManager.IS_UNITY_ANDROID() or CS.SDKManager.IS_UNITY_IOS()) and not CS.SDKManager.IS_UNITY_EDITOR()
end

function M:IsOnEditorOrPC()
  return CS.SDKManager.IS_UNITY_EDITOR() or Config.IsPC()
end

function M:OnInputMsgChanged(value)
  local currRoom = ChatManager2:GetInstance().Room:GetEasterEggRoom()
  if currRoom then
    currRoom:SetTempText(value)
  end
  self:SetSendRootActive(true, value)
end

function M:SetHolderColor(holderColor, textColor, mobilBackGroundColor)
  if self:IsOnAndroidOrIOS() then
    self.inputMsgMobile:SetMobilPlaceholderColor(holderColor.r, holderColor.g, holderColor.b, holderColor.a)
    self.inputMsgMobile:SetMobilTextColor(textColor.r, textColor.g, textColor.b, textColor.a)
    self.inputMsgMobile:SetMobilBackGroundColor(0, 0, 0, 0)
  else
    self.inputMsgUnity.unity_tmpinput.placeholder.color = Color.New(holderColor.r, holderColor.g, holderColor.b, holderColor.a)
    self.inputMsgUnity.unity_tmpinput.textComponent.color = Color.New(textColor.r, textColor.g, textColor.b, textColor.a)
    self.inputMsgPCBg:SetColor(Color.New(mobilBackGroundColor.r, mobilBackGroundColor.g, mobilBackGroundColor.b, mobilBackGroundColor.a))
  end
end

function M:SetInputCompsActive(active)
  if not active then
    self:SetUMIFocus(false)
  end
  self.inputMsgUnity:SetActive(active)
  self.btnEmoji:SetActive(active)
  self:SetSendRootActive(active)
end

function M:SetSendRootActive(active, str)
  self.btnSend:SetActive(true)
  local text = str or self:GetDiffInputMsgText()
  local isOn = string.IsNullOrEmpty(text)
  if ChatInterface.IsUnlockEmojiInput() and self.areaEmoji:GetActive() then
    self.areaEmoji:SendDeleteBtnSetGray(active and isOn)
  end
end

function M:SetMobileKeyboardActive(active, keyboardHeight)
  if active then
    self:SetPopUpPanelDataByType(PanelTypeEnum.Keyboard)
    self.view.middle:SetClickZoneActive(true, PanelTypeEnum.Keyboard, function()
      self:SetUMIFocus(false)
      self.resetPopPanelType = PanelTypeEnum.None
      self:__UpdateHeight()
    end)
    self.keyboardHeight = keyboardHeight
  else
    self.view.middle:SetClickZoneActive(false, PanelTypeEnum.Keyboard)
    self.keyboardHeight = 0
    if self.resetPopPanelType and self.resetPopPanelType ~= PanelTypeEnum.None then
      self:SetPopUpPanelDataByType(self.resetPopPanelType, true)
    end
  end
end

function M:SetPopUpPanelDataByType(boardType, isIgnoreSetFocus)
  local curBoardType = boardType or PanelTypeEnum.None
  self.areaEmoji:SetActive(curBoardType == PanelTypeEnum.EmojiPanel)
  if self:IsOnAndroidOrIOS() then
    self.btnKeyboard:SetActive(curBoardType == PanelTypeEnum.EmojiPanel)
  end
  if not isIgnoreSetFocus and curBoardType ~= PanelTypeEnum.Keyboard then
    self:SetUMIFocus(false)
  end
  self.emojiAreaHight = 0
  if curBoardType == PanelTypeEnum.None then
    self.view.middle:SetClickZoneActive(false, self.prePanelType)
  elseif curBoardType == PanelTypeEnum.EmojiPanel then
    self:ShowEmojiPanel()
  elseif curBoardType == PanelTypeEnum.FuncsPanel then
    Logger.LogError("\229\164\141\230\180\187\232\138\130\226\128\148\226\128\148\226\128\148\226\128\148\228\184\141\229\186\148\232\175\165\229\173\152\229\156\168\229\138\159\232\131\189\229\136\151\232\161\168\231\154\132\230\131\133\229\134\181")
    return
  end
  self.prePanelType = curBoardType
end

function M:SetReply(replyMsg)
  if replyMsg then
    self.areaReply:SetActive(true)
    local replyH = self.areaReply:GetReplyMsgHeight(replyMsg)
    self.replyAreaHeight = replyH < 40 and 90 or 130
    self.areaReply:SetSizeDeltaXY(self.areaReply:GetSizeDelta().x, self.replyAreaHeight)
    self.areaReply:SetReply(replyMsg)
  else
    self.replyAreaHeight = 0
    self.areaReply:SetActive(false)
  end
  self.areaInput:SetAnchoredPositionXY(self.areaInput:GetAnchoredPositionX(), -self.replyAreaHeight)
  self.areaEmoji:SetAnchoredPositionXY(self.areaEmoji:GetAnchoredPositionX(), -self.inputHeight - self.replyAreaHeight)
  local currRoom = ChatManager2:GetInstance().Room:GetEasterEggRoom()
  if currRoom then
    currRoom:SetTempReply(replyMsg)
  end
end

function M:ShowEmojiPanel()
  local isBtnGray = self:GetDiffInputMsgText() == ""
  self.areaEmoji:SendDeleteBtnSetGray(isBtnGray)
  self.areaEmoji:UpdateItems()
  self.view.middle:SetClickZoneActive(true, PanelTypeEnum.EmojiPanel, function()
    self.resetPopPanelType = PanelTypeEnum.None
    self:SetPopUpPanelDataByType(PanelTypeEnum.None)
    self:__UpdateHeight()
  end)
  self.emojiAreaHight = __EMOJI_HEIGHT
end

function M:OnEmojiClick(info)
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

function M:OnClickEmoji()
  if not self.areaEmoji:GetActive() then
    self.resetPopPanelType = PanelTypeEnum.EmojiPanel
    self:SetPopUpPanelDataByType(PanelTypeEnum.EmojiPanel)
  else
    self.resetPopPanelType = PanelTypeEnum.None
    self:SetPopUpPanelDataByType(PanelTypeEnum.None)
  end
  self:__UpdateHeight()
end

function M:OnClickBtnKeyboard()
  if self:IsOnAndroidOrIOS() then
    self.resetPopPanelType = PanelTypeEnum.None
    self:SetUMIFocus(true)
  else
    self.resetPopPanelType = PanelTypeEnum.None
    self:SetPopUpPanelDataByType(PanelTypeEnum.None)
    self:__UpdateHeight()
  end
end

function M:SetInputMsgText(textId)
  local id = textId or 2900000
  self.inputMsgHolder:SetLocalText(id)
  self.inputMsgPCHolder:SetLocalText(id)
end

function M:OnClickSend()
  local canSendMsg = DataCenter.ActEasterEggManager:CheckCanSendMsg()
  if not canSendMsg then
    return
  end
  local eggInfo = self.view:GetEggInfo()
  if eggInfo == nil then
    Logger.LogError("\229\164\141\230\180\187\232\138\130\226\128\148\226\128\148\226\128\148\226\128\148\231\130\185\229\135\187\229\143\145\233\128\129\232\175\132\232\174\186\230\151\182\239\188\140\228\184\187\231\149\140\233\157\162eggInfo\228\184\186\231\169\186\239\188\129")
    return
  end
  local posterInfo = eggInfo:GetPosterInfo()
  local extraData = {
    posterUuid = posterInfo.uid,
    eggUuid = eggInfo:GetId(),
    anonymousHead = DataCenter.ActEasterEggManager:GetCurAnonymousInfo(),
    answer = eggInfo:GetPlayerSelfAnswer()
  }
  self.view.ctrl:SendMessage(self:GetDiffInputMsgText(), 0, PostType.EasterEggChat, extraData)
  self:SetDiffInputMsgText("")
  self:OnSetReply(nil)
end

function M:DeleteButtonClick()
  if self:IsOnAndroidOrIOS() then
    self.inputMsgMobile:DeleteButtonClick()
  end
end

function M:OnSetReply(replyMsg)
  if replyMsg then
    local currRoom = ChatManager2:GetInstance().Room:GetEasterEggRoom()
    if replyMsg.roomId ~= currRoom.roomId then
      return
    end
  end
  self:SetReply(replyMsg)
  self:__UpdateHeight()
end

function M:OnBtnSettingClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIActEasterAnonymousEdit)
end

function M:OnBtnAnonymousClick()
  local isAnonymous = DataCenter.ActEasterEggManager:GetIsAnonymousState()
  DataCenter.ActEasterEggManager:SetIsAnonymousState(not isAnonymous)
end

function M:RefreshAnonymousState()
  local isAnonymous = DataCenter.ActEasterEggManager:GetIsAnonymousState()
  local compIconBtnOnPosX = 0
  if isAnonymous then
    compIconBtnOnPosX = 40
  end
  self.compIconBtnOn:SetAnchoredPositionXY(compIconBtnOnPosX, self.compIconBtnOn:GetAnchoredPositionY())
  self.compSunglasses:SetActive(isAnonymous)
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
  UIWindowNames.UIBattleMessageBar
}

function M:IsCover(wind)
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

function M:GetWindowIsBottom()
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

function M:OnWindowOpened(windowName)
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

function M:OnWindowClosed(windowName)
  if not self.inputMsgMobile then
    return
  end
  local isCover = self:GetWindowIsBottom()
  if isCover and self.hiddenKeyboard then
    self:SetUMIVisible(isCover)
    self.hiddenKeyboard = false
  end
end

return M
