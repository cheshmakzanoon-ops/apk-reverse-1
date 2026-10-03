local base = UIBaseContainer
local UIChatViewBottom_v2 = BaseClass("UIChatViewBottom_v2", base)
local UIEmojiArea = require("UI.UIChatNewV2.Component.UIChatViewEmojiArea_v2")
local UIFuncArea = require("UI.UIChatNewV2.Component.UIChatViewFuncArea_v2")
local UIReplyArea = require("UI.UIChatNewV2.Component.UIChatViewReplyArea_v2")
local SelectAtPlayerPanelView = require("UI.UIChatNewV2.Component.SelectAtPlayerPanelView")
local PanelTypeEnum = _ENV.PanelTypeEnum
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local utf8Tools = require("Common/Tools/utf8")
local rapidjson = require("rapidjson")
local Regex = CS.System.Text.RegularExpressions.Regex
local MAX_AT_PLAYERS = 30
local ZeroWidthSpace = " \226\128\139"
local insertColor = "#249bc5"
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
    path = "areaInput/btnBatchDel",
    name = "btnBatchDel",
    type = UIButton,
    onClick = function(self)
      self:OnClickbtnBatchDel()
    end
  },
  {
    path = "areaInput/btnBatchDel/btnBatchDelText",
    name = "btnBatchDelText",
    type = UIText
  },
  {
    path = "areaInput/btnBatchDel",
    name = "btnBatchDelImg",
    type = UIImage
  },
  {
    path = "areaInput/btnNoticeBatchDel",
    name = "btnNoticeBatchDelBtn",
    type = UIButton,
    onClick = function(self)
      self:OnClickbtnNoticeBatchDel()
    end
  },
  {
    path = "areaInput/btnNoticeBatchDel/btnNoticeBatchDelText",
    name = "btnNoticeBatchDelText",
    type = UIText
  },
  {
    path = "areaInput/btnNoticeBatchDel",
    name = "btnNoticeBatchDelImg",
    type = UIImage
  },
  {
    path = "areaInput/btnNoticePost",
    name = "btnNoticePostBtn",
    type = UIButton,
    onClick = function(self)
      self:OnClickbtnNoticePost()
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
    type = UITextMeshProUGUIEx
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
    path = "SelectAtPlayerPanel",
    name = "atPanel",
    type = SelectAtPlayerPanelView,
    active = false
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

function UIChatViewBottom_v2:OnCreate()
  base.OnCreate(self)
  self:InitData()
  self:ComponentDefine()
  self:SetInputCompsActive(true)
  self:SetBatchBtnShow(false)
  self:SetNoticeBatchBtnShow(false)
  self.inputMsgUnity:SetText("")
  if self.IsOnAndroidOrIOS() then
    self:SetInputHeightDataByLineCount_Mobile()
  end
  self:SetPopUpPanelDataByType(PanelTypeEnum.None)
  self:SetMobileKeyboardActive(false)
  self:SetReply(nil)
  self:__UpdateHeight(isShowImmediately)
  self:OnChatAtEnd()
end

function UIChatViewBottom_v2:InitData()
  self.inputLineCount = 1
  self.inputHeight = 135
  self.replayAreaHeight = 0
  self.charHeight = 44
  self.keyboardHeight = 0
  self.forceHiddenKeyboard = false
  self.mobilId = nil
  self.emojiAreaHight = 0
  self.funcsAreaHeight = 0
  self.atMentionIndex = 0
  self.isBatchBtnShow = false
  self.isNoticeBatchBtnShow = false
end

function UIChatViewBottom_v2:OnDestroy()
  self:DestroyData()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIChatViewBottom_v2:DestroyData()
  self.forceHiddenKeyboard = nil
  self.mobilId = nil
  self.atMentionIndex = 0
end

function UIChatViewBottom_v2:ComponentDefine()
  self:DefineCompsByBook(compBook)
  local inputMsgMobile = self:AddComponent(UIInput, "areaInput/inputMsgMobile")
  local inputMsgPC = self:AddComponent(UIInput, "areaInput/inputMsgPC")
  inputMsgMobile:SetActive(self:IsOnAndroidOrIOS())
  inputMsgPC:SetActive(not self:IsOnAndroidOrIOS())
  self.inputMsgUnity = self:IsOnAndroidOrIOS() and inputMsgMobile or inputMsgPC
  if not self:IsOnAndroidOrIOS() then
    self.inputMention = self.inputMsgUnity.gameObject:GetComponent(typeof(CS.InputFieldMention))
  end
  
  function self.onTextInsertFunc(str1, str2, index)
    self:OnTextInsert(str1, str2, index)
  end
  
  function self.onTextDeleteFunc(str1, str2, index)
    self:OnTextDelete(str1, str2, index)
  end
  
  self.inputFieldTextListener = self.inputMsgUnity.gameObject:GetComponent(typeof(CS.InputFieldTextListener))
  self.inputFieldTextListener.OnTextInsertEvent:AddListener(self.onTextInsertFunc)
  self.inputFieldTextListener.OnTextDeleteEvent:AddListener(self.onTextDeleteFunc)
  local holderColor = ChatUIThemeConfig.InputHolderColor[ChatInterface.GetChatTheme()]
  local textColor = ChatUIThemeConfig.InputTextColor[ChatInterface.GetChatTheme()]
  local mobilBackGroundColor = ChatUIThemeConfig.MobilBackGroundColor[ChatInterface.GetChatTheme()]
  if self:IsOnAndroidOrIOS() then
    self.inputMsgMobile = self.inputMsgUnity.gameObject:GetComponent(typeof(CS.Mopsicus.Plugins.MobileInputField))
    self.mobilId = self.inputMsgMobile:GetMobilId()
    DataCenter.CacheData:MobilTestLogInfo(self.mobilId, self.view.__name)
    self.inputActive = self.inputMsgUnity.gameObject.activeSelf
    
    function self.OnTextChangeFromPlatform(str)
      self:OnInputMsgChanged(str)
      self:OnInputMsgChanged_UpadteHeight_Mobile(str)
    end
    
    function self.OnShowKeyboard(mobilId, isShow, height, navHeight)
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
    ChatInterface.SetEmojiTextProperty(self.inputMsgPCText)
  end
  self.areaReply = self:AddComponent(UIReplyArea, "areaReply_TMP")
  self.areaReply:SetActive(false)
  self.inputActive = self.inputMsgUnity.gameObject.activeSelf
  self.inputMsgUnity:SetOnValueChange(function(value)
    if CS.SDKManager.IS_UNITY_EDITOR() or Config.IsPC() then
      self:OnInputMsgChanged(value)
      self:OnInputMsgChanged_UpadteHeight_PC(value)
    end
  end)
  if self:IsOnEditorOrPC() then
    self.inputMsgUnity:SetOnPressEnter(function(value)
      self:OnPressEnterAction(value)
    end)
    
    function self.OnInputPassAction(str)
      self:OnInputPass(str)
    end
    
    self.inputMsgUnity.unity_tmpinput.OnPaste = self.OnInputPassAction
  end
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

function UIChatViewBottom_v2:OnInputPass(str)
  local url = DataCenter.LWNewsCenterManager:ReplaceWikiLink(str)
  if url then
    local curRoom = self.view:GetSelectedRoom()
    if curRoom then
      DataCenter.LWNewsCenterManager:OpenShareView(url, curRoom.roomId)
    end
  end
end

function UIChatViewBottom_v2:SetHolderColor(holderColor, textColor, mobilBackGroundColor)
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

function UIChatViewBottom_v2:ComponentDestroy()
  self:SetUMIFocus(false)
  self.inputFieldTextListener.OnTextInsertEvent:RemoveListener(self.onTextInsertFunc)
  self.inputFieldTextListener.OnTextDeleteEvent:RemoveListener(self.onTextDeleteFunc)
  self.onTextInsertFunc = nil
  self.onTextDeleteFunc = nil
  self.inputFieldTextListener = nil
  if self:IsOnEditorOrPC() then
    self.inputMsgUnity.unity_tmpinput.OnPaste = nil
  end
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

function UIChatViewBottom_v2:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GF_window_opened, self.OnWindowOpened)
  self:AddUIListener(EventId.GF_window_closed, self.OnWindowClosed)
  self:AddUIListener(EventId.SetReplyChatMsg, self.OnSetReply)
  self:AddUIListener(EventId.Chat_Emoji_Clcik, self.OnEmojiClick)
  self:AddUIListener(ChatEventEnum.CHAT_CLOSE_POP_UP_KEYBOARD, self.OnClosePopUpKeyboard)
  self:AddUIListener(ChatEventEnum.CHAT_ON_INPUT_ADD_AT_PLAYER, self.OnInputAddAtPlayer)
  self:AddUIListener(ChatEventEnum.CHAT_ON_LONG_CLICK_ADD_AT_PLAYER, self.OnLongClickAddAtPlayer)
  self:AddUIListener(EventId.RefreshBagRedDot, self.UpdateRedPacketDot)
  self:AddUIListener(EventId.UMIRefreshCharHeight, self.SetCharHeight)
  self:AddUIListener(ChatEventEnum.CHAT_ROOM_SEL, self.SelectRoom)
  self:AddUIListener(EventId.ChatPrivateShowTypeChange, self.PrivateChatShowChange)
  self:AddUIListener(EventId.ChatPrivateBatchDelSelectChange, self.PrivateChatShowChange)
  self:AddUIListener(EventId.ChatAlNoticeShowTypeChange, self.AlNoticeChatShowChange)
  self:AddUIListener(EventId.ChatAtMentionDelete, self.OnMentionDelete)
  self:AddUIListener(EventId.CHAT_CANCELMSG_EDITOR_CLICK, self.InsertMsgText)
  if self:IsOnEditorOrPC() and not self.updateTimer then
    function self.updateTimer()
      self:OnUpdate()
    end
    
    UpdateManager:GetInstance():AddUpdate(self.updateTimer)
  end
