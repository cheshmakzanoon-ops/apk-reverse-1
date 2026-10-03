local UINoticeRecordItem = BaseClass("UINoticeRecordItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local BGExpandText = require("UI.UIChatNew.Component.GeneralComponents.BGExpandText")
local AlNoticePicContent = require("UI.UIChatNew.Component.PicContent.AlNoticePicContent")
local base64 = require("Framework.Common.base64")
local rapidjson = require("rapidjson")
local ShareDecode = require("Chat.Other.ShareDecode")
local StringUtils = CS.StringUtils
local content_root_path = "ContentRoot"
local top_bg_path = "ContentRoot/topContent/topBg"
local txt_publisher_path = "ContentRoot/topContent/txtPublisher"
local operate_txt_content_path = "ContentRoot/operateTxtContent"
local operate_txt_path = "ContentRoot/operateTxtContent/operateTxt"
local notice_content_path = "ContentRoot/NoticeContent"
local vote_info_path = "ContentRoot/voteInfo"
local notice_info_content_path = "ContentRoot/noticeInfoContent"
local tag_layout_path = "ContentRoot/noticeInfoContent/tagLayout"
local anonymou_text_path = "ContentRoot/noticeInfoContent/tagLayout/anonymouText"
local multiple_text_path = "ContentRoot/noticeInfoContent/tagLayout/multipleText"
local only_r4_r5_text_path = "ContentRoot/noticeInfoContent/tagLayout/onlyR4R5Text"
local trans_path = "ContentRoot/noticeInfoContent/trans"
local node_translating_path = "ContentRoot/noticeInfoContent/trans/nodeTranslating"
local img_translated_path = "ContentRoot/noticeInfoContent/trans/imgTranslated"
local btn_translate_path = "ContentRoot/noticeInfoContent/trans/btnTranslate"
local vote_info_title_path = "ContentRoot/voteInfo/voteInfoTitle"
local scroll_text_path = "ContentRoot/NoticeContent/scrollText"
local content_path = "ContentRoot/NoticeContent/scrollText/Viewport/Content"
local txt_raw_path = "ContentRoot/NoticeContent/scrollText/Viewport/Content/txtRaw"
local img_line_path = "ContentRoot/NoticeContent/scrollText/Viewport/Content/imgLine"
local txt_trans_path = "ContentRoot/NoticeContent/scrollText/Viewport/Content/txtTrans"
local show_more_text_path = "ContentRoot/NoticeContent/ShowMoreText"
local select_img_list_path = "ContentRoot/NoticeContent/SelectImgList"
local itemTopSpace = 4
local itemBottomSpace = 12
local conetentSpace = 12
local topContentH = 52
local tagContentH = 52
local txtRawLRSpace = 5
local txtRawDefaultTopSpaceH = 5
local uploadImgDefaultSize = 106
local uploadImgSpace = 12
local distanceBetweenContentAndLike = 15
local distanceTags = 50
local showMoreTxtH = 38

function UINoticeRecordItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UINoticeRecordItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UINoticeRecordItem:OnEnable()
  base.OnEnable(self)
end

function UINoticeRecordItem:OnDisable()
  base.OnDisable(self)
end

function UINoticeRecordItem:ComponentDefine()
  self.content_root = self:AddComponent(UIBaseContainer, content_root_path)
  self.top_bg = self:AddComponent(UIImage, top_bg_path)
  self.txt_publisher = self:AddComponent(UITextMeshProUGUIEx, txt_publisher_path)
  self.operate_txt_content = self:AddComponent(UIBaseContainer, operate_txt_content_path)
  self.operate_txt = self:AddComponent(UITextMeshProUGUIEx, operate_txt_path)
  self.notice_content = self:AddComponent(UIBaseContainer, notice_content_path)
  self.vote_info = self:AddComponent(UIBaseContainer, vote_info_path)
  self.notice_info_content = self:AddComponent(UIBaseContainer, notice_info_content_path)
  self.tag_layout = self:AddComponent(UIBaseContainer, tag_layout_path)
  self.anonymou_text = self:AddComponent(BGExpandText, anonymou_text_path)
  self.multiple_text = self:AddComponent(BGExpandText, multiple_text_path)
  self.only_r4_r5_text = self:AddComponent(BGExpandText, only_r4_r5_text_path)
  self.trans = self:AddComponent(UIBaseContainer, trans_path)
  self.node_translating = self:AddComponent(UIImage, node_translating_path)
  self.img_translated = self:AddComponent(UIImage, img_translated_path)
  self.btn_translate = self:AddComponent(UIButton, btn_translate_path)
  self.vote_info_title = self:AddComponent(UITextMeshProUGUIEx, vote_info_title_path)
  self.scrollText = self:AddComponent(UIBaseContainer, scroll_text_path)
  self.scrollContent = self:AddComponent(UIImage, content_path)
  self.txtRaw = self:AddComponent(UITextMeshProUGUIEx, txt_raw_path)
  self.imgLine = self:AddComponent(UIImage, img_line_path)
  self.txtTrans = self:AddComponent(UITextMeshProUGUIEx, txt_trans_path)
  self.showMoreText = self:AddComponent(UITextMeshProUGUIEx, show_more_text_path)
  self.select_img_list = self:AddComponent(AlNoticePicContent, select_img_list_path)
  self.btn_translate:SetOnClick(function()
    self:OnTranslateBtnClick()
  end)
  self.txtRaw:OnPointerClick(function(eventData)
    self:OnTxtRawPointerClick(eventData.position)
  end)
  self.operate_txt:OnPointerClick(function(eventData)
    self:OnTxtOperatePointerClick(eventData.position)
  end)
end

function UINoticeRecordItem:ComponentDestroy()
  self.content_root = nil
  self.top_bg = nil
  self.txt_publisher = nil
  self.operate_txt_content = nil
  self.operate_txt = nil
  self.notice_content = nil
  self.vote_info = nil
  self.notice_info_content = nil
  self.tag_layout = nil
  self.anonymou_text = nil
  self.multiple_text = nil
  self.only_r4_r5_text = nil
  self.trans = nil
  self.node_translating = nil
  self.img_translated = nil
  self.btn_translate = nil
  self.vote_info_title = nil
  self.scrollText = nil
  self.scrollContent = nil
  self.txtRaw = nil
  self.imgLine = nil
  self.txtTrans = nil
  self.showMoreText = nil
  self.select_img_list = nil
end

function UINoticeRecordItem:DataDefine()
  self.data = nil
  self.dataIndex = nil
  self.id = nil
  self.recordData = nil
  self.isNoticeInfoShow = false
  self.scroll = nil
end

function UINoticeRecordItem:DataDestroy()
  self.data = nil
  self.dataIndex = nil
  self.id = nil
  self.recordData = nil
  self.isNoticeInfoShow = nil
  self.scroll = nil
end

function UINoticeRecordItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ChatSendPhotoSetSuccess, self.SetUILoadedSuccessShow)
  self:AddUIListener(EventId.CHAT_NEWSCENTER_DATAS_UPDATE, self.GetNewsCenterDatasMsg)
