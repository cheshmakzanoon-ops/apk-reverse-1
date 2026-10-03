local base = UIBaseView
local UIPostAllianceNoticeView = BaseClass("UIPostAllianceNoticeView", base)
local UIhSettingsSlider = require("UI.UIChatNew.UIPushSettings.Component.UIPushSettingsSlider")
local Localization = CS.GameEntry.Localization
local StringUtils = CS.StringUtils
local rapidjson = require("rapidjson")
local AlPostEventLog = require("DataCenter.AllianceData.AlliancePostEventLog")
local AlNoticePicContent = require("UI.UIAllianceNotice.Post.Component.AlNoticePicContent")
local ChatSendPhotoLoadingBgPath = _ENV.ChatSendPhotoLoadingBgPath
local ChatInterface = _ENV.ChatInterface
local pushAlmeber = 20
local openService = 4
local lastPush = 14
local textMaxCount = 500
local insertColor = "#249bc5"
local pasteNeedCheckLen = 10
local photoShowSize = 190
local compBook = {
  {
    path = "curtain",
    name = "curtain",
    type = UIButton,
    onClick = function(self)
      self.ctrl:CloseSelf()
    end
  },
  {
    path = "panel/btnClose",
    name = "btnClose",
    type = UIButton,
    onClick = function(self)
      self.ctrl:CloseSelf()
    end
  },
  {
    path = "panel/txtTitle",
    name = "txtTitle",
    type = UIText,
    textKey = 2900001
  },
  {
    path = "panel/bottomBtnContent/btnNormal",
    name = "btnNormal",
    type = UIButton,
    onClick = function(self)
      self:OnClickNormal()
    end
  },
  {
    path = "panel/bottomBtnContent/btnNormal/txtBtnNormal",
    name = "txtNormal",
    type = UIText,
    textKey = 2900003
  },
  {
    path = "panel/bottomBtnContent/btnNormal/disNormal",
    name = "disNormal",
    type = nil
  },
  {
    path = "panel/bottomBtnContent/btnUpgrade",
    name = "btnUpgrade",
    type = UIButton,
    onClick = function(self)
      self:OnClickUpgrade()
    end
  },
  {
    path = "panel/bottomBtnContent/btnUpgrade/txtBtnUpgrade",
    name = "txtBtnUpgrade",
    type = UIText,
    textKey = "alliance_announcement_btn_urgent"
  },
  {
    path = "panel/bottomBtnContent/btnUpgrade/disUpgrade",
    name = "disUpgrade",
    type = nil
  },
  {
    path = "panel/bottomBtnContent/btnSave",
    name = "btnSave",
    type = UIButton,
    onClick = function(self)
      self:OnClickSave()
    end
  },
  {
    path = "panel/bottomBtnContent/btnSave/txtBtnSave",
    name = "txtBtnSave",
    type = UIText,
    textKey = "alliance_announcement_btn_save"
  },
  {
    path = "panel/bottomBtnContent/btnSave/disSave",
    name = "disSave",
    type = nil
  },
  {
    path = "panel/areaContent",
    name = "areaContent",
    type = nil
  },
  {
    path = "panel/areaContent/txtCharNum",
    name = "txtCharNum",
    type = UIText,
    text = "0/" .. textMaxCount
  },
  {
    path = "panel/areaContent/inputCommonType",
    name = "inputContent",
    type = UIInputCommonType
  },
  {
    path = "panel/areaContent/areaContentClick",
    name = "areaContentClick",
    type = nil
  },
  {
    path = "panel/areaContent/inputCommonType/inputMsgPC/Text Area/Text",
    name = "inputText",
    type = UITextMeshProUGUIEx
  },
  {
    path = "panel/areaContent/scrollContent",
    name = "scrollContent",
    type = nil
  },
  {
    path = "panel/areaContent/scrollContent/Viewport/Content/txtContent",
    name = "txtContent",
    type = UITextMeshProUGUIEx,
    textKey = 2900002
  },
  {
    path = "panel/itemOnlyR4R5/OnlyR4R5Slider",
    name = "onlyR4R5Slider",
    type = UIhSettingsSlider
  },
  {
    path = "panel/sharePointBtn",
    name = "sharePointBtn",
    type = UIButton,
    onClick = function(self)
      self:OnSharePointBtnClick()
    end
  },
  {
    path = "panel/areaContent/inputCommonType",
    name = "inputContentCanvasGroup",
    type = UICanvasGroup
  },
  {
    path = "panel/areaContent/scrollContent",
    name = "scrollContentCanvasGroup",
    type = UICanvasGroup
  },
  {
    path = "panel/areaContent/CloseMobleBg",
    name = "closeMobleInputBg",
    type = UIButton,
    onClick = function(self)
      self:OnCloseMobleBg()
    end
  },
  {
    path = "panel/SelectImgList",
    name = "SelectImgList",
    type = AlNoticePicContent
  }
}

function UIPostAllianceNoticeView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  ChatInterface.SetEmojiTextProperty(self.inputText)
  ChatInterface.SetEmojiTextProperty(self.txtContent)
  self.inputParam = self:GetUserData()
  self.extraJsonData = {}
  self.noticeAddExtraJsonData = {}
  self.__waiting_for_response = nil
  self.txtChangeFuncBlock = true
  self.selectionAtIndex = 0
  self.selectionAtIndexNeedRefresh = false
  self.initTextStr = nil
  self.photoSelectId = nil
  self.photoSelectData = nil
  self.baseNoticeUuid = nil
  self.baseNoticePublisherUid = nil
  self.baseNoticeAdv = nil
  self:Show()
  self.onlyR4R5Slider:SetSwitchPos(20)
  
  function self.onlyR4R5Slider.onSwitch(isOn)
    self.isOnlyR4R5Slider = isOn and 1 or 0
  end
  
  self.onlyR4R5Slider:Switch(false)
  self:TryinputParamView()
  self.txtChangeFuncBlock = false
end

function UIPostAllianceNoticeView:OnDestroy()
  self.inputContent:SetText("")
  self:ComponentDestroy()
  base.OnDestroy(self)
  self.__waiting_for_response = nil
  self.inputParam = nil
end

function UIPostAllianceNoticeView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ServerError, self.OnServerError)
  self:AddUIListener(EventId.SCREEN_TOUCH_CLICK_IGNORE_UI, self.OnScreenTouch)
  self:AddUIListener(EventId.ChatSendPhotoSetSuccess, self.SetUILoadedSuccessShow)
  self:AddUIListener(EventId.PhotoUploadStateChange, self.InitPhotoStateShow)
  self:AddUIListener(EventId.GF_window_opened, self.OnWindowOpened)
  self:AddUIListener(EventId.GF_window_closed, self.OnWindowClosed)
  self:AddUIListener(EventId.SelectPhotoFinishAndData, self.OnSelectPhotoFin)
  self:AddUIListener(EventId.PhotoGetPicVerToUpload, self.OnPhotoGetPicVerToUploadMsg)
  self:AddUIListener(EventId.PicVerGetMsgErr, self.OnPicVerGetMsgErr)
  self:AddUIListener(EventId.PhotoReuploadSet, self.OnPhotoReuploadSet)
  self:AddUIListener(EventId.PhotoUploadBan, self.OnPhotoUploadBan)
  self:AddUIListener(EventId.AlNoticeChangeMsgBackSuccess, self.OnChangeMsgBackSuccess)
end

