local ChatPinAllianceNoticeItemCell = BaseClass("ChatPinAllianceNoticeItemCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local cd = 60
local ChatPinVote = require("UI.UIChatNew.Component.ChatPinVote")
local ChatDataEmojiItem2 = require("UI.UIChatNew.Component.ChatItem.ChatDataEmojiItem2")
local BGExpandText = require("UI.UIChatNew.Component.GeneralComponents.BGExpandText")
local ContentSizeFitter = CS.UnityEngine.UI.ContentSizeFitter
local ChatUploadPhoto = require("UI.UIChatNew.Component.UploadPhoto.ChatUploadPhoto")
local AlNoticePicContent = require("UI.UIChatNew.Component.PicContent.AlNoticePicContent")
local StringUtils = CS.StringUtils
local defaultHeigh = 60
local pushAlmeber = 20
local openService = 4
local lastPush = 14
local distanceBetweenContentAndLike = 15
local distanceTags = 50
local showMoreTxtH = 38
local txtRawLRSpace = 5
local txtRawDefaultTopSpaceH = 5
local uploadImgDefaultSize = 210
local uploadImgHeightMax = 277
local uploadImgTopSpaceH = 5
local AlPostEventLog = require("DataCenter.AllianceData.AlliancePostEventLog")
local compBook = {
  {
    path = "",
    name = "canvasGroup",
    rawType = CS.UnityEngine.CanvasGroup
  },
  {
    path = "ContentRoot/topNormal",
    name = "topNormal",
    type = UIImage
  },
  {
    path = "ContentRoot/bottomBtnContent/btnContents/btnClose",
    name = "btnClose",
    type = UIButton,
    onClick = function(self)
      self:OnClickClose()
    end
  },
  {
    path = "ContentRoot/TitleContent/txtTitle",
    name = "txtTitle",
    type = UITextMeshProUGUIEx,
    textKey = "2900001"
  },
  {
    path = "ContentRoot/TitleContent/txtEdited",
    name = "txtEdited",
    type = UITextMeshProUGUIEx,
    textKey = "alliance_announcement_edit_tips2"
  },
  {
    path = "ContentRoot/btnUpgrade",
    name = "btnUpgrade",
    type = UIButton,
    onClick = function(self)
      self:OnClickUpgrade()
    end
  },
  {
    path = "ContentRoot/btnUpgrade/txtUpgrade",
    name = "txtUpgrade",
    type = UITextMeshProUGUIEx,
    textKey = "2900004"
  },
  {
    path = "ContentRoot/btnResend",
    name = "btnResend",
    type = UIButton,
    onClick = function(self)
      self:OnClickResend()
    end
  },
  {
    path = "ContentRoot/scrollText",
    name = "scrollText",
    type = UIScrollRect
  },
  {
    path = "ContentRoot/scrollText/Viewport/Content",
    name = "scrollContent",
    type = UIBaseContainer
  },
  {
    path = "ContentRoot/scrollText/Viewport/Content/txtRaw",
    name = "txtRaw",
    type = UITextMeshProUGUIEx
  },
  {
    path = "ContentRoot/scrollText/Viewport/Content/txtTrans",
    name = "txtTrans",
    type = UITextMeshProUGUIEx
  },
  {
    path = "ContentRoot/scrollText/Viewport/Content/imgLine",
    name = "imgLine",
    type = UIImage
  },
  {
    path = "ContentRoot/bottom",
    name = "bottom",
    type = UIBaseContainer
  },
  {
    path = "ContentRoot/bottom/txtPublisher",
    name = "txtPublisher",
    type = UITextMeshProUGUIEx
  },
  {
    path = "ContentRoot/bottom/trans/imgTranslated",
    name = "imgTranslated",
    type = UIImage
  },
  {
    path = "ContentRoot/bottom/trans/nodeTranslating",
    name = "nodeTranslating",
    type = UIGameObjectWrap
  },
  {
    path = "ContentRoot/bottom/trans/nodeTranslating/txtTranslating",
    name = "txtTranslating",
    type = UITextMeshProUGUIEx,
    textKey = "120039"
  },
  {
    path = "ContentRoot/bottom/trans/btnTranslate",
    name = "btnTranslate",
    type = UIButton,
    onClick = function(self)
      self:OnClickTranslate()
    end
  },
  {
    path = "ContentRoot/likeLayout",
    name = "emoji_like_layout",
    type = UIBaseContainer
  },
  {
    path = "ContentRoot/likeLayout/emoji_like_item1",
    name = "emoji_like_item1",
    type = ChatDataEmojiItem2
  },
  {
    path = "ContentRoot/likeLayout/emoji_like_item2",
    name = "emoji_like_item2",
    type = ChatDataEmojiItem2
  },
  {
    path = "ContentRoot/clickBtn",
    name = "clickBtn",
    type = UIButton,
    onClick = function(self)
      self:GoNoticeView()
    end
  },
  {
    path = "ContentRoot/Text",
    name = "comment",
    type = UITextMeshProUGUIEx
  },
  {
    path = "ContentRoot/Text/clickBtn_2",
    name = "clickBtn_2",
    type = UIButton,
    onClick = function(self)
      self:GoNoticeView()
    end
  },
  {
    path = "ContentRoot/bottomBtnContent/btnContents/delBtn",
    name = "delBtn",
    type = UIButton,
    onClick = function(self)
      self:OnDeleteBtnClick()
    end
  },
  {
    path = "ContentRoot/voteInfo",
    name = "voteInfo",
    type = ChatPinVote,
    onClick = function(self)
      self:OnDeleteBtnClick()
    end
  },
  {
    path = "ContentRoot/moveUpBtn",
    name = "moveUpBtn",
    type = UIButton,
    onClick = function(self)
      self:OnMovePinnedBtnClick(true)
    end
  },
  {
    path = "ContentRoot/moveDownBtn",
    name = "moveDownBtn",
    type = UIButton,
    onClick = function(self)
      self:OnMovePinnedBtnClick(false)
    end
  },
  {
    path = "ContentRoot/tagLayout/multipleText",
    name = "multipleText",
    type = BGExpandText
  },
  {
    path = "ContentRoot/tagLayout/anonymouText",
    name = "anonymouText",
    type = BGExpandText
  },
  {
    path = "ContentRoot/tagLayout/onlyR4R5Text",
    name = "onlyR4R5Text",
    type = BGExpandText
  },
  {
    path = "ContentRoot/tagLayout",
    name = "tagLayoutRoot",
    type = UIBaseContainer
  },
  {
    path = "ContentRoot/ShowMoreText",
    name = "showMoreText",
    type = UITextMeshProUGUIEx
  },
  {
    path = "ContentRoot",
    name = "contentRoot",
    type = UIBaseContainer
  },
  {
    path = "DelContent",
    name = "delContent",
    type = UIBaseContainer
  },
  {
    path = "DelContent/btnBatchSelect",
    name = "btnBatchSelect",
    type = UIButton,
    onClick = function(self)
      self:OnClickBatchSelect()
    end
  },
  {
    path = "DelContent/btnBatchSelect/btnBatchSelectImg",
    name = "btnBatchSelectImg",
    type = UIImage
  },
  {
    path = "ContentRoot/bottomBtnContent",
    name = "bottom_btn_content",
    type = UIBaseContainer
  },
  {
    path = "ContentRoot/bottomBtnContent/btnContents/bottomUpgradeBtn",
    name = "bottom_upgrade_btn",
    type = UIButton,
    onClick = function(self)
      self:OnClickBottomUpgrade()
    end
  },
  {
    path = "ContentRoot/bottomBtnContent/btnContents/bottomResendBtn",
    name = "bottom_resend_btn",
    type = UIButton,
    onClick = function(self)
      self:OnClickBottomResend()
    end
  },
  {
    path = "ContentRoot/bottomBtnContent/btnContents/bottomCloseBtn",
    name = "bottom_close_btn",
    type = UIButton,
    onClick = function(self)
      self:OnClickBottomClose()
    end
  },
  {
    path = "ContentRoot/bottomBtnContent/btnContents/pinBtn",
    name = "pin_btn",
    type = UIButton,
    onClick = function(self)
      self:OnClickPinBtn()
    end
  },
  {
    path = "ContentRoot/bottomBtnContent/btnContents/pinBtn",
    name = "pin_btn_img",
    type = UIImage
  },
  {
    path = "ContentRoot/SelectImgList",
    name = "select_img_list",
    type = AlNoticePicContent
  }
}

function ChatPinAllianceNoticeItemCell:OnCreate()
  base.OnCreate(self)
  self:AddListener()
  self:ComponentDefine()
  self.emojisData1 = {}
  self.emojisData2 = {}
  self.canClickLike = true
  self.canClickDislike = true
  self.showType = ChatAlNoticeShowType.Normal
  self.noticeAddExtraJsonData = nil
  self.loopScroll = nil
  self.loopListIndex = nil
end

function ChatPinAllianceNoticeItemCell:OnDestroy()
  if self.tween then
    self.tween:Kill()
    self.tween = nil
  end
  self:RemoveListener()
  self:ComponentDestroy()
  self.emojisData1 = nil
  self.emojisData2 = nil
  self.canClickLike = true
  self.canClickDislike = true
  self.showType = nil
  self.noticeAddExtraJsonData = nil
  self.loopScroll = nil
  self.loopListIndex = nil
  base.OnDestroy(self)
end

function ChatPinAllianceNoticeItemCell:AddListener()
  self:AddUIListener(ChatEventEnum.CHAT_ALLIANCE_NOTICEDATA_UPDATE, self.UpdateNoticeData)
  self:AddUIListener(ChatEventEnum.CHAT_TRANSLATE_All, self.OnClickTranslate)
  self:AddUIListener(EventId.ChatSendPhotoSetSuccess, self.SetUILoadedSuccessShow)
  self:AddUIListener(EventId.CHAT_NEWSCENTER_DATAS_UPDATE, self.GetNewsCenterDatasMsg)
end

function ChatPinAllianceNoticeItemCell:RemoveListener()
  self:RemoveUIListener(ChatEventEnum.CHAT_ALLIANCE_NOTICEDATA_UPDATE, self.UpdateNoticeData)
  self:RemoveUIListener(ChatEventEnum.CHAT_TRANSLATE_All, self.OnClickTranslate)
  self:RemoveUIListener(EventId.ChatSendPhotoSetSuccess, self.SetUILoadedSuccessShow)
  self:RemoveUIListener(EventId.CHAT_NEWSCENTER_DATAS_UPDATE, self.GetNewsCenterDatasMsg)
end

function ChatPinAllianceNoticeItemCell:OnEnable()
  base.OnEnable(self)
end

function ChatPinAllianceNoticeItemCell:OnDisable()
  if self.data then
    DataCenter.AllianceNoticeManager:KillNoticeWaitTimer(self.data.uid)
  end
  base.OnDisable(self)
end

function ChatPinAllianceNoticeItemCell:GoNoticeView()
  if self.showType == ChatAlNoticeShowType.BatchDel then
    self:OnClickBatchSelect()
    return
  end
  local data = DeepCopy(self.data)
  if self.view and self.view.ctrl then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIAllianceNoticeDetail, {anim = true}, data)
  end
  AlPostEventLog.PostEventLog_Notice_Action(AlPostEventLog.NoticeAction.Open)
