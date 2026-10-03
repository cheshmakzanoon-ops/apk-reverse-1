local UIChatViewBigPhotoView = BaseClass("UIChatViewBigPhotoView", UIBaseView)
local base = UIBaseView
local logger = require("Framework.Logger.Logger")
local compBook = {
  {
    path = "UIPhoto",
    name = "RootPhoto",
    type = UIBaseContainer
  },
  {
    path = "UIPhoto",
    name = "RawImagetPhoto",
    type = UIRawImage
  },
  {
    path = "PhotoDefaultBg",
    name = "BlackBg",
    type = UIBaseContainer
  },
  {
    path = "BtnReport",
    name = "RootReport",
    type = UIBaseContainer
  },
  {
    path = "ImgLoading",
    name = "RootImgLoading",
    type = UIBaseContainer
  },
  {
    path = "ImgLoadFail",
    name = "RootImgLoadFail",
    type = UIBaseContainer
  },
  {
    path = "",
    name = "RootPanel",
    type = UIBaseContainer
  }
}

function UIChatViewBigPhotoView:OnCreate()
  base.OnCreate(self)
  self:DefineCompsByBook(compBook)
  self.UIChatSendPhoto = self.RootPhoto.gameObject:GetComponent(typeof(CS.UIChatSendPhoto))
  self.PhotoTouchInputCtrl = self.RootPhoto.gameObject:GetComponent(typeof(CS.BitBenderGames.TouchInputController2))
  self:InitData()
  self:RefreshPhotoView()
end

function UIChatViewBigPhotoView:OnDestroy()
  self:ClearCompsByBook(compBook)
  self.UIChatSendPhoto:CancelOrClearBigCacheItem()
  self.UIChatSendPhoto = nil
  self.PhotoTouchInputCtrl = nil
  self.chatData = nil
  self.assetKey = nil
  self.photoFuncType = nil
  base.OnDestroy(self)
end

function UIChatViewBigPhotoView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ChatSendPhotoSetSuccess, self.SetUILoadedSuccessShow)
  self:AddUIListener(EventId.ChatSendPhotoSetReload, self.SetUIReloadShow)
  self:AddUIListener(EventId.ChatSendPhotoSetLoading, self.SetUILoadingShow)
  self:AddUIListener(EventId.ChatSendPhotoReport, self.OnPhotoReport)
  self:AddUIListener(EventId.ChatSendPhotoCloseBigPhotoView, self.OnChatCloseBigPhotoView)
  self:AddUIListener(EventId.ChatSendPhotoSetInputCtlState, self.SetInputControllerState)
end

function UIChatViewBigPhotoView:OnRemoveListener()
  self:RemoveUIListener(EventId.ChatSendPhotoSetSuccess, self.SetUILoadedSuccessShow)
  self:RemoveUIListener(EventId.ChatSendPhotoSetReload, self.SetUIReloadShow)
  self:RemoveUIListener(EventId.ChatSendPhotoSetLoading, self.SetUILoadingShow)
  self:RemoveUIListener(EventId.ChatSendPhotoReport, self.OnPhotoReport)
  self:RemoveUIListener(EventId.ChatSendPhotoCloseBigPhotoView, self.OnChatCloseBigPhotoView)
  self:RemoveUIListener(EventId.ChatSendPhotoSetInputCtlState, self.SetInputControllerState)
  base.OnRemoveListener(self)
end

function UIChatViewBigPhotoView:InitData()
  local userData = self:GetUserData()
  self.chatData = userData.chatData
  self.smallAssetKey = userData.smallAssetKey
  self.photoFuncType = userData.photoFuncType
  self.picData = userData.picData
  self.chatReportParam = userData.chatReportParam
  self.isHideReportBtn = userData.isHideReportBtn
  if self.chatData and (self.chatData:getExtra() == nil or self.chatData:getExtra().picVer == nil) then
    logger.LogError("\232\129\138\229\164\169\229\143\145\233\128\129\229\155\190\231\137\135\228\184\139\229\143\145\231\154\132picVer\230\182\136\230\129\175\228\184\141\229\175\185\239\188\129")
    return
  end
  local uploadPicVer = self.chatData and self.chatData:getExtra().picVer or self.picData.picVer
  local senderUid = self.chatData and self.chatData:getSenderUid() or self.picData.senderUid
  if not string.IsNullOrEmpty(userData.bigAssetKey) then
    self.assetKey = userData.bigAssetKey
  else
    self.assetKey = CS.UploadImageManager.Instance:GenAssetKey(senderUid, uploadPicVer, true)
  end
end

