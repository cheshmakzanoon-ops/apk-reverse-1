local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local base = IChatItemPost
local NewsCenterLink = BaseClass("NewsCenterLink", IChatItemPost)
local Localization = CS.GameEntry.Localization
local raw_black_path = "rawBg/rawIcon/rawBlack"
local bg_black_path = "BgBtn/bgBlack"
local rapidjson = require("rapidjson")

function NewsCenterLink:OnLoaded()
  self:UpdateItem(self:ChatData())
end

function NewsCenterLink:ComponentDestroy()
end

function NewsCenterLink:ComponentDefine()
  self.titleText = self:AddComponent(UITextMeshProUGUIEx, "text")
  self.btn = self:AddComponent(UIButton, "BgBtn")
  self.rawImg = self:AddComponent(UIRawImage, "rawBg/rawIcon")
  self.rawBlackImg = self:AddComponent(UIImage, raw_black_path)
  self.bgBlackImg = self:AddComponent(UIImage, bg_black_path)
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.newsIcon = self:AddComponent(UIImage, "icon")
  self._UIChatSendPhoto = self.rawImg.gameObject:GetComponent(typeof(CS.UIChatSendPhoto))
end

function NewsCenterLink:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function NewsCenterLink:OnBtnClick()
  if self.info then
    PostEventLog.Track(PostEventLog.Defines.NewsCenterRead, {
      def_uid = self.param.uuid,
      action = "share"
    })
    local url = DataCenter.LWNewsCenterManager:GetLanguageUrl(self.info.urlWiki)
    if ChatInterface.NewsWikiTokenVerification() then
      local openUrl = DataCenter.LWNewsCenterManager:GetNewsCenterUrl(url, self.info, NewsCenterOpenType.Chat, true)
      if openUrl then
        EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_NEWSCENTER_CHATVIEW_OPENURL, {openUrl = openUrl})
      end
    else
      EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_NEWSCENTER_CHATVIEW_OPENURL, {openUrl = url})
    end
  else
    UIUtil.ShowTipsId("news_center_share_tips_1")
  end
end

function NewsCenterLink:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(ChatEventEnum.CHAT_NEWSCENTER_CACHEUPDATE, self.RefreshView)
  self:AddUIListener(EventId.ChatSendPhotoSetSuccess, self.SetUILoadedSuccessShow)
  self:AddUIListener(EventId.ChatSendPhotoSetReload, self.SetUIReloadShow)
  self:AddUIListener(EventId.ChatSendPhotoSetLoading, self.SetUILoadingShow)
end

function NewsCenterLink:OnRemoveListener()
  self:RemoveUIListener(ChatEventEnum.CHAT_NEWSCENTER_CACHEUPDATE, self.RefreshView)
  self:RemoveUIListener(EventId.ChatSendPhotoSetSuccess, self.SetUILoadedSuccessShow)
  self:RemoveUIListener(EventId.ChatSendPhotoSetReload, self.SetUIReloadShow)
  self:RemoveUIListener(EventId.ChatSendPhotoSetLoading, self.SetUILoadingShow)
  base.OnRemoveListener(self)
end

function NewsCenterLink:SetUILoadedSuccessShow(assetKey)
  if assetKey ~= self.assetKey then
    return
  end
  local cacheItem = self._UIChatSendPhoto:SetUILoadedSuccessShow(assetKey)
  if cacheItem == nil or IsNull(cacheItem) then
    return
  end
  self.rawImg:SetTexture(cacheItem.textureAsset)
  self.newsIcon:SetActive(false)
end

function NewsCenterLink:SetUIReloadShow()
  self.newsIcon:SetActive(true)
end

function NewsCenterLink:SetUILoadingShow(assetKey)
  if assetKey ~= self.assetKey then
    return
  end
  self.newsIcon:SetActive(true)
end

function NewsCenterLink:OnLoaded()
  local chatData = self:ChatData()
  if not chatData then
    return
  end
  self.param = rapidjson.decode(chatData.attachmentId)
  self:RefreshView()
  local isNight = ChatInterface.GetChatTheme() == ChatUIThemeConfig.ChatMode.Night
  self.rawBlackImg:SetActive(isNight)
  self.bgBlackImg:SetActive(isNight)
end

function NewsCenterLink:RefreshView()
  self.rawImg:SetActive(true)
  self.info = DataCenter.LWNewsCenterManager:GetCacheInfo(self.param.uuid, self.param.newsType)
  if self.info then
    self.assetKey = self.info.urlPic
    self._UIChatSendPhoto:SetData(PhotoFuncType.NewsCenter, "", 0, self.assetKey)
    self._UIChatSendPhoto:StartUpdateSmallPhoto()
    self.titleText:SetText(self.info.title)
  else
    self.assetKey = nil
    self.newsIcon:SetActive(true)
    if self.info == nil then
      self.titleText:SetText("")
    else
      self.titleText:SetLocalText("news_center_share_tips_1")
    end
  end
end

return NewsCenterLink