end

function UIChatViewBottom_v2:InsertMsgText(msg)
  if self:IsOnAndroidOrIOS() then
    self.inputMsgMobile:InsertTextAndScroll(msg, false)
    self.inputMsgMobile:SetFocus(true)
  else
    self.inputMsgUnity:InsertStrInCaretPos(msg)
  end
end

function UIChatViewBottom_v2:OnRemoveListener()
  if self:IsOnEditorOrPC() and self.updateTimer then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.updateTimer = nil
  end
  self:RemoveUIListener(EventId.GF_window_opened, self.OnWindowOpened)
  self:RemoveUIListener(EventId.GF_window_closed, self.OnWindowClosed)
  self:RemoveUIListener(EventId.SetReplyChatMsg, self.OnSetReply)
  self:RemoveUIListener(ChatEventEnum.CHAT_CLOSE_POP_UP_KEYBOARD, self.OnClosePopUpKeyboard)
  self:RemoveUIListener(ChatEventEnum.CHAT_ON_INPUT_ADD_AT_PLAYER, self.OnInputAddAtPlayer)
  self:RemoveUIListener(ChatEventEnum.CHAT_ON_LONG_CLICK_ADD_AT_PLAYER, self.OnLongClickAddAtPlayer)
  self:RemoveUIListener(EventId.RefreshBagRedDot, self.UpdateRedPacketDot)
  self:RemoveUIListener(EventId.UMIRefreshCharHeight, self.SetCharHeight)
  self:RemoveUIListener(EventId.Chat_Emoji_Clcik, self.OnEmojiClick)
  self:RemoveUIListener(ChatEventEnum.CHAT_ROOM_SEL, self.SelectRoom)
  self:RemoveUIListener(EventId.ChatPrivateShowTypeChange, self.PrivateChatShowChange)
  self:RemoveUIListener(EventId.ChatPrivateBatchDelSelectChange, self.PrivateChatShowChange)
  self:RemoveUIListener(EventId.ChatAlNoticeShowTypeChange, self.AlNoticeChatShowChange)
  self:RemoveUIListener(EventId.ChatAtMentionDelete, self.OnMentionDelete)
  self:RemoveUIListener(EventId.CHAT_CANCELMSG_EDITOR_CLICK, self.InsertMsgText)
  base.OnRemoveListener(self)