end

function ChatPinAllianceNoticeItemCell:OnDeleteBtnClick()
  if self.showType ~= ChatAlNoticeShowType.Normal then
    return
  end
  UIUtil.ShowSecondMessage("", Localization:GetString("2900058"), 2, 100190, "", function()
    DataCenter.AllianceNoticeManager:RefreshIsClosePinNotice(self.data.uid)
    SFSNetwork.SendMessage(MsgDefines.AllianceNoticeOpDel, self.data.uid, ChatManager2:GetInstance().Room:GetNoticeId(self.data.uid))
  end, nil, nil, nil, nil, nil, nil, nil, nil, false)
end

function ChatPinAllianceNoticeItemCell:OnMovePinnedBtnClick(isUp)
  if self.showType ~= ChatAlNoticeShowType.Normal then
    return
  end
  local pos = DataCenter.AllianceNoticeManager:GetPinnedNoticePosition(self.data.uid)
  local list = DataCenter.AllianceNoticeManager:GetNoticePinnedListInfo()
  local newPos = isUp and pos - 1 or pos + 1
  local newData = list[newPos]
  if not newData then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.AllianceNoticePinnedChange, self.data.uid, newData.uid)
end

function ChatPinAllianceNoticeItemCell:ComponentDefine()
  self:DefineCompsByBook(compBook)
  self.scrollContentSizeFitter = self.scrollContent.rectTransform:GetComponent(typeof(ContentSizeFitter))
  if self.scrollContentSizeFitter then
    self.scrollContentSizeFitter.enabled = false
  end
