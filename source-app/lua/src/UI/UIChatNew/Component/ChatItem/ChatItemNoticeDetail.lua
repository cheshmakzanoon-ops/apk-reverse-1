local IChatItem = require("UI.UIChatNew.Component.ChatItem.IChatItem")
local base = IChatItem
local ChatItemNoticeDetail = BaseClass("ChatItemNoticeDetail", IChatItem)
local ChatPinVote = require("UI.UIChatNew.Component.ChatPinVote")
local ChatPinVoteDetail = require("UI.UIChatNew.Component.ChatPinVoteDetail")
local BGExpandText = require("UI.UIChatNew.Component.GeneralComponents.BGExpandText")
local rapidjson = require("rapidjson")
local ShareDecode = require("Chat.Other.ShareDecode")
local base64 = require("Framework.Common.base64")
local AlNoticePicContent = require("UI.UIChatNew.Component.PicContent.AlNoticePicContent")
local StringUtils = CS.StringUtils
local Canvas = CS.UnityEngine.Canvas
local pushAlmeber = 20
local openService = 4
local lastPush = 14
local Localization = CS.GameEntry.Localization
local distanceBetweenContentAndLike = 15
local distanceTags = 50
local uploadImgDefaultSize = 180
local uploadImgHeightMax = 277
local ChatDataEmojiItem2 = require("UI.UIChatNew.Component.ChatItem.ChatDataEmojiItem2")
local ChatUploadPhoto = require("UI.UIChatNew.Component.UploadPhoto.ChatUploadPhoto")
local compBook = {
  {
    path = "",
    name = "canvasGroup",
    rawType = CS.UnityEngine.CanvasGroup
  },
  {
    path = "ChatPinNoticeItem/ContentRoot/topNormal",
    name = "topNormal",
    type = UIImage
  },
  {
    path = "ChatPinNoticeItem/ContentRoot/topEmergency",
    name = "topEmergency",
    type = nil
  },
  {
    path = "ChatPinNoticeItem/ContentRoot/bottomBtnContent/btnContents/btnClose",
    name = "btnClose",
    type = UIButton,
    onClick = function()
    end
  },
  {
    path = "ChatPinNoticeItem/ContentRoot/TitleContent/txtTitle",
    name = "txtTitle",
    type = UITextMeshProUGUIEx,
    textKey = "2900001"
  },
  {
    path = "ChatPinNoticeItem/ContentRoot/TitleContent/txtEdited",
    name = "txtEdited",
    type = UITextMeshProUGUIEx,
    textKey = "alliance_announcement_edit_tips2"
  },
  {
    path = "ChatPinNoticeItem/ContentRoot/btnUpgrade",
    name = "btnUpgrade",
    type = UIButton,
    onClick = function(self)
      self:OnClickUpgrade()
    end
  },
  {
    path = "ChatPinNoticeItem/ContentRoot/btnUpgrade/txtUpgrade",
    name = "txtUpgrade",
    type = UITextMeshProUGUIEx,
    textKey = "2900004"
  },
  {
    path = "ChatPinNoticeItem/ContentRoot/btnResend",
    name = "btnResend",
    type = UIButton,
    onClick = function(self)
      self:OnClickResend()
    end
  },
  {
    path = "ChatPinNoticeItem/ContentRoot/scrollText",
    name = "scrollText",
    type = UIScrollRect
  },
  {
    path = "ChatPinNoticeItem/ContentRoot/scrollText/Viewport/Content",
    name = "scrollContent",
    type = UIBaseContainer
  },
  {
    path = "ChatPinNoticeItem/ContentRoot/scrollText/Viewport/Content/txtRaw",
    name = "txtRaw",
    type = UITextMeshProUGUIEx
  },
  {
    path = "ChatPinNoticeItem/ContentRoot/scrollText/Viewport/Content/txtTrans",
    name = "txtTrans",
    type = UITextMeshProUGUIEx
  },
  {
    path = "ChatPinNoticeItem/ContentRoot/scrollText/Viewport/Content/imgLine",
    name = "imgLine",
    type = UIImage
  },
  {
    path = "ChatPinNoticeItem/ContentRoot/bottom",
    name = "bottom",
    type = UIBaseContainer
  },
  {
    path = "ChatPinNoticeItem/ContentRoot/bottom/trans",
    name = "transCom",
    type = UIBaseContainer
  },
  {
    path = "ChatPinNoticeItem/ContentRoot/bottom/txtPublisher",
    name = "txtPublisher",
    type = UITextMeshProUGUIEx
  },
  {
    path = "ChatPinNoticeItem/ContentRoot/bottom/trans/imgTranslated",
    name = "imgTranslated",
    type = UIImage
  },
  {
    path = "ChatPinNoticeItem/ContentRoot/bottom/trans/nodeTranslating",
    name = "nodeTranslating",
    type = nil
  },
  {
    path = "ChatPinNoticeItem/ContentRoot/bottom/trans/nodeTranslating/txtTranslating",
    name = "txtTranslating",
    type = UITextMeshProUGUIEx,
    textKey = "120039"
  },
  {
    path = "ChatPinNoticeItem/ContentRoot/bottom/trans/btnTranslate",
    name = "btnTranslate",
    type = UIButton,
    onClick = function(self)
      self:OnClickTranslate()
    end
  },
  {
    path = "ChatPinNoticeItem/ContentRoot/likeLayout",
    name = "likeLayout",
    type = UIBaseContainer
  },
  {
    path = "ChatPinNoticeItem/ContentRoot/likeLayout/emoji_like_item1",
    name = "emoji_like_item1",
    type = ChatDataEmojiItem2
  },
  {
    path = "ChatPinNoticeItem/ContentRoot/likeLayout/emoji_like_item2",
    name = "emoji_like_item2",
    type = ChatDataEmojiItem2
  },
  {
    path = "ChatPinNoticeItem/ContentRoot/clickBtn",
    name = "clickBtn",
    type = UIButton,
    onClick = function(self)
      self:GoNoticeView()
    end
  },
  {
    path = "ChatPinNoticeItem/ContentRoot/Text",
    name = "comment",
    type = UITextMeshProUGUIEx
  },
  {
    path = "ChatPinNoticeItem/ContentRoot/Text/clickBtn_2",
    name = "clickBtn_2",
    type = UIButton,
    onClick = function(self)
      self:GoNoticeView()
    end
  },
  {
    path = "ChatPinNoticeItem/ContentRoot/bottomBtnContent/btnContents/delBtn",
    name = "delBtn",
    type = UIButton,
    onClick = function(self)
      self:OnDeleteBtnClick()
    end
  },
  {
    path = "ChatPinNoticeItem",
    name = "noticeItem",
    type = UIBaseContainer
  },
  {
    path = "noticeBg",
    name = "noticeBg",
    type = UIBaseContainer
  },
  {
    path = "ChatPinNoticeItem/ContentRoot/voteInfo",
    name = "voteInfo",
    type = ChatPinVote
  },
  {
    path = "ChatPinNoticeItem/ContentRoot/ChatPinVoteDetail",
    name = "voteDetail",
    type = ChatPinVoteDetail
  },
  {
    path = "ChatPinNoticeItem/ContentRoot/tagLayout/multipleText",
    name = "multipleText",
    type = BGExpandText
  },
  {
    path = "ChatPinNoticeItem/ContentRoot/tagLayout/anonymouText",
    name = "anonymouText",
    type = BGExpandText
  },
  {
    path = "ChatPinNoticeItem/ContentRoot/tagLayout/onlyR4R5Text",
    name = "onlyR4R5Text",
    type = BGExpandText
  },
  {
    path = "ChatPinNoticeItem/ContentRoot/tagLayout",
    name = "tagLayoutRoot",
    type = UIBaseContainer
  },
  {
    path = "reportBtn",
    name = "reportBtn",
    type = UIButton,
    onClick = function(self)
      self:OnReportBtnClick()
    end
  },
  {
    path = "ChatPinNoticeItem/ContentRoot",
    name = "contentRoot",
    type = UIBaseContainer
  },
  {
    path = "ChatPinNoticeItem/ContentRoot/bottomBtnContent",
    name = "bottom_btn_content",
    type = UIBaseContainer
  },
  {
    path = "ChatPinNoticeItem/ContentRoot/bottomBtnContent/btnContents/bottomUpgradeBtn",
    name = "bottom_upgrade_btn",
    type = UIButton,
    onClick = function(self)
      self:OnClickBottomUpgrade()
    end
  },
  {
    path = "ChatPinNoticeItem/ContentRoot/bottomBtnContent/btnContents/bottomResendBtn",
    name = "bottom_resend_btn",
    type = UIButton,
    onClick = function(self)
      self:OnClickBottomResend()
    end
  },
  {
    path = "ChatPinNoticeItem/ContentRoot/bottomBtnContent/btnContents/bottomCloseBtn",
    name = "bottom_close_btn",
    type = UIButton,
    onClick = function(self)
      self:OnClickBottomClose()
    end
  },
  {
    path = "ChatPinNoticeItem/ContentRoot/bottomBtnContent/btnContents/pinBtn",
    name = "pin_btn",
    type = UIButton,
    onClick = function(self)
      self:OnClickPinBtn()
    end
  },
  {
    path = "ChatPinNoticeItem/ContentRoot/bottomBtnContent/btnContents/pinBtn",
    name = "pin_btn_img",
    type = UIImage
  },
  {
    path = "ChatPinNoticeItem/ContentRoot/bottomBtnContent/btnContents/pinBtn/pinSelectIcon",
    name = "pin_select_icon",
    type = UIImage
  },
  {
    path = "ChatPinNoticeItem/ContentRoot/SelectImgList",
    name = "select_img_list",
    type = AlNoticePicContent
  }
}

