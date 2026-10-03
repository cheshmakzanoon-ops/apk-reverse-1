local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local ChatItemPost_AllianceNotice = BaseClass("ChatItemPost_AllianceNotice", IChatItemPost)
local base = IChatItemPost
local ChatUploadPhoto = require("UI.UIChatNew.Component.UploadPhoto.ChatUploadPhoto")
local rapidjson = require("rapidjson")
local base64 = require("Framework.Common.base64")
local Localization = CS.GameEntry.Localization
local ExecuteEvents = CS.UnityEngine.EventSystems.ExecuteEvents
local ShareDecode = require("Chat.Other.ShareDecode")
local StringUtils = CS.StringUtils
local uploadImgDefaultSize = 96
local uploadImgHeightMax = 140

function ChatItemPost_AllianceNotice:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatItemPost_AllianceNotice:ComponentDefine()
  self.bar = self:AddComponent(UIImage, "bar")
  self.txt_title = self:AddComponent(UITextMeshProUGUIEx, "bar/txtTitle")
  self.txt_edited = self:AddComponent(UITextMeshProUGUIEx, "bar/txtEdited")
  self.text = self:AddComponent(UITextMeshProUGUIEx, "Text")
  self._rootPhoto = self:AddComponent(UIBaseContainer, "RootPhoto")
  self._photoComponent = self:AddComponent(ChatUploadPhoto, "RootPhoto/ChatUploadPhoto")
  self.text:OnPointerClick(function(eventData)
    self:OnTxtRawPointerClick(eventData)
  end)
end

function ChatItemPost_AllianceNotice:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.CHAT_NEWSCENTER_DATAS_UPDATE, self.GetNewsCenterDatasMsg)
end

function ChatItemPost_AllianceNotice:OnRemoveListener()
  self:RemoveUIListener(EventId.CHAT_NEWSCENTER_DATAS_UPDATE, self.GetNewsCenterDatasMsg)
  base.OnRemoveListener(self)
end

function ChatItemPost_AllianceNotice:OnLoaded()
  self.noticeAddExtraJsonData = nil
  local path, key
  if self:ChatData().extra.noticeType == ChatNoticeType.ALLIANCE_VOTE then
    path = ChatInterface.GetChatUIPath("ChatNotice/zyf_tongmenggonggao_gonggaokuang_biaoti.png")
    key = "alliance_post_poll"
  else
    path = ChatInterface.GetChatUIPath("ChatNotice/sj_liaotian_gonggaobg.png")
    key = "2900001"
  end
  self.bar:LoadSprite(path)
  self.txt_title:SetLocalText(key)
  self.txt_edited:SetActive(self:ChatData():IsNoticeEdited())
  self:SetMessageTxt()
  local isHavePic = self:ChatData():IsNoticeHavePicListData()
  local picSpace = 2
  local picContentW = 0
  if isHavePic then
    local picDataList = self:ChatData():GetNoticePicListData()
    local picVer, picSenderUid, smallHeight, smallWidth, bigHeight, bigWidth
    if picDataList and 0 < #picDataList then
      local picData = picDataList[1]
      picVer = picData[AlNoticePicDataType.PicVer]
      picSenderUid = picData[AlNoticePicDataType.SenderUid]
      smallHeight = picData[AlNoticePicDataType.SmallHeight] or 1
      smallWidth = picData[AlNoticePicDataType.SmallWidth] or 1
      bigHeight = picData[AlNoticePicDataType.BigHeight] or 1
      bigWidth = picData[AlNoticePicDataType.BigWidth] or 1
    end
    self._rootPhoto:SetActive(true)
    local showPicW = uploadImgDefaultSize
    local showPicH = uploadImgDefaultSize
    local showPicContentW = uploadImgDefaultSize
    local showPicContentH = uploadImgDefaultSize
    if smallHeight <= smallWidth then
      showPicW = uploadImgDefaultSize / smallHeight * smallWidth
    else
      showPicH = uploadImgDefaultSize / smallWidth * smallHeight
      showPicContentH = math.min(uploadImgHeightMax, showPicH)
    end
    self._rootPhoto:SetSizeDeltaXY(showPicContentW, showPicContentH)
    self._photoComponent:OnLoaded(nil, {
      picVer = picVer,
      senderUid = picSenderUid,
      bigWidth = showPicW,
      bigHeight = showPicH,
      isAdaptSize = false,
      isSizeSameContent = true,
      contentW = showPicContentW,
      contentH = showPicContentH
    }, {
      type = ReportType.chatPhoto,
      chatData = self:ChatData()
    })
    self._photoComponent:UpdatePhoto()
    picContentW = showPicContentW + picSpace
  else
    self._rootPhoto:SetActive(false)
  end
  local itemContentMaxWidth = 560
  local txtMaxWidth = itemContentMaxWidth - picContentW
  local preferredValues = self.text.unity_tmpro:GetPreferredValues(txtMaxWidth, 0)
  local textShowWidth = txtMaxWidth < preferredValues.x and txtMaxWidth or preferredValues.x
  self.text.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Horizontal, textShowWidth)
  self.text.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Vertical, preferredValues.y)
  if isHavePic then
    local txtAnchoredPos = self.text:GetAnchoredPosition()
    self._rootPhoto:SetAnchoredPositionXY(txtAnchoredPos.x + txtMaxWidth, txtAnchoredPos.y)
  end