end

function ChatPinAllianceNoticeItemCell:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function ChatPinAllianceNoticeItemCell:SetType(type)
  self.type = type or NoticeItemType.NoticePin
end

function ChatPinAllianceNoticeItemCell:ShowInfo(data)
  local str = Localization:GetString(390009)
  if data.comment and data.comment > 0 then
    self.comment:SetText(str .. "(" .. data.comment .. ")")
  else
    self.comment:SetText(str)
  end
  self:RefreshLikeAndDislikeState(data)
  if self.type == NoticeItemType.NoticeDetail then
    self.txtTrans:SetActive(data.transText)
    self.imgLine:SetActive(data.transText)
    self.txtTrans:SetText(data.transText or " ")
    self.txtTrans:SetBestFitEnable(false)
    self.clickBtn:SetActive(false)
    self.btnClose:SetActive(false)
    self.clickBtn_2:SetActive(false)
  else
    local text = self.data.transText or self.data.content or ""
    self.txtTrans:SetActive(false)
    self.imgLine:SetActive(false)
    self.clickBtn:SetActive(true)
    self.clickBtn_2:SetActive(true)
  end
  self:SetTextShowFunc()
  if data.type == ChatPinMessageType.AllianceNotice then
    local firstNotice = DataCenter.AllianceNoticeManager:GetTotalFristNotice()
    local isFirstNotice = firstNotice and firstNotice.uid == data.uid
    self.btnUpgrade:SetActive(false)
    self.btnResend:SetActive(false)
  else
    self.btnUpgrade:SetActive(false)
    self.btnResend:SetActive(false)
  end
  if self.type == NoticeItemType.NoticeList then
    self.btnClose:SetActive(false)
    if DataCenter.AllianceBaseDataManager:IsR4orR5() then
      self.delBtn:SetActive(data.noticeType == ChatNoticeType.ALLIANCE_VOTE)
    else
      self.delBtn:SetActive(false)
    end
  else
    self.delBtn:SetActive(false)
  end
end

function ChatPinAllianceNoticeItemCell:SetTextShowFunc()
  self.txtRaw.unity_tmpro:SetInputHtmlTagEmpty()
  if not string.IsNullOrEmpty(self.data.transText) then
    self.txtRaw:SetText_NotNative(self.data.transText)
    return
  end
  if self.data.extraJsonData then
    local showNotice, noticeAddExtraJsonData = ChatInterface.GetShowNoticeAndAddTempData(self.data.content, self.data.extraJsonData)
    if noticeAddExtraJsonData then
      self.noticeAddExtraJsonData = noticeAddExtraJsonData
      local fixedAddCharPosList = UIUtil.GetFixedArabicAddCharPosList(showNotice, self.txtRaw.unity_tmpro)
      for i = 1, #ChatAlNoticePosChangeTag do
        local tag = ChatAlNoticePosChangeTag[i]
        local pointShare = noticeAddExtraJsonData[tag]
        if pointShare and 0 < #pointShare then
          for i = 1, #pointShare do
            local data = pointShare[i]
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
            self.txtRaw.unity_tmpro:AddInputHtmlTag("color=#249bc5", "/color", realIndex - 1, realEndIndex - 1)
            self.txtRaw.unity_tmpro:AddInputHtmlTag("u", "/u", realIndex - 1, realEndIndex - 1)
          end
        end
      end
    end
    self.txtRaw:SetText_NotNative(showNotice)
  else
    self.txtRaw:SetText_NotNative(self.data.content)
  end