function ChatItemNoticeDetail:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.emojisData1 = {}
  self.emojisData2 = {}
  self.canClickLike = true
  self.canClickDislike = true
  self.noticeAddExtraJsonData = nil
  self.loopScroll = nil
  self.loopListIndex = nil
end

function ChatItemNoticeDetail:OnDestroy()
  if self.tween then
    self.tween:Kill()
    self.tween = nil
  end
  self:ComponentDestroy()
  self.emojisData1 = nil
  self.emojisData2 = nil
  self.canClickLike = true
  self.canClickDislike = true
  self.noticeAddExtraJsonData = nil
  self.loopScroll = nil
  self.loopListIndex = nil
  base.OnDestroy(self)
end

function ChatItemNoticeDetail:OnEnable()
  base.OnEnable(self)
end

function ChatItemNoticeDetail:OnDisable()
  if self.data then
    DataCenter.AllianceNoticeManager:KillNoticeWaitTimer(self.data.uid)
  end
  base.OnDisable(self)
end

function ChatItemNoticeDetail:OnReportBtnClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIChatReport, {anim = true}, {
    type = ReportType.allianceNotice,
    allianceId = LuaEntry.Player.allianceId,
    noticeId = self.data.uid,
    uid = self.data.publisherUid
  })
end

function ChatItemNoticeDetail:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(ChatEventEnum.CHAT_ALLIANCE_NOTICEDATA_UPDATE, self.UpdateNoticeData)
  self:AddUIListener(EventId.ChatSendPhotoSetSuccess, self.SetUILoadedSuccessShow)
  self:AddUIListener(EventId.CHAT_NEWSCENTER_DATAS_UPDATE, self.GetNewsCenterDatasMsg)
