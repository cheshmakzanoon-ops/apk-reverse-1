local base = UIBaseContainer
local ChatUploadPhoto = BaseClass("ChatUploadPhoto", base)
local ChatSendPhotoLoadingBgPath = _ENV.ChatSendPhotoLoadingBgPath
local ChatSendPhotoReloadBgPath = _ENV.ChatSendPhotoReloadBgPath
local ChatSendPhotoShowMaxSize = _ENV.ChatSendPhotoShowMaxSize
local Localization = CS.GameEntry.Localization

function ChatUploadPhoto:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.assetKey = 0
end

function ChatUploadPhoto:ComponentDefine()
  self._rawImgPhoto = self:AddComponent(UIRawImage, "Photo")
  self._btnPhoto = self:AddComponent(UIButton, "Photo")
  self._sendPhotoNode = self:AddComponent(UIBaseContainer, "Photo")
  self._UIChatSendPhoto = self._sendPhotoNode.gameObject:GetComponent(typeof(CS.UIChatSendPhoto))
  self._rootPhoto = self:AddComponent(UIBaseContainer, "")
  self._rootImgLoading = self:AddComponent(UIBaseContainer, "Photo/ImgLoading")
  self._rootImgLoadFail = self:AddComponent(UIBaseContainer, "Photo/ImgLoadFail")
end

function ChatUploadPhoto:ComponentDestroy()
  self._rawImgPhoto = nil
  self._btnPhoto = nil
  self._sendPhotoNode = nil
  self._UIChatSendPhoto = nil
  self._rootPhoto = nil
  self._rootImgLoading = nil
  self._rootImgLoadFail = nil
end

function ChatUploadPhoto:OnAddListener()
  self:AddUIListener(EventId.ChatSendPhotoSetSuccess, self.SetUILoadedSuccessShow)
  self:AddUIListener(EventId.ChatSendPhotoSetReload, self.SetUIReloadShow)
  self:AddUIListener(EventId.ChatSendPhotoSetLoading, self.SetUILoadingShow)
end

function ChatUploadPhoto:OnRemoveListener()
  self:RemoveUIListener(EventId.ChatSendPhotoSetSuccess, self.SetUILoadedSuccessShow)
  self:RemoveUIListener(EventId.ChatSendPhotoSetReload, self.SetUIReloadShow)
  self:RemoveUIListener(EventId.ChatSendPhotoSetLoading, self.SetUILoadingShow)
end

function ChatUploadPhoto:OnLoaded(chatdata, picData, chatReportParam)
  self._chatData = chatdata
  self._picData = picData
  self._chatReportParam = chatReportParam
end

function ChatUploadPhoto:OnRecycle()
  self.assetKey = 0
end

function ChatUploadPhoto:ChatData()
  return self._chatData
end

function ChatUploadPhoto:UpdatePhoto()
  local chatData = self:ChatData()
  local uploadPicVer = chatData and chatData:getExtra().picVer or self._picData.picVer
  local senderUid = chatData and chatData:getSenderUid() or self._picData.senderUid
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
  self.assetKey = CS.UploadImageManager.Instance:GenAssetKey(senderUid, uploadPicVer, false)
  self._UIChatSendPhoto:SetData(PhotoFuncType.ChatAllianceNoticePhoto, senderUid, uploadPicVer, self.assetKey, false)
  self:SetUILoadingShow(self.assetKey)
  self._UIChatSendPhoto:StartUpdateSmallPhoto()
  self._sendPhotoNode:SetAnchoredPositionXY(0, 0)
end