end

function ChatPinAllianceNoticeItemCell:RefreshLikeAndDislikeState(data)
  self.emojisData1 = self.emojisData1 or {}
  self.emojisData1.count = data.like
  self.emojisData1.emoji = 1
  self.emojisData1.self = self.emojisData1.self or 0
  if data.myLike ~= self.emojisData1.self then
    self.emojisData1.count = self.emojisData1.self == 1 and self.emojisData1.count + 1 or self.emojisData1.count - 1
  end
  self.emoji_like_item1:UpdateData(self.emojisData1, self)
  self.emojisData2 = self.emojisData2 or {}
  self.emojisData2.count = data.unlike
  self.emojisData2.emoji = 2
  self.emojisData2.self = self.emojisData2.self or 0
  if data.myDislike ~= self.emojisData2.self then
    self.emojisData2.count = self.emojisData2.self == 1 and self.emojisData2.count + 1 or self.emojisData2.count - 1
  end
  self.emoji_like_item2:UpdateData(self.emojisData2, self)
  data:SetMyLike(self.emojisData1.self)
  data.like = self.emojisData1.count
  data:SetMyDislike(self.emojisData2.self)
  data.unlike = self.emojisData2.count
end

function ChatPinAllianceNoticeItemCell:OnClickEmoji(emojiType)
  if self.showType ~= ChatAlNoticeShowType.Normal then
    return
  end
  local publisherUid = self.data.publisherUid
  local noticeUid = self.data.uid
  local isWaitClickRespondCache = DataCenter.AllianceNoticeManager:GetIsWaitClickRespondCache(noticeUid)
  if isWaitClickRespondCache and isWaitClickRespondCache[1] then
    UIUtil.ShowTipsId("avatar_tips002")
    return
  end
  if publisherUid == LuaEntry.Player.uid then
    UIUtil.ShowTipsId("avatar_tips001")
    return
  end
  if emojiType == 1 then
    if self.emojisData1.self == 0 then
      local isNoticeClickedLike = DataCenter.AllianceNoticeManager:GetIsNoticeClickedLike(noticeUid)
      if not isNoticeClickedLike and not InteractiveUtil.CanThumbsUp(InteractiveUtil.ThumbsUpType.AllianceNotice) then
        UIUtil.ShowTipsId("avatar_tips003")
        return
      end
      if not isNoticeClickedLike and publisherUid == LuaEntry.Player.uid then
        UIUtil.ShowTipsId("avatar_tips001")
        return
      end
      self.emojisData1.self = 1
      self.emojisData1.count = self.emojisData1.count + 1
      SFSNetwork.SendMessage(MsgDefines.AllianceNoticeOpLike, noticeUid, emojiType)
      if not isNoticeClickedLike then
        InteractiveUtil.TryThumbsUp(publisherUid, InteractiveUtil.ThumbsUpType.AllianceNotice, noticeUid, function()
        end)
      end
    else
      self.emojisData1.self = 0
      self.emojisData1.count = math.max(0, self.emojisData1.count - 1)
      SFSNetwork.SendMessage(MsgDefines.AllianceNoticeOpLikeCancel, noticeUid, emojiType)
    end
    self.emoji_like_item1:UpdateData(self.emojisData1, self)
  elseif emojiType == 2 then
    self.emojisData2.self = self.emojisData2.self == 0 and 1 or 0
    if self.emojisData2.self == 1 then
      self.emojisData2.count = self.emojisData2.count + 1
      SFSNetwork.SendMessage(MsgDefines.AllianceNoticeOpLike, noticeUid, emojiType)
    else
      self.emojisData2.count = math.max(0, self.emojisData2.count - 1)
      SFSNetwork.SendMessage(MsgDefines.AllianceNoticeOpLikeCancel, noticeUid, emojiType)
    end
    self.emoji_like_item2:UpdateData(self.emojisData2, self)
  end
end

function ChatPinAllianceNoticeItemCell:UpdateNoticeData(params)
  local noticeUuid = params.uuid or ""
  local isSkipRefreshTmpShow = params.isSkipRefreshTmpShow
  if noticeUuid == self.data.uid then
    local data
    if self.data.isPinned then
      data = DataCenter.AllianceNoticeManager:GetNoticePinnedDataById(noticeUuid)
    else
      data = DataCenter.AllianceNoticeManager:GetNoticeDataById(noticeUuid)
    end
    if data then
      self:ReInit(data, isSkipRefreshTmpShow)
      if self.loopScroll ~= nil and self.loopListIndex ~= nil then
        self.loopScroll:OnItemSizeChanged(self.loopListIndex)
      end
    end
  end
end