end

function ChatItemNoticeDetail:OnRemoveListener()
  self:RemoveUIListener(ChatEventEnum.CHAT_ALLIANCE_NOTICEDATA_UPDATE, self.UpdateNoticeData)
  self:RemoveUIListener(EventId.ChatSendPhotoSetSuccess, self.SetUILoadedSuccessShow)
  self:RemoveUIListener(EventId.CHAT_NEWSCENTER_DATAS_UPDATE, self.GetNewsCenterDatasMsg)
  base.OnRemoveListener(self)
end

function ChatItemNoticeDetail:UpdateItemAfterTranslateRecv()
  self._contentViewScript:ReloadAfterTranslateRecv(self._chatIndex)
end

function ChatItemNoticeDetail:GoNoticeView()
  local data = DeepCopy(self.data)
  if self.view and self.view.ctrl then
    self.view.ctrl:CloseSelf()
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIAllianceNoticeDetail, {anim = true}, data)
  end
end

function ChatItemNoticeDetail:OnDeleteBtnClick()
  UIUtil.ShowSecondMessage("", Localization:GetString("2900058"), 2, 100190, "", function()
    DataCenter.AllianceNoticeManager:RefreshIsClosePinNotice(self.data.uid)
    SFSNetwork.SendMessage(MsgDefines.AllianceNoticeOpDel, self.data.uid, ChatManager2:GetInstance().Room:GetNoticeId(self.data.uid))
  end, nil, nil, nil, nil, nil, nil, nil, nil, false)
end

