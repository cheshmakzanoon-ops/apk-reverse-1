local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local ChatItemPost_SendPhoto = BaseClass("ChatItemPost_SendPhoto", IChatItemPost)
local base = IChatItemPost
local logger = require("Framework.Logger.Logger")
local ChatSendPhotoLoadingBgPath = _ENV.ChatSendPhotoLoadingBgPath
local ChatSendPhotoReloadBgPath = _ENV.ChatSendPhotoReloadBgPath
local ChatSendPhotoShowMaxSize = _ENV.ChatSendPhotoShowMaxSize

function ChatItemPost_SendPhoto:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.assetKey = 0
  self.isFakePhoto = false
  self.chatData = nil
end

function ChatItemPost_SendPhoto:ComponentDefine()
  self._RawImgChatPhoto = self:AddComponent(UIRawImage, "RootChatPhoto/ChatPhoto")
  self._BtnChatPhoto = self:AddComponent(UIButton, "RootChatPhoto/ChatPhoto")
  self._ChatSendPhotoNode = self:AddComponent(UIBaseContainer, "RootChatPhoto/ChatPhoto")
  self._UIChatSendPhoto = self._ChatSendPhotoNode.gameObject:GetComponent(typeof(CS.UIChatSendPhoto))
  self._RootChatPhoto = self:AddComponent(UIBaseContainer, "RootChatPhoto")
  self._RootImgLoading = self:AddComponent(UIBaseContainer, "RootChatPhoto/ChatPhoto/ImgLoading")
  self._RootImgLoadFail = self:AddComponent(UIBaseContainer, "RootChatPhoto/ChatPhoto/ImgLoadFail")
end

function ChatItemPost_SendPhoto:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ChatSendPhotoSetSuccess, self.SetUILoadedSuccessShow)
  self:AddUIListener(EventId.ChatSendPhotoSetReload, self.SetUIReloadShow)
  self:AddUIListener(EventId.ChatSendPhotoSetLoading, self.SetUILoadingShow)
end

function ChatItemPost_SendPhoto:OnRemoveListener()
  self:RemoveUIListener(EventId.ChatSendPhotoSetSuccess, self.SetUILoadedSuccessShow)
  self:RemoveUIListener(EventId.ChatSendPhotoSetReload, self.SetUIReloadShow)
  self:RemoveUIListener(EventId.ChatSendPhotoSetLoading, self.SetUILoadingShow)
  base.OnRemoveListener(self)
end

function ChatItemPost_SendPhoto:OnLoaded()
  if self:ChatData() == nil then
    logger.LogError("\232\129\138\229\164\169\229\155\190\231\137\135\228\184\139\229\143\145chatData\228\184\186\231\169\186\239\188\129")
    return
  end
  self.chatData = self:ChatData()
  self.isFakePhoto = self.chatData:getMsg() == "<FakeLWPhoto>"
  self._RootImgLoading:SetActive(false)
  self._RootImgLoadFail:SetActive(false)
  if not self.isFakePhoto and (self.chatData:getExtra() == nil or self.chatData:getExtra().picVer == nil) then
    logger.LogError("\232\129\138\229\164\169\229\143\145\233\128\129\229\155\190\231\137\135\228\184\139\229\143\145\231\154\132picVer\230\182\136\230\129\175\228\184\141\229\175\185\239\188\129")
    return
  end
  if self._UIChatSendPhoto == nil then
    logger.LogError("\232\129\138\229\164\169\229\155\190\231\137\135Item\239\188\140\228\184\141\229\173\152\229\156\168UIChatSendPhoto\232\132\154\230\156\172")
    return
  end
  self:SetPhotoSizeFromTexture(self.chatData)
  if self.isFakePhoto then
    self.assetKey = 0
    self:SetUILoadingShow(0)
  else
    self.assetKey = CS.UploadImageManager.Instance:GenAssetKey(self.chatData:getSenderUid(), self.chatData:getExtra().picVer, false)
    self._UIChatSendPhoto:SetData(PhotoFuncType.ChatSendPickPhoto, self.chatData:getSenderUid(), self.chatData:getExtra().picVer, self.assetKey, false)
    self:SetUILoadingShow(self.assetKey)
    self._UIChatSendPhoto:StartUpdateSmallPhoto()
  end
end

function ChatItemPost_SendPhoto:OnRecycle()
  self.assetKey = 0
  self.isFakePhoto = false
  self.chatData = nil
end

function ChatItemPost_SendPhoto:HandleLongPress()
  return self.isFakePhoto
end

function ChatItemPost_SendPhoto:SetPhotoSizeFromTexture(chatData)
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
  self._ChatSendPhotoNode:SetSizeDeltaXY(finalWidth, finalHeight)
  self._RootChatPhoto:SetSizeDeltaXY(finalWidth, finalHeight + 30)
end

function ChatItemPost_SendPhoto:SetUILoadingShow(assetKey)
  if assetKey ~= self.assetKey then
    return
  end
  self._RawImgChatPhoto:LoadSprite(ChatSendPhotoLoadingBgPath)
  self._BtnChatPhoto:SetOnClick(function()
  end)
  self._RootImgLoading:SetActive(true)
  self._RootImgLoadFail:SetActive(false)
end

function ChatItemPost_SendPhoto:SetUIReloadShow(assetKey)
  if assetKey ~= self.assetKey then
    return
  end
  self._RawImgChatPhoto:LoadSprite(ChatSendPhotoReloadBgPath)
  self._BtnChatPhoto:SetOnClick(function()
    self:SetUILoadingShow(assetKey)
    self._UIChatSendPhoto:RequestTextureData(assetKey, false)
  end)
  self._RootImgLoading:SetActive(false)
  self._RootImgLoadFail:SetActive(true)
end

function ChatItemPost_SendPhoto:SetUILoadedSuccessShow(assetKey)
  if assetKey ~= self.assetKey then
    return
  end
  local cacheItem = self._UIChatSendPhoto:SetUILoadedSuccessShow(assetKey)
  if cacheItem == nil or IsNull(cacheItem) then
    return
  end
  self._RawImgChatPhoto:SetTexture(cacheItem.textureAsset)
  self._BtnChatPhoto:SetOnClick(function()
    local param = {}
    param.chatData = self.chatData
    param.smallAssetKey = self.assetKey
    param.photoFuncType = PhotoFuncType.ChatSendPickPhoto
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIChatViewBigPhotoView, {anim = true}, param)
  end)
  self._RootImgLoading:SetActive(false)
  self._RootImgLoadFail:SetActive(false)
end

return ChatItemPost_SendPhoto