function ChatPinAllianceNoticeItemCell:ReInit(data, isSkipRefreshTmpShow, isInitData)
  self.data = data
  self.noticeAddExtraJsonData = nil
  if data.type ~= ChatPinMessageType.AllianceNotice then
    return
  end
  if not self.topNormal then
    return
  end
  local publisherInfo = ChatManager2:GetInstance().User:getChatUserInfo(data.publisherUid)
  local str = ""
  if data.time then
    str = UITimeManager:GetInstance():ConvertServerTimeToLocalTime(data.time) .. " "
  end
  if not publisherInfo then
    self.txtPublisher:SetText(" ")
  else
    local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(data.publisherUid, publisherInfo.userName)
    local nameStr = showName
    str = str .. nameStr
  end
  if not isSkipRefreshTmpShow then
    self.imgTranslated:SetActive(data.transText)
    self.nodeTranslating:SetActive(false)
    self.btnTranslate:SetActive(not data.transText)
  end
  if isInitData then
    self:InitEmojiData(data)
  end
  self.txtPublisher:SetText(str)
  if self.data.noticeType == ChatNoticeType.ALLIANCE_VOTE then
    self.topNormal.spritePath = nil
    self.topNormal:LoadSpriteAuto(ChatInterface.GetChatBigUIPath("zyf_lianmenggonggao_title_tiao2.png"))
    local scrollHeight = 200
    local bottomY = self.scrollText:GetAnchoredPositionY() - scrollHeight - 50
    local bottomH = self.bottom:GetSizeDelta().y
    self.bottom:SetAnchoredPositionXY(self.bottom:GetAnchoredPositionX(), bottomY)
    self.tagLayoutRoot:SetAnchoredPositionXY(0, bottomY + 50)
    local commentH = 50
    self:SetSizeDeltaXY(780, -bottomY + bottomH + 67 + 45 + commentH - 110 + distanceBetweenContentAndLike)
    self.comment:SetAnchoredPositionXY(self.comment:GetAnchoredPositionX(), bottomY - bottomH)
    self.emoji_like_layout:SetAnchoredPositionXY(self.emoji_like_layout:GetAnchoredPositionX(), bottomY - bottomH)
    self:ShowInfo(self.data)
    self.voteInfo:SetSizeDeltaXY(self.voteInfo:GetSizeDelta().x, scrollHeight)
    self.voteInfo:StopTimer()
    self.voteInfo:ReInit(self.data)
    self.voteInfo:SetActive(true)
    self.scrollText:SetActive(false)
    self.btnUpgrade:SetActive(false)
    self.btnResend:SetActive(false)
    self.txtTitle:SetLocalText("alliance_post_poll")
    self.showMoreText:SetActive(false)
    self.select_img_list:SetActive(false)
    self.bottom_upgrade_btn:SetActive(false)
    local resendBtnBottomShow = DataCenter.AllianceBaseDataManager:IsR4orR5()
    self.bottom_resend_btn:SetActive(resendBtnBottomShow)
    self.bottom_close_btn:SetActive(false)
  else
    self.voteInfo:SetActive(false)
    self.scrollText:SetActive(true)
    self.scrollText:SetSizeDeltaXY(self.scrollText:GetSizeDelta().x, defaultHeigh)
    self:InitNormalNoticeInfo(data)
    self.txtTitle:SetLocalText("2900001")
  end
  if self.canvasGroup then
    self.canvasGroup.alpha = 1
  end
  self.txtEdited:SetActive(data.edited == 1)
  self:SetNoticeTag(data)
  local isHideBtns = self.data.isPinned == true
  if isHideBtns then
    self.btnUpgrade:SetActive(false)
    self.btnResend:SetActive(false)
    self.delBtn:SetActive(false)
  end
  local pos = DataCenter.AllianceNoticeManager:GetPinnedNoticePosition(self.data.uid)
  local list = DataCenter.AllianceNoticeManager:GetNoticePinnedListInfo()
  local isR4orR5 = DataCenter.AllianceBaseDataManager:IsR4orR5()
  self.moveUpBtn:SetActive(isHideBtns and isR4orR5 and pos ~= 1)
  self.moveDownBtn:SetActive(isHideBtns and isR4orR5 and pos ~= #list)
  local selfSizeX, selfSizeY = self:GetSizeDeltaXY()
  self.contentRoot:SetSizeDeltaXY(selfSizeX, selfSizeY)
  self:RefreshSelectedContent()
end

function ChatPinAllianceNoticeItemCell:SetLoopScrollData(loopScroll, loopListIndex)
  self.loopScroll = loopScroll
  self.loopListIndex = loopListIndex
end

function ChatPinAllianceNoticeItemCell:InitEmojiData(data)
  self.emojisData1 = self.emojisData1 or {}
  self.emojisData1.count = data.like
  self.emojisData1.emoji = 1
  self.emojisData1.self = data.myLike
  self.emojisData2 = self.emojisData2 or {}
  self.emojisData2.count = data.unlike
  self.emojisData2.emoji = 2
  self.emojisData2.self = data.myDislike
end

function ChatPinAllianceNoticeItemCell:SetShowType(showType)
  self.showType = showType
  self:RefreshSelectedContent()
end

function ChatPinAllianceNoticeItemCell:RefreshSelectedContent()
  local isMirror = CommonUtil.IsArabicAutoMirrorOpen()
  if self.showType == ChatAlNoticeShowType.Normal then
    self.delContent:SetActive(false)
    self.contentRoot:SetAnchoredPositionXY(0, 0)
  elseif self.showType == ChatAlNoticeShowType.BatchDel then
    self.delContent:SetActive(true)
    self.contentRoot:SetAnchoredPositionXY(80, 0)
    local isDelSelect = DataCenter.ChatVieweDataManager:CheckNoticeInBatchDel(self.data.uid)
    self.btnBatchSelectImg:SetActive(isDelSelect)
  end
end

function ChatPinAllianceNoticeItemCell:InitNormalNoticeInfo(data)
  local path = data.isAdv and ChatInterface.GetChatBigUIPath("zyf_lianmenggonggao_title_tiao3.png") or ChatInterface.GetChatBigUIPath("zyf_lianmenggonggao_title_tiao.png")
  self.topNormal.spritePath = nil
  self.topNormal:LoadSpriteAuto(path)
  local isHavePic = data:IsHaveNoticePicVer()
  local picH = 0
  local txtContentSize = self.scrollText:GetSizeDelta()
  local textRawSizeX = txtContentSize.x - txtRawLRSpace * 2
  if isHavePic then
    self.select_img_list:SetActive(true)
    textRawSizeX = textRawSizeX - uploadImgDefaultSize - uploadImgTopSpaceH * 2
    local scrollTextAnchPos = self.scrollText:GetAnchoredPosition()
    self.select_img_list:SetAnchoredPositionXY(scrollTextAnchPos.x + txtContentSize.x - uploadImgDefaultSize - uploadImgTopSpaceH, scrollTextAnchPos.y - txtRawDefaultTopSpaceH + 5 - uploadImgTopSpaceH)
    self.select_img_list:SetSizeDeltaXY(uploadImgDefaultSize, uploadImgDefaultSize)
    picH = uploadImgDefaultSize + uploadImgTopSpaceH * 2
    local dataList = data:GetNoticePicListData()
    for i = 1, #dataList do
      local picSenderUidIn = dataList[i][AlNoticePicDataType.SenderUid]
      local picVerIn = dataList[i][AlNoticePicDataType.PicVer]
      dataList[i][AlNoticePicDataType.AssetKey] = CS.UploadImageManager.Instance:GenAssetKey(picSenderUidIn, picVerIn, false)
    end
    self.select_img_list:SetInputData(dataList, AlNoticeItemPicShowType.Normal, self.data)
  else
    self.select_img_list:SetActive(false)
  end
  self.txtRaw:SetSizeDeltaXY(textRawSizeX, 1000)
  self:ShowInfo(data)
  self.scrollContent:SetAnchoredPositionXY(0, 0)
  self:RefreshfLayOut()
  local rawTxtContentVal = self.txtRaw.unity_tmpro:GetPreferredValues(self.txtRaw:GetSizeDelta().x, 0)
  local height = 50
  if self.txtRaw then
    height = rawTxtContentVal.y
  end
  self.txtRaw.unity_tmpro:ForceMeshUpdate()
  local textInfo = self.txtRaw.unity_tmpro.textInfo
  local lineCount = textInfo.lineCount
  local textContentShowH = 0
  local isTxtShowComplete = false
  if isHavePic then
    if picH > height + txtRawDefaultTopSpaceH then
      textContentShowH = picH
      isTxtShowComplete = true
    else
      local textContentShowMaxH = 0
      local isHaveResult = false
      for i = 1, lineCount do
        local lineInfoH = textInfo.lineInfo[i - 1].lineHeight
        textContentShowMaxH = textContentShowMaxH + lineInfoH
        if picH < textContentShowMaxH + txtRawDefaultTopSpaceH then
          isHaveResult = true
          textContentShowH = textContentShowMaxH + txtRawDefaultTopSpaceH
          if i == lineCount then
            isTxtShowComplete = true
          end
          break
        end
      end
      if isHaveResult == false then
        textContentShowH = height + txtRawDefaultTopSpaceH
        isTxtShowComplete = true
      end
    end
  else
    local textContentShowMaxLine = 4
    if lineCount <= textContentShowMaxLine then
      textContentShowH = height
      isTxtShowComplete = true
    else
      local textContentShowMaxH = 0
      for i = 1, textContentShowMaxLine do
        local lineInfoH = textInfo.lineInfo[i - 1].lineHeight
        textContentShowMaxH = textContentShowMaxH + lineInfoH
      end
      textContentShowH = textContentShowMaxH + txtRawDefaultTopSpaceH
    end
  end
  local contentWithBottomSpace = 0
  local isShowMoreText = self.data.noticeType == ChatNoticeType.NORMAL and not isTxtShowComplete
  local showMoreTextDealH = isShowMoreText and showMoreTxtH or 0
  local scrollHeight = textContentShowH + 2
  scrollHeight = math.max(scrollHeight, 50)
  self.txtRaw:SetSizeDeltaXY(self.txtRaw:GetSizeDelta().x, textContentShowH)
  self.scrollText:SetSizeDeltaXY(self.scrollText:GetSizeDelta().x, scrollHeight)
  self.scrollContent:SetSizeDeltaXY(self.scrollContent:GetSizeDelta().x, scrollHeight)
  self.showMoreText:SetAnchoredPositionXY(self.showMoreText:GetAnchoredPositionX(), self.scrollText:GetAnchoredPositionY() - scrollHeight)
  local bottomY = self.scrollText:GetAnchoredPositionY() - scrollHeight - showMoreTextDealH - contentWithBottomSpace
  local bottomH = self.bottom:GetSizeDelta().y
  local tagsHeight = data:GetIsR4R5() and distanceTags or 0
  self.bottom:SetAnchoredPositionXY(self.bottom:GetAnchoredPositionX(), bottomY - tagsHeight)
  local commentChangeH = 57
  self.comment:SetAnchoredPositionXY(self.comment:GetAnchoredPositionX(), bottomY - tagsHeight - commentChangeH)
  self.emoji_like_layout:SetAnchoredPositionXY(self.emoji_like_layout:GetAnchoredPositionX(), bottomY - tagsHeight - commentChangeH)
  local commonTxtH = 50
  local delBtnBottomShow = false
  if self.type == NoticeItemType.NoticeList and DataCenter.AllianceBaseDataManager:IsR4orR5() then
    delBtnBottomShow = true
  end
  local upgradeBtnBottomShow = false
  local resendBtnBottomShow = false
  if data.type == ChatPinMessageType.AllianceNotice then
    local firstNotice = DataCenter.AllianceNoticeManager:GetTotalFristNotice()
    local isFirstNotice = firstNotice and firstNotice.uid == data.uid
    upgradeBtnBottomShow = not data.isAdv and DataCenter.AllianceBaseDataManager:IsR4orR5()
    resendBtnBottomShow = DataCenter.AllianceBaseDataManager:IsR4orR5()
  end
  self.bottom_upgrade_btn:SetActive(upgradeBtnBottomShow)
  self.bottom_resend_btn:SetActive(resendBtnBottomShow)
  self.bottom_close_btn:SetActive(delBtnBottomShow)
  local bottomBtnH = 0
  self.tagLayoutRoot:SetAnchoredPositionXY(0, bottomY)
  self:SetSizeDeltaXY(780, -bottomY + bottomH + 62 + distanceBetweenContentAndLike + tagsHeight + bottomBtnH)
  self.showMoreText:SetActive(isShowMoreText)
  if string.IsNullOrEmpty(self.data.content) then
    self.imgTranslated:SetActive(false)
    self.nodeTranslating:SetActive(false)
    self.btnTranslate:SetActive(false)
  end
end

function ChatPinAllianceNoticeItemCell:RefreshfLayOut()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.transform)
end