function ChatItemNoticeDetail:OnPinBtnClick()
  local isR4orR5 = DataCenter.AllianceBaseDataManager:IsR4orR5()
  if not isR4orR5 then
    return
  end
  local pinnedData = DataCenter.AllianceNoticeManager:GetNoticePinnedDataById(self.data.uid)
  local pinned = 1
  if pinnedData and pinnedData.pinnedTime and pinnedData.pinnedTime > 0 then
    pinned = 0
  end
  SFSNetwork.SendMessage(MsgDefines.AllianceNoticePinnedUpdate, self.data.uid, pinned)
end

function ChatItemNoticeDetail:ComponentDefine()
  self:DefineCompsByBook(compBook)
  self.txtRaw:OnPointerClick(function(eventData)
    self:OnTxtRawPointerClick(eventData.position)
  end)
end

function ChatItemNoticeDetail:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function ChatItemNoticeDetail:SetType(type)
  self.type = type or NoticeItemType.NoticePin
end

function ChatItemNoticeDetail:ShowInfo(data)
  local str = Localization:GetString(390009)
  if data.comment and data.comment > 0 then
    self.comment:SetText(str .. "(" .. data.comment .. ")")
  else
    self.comment:SetText(str)
  end
  self:RefreshLikeAndDislikeState(data)
  self.clickBtn_2:SetActive(false)
  self.clickBtn:SetActive(false)
  self:SetTextShowFunc()
  self.txtTrans:SetActive(data.transText)
  self.imgLine:SetActive(data.transText)
  self.txtTrans:SetText(data.transText or " ")
  self.txtTrans:SetBestFitEnable(false)
  self.btnClose:SetActive(false)
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
      self.delBtn:SetActive(true)
    else
      self.delBtn:SetActive(false)
    end
  else
    self.delBtn:SetActive(false)
  end
end

function ChatItemNoticeDetail:SetTextShowFunc()
  self.txtRaw.unity_tmpro:SetInputHtmlTagEmpty()
  self.txtRaw:SetText("")
  self.txtRaw.unity_tmpro:ForceMeshUpdate()
  if self.data.extraJsonData then
    local showNotice, noticeAddExtraJsonData = ChatInterface.GetShowNoticeAndAddTempData(self.data.content, self.data.extraJsonData)
    if noticeAddExtraJsonData then
      self.noticeAddExtraJsonData = noticeAddExtraJsonData
      for tagIndex = 1, #ChatAlNoticePosChangeTag do
        local tag = ChatAlNoticePosChangeTag[tagIndex]
        local pointShare = noticeAddExtraJsonData[tag]
        if pointShare and 0 < #pointShare then
          local maxLinkEndIndex = string.word_count(showNotice) - 1 - 1
          local fixedAddCharPosList = UIUtil.GetFixedArabicAddCharPosList(showNotice, self.txtRaw.unity_tmpro)
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
            local linkData = {}
            if tag == ChatAlNoticeSpecialDataType.PointShare then
              local shareData = data[ChatAlNoticeSpecialDataParamType.shareData]
              local jumpData = {
                x = shareData.x,
                y = shareData.y,
                wid = shareData.worldId,
                sid = shareData.sid
              }
              linkData = {tag = tag, data = jumpData}
            elseif tag == ChatAlNoticeSpecialDataType.NewsCenterURL then
              local shareData = data[ChatAlNoticeSpecialDataParamType.shareData]
              linkData = {tag = tag, data = shareData}
            end
            local json = rapidjson.encode(linkData)
            local linkId = base64.encode(json)
            local linkStarIndex = realIndex - 1
            local linkEndIndex = realEndIndex - 1 - 1
            if maxLinkEndIndex < linkEndIndex and maxLinkEndIndex > linkStarIndex then
              linkEndIndex = maxLinkEndIndex
            end
            self.txtRaw.unity_tmpro:AddInputHtmlTag("link=" .. linkId, "/link", linkStarIndex, linkEndIndex, true)
          end
        end
      end
    end
    self.txtRaw:SetText_NotNative(showNotice)
  else
    self.txtRaw:SetText_NotNative(self.data.content)
  end
end

function ChatItemNoticeDetail:GetNewsCenterDatasMsg()
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
    self:ShowInfo(self.data)
    EventManager:GetInstance():BroadcastDeferred(EventId.CHAT_ITEM_NEWSCENTER_DATA_GET)
  end
end

function ChatItemNoticeDetail:RefreshLikeAndDislikeState(data)
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