function UIPostAllianceNoticeView:OnRemoveListener()
  self:RemoveUIListener(EventId.ServerError, self.OnServerError)
  self:RemoveUIListener(EventId.SCREEN_TOUCH_CLICK_IGNORE_UI, self.OnScreenTouch)
  self:RemoveUIListener(EventId.ChatSendPhotoSetSuccess, self.SetUILoadedSuccessShow)
  self:RemoveUIListener(EventId.PhotoUploadStateChange, self.InitPhotoStateShow)
  self:RemoveUIListener(EventId.GF_window_opened, self.OnWindowOpened)
  self:RemoveUIListener(EventId.GF_window_closed, self.OnWindowClosed)
  self:RemoveUIListener(EventId.SelectPhotoFinishAndData, self.OnSelectPhotoFin)
  self:RemoveUIListener(EventId.PhotoGetPicVerToUpload, self.OnPhotoGetPicVerToUploadMsg)
  self:RemoveUIListener(EventId.PicVerGetMsgErr, self.OnPicVerGetMsgErr)
  self:RemoveUIListener(EventId.PhotoReuploadSet, self.OnPhotoReuploadSet)
  self:RemoveUIListener(EventId.PhotoUploadBan, self.OnPhotoUploadBan)
  self:RemoveUIListener(EventId.AlNoticeChangeMsgBackSuccess, self.OnChangeMsgBackSuccess)
  base.OnRemoveListener(self)
end

function UIPostAllianceNoticeView:ComponentDefine()
  self:DefineCompsByBook(compBook)
  self.inputContent:SetOnValueChange(function(text)
    self:OnInputContentChange(text)
  end)
  self.inputContent:SetOnEndEdit(function(text)
    self:SetTextContentShow(true)
    self:SyncContentWithInput(text)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.txtContent.transform)
  end)
  self.inputContent:SetCharacterLimit(2000)
  
  function self.onTextPasteFunc(str)
    self:OnTextPaste(str)
  end
  
  self.inputContent:TrySetPCTextPasteLister(self.onTextPasteFunc)
  if not self:IsOnAndroidOrIOS() then
    self.inputMention = self.inputContent.inputMsgUse.gameObject:GetComponent(typeof(CS.InputFieldMention))
  end
  
  function self.onTextInsertFunc(str1, str2, index)
    if self.txtChangeFuncBlock then
      return
    end
    self:OnTextInsert(str1, str2, index)
  end
  
  function self.onTextDeleteFunc(str1, str2, index)
    if self.txtChangeFuncBlock then
      return
    end
    self:OnTextDelete(str1, str2, index)
  end
  
  self.inputFieldTextListener = self.inputContent.inputMsgUse.gameObject:GetComponent(typeof(CS.InputFieldTextListener))
  if not IsNull(self.inputFieldTextListener) then
    self.inputFieldTextListener.OnTextInsertEvent:AddListener(self.onTextInsertFunc)
    self.inputFieldTextListener.OnTextDeleteEvent:AddListener(self.onTextDeleteFunc)
    self.inputFieldTextListener:SetCustomSetting(true, true)
  else
    Logger.LogError("inputFieldTextListener is nil")
  end
  if self:IsOnAndroidOrIOS() then
    self.inputMsgMobile = self.inputContent.inputMsgUse.gameObject:GetComponent(typeof(CS.Mopsicus.Plugins.MobileInputField))
    self.mobilId = self.inputMsgMobile:GetMobilId()
  else
  end
  local holderColor = ChatUIThemeConfig.InputHolderColor[ChatInterface.GetChatTheme()]
  local textColor = ChatUIThemeConfig.InputTextColor[ChatInterface.GetChatTheme()]
  local mobilBackGroundColor = ChatUIThemeConfig.MobilBackGroundColor[ChatInterface.GetChatTheme()]
  self.inputContent:SetHolderColor(holderColor, textColor, mobilBackGroundColor)
  self.SelectImgList:SetPhotoFunc(function(dataIndex)
    self:OnSelectImgDel(dataIndex)
  end, function(dataIndex)
    self:OnSelectImgOpen(dataIndex)
  end, function(indexSource, indexTarget)
    self:OnSelectImgPosChange(indexSource, indexTarget)
  end)
end

function UIPostAllianceNoticeView:ComponentDestroy()
  if not IsNull(self.inputFieldTextListener) then
    self.inputFieldTextListener.OnTextInsertEvent:RemoveListener(self.onTextInsertFunc)
    self.inputFieldTextListener.OnTextDeleteEvent:RemoveListener(self.onTextDeleteFunc)
  end
  self.onTextInsertFunc = nil
  self.onTextDeleteFunc = nil
  self.inputFieldTextListener = nil
  self:ClearCompsByBook(compBook)
end

function UIPostAllianceNoticeView:SyncContentWithInput(inputText)
  self.txtContent.unity_tmpro:SetInputHtmlTagEmpty()
  if self.noticeAddExtraJsonData then
    local fixedAddCharPosList = UIUtil.GetFixedArabicAddCharPosList(inputText, self.txtContent.unity_tmpro)
    for tagIndex = 1, #ChatAlNoticePosChangeTag do
      local tag = ChatAlNoticePosChangeTag[tagIndex]
      if self.noticeAddExtraJsonData[tag] then
        local tagDataList = self.noticeAddExtraJsonData[tag]
        if tagDataList and 0 < #tagDataList then
          for i = 1, #tagDataList do
            local data = tagDataList[i]
            local index = data[ChatAlNoticeSpecialDataParamType.Index]
            local strLen = data.wordLen
            local endIndex = index + strLen - 1
            local realIndex = index
            local realEndIndex = endIndex
            for i = 1, #fixedAddCharPosList do
              local sCharPos = fixedAddCharPosList[i]
              if realIndex >= sCharPos then
                realIndex = realIndex + 1
              end
              if realEndIndex >= sCharPos then
                realEndIndex = realEndIndex + 1
              end
            end
            self.txtContent.unity_tmpro:AddInputHtmlTag("color=#249bc5", "/color", realIndex - 1, realEndIndex - 1)
          end
        end
      end
    end
  end
  if 0 < #inputText then
    self.txtContent:SetText_NotNative(inputText)
    self.txtContent:SetColor(ChatUIThemeConfig.ChatNameColor[ChatInterface.GetChatTheme()])
  else
    self.txtContent:SetText_NotNative(Localization:GetString(2900002))
    self.txtContent:SetColor(ChatUIThemeConfig.ChatNameColor[ChatInterface.GetChatTheme()])
  end
end

function UIPostAllianceNoticeView:UpdateBtnsState()
  local canPost = self:CanPostChatAllianceNotice()
  self.btnNormal:SetInteractable(canPost)
  self.disNormal:SetActive(not canPost)
  self.btnUpgrade:SetInteractable(canPost)
  self.disUpgrade:SetActive(not canPost)
  self.btnSave:SetInteractable(canPost)
  self.disSave:SetActive(not canPost)
  local isHaveBaseNotice = self.baseNoticeUuid and self.baseNoticeUuid
  self.btnSave:SetActive(isHaveBaseNotice)
end

function UIPostAllianceNoticeView:Show()
  self:SetActive(true)
  self:SetTextContentShow(true)
  self:SyncContentWithInput("")
  self:OnSelectPhotosContentRefresh()
  self:UpdateBtnsState()
  if self.inputParam == nil then
    self.inputContent:SetText("")
    self.initTextStr = ""
  end
end

