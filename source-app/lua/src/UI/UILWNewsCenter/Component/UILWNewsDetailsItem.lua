local UILWNewsDetailsItem = BaseClass("UILWNewsDetailsItem", UIBaseContainer)
local base = UIBaseContainer
local translate_trans = "NormalBg"
local translate_btn_path = "NormalBg/TranslateBtn"
local translate_refresh_btn_path = "NormalBg/TranslateRefreshBtn"
local translate_finish_path = "NormalBg/TranslateFinishImg"
local translating_content_path = "NormalBg/Translating"
local translating_text_path = "NormalBg/Translating/TranslatingText"
local Localization = CS.GameEntry.Localization

function UILWNewsDetailsItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UILWNewsDetailsItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWNewsDetailsItem:ComponentDefine()
  self.titleText = self:AddComponent(UITextMeshProUGUIEx, "titleText")
  self.likeBtn = self:AddComponent(UIButton, "groupLike")
  self.likeText = self:AddComponent(UITextMeshProUGUIEx, "groupLike/txtLike")
  self.newTip = self:AddComponent(UIImage, "newTip")
  self.rawImg = self:AddComponent(UIRawImage, "rawImage")
  self.urlBtn = self:AddComponent(UIButton, "urlBtn")
  self.translateTrans = self:AddComponent(UIBaseContainer, translate_trans)
  self.translateBtn = self:AddComponent(UIButton, translate_btn_path)
  self.translateRefreshBtn = self:AddComponent(UIButton, translate_refresh_btn_path)
  self.translateFinishImg = self:AddComponent(UIBaseContainer, translate_finish_path)
  self.translating = self:AddComponent(UIBaseContainer, translating_content_path)
  self.translatingText = self:AddComponent(UIText, translating_text_path)
  self._UIChatSendPhoto = self.rawImg.gameObject:GetComponent(typeof(CS.UIChatSendPhoto))
  self.loadingImg = self:AddComponent(UIImage, "loading")
  self.loadFailImg = self:AddComponent(UIImage, "loadFail")
  self.shareBtn = self:AddComponent(UIButton, "shareBtn")
  self.copyUrlBtn = self:AddComponent(UIButton, "copyUrlBtn")
  self.translatingText:SetLocalText("120039")
  self.translateRefreshBtn:SetOnClick(function()
    self:TranslateMsgThenChangeType()
  end)
  self.shareBtn:SetOnClick(function()
    self:OnShareBtnClick()
  end)
  self.urlBtn:SetOnClick(function()
    PostEventLog.Track(PostEventLog.Defines.NewsCenterRead, {
      def_uid = self.data.uuid,
      action = "center"
    })
    local url = DataCenter.LWNewsCenterManager:GetLanguageUrl(self.data.urlWiki)
    if ChatInterface.NewsWikiTokenVerification() then
      local openUrl = DataCenter.LWNewsCenterManager:GetNewsCenterUrl(url, self.data, NewsCenterOpenType.News, true)
      if openUrl then
        EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_NEWSCENTER_OPEN_URL, {openUrl = openUrl})
      end
    else
      EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_NEWSCENTER_OPEN_URL, {openUrl = url})
    end
  end)
  self.likeBtn:SetOnClick(function()
    self:OnLikeClick()
  end)
  self.translateBtn:SetOnClick(function()
    self:TranslateMsg()
  end)
  self.copyUrlBtn:SetOnClick(function()
    local url = DataCenter.LWNewsCenterManager:GetLanguageUrl(self.data.urlWiki)
    if not string.IsNullOrEmpty(url) then
      CommonUtil.CopyTextToClipboard(url)
      UIUtil.ShowTipsId(128031)
    end
  end)
  self.loadingImg:SetActive(true)
  self.loadFailImg:SetActive(false)
end

function UILWNewsDetailsItem:OnShareBtnClick()
  local share_param = {}
  share_param.postType = PostType.NewsCenterLink
  share_param.uuid = self.data.uuid
  share_param.newsType = self.data.type
  local chatData = {}
  chatData.post = share_param.postType
  chatData.postType = share_param.postType
  chatData.param = share_param
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, chatData)
end

function UILWNewsDetailsItem:OnLikeClick()
  if not self.data or self.data.isLike then
    return
  end
  PostEventLog.Track(PostEventLog.Defines.NewsCenterLikeNum, {
    def_uid = self.data.uuid
  })
  self.view:ShowFloatLikeByPos(self.likeBtn.transform.position)
  ChatManager2:GetInstance().Net:SendSFSMessage(ChatMsgDefines.NewCenterLike, self.data.type, self.data.uuid)
  self.data.isLike = true
end

function UILWNewsDetailsItem:ComponentDestroy()
  self.titleText = nil
  self.likeBtn = nil
  self.likeText = nil
  self.newTip = nil
  self.rawImg = nil
  self.translateTrans = nil
  self.translateBtn = nil
  self.translateRefreshBtn = nil
  self.translateFinishImg = nil
  self.translating = nil
  self.translatingText = nil
  self._UIChatSendPhoto = nil
end

function UILWNewsDetailsItem:OnBtnClick()
  if self.callBack then
    self.callBack(self.data.type)
  end
end

function UILWNewsDetailsItem:TranslateMsgThenChangeType()
  self.data:SetTranslateState(1)
  local transType = self.data:GetTranslateType()
  if transType == nil then
    transType = 1
  elseif transType == 0 then
    transType = 1
  elseif transType == 1 then
    transType = 0
  end
  self.data:SetTranslateType(transType)
  ChatManager2:GetInstance().Translate:NewsCenterTranslate(self.data)