end

function UIChatViewBottom_v2:OnUpdate()
end

function UIChatViewBottom_v2:OnPressEnterAction(val)
  if self:IsOnEditorOrPC() and self.btnSend:GetActive() then
    __ChatPostBI(ChatBIEnum.ChatMsgSendClick, {source = "keyboard"})
    self:OnClickSend(true)
    self.inputMsgUnity.unity_tmpinput:ActivateInputField()
  end
end

function UIChatViewBottom_v2:OnEmojiClick(info)
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

function UIChatViewBottom_v2:OnEnable()
  base.OnEnable(self)
  self:InitFuncsRedDotData()
  self:SetFuncsRedDotState()
  self:SetInputFieldTextHeight()
end

function UIChatViewBottom_v2:OnDisable()
  self.chatBottomFuncData = nil
  base.OnDisable(self)
end

function UIChatViewBottom_v2:ResetInputAndReply(room)
  local active = room and not ChatInterface.GetIsMomentGroup(room.group) and room.group ~= ChatGroupType.GROUP_ALLIANCE_NOTICE
  if self.view and self.view.webView and active then
    active = not self.view.webView:GetActive()
  end
  self:OnSetReply(room and room.temp and room:GetCacheData().replyMsg or nil)
  local curText = room and room.temp and room:GetCacheData().text or ""
  if active and not self:IsOnAndroidOrIOS() then
    self:SetInputActive(active)
    self:SetDiffInputMsgText(curText)
  else
    self:SetDiffInputMsgText(curText)
    self:SetInputActive(active)
  end
  self:ResetAtInfo()
  self:SetCaretPosition(utf8Tools.len(curText))
end

function UIChatViewBottom_v2:__CalcKeyboardHeight(height)
  local layer = UIManager:GetInstance():GetLayer(UILayer.Normal.Name)
  local uiFullHeight = layer.rectTransform.rect.height
  local keyboardHeight = uiFullHeight * height / Screen.height
  return keyboardHeight
end

function UIChatViewBottom_v2:__UpdateHeight(immediately, isSkipRefreshMidArea)
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
    if not ChatInterface.IsTranslateAllOpen() and self.view and self.view.middle and self.view.middle.scrollMsgs and not isSkipRefreshMidArea then
      self.view.middle.scrollMsgs:ScrollToTail()
    end
  else
    self.__heightTween = self.layoutElement.unity_LayoutElement:DOMinSize(Vector2(0, height), 0.2):OnComplete(function()
      self.__heightTween = nil
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.transform.parent)
      if not ChatInterface.IsTranslateAllOpen() then
        self.view.middle.scrollMsgs:ScrollToTail()
      end
    end):OnUpdate(function()
      if not ChatInterface.IsTranslateAllOpen() then
        self.view.middle.scrollMsgs:ScrollToTail()
      end
    end)
  end
end

function UIChatViewBottom_v2:UpdateMsgContainerPosition(height)
  self.lastHeight = self.nowHeight
  self.nowHeight = height
  local containerTrans = self.view.middle.scrollMsgs._scrollView.unity_looplistview2.ContainerTrans
  local anchoredPosition = containerTrans.anchoredPosition
  if self.lastHeight then
    anchoredPosition.y = anchoredPosition.y + self.nowHeight - self.lastHeight
    containerTrans.anchoredPosition = anchoredPosition
  end
end

function UIChatViewBottom_v2:SetPopUpPanelDataByType(boardType, isIgnoreSetFocus)
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
    self.view.middle:SetClickZoneActive(false, self.prePanelType)
  elseif curBoardType == PanelTypeEnum.EmojiPanel then
    self:ShowEmojiPanel()
  elseif curBoardType == PanelTypeEnum.FuncsPanel then
    self.areaFunc:ClearLoadingFuncItem()
    self:ShowFuncsPanel()
  end
  self.prePanelType = curBoardType
end

function UIChatViewBottom_v2:ShowEmojiPanel()
  local isBtnGray = self:GetDiffInputMsgText() == ""
  self.areaEmoji:SendDeleteBtnSetGray(isBtnGray)
  self.areaEmoji:UpdateItems()
  self.view.middle:SetClickZoneActive(true, PanelTypeEnum.EmojiPanel, function()
    self.resetPopPanelType = PanelTypeEnum.None
    self:SetPopUpPanelDataByType(PanelTypeEnum.None)
    self:__UpdateHeight(isShowImmediately)
  end)
  self.emojiAreaHight = emojiHeight
end