function UIPostAllianceNoticeView:TryinputParamView()
  if self:IsOnAndroidOrIOS() then
    self.inputMsgMobile:ResetMentions({})
  else
    self.inputMention:ResetMentions({})
  end
  if self.inputParam == nil then
    return
  end
  self.baseNoticeUuid = self.inputParam.baseNoticeUuid
  self.baseNoticePublisherUid = self.inputParam.baseNoticePublisherUid
  self.baseNoticeAdv = self.inputParam.isAdv
  self.photoSelectData = {}
  local photoData = self.inputParam.photoData
  if photoData then
    local picVerIn = photoData.noticePicVer
    local picSenderUidIn = photoData.picSenderUid
    local smallHeightIn = photoData.smallHeight
    local smallWidthIn = photoData.smallWidth
    local bigHeightIn = photoData.bigHeight
    local bigWidthIn = photoData.bigWidth
    local isHavePicIn = picVerIn and 0 < picVerIn and not string.IsNullOrEmpty(picSenderUidIn)
    if isHavePicIn then
      local photoData = {}
      photoData[AlNoticePicDataType.SenderUid] = picSenderUidIn
      photoData[AlNoticePicDataType.PicVer] = picVerIn
      photoData[AlNoticePicDataType.SmallWidth] = smallWidthIn
      photoData[AlNoticePicDataType.SmallHeight] = smallHeightIn
      photoData[AlNoticePicDataType.BigWidth] = bigWidthIn
      photoData[AlNoticePicDataType.BigHeight] = bigHeightIn
      photoData[AlNoticePicDataType.SendState] = PhotoUploadState.UploadSuccess
      photoData[AlNoticePicDataType.AssetKey] = CS.UploadImageManager.Instance:GenAssetKey(picSenderUidIn, picVerIn, false)
      table.insert(self.photoSelectData, photoData)
    end
  end
  local isR4orR5 = self.inputParam.isR4R5
  self.onlyR4R5Slider:Switch(isR4orR5 == 1)
  self:SetTextContentShow(true)
  local notice = self.inputParam.notice
  if self.inputParam.extraJsonData then
    self.extraJsonData = {}
    table.copy(self.inputParam.extraJsonData, self.extraJsonData)
    local showTxtNotice
    showTxtNotice, self.noticeAddExtraJsonData = ChatInterface.GetShowNoticeAndAddTempData(notice, self.extraJsonData)
    local baseNotice = notice
    self.inputContent:SetText(showTxtNotice)
    self.initTextStr = showTxtNotice
    local mentionList = {}
    for tagIndex = 1, #ChatAlNoticePosChangeTag do
      local tag = ChatAlNoticePosChangeTag[tagIndex]
      local tagDataList = self.noticeAddExtraJsonData[tag]
      if tagDataList and 0 < #tagDataList then
        for i = 1, #tagDataList do
          local data = tagDataList[i]
          if data then
            local addStr = data.str
            local addSelectOff = 0
            local adIndex = i - 1
            local strInsertIndex = data[ChatAlNoticeSpecialDataParamType.Index]
            table.insert(mentionList, {
              text = addStr,
              index = adIndex,
              color = insertColor
            })
          end
        end
      end
    end
    if self:IsOnAndroidOrIOS() then
      self.inputMsgMobile:ResetMentions(mentionList)
    else
      self.inputMention:ResetMentions(mentionList)
    end
    self:SyncContentWithInput(showTxtNotice)
  else
    self.inputContent:SetText(notice)
    self.initTextStr = notice
    self:SyncContentWithInput(notice)
  end
  if self.inputParam.selectionAtIndex then
    self.selectionAtIndex = self.inputParam.selectionAtIndex
  else
    self.selectionAtIndex = string.word_count(self.inputContent:GetText() or "")
  end
  if self.inputParam.picJsonData and 0 < #self.inputParam.picJsonData then
    table.copy(self.inputParam.picJsonData, self.photoSelectData)
    for i = 1, #self.photoSelectData do
      local picSenderUidIn = self.photoSelectData[i][AlNoticePicDataType.SenderUid]
      local picVerIn = self.photoSelectData[i][AlNoticePicDataType.PicVer]
      self.photoSelectData[i][AlNoticePicDataType.SendState] = PhotoUploadState.UploadSuccess
      self.photoSelectData[i][AlNoticePicDataType.AssetKey] = CS.UploadImageManager.Instance:GenAssetKey(picSenderUidIn, picVerIn, false)
    end
  end
  self:OnSelectPhotosContentRefresh()
  self:UpdateBtnsState()
end

function UIPostAllianceNoticeView:OnSelectPhotosContentRefresh()
  self.SelectImgList:SetInputData(self.photoSelectData)
end

function UIPostAllianceNoticeView:GetChangeNoticeMsgData()
  local baseNotice = ""
  baseNotice, self.extraJsonData = ChatInterface.GetBaseNoticeAndExtraJsonData(self.inputContent:GetText() or "", self.noticeAddExtraJsonData, true)
  local notice = baseNotice
  local extraJson = rapidjson.encode(self.extraJsonData)
  local canPost = self:CanPostChatAllianceNotice()
  if not canPost then
    return
  end
  local isR4orR5 = DataCenter.AllianceBaseDataManager:IsR4orR5()
  if not isR4orR5 then
    UIUtil.ShowTipsId("alliance_announcement_r4r5_tips")
    return
  end
  local picJsonData = {}
  local picJson
  if self.photoSelectData and #self.photoSelectData > 0 then
    for i = 1, #self.photoSelectData do
      local picData = self.photoSelectData[i]
      if picData[AlNoticePicDataType.SendId] == nil then
        if picData[AlNoticePicDataType.SenderUid] and picData[AlNoticePicDataType.PicVer] and picData[AlNoticePicDataType.SmallWidth] and picData[AlNoticePicDataType.SmallHeight] and picData[AlNoticePicDataType.BigWidth] and picData[AlNoticePicDataType.BigHeight] then
          local inData = {
            [AlNoticePicDataType.SenderUid] = picData[AlNoticePicDataType.SenderUid],
            [AlNoticePicDataType.PicVer] = picData[AlNoticePicDataType.PicVer],
            [AlNoticePicDataType.SmallWidth] = picData[AlNoticePicDataType.SmallWidth],
            [AlNoticePicDataType.SmallHeight] = picData[AlNoticePicDataType.SmallHeight],
            [AlNoticePicDataType.BigWidth] = picData[AlNoticePicDataType.BigWidth],
            [AlNoticePicDataType.BigHeight] = picData[AlNoticePicDataType.BigHeight]
          }
          table.insert(picJsonData, inData)
        end
      else
        local sendId = picData[AlNoticePicDataType.SendId]
        local taskData = DataCenter.SendPhotoToServerManager:GetTaskDataBySendId(sendId)
        if taskData and taskData.photoData then
          local inData = {
            [AlNoticePicDataType.SenderUid] = taskData.senderUid,
            [AlNoticePicDataType.PicVer] = taskData.picVer,
            [AlNoticePicDataType.SmallWidth] = taskData.photoData.smallWidth,
            [AlNoticePicDataType.SmallHeight] = taskData.photoData.smallHeight,
            [AlNoticePicDataType.BigWidth] = taskData.photoData.bigWidth,
            [AlNoticePicDataType.BigHeight] = taskData.photoData.bigHeight
          }
          table.insert(picJsonData, inData)
        end
      end
    end
    picJson = rapidjson.encode(picJsonData)
  end
  local param = {
    notice = notice,
    isAdv = 0,
    isR4R5 = self.isOnlyR4R5Slider,
    extraJson = extraJson,
    picJson = picJson
  }
  return param
end