end

function UINoticeRecordItem:OnRemoveListener()
  self:RemoveUIListener(EventId.ChatSendPhotoSetSuccess, self.SetUILoadedSuccessShow)
  self:RemoveUIListener(EventId.CHAT_NEWSCENTER_DATAS_UPDATE, self.GetNewsCenterDatasMsg)
  base.OnRemoveListener(self)
end

function UINoticeRecordItem:SetData(data, scroll, dataIndex)
  if data == nil then
    return
  end
  self.data = data
  self.scroll = scroll
  self.dataIndex = dataIndex
  self.id = data.id
  self.recordData = DataCenter.AllianceNoticeRecordManager:GetDataById(data.id)
  self:RefreshView()
end

function UINoticeRecordItem:RefreshView()
  if self.data == nil or self.recordData == nil then
    return
  end
  self:RefreshTopContentView()
  self:RefreshOperateTxtContentView()
  self:RefreshNoticeContentView()
  self:RefreshNoticeInfoContentView()
  self:RefreshBgContent()
end

function UINoticeRecordItem:RefreshTopContentView()
  local operateType = self.recordData.operateType
  local time = self.recordData.time
  local filterCfgData = self.view.ctrl:GetFilterTypeConfig(operateType)
  if filterCfgData == nil then
    return
  end
  local spriteName = filterCfgData.TopBg
  if spriteName then
    self.top_bg:LoadSpriteAuto(string.format(LoadPath.UINoticeRecordSpritePath, spriteName))
  end
  local timeStr = UITimeManager:GetInstance():ConvertServerTimeToLocalTime(time)
  self.txt_publisher:SetText(timeStr)
end