function UIChatViewBottom_v2:ShowFuncsPanel()
  self.areaFunc:ShowFuncsPanel()
  self.view.middle:SetClickZoneActive(true, PanelTypeEnum.FuncsPanel, function()
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

function UIChatViewBottom_v2:SetMobileKeyboardActive(active, keyboardHeight)
  if active then
    self:SetPopUpPanelDataByType(PanelTypeEnum.Keyboard)
    self.view.middle:SetClickZoneActive(true, PanelTypeEnum.Keyboard, function()
      self:SetUMIFocus(false)
      self.resetPopPanelType = PanelTypeEnum.None
      self:__UpdateHeight(isShowImmediately)
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

function UIChatViewBottom_v2:SetInputCompsActive(active)
  if not active then
    self:SetUMIFocus(false)
  end
  self.inputMsgUnity:SetActive(active)
  self.btnEmoji:SetActive(active)
  self.areaFunc:ClearLoadingFuncItem()
  self:SetSendOrFuncActive(active)
  self:SetKeyboardActive(active)
  self:RefreshBatchDelBtn()
end

function UIChatViewBottom_v2:SetBatchBtnShow(active)
  self.isBatchBtnShow = active
  self:RefreshBatchDelBtn()
end

function UIChatViewBottom_v2:PrivateChatShowChange()
  self:RefreshBatchDelBtn()
end

function UIChatViewBottom_v2:AlNoticeChatShowChange()
  self:RefreshNoticeBatchDelBtn()
end

function UIChatViewBottom_v2:SetNoticeBatchBtnShow(active)
  self.isNoticeBatchBtnShow = active
  self:RefreshNoticeBatchDelBtn()
end

function UIChatViewBottom_v2:SetSendOrFuncActive(active, str)
  local text
  text = str or self:GetDiffInputMsgText()
  local isOn = string.IsNullOrEmpty(text)
  local send = active and not string.IsNullOrEmpty(text)
  self.btnSend:SetActive(send)
  self.btnFuncs:SetActive(active and isOn)
  if ChatInterface.IsUnlockEmojiInput() and self.areaEmoji:GetActive() then
    self.areaEmoji:SendDeleteBtnSetGray(active and isOn)
  end
end

function UIChatViewBottom_v2:RefreshBatchDelBtn()
  local isShow = false
  isShow = self.isBatchBtnShow
  local viewShowType = DataCenter.ChatPrivateDataManager:GetShowType()
  if isShow and (viewShowType == ChatPrivateListShowType.Normal or viewShowType == ChatPrivateListShowType.BatchDel) then
    self.btnBatchDel:SetActive(true)
    if viewShowType == ChatPrivateListShowType.Normal then
      self.btnBatchDelText:SetLocalText("multiple_selection")
      self.btnBatchDelImg:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_3.png")
      UIGray.SetGray(self.btnBatchDel.transform, false, true)
    elseif viewShowType == ChatPrivateListShowType.BatchDel then
      self.btnBatchDelText:SetLocalText("btn_delete")
      self.btnBatchDelImg:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_5.png")
      local selectDict = DataCenter.ChatPrivateDataManager:GetBatchDelDict()
      local isEmpty = table.IsEmpty(selectDict)
      if not isEmpty then
        UIGray.SetGray(self.btnBatchDel.transform, false, true)
      else
        UIGray.SetGray(self.btnBatchDel.transform, true, true)
      end
    end
  else
    self.btnBatchDel:SetActive(false)
  end
end

function UIChatViewBottom_v2:RefreshNoticeBatchDelBtn()
  local isShowInCurView = self.isNoticeBatchBtnShow
  local isShow = false
  local isPostNoticeBtnShow = false
  if isShowInCurView then
    local inAlliance = ChatInterface.isInAlliance()
    if inAlliance then
      local isR4orR5 = DataCenter.AllianceBaseDataManager:IsR4orR5()
      if isR4orR5 then
        isShow = true
        isPostNoticeBtnShow = true
      end
    end
  end
  if isShow then
    self.btnNoticeBatchDelBtn:SetActive(true)
    local viewShowType = DataCenter.ChatVieweDataManager:GetAlNoticeShowType()
    if viewShowType == ChatAlNoticeShowType.Normal then
      self.btnNoticeBatchDelText:SetLocalText("multiple_selection")
      self.btnNoticeBatchDelImg:LoadSprite("Assets/Main/Sprites/UI/LWChat_v2/Common/zyf_lmgg_duoxuan_anniu.png")
      self.btnNoticeBatchDelText:SetActive(false)
      self.btnNoticeBatchDelImg:SetSizeDeltaXY(105, 90)
      UIGray.SetGray(self.btnNoticeBatchDelBtn.transform, false, true)
    elseif viewShowType == ChatAlNoticeShowType.BatchDel then
      self.btnNoticeBatchDelText:SetLocalText("btn_delete")
      self.btnNoticeBatchDelImg:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_5.png")
      self.btnNoticeBatchDelText:SetActive(true)
      self.btnNoticeBatchDelImg:SetSizeDeltaXY(210, 90)
      local selectDict = DataCenter.ChatVieweDataManager:GetAlNoticeBatchDelDict()
      local isEmpty = table.IsEmpty(selectDict)
      if not isEmpty then
        UIGray.SetGray(self.btnNoticeBatchDelBtn.transform, false, true)
      else
        UIGray.SetGray(self.btnNoticeBatchDelBtn.transform, true, true)
      end
    end
  else
    self.btnNoticeBatchDelBtn:SetActive(false)
  end
  self.btnNoticePostBtn:SetActive(isPostNoticeBtnShow)
end

function UIChatViewBottom_v2:OnClickbtnNoticePost()
  local canChat = DataCenter.LWRefundPunishManager:GetCanChat()
  if not canChat then
    return
  end
  self.view:ShowAllianceNoticePopup()
end

function UIChatViewBottom_v2:SetReply(replyMsg)
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
  local currRoom = self.view:GetSelectedRoom()
  if currRoom then
    currRoom:SetTempReply(replyMsg)
  end
end

function UIChatViewBottom_v2:CountChatLinesInEditorAndPC(str)
  self.inputMsgUnity.unity_tmpinput:InputFieldContentForceMeshUpdate()
  return self.inputMsgUnity.unity_tmpinput:GetInputFieldLineCount()
end

function UIChatViewBottom_v2:OnInputMsgChanged_UpadteHeight_PC(value)
  if not self:IsOnEditorOrPC() then
    return
  end
  local curLineCount = self:CountChatLinesInEditorAndPC(value)
  curLineCount = math.min(math.max(curLineCount, 1), 6)
  self.inputLineCount = curLineCount
  self:SetInputHeightDataByLineCount_PC(curLineCount)
  self:__UpdateHeight(isShowImmediately)
end

function UIChatViewBottom_v2:SetInputHeightDataByLineCount_PC(lineCount)
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

function UIChatViewBottom_v2:OnInputMsgChanged_UpadteHeight_Mobile(value)
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

function UIChatViewBottom_v2:SetInputHeightDataByLineCount_Mobile()
  local extraHeight = (self:GetCharHeight() + __CHAR_EXTRA_HEIGHT) * (self.inputLineCount - 1)
  self.inputHeight = __DEFAULT_INPUT_HEIGHT + extraHeight
  self.areaInput:SetSizeDeltaXY(self.areaInput:GetSizeDelta().x, self.inputHeight)
  self.inputMsgUnity:SetSizeDeltaXY(self.inputMsgUnity:GetSizeDelta().x, __DEFAULT_INPUT_MSG_HEIGHT + extraHeight)
  self:SetInputFieldTextHeight()
  self.areaInput:SetAnchoredPositionXY(self.areaInput:GetAnchoredPositionX(), -self.replayAreaHeight)
  self.areaEmoji:SetOffsetMaxXY(0, -self.inputHeight - self.replayAreaHeight)
  self.areaFunc:SetOffsetMaxXY(0, -self.inputHeight - self.replayAreaHeight)
end

function UIChatViewBottom_v2:GetInputFieldTextHeightByLineCount(lineCount)
  return (self:GetCharHeight() + __CHAR_EXTRA_HEIGHT) * lineCount
end

function UIChatViewBottom_v2:SetInputFieldTextHeight()
  local textTotalHeight = self:GetInputFieldTextHeightByLineCount(self.inputLineCount)
  self.inputMsgText:SetSizeDeltaXY(self.inputMsgText:GetSizeDelta().x, textTotalHeight)
  self.inputMsgHolder:SetSizeDeltaXY(self.inputMsgHolder:GetSizeDelta().x, textTotalHeight)
end

function UIChatViewBottom_v2:SetInputFieldTextToMid()
  local toMidOffset = (__DEFAULT_INPUT_MSG_HEIGHT - self:GetCharHeight() - __CHAR_EXTRA_HEIGHT) / 2
  self.inputMsgText:SetAnchoredPositionXY(self.inputMsgText:GetAnchoredPositionX(), toMidOffset)
  self.inputMsgHolder:SetAnchoredPositionXY(self.inputMsgHolder:GetAnchoredPositionX(), toMidOffset)
end

function UIChatViewBottom_v2:InitFuncsRedDotData()
  self.chatBottomFuncData = {
    {
      funcType = ChatBottomFuncConfig.RedPackage,
      redDotNum = 0
    }
  }
  self:UpdateRedPacketDotData()
end

function UIChatViewBottom_v2:SetFuncsRedDotState()
  local redPacketDotState = CommonUtil.PlayerPrefsGetInt(SettingKeys.CHAT_BOTTOM_FUNC_RED_DOT_BY_RED_PACKET, 0)
  self.areaFuncRedDot:SetActive(0 < redPacketDotState and 0 < self:GetTotalFuncRedDotNum())
end

function UIChatViewBottom_v2:UpdateRedPacketDotData()
  local count = DataCenter.RedPacketManager:GetRedPackRedDot()
  self:SetFuncRedDotNumByType(ChatBottomFuncConfig.RedPackage, count)
end

function UIChatViewBottom_v2:GetFuncRedDotNumByType(funcType)
  for _, funcData in ipairs(self.chatBottomFuncData) do
    if funcData.funcType == funcType then
      return funcData.redDotNum
    end
  end
end

function UIChatViewBottom_v2:SetFuncRedDotNumByType(funcType, redDotNum)
  for _, funcData in ipairs(self.chatBottomFuncData) do
    if funcData.funcType == funcType then
      funcData.redDotNum = redDotNum
      return
    end
  end
end

function UIChatViewBottom_v2:GetTotalFuncRedDotNum()
  local sum = 0
  for _, funcData in ipairs(self.chatBottomFuncData) do
    sum = sum + funcData.redDotNum
  end
  return sum
end

function UIChatViewBottom_v2:OnClickBack()
  self.resetPopPanelType = PanelTypeEnum.None
  self:SetPopUpPanelDataByType(PanelTypeEnum.None)
  self:__UpdateHeight(isShowImmediately, true)
  self.view:OnClickBack()
end

function UIChatViewBottom_v2:DeleteButtonClick()
  if self:IsOnAndroidOrIOS() then
    self.inputMsgMobile:DeleteButtonClick()
  end
end

function UIChatViewBottom_v2:SendMessage()
  self:OnClickSend()
end

function UIChatViewBottom_v2:OnClickSend(keyboard)
  local canChat = DataCenter.LWRefundPunishManager:GetCanChat()
  if not canChat then
    return
  end
  if not keyboard then
    __ChatPostBI(ChatBIEnum.ChatMsgSendClick, {source = "button"})
  end
  local extra = {
    isSendEmoji = false,
    srcLang = ChatInterface.getLanguageName()
  }
  self:TryInsertInfoToExtra(extra)
  self.view.ctrl:SendMessage(self:GetDiffInputMsgText(), 0, PostType.Text_Normal, extra)
  self:SetDiffInputMsgText("")
  if ChatInterface.IsTranslateAllOpen() and self.view and self.view.middle and self.view.middle.scrollMsgs then
    self.view.middle.scrollMsgs:ReLoadChat()
  end
end

function UIChatViewBottom_v2:OnClickbtnBatchDel()
  local isShow = false
  isShow = self.isBatchBtnShow
  if isShow == false then
    return
  end
  local viewShowType = DataCenter.ChatPrivateDataManager:GetShowType()
  if viewShowType == ChatPrivateListShowType.Normal then
    DataCenter.ChatPrivateDataManager:OnToBatchDelType()
    EventManager:GetInstance():Broadcast(EventId.ChatPrivateShowTypeChange)
  elseif viewShowType == ChatPrivateListShowType.BatchDel then
    local selectDict = DataCenter.ChatPrivateDataManager:GetBatchDelDict()
    local isEmpty = table.IsEmpty(selectDict)
    if not isEmpty then
      do
        local tblNum = table.count(selectDict)
        UIUtil.ShowMessage(Localization:GetString("multiple_selection_tips", tblNum), 2, "btn_delete", "btn_cancel", function()
          EventManager:GetInstance():Broadcast(EventId.ChatPrivateRemoveRoomIds, selectDict)
          DataCenter.ChatPrivateDataManager:OnToNormalType()
          EventManager:GetInstance():Broadcast(EventId.ChatPrivateShowTypeChange)
        end, function()
        end, function()
        end)
      end
    end
  end
end

function UIChatViewBottom_v2:OnClickbtnNoticeBatchDel()
  local isShow = self.isNoticeBatchBtnShow
  if isShow == false then
    return
  end
  local isInAlliance = ChatInterface.isInAlliance()
  if isInAlliance == false then
    return
  end
  local isR4orR5 = DataCenter.AllianceBaseDataManager:IsR4orR5()
  if isR4orR5 == false then
    return
  end
  local curRoom = self.view:GetSelectedRoom()
  if curRoom == nil then
    return
  end
  local viewShowType = DataCenter.ChatVieweDataManager:GetAlNoticeShowType()
  if viewShowType == ChatAlNoticeShowType.Normal then
    DataCenter.ChatVieweDataManager:StartAlNoticeSelectDel(curRoom.roomId)
    EventManager:GetInstance():Broadcast(EventId.ChatAlNoticeShowTypeChange)
  elseif viewShowType == ChatAlNoticeShowType.BatchDel then
    local selectDict = DataCenter.ChatVieweDataManager:GetAlNoticeBatchDelDict()
    local isEmpty = table.IsEmpty(selectDict)
    if not isEmpty then
      local tblNum = table.count(selectDict)
      local roomId = curRoom.roomId
      local uuidList = {}
      local roomIds = {}
      local roomIdsJson = ""
      for k, v in pairs(selectDict) do
        table.insert(uuidList, k)
        table.insert(roomIds, ChatInterface.getRoomMgr():GetNoticeId(k))
      end
      if 0 < #roomIds then
        roomIdsJson = rapidjson.encode(roomIds)
      end
      UIUtil.ShowMessage(Localization:GetString("multiple_selection_tips_alliance", tblNum), 2, "btn_delete", "btn_cancel", function()
        SFSNetwork.SendMessage(MsgDefines.AllianceNoticeBatchDelete, uuidList, roomIdsJson)
        DataCenter.ChatVieweDataManager:SetAlNoticeNormalData()
        EventManager:GetInstance():Broadcast(EventId.ChatAlNoticeShowTypeChange)
      end, function()
      end, function()
      end)
    else
    end
  end
end

function UIChatViewBottom_v2:OnClickEmoji()
  if not self.areaEmoji:GetActive() then
    self.resetPopPanelType = PanelTypeEnum.EmojiPanel
    self:SetPopUpPanelDataByType(PanelTypeEnum.EmojiPanel)
  else
    self.resetPopPanelType = PanelTypeEnum.None
    self:SetPopUpPanelDataByType(PanelTypeEnum.None)
  end
  self:__UpdateHeight(isShowImmediately)
end

function UIChatViewBottom_v2:OnClickFuncs()
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

function UIChatViewBottom_v2:OnClickBtnKeyboard()
  self.resetPopPanelType = PanelTypeEnum.None
  self:SetUMIFocus(true)
end

function UIChatViewBottom_v2:OnInputMsgChanged(value)
  local currRoom = self.view:GetSelectedRoom()
  if currRoom then
    currRoom:SetTempText(value)
  end
  if self.inputActive == nil then
    self.inputActive = true
  end
  self:SetSendOrFuncActive(self.inputActive, value)
end

function UIChatViewBottom_v2:OnClosePopUpKeyboard()
  self:SetPopUpPanelDataByType(PanelTypeEnum.None)
  self:__UpdateHeight(isShowImmediately)
end

function UIChatViewBottom_v2:OnSetReply(replyMsg)
  if replyMsg then
    local currRoom = self.view:GetSelectedRoom()
    if replyMsg.roomId ~= currRoom.roomId then
      return
    end
  end
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
  UIWindowNames.UIBattleMessageBar,
  UIWindowNames.UILimitDropTipView
}

function UIChatViewBottom_v2:SetInputActive(active)
  if active == nil then
    active = false
  end
  self.inputMsgUnity:SetActive(active)
  self.inputMsgHolder:SetActive(active)
  self.btnEmoji:SetActive(active)
  self:SetSendOrFuncActive(active)
  self.inputActive = active
end

function UIChatViewBottom_v2:SetInputMsgText(textId)
  local id = textId or 2900000
  self.inputMsgHolder:SetLocalText(id)
  self.inputMsgPCHolder:SetLocalText(id)
end

function UIChatViewBottom_v2:IsCover(wind)
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

function UIChatViewBottom_v2:GetWindowIsBottom()
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

function UIChatViewBottom_v2:SetKeyboardActive(isOn)
  self:SetUMIVisible(isOn)
  self.forceHiddenKeyboard = not isOn
end

function UIChatViewBottom_v2:SetEmojiBtnActive(isOn)
  self.btnEmoji:SetActive(isOn)
end

function UIChatViewBottom_v2:OnWindowOpened(windowName)
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
  if windowName == UIWindowNames.UICommonMessageTip or windowName == UIWindowNames.UIWinterStormMatching or windowName == UIWindowNames.UICommonConfirm then
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

function UIChatViewBottom_v2:OnWindowClosed(windowName)
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

function UIChatViewBottom_v2:UpdateRedPacketDot()
  self:InitFuncsRedDotData()
  self:SetFuncsRedDotState()
  self.areaFunc:ShowFuncsPanel()
end

function UIChatViewBottom_v2:SetCharHeight()
  if self:IsOnAndroidOrIOS() then
    self.charHeight = self:__CalcKeyboardHeight(self.inputMsgMobile.charHeight)
  end
  self:OnInputMsgChanged_UpadteHeight_Mobile()
end

function UIChatViewBottom_v2:GetCharHeight()
  if self:IsOnAndroidOrIOS() and self.inputMsgMobile.Visible then
    self.charHeight = self:__CalcKeyboardHeight(self.inputMsgMobile.charHeight)
  end
  return self.charHeight
end

function UIChatViewBottom_v2:SelectRoom()
  if self.areaFunc:GetActive() then
    self.areaFunc:ClearLoadingFuncItem()
    self.areaFunc:ShowFuncsPanel()
  end
end

function UIChatViewBottom_v2:IsOnAndroidOrIOS()
  return (CS.SDKManager.IS_UNITY_ANDROID() or CS.SDKManager.IS_UNITY_IOS()) and not CS.SDKManager.IS_UNITY_EDITOR()
end

function UIChatViewBottom_v2:IsOnEditorOrPC()
  return CS.SDKManager.IS_UNITY_EDITOR() or Config.IsPC()
end

function UIChatViewBottom_v2:SetUMIVisible(state)
  if not self:IsOnAndroidOrIOS() then
    return
  end
  self.inputMsgMobile:SetVisible(state)
  self.inputMsgMobile:SetIsDefaultVisibleOnEnable(state)
end

function UIChatViewBottom_v2:SetUMIFocus(state)
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

function UIChatViewBottom_v2:SetDiffInputMsgText(text)
  if self:IsOnAndroidOrIOS() then
    self.inputMsgMobile.Text = text
  else
    self.inputMsgUnity:SetText(text)
  end
end

function UIChatViewBottom_v2:GetDiffInputMsgText()
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

function UIChatViewBottom_v2:OnTextInsert(inserted, preText, insertPos)
  if not ChatInterface.IsAtOpen() then
    return
  end
  local roomData = self.view:GetSelectedRoom()
  if not ChatInterface.IsCanAt(roomData) then
    if self.hasTriggeredAt then
      self.hasTriggeredAt = false
      self:OnChatAtEnd()
    end
    return
  end
  local text = self:GetDiffInputMsgText()
  if inserted == "@" then
    self:OnChatAtStart(insertPos, insertPos + 1)
  elseif self.hasTriggeredAt then
    self.atRange.finish = self.atRange.finish + utf8Tools.len(inserted)
    self:OnChatAtEditing(utf8Tools.sub(text, self.atRange.start + 2, self.atRange.finish + 1))
  end
end

function UIChatViewBottom_v2:OnTextDelete(deleted, preText, deletePos)
  if not ChatInterface.IsAtOpen() then
    return
  end
  local roomData = self.view:GetSelectedRoom()
  if not ChatInterface.IsCanAt(roomData) then
    if self.hasTriggeredAt then
      self.hasTriggeredAt = false
      self:OnChatAtEnd()
    end
    return
  end
  local text = self:GetDiffInputMsgText()
  local delta = utf8Tools.len(deleted)
  if self.hasTriggeredAt then
    self.atRange.finish = self.atRange.finish - delta
    if self.atRange.finish <= self.atRange.start then
      self:OnChatAtEnd()
    else
      self:OnChatAtEditing(utf8Tools.sub(text, self.atRange.start + 2, self.atRange.finish + 1))
    end
  end
  if self.hasTriggeredAt and not string.contains(text, "@") then
    self.hasTriggeredAt = false
    self:OnChatAtEnd()
  end
  self:UpdateAtPlayers()
end

function UIChatViewBottom_v2:OnChatAtStart(start, finish)
  if not self.hasTriggeredAt then
    self.hasTriggeredAt = true
  end
  self.atRange = {start = start, finish = finish}
  self.atPanel:SetActive(true)
  local roomData = self.view:GetSelectedRoom()
  self.atPanel:RefreshChatFilter(roomData)
  self.atPanel:RefreshScrollView("")
end

function UIChatViewBottom_v2:OnChatAtEditing(filter)
  self.atPanel:RefreshScrollView(filter)
end

function UIChatViewBottom_v2:OnChatAtEnd()
  if self.hasTriggeredAt then
    self.hasTriggeredAt = false
  end
  self.atPanel:RefreshChatFilter()
  self.atPanel:SetActive(false)
end

function UIChatViewBottom_v2:ResetAtInfo()
  local roomData = self.view:GetSelectedRoom()
  if ChatInterface.IsCanAt(roomData) then
    local atPlayers = roomData:GetInputAtPlayers()
    local list = {}
    for _, v in ipairs(atPlayers) do
      table.insert(list, {
        text = "@" .. v.name .. ZeroWidthSpace,
        index = v.index,
        color = insertColor
      })
    end
    if self:IsOnAndroidOrIOS() then
      self.inputMsgMobile:ResetMentions(list)
    else
      self.inputMention:ResetMentions(list)
    end
  end
end

function UIChatViewBottom_v2:OnLongClickAddAtPlayer(player)
  if not ChatInterface.IsAtOpen() then
    return
  end
  local roomData = self.view:GetSelectedRoom()
  if not ChatInterface.IsCanAt(roomData) then
    return
  end
  if player.uid == LuaEntry.Player.uid then
    return
  end
  if #roomData:GetInputAtPlayers() >= MAX_AT_PLAYERS then
    UIUtil.ShowTips(Localization:GetString("at_notice_limit_number", MAX_AT_PLAYERS))
    return
  end
  if roomData.atUsedTimes >= AtMaxTimes then
    UIUtil.ShowTips(Localization:GetString("at_notice_limit_times", AtMaxTimes))
    return
  end
  self.atMentionIndex = self.atMentionIndex + 1
  local list = roomData:GetInputAtPlayers()
  table.insert(list, {
    uid = player.uid,
    name = player.userName,
    index = self.atMentionIndex
  })
  roomData:SetInputAtPlayers(list)
  if self:IsOnAndroidOrIOS() then
    self.inputMsgMobile:InsertMention("@" .. player.userName .. ZeroWidthSpace, 0, insertColor, self.atMentionIndex)
  else
    self.inputMention:InsertMention("@" .. player.userName .. ZeroWidthSpace, 0, insertColor, self.atMentionIndex)
  end
end

function UIChatViewBottom_v2:OnInputAddAtPlayer(data)
  if not ChatInterface.IsAtOpen() then
    return
  end
  local roomData = self.view:GetSelectedRoom()
  if not ChatInterface.IsCanAt(roomData) then
    return
  end
  if data.uid == LuaEntry.Player.uid then
    return
  end
  if #roomData:GetInputAtPlayers() >= MAX_AT_PLAYERS then
    UIUtil.ShowTips(Localization:GetString("at_notice_limit_number", MAX_AT_PLAYERS))
    return
  end
  if roomData.atUsedTimes >= AtMaxTimes then
    UIUtil.ShowTips(Localization:GetString("at_notice_limit_times", AtMaxTimes))
    return
  end
  self:OnChatAtEnd()
  local len = 0
  if self:GetCaretPosition() == self.atRange.finish then
    len = self.atRange.finish - self.atRange.start
  end
  self.atMentionIndex = self.atMentionIndex + 1
  local list = roomData:GetInputAtPlayers()
  local name = data.name
  if not data.atAll then
    local playerInfo = DataCenter.PlayerInfoDataManager:GetPlayerDataByUid(data.uid)
    if playerInfo then
      name = playerInfo.name
    end
  end
  table.insert(list, {
    uid = data.uid,
    name = name,
    index = self.atMentionIndex
  })
  roomData:SetInputAtPlayers(list)
  if self:IsOnAndroidOrIOS() then
    self.inputMsgMobile:InsertMention("@" .. name .. ZeroWidthSpace, len, insertColor, self.atMentionIndex)
  else
    self.inputMention:InsertMention("@" .. name .. ZeroWidthSpace, len, insertColor, self.atMentionIndex)
  end
end

function UIChatViewBottom_v2:OnMentionDelete(index)
  local roomData = self.view:GetSelectedRoom()
  if not ChatInterface.IsCanAt(roomData) then
    return
  end
  local inputAtPlayers = roomData:GetInputAtPlayers()
  for i, v in pairs(inputAtPlayers) do
    if v.index == index then
      table.remove(inputAtPlayers, i)
      break
    end
  end
  roomData:SetInputAtPlayers(inputAtPlayers)
end

function UIChatViewBottom_v2:TryInsertInfoToExtra(extra)
  local roomData = self.view:GetSelectedRoom()
  if roomData then
    local inputAtPlayers = roomData:GetInputAtPlayers()
    local text = self:GetDiffInputMsgText()
    local uids = {}
    for _, v in ipairs(inputAtPlayers) do
      local atStr = "@" .. v.name
      if string.contains(text, atStr) then
        table.insert(uids, v.uid)
        if v.uid == "atAll" then
          extra.atAll = true
          v.name = ATTag.atAllTag
        end
      end
    end
    extra.atUids = uids
    extra.atPlayers = inputAtPlayers
    roomData:SetInputAtPlayers({})
  end
end

function UIChatViewBottom_v2:GetCaretPosition()
  local start, finish = 0, 0
  if self:IsOnAndroidOrIOS() then
    local selection = self.inputMsgMobile:GetSelection()
    start = selection.start
    finish = selection.start + selection.length
  elseif self.inputMsgUnity.unity_tmpinput then
    start = self.inputMsgUnity.unity_tmpinput.selectionStringAnchorPosition
    finish = self.inputMsgUnity.unity_tmpinput.selectionStringFocusPosition
  end
  return start, finish
end

function UIChatViewBottom_v2:SetCaretPosition(index)
  if self:IsOnAndroidOrIOS() then
    local selection = self.inputMsgMobile:GetSelection()
    selection.start = index
    selection.length = 0
    self.inputMsgMobile:SetSelection(selection)
  elseif self.inputMsgUnity.unity_tmpinput then
    self.inputMsgUnity.unity_tmpinput.caretPosition = index
  end
end

function UIChatViewBottom_v2:UpdateAtPlayers()
  local roomData = self.view:GetSelectedRoom()
  if roomData then
    local inputAtPlayers = roomData:GetInputAtPlayers()
    local text = self:GetDiffInputMsgText()
    local removes = {}
    for i, v in ipairs(inputAtPlayers) do
      local atStr = "@" .. v.name
      if not string.contains(text, atStr) then
        table.insert(removes, v)
      end
    end
    for _, v in ipairs(removes) do
      self:OnMentionDelete(v.index)
    end
  end
end

return UIChatViewBottom_v2