function UIPostAllianceNoticeView:TryNoticeNotifyOpenMsg()
  local all = DataCenter.AllianceMemberDataManager:GetAllMember()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local day = UITimeManager:GetInstance().GetDateNum(curTime, LuaEntry.Player.openServerTime)
  local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  local lastPushDay = UITimeManager:GetInstance().GetDateNum(curTime, allianceData.noticeNotifyOpenTime)
  if DataCenter.AllianceBaseDataManager:IsSelfLeader() and all and table.count(all) >= pushAlmeber and day >= openService and lastPushDay >= lastPush then
    UIUtil.ShowMessage(Localization:GetString("alliance_noti_guide_leader"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      SFSNetwork.SendMessage(MsgDefines.AllianceNoticeNotifyOpen)
    end)
  end
end

function UIPostAllianceNoticeView:TryNoticePostEventLog(param)
  local notice = param.notice
  local picJson = param.picJson
  local sendType = self.baseNoticePublisherUid == nil and AlPostEventLog.NoticeSendType.New or AlPostEventLog.NoticeSendType.Resend
  AlPostEventLog.PostEventLog_Notice_Send(sendType, AlPostEventLog.NoticeContentType.Normal, notice, not string.IsNullOrEmpty(picJson))
end

function UIPostAllianceNoticeView:OnChangeMsgBackSuccess(msg)
  self:TryNoticeNotifyOpenMsg()
  self.ctrl:CloseSelf()
end

function UIPostAllianceNoticeView:CheckEditCDPassWithTip()
  local isPass, time = DataCenter.AllianceBaseDataManager:CheckEditCDPass()
  if not isPass and time then
    local timeStr = UITimeManager:GetInstance():MilliSecondToFmtStringWithoutDay(time)
    UIUtil.ShowTips(Localization:GetString("alliance_announcement_edit_tips", timeStr))
  end
  return isPass
end

function UIPostAllianceNoticeView:OnClickNormal()
  if self.__waiting_for_response then
    return
  end
  local param = self:GetChangeNoticeMsgData()
  if not param then
    return
  end
  self.__waiting_for_response = true
  SFSNetwork.SendMessage(MsgDefines.AllianceChangeNotice, param)
  self:TryNoticePostEventLog(param)
end

function UIPostAllianceNoticeView:OnClickSave()
  if self.__waiting_for_response then
    return
  end
  local param = self:GetChangeNoticeMsgData()
  if not param then
    return
  end
  local needCheckEditorCD = false
  if self.baseNoticePublisherUid and self.baseNoticeUuid then
    param.uid = self.baseNoticeUuid
    param.publisherUid = self.baseNoticePublisherUid
    param.edited = 1
    param.isAdv = 0
    needCheckEditorCD = true
  end
  if needCheckEditorCD then
    local isPass = self:CheckEditCDPassWithTip()
    if not isPass then
      return
    end
  end
  self.__waiting_for_response = true
  SFSNetwork.SendMessage(MsgDefines.AllianceChangeNotice, param)
  self:TryNoticePostEventLog(param)
end

function UIPostAllianceNoticeView:OnClickUpgrade()
  if self.__waiting_for_response then
    return
  end
  local param = self:GetChangeNoticeMsgData()
  if not param then
    return
  end
  local needCheckEditorCD = false
  if self.baseNoticePublisherUid and self.baseNoticeUuid then
    param.uid = self.baseNoticeUuid
    param.publisherUid = self.baseNoticePublisherUid
    param.edited = 1
    needCheckEditorCD = true
  end
  if needCheckEditorCD then
    local isPass = self:CheckEditCDPassWithTip()
    if not isPass then
      return
    end
  end
  local inParam = {
    data = param,
    dataType = AlNoticeInputDataType.MsgParamTbl
  }
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIUpgradeAllianceNotice, {}, inParam)
end

function UIPostAllianceNoticeView:OnInputContentChange(text)
  local baseTxtCount = self:GetCurBaseTextWordCount()
  self.txtCharNum:SetText(string.format("%d/%d", baseTxtCount, textMaxCount))
  self:UpdateBtnsState()
end

function UIPostAllianceNoticeView:GetCurBaseTextWordCount()
  local text = self.inputContent:GetText() or ""
  local baseTxtCount = string.word_count(text)
  local tagWordCount = self:GetCurTagWordCount()
  baseTxtCount = baseTxtCount - tagWordCount
  if baseTxtCount < 0 then
    baseTxtCount = 0
  end
  return baseTxtCount
end

function UIPostAllianceNoticeView:GetCurTagWordCount()
  local tagWordCount = 0
  if self.noticeAddExtraJsonData then
    for tagIndex = 1, #ChatAlNoticePosChangeTag do
      local tag = ChatAlNoticePosChangeTag[tagIndex]
      local shareDataList = self.noticeAddExtraJsonData[tag]
      if shareDataList and 0 < #shareDataList then
        for i = 1, #shareDataList do
          local data = shareDataList[i]
          if data then
            local wordCount = data.wordLen
            tagWordCount = tagWordCount + wordCount
          end
        end
      end
    end
  end
  return tagWordCount
end

function UIPostAllianceNoticeView:OnServerError(msgName)
  if msgName == MsgDefines.AllianceChangeNotice then
    self.__waiting_for_response = nil
  end
end

function UIPostAllianceNoticeView:OnScreenTouch(touchInfo)
  if self.inputContentCanvasGroup:GetAlpha() == 1 then
    return
  end
  local touchPos = touchInfo.pointerPos
  local result = CS.UnityEngine.RectTransformUtility.RectangleContainsScreenPoint(self.areaContentClick.transform, touchPos, CS.GameEntry.UICamera)
  if result then
    self:SetTextContentShow(false)
  end
end

function UIPostAllianceNoticeView:OnCloseMobleBg()
  self:SetTextContentShow(true)
end