function UINoticeRecordItem:RefreshOperateTxtContentView()
  local operateType = self.recordData.operateType
  local playerName = self.recordData.playerName or ""
  local playerUid = self.recordData.playerUid or ""
  local filterCfgData = self.view.ctrl:GetFilterTypeConfig(operateType)
  if filterCfgData == nil then
    return
  end
  local descKey = filterCfgData.descKey
  local nameRichTxt = string.format("<color=#249bc5><u><link=" .. playerUid .. ">%s</link></u></color>", playerName)
  local showStr = Localization:GetString(descKey, nameRichTxt)
  self.operate_txt:SetText(showStr)
  local txtSize = self.operate_txt:GetSizeDelta()
  local txtVal = self.operate_txt.unity_tmpro:GetPreferredValues(txtSize.x, 0)
  self.operate_txt:SetSizeDeltaY(txtVal.y)
  self.operate_txt_content:SetSizeDeltaY(txtVal.y)
end

function UINoticeRecordItem:RefreshNoticeContentView()
  local noticeType = self.recordData.noticeDataDecode.noticeType
  if noticeType == ChatNoticeType.ALLIANCE_VOTE then
    self.vote_info:SetActive(true)
    self.notice_content:SetActive(false)
    self:RefreshVoteTypeView()
  else
    self.vote_info:SetActive(false)
    self.notice_content:SetActive(true)
    self:RefreshNoticeTypeView()
  end
end

function UINoticeRecordItem:RefreshVoteTypeView()
  local txtMinH = 110
  local txtSpace = 26
  local curH = 0
  if self.recordData.voteData then
    local titleStr = self.recordData.voteData.title
    local translateState, translateText = DataCenter.TranslateResultSaveDataManager:GetTranslateResult(TranslateSaveDataFuncType.NoticeRecord, self.recordData.uuid)
    if translateState == TranslateStateType.TranslationCompleted then
      titleStr = translateText
    end
    self.vote_info_title:SetText(titleStr)
    local txtSize = self.vote_info_title:GetSizeDelta()
    local txtVal = self.vote_info_title.unity_tmpro:GetPreferredValues(txtSize.x, 0)
    curH = txtVal.y
  end
  if txtMinH > curH then
    curH = txtMinH
  end
  local contentH = curH + txtSpace * 2
  self.vote_info:SetSizeDeltaY(contentH)
end

function UINoticeRecordItem:RefreshNoticeTypeView()
  self:InitNormalNoticeInfo()
end

function UINoticeRecordItem:RefreshNoticeInfoContentView()
  local isHaveTrans = self:RefreshTagContent()
  local isHaveTag = self:RefreshTransContent()
  self.isNoticeInfoShow = isHaveTrans or isHaveTag
  self.notice_info_content:SetActive(self.isNoticeInfoShow)
end

function UINoticeRecordItem:RefreshTagContent()
  local noticeType = self.recordData.noticeDataDecode.noticeType
  local isHaveTag = false
  if noticeType == ChatNoticeType.ALLIANCE_VOTE then
    self.multiple_text:ReInit({
      interval = 20,
      bgPath = ChatInterface.GetChatUIPath("ChatNotice/zyf_tongmengliaotianyouhua_lan_tiao.png"),
      text = self.recordData.voteData.type == VoteType.radio and "poll_singal" or "poll_multiple",
      islocalText = true
    })
    self.anonymou_text:ReInit({
      interval = 20,
      bgPath = ChatInterface.GetChatUIPath("ChatNotice/zyf_tongmengliaotianyouhua_lv_tiao.png"),
      text = self.recordData.voteData.isCryptonym and "alliance_vote_option_anonymous" or "alliance_vote_option_public",
      islocalText = true
    })
  end
  self.only_r4_r5_text:ReInit({
    interval = 20,
    bgPath = ChatInterface.GetChatUIPath("ChatNotice/zyf_tongmenggonggaoyouhua_di_purple.png"),
    text = "alliance_announcement_r4r5",
    islocalText = true
  })
  self.anonymou_text:SetActive(false)
  self.multiple_text:SetActive(false)
  self.only_r4_r5_text:SetActive(false)
  if noticeType == ChatNoticeType.ALLIANCE_VOTE then
    self.anonymou_text:SetActive(true)
    self.multiple_text:SetActive(true)
    isHaveTag = true
  else
  end
  local isR4OrR5 = self.recordData.noticeDataDecode.isR4R5 == 1
  if isR4OrR5 then
    self.only_r4_r5_text:SetActive(true)
    isHaveTag = true
  end
  if isHaveTag then
    self.tag_layout:SetActive(true)
  else
    self.tag_layout:SetActive(false)
  end
  return isHaveTag
end

