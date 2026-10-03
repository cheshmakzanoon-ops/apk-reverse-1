local UIVip18HistoryPhotoComponent = BaseClass("UIVip18HistoryPhotoComponent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function UIVip18HistoryPhotoComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIVip18HistoryPhotoComponent:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIVip18HistoryPhotoComponent:ComponentDefine()
  self.BtnChatPhoto = self:AddComponent(UIButton, "ChatPhoto")
  self.RawImgChatPhoto = self:AddComponent(UIRawImage, "ChatPhoto")
  self.ChatSendPhotoNode = self:AddComponent(UIBaseContainer, "ChatPhoto")
  self.RootImgLoading = self:AddComponent(UIBaseContainer, "ChatPhoto/ImgLoading")
  self.RootImgLoadFail = self:AddComponent(UIBaseContainer, "ChatPhoto/ImgLoadFail")
end

function UIVip18HistoryPhotoComponent:ComponentDestroy()
  self.BtnChatPhoto = nil
  self.RawImgChatPhoto = nil
  self.ChatSendPhotoNode = nil
  self.RootImgLoading = nil
  self.RootImgLoadFail = nil
end

function UIVip18HistoryPhotoComponent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ChatSendPhotoSetSuccess, self.SetUILoadedSuccessShow)
  self:AddUIListener(EventId.ChatSendPhotoSetReload, self.SetUIReloadShow)
  self:AddUIListener(EventId.ChatSendPhotoSetLoading, self.SetUILoadingShow)
end

function UIVip18HistoryPhotoComponent:OnRemoveListener()
  self:RemoveUIListener(EventId.ChatSendPhotoSetSuccess, self.SetUILoadedSuccessShow)
  self:RemoveUIListener(EventId.ChatSendPhotoSetReload, self.SetUIReloadShow)
  self:RemoveUIListener(EventId.ChatSendPhotoSetLoading, self.SetUILoadingShow)
  base.OnRemoveListener(self)
end

function UIVip18HistoryPhotoComponent:SetData(data)
  self.picVer = data
  self.UIChatSendPhoto = self.ChatSendPhotoNode.gameObject:GetComponent(typeof(CS.UIChatSendPhoto))
  if self.UIChatSendPhoto == nil then
    Logger.LogError("\230\156\139\229\143\139\229\156\136\226\128\148\226\128\148\226\128\148\226\128\148\229\155\190\231\137\135Item\239\188\140\228\184\141\229\173\152\229\156\168UIChatSendPhoto\232\132\154\230\156\172")
    return
  end
  self.RootImgLoading:SetActive(false)
  self.RootImgLoadFail:SetActive(false)
  self.assetKey = self:GenAssetKey(LuaEntry.Player.uid, self.picVer, false)
  self.UIChatSendPhoto:SetData(PhotoFuncType.MomentPickPhoto, LuaEntry.Player.uid, 0, self.assetKey, false)
  self:SetUILoadingShow(self.assetKey)
  self.UIChatSendPhoto:StartUpdateSmallPhoto()
end

function UIVip18HistoryPhotoComponent:GenAssetKey(uid, picVer, useBig)
  local md5 = CS.AESHelper.GetMd5Hash(uid .. "_" .. picVer)
  local tempStr = uid
  if string.len(tempStr) > 6 then
    tempStr = string.sub(tempStr, string.len(tempStr) - 5)
  end
  local suffix = ""
  if useBig then
    suffix = "_big"
  end
  return string.format("%s/%s%s.jpg", tempStr, md5, suffix)
end

function UIVip18HistoryPhotoComponent:SetUILoadingShow(assetKey)
  if assetKey ~= self.assetKey then
    return
  end
  self.RawImgChatPhoto:LoadSprite(ChatSendPhotoLoadingBgPath)
  self.BtnChatPhoto:SetOnClick(function()
  end)
  self.RootImgLoading:SetActive(true)
  self.RootImgLoadFail:SetActive(false)
end

function UIVip18HistoryPhotoComponent:SetUIReloadShow(assetKey)
  if assetKey ~= self.assetKey then
    return
  end
  self.RawImgChatPhoto:LoadSprite(ChatSendPhotoReloadBgPath)
  self.BtnChatPhoto:SetOnClick(function()
    self:SetUILoadingShow(assetKey)
    self.UIChatSendPhoto:RequestTextureData(assetKey, false)
  end)
  self.RootImgLoading:SetActive(false)
  self.RootImgLoadFail:SetActive(true)
end

function UIVip18HistoryPhotoComponent:SetUILoadedSuccessShow(assetKey)
  if assetKey ~= self.assetKey then
    return
  end
  local cacheItem = self.UIChatSendPhoto:SetUILoadedSuccessShow(assetKey)
  if cacheItem == nil or IsNull(cacheItem) then
    return
  end
  local cacheItem = self.UIChatSendPhoto:SetUILoadedSuccessShow(assetKey)
  if cacheItem == nil or IsNull(cacheItem) then
    return
  end
  self.RawImgChatPhoto:SetTexture(cacheItem.textureAsset)
  self.BtnChatPhoto:SetOnClick(function()
    local tmpChatData = {
      getSenderUid = function()
        return LuaEntry.Player.uid
      end,
      getExtra = function()
        local tmpData = {
          picVer = self.picVer,
          bigHeight = 800,
          bigWidth = 800
        }
        return tmpData
      end
    }
    local param = {}
    param.chatData = tmpChatData
    param.smallAssetKey = self.assetKey
    param.photoFuncType = PhotoFuncType.MomentPickPhoto
    param.bigAssetKey = self:GenAssetKey(LuaEntry.Player.uid, self.picVer, true)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIChatViewBigPhotoView, {anim = true}, param)
  end)
  self.RootImgLoading:SetActive(false)
  self.RootImgLoadFail:SetActive(false)
end

return UIVip18HistoryPhotoComponent