function UIPostAllianceNoticeView:OnSharePointBtnClick()
  local savePointShareNum = self:GetSavePointShareNum()
  if savePointShareNum >= ChatInterface.GetAlNoticePointShareMaxNum() then
    UIUtil.ShowTipsId("newscenter_tips1")
    return
  end
  local isInDragon = BattleFieldUtil.InBattleField()
  if isInDragon then
    UIUtil.ShowTipsId("alliance_coordinate_tips_1")
    return
  end
  if SceneUtils.GetIsInCity() then
    local unlock, lockTips = DataCenter.LWFunctionUnlockManager:CheckCanShow(LWFunctionUnlockType.MainUI_WorldBtn)
    if not unlock then
      UIUtil.ShowTipsId(lockTips)
      return
    end
  end
  if LuaEntry.Player:GetMainWorldPos() < 0 then
    UIUtil.ShowTipsId("alliance_coordinate_tips_2")
    return
  end
  local isUploadSuccess = true
  local isHavePic = self.photoSelectData and 0 < #self.photoSelectData
  if isHavePic then
    for i = 1, #self.photoSelectData do
      if self.photoSelectData[i][AlNoticePicDataType.SendState] ~= PhotoUploadState.UploadSuccess then
        isUploadSuccess = false
        break
      end
    end
  end
  if isUploadSuccess == false then
    return
  end
  local picJsonData, picJson
  if self.photoSelectData and 0 < #self.photoSelectData then
    picJsonData = {}
    for i = 1, #self.photoSelectData do
      local picData = self.photoSelectData[i]
      if picData[AlNoticePicDataType.SendId] == nil then
        if picData[AlNoticePicDataType.SenderUid] and picData[AlNoticePicDataType.PicVer] and picData[AlNoticePicDataType.SmallWidth] and picData[AlNoticePicDataType.SmallHeight] and picData[AlNoticePicDataType.BigWidth] and picData[AlNoticePicDataType.BigHeight] then
          local inData = {
            [AlNoticePicDataType.SenderUid] = picData[AlNoticePicDataType.SenderUid],
            [AlNoticePicDataType.PicVer] = picData[AlNoticePicDataType.PicVer],
            [AlNoticePicDataType.SmallWidth] = picData[AlNoticePicDataType.SmallWidth],
            [AlNoticePicDataType.SmallHeight] = picData[AlNoticePicDataType.SmallHeight],
            [AlNoticePicDataType.BigWidth] = picData[AlNoticePicDataType.BigWidth],
            [AlNoticePicDataType.BigHeight] = picData[AlNoticePicDataType.BigHeight]
          }
          table.insert(picJsonData, inData)
        end
      else
        local sendId = picData[AlNoticePicDataType.SendId]
        local taskData = DataCenter.SendPhotoToServerManager:GetTaskDataBySendId(sendId)
        if taskData and taskData.photoData then
          local inData = {
            [AlNoticePicDataType.SenderUid] = taskData.senderUid,
            [AlNoticePicDataType.PicVer] = taskData.picVer,
            [AlNoticePicDataType.SmallWidth] = taskData.photoData.smallWidth,
            [AlNoticePicDataType.SmallHeight] = taskData.photoData.smallHeight,
            [AlNoticePicDataType.BigWidth] = taskData.photoData.bigWidth,
            [AlNoticePicDataType.BigHeight] = taskData.photoData.bigHeight
          }
          table.insert(picJsonData, inData)
        end
      end
    end
    picJson = rapidjson.encode(picJsonData)
  end
  local curInputTxt = self.inputContent:GetText() or ""
  local baseNotice = ""
  baseNotice, self.extraJsonData = ChatInterface.GetBaseNoticeAndExtraJsonData(curInputTxt, self.noticeAddExtraJsonData)
  local insertPosData = {
    type = ChatAlNoticeTagInsertType.None,
    index = 0,
    charIndex = 0
  }
  local isInTag = false
  local preStrIndex = string.charIndexToWordIndex(curInputTxt, self.selectionAtIndex)
  local sortTagList = self.noticeAddExtraJsonData[ChatAlNoticeSpecialDataType.SortTag]
  local insertTagIndex = -1
  local insertCharIndex = preStrIndex + 1
  if sortTagList and 0 < #sortTagList then
    for i = 1, #sortTagList do
      local data = sortTagList[i]
      local tag = data[ChatAlNoticeSpecialDataParamType.Tag]
      local index = data[ChatAlNoticeSpecialDataParamType.Index]
      if tag == ChatAlNoticeSpecialDataType.PointShare or tag == ChatAlNoticeSpecialDataType.NewsCenterURL then
        local data
        if self.noticeAddExtraJsonData[tag] and self.noticeAddExtraJsonData[tag][index] then
          data = self.noticeAddExtraJsonData[tag][index]
        end
        if data then
          local dataStartIndex = data[ChatAlNoticeSpecialDataParamType.Index]
          local dataWordLen = data.wordLen
          local dataEndIndex = dataStartIndex + dataWordLen - 1
          if preStrIndex >= dataStartIndex and preStrIndex <= dataEndIndex then
            isInTag = true
            insertTagIndex = i + 1
            insertCharIndex = insertCharIndex - dataWordLen
            break
          else
            if preStrIndex < dataStartIndex then
              break
            end
            insertCharIndex = insertCharIndex - dataWordLen
          end
        end
      end
    end
  end
  if isInTag then
    insertPosData.type = ChatAlNoticeTagInsertType.SortTagIndex
    insertPosData.index = insertTagIndex
    insertPosData.charIndex = insertCharIndex
  else
    insertPosData.type = ChatAlNoticeTagInsertType.CharIndex
    insertPosData.index = insertCharIndex
    insertPosData.charIndex = insertCharIndex
  end
  local saveParam = {
    notice = baseNotice or "",
    isR4R5 = self.isOnlyR4R5Slider,
    picJsonData = picJsonData,
    extraJsonData = self.extraJsonData,
    selectionAtIndex = self.selectionAtIndex,
    baseNoticeUuid = self.baseNoticeUuid,
    baseNoticePublisherUid = self.baseNoticePublisherUid
  }
  local entryParm = {
    saveParam = saveParam,
    selectRoomGroup = DataCenter.ChatVieweDataManager.curSelectRoomGroup,
    insertPosData = insertPosData
  }
  DataCenter.WorldPointSelectViewDataManager:StartSelect(WorldPointSelectViewEntryType.AllianceNotice, entryParm)
end

function UIPostAllianceNoticeView:OnTextInsert(inserted, preText, insertPos)
  if self.initTextStr ~= nil and self.initTextStr ~= preText then
    return
  end
  if string.IsNullOrEmpty(inserted) then
    return
  end
  self.initTextStr = nil
  if self.noticeAddExtraJsonData and self.noticeAddExtraJsonData[ChatAlNoticeSpecialDataType.SortTag] and #self.noticeAddExtraJsonData[ChatAlNoticeSpecialDataType.SortTag] > 0 then
    local insertWordLen = string.word_count(inserted)
    local insertStartIndex = string.charIndexToWordIndex(preText, insertPos)
    for tagIndex = 1, #ChatAlNoticePosChangeTag do
      local tag = ChatAlNoticePosChangeTag[tagIndex]
      local sharDataList = self.noticeAddExtraJsonData[tag]
      if sharDataList and 0 < #sharDataList then
        for i = 1, #sharDataList do
          local data = sharDataList[i]
          local index = data[ChatAlNoticeSpecialDataParamType.Index]
          if insertStartIndex <= index then
            data[ChatAlNoticeSpecialDataParamType.Index] = index + insertWordLen
          end
        end
      end
    end
  end
  self:OnTextPaste(inserted)
end