function ChatItemNoticeDetail:UpdateNoticeData(params)
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
      self:RefreshItemView(data, isSkipRefreshTmpShow)
      if self.loopScroll ~= nil and self.loopListIndex ~= nil then
        self.loopScroll:OnItemSizeChanged(self.loopListIndex)
      end
    end
  end
end

function ChatItemNoticeDetail:UpdateItem(data, index)
  function data.isFromAI()
    return false
  end
  
  base.UpdateItem(self, data, index)
  if data.type ~= ChatPinMessageType.AllianceNotice then
    return
  end
  if index then
    self.index = index
  end
  self:InitEmojiData(data)
  self:RefreshItemView(data, false)
end

function ChatItemNoticeDetail:SetLoopScrollData(loopScroll, loopListIndex)
  self.loopScroll = loopScroll
  self.loopListIndex = loopListIndex
end

function ChatItemNoticeDetail:InitEmojiData(data)
  self.emojisData1 = self.emojisData1 or {}
  self.emojisData1.count = data.like
  self.emojisData1.emoji = 1
  self.emojisData1.self = data.myLike
  self.emojisData2 = self.emojisData2 or {}
  self.emojisData2.count = data.unlike
  self.emojisData2.emoji = 2
  self.emojisData2.self = data.myDislike
end

function ChatItemNoticeDetail:RefreshItemView(data, isSkipRefreshTmpShow)
  if data.type ~= ChatPinMessageType.AllianceNotice then
    return
  end
  if data.isPinned then
    self.data = DataCenter.AllianceNoticeManager:GetNoticePinnedDataById(data.uid)
  else
    self.data = DataCenter.AllianceNoticeManager:GetNoticeDataById(data.uid)
  end
  if self.data == nil then
    return
  end
  self.noticeAddExtraJsonData = nil
  if not (self.topNormal and self.topEmergency) or not data then
    if not data then
      local ailId = LuaEntry.Player:GetAllianceUid()
      if ailId then
        Logger.LogInfo("not notice id : " .. data.uid .. "  -- " .. ailId)
      end
    end
    return
  end
  if self.data.scrollViewWidth then
    self.width = self.data.scrollViewWidth - 25
  end
  local str = ""
  if data.time then
    str = UITimeManager:GetInstance():ConvertServerTimeToLocalTime(data.time) .. " "
  end
  local publisherInfo = ChatManager2:GetInstance().User:getChatUserInfo(data.publisherUid)
  if not publisherInfo then
    self.txtPublisher:SetText(" ")
  else
    local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(data.publisherUid, publisherInfo:GetUserName())
    local nameStr = showName
    str = str .. nameStr
  end
  self.txtPublisher:SetText(str)
  if self.data.noticeType == ChatNoticeType.ALLIANCE_VOTE then
    self.topNormal.spritePath = nil
    self.topNormal:LoadSpriteAuto(ChatInterface.GetChatBigUIPath("zyf_lianmenggonggao_title_tiao2.png"))
    self.voteDetail:SetActive(true)
    if isSkipRefreshTmpShow then
      function self.voteDetail.updateCallBack()
        self:UpdateItemAfterTranslateRecv()
      end
    else
      self.voteDetail:ReInit(data, function()
        self:UpdateItemAfterTranslateRecv()
      end)
    end
    self.scrollText:SetActive(false)
    Canvas.ForceUpdateCanvases()
    local scrollHeight = self.voteDetail:GetSizeDelta().y
    local bottomY = self.voteDetail:GetAnchoredPosition().y - scrollHeight
    local bottomH = self.bottom:GetSizeDelta().y
    self.bottom:SetAnchoredPositionXY(self.bottom:GetAnchoredPositionX(), bottomY - distanceTags)
    local rect_sizeDelta_cx, _ = self.rectTransform:Get_sizeDelta()
    local likeLayoutH = 50
    local tagLayoutH = 50
    self.rectTransform:Set_sizeDelta(rect_sizeDelta_cx, -bottomY + bottomH + 112 + 88 + 40 - 138 + distanceTags + likeLayoutH)
    self.tagLayoutRoot:SetAnchoredPositionXY(0, bottomY)
    self.comment:SetAnchoredPositionXY(self.comment:GetAnchoredPositionX(), bottomY - bottomH - tagLayoutH + 10)
    self.likeLayout:SetAnchoredPositionXY(self.likeLayout:GetAnchoredPositionX(), bottomY - bottomH - tagLayoutH + 10)
    self.noticeItem.rectTransform:Set_sizeDelta(self.width, -bottomY + bottomH + 112 - 110 + distanceTags + likeLayoutH)
    self.noticeBg.rectTransform:Set_sizeDelta(rect_sizeDelta_cx, -bottomY + bottomH + 112 + 60 - 155 + distanceTags + likeLayoutH)
    self:ShowInfo(self.data)
    if not isSkipRefreshTmpShow then
      self.imgTranslated:SetActive(data.transText)
      self.nodeTranslating:SetActive(false)
      self.btnTranslate:SetActive(not data.transText)
    end
    self.btnUpgrade:SetActive(false)
    self.btnResend:SetActive(false)
    self.txtTitle:SetLocalText("alliance_post_poll")
    self.transCom:SetActive(false)
    self.select_img_list:SetActive(false)
    self.bottom_upgrade_btn:SetActive(false)
    local resendBtnBottomShow = DataCenter.AllianceBaseDataManager:IsR4orR5()
    self.bottom_resend_btn:SetActive(resendBtnBottomShow)
    self.bottom_close_btn:SetActive(false)
  else
    self.voteDetail:SetActive(false)
    self.transCom:SetActive(true)
    self.voteInfo:SetActive(false)
    self.scrollText:SetActive(true)
    self:ShowInfo(data)
    self:InitNormalNoticeInfo(data, isSkipRefreshTmpShow)
    self.txtTitle:SetLocalText("2900001")
  end
  self.txtEdited:SetActive(data.edited == 1)
  self:SetNoticeTag(data)
  local isShowPinnedBtn = DataCenter.AllianceBaseDataManager:IsR4orR5()
  self.pin_btn:SetActive(isShowPinnedBtn)
  if isShowPinnedBtn then
    local pinnedData = DataCenter.AllianceNoticeManager:GetNoticePinnedDataById(self.data.uid)
    local hasPinned = pinnedData and pinnedData.pinnedTime and pinnedData.pinnedTime ~= 0
    self.pin_select_icon:SetActive(hasPinned)
  end
  local selfSizeX, selfSizeY = self.noticeItem:GetSizeDeltaXY()
  self.contentRoot:SetSizeDeltaXY(selfSizeX, selfSizeY)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
