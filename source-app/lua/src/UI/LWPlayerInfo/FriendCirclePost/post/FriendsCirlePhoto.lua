local base = UIBaseContainer
local FriendsCirlePhoto = BaseClass("FriendsCirlePhoto", base)
local ChatSendPhotoLoadingBgPath = _ENV.ChatSendPhotoLoadingBgPath
local ChatSendPhotoReloadBgPath = _ENV.ChatSendPhotoReloadBgPath
local ChatSendPhotoShowMaxSize = _ENV.ChatSendPhotoShowMaxSize
local Localization = CS.GameEntry.Localization

function FriendsCirlePhoto:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.assetKey = 0
end

function FriendsCirlePhoto:ComponentDefine()
  self._rawImgPhoto = self:AddComponent(UIRawImage, "Photo")
  self._btnPhoto = self:AddComponent(UIButton, "Photo")
  self._sendPhotoNode = self:AddComponent(UIBaseContainer, "Photo")
  self._UIChatSendPhoto = self._sendPhotoNode.gameObject:GetComponent(typeof(CS.UIChatSendPhoto))
  self._rootPhoto = self:AddComponent(UIBaseContainer, "")
  self._rootImgLoading = self:AddComponent(UIBaseContainer, "Photo/ImgLoading")
  self._rootImgLoadFail = self:AddComponent(UIBaseContainer, "Photo/ImgLoadFail")
end

function FriendsCirlePhoto:ComponentDestroy()
  self._rawImgPhoto = nil
  self._btnPhoto = nil
  self._sendPhotoNode = nil
  self._UIChatSendPhoto = nil
  self._rootPhoto = nil
  self._rootImgLoading = nil
  self._rootImgLoadFail = nil
end

function FriendsCirlePhoto:OnAddListener()
  self:AddUIListener(EventId.ChatSendPhotoSetSuccess, self.SetUILoadedSuccessShow)
  self:AddUIListener(EventId.ChatSendPhotoSetReload, self.SetUIReloadShow)
  self:AddUIListener(EventId.ChatSendPhotoSetLoading, self.SetUILoadingShow)
end

function FriendsCirlePhoto:OnRemoveListener()
  self:RemoveUIListener(EventId.ChatSendPhotoSetSuccess, self.SetUILoadedSuccessShow)
  self:RemoveUIListener(EventId.ChatSendPhotoSetReload, self.SetUIReloadShow)
  self:RemoveUIListener(EventId.ChatSendPhotoSetLoading, self.SetUILoadingShow)
end

function FriendsCirlePhoto:OnLoaded(chatdata, chatPhotoSource)
  self._chatData = chatdata
  self.chatPhotoSource = chatPhotoSource
end

function FriendsCirlePhoto:OnRecycle()
  self.assetKey = 0
end

function FriendsCirlePhoto:ChatData()
  return self._chatData
end

function FriendsCirlePhoto:UpdatePhoto()
  local chatData = self:ChatData()
  local uploadPicVer = chatData:getExtra().picVer
  if uploadPicVer == nil or uploadPicVer == -1 then
    self._sendPhotoNode:SetActive(false)
    return
  end
  if self._UIChatSendPhoto == nil then
    Logger.LogError("\230\156\139\229\143\139\229\156\136\229\155\190\231\137\135\239\188\140\228\184\141\229\173\152\229\156\168UIChatSendPhoto\232\132\154\230\156\172")
    return
  end
  self._sendPhotoNode:SetActive(true)
  self._rootImgLoading:SetActive(false)
  self._rootImgLoadFail:SetActive(false)
  self:SetPhotoSizeFromTexture(chatData)
  self.assetKey = CS.UploadImageManager.Instance:GenAssetKey(chatData:getSenderUid(), chatData:getExtra().picVer, false)
  self._UIChatSendPhoto:SetData(PhotoFuncType.ChatSendPickPhoto, chatData:getSenderUid(), chatData:getExtra().picVer, self.assetKey, false)
  self:SetUILoadingShow(self.assetKey)
  self._UIChatSendPhoto:StartUpdateSmallPhoto()