function UIPostAllianceNoticeView:OnTextDelete(deleted, preText, deletePos)
  if self.initTextStr ~= nil and self.initTextStr ~= preText then
    return
  end
  if string.IsNullOrEmpty(deleted) then
    return
  end
  self.initTextStr = nil
  if not (self.noticeAddExtraJsonData and self.noticeAddExtraJsonData[ChatAlNoticeSpecialDataType.SortTag]) or not (#self.noticeAddExtraJsonData[ChatAlNoticeSpecialDataType.SortTag] > 0) then
    return
  end
  local delWordLen = string.word_count(deleted)
  local delStartIndex = string.charIndexToWordIndex(preText, deletePos + 1)
  local delEndIndex = delStartIndex + delWordLen - 1
  local sortTagIndexList = {}
  for i = 1, #self.noticeAddExtraJsonData[ChatAlNoticeSpecialDataType.SortTag] do
    local data = self.noticeAddExtraJsonData[ChatAlNoticeSpecialDataType.SortTag][i]
    local tag = data[ChatAlNoticeSpecialDataParamType.Tag]
    local index = data[ChatAlNoticeSpecialDataParamType.Index]
    if tag == ChatAlNoticeSpecialDataType.PointShare or tag == ChatAlNoticeSpecialDataType.NewsCenterURL then
      local data
      if self.noticeAddExtraJsonData[tag] and self.noticeAddExtraJsonData[tag][index] then
        data = self.noticeAddExtraJsonData[tag][index]
      end
      if data then
        local dataStartIndex = data[ChatAlNoticeSpecialDataParamType.Index]
        local dataWordLen = data.wordLen
        local dataEndIndex = dataStartIndex + dataWordLen - 1
        if delStartIndex <= dataEndIndex and delEndIndex >= dataStartIndex then
          table.insert(sortTagIndexList, i)
        end
      end
    end
  end
  local sharDataList = self.noticeAddExtraJsonData[ChatAlNoticeSpecialDataType.PointShare]
  local sharUrlDataList = self.noticeAddExtraJsonData[ChatAlNoticeSpecialDataType.NewsCenterURL]
  local sortTagDataList = self.noticeAddExtraJsonData[ChatAlNoticeSpecialDataType.SortTag]
  local pointShareDelIndexList = {}
  local urlShareDelIndexList = {}
  for i = 1, #sortTagIndexList do
    local index = sortTagIndexList[i]
    local data = sortTagDataList[index]
    local dataTag = data[ChatAlNoticeSpecialDataParamType.Tag]
    local dataIndex = data[ChatAlNoticeSpecialDataParamType.Index]
    if dataTag == ChatAlNoticeSpecialDataType.PointShare then
      table.insert(pointShareDelIndexList, dataIndex)
    elseif dataTag == ChatAlNoticeSpecialDataType.NewsCenterURL then
      table.insert(urlShareDelIndexList, dataIndex)
    end
  end
  if 0 < #sortTagIndexList then
    local listDelStartIndex = sortTagIndexList[1]
    local listDelEndIndex = sortTagIndexList[#sortTagIndexList]
    local delLen = listDelEndIndex - listDelStartIndex + 1
    local curLen = #sortTagDataList
    for i = listDelEndIndex, listDelStartIndex, -1 do
      table.remove(sortTagDataList, i)
    end
  end
  local realDelStartIndex = delStartIndex
  local realDelEndIndex = delEndIndex
  if 0 < #pointShareDelIndexList then
    local listDelStartIndex = pointShareDelIndexList[1]
    local listDelEndIndex = pointShareDelIndexList[#pointShareDelIndexList]
    local delLen = listDelEndIndex - listDelStartIndex + 1
    local curLen = #sharDataList
    for i = listDelEndIndex, listDelStartIndex, -1 do
      local data = sharDataList[i]
      local index = data[ChatAlNoticeSpecialDataParamType.Index]
      local wordLen = data.wordLen
      local endIndex = index + wordLen - 1
      if realDelStartIndex > index then
        realDelStartIndex = index
      end
      if realDelEndIndex < endIndex then
        realDelEndIndex = endIndex
      end
      table.remove(sharDataList, i)
    end
    for i = 1, #sortTagDataList do
      local data = sortTagDataList[i]
      local index = data[ChatAlNoticeSpecialDataParamType.Index]
      local tag = data[ChatAlNoticeSpecialDataParamType.Tag]
      if tag == ChatAlNoticeSpecialDataType.PointShare and listDelEndIndex < index then
        data[ChatAlNoticeSpecialDataParamType.Index] = index - delLen
      end
    end
  end
  if 0 < #urlShareDelIndexList then
    local listDelStartIndex = urlShareDelIndexList[1]
    local listDelEndIndex = urlShareDelIndexList[#urlShareDelIndexList]
    local delLen = listDelEndIndex - listDelStartIndex + 1
    local curLen = #sharUrlDataList
    for i = listDelEndIndex, listDelStartIndex, -1 do
      local data = sharUrlDataList[i]
      local index = data[ChatAlNoticeSpecialDataParamType.Index]
      local wordLen = data.wordLen
      local endIndex = index + wordLen - 1
      if realDelStartIndex > index then
        realDelStartIndex = index
      end
      if realDelEndIndex < endIndex then
        realDelEndIndex = endIndex
      end
      table.remove(sharUrlDataList, i)
    end
    for i = 1, #sortTagDataList do
      local data = sortTagDataList[i]
      local index = data[ChatAlNoticeSpecialDataParamType.Index]
      local tag = data[ChatAlNoticeSpecialDataParamType.Tag]
      if tag == ChatAlNoticeSpecialDataType.NewsCenterURL and listDelEndIndex < index then
        data[ChatAlNoticeSpecialDataParamType.Index] = index - delLen
      end
    end
  end
  local realDelLen = realDelEndIndex - realDelStartIndex + 1
  if sharDataList and 0 < #sharDataList then
    for i = 1, #sharDataList do
      local data = sharDataList[i]
      local index = data[ChatAlNoticeSpecialDataParamType.Index]
      if realDelEndIndex < index then
        data[ChatAlNoticeSpecialDataParamType.Index] = index - realDelLen
      end
    end
  end
  if sharUrlDataList and 0 < #sharUrlDataList then
    for i = 1, #sharUrlDataList do
      local data = sharUrlDataList[i]
      local index = data[ChatAlNoticeSpecialDataParamType.Index]
      if realDelEndIndex < index then
        data[ChatAlNoticeSpecialDataParamType.Index] = index - realDelLen
      end
    end
  end
end

function UIPostAllianceNoticeView:OnTextPaste(str)
  if string.IsNullOrEmpty(str) then
    return
  end
  if #str > pasteNeedCheckLen then
    local url = DataCenter.LWNewsCenterManager:ReplaceWikiLink(str)
    if url then
      self:TryFindNewsUrlStrToData(str, url)
    end
  end
end

function UIPostAllianceNoticeView:TryFindNewsUrlStrToData(str, url)
  local start, finish = self.inputContent:GetCaretPosition()
  local curInputTxt = self.inputContent:GetText() or ""
  local copyStrLen = #str
  if start == finish then
    local finishWordIndex = string.charIndexToWordIndex(curInputTxt, finish)
    local finishLenIndex = string.wordIndexToLenIndex(curInputTxt, finishWordIndex)
    local trySubStr = string.sub(curInputTxt, finishLenIndex - (copyStrLen - 1), finishLenIndex)
    if trySubStr == str then
      local savePointShareNum = self:GetSavePointShareNum()
      if savePointShareNum >= ChatInterface.GetAlNoticePointShareMaxNum() then
        UIUtil.ShowTipsId("newscenter_tips1")
        return
      end
      self:TryReplaceTxtToUrlShareData(curInputTxt, trySubStr, finishLenIndex - (copyStrLen - 1), finishLenIndex, url)
    end
  end
end

function UIPostAllianceNoticeView:TryReplaceTxtToUrlShareData(curStr, replaceStr, replaceSIndex, replaceEIndex, targetUrl)
  if self.noticeAddExtraJsonData == nil then
    self.noticeAddExtraJsonData = {}
  end
  local wikiChain = StringUtils.GetMD5(targetUrl)
  local dataState, data = DataCenter.LWNewsCenterManager:GetCacheInfoByWikiChain(wikiChain)
  local shareStr = Localization:GetString("newscenter_desc2")
  if dataState == NewsChainDataState.NoData then
    shareStr = Localization:GetString("newscenter_desc1")
  elseif dataState == NewsChainDataState.HaveData then
    shareStr = data.title
  end
  local strLen = #shareStr
  local wordLen = string.word_count(shareStr)
  local replaceTxtLen = #replaceStr
  local replaceTxtWordLen = string.word_count(replaceStr)
  local changeWordCount = wordLen - replaceTxtWordLen
  local preTxt = string.sub(curStr, 1, replaceSIndex - 1)
  local afterTxt = string.sub(curStr, replaceEIndex + 1)
  local curTxt = preTxt .. shareStr .. afterTxt
  local preTxtWordLen = string.word_count(preTxt)
  local tempData = {
    [ChatAlNoticeSpecialDataParamType.Index] = preTxtWordLen + 1,
    [ChatAlNoticeSpecialDataParamType.shareData] = targetUrl,
    str = shareStr,
    strLen = strLen,
    wordLen = wordLen
  }
  self.inputContent:SetCaretPosition(preTxtWordLen + wordLen)
  local addSortIndex = -1
  if self.noticeAddExtraJsonData[ChatAlNoticeSpecialDataType.SortTag] == nil then
    self.noticeAddExtraJsonData[ChatAlNoticeSpecialDataType.SortTag] = {}
  end
  if self.noticeAddExtraJsonData[ChatAlNoticeSpecialDataType.NewsCenterURL] == nil then
    self.noticeAddExtraJsonData[ChatAlNoticeSpecialDataType.NewsCenterURL] = {}
  end
  for i = 1, #self.noticeAddExtraJsonData[ChatAlNoticeSpecialDataType.SortTag] do
    local data = self.noticeAddExtraJsonData[ChatAlNoticeSpecialDataType.SortTag][i]
    local tag = data[ChatAlNoticeSpecialDataParamType.Tag]
    local index = data[ChatAlNoticeSpecialDataParamType.Index]
    local targetData = self.noticeAddExtraJsonData[tag] and self.noticeAddExtraJsonData[tag][index]
    if targetData then
      local targetIndex = targetData[ChatAlNoticeSpecialDataParamType.Index]
      if targetIndex < tempData[ChatAlNoticeSpecialDataParamType.Index] then
      else
        addSortIndex = i
        break
      end
    end
  end
  if addSortIndex < 0 then
    addSortIndex = #self.noticeAddExtraJsonData[ChatAlNoticeSpecialDataType.SortTag] + 1
  end
  local addUrlTagIndex = 1
  for i = 1, addSortIndex - 1 do
    local tagData = self.noticeAddExtraJsonData[ChatAlNoticeSpecialDataType.SortTag][i]
    local tag = tagData[ChatAlNoticeSpecialDataParamType.Tag]
    local index = tagData[ChatAlNoticeSpecialDataParamType.Index]
    if tag == ChatAlNoticeSpecialDataType.NewsCenterURL then
      addUrlTagIndex = addUrlTagIndex + 1
    end
  end
  table.insert(self.noticeAddExtraJsonData[ChatAlNoticeSpecialDataType.SortTag], addSortIndex, {
    [ChatAlNoticeSpecialDataParamType.Tag] = ChatAlNoticeSpecialDataType.NewsCenterURL,
    [ChatAlNoticeSpecialDataParamType.Index] = addUrlTagIndex
  })
  table.insert(self.noticeAddExtraJsonData[ChatAlNoticeSpecialDataType.NewsCenterURL], addUrlTagIndex, tempData)
  for i = addSortIndex + 1, #self.noticeAddExtraJsonData[ChatAlNoticeSpecialDataType.SortTag] do
    local tagData = self.noticeAddExtraJsonData[ChatAlNoticeSpecialDataType.SortTag][i]
    local tag = tagData[ChatAlNoticeSpecialDataParamType.Tag]
    local index = tagData[ChatAlNoticeSpecialDataParamType.Index]
    if tag == ChatAlNoticeSpecialDataType.NewsCenterURL then
      tagData[ChatAlNoticeSpecialDataParamType.Index] = index + 1
    end
  end
  for i = addSortIndex + 1, #self.noticeAddExtraJsonData[ChatAlNoticeSpecialDataType.SortTag] do
    local tagData = self.noticeAddExtraJsonData[ChatAlNoticeSpecialDataType.SortTag][i]
    local tag = tagData[ChatAlNoticeSpecialDataParamType.Tag]
    local index = tagData[ChatAlNoticeSpecialDataParamType.Index]
    local data = self.noticeAddExtraJsonData[tag][index]
    if data then
      data[ChatAlNoticeSpecialDataParamType.Index] = data[ChatAlNoticeSpecialDataParamType.Index] + changeWordCount
    end
  end
  self:UseCurDataRefreshTxt(curTxt)
end

function UIPostAllianceNoticeView:UseCurDataRefreshTxt(showTxtNotice)
  if self.noticeAddExtraJsonData == nil then
    return
  end
  self.initTextStr = showTxtNotice
  self.inputContent:SetText(showTxtNotice)
  if self:IsOnAndroidOrIOS() then
    self.inputMsgMobile:ResetMentions({})
  else
    self.inputMention:ResetMentions({})
  end
  local adIndex = 0
  local mentionList = {}
  for tagIndex = 1, #ChatAlNoticePosChangeTag do
    local tag = ChatAlNoticePosChangeTag[tagIndex]
    local tagDataList = self.noticeAddExtraJsonData[tag]
    if tagDataList and 0 < #tagDataList then
      for i = 1, #tagDataList do
        local data = tagDataList[i]
        if data then
          local addStr = data.str
          local addSelectOff = 0
          local strInsertIndex = data[ChatAlNoticeSpecialDataParamType.Index]
          table.insert(mentionList, {
            text = addStr,
            index = adIndex,
            color = insertColor
          })
          adIndex = adIndex + 1
        end
      end
    end
  end
  if self:IsOnAndroidOrIOS() then
    self.inputMsgMobile:ResetMentions(mentionList)
  else
    self.inputMention:ResetMentions(mentionList)
  end
  self:SyncContentWithInput(showTxtNotice)
end

function UIPostAllianceNoticeView:GetSavePointShareNum()
  local num = 0
  if self.noticeAddExtraJsonData then
    for tagIndex = 1, #ChatAlNoticePosChangeTag do
      local tag = ChatAlNoticePosChangeTag[tagIndex]
      if self.noticeAddExtraJsonData[tag] then
        num = num + #self.noticeAddExtraJsonData[tag]
      end
    end
  end
  return num
end

function UIPostAllianceNoticeView:SetTextContentShow(val)
  self.scrollContentCanvasGroup:SetShow(val)
  self.inputContentCanvasGroup:SetShow(not val)
  self.inputContent:Select(not val)
  self.selectionAtIndexNeedRefresh = not val
  if self:IsOnAndroidOrIOS() then
    self.inputMsgMobile:SetVisible(not val)
    self.inputMsgMobile:SetIsDefaultVisibleOnEnable(not val)
    self.inputMsgMobile:SetFocus(not val)
    self.closeMobleInputBg:SetActive(not val)
    if val == false then
      local scaleFactor = UIManager:GetInstance():GetScaleFactor()
      self.parentSizeX = Screen.width / scaleFactor
      self.parentSizeY = Screen.height / scaleFactor
      self.closeMobleInputBg:SetSizeDeltaXY(self.parentSizeX, self.parentSizeY)
      self.closeMobleInputBg:SetPosition(self.view:GetPosition())
    end
  else
    self.closeMobleInputBg:SetActive(false)
  end
  if not val then
    self.inputContent:SetCaretPosition(self.selectionAtIndex)
  end
end

function UIPostAllianceNoticeView:__CalcKeyboardHeight(height)
  local layer = UIManager:GetInstance():GetLayer(UILayer.Normal.Name)
  local uiFullHeight = layer.rectTransform.rect.height
  local keyboardHeight = uiFullHeight * height / Screen.height
  return keyboardHeight
end

function UIPostAllianceNoticeView:Update()
  if self.selectionAtIndexNeedRefresh then
    local start, finish = self.inputContent:GetCaretPosition()
    self.selectionAtIndex = finish
  end
end

local IgnoreWindowNames = {
  [UIWindowNames.UINoticeTips] = true,
  [UIWindowNames.UICommonMessageSpecialBar] = true,
  [UIWindowNames.UICommonSingleMsgBar] = true,
  [UIWindowNames.UICommonMessageBar] = true,
  [UIWindowNames.UICommonMessageBarOld] = true,
  [UIWindowNames.UIBattleMessageBar] = true
}

function UIPostAllianceNoticeView:OnWindowOpened(windowName)
  if not self:IsOnAndroidOrIOS() then
    return
  end
  if IgnoreWindowNames[windowName] then
    return
  end
  local config = UIManager:GetInstance():GetWindowConfig(windowName)
  if not config then
    return
  end
  if config.Layer ~= UILayer.Dialog and config.Layer ~= UILayer.Info then
    return
  end
  self.inputMsgMobile:SetVisible(false)
  self.inputMsgMobile:SetIsDefaultVisibleOnEnable(false)
end

function UIPostAllianceNoticeView:OnWindowClosed(windowName)
  if not self:IsOnAndroidOrIOS() then
    return
  end
  if IgnoreWindowNames[windowName] then
    return
  end
  local config = UIManager:GetInstance():GetWindowConfig(windowName)
  if not config then
    return
  end
  if config.Layer ~= UILayer.Dialog and config.Layer ~= UILayer.Info then
    return
  end
  self.inputMsgMobile:SetVisible(true)
  self.inputMsgMobile:SetIsDefaultVisibleOnEnable(true)
end

function UIPostAllianceNoticeView:SetUILoadedSuccessShow(assetKey)
  self.SelectImgList:SetUILoadedSuccessShow(assetKey)
  self:UpdateBtnsState()
end

function UIPostAllianceNoticeView:InitPhotoStateShow(picVer)
  if picVer == nil then
    return
  end
  local sendId = DataCenter.SendPhotoToServerManager:GetSendIdByPicVer(picVer)
  if sendId == nil then
    return
  end
  local changeIndex = -1
  local isHavePic = self.photoSelectData and #self.photoSelectData > 0
  if isHavePic then
    for i = 1, #self.photoSelectData do
      local curSendId = self.photoSelectData[i][AlNoticePicDataType.SendId]
      if curSendId == sendId then
        changeIndex = i
        local taskData = DataCenter.SendPhotoToServerManager:GetTaskDataBySendId(curSendId)
        self.photoSelectData[i][AlNoticePicDataType.SendState] = taskData.state
        break
      end
    end
  end
  if 0 < changeIndex then
    self.SelectImgList:ItemPicStateChange(changeIndex)
  end
end

function UIPostAllianceNoticeView:OnSelectImgOpen(dataIndex)
  local isGet, tipTxt, selectId = DataCenter.SendPhotoToServerManager:GetSelectImgIdSafe()
  if isGet then
    self.photoSelectId = selectId
    local maxNum = DataCenter.AllianceNoticeManager:GetNoticeMaxPhotoNum()
    local curNum = 0
    if self.photoSelectData then
      curNum = #self.photoSelectData
    end
    local canNum = maxNum - curNum
    if 0 < canNum then
      DataCenter.SendPhotoToServerManager:OnSelectImg(FetchPicVerFuncType.ChatAlNoticePhotoNew, PhotoFuncType.CommonMulSelect, self.photoSelectId, canNum)
    end
  end
end

function UIPostAllianceNoticeView:OnSelectPhotoFin(data)
  if data and data.selectId == self.photoSelectId then
    if self.photoSelectData == nil then
      self.photoSelectData = {}
    end
    local sendIdList = data.sendIdList
    if sendIdList and 0 < #sendIdList then
      for i = 1, #sendIdList do
        local sendId = sendIdList[i]
        local taskData = DataCenter.SendPhotoToServerManager:GetTaskDataBySendId(sendId)
        local sendState = PhotoUploadState.WaitPicVer
        if taskData then
          sendState = taskData.state
        end
        local selectData = {
          [AlNoticePicDataType.SendId] = sendId,
          [AlNoticePicDataType.SendState] = sendState
        }
        table.insert(self.photoSelectData, selectData)
      end
      self.SelectImgList:SetInputData(self.photoSelectData)
    end
  end
  self:UpdateBtnsState()
end

function UIPostAllianceNoticeView:OnSelectImgDel(dataIndex)
  if self.photoSelectData and self.photoSelectData[dataIndex] then
    local delData = self.photoSelectData[dataIndex]
    table.remove(self.photoSelectData, dataIndex)
    self.SelectImgList:SetInputData(self.photoSelectData)
    if delData[AlNoticePicDataType.SendId] then
      DataCenter.SendPhotoToServerManager:TryDelPicTaskBySendId(delData[AlNoticePicDataType.SendId])
    end
  end
  self:UpdateBtnsState()
end

function UIPostAllianceNoticeView:OnSelectImgReupload(dataIndex)
end

function UIPostAllianceNoticeView:OnSelectImgPosChange(indexSource, indexTarget)
  if indexSource == indexTarget then
    return
  end
  if self.photoSelectData and self.photoSelectData[indexSource] and self.photoSelectData[indexTarget] then
    local tempData = self.photoSelectData[indexSource]
    if indexTarget < indexSource then
      for i = indexSource, indexTarget + 1, -1 do
        self.photoSelectData[i] = self.photoSelectData[i - 1]
      end
    else
      for i = indexSource, indexTarget - 1 do
        self.photoSelectData[i] = self.photoSelectData[i + 1]
      end
    end
    self.photoSelectData[indexTarget] = tempData
  end
end

function UIPostAllianceNoticeView:OnPhotoGetPicVerToUploadMsg(sendId)
  self.SelectImgList:OnPhotoGetPicVerToUploadMsg(sendId)
  self:UpdateBtnsState()
end

function UIPostAllianceNoticeView:OnPicVerGetMsgErr(data)
  self.SelectImgList:OnPicVerGetMsgErr(data)
  self:UpdateBtnsState()
end

function UIPostAllianceNoticeView:OnPhotoReuploadSet(data)
  if data and data.oldSendId and data.newSendId then
    local oldSendId = data.oldSendId
    local newSendId = data.newSendId
    for i = 1, #self.photoSelectData do
      local sendId = self.photoSelectData[i][AlNoticePicDataType.SendId]
      if sendId == oldSendId then
        local taskData = DataCenter.SendPhotoToServerManager:GetTaskDataBySendId(newSendId)
        local sendState = PhotoUploadState.WaitPicVer
        if taskData then
          sendState = taskData.state
        end
        self.photoSelectData[i][AlNoticePicDataType.SendId] = newSendId
        self.photoSelectData[i][AlNoticePicDataType.SendState] = sendState
        self.SelectImgList:SetInputData(self.photoSelectData)
        break
      end
    end
  end
end

function UIPostAllianceNoticeView:OnPhotoUploadBan(picVer)
  if picVer == nil then
    return
  end
  local sendId = DataCenter.SendPhotoToServerManager:GetSendIdByPicVer(picVer)
  if sendId == nil then
    return
  end
  local changeIndex = -1
  local isHavePic = self.photoSelectData and #self.photoSelectData > 0
  if isHavePic then
    for i = 1, #self.photoSelectData do
      local curSendId = self.photoSelectData[i][AlNoticePicDataType.SendId]
      if curSendId == sendId then
        changeIndex = i
        table.remove(self.photoSelectData, i)
        break
      end
    end
  end
  if 0 < changeIndex then
    self.SelectImgList:SetInputData(self.photoSelectData)
    self:UpdateBtnsState()
  end
end

function UIPostAllianceNoticeView:CanPostChatAllianceNotice()
  local typeWithoutPhoto = not string.IsNullOrEmpty(string.trim(self.inputContent:GetText()))
  local isHavePic = self.photoSelectData and #self.photoSelectData > 0
  local isUploadSuccess = true
  if isHavePic then
    for i = 1, #self.photoSelectData do
      if self.photoSelectData[i][AlNoticePicDataType.SendState] ~= PhotoUploadState.UploadSuccess then
        isUploadSuccess = false
        break
      end
    end
  end
  local curSharPointNUm = self:GetSavePointShareNum()
  local isHaveSharePoint = 0 < curSharPointNUm
  local noticeWordCountIsMax = false
  local baseTxtWordCount = self:GetCurBaseTextWordCount()
  if baseTxtWordCount > textMaxCount then
    noticeWordCountIsMax = true
  end
  local isHaveContent = false
  if isHavePic then
    isHaveContent = isUploadSuccess
  else
    isHaveContent = typeWithoutPhoto or isHaveSharePoint
  end
  local isCanSend = false
  if isHaveContent and not noticeWordCountIsMax then
    isCanSend = true
  end
  return isCanSend
end

function UIPostAllianceNoticeView:IsOnAndroidOrIOS()
  return (CS.SDKManager.IS_UNITY_ANDROID() or CS.SDKManager.IS_UNITY_IOS()) and not CS.SDKManager.IS_UNITY_EDITOR()
end

return UIPostAllianceNoticeView