function UIChatViewBigPhotoView:RefreshPhotoView()
  if self.UIChatSendPhoto == nil then
    logger.LogError("\232\129\138\229\164\169\229\164\167\229\155\190\239\188\140\228\184\141\229\173\152\229\156\168UIChatSendPhoto\232\132\154\230\156\172")
    return
  end
  local uploadPicVer = self.chatData and self.chatData:getExtra().picVer or self.picData.picVer
  local senderUid = self.chatData and self.chatData:getSenderUid() or self.picData.senderUid
  self.RootImgLoading:SetActive(false)
  self.RootImgLoadFail:SetActive(false)
  self.RootReport:SetActive(senderUid ~= ChatInterface.getPlayerUid() and not self.isHideReportBtn)
  self:SetPhotoSizeFromTexture()
  if type(uploadPicVer) == "number" then
    self.UIChatSendPhoto:SetData(self.photoFuncType, senderUid, uploadPicVer, self.assetKey, true)
  else
    self.UIChatSendPhoto:SetData(self.photoFuncType, senderUid, 0, self.assetKey, true)
  end
  self.UIChatSendPhoto:AddBigNodeUseNumMap()
  self:SetUILoadingShow(self.assetKey)
  self.UIChatSendPhoto:StartUpdateBigPhoto()
  local cacheItem = self.UIChatSendPhoto:GetBigPhotoCacheItem(self.assetKey)
  if cacheItem ~= nil and not IsNull(cacheItem) and not IsNull(cacheItem.textureAsset) then
    self:SetUILoadedSuccessShow(self.assetKey)
  end
end

function UIChatViewBigPhotoView:SetPhotoSizeFromTexture()
  local finalWidth, finalHeight = 0, 0
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local parentWidth = Screen.width / scaleFactor
  local parentHeight = Screen.height / scaleFactor
  local photoWidth = 0
  local photoHeight = 0
  if self.chatData then
    photoWidth = self.chatData:getExtra().bigWidth or parentWidth
    photoHeight = self.chatData:getExtra().bigHeight or parentHeight
  else
    photoWidth = self.picData.bigWidth or parentWidth
    photoHeight = self.picData.bigHeight or parentHeight
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
  self.RootPhoto:SetSizeDeltaXY(finalWidth, finalHeight)
  self.UIChatSendPhoto:SetPhotoOriginalSize(finalWidth, finalHeight)
  self.BlackBg:SetSizeDeltaXY(parentWidth + 100, parentHeight + 100)
  local btnOffset = parentWidth / 2 - 90
  self.RootReport:SetAnchoredPositionXY(btnOffset, self.RootReport:GetAnchoredPositionY())
end

function UIChatViewBigPhotoView:SetUILoadingShow(assetKey)
  if assetKey ~= self.assetKey then
    return
  end
  local cacheItem = self.UIChatSendPhoto:GetSmallPhotoCacheItem(self.smallAssetKey)
  if not IsNull(cacheItem) then
    self.RawImagetPhoto:SetTexture(cacheItem.textureAsset)
  end
  self.UIChatSendPhoto:BindClickCloseBigPhotoView()
  self.RootImgLoading:SetActive(true)
  self.RootImgLoadFail:SetActive(false)
end

function UIChatViewBigPhotoView:SetUIReloadShow(assetKey)
  if assetKey ~= self.assetKey then
    return
  end
  local cacheItem = self.UIChatSendPhoto:GetSmallPhotoCacheItem(self.smallAssetKey)
  if not IsNull(cacheItem) then
    self.RawImagetPhoto:SetTexture(cacheItem.textureAsset)
  end
  self.RootImgLoading:SetActive(false)
  self.RootImgLoadFail:SetActive(true)
end

function UIChatViewBigPhotoView:SetUILoadedSuccessShow(assetKey)
  if assetKey ~= self.assetKey then
    return
  end
  local cacheItem = self.UIChatSendPhoto:GetBigPhotoCacheItem(self.assetKey)
  if cacheItem == nil or IsNull(cacheItem) then
    return
  end
  self.RawImagetPhoto:SetTexture(cacheItem.textureAsset)
  self.UIChatSendPhoto:BindClickCloseBigPhotoView()
  self.RootImgLoading:SetActive(false)
  self.RootImgLoadFail:SetActive(false)
end

function UIChatViewBigPhotoView:OnPhotoReport()
  local isLvEnough = ChatManager2:GetInstance():CheckMainLvEnough()
  if not isLvEnough then
    UIUtil.ShowTipsId(208256)
    return
  end
  if self.chatData then
    local reported = ChatManager2:GetInstance():CheckIfReported(self.chatData)
    if reported then
      UIUtil.ShowTipsId(280064)
      return
    end
  end
  if ChatManager2:GetInstance():CheckReportTime() then
    if self.chatData then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIChatReport, {anim = true}, {
        type = ReportType.chatPhoto,
        chatData = self.chatData
      })
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIChatReport, {anim = true}, self.chatReportParam)
    end
  else
    UIUtil.ShowTipsId(208250)
  end
end

function UIChatViewBigPhotoView:OnChatCloseBigPhotoView()
  self.ctrl:CloseSelf()
end

function UIChatViewBigPhotoView:SetInputControllerState(state)
  self.UIChatSendPhoto:SetInputControllerState(state)
end

return UIChatViewBigPhotoView