function ChatPinAllianceNoticeItemCell:LocateContentToTranslated()
  if not self.scrollContent or not self.scrollText then
    return
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.scrollContent.transform)
  local scrollH = self.scrollText.rectTransform.sizeDelta and self.scrollText.rectTransform.sizeDelta.y or 50
  local contentH = self.scrollContent.rectTransform.sizeDelta.y
  local anchorY = self.imgLine:GetAnchoredPositionY()
  local locateY = math.min(-anchorY, math.max(0, contentH - scrollH))
  self.scrollContent:SetAnchoredPositionXY(0, locateY)
end

function ChatPinAllianceNoticeItemCell:SetNoticeTag(data)
  if self.data.noticeType == ChatNoticeType.ALLIANCE_VOTE then
    self.tagLayoutRoot:SetActive(true)
    self.multipleText:ReInit({
      interval = 20,
      bgPath = ChatInterface.GetChatUIPath("ChatNotice/zyf_tongmengliaotianyouhua_lan_tiao.png"),
      text = data.voteData.voteInfo.type == VoteType.radio and "poll_singal" or "poll_multiple",
      islocalText = true
    })
    self.anonymouText:ReInit({
      interval = 20,
      bgPath = ChatInterface.GetChatUIPath("ChatNotice/zyf_tongmengliaotianyouhua_lv_tiao.png"),
      text = data.voteData.voteInfo.isCryptonym and "alliance_vote_option_anonymous" or "alliance_vote_option_public",
      islocalText = true
    })
  else
    self.tagLayoutRoot:SetActive(self.data:GetIsR4R5())
  end
  if self.data:GetIsR4R5() then
    self.onlyR4R5Text:ReInit({
      interval = 20,
      bgPath = ChatInterface.GetChatUIPath("ChatNotice/zyf_tongmenggonggaoyouhua_di_purple.png"),
      text = "alliance_announcement_r4r5",
      islocalText = true
    })
  end
  self.onlyR4R5Text:SetActive(self.data:GetIsR4R5())
  self.multipleText:SetActive(self.data.noticeType == ChatNoticeType.ALLIANCE_VOTE)
  self.anonymouText:SetActive(self.data.noticeType == ChatNoticeType.ALLIANCE_VOTE)