end

function ChatItemNoticeDetail:InitNormalNoticeInfo(data, isSkipRefreshTmpShow)
  local path = data.isAdv and ChatInterface.GetChatBigUIPath("zyf_lianmenggonggao_title_tiao3.png") or ChatInterface.GetChatBigUIPath("zyf_lianmenggonggao_title_tiao.png")
  self.topNormal.spritePath = nil
  self.topNormal:LoadSpriteAuto(path)
  self.scrollContent:SetAnchoredPositionXY(0, 0)
  if not isSkipRefreshTmpShow then
    self.imgTranslated:SetActive(data.transText)
    self.nodeTranslating:SetActive(false)
    self.btnTranslate:SetActive(not data.transText)
  end
  local isHavePic = data:IsHaveNoticePicVer()
  local picH = 0
  if isHavePic then
    self.select_img_list:SetActive(true)
    picH = uploadImgDefaultSize
    local dataList = data:GetNoticePicListData()
    for i = 1, #dataList do
      local picSenderUidIn = dataList[i][AlNoticePicDataType.SenderUid]
      local picVerIn = dataList[i][AlNoticePicDataType.PicVer]
      dataList[i][AlNoticePicDataType.AssetKey] = CS.UploadImageManager.Instance:GenAssetKey(picSenderUidIn, picVerIn, false)
    end
    self.select_img_list:SetInputData(dataList, AlNoticeItemPicShowType.Detail, self.data)
  else
    self.select_img_list:SetActive(false)
  end
  self:RefreshfLayOut()
  local height = 10
  if self.scrollContent.rectTransform and self.scrollContent.rectTransform.sizeDelta then
    height = self.scrollContent.rectTransform.sizeDelta.y
  end
  local scrollHeight = math.max(height, 10)
  self.scrollText:SetSizeDeltaXY(self.scrollText:GetSizeDelta().x, scrollHeight)
  local contentWithBottomSpace = 10
  local bottomY = self.scrollText:GetAnchoredPositionY() - scrollHeight - contentWithBottomSpace - picH
  local bottomH = self.bottom:GetSizeDelta().y
  if isHavePic then
    self.select_img_list:SetAnchoredPositionXY(self.scrollText:GetAnchoredPositionX(), bottomY + picH + 6)
  end
  local isShowPinnedBtn = false
  local pinBtnH = 0
  if isShowPinnedBtn then
    pinBtnH = 75
  end
  local tagsHeight = data:GetIsR4R5() and distanceTags or 0
  self.bottom:SetAnchoredPositionXY(self.bottom:GetAnchoredPositionX(), bottomY - tagsHeight)
  local rect_sizeDelta_cx, _ = self.rectTransform:Get_sizeDelta()
  local commentChangeH = 57
  self.comment:SetAnchoredPositionXY(self.comment:GetAnchoredPositionX(), bottomY - tagsHeight - commentChangeH)
  self.likeLayout:SetAnchoredPositionXY(self.likeLayout:GetAnchoredPositionX(), bottomY - tagsHeight - commentChangeH)
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
  self.noticeItem.rectTransform:Set_sizeDelta(self.width, -bottomY + bottomH + 67 + 45 - 50 + distanceBetweenContentAndLike + tagsHeight + bottomBtnH)
  self.rectTransform:Set_sizeDelta(rect_sizeDelta_cx, -bottomY + bottomH + 67 + 45 + 88 + 40 - 50 + distanceBetweenContentAndLike + tagsHeight + pinBtnH - 45 + bottomBtnH)
  self.noticeBg.rectTransform:Set_sizeDelta(rect_sizeDelta_cx, -bottomY + bottomH + 67 + 45 + 70 - 50 + distanceBetweenContentAndLike + tagsHeight + pinBtnH - 70 + bottomBtnH)
  if string.IsNullOrEmpty(self.data.content) then
    self.imgTranslated:SetActive(false)
    self.nodeTranslating:SetActive(false)
    self.btnTranslate:SetActive(false)
  end
