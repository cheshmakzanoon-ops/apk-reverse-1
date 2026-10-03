local IChatItem = require("UI.UIChatNew.Component.ChatItem.IChatItem")
local ChatItemSendPhoto = BaseClass("ChatItemSendPhoto", IChatItem)
local base = IChatItem
local ChatHead = require("UI.UIChatNew.Component.ChatHead")
local ChatUserName = require("UI.UIChatNew.Component.ChatItem.ChatUserName")
local logger = require("Framework.Logger.Logger")
local ChatSendPhotoLoadingBgPath = _ENV.ChatSendPhotoLoadingBgPath
local ChatSendPhotoReloadBgPath = _ENV.ChatSendPhotoReloadBgPath
local ChatSendPhotoShowMaxSize = _ENV.ChatSendPhotoShowMaxSize
local _cp_chatHead = "ChatHead"
local _cp_chatNameLayout = "ChatNameLayout"
local _cp_chatPhotoPath = "ChatPhoto"
local _cp_chatImgLoading = "ChatPhoto/ImgLoading"
local _cp_chatImgLoadFail = "ChatPhoto/ImgLoadFail"

function ChatItemSendPhoto:OnCreate()
  base.OnCreate(self)
  self._chatHead = self:AddComponent(ChatHead, _cp_chatHead)
  self._chatUserName = self:AddComponent(ChatUserName, _cp_chatNameLayout)
  self._RawImgChatPhoto = self:AddComponent(UIRawImage, _cp_chatPhotoPath)
  self._BtnChatPhoto = self:AddComponent(UIButton, _cp_chatPhotoPath)
  self._ChatSendPhotoNode = self:AddComponent(UIBaseContainer, _cp_chatPhotoPath)
  self._UIChatSendPhoto = self._ChatSendPhotoNode.gameObject:GetComponent(typeof(CS.UIChatSendPhoto))
  self._RootNode = self:AddComponent(UIBaseContainer, "")
  self._RootImgLoading = self:AddComponent(UIBaseContainer, _cp_chatImgLoading)
  self._RootImgLoadFail = self:AddComponent(UIBaseContainer, _cp_chatImgLoadFail)
  self.assetKey = 0
  self.isFakePhoto = false
  self.chatData = nil
end

function ChatItemSendPhoto:OnDestroy()
  base.OnDestroy(self)
  self.assetKey = 0
  self.isFakePhoto = false
  self.chatData = nil
end

function ChatItemSendPhoto:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ChatSendPhotoSetSuccess, self.SetUILoadedSuccessShow)
  self:AddUIListener(EventId.ChatSendPhotoSetReload, self.SetUIReloadShow)
  self:AddUIListener(EventId.ChatSendPhotoSetLoading, self.SetUILoadingShow)
end

function ChatItemSendPhoto:OnRemoveListener()
  self:RemoveUIListener(EventId.ChatSendPhotoSetSuccess, self.SetUILoadedSuccessShow)
  self:RemoveUIListener(EventId.ChatSendPhotoSetReload, self.SetUIReloadShow)
  self:RemoveUIListener(EventId.ChatSendPhotoSetLoading, self.SetUILoadingShow)
  base.OnRemoveListener(self)
end

function ChatItemSendPhoto:OnRecycleItem()
  self.assetKey = 0
  self.isFakePhoto = false
  self.chatData = nil
end

function ChatItemSendPhoto:UpdateItem(chatData, index)
  base.UpdateItem(self, chatData, index)
  if chatData == nil then
    logger.LogError("\232\129\138\229\164\169\229\155\190\231\137\135\228\184\139\229\143\145chatData\228\184\186\231\169\186\239\188\129")
    return
  end
  self.chatData = chatData
  self.isFakePhoto = chatData:getMsg() == "<FakeLWPhoto>"
  self._RootImgLoading:SetActive(false)
  self._RootImgLoadFail:SetActive(false)
  if not self.isFakePhoto and (chatData:getExtra() == nil or chatData:getExtra().picVer == nil) then
    logger.LogError("\232\129\138\229\164\169\229\143\145\233\128\129\229\155\190\231\137\135\228\184\139\229\143\145\231\154\132picVer\230\182\136\230\129\175\228\184\141\229\175\185\239\188\129")
    return
  end
  if self._UIChatSendPhoto == nil then
    logger.LogError("\232\129\138\229\164\169\229\155\190\231\137\135Item\239\188\140\228\184\141\229\173\152\229\156\168UIChatSendPhoto\232\132\154\230\156\172")
    return
  end
  self:SetPhotoSizeFromTexture(chatData)
  if self.isFakePhoto then
    self.assetKey = 0
    self:SetUILoadingShow(0)
  else
    self.assetKey = CS.UploadImageManager.Instance:GenAssetKey(chatData:getSenderUid(), chatData:getExtra().picVer, false)
    self._UIChatSendPhoto:SetData(PhotoFuncType.ChatSendPickPhoto, chatData:getSenderUid(), chatData:getExtra().picVer, self.assetKey, false)
    self:SetUILoadingShow(self.assetKey)
    self._UIChatSendPhoto:StartUpdateSmallPhoto()
  end
end

function ChatItemSendPhoto:SetPhotoSizeFromTexture(chatData)
  local originalWidth = chatData.extra.bigWidth or ChatSendPhotoShowMaxSize
  local originalHeight = chatData.extra.bigHeight or ChatSendPhotoShowMaxSize
  local finalWidth, finalHeight = 0, 0
  if originalWidth >= originalHeight then
    local ratio = ChatSendPhotoShowMaxSize / originalWidth
    finalWidth = ChatSendPhotoShowMaxSize
    finalHeight = math.floor(originalHeight * ratio)
  else
    local ratio = ChatSendPhotoShowMaxSize / originalHeight
    finalHeight = ChatSendPhotoShowMaxSize
    finalWidth = math.floor(originalWidth * ratio)
  end
  self._ChatSendPhotoNode:SetSizeDeltaXY(finalWidth, finalHeight)
  finalHeight = finalHeight or ChatSendPhotoShowMaxSize
  self._RootNode:SetSizeDeltaXY(self._RootNode:GetSizeDelta().x, 40 + finalHeight + 12)
end

function ChatItemSendPhoto:SetUILoadingShow(assetKey)
  if assetKey ~= self.assetKey then
    return
  end
  self._RawImgChatPhoto:LoadSprite(ChatSendPhotoLoadingBgPath)
  self._BtnChatPhoto:SetOnClick(function()
  end)
  self._RootImgLoading:SetActive(true)
  self._RootImgLoadFail:SetActive(false)
end

function ChatItemSendPhoto:SetUIReloadShow(assetKey)
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

function ChatItemSendPhoto:SetUILoadedSuccessShow(assetKey)
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

return ChatItemSendPhoto