end

function ChatPinAllianceNoticeItemCell:OnClickClose()
  if self.showType ~= ChatAlNoticeShowType.Normal then
    return
  end
  if self.canvasGroup then
    if not self.tween then
      self.tween = self.canvasGroup:DOFade(0, 0.2):OnComplete(function()
        DataCenter.AllianceNoticeManager:CloseFirstPinNotice(self.data)
        EventManager:GetInstance():Broadcast(EventId.ChatPinUpdate)
      end)
    end
  else
    DataCenter.AllianceNoticeManager:CloseFirstPinNotice(self.data)
    EventManager:GetInstance():Broadcast(EventId.ChatPinUpdate)
  end
end

function ChatPinAllianceNoticeItemCell:OnClickUpgrade()
  if self.showType ~= ChatAlNoticeShowType.Normal then
    return
  end
  local param = {
    data = self.data,
    dataType = AlNoticeInputDataType.AllianceNoticeData
  }
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIUpgradeAllianceNotice, {}, param)
end

function ChatPinAllianceNoticeItemCell:OnClickTranslate()
  if self.showType ~= ChatAlNoticeShowType.Normal then
    return
  end
  if not self.data then
    return
  end
  if self.__waiting_for_translation_result then
    return
  end
  self.__waiting_for_translation_result = true
  self.btnTranslate:SetActive(false)
  self.nodeTranslating:SetActive(true)
  local translateTxt = self.data.content
  if self.data.extraJsonData then
    translateTxt = ChatInterface.GetShowNoticeAndAddTempData(self.data.content, self.data.extraJsonData, true)
  end
  ChatManager2:GetInstance().Translate:Translate(translateTxt, nil, nil, function(ok, rtnTbl)
    self.__waiting_for_translation_result = false
    if ok then
      DataCenter.AllianceNoticeManager:SaveTranslatedContentById(self.data.uid, rtnTbl.translateMsg)
      self.data.transText = rtnTbl.translateMsg
      self:ReInit(self.data, false)
      self:LocateContentToTranslated()
      if self.view and self.view.ctrl then
        if self.view.__name == UIWindowNames.LWUIAllianceNoticeDetail then
          self.view:ReInit()
        elseif self.view.__name == UIWindowNames.UIChatNew_v2 and self.transform then
          CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.transform.parent)
        end
      end
    else
      self.btnTranslate:SetActive(true)
      self.nodeTranslating:SetActive(false)
      UIUtil.ShowTipsId(rtnTbl.code)
    end
  end, nil, nil, FakeChatGroupType.Fake_GROUP_ALLIANCE_NOTICE)
