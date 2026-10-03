local UINewsShareView = BaseClass("UINewsShareView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local bgblack_path = "PanelRoot/Content/Image/bgblack"
local black_path = "PanelRoot/Content/Image/Image/rawIcon/black"

function UINewsShareView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
end

function UINewsShareView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UINewsShareView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnCancel = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnCancel:SetOnClick(function()
    self:OnBtnCancelClick()
  end)
  self.btnConfirm = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnConfirm:SetOnClick(function()
    self:OnBtnConfirmClick()
  end)
  self.textExplanation = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textDes = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 5)
  self.btnUICommonBlackMask = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnUICommonBlackMask:SetOnClick(function()
    self:OnBtnUICommonBlackMaskClick()
  end)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.rawImgBlack = self:AddComponent(UIImage, black_path)
  self.bgBlackImg = self:AddComponent(UIImage, bgblack_path)
  self.rawImg = self:AddComponent(UIRawImage, "PanelRoot/Content/Image/Image/rawIcon")
  self._UIChatSendPhoto = self.rawImg.gameObject:GetComponent(typeof(CS.UIChatSendPhoto))
end

function UINewsShareView:ComponentDestroy()
  self.btnCancel = nil
  self.btnConfirm = nil
  self.textExplanation = nil
  self.textDes = nil
  self.imgIcon = nil
  self.btnUICommonBlackMask = nil
  self.btnClose = nil
end

function UINewsShareView:DataDefine()
  self.param = self:GetUserData()
end

function UINewsShareView:DataDestroy()
end

function UINewsShareView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(ChatEventEnum.CHAT_NEWSCENTER_CACHEUPDATE, self.RefreshView)
  self:AddUIListener(EventId.ChatSendPhotoSetSuccess, self.SetUILoadedSuccessShow)
  self:AddUIListener(EventId.ChatSendPhotoSetReload, self.SetUIReloadShow)
  self:AddUIListener(EventId.ChatSendPhotoSetLoading, self.SetUILoadingShow)
end

function UINewsShareView:OnRemoveListener()
  self:RemoveUIListener(ChatEventEnum.CHAT_NEWSCENTER_CACHEUPDATE, self.RefreshView)
  self:RemoveUIListener(EventId.ChatSendPhotoSetSuccess, self.SetUILoadedSuccessShow)
  self:RemoveUIListener(EventId.ChatSendPhotoSetReload, self.SetUIReloadShow)
  self:RemoveUIListener(EventId.ChatSendPhotoSetLoading, self.SetUILoadingShow)
  base.OnRemoveListener(self)
end

function UINewsShareView:SetUILoadedSuccessShow(assetKey)
  if assetKey ~= self.assetKey then
    return
  end
  local cacheItem = self._UIChatSendPhoto:SetUILoadedSuccessShow(assetKey)
  if cacheItem == nil or IsNull(cacheItem) then
    return
  end
  self.rawImg:SetActive(true)
  self.rawImg:SetTexture(cacheItem.textureAsset)
  self.imgIcon:SetActive(false)
end

function UINewsShareView:SetUIReloadShow(assetKey)
  if assetKey ~= self.assetKey then
    return
  end
  self.imgIcon:SetActive(true)
end

function UINewsShareView:SetUILoadingShow(assetKey)
  if assetKey ~= self.assetKey then
    return
  end
  self.imgIcon:SetActive(true)
end

function UINewsShareView:RefreshView()
  self.rawImg:SetActive(false)
  self.info = DataCenter.LWNewsCenterManager:GetCacheInfo(self.param.newsUid)
  local isNight = ChatInterface.GetChatTheme() == ChatUIThemeConfig.ChatMode.Night
  self.rawImgBlack:SetActive(isNight)
  self.bgBlackImg:SetActive(isNight)
  if self.info then
    self.assetKey = self.info.urlPic
    local cacheItem = self._UIChatSendPhoto:SetUILoadedSuccessShow(self.assetKey)
    if cacheItem == nil or IsNull(cacheItem) then
      self._UIChatSendPhoto:SetData(PhotoFuncType.NewsCenter, "", 0, self.assetKey)
      self._UIChatSendPhoto:StartUpdateSmallPhoto()
    else
      self.rawImg:SetActive(true)
      self.rawImg:SetTexture(cacheItem.textureAsset)
      self.imgIcon:SetActive(false)
    end
    self.textDes:SetText(self.info.title)
  else
    self.assetKey = nil
    self.imgIcon:SetActive(true)
    if self.info == nil then
      self.textDes:SetText("")
    end
  end
end

function UINewsShareView:OnBtnCancelClick()
  self.ctrl:CloseSelf()
end

function UINewsShareView:OnBtnConfirmClick()
  if not self.info then
    self.ctrl:CloseSelf()
    return
  end
  local share_param = {}
  share_param.postType = PostType.NewsCenterLink
  share_param.uuid = self.info.uuid
  share_param.newsType = self.info.type
  local data = {}
  data.roomId = self.param.roomId
  data.post = PostType.NewsCenterLink
  data.param = share_param
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_SHARE_COMMAND, data)
  self.ctrl:CloseSelf()
end

function UINewsShareView:OnBtnUICommonBlackMaskClick()
  self.ctrl:CloseSelf()
end

function UINewsShareView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

return UINewsShareView