function UINoticeRecordItem:RefreshTransContent()
  local noticeType = self.recordData.noticeDataDecode.noticeType
  local isHaveTrans = false
  if noticeType == ChatNoticeType.ALLIANCE_VOTE then
    isHaveTrans = true
  else
    local content = self.recordData.noticeDataDecode.notice
    if not string.IsNullOrEmpty(content) then
      isHaveTrans = true
    end
  end
  if isHaveTrans then
    self.trans:SetActive(true)
    local translateState, translateText = DataCenter.TranslateResultSaveDataManager:GetTranslateResult(TranslateSaveDataFuncType.NoticeRecord, self.recordData.uuid)
    self.node_translating:SetActive(translateState == TranslateStateType.Translating)
    self.img_translated:SetActive(translateState == TranslateStateType.TranslationCompleted)
    self.btn_translate:SetActive(translateState == TranslateStateType.NotTranslated or translateState == TranslateStateType.TranslationError)
  else
    self.trans:SetActive(false)
  end
  return isHaveTrans
end

function UINoticeRecordItem:RefreshBgContent()
  local noticeType = self.recordData.noticeDataDecode.noticeType
  local totalH = 0
  totalH = totalH + itemTopSpace
  totalH = totalH + topContentH
  self.operate_txt_content:SetAnchoredPositionXY(0, -1 * totalH)
  local opTxtSize = self.operate_txt_content:GetSizeDelta()
  totalH = totalH + opTxtSize.y
  totalH = totalH + conetentSpace
  if noticeType == ChatNoticeType.ALLIANCE_VOTE then
    self.vote_info:SetAnchoredPositionXY(0, -1 * totalH)
    local contentSize = self.vote_info:GetSizeDelta()
    totalH = totalH + contentSize.y
  else
    self.notice_content:SetAnchoredPositionXY(0, -1 * totalH)
    local contentSize = self.notice_content:GetSizeDelta()
    totalH = totalH + contentSize.y
  end
  if self.isNoticeInfoShow then
    totalH = totalH + conetentSpace
    self.notice_info_content:SetAnchoredPositionXY(0, -1 * totalH)
    local contentSize = self.notice_info_content:GetSizeDelta()
    totalH = totalH + contentSize.y
  end
  totalH = totalH + itemBottomSpace
  self.content_root:SetSizeDeltaY(totalH)
  self:SetSizeDeltaY(totalH)
end

function UINoticeRecordItem:SetUILoadedSuccessShow(assetKey)
  self.select_img_list:SetUILoadedSuccessShow(assetKey)
end

function UINoticeRecordItem:InitNormalNoticeInfo()
  local data = self.recordData.noticeDataDecode
  local isHavePic = self.recordData:IsHaveNoticePicVer()
  local picH = 0
  local txtContentSize = self.scrollText:GetSizeDelta()
  local textRawSizeX = txtContentSize.x - txtRawLRSpace * 2
  if isHavePic then
    self.select_img_list:SetActive(true)
    textRawSizeX = textRawSizeX - uploadImgDefaultSize - uploadImgSpace * 2
    local scrollTextAnchPos = self.scrollText:GetAnchoredPosition()
    self.select_img_list:SetAnchoredPositionXY(scrollTextAnchPos.x + txtContentSize.x / 2 - uploadImgSpace - uploadImgDefaultSize, scrollTextAnchPos.y - uploadImgSpace)
    self.select_img_list:SetSizeDeltaXY(uploadImgDefaultSize, uploadImgDefaultSize)
    picH = uploadImgDefaultSize + uploadImgSpace * 2
    local dataList = self.recordData:GetNoticePicListData()
    for i = 1, #dataList do
      local picSenderUidIn = dataList[i][AlNoticePicDataType.SenderUid]
      local picVerIn = dataList[i][AlNoticePicDataType.PicVer]
      dataList[i][AlNoticePicDataType.AssetKey] = CS.UploadImageManager.Instance:GenAssetKey(picSenderUidIn, picVerIn, false)
    end
    self.select_img_list:SetInputData(dataList, AlNoticeItemPicShowType.Normal, self.recordData, uploadImgDefaultSize, true)
  else
    self.select_img_list:SetActive(false)
  end
  self.txtRaw:SetSizeDeltaXY(textRawSizeX, 1000)
  self.imgLine:SetSizeDeltaX(textRawSizeX)
  self.txtTrans:SetSizeDeltaXY(textRawSizeX, 1000)
  self:SetTextShowFunc()
  self.scrollContent:SetAnchoredPositionXY(0, 0)
  local rawTxtContentVal = self.txtRaw.unity_tmpro:GetPreferredValues(self.txtRaw:GetSizeDelta().x, 0)
  self.txtRaw.unity_tmpro:ForceMeshUpdate()
  self.txtTrans.unity_tmpro:ForceMeshUpdate()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.scrollContent.transform)
  local contentSize = self.scrollContent:GetSizeDelta()
  local height = contentSize.y
  local textContentShowH = 0
  if isHavePic then
    if picH > height + txtRawDefaultTopSpaceH then
      textContentShowH = picH
    else
      textContentShowH = height + txtRawDefaultTopSpaceH
    end
  else
    textContentShowH = height
  end
  self.showMoreText:SetActive(false)
  local scrollHeight = textContentShowH + 2
  scrollHeight = math.max(scrollHeight, 50)
  self.scrollText:SetSizeDeltaXY(self.scrollText:GetSizeDelta().x, scrollHeight)
  self.scrollContent:SetSizeDeltaXY(self.scrollContent:GetSizeDelta().x, scrollHeight)
  self.notice_content:SetSizeDeltaY(scrollHeight)