end

function ChatPinAllianceNoticeItemCell:OnClickResend()
  if self.data == nil then
    return
  end
  if self.data.type ~= ChatPinMessageType.AllianceNotice then
    return
  end
  if self.showType ~= ChatAlNoticeShowType.Normal then
    return
  end
  if self.data.noticeType == ChatNoticeType.NORMAL then
  elseif self.data.noticeType == ChatNoticeType.ALLIANCE_VOTE then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIPublishPoll, {anim = false}, self.data)
    return
  else
    return
  end
  local notice = self.data.content or ""
  local isAdv = self.data.isAdv and 1 or 0
  local param = {
    notice = notice,
    isAdv = isAdv,
    isR4R5 = self.data:GetIsR4R5() and 1 or 0,
    photoData = {
      smallHeight = self.data.smallHeight,
      smallWidth = self.data.smallWidth,
      bigHeight = self.data.bigHeight,
      bigWidth = self.data.bigWidth,
      noticePicVer = self.data.noticePicVer,
      picSenderUid = self.data.picSenderUid
    },
    extraJsonData = self.data.extraJsonData,
    picJsonData = self.data.picJsonData,
    baseNoticeUuid = self.data.uid,
    baseNoticePublisherUid = self.data.publisherUid
  }
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPostAllianceNotice, {anim = true}, param)
end

function ChatPinAllianceNoticeItemCell:SetUILoadedSuccessShow(assetKey)
  self.select_img_list:SetUILoadedSuccessShow(assetKey)
end

function ChatPinAllianceNoticeItemCell:GetNewsCenterDatasMsg()
  local haveChange = false
  if self.noticeAddExtraJsonData then
    local tag = ChatAlNoticeSpecialDataType.NewsCenterURL
    local pointShare = self.noticeAddExtraJsonData[tag]
    if pointShare and 0 < #pointShare then
      for i = 1, #pointShare do
        local tagData = pointShare[i]
        local dataState = tagData.dataState
        if dataState ~= NewsChainDataState.NoData and dataState ~= NewsChainDataState.HaveData then
          local shareData = tagData[ChatAlNoticeSpecialDataParamType.shareData]
          local wikiChain = StringUtils.GetMD5(shareData)
          local curState = DataCenter.LWNewsCenterManager:GetCacheInfoByWikiChain(wikiChain)
          if curState ~= dataState then
            haveChange = true
            break
          end
        end
      end
    end
  end
  if haveChange then
    self:ReInit(self.data, false)
    EventManager:GetInstance():BroadcastDeferred(EventId.CHAT_ITEM_NEWSCENTER_DATA_GET)
  end
end

function ChatPinAllianceNoticeItemCell:DoResend()
end

function ChatPinAllianceNoticeItemCell:OnClickBatchSelect()
  if self.showType ~= ChatAlNoticeShowType.BatchDel then
    return
  end
  local isDelSelect = DataCenter.ChatVieweDataManager:CheckNoticeInBatchDel(self.data.uid)
  DataCenter.ChatVieweDataManager:SetNoticeInBatchDel(self.data.uid, not isDelSelect)
  EventManager:GetInstance():Broadcast(EventId.ChatAlNoticeShowTypeChange)
end

function ChatPinAllianceNoticeItemCell:OnClickBottomUpgrade()
  self:OnClickUpgrade()
end

function ChatPinAllianceNoticeItemCell:OnClickBottomResend()
  self:OnClickResend()
end

function ChatPinAllianceNoticeItemCell:OnClickBottomClose()
  self:OnDeleteBtnClick()
end

function ChatPinAllianceNoticeItemCell:OnClickPinBtn()
end

return ChatPinAllianceNoticeItemCell