end

function FriendsCirlePhoto:SetPhotoSizeFromTexture(chatData)
  local uploadPicVer = chatData:getExtra().picVer
  if uploadPicVer == -1 then
    self._sendPhotoNode:SetSizeDeltaXY(0, 0)
    self._rootPhoto:SetSizeDeltaXY(0, 0)
  else
    local originalWidth = chatData:getExtra().bigWidth or ChatSendPhotoShowMaxSize
    local originalHeight = chatData:getExtra().bigHeight or ChatSendPhotoShowMaxSize
    local finalWidth, finalHeight = 0, 0
    if originalWidth >= originalHeight then
      finalWidth = ChatSendPhotoShowMaxSize
      finalHeight = math.floor(originalHeight * finalWidth / originalWidth)
    else
      finalHeight = ChatSendPhotoShowMaxSize
      finalWidth = math.floor(originalWidth * finalHeight / originalHeight)
    end
    self._sendPhotoNode:SetSizeDeltaXY(finalWidth, finalHeight)
    self._rootPhoto:SetSizeDeltaXY(finalWidth, finalHeight + 30)
  end
end

function FriendsCirlePhoto:SetUILoadingShow(assetKey)
  if assetKey ~= self.assetKey then
    return
  end
  self._rawImgPhoto:LoadSprite(ChatSendPhotoLoadingBgPath)
  self._btnPhoto:SetOnClick(function()
  end)
  self._rootImgLoading:SetActive(true)
  self._rootImgLoadFail:SetActive(false)
end

function FriendsCirlePhoto:SetUIReloadShow(assetKey)
  if assetKey ~= self.assetKey then
    return
  end
  self._rawImgPhoto:LoadSprite(ChatSendPhotoReloadBgPath)
  self._btnPhoto:SetOnClick(function()
    self:SetUILoadingShow(assetKey)
    self._UIChatSendPhoto:RequestTextureData(assetKey, false)
  end)
  self._rootImgLoading:SetActive(false)
  self._rootImgLoadFail:SetActive(true)
end

function FriendsCirlePhoto:SetUILoadedSuccessShow(assetKey)
  if assetKey ~= self.assetKey then
    return
  end
  local cacheItem = self._UIChatSendPhoto:SetUILoadedSuccessShow(assetKey)
  if cacheItem == nil or IsNull(cacheItem) then
    return
  end
  self._rawImgPhoto:SetTexture(cacheItem.textureAsset)
  self._btnPhoto:SetOnClick(function()
    if self._chatData then
      ChatInterface.getMoment():SendClickExposure(self._chatData.msgId)
    end
    if self.chatPhotoSource and self.chatPhotoSource == ChatPhotoSource.PlayerDetailFriendsCircle then
      self:OnPhotoFuncInPlayerDetailFriendsCircle()
    else
      local param = {}
      param.chatData = self:ChatData()
      param.smallAssetKey = self.assetKey
      param.photoFuncType = PhotoFuncType.ChatSendPickPhoto
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIChatViewBigPhotoView, {anim = true}, param)
    end
  end)
  self._rootImgLoading:SetActive(false)
  self._rootImgLoadFail:SetActive(false)
end

function FriendsCirlePhoto:GetImageHight()
  if self._sendPhotoNode:GetActive() then
    return self._rootPhoto:GetSizeDelta().y
  end
  return 0
end

function FriendsCirlePhoto:GetImageWidth()
  if self._sendPhotoNode:GetActive() then
    return self._rootPhoto:GetSizeDelta().x
  end
  return 0
end

function FriendsCirlePhoto:OnDestroy()
  self:ComponentDestroy()
  self.assetKey = 0
  base.OnDestroy(self)
end

function FriendsCirlePhoto:OnPhotoFuncInPlayerDetailFriendsCircle()
  local chatData = self:ChatData()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIChatViewBigPhotoListView, {anim = true}, self.chatPhotoSource, chatData)
end

return FriendsCirlePhoto
