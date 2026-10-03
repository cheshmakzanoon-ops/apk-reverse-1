local AlNoticePicItem = BaseClass("AlNoticePicItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local ChatSendPhotoLoadingBgPath = _ENV.ChatSendPhotoLoadingBgPath
local photo_mask_path = "photoMask"
local photo_path = "photoMask/photo"
local img_loading_path = "photoMask/photo/imgLoading"
local img_load_fail_path = "photoMask/photo/imgLoadFail"

function AlNoticePicItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function AlNoticePicItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function AlNoticePicItem:OnEnable()
  base.OnEnable(self)
end

function AlNoticePicItem:OnDisable()
  base.OnDisable(self)
end

function AlNoticePicItem:ComponentDefine()
  self.photo_mask = self:AddComponent(UIBaseContainer, photo_mask_path)
  self.photo = self:AddComponent(UIRawImage, photo_path)
  self.img_loading = self:AddComponent(UIImage, img_loading_path)
  self.img_load_fail = self:AddComponent(UIImage, img_load_fail_path)
  self.photoBtn = self:AddComponent(UIButton, photo_path)
  self.UIChatSendPhoto = self.photo.gameObject:GetComponent(typeof(CS.UIChatSendPhoto))
  self.photoBtn:SetOnClick(function()
    self:OnPhotoClickFunc()
  end)
end

function AlNoticePicItem:ComponentDestroy()
  self.photo_mask = nil
  self.photo = nil
  self.img_loading = nil
  self.img_load_fail = nil
  self.photoBtn = nil
end

function AlNoticePicItem:DataDefine()
  self.checkFunc = nil
  self.delPhotoFunc = nil
  self.selectPhotoFunc = nil
  self.longPassFunc = nil
  self.pointUpFunc = nil
  self.dragBeginFunc = nil
  self.dragMoveFunc = nil
  self.dataIndex = nil
  self.maxNum = nil
  self.photoData = nil
end

function AlNoticePicItem:DataDestroy()
  self.checkFunc = nil
  self.delPhotoFunc = nil
  self.selectPhotoFunc = nil
  self.longPassFunc = nil
  self.pointUpFunc = nil
  self.dragBeginFunc = nil
  self.dragMoveFunc = nil
  self.dataIndex = nil
  self.maxNum = nil
  self.photoData = nil
end

function AlNoticePicItem:SetCheckViewStateFunc(checkFunc)
  self.checkFunc = checkFunc
end

function AlNoticePicItem:SetDeletePhotoFunc(delPhotoFunc)
  self.delPhotoFunc = delPhotoFunc
end

function AlNoticePicItem:SetSelectPhotoFunc(selectPhotoFunc)
  self.selectPhotoFunc = selectPhotoFunc
end

function AlNoticePicItem:SetLongPassFunc(longPassFunc)
  self.longPassFunc = longPassFunc
end

function AlNoticePicItem:SetPointUpFunc(pointUpFunc)
  self.pointUpFunc = pointUpFunc
end

function AlNoticePicItem:SetDragBeginFunc(dragBeginFunc)
  self.dragBeginFunc = dragBeginFunc
end

function AlNoticePicItem:SetDragMoveFunc(dragMoveFunc)
  self.dragMoveFunc = dragMoveFunc
end

function AlNoticePicItem:SetData(photoData, allianceData, isHideReportBtn)
  self.photoData = photoData
  self.allianceData = allianceData
  self.isHideReportBtn = isHideReportBtn
  local selfSizeX, selfSizeY = self:GetSizeDeltaXY()
  self.photo_mask:SetSizeDeltaXY(selfSizeX, selfSizeY)
  self:RefreshView()
end

function AlNoticePicItem:RefreshView()
  if self.photoData == nil then
    self:MomentPhotoResetSelect()
  else
    self.photo:SetTexture(ChatSendPhotoLoadingBgPath)
    self.photo_mask:SetActive(true)
    self.img_loading:SetActive(true)
    self.img_load_fail:SetActive(false)
    self:StartUpdateSmallPhoto()
  end
end

function AlNoticePicItem:MomentPhotoResetSelect()
  self.photo_mask:SetActive(false)
  self.img_loading:SetActive(false)
  self.img_load_fail:SetActive(false)
end

function AlNoticePicItem:CheckRefreshByAssetKey(assetKey)
  if self.photoData == nil then
    return
  end
  if self.photoData[AlNoticePicDataType.SendId] == nil then
    if self.photoData[AlNoticePicDataType.AssetKey] == assetKey then
      local cacheItem = self.UIChatSendPhoto:SetUILoadedSuccessShow(assetKey)
      if cacheItem == nil or IsNull(cacheItem) then
        return
      end
      self.photo:SetTexture(cacheItem.textureAsset)
      self.photo_mask:SetActive(true)
      self.img_loading:SetActive(false)
      self.img_load_fail:SetActive(false)
    end
  else
    local sendId = self.photoData[AlNoticePicDataType.SendId]
    local uploadState = self.photoData[AlNoticePicDataType.SendState]
    local taskData = DataCenter.SendPhotoToServerManager:GetTaskDataBySendId(sendId)
    if taskData == nil then
      return
    end
    if taskData.photoData and taskData.photoData.assetKey == assetKey then
      local cacheItem = self.UIChatSendPhoto:SetUILoadedSuccessShow(assetKey)
      if cacheItem == nil or IsNull(cacheItem) then
        return
      end
      self.photo:SetTexture(cacheItem.textureAsset)
    end
  end
end

function AlNoticePicItem:StartUpdateSmallPhoto()
  if self.photoData[AlNoticePicDataType.AssetKey] then
    local senderUid = self.photoData[AlNoticePicDataType.SenderUid]
    local uploadPicVer = self.photoData[AlNoticePicDataType.PicVer]
    local photoData = {
      bigHeight = self.photoData[AlNoticePicDataType.BigHeight],
      bigWidth = self.photoData[AlNoticePicDataType.BigWidth],
      smallHeight = self.photoData[AlNoticePicDataType.SmallHeight],
      smallWidth = self.photoData[AlNoticePicDataType.SmallWidth],
      assetKey = self.photoData[AlNoticePicDataType.AssetKey]
    }
    self.UIChatSendPhoto:SetData(PhotoFuncType.CommonMulSelect, senderUid, uploadPicVer, photoData.assetKey, false)
    self:MaskPartPhoto(uploadPicVer, photoData)
    self.UIChatSendPhoto:StartUpdateSmallPhoto()
  end
end

function AlNoticePicItem:MaskPartPhoto(uploadPicVer, photoData)
  local originalHeight = photoData.bigHeight or 0
  local originalWidth = photoData.bigWidth or 0
  local photoSizeW, photoSizeH = self.photo_mask:GetSizeDeltaXY()
  local finalWidth, finalHeight = 0, 0
  if originalHeight ~= 0 and originalWidth ~= 0 and photoSizeW ~= 0 and photoSizeH ~= 0 then
    local originalRate = originalHeight / originalWidth
    local photoRate = photoSizeH / photoSizeW
    if originalRate > photoRate then
      finalWidth = photoSizeW
      finalHeight = math.floor(originalHeight * finalWidth / originalWidth)
    else
      finalHeight = photoSizeH
      finalWidth = math.floor(originalWidth * finalHeight / originalHeight)
    end
  end
  self.photo:SetSizeDeltaXY(finalWidth, finalHeight)
end

function AlNoticePicItem:OnPhotoClickFunc()
  if self.photoData == nil then
  else
    self:OpenBigPhotoViewByFakeData()
  end
end

function AlNoticePicItem:OpenBigPhotoViewByFakeData()
  if self.photoData == nil then
    return
  end
  local targetSenderUid, targetPicVer, targetPicBigHeight, targetPicBigWidth, assetKey
  local photoData = self.photoData
  if photoData then
    targetSenderUid = photoData[AlNoticePicDataType.SenderUid]
    targetPicVer = photoData[AlNoticePicDataType.PicVer]
    targetPicBigHeight = photoData[AlNoticePicDataType.BigHeight]
    targetPicBigWidth = photoData[AlNoticePicDataType.BigWidth]
    assetKey = CS.UploadImageManager.Instance:GenAssetKey(targetSenderUid, targetPicVer, false)
  end
  local tmpPicData = {
    senderUid = targetSenderUid,
    picVer = targetPicVer,
    bigHeight = targetPicBigHeight,
    bigWidth = targetPicBigWidth
  }
  local param = {}
  param.chatData = nil
  param.picData = tmpPicData
  param.smallAssetKey = assetKey
  param.photoFuncType = PhotoFuncType.CommonMulSelect
  param.isHideReportBtn = self.isHideReportBtn
  param.chatReportParam = {
    type = ReportType.allianceNotice,
    allianceId = LuaEntry.Player.allianceId,
    noticeId = self.allianceData.uid,
    uid = self.allianceData.publisherUid
  }
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIChatViewBigPhotoView, {anim = true}, param)
end

return AlNoticePicItem