function ChatUploadPhoto:SetPhotoSizeFromTexture(chatData)
  local uploadPicVer = chatData and chatData:getExtra().picVer or self._picData.picVer
  local senderUid = chatData and chatData:getSenderUid() or self._picData.senderUid
  if uploadPicVer == -1 then
    self._sendPhotoNode:SetSizeDeltaXY(0, 0)
    self._rootPhoto:SetSizeDeltaXY(0, 0)
  else
    local originalWidth = 0
    local originalHeight = 0
    local finalWidth, finalHeight = 0, 0
    if chatData then
      originalWidth = chatData:getExtra().bigWidth or ChatSendPhotoShowMaxSize
      originalHeight = chatData:getExtra().bigHeight or ChatSendPhotoShowMaxSize
    else
      originalWidth = self._picData.bigWidth or ChatSendPhotoShowMaxSize
      originalHeight = self._picData.bigHeight or ChatSendPhotoShowMaxSize
    end
    local isNeedAdaptSize = true
    if self._picData and self._picData.isAdaptSize == false then
      isNeedAdaptSize = self._picData.isAdaptSize
    end
    local isSizeSameContent = false
    if self._picData and self._picData.isSizeSameContent == true then
      isSizeSameContent = self._picData.isSizeSameContent
    end
    if isNeedAdaptSize then
      if originalWidth >= originalHeight then
        finalWidth = ChatSendPhotoShowMaxSize
        finalHeight = math.floor(originalHeight * finalWidth / originalWidth)
      else
        finalHeight = ChatSendPhotoShowMaxSize
        finalWidth = math.floor(originalWidth * finalHeight / originalHeight)
      end
      self._sendPhotoNode:SetSizeDeltaXY(finalWidth, finalHeight)
      self._rootPhoto:SetSizeDeltaXY(finalWidth, finalHeight + 30)
      self._rawImgPhoto:SetUVRectPositionAndSize(0, 0, 1, 1)
    elseif isSizeSameContent then
      local contentW = self._picData.contentW
      local contentH = self._picData.contentH
      local bigWidth = self._picData.bigWidth
      local bigHeight = self._picData.bigHeight
      finalWidth = contentW
      finalHeight = contentH
      local wRate = contentW / bigWidth
      local hRate = contentH / bigHeight
      self._sendPhotoNode:SetSizeDeltaXY(finalWidth, finalHeight)
      self._rootPhoto:SetSizeDeltaXY(finalWidth, finalHeight)
      self._rawImgPhoto:SetUVRectPositionAndSize(0.5 - wRate / 2, 0.5 - hRate / 2, wRate, hRate)
    else
      finalWidth = self._picData.bigWidth
      finalHeight = self._picData.bigHeight
      self._sendPhotoNode:SetSizeDeltaXY(finalWidth, finalHeight)
      self._rootPhoto:SetSizeDeltaXY(finalWidth, finalHeight)
      self._rawImgPhoto:SetUVRectPositionAndSize(0, 0, 1, 1)
    end
  end
end

function ChatUploadPhoto:SetUILoadingShow(assetKey)
  if assetKey ~= self.assetKey then
    return
  end
  self._rawImgPhoto:LoadSprite(ChatSendPhotoLoadingBgPath)
  self._btnPhoto:SetOnClick(function()
  end)
  self._rootImgLoading:SetActive(true)
  self._rootImgLoadFail:SetActive(false)
end

function ChatUploadPhoto:SetUIReloadShow(assetKey)
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

function ChatUploadPhoto:SetUILoadedSuccessShow(assetKey)
  if assetKey ~= self.assetKey then
    return
  end
  local cacheItem = self._UIChatSendPhoto:SetUILoadedSuccessShow(assetKey)
  if cacheItem == nil or IsNull(cacheItem) then
    return
  end
  self._rawImgPhoto:SetTexture(cacheItem.textureAsset)
  self._btnPhoto:SetOnClick(function()
    local param = {}
    param.chatData = self:ChatData()
    param.picData = self._picData
    param.chatReportParam = self._chatReportParam
    param.smallAssetKey = self.assetKey
    param.photoFuncType = PhotoFuncType.ChatAllianceNoticePhoto
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIChatViewBigPhotoView, {anim = true}, param)
  end)
  self._rootImgLoading:SetActive(false)
  self._rootImgLoadFail:SetActive(false)
end

function ChatUploadPhoto:GetImageHight()
  if self._sendPhotoNode:GetActive() then
    return self._rootPhoto:GetSizeDelta().y
  end
  return 0
end

function ChatUploadPhoto:GetImageWidth()
  if self._sendPhotoNode:GetActive() then
    return self._rootPhoto:GetSizeDelta().x
  end
  return 0
end

function ChatUploadPhoto:OnDestroy()
  self:ComponentDestroy()
  self.assetKey = 0
  base.OnDestroy(self)
end

return ChatUploadPhoto
