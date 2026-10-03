local AlNoticePicItem = BaseClass("AlNoticePicItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local ChatSendPhotoLoadingBgPath = _ENV.ChatSendPhotoLoadingBgPath
local select_image_btn_path = "selectImageBtn"
local img_txt_path = "selectImageBtn/imgTxt"
local photo_mask_path = "photoMask"
local photo_path = "photoMask/photo"
local img_loading_path = "photoMask/photo/imgLoading"
local img_load_fail_path = "photoMask/photo/imgLoadFail"
local btn_cross_path = "btnCross"

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
  self.select_image_btn = self:AddComponent(UIEventTrigger, select_image_btn_path)
  self.img_txt = self:AddComponent(UITextMeshProUGUIEx, img_txt_path)
  self.photo_mask = self:AddComponent(UIBaseContainer, photo_mask_path)
  self.photo = self:AddComponent(UIRawImage, photo_path)
  self.img_loading = self:AddComponent(UIImage, img_loading_path)
  self.img_load_fail = self:AddComponent(UIImage, img_load_fail_path)
  self.btn_cross = self:AddComponent(UIButton, btn_cross_path)
  self.UIChatSendPhoto = self.photo.gameObject:GetComponent(typeof(CS.UIChatSendPhoto))
  self.btn_cross:SetOnClick(function()
    if self.checkFunc and self.delPhotoFunc and self.checkFunc() then
      self.delPhotoFunc(self.dataIndex)
    end
  end)
  self.select_image_btn:OnDrag(function(data)
    if self.dragMoveFunc then
      self.dragMoveFunc(data)
    end
  end)
  self.select_image_btn:OnBeginDrag(function(data)
    if self.dragBeginFunc then
      self.dragBeginFunc(data)
    end
  end)
  self.select_image_btn:OnPointerUp(function()
    if self.pointUpFunc then
      self.pointUpFunc()
    end
  end)
  self.select_image_btn:onLongPress(function()
    if self.checkFunc and self.checkFunc() and self.longPassFunc then
      self.longPassFunc(self.dataIndex)
    end
  end)
  self.select_image_btn:OnPointerClick(function()
    if self.checkFunc and self.checkFunc() then
      self:OnPhotoClickFunc()
    end
  end)
end

function AlNoticePicItem:ComponentDestroy()
  self.select_image_btn = nil
  self.img_txt = nil
  self.photo_mask = nil
  self.photo = nil
  self.img_loading = nil
  self.img_load_fail = nil
  self.btn_cross = nil
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
  self.curNum = nil
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
  self.curNum = nil
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

function AlNoticePicItem:SetData(dataIndex, maxNum, photoData, curNum)
  self.dataIndex = dataIndex
  self.maxNum = maxNum
  self.photoData = photoData
  self.photo:SetTexture(ChatSendPhotoLoadingBgPath)
  self.curNum = curNum
  self:RefreshView()
end

function AlNoticePicItem:SetDataIndex(dataIndex)
  self.dataIndex = dataIndex
end

function AlNoticePicItem:RefreshView()
  if self.photoData == nil then
    self:MomentPhotoResetSelect()
  else
    if self.photoData[AlNoticePicDataType.SendId] == nil then
      self:RefreshPhotoAsset()
    else
    end
    local uploadState = self.photoData[AlNoticePicDataType.SendState]
    if uploadState == PhotoUploadState.Uploading or uploadState == PhotoUploadState.WaitPicVer then
      self:MomentPhotoUploading()
    elseif uploadState == PhotoUploadState.UploadSuccess then
      self:MomentPhotoUploadSuccess()
    elseif uploadState == PhotoUploadState.UploadFail then
      self:MomentPhotoUploadFail()
    end
  end
end

function AlNoticePicItem:MomentPhotoResetSelect()
  self.photo_mask:SetActive(false)
  self.img_loading:SetActive(false)
  self.img_load_fail:SetActive(false)
  self.btn_cross:SetActive(false)
  self.img_txt:SetText(self.curNum .. "/" .. self.maxNum)
end

function AlNoticePicItem:MomentPhotoUploading()
  self.photo_mask:SetActive(true)
  self.img_loading:SetActive(true)
  self.img_load_fail:SetActive(false)
  self.btn_cross:SetActive(true)
  self:StartUpdateSmallPhoto()
end

function AlNoticePicItem:MomentPhotoUploadSuccess()
  self.photo_mask:SetActive(true)
  self.img_loading:SetActive(false)
  self.img_load_fail:SetActive(false)
  self.btn_cross:SetActive(true)
  self:StartUpdateSmallPhoto()
end

function AlNoticePicItem:MomentPhotoUploadFail()
  self.photo_mask:SetActive(true)
  self.img_loading:SetActive(false)
  self.img_load_fail:SetActive(true)
  self.btn_cross:SetActive(true)
  self:StartUpdateSmallPhoto()
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

function AlNoticePicItem:RefreshPhotoAsset()
  if self.photoData == nil then
    return
  end
  if self.photoData[AlNoticePicDataType.SendId] == nil then
    if self.photoData[AlNoticePicDataType.AssetKey] then
      local cacheItem = self.UIChatSendPhoto:SetUILoadedSuccessShow(self.photoData[AlNoticePicDataType.AssetKey])
      if cacheItem == nil or IsNull(cacheItem) then
        return
      end
      self.photo:SetTexture(cacheItem.textureAsset)
    end
  else
    local sendId = self.photoData[AlNoticePicDataType.SendId]
    local uploadState = self.photoData[AlNoticePicDataType.SendState]
    local taskData = DataCenter.SendPhotoToServerManager:GetTaskDataBySendId(sendId)
    if taskData == nil then
      return
    end
    if taskData.photoData == nil then
      return
    end
    local cacheItem = self.UIChatSendPhoto:SetUILoadedSuccessShow(taskData.photoData.assetKey)
    if cacheItem == nil or IsNull(cacheItem) then
      return
    end
    self.photo:SetTexture(cacheItem.textureAsset)
  end
end

function AlNoticePicItem:CheckPicStateChange()
  self:RefreshView()
end

function AlNoticePicItem:OnPhotoGetPicVerToUploadMsg(sendId)
  if self.photoData == nil then
    return
  end
  if self.photoData[AlNoticePicDataType.SendId] == nil then
    return
  end
  local selfSendId = self.photoData[AlNoticePicDataType.SendId]
  if selfSendId ~= sendId then
    return
  end
  self:RefreshView()
end

function AlNoticePicItem:StartUpdateSmallPhoto()
  local sendId = self.photoData[AlNoticePicDataType.SendId]
  if sendId == nil then
    if self.photoData[AlNoticePicDataType.AssetKey] then
      local senderUid = self.photoData[AlNoticePicDataType.SenderUid]
      local uploadPicVer = self.photoData[AlNoticePicDataType.PicVer]
      local photoData = {
        bigHeight = self.photoData[AlNoticePicDataType.BigHeight],
        bigWidth = self.photoData[AlNoticePicDataType.BigWidth],
        assetKey = self.photoData[AlNoticePicDataType.AssetKey]
      }
      self.UIChatSendPhoto:SetData(PhotoFuncType.CommonMulSelect, senderUid, uploadPicVer, photoData.assetKey, false)
      self:MaskPartPhoto(uploadPicVer, photoData)
      self.UIChatSendPhoto:StartUpdateSmallPhoto()
    end
  else
    local taskData = DataCenter.SendPhotoToServerManager:GetTaskDataBySendId(sendId)
    if taskData == nil then
      return
    end
    if taskData.picVer == nil or taskData.photoData == nil then
      return
    end
    local uploadPicVer = taskData.picVer
    local photoData = taskData.photoData
    self.UIChatSendPhoto:SetData(PhotoFuncType.CommonMulSelect, taskData.senderUid, uploadPicVer, photoData.assetKey, false)
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
    if self.selectPhotoFunc then
      self.selectPhotoFunc(self.dataIndex)
    end
  elseif self.photoData[AlNoticePicDataType.SendState] == PhotoUploadState.UploadSuccess then
    self:OpenBigPhotoViewByFakeData()
  elseif self.photoData[AlNoticePicDataType.SendState] == PhotoUploadState.UploadFail then
    local sendId = self.photoData[AlNoticePicDataType.SendId]
    if sendId then
      DataCenter.SendPhotoToServerManager:OnClickPhotoReupload(sendId)
    end
  end
end

function AlNoticePicItem:OpenBigPhotoViewByFakeData()
  if self.photoData == nil then
    return
  end
  local targetSenderUid, targetPicVer, targetPicBigHeight, targetPicBigWidth, assetKey
  local sendId = self.photoData[AlNoticePicDataType.SendId]
  if sendId == nil then
    local photoData = self.photoData
    if photoData then
      targetSenderUid = photoData[AlNoticePicDataType.SenderUid]
      targetPicVer = photoData[AlNoticePicDataType.PicVer]
      targetPicBigHeight = photoData[AlNoticePicDataType.BigHeight]
      targetPicBigWidth = photoData[AlNoticePicDataType.BigWidth]
      assetKey = CS.UploadImageManager.Instance:GenAssetKey(targetSenderUid, targetPicVer, false)
    end
  else
    local taskData = DataCenter.SendPhotoToServerManager:GetTaskDataBySendId(sendId)
    if taskData == nil then
      return
    end
    if taskData.picVer == nil or taskData.photoData == nil then
      return
    end
    local uploadPicVer = taskData.picVer
    local photoData = taskData.photoData
    targetSenderUid = taskData.senderUid
    targetPicVer = taskData.picVer
    targetPicBigHeight = photoData.bigHeight
    targetPicBigWidth = photoData.bigWidth
    assetKey = photoData.assetKey
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
  param.isHideReportBtn = true
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIChatViewBigPhotoView, {anim = true}, param)
end

return AlNoticePicItem