end

function ChatItemPost_AllianceNotice:GetNewsCenterDatasMsg()
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
    EventManager:GetInstance():BroadcastDeferred(EventId.CHAT_ITEM_NEWSCENTER_DATA_GET)
  end
end

function ChatItemPost_AllianceNotice:OnRecycle()
end

function ChatItemPost_AllianceNotice:SetMessageTxt()
  local chatData = self:ChatData()
  if chatData == nil then
    return
  end
  self.text.unity_tmpro:SetInputHtmlTagEmpty()
  if chatData.extraJsonData then
    local showNotice, noticeAddExtraJsonData = ChatInterface.GetShowNoticeAndAddTempData(chatData:getMsg(), chatData.extraJsonData)
    if noticeAddExtraJsonData then
      self.noticeAddExtraJsonData = noticeAddExtraJsonData
      for tagIndex = 1, #ChatAlNoticePosChangeTag do
        local tag = ChatAlNoticePosChangeTag[tagIndex]
        local pointShare = noticeAddExtraJsonData[tag]
        if pointShare and 0 < #pointShare then
          local maxLinkEndIndex = string.word_count(showNotice) - 1 - 1
          local fixedAddCharPosList = UIUtil.GetFixedArabicAddCharPosList(showNotice, self.text.unity_tmpro)
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
            self.text.unity_tmpro:AddInputHtmlTag("color=#249bc5", "/color", realIndex - 1, realEndIndex - 1)
            self.text.unity_tmpro:AddInputHtmlTag("u", "/u", realIndex - 1, realEndIndex - 1)
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
            self.text.unity_tmpro:AddInputHtmlTag("link=" .. linkId, "/link", linkStarIndex, linkEndIndex, true)
          end
        end
      end
    end
    self.text:SetText_NotNative(showNotice)
  else
    local message = self:ChatData():getSuperParsedResult()
    if message == nil then
      message = self:ChatData():getMessageWithExtra(false)
      self:ChatData():setSuperParsedResult(message)
    end
    self.text:SetText_NotNative(message)
  end
end

function ChatItemPost_AllianceNotice:OnTxtRawPointerClick(eventData)
  local clickPos = eventData.position
  local linkId = self.text:TryGetPointerClickLinkID(clickPos)
  if string.IsNullOrEmpty(linkId) then
    local targetObj = self.gameObject
    local deepFindLen = 2
    for i = 1, deepFindLen do
      local parent = targetObj.transform.parent
      if IsNull(parent) then
        break
      end
      targetObj = parent.gameObject
      if self.text.unity_tmpro:ThroughPointerClickHandler(targetObj, eventData) then
        break
      end
    end
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
    if posX == nil or posY == nil then
      return
    end
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
      local openUrl = DataCenter.LWNewsCenterManager:GetNewsCenterUrl(url, data, NewsCenterOpenType.Chat, true)
      if openUrl then
        DataCenter.LWNewsCenterManager:OnOpenNewsCenterURL({openUrl = openUrl}, NewsCenterOpenType.Chat)
      end
    else
      DataCenter.LWNewsCenterManager:OnOpenNewsCenterURL({openUrl = url}, NewsCenterOpenType.Chat)
    end
  end
end

return ChatItemPost_AllianceNotice