end

function UINoticeRecordItem:SetTextShowFunc()
  self.txtRaw.unity_tmpro:SetInputHtmlTagEmpty()
  self.txtRaw:SetText("")
  self.txtRaw.unity_tmpro:ForceMeshUpdate()
  local data = self.recordData.noticeDataDecode
  if data.extraJsonData then
    local showNotice, noticeAddExtraJsonData = ChatInterface.GetShowNoticeAndAddTempData(data.notice, data.extraJsonData)
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
    self.txtRaw:SetText_NotNative(data.notice)
  end
  local translateState, translateText = DataCenter.TranslateResultSaveDataManager:GetTranslateResult(TranslateSaveDataFuncType.NoticeRecord, self.recordData.uuid)
  local transText
  if translateState == TranslateStateType.TranslationCompleted then
    transText = translateText
  else
    if translateState == TranslateStateType.Translating then
    else
    end
  end
  self.txtTrans:SetActive(transText)
  self.imgLine:SetActive(transText)
  self.txtTrans:SetText(transText or " ")
end

function UINoticeRecordItem:OnTranslateBtnClick()
  if self.recordData == nil then
    return
  end
  local uuid = self.recordData.uuid
  local translateType = TranslateSaveDataFuncType.NoticeRecord
  local noticeType = self.recordData.noticeDataDecode.noticeType
  DataCenter.TranslateResultSaveDataManager:SetTranslateStateDoing(translateType, uuid)
  self:ShowInfo()
  local content = ""
  if noticeType == ChatNoticeType.ALLIANCE_VOTE then
    content = self.recordData.voteData.title
  else
    content = self.recordData.noticeDataDecode.notice
    if self.recordData.noticeDataDecode.extraJsonData then
      content = ChatInterface.GetShowNoticeAndAddTempData(self.recordData.noticeDataDecode.notice, self.recordData.noticeDataDecode.extraJsonData, true)
    end
  end
  ChatManager2:GetInstance().Translate:Translate(content, nil, nil, function(ok, data)
    if not data or data.code ~= 0 then
      DataCenter.TranslateResultSaveDataManager:ClearTranslateResult(translateType, uuid)
    else
      DataCenter.TranslateResultSaveDataManager:SaveTranslateResult(translateType, uuid, data.translateMsg)
    end
    if self.view and self.view.ctrl then
      self:ShowInfo()
    end
  end)
end

function UINoticeRecordItem:GetNewsCenterDatasMsg()
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
    self:ShowInfo()
  end
end

function UINoticeRecordItem:ShowInfo()
  self:RefreshNoticeContentView()
  self:RefreshNoticeInfoContentView()
  self:RefreshBgContent()
  self.scroll:OnItemSizeChanged(self.dataIndex)
end

function UINoticeRecordItem:OnTxtRawPointerClick(clickPos)
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
      local openUrl = DataCenter.LWNewsCenterManager:GetNewsCenterUrl(url, data, NewsCenterOpenType.NoticeRecord, true)
      if openUrl then
        DataCenter.LWNewsCenterManager:OnOpenNewsCenterURL({openUrl = openUrl}, NewsCenterOpenType.NoticeRecord)
      end
    else
      DataCenter.LWNewsCenterManager:OnOpenNewsCenterURL({openUrl = url}, NewsCenterOpenType.NoticeRecord)
    end
  end
end

function UINoticeRecordItem:OnTxtOperatePointerClick(clickPos)
  local linkId = self.operate_txt:TryGetPointerClickLinkID(clickPos)
  if string.IsNullOrEmpty(linkId) then
    return
  end
  local playerUid = linkId
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true, hideTop = false}, playerUid)
end

return UINoticeRecordItem
