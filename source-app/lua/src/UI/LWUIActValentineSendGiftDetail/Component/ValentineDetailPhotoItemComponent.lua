local ValentineDetailPhotoItemComponent = BaseClass("ValentineDetailPhotoItemComponent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local head_icon_path = "HeadIcon"
local friend_circle_img_path = "FriendCircleImg"
local ChatSendPhotoLoadingBgPath = _ENV.ChatSendPhotoLoadingBgPath
local ChatSendPhotoReloadBgPath = _ENV.ChatSendPhotoReloadBgPath
local ChatSendPhotoShowMaxSize = _ENV.ChatSendPhotoShowMaxSize

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.headIcon = self:AddComponent(UIPlayerHead, head_icon_path)
  self.friendCircleRawImg = self:AddComponent(UIRawImage, friend_circle_img_path)
  self._UIChatSendPhoto = self.friendCircleRawImg.gameObject:GetComponent(typeof(CS.UIChatSendPhoto))
  self.frameObj = self:AddComponent(UIBaseContainer, "")
  local width, height = self.frameObj.rectTransform:Get_sizeDelta()
  self.frameWidth = width
  self.frameHeight = height
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.ChatSendPhotoSetSuccess, self.SetUILoadedSuccessShow)
  self:AddUIListener(EventId.ChatSendPhotoSetReload, self.SetUIReloadShow)
  self:AddUIListener(EventId.ChatSendPhotoSetLoading, self.SetUILoadingShow)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.ChatSendPhotoSetSuccess, self.SetUILoadedSuccessShow)
  self:RemoveUIListener(EventId.ChatSendPhotoSetReload, self.SetUIReloadShow)
  self:RemoveUIListener(EventId.ChatSendPhotoSetLoading, self.SetUILoadingShow)
  base.OnRemoveListener(self)
end

function ValentineDetailPhotoItemComponent:SetData(param)
  self.param = param
  self.photoType = param.type
  if self.photoType == SendGiftDetailPhotoType.HeadIcon then
    self:RefreshHeadIcon()
  elseif self.photoType == SendGiftDetailPhotoType.FriendCircle then
    self:RefreshFriendCirclePhoto()
  elseif self.photoType == SendGiftDetailPhotoType.NpcIcon then
    self:RefreshNpcHeadIcon()
  end
end

function ValentineDetailPhotoItemComponent:RefreshHeadIcon()
  self.headIcon:SetActive(true)
  self.friendCircleRawImg:SetActive(false)
  local uid = self.param.uid
  local pic = self.param.pic
  local picVer = self.param.picVer
  self.headIcon:SetBigData(uid, pic or "", picVer or 0, true)
end

function ValentineDetailPhotoItemComponent:RefreshFriendCirclePhoto()
  self.headIcon:SetActive(false)
  self.friendCircleRawImg:SetActive(true)
  local uid = self.param.uid
  local picVer = toInt(self.param.picVer)
  self.assetKey = CS.UploadImageManager.Instance:GenAssetKey(uid, picVer, false)
  self._UIChatSendPhoto:SetData(PhotoFuncType.ChatSendPickPhoto, uid, picVer, self.assetKey, false)
  self._UIChatSendPhoto:StartUpdateSmallPhoto()
end

function ValentineDetailPhotoItemComponent:RefreshNpcHeadIcon()
  self.headIcon:SetActive(true)
  self.friendCircleRawImg:SetActive(false)
  self.headIcon:UseSpecifiedRes(self.param.pic)
end

function ValentineDetailPhotoItemComponent:SetUILoadedSuccessShow(assetKey)
  if self.photoType ~= SendGiftDetailPhotoType.FriendCircle or assetKey ~= self.assetKey then
    return
  end
  local cacheItem = self._UIChatSendPhoto:SetUILoadedSuccessShow(assetKey)
  if cacheItem == nil or IsNull(cacheItem) then
    return
  end
  self.friendCircleRawImg:SetTexture(cacheItem.textureAsset)
  self.friendCircleRawImg:SetNativeSize()
  self:ResetPhotoSize(self.friendCircleRawImg.rectTransform)
end

function ValentineDetailPhotoItemComponent:SetUIReloadShow(assetKey)
  if self.photoType ~= SendGiftDetailPhotoType.FriendCircle or assetKey ~= self.assetKey then
    return
  end
  self.friendCircleRawImg:LoadSprite(ChatSendPhotoReloadBgPath)
  self.friendCircleRawImg:SetNativeSize()
  self:ResetPhotoSize(self.friendCircleRawImg.rectTransform)
end

function ValentineDetailPhotoItemComponent:SetUILoadingShow(assetKey)
  if self.photoType ~= SendGiftDetailPhotoType.FriendCircle or assetKey ~= self.assetKey then
    return
  end
end

function ValentineDetailPhotoItemComponent:ResetPhotoSize(photoTrans)
  if not photoTrans then
    return
  end
  local originalWidth, originalHeight = photoTrans:Get_sizeDelta()
  local shrinkRatio = 0.9
  local finalWidth, finalHeight = 0, 0
  if originalHeight <= originalWidth then
    finalWidth = self.frameWidth * shrinkRatio
    finalHeight = math.floor(originalHeight * finalWidth / originalWidth)
  else
    finalHeight = self.frameHeight * shrinkRatio
    finalWidth = math.floor(originalWidth * finalHeight / originalHeight)
  end
  photoTrans:Set_sizeDelta(finalWidth, finalHeight)
end

function ValentineDetailPhotoItemComponent:SetEmptyState()
  self.headIcon:SetActive(false)
  self.friendCircleRawImg:SetActive(false)
end

ValentineDetailPhotoItemComponent.OnCreate = OnCreate
ValentineDetailPhotoItemComponent.OnDestroy = OnDestroy
ValentineDetailPhotoItemComponent.OnEnable = OnEnable
ValentineDetailPhotoItemComponent.OnDisable = OnDisable
ValentineDetailPhotoItemComponent.ComponentDefine = ComponentDefine
ValentineDetailPhotoItemComponent.ComponentDestroy = ComponentDestroy
ValentineDetailPhotoItemComponent.DataDefine = DataDefine
ValentineDetailPhotoItemComponent.DataDestroy = DataDestroy
ValentineDetailPhotoItemComponent.OnAddListener = OnAddListener
ValentineDetailPhotoItemComponent.OnRemoveListener = OnRemoveListener
return ValentineDetailPhotoItemComponent