end

function ChatItemNoticeDetail:RefreshfLayOut()
  local LayoutRebuilder = CS.UnityEngine.UI.LayoutRebuilder
  LayoutRebuilder.ForceRebuildLayoutImmediate(self.scrollContent.transform)
  LayoutRebuilder.ForceRebuildLayoutImmediate(self.likeLayout.transform)
end

function ChatItemNoticeDetail:LocateContentToTranslated()
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

function ChatItemNoticeDetail:SetNoticeTag(data)
  if self.data.noticeType == ChatNoticeType.ALLIANCE_VOTE then
    self.tagLayoutRoot:SetActive(true)
    self.multipleText:ReInit({
      interval = 20,
      bgPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_tongmengliaotianyouhua_lan_tiao.png",
      text = data.voteData.voteInfo.type == VoteType.radio and "poll_singal" or "poll_multiple",
      islocalText = true
    })
    self.anonymouText:ReInit({
      interval = 20,
      bgPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_tongmengliaotianyouhua_lv_tiao.png",
      text = data.voteData.voteInfo.isCryptonym and "alliance_vote_option_anonymous" or "alliance_vote_option_public",
      islocalText = true
    })
  elseif self.data.noticeType == ChatNoticeType.NORMAL then
    self.tagLayoutRoot:SetActive(self.data:GetIsR4R5())
  end
  if self.data:GetIsR4R5() then
    self.onlyR4R5Text:ReInit({
      interval = 20,
      bgPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_tongmenggonggaoyouhua_di_purple.png",
      text = "alliance_announcement_r4r5",
      islocalText = true
    })
  end
  self.onlyR4R5Text:SetActive(self.data:GetIsR4R5())
  self.multipleText:SetActive(self.data.noticeType == ChatNoticeType.ALLIANCE_VOTE)
  self.anonymouText:SetActive(self.data.noticeType == ChatNoticeType.ALLIANCE_VOTE)
end

function ChatItemNoticeDetail:OnClickEmoji(emojiType)
  local publisherUid = self.data.publisherUid
  local noticeUid = self.data.uid
  local isWaitClickRespondCache = DataCenter.AllianceNoticeManager:GetIsWaitClickRespondCache(noticeUid)
  if isWaitClickRespondCache and isWaitClickRespondCache[2] then
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

function ChatItemNoticeDetail:OnClickUpgrade()
  local param = {
    data = self.data,
    dataType = AlNoticeInputDataType.AllianceNoticeData
  }
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIUpgradeAllianceNotice, {}, param)
end

function ChatItemNoticeDetail:OnClickResend()
  if self.data == nil then
    return
  end
  if self.data.type ~= ChatPinMessageType.AllianceNotice then
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