end

function UILWNewsDetailsItem:TranslateMsg()
  if self.data:IsTranslating() then
    return
  end
  self.data:SetTranslateState(1)
  local _translationMsg = self.data:GetTranslateMsg()
  if string.IsNullOrEmpty(_translationMsg) or self._chatData.translatedLang ~= ChatInterface.GetChatTranslateLanguageAbbr() then
    ChatManager2:GetInstance().Translate:NewsCenterTranslate(self.data)
  else
    self.data:SetTranslateState(0)
  end
  self:UpdateTranslateBtnState(self.data:IsTranslating(), self.data:GetTranslateState() == 2)
end

function UILWNewsDetailsItem:UpdateTranslateBtnState(isTranslating, hasTranslated)
  if self.translateBtn == nil then
    return
  end
  self.translating:SetActive(isTranslating and not hasTranslated)
  self.translateBtn:SetActive(not isTranslating and not hasTranslated)
  self.translateFinishImg:SetActive(hasTranslated and self.data:GetCanRefreshTranslate() == 1)
  self.translateRefreshBtn:SetActive(hasTranslated and self.data:GetCanRefreshTranslate() ~= 1)
end

function UILWNewsDetailsItem:UpdateItem(data)
  self.data = data
  self.assetKey = data.urlPic
  if not string.IsNullOrEmpty(data.translateMsg) and self.data.translatedLang == ChatInterface.GetChatTranslateLanguageAbbr() then
    self.titleText:SetText(data.translateMsg)
  else
    self.titleText:SetText(data.title)
  end
  if self.data.isLike then
    self.likeText:SetColorRGBA255(9, 155, 74)
  else
    self.likeText:SetColorRGBA255(105, 114, 99)
  end
  self.likeText:SetText(string.format("[%s]", data.likeCount))
  self.newTip:SetActive(data.isNew)
  self._UIChatSendPhoto:SetData(PhotoFuncType.NewsCenter, "", 0, self.assetKey)
  self._UIChatSendPhoto:StartUpdateSmallPhoto()
  self:UpdateTranslateBtnState(self.data:IsTranslating(), self.data:GetTranslateState() == 2)
end

function UILWNewsDetailsItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ChatSendPhotoSetSuccess, self.SetUILoadedSuccessShow)
  self:AddUIListener(EventId.ChatSendPhotoSetReload, self.SetUIReloadShow)
  self:AddUIListener(EventId.ChatSendPhotoSetLoading, self.SetUILoadingShow)
  self:AddUIListener(EventId.CHAT_NEWSCENTER_FINISHED, self.OnTranslate)
  self:AddUIListener(EventId.CHAT_NEWSCENTER_UPLIKECOUNT, self.OnUpLike)
end

function UILWNewsDetailsItem:OnRemoveListener()
  self:RemoveUIListener(EventId.ChatSendPhotoSetSuccess, self.SetUILoadedSuccessShow)
  self:RemoveUIListener(EventId.ChatSendPhotoSetReload, self.SetUIReloadShow)
  self:RemoveUIListener(EventId.ChatSendPhotoSetLoading, self.SetUILoadingShow)
  self:RemoveUIListener(EventId.CHAT_NEWSCENTER_FINISHED, self.OnTranslate)
  self:RemoveUIListener(EventId.CHAT_NEWSCENTER_UPLIKECOUNT, self.OnUpLike)
  base.OnRemoveListener(self)
end

function UILWNewsDetailsItem:SetUIReloadShow(assetKey)
  if assetKey ~= self.assetKey then
    return
  end
  self.loadingImg:SetActive(false)
  self.loadFailImg:SetActive(true)
end

function UILWNewsDetailsItem:OnUpLike(newsData)
  if self.data.uuid ~= newsData.uuid or self.data.type ~= newsData.type then
    return
  end
  self.data = newsData
  if self.data.isLike then
    self.likeText:SetColorRGBA255(9, 155, 74)
  else
    self.likeText:SetColorRGBA255(105, 114, 99)
  end
  self.likeText:SetText(string.format("[%s]", newsData.likeCount))
end

function UILWNewsDetailsItem:OnTranslate(newsData)
  if self.data.uuid ~= newsData.uuid then
    return
  end
  if not string.IsNullOrEmpty(newsData.translateMsg) and newsData.translatedLang == ChatInterface.GetChatTranslateLanguageAbbr() then
    self.titleText:SetText(newsData.translateMsg)
  end
  self:UpdateTranslateBtnState(self.data:IsTranslating(), self.data:GetTranslateState() == 2)
end

function UILWNewsDetailsItem:SetUILoadedSuccessShow(assetKey)
  if assetKey ~= self.assetKey then
    return
  end
  local cacheItem = self._UIChatSendPhoto:SetUILoadedSuccessShow(assetKey)
  if cacheItem == nil or IsNull(cacheItem) then
    return
  end
  self.rawImg:SetTexture(cacheItem.textureAsset)
  self.loadingImg:SetActive(false)
  self.loadFailImg:SetActive(false)
end

function UILWNewsDetailsItem:SetUILoadingShow()
  self.loadingImg:SetActive(true)
  self.loadFailImg:SetActive(false)
end

return UILWNewsDetailsItem
