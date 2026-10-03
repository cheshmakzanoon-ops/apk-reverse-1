local BigPhotoListItem = BaseClass("BigPhotoListItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local u_i_photo_content_path = "UIPhotoContent"
local u_i_photo_path = "UIPhotoContent/UIPhoto"
local btn_report_path = "BtnReport"
local img_loading_path = "ImgLoading"
local img_load_fail_path = "ImgLoadFail"
local ItemMaxScale = 2

function BigPhotoListItem:OnCreate()
  base.OnCreate(self)
  self.root = self:AddComponent(UIBaseContainer, "")
  self.u_i_photo_content = self:AddComponent(UIBaseContainer, u_i_photo_content_path)
  self.u_i_photo = self:AddComponent(UIRawImage, u_i_photo_path)
  self.btn_report = self:AddComponent(UIButton, btn_report_path)
  self.img_loading = self:AddComponent(UIImage, img_loading_path)
  self.img_load_fail = self:AddComponent(UIImage, img_load_fail_path)
  self.UIChatSendPhoto = self.u_i_photo.gameObject:GetComponent(typeof(CS.UIChatSendPhoto))
  self.btn_report:SetOnClick(function()
    self:OnPhotoReport()
  end)
end

function BigPhotoListItem:OnDestroy()
  base.OnDestroy(self)
  self.UIChatSendPhoto:CancelOrClearBigCacheItem()
  self.UIChatSendPhoto = nil
  self.root = nil
  self.u_i_photo_content = nil
  self.u_i_photo = nil
  self.btn_report = nil
  self.img_loading = nil
  self.img_load_fail = nil
end

function BigPhotoListItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ChatSendPhotoSetSuccess, self.SetUILoadedSuccessShow)
end

function BigPhotoListItem:OnRemoveListener()
  self:RemoveUIListener(EventId.ChatSendPhotoSetSuccess, self.SetUILoadedSuccessShow)
  base.OnRemoveListener(self)
end

function BigPhotoListItem:RefreshData(chatData)
  self.chatData = chatData
  self.baseSizeX = 0
  self.baseSizeY = 0
  self.minSizeX = 0
  self.minSizeY = 0
  self.maxSizeX = 0
  self.maxSizeY = 0
  self.rootSizeX = 0
  self.rootSizeY = 0
  self.baseScale = 1
  self.minScale = 0.5
  self.maxScale = 2
  self:RefreshView()
end

function BigPhotoListItem:RefreshView()
  local uploadPicVer = self.chatData and self.chatData:getExtra().picVer
  local senderUid = self.chatData and self.chatData:getSenderUid()
  self.smallAssetKey = CS.UploadImageManager.Instance:GenAssetKey(senderUid, uploadPicVer, false)
  local oldAssetKey = self.assetKey
  self.assetKey = CS.UploadImageManager.Instance:GenAssetKey(senderUid, uploadPicVer, true)
  local needClearCacheItem = false
  if not string.IsNullOrEmpty(oldAssetKey) and oldAssetKey ~= self.assetKey then
    needClearCacheItem = true
  end
  local IsNewPhotoData = false
  if string.IsNullOrEmpty(oldAssetKey) or oldAssetKey ~= self.assetKey then
    IsNewPhotoData = true
  end
  self.img_loading:SetActive(false)
  self.img_load_fail:SetActive(false)
  self.btn_report:SetActive(false)
  self:SetPhotoSizeFromTexture()
  if needClearCacheItem then
    self.UIChatSendPhoto:CancelOrClearBigCacheItem()
  end
  self.UIChatSendPhoto:SetData(PhotoFuncType.ChatSendPickPhoto, senderUid, uploadPicVer, self.assetKey, true)
  if IsNewPhotoData then
    self.UIChatSendPhoto:AddBigNodeUseNumMap()
  end
  self:SetUILoadingShow(self.assetKey)
  self.UIChatSendPhoto:StartUpdateBigPhoto()
  self.u_i_photo:SetAnchoredPositionXY(0, 0)
end

function BigPhotoListItem:SetPhotoSizeFromTexture()
  local finalWidth, finalHeight = 0, 0
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local parentWidth, parentHeight = self:GetSizeDeltaXY()
  local photoWidth = 0
  local photoHeight = 0
  if self.chatData then
    photoWidth = self.chatData:getExtra().bigWidth or parentWidth
    photoHeight = self.chatData:getExtra().bigHeight or parentHeight
  end
  local bgRatio = parentWidth / parentHeight
  local photoRatio = photoWidth / photoHeight
  if bgRatio < photoRatio then
    finalWidth = parentWidth
    finalHeight = photoHeight * (finalWidth / photoWidth)
  else
    finalHeight = parentHeight
    finalWidth = photoWidth * (finalHeight / photoHeight)
  end
  self.u_i_photo:SetSizeDeltaXY(finalWidth, finalHeight)
  self.baseSizeX = finalWidth
  self.baseSizeY = finalHeight
  self.rootSizeX = parentWidth
  self.rootSizeY = parentHeight
  self.minSizeX = finalWidth * 0.5
  self.minSizeY = finalHeight * 0.5
  local finalWidth2, finalHeight2 = 0, 0
  if bgRatio < photoRatio then
    finalHeight2 = parentHeight
    finalWidth2 = parentHeight * photoRatio
  else
    finalWidth2 = parentWidth
    finalHeight2 = parentWidth / photoRatio
  end
  self.maxSizeX = finalWidth2
  self.maxSizeY = finalHeight2
  if self.maxSizeX > self.baseSizeX * ItemMaxScale then
    self.maxScale = self.maxSizeX / self.baseSizeX
  else
    self.maxScale = ItemMaxScale
    self.maxSizeX = self.baseSizeX * self.maxScale
    self.maxSizeY = self.baseSizeY * self.maxScale
  end
end

function BigPhotoListItem:SetUILoadingShow(assetKey)
  if assetKey ~= self.assetKey then
    return
  end
  self.img_loading:SetActive(true)
  self.img_load_fail:SetActive(false)
end

function BigPhotoListItem:SetUILoadedSuccessShow(assetKey)
  if assetKey ~= self.assetKey then
    return
  end
  local cacheItem = self.UIChatSendPhoto:GetBigPhotoCacheItem(assetKey)
  if cacheItem == nil or IsNull(cacheItem) then
    return
  end
  self.u_i_photo:SetTexture(cacheItem.textureAsset)
  self.img_loading:SetActive(false)
  self.img_load_fail:SetActive(false)
end

function BigPhotoListItem:OnPhotoReport()
  local isLvEnough = ChatManager2:GetInstance():CheckMainLvEnough()
  if not isLvEnough then
    UIUtil.ShowTipsId(208256)
    return
  end
  if ChatManager2:GetInstance():CheckReportTime() then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIChatReport, {anim = true}, {
      type = ReportType.chatPhoto,
      chatData = self.chatData
    })
  else
    UIUtil.ShowTipsId(208250)
  end
end

return BigPhotoListItem