function ChatItemNoticeDetail:DoResend()
end

function ChatItemNoticeDetail:OnClickTranslate()
  if not self.data then
    return
  end
  if self.__waiting_for_translation_result then
    return
  end
  self.__waiting_for_translation_result = true
  self.btnTranslate:SetActive(false)
  self.nodeTranslating:SetActive(true)
  local toTranslateStr = self.data.content or ""
  if self.data.extraJsonData then
    local showNotice, noticeAddExtraJsonData = ChatInterface.GetShowNoticeAndAddTempData(self.data.content, self.data.extraJsonData, true)
    toTranslateStr = showNotice
  end
  ChatManager2:GetInstance().Translate:Translate(toTranslateStr, nil, nil, function(ok, rtnTbl)
    self.__waiting_for_translation_result = false
    if ok then
      DataCenter.AllianceNoticeManager:SaveTranslatedContentById(self.data.uid, rtnTbl.translateMsg)
      if self.view then
        self.data.transText = rtnTbl.translateMsg
        self:RefreshItemView(self.data, false)
        self:LocateContentToTranslated()
        self._contentViewScript:ReloadAfterTranslateRecv(self.index)
      end
    elseif self.view then
      self.btnTranslate:SetActive(true)
      self.nodeTranslating:SetActive(false)
      UIUtil.ShowTipsId(rtnTbl.code)
    end
  end, nil, nil, FakeChatGroupType.Fake_GROUP_ALLIANCE_NOTICE)
end

function ChatItemNoticeDetail:OnTxtRawPointerClick(clickPos)
  local linkId = self.txtRaw:TryGetPointerClickLinkID(clickPos)
  if string.IsNullOrEmpty(linkId) then
    return
  end
  local jsonData = base64.decode(linkId)
  if string.IsNullOrEmpty(jsonData) then
    return
  end
  local linkData = rapidjson.decode(jsonData)
  if linkData == nil then
    return
  end
  if linkData.tag == ChatAlNoticeSpecialDataType.PointShare then
    local chatData = {}
    local shareData = linkData.data
    if shareData.postType ~= nil then
      chatData.post = shareData.postType
    else
      chatData.post = PostType.Text_PointShare
    end
    chatData.param = shareData
    local shareStr = ShareDecode.Decode(chatData, shareData, true)
    local posX = shareData.x
    local posY = shareData.y
    local worldId = shareData.wid
    local sid = shareData.sid
    local point = SceneUtils.TilePosToIndex({x = posX, y = posY}, ForceChangeScene.World)
    UIUtil.ShowMessage(Localization:GetString("alliance_announcement_5", shareStr), 2, "", "", function()
      GoToUtil.CloseAllWindows()
      GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(point), nil, nil, nil, sid, worldId, nil)
    end, nil, nil, nil)
  elseif linkData.tag == ChatAlNoticeSpecialDataType.NewsCenterURL then
    local urlWiki = linkData.data
    local wikiChain = StringUtils.GetMD5(urlWiki)
    local state, data = DataCenter.LWNewsCenterManager:GetCacheInfoByWikiChain(wikiChain)
    local url = DataCenter.LWNewsCenterManager:GetLanguageUrl(urlWiki)
    if state == NewsChainDataState.HaveData and ChatInterface.NewsWikiTokenVerification() then
      local openUrl = DataCenter.LWNewsCenterManager:GetNewsCenterUrl(url, data, NewsCenterOpenType.NoticeDetail, true)
      if openUrl then
        DataCenter.LWNewsCenterManager:OnOpenNewsCenterURL({openUrl = openUrl}, NewsCenterOpenType.NoticeDetail)
      end
    else
      DataCenter.LWNewsCenterManager:OnOpenNewsCenterURL({openUrl = url}, NewsCenterOpenType.NoticeDetail)
    end
  end
end

function ChatItemNoticeDetail:OnClickBottomUpgrade()
  self:OnClickUpgrade()
end

function ChatItemNoticeDetail:OnClickBottomResend()
  self:OnClickResend()
end

function ChatItemNoticeDetail:OnClickBottomClose()
  self:OnDeleteBtnClick()
end

function ChatItemNoticeDetail:OnClickPinBtn()
  self:OnPinBtnClick()
end

function ChatItemNoticeDetail:SetUILoadedSuccessShow(assetKey)
  self.select_img_list:SetUILoadedSuccessShow(assetKey)
end

return ChatItemNoticeDetail
