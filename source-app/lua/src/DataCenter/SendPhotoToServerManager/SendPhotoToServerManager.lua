local SendPhotoToServerManager = BaseClass("SendPhotoToServerManager")
local rapidjson = require("rapidjson")
local Localization = CS.GameEntry.Localization
local SDKManager = CS.SDKManager
local photoResolutionLimit = 4000
local photoFileSizeLimit = 3072
local suitableResolutionSizeBig = 1280
local suitableResolutionSizeSmall = 200
local selectImgCD = 2000

function SendPhotoToServerManager:__init()
  self.selectImgIdCount = 0
  self.sendImgIdCount = 0
  self.picVerTempList = {}
  self.sendPhotoTaskList = {}
  self.waitPicVerMsgBack = false
  self.mulSelectVer = "1.0.335"
  self.mulSelectCfgOpen = nil
  self.ctrlFuncType = {
    [FetchPicVerFuncType.ChatAlNoticePhotoNew] = true
  }
  self.selectInData = nil
  self.selectImgCDFinTime = 0
  self.sendIdToTaskDataDict = {}
  self.picVerToSenderIdDict = {}
end

function SendPhotoToServerManager:__delete()
  self.selectImgIdCount = nil
  self.sendImgIdCount = nil
  self.picVerTempList = nil
  self.sendPhotoTaskList = nil
  self.waitPicVerMsgBack = nil
  self.mulSelectVer = nil
  self.mulSelectCfgOpen = nil
  self.ctrlFuncType = nil
  self.selectInData = nil
  self.selectImgCDFinTime = nil
  self.sendIdToTaskDataDict = nil
  self.picVerToSenderIdDict = nil
end

function SendPhotoToServerManager:GetSelectImgId()
  self.selectImgIdCount = self.selectImgIdCount + 1
  return self.selectImgIdCount
end

function SendPhotoToServerManager:GetSelectImgIdSafe()
  local isCDPass, cdTip = self:CheckCDPassAndTip()
  if isCDPass then
    local id = self:GetSelectImgId()
    return isCDPass, cdTip, id
  else
    return isCDPass, cdTip
  end
end

function SendPhotoToServerManager:GetSendImgId()
  self.sendImgIdCount = self.sendImgIdCount + 1
  return self.sendImgIdCount
end

function SendPhotoToServerManager:OnPicVerMsgBack(picVer)
  self.waitPicVerMsgBack = false
  if picVer then
    table.insert(self.picVerTempList, picVer)
  end
  self:TryTriggerRequestUploadImg()
end

function SendPhotoToServerManager:TrySaveAPicVer(imgFuncType)
  if #self.picVerTempList > 0 then
    return
  end
  if self.waitPicVerMsgBack then
    return
  end
  self.waitPicVerMsgBack = true
  SFSNetwork.SendMessage(MsgDefines.FetchNewPicVer, imgFuncType)
end

function SendPhotoToServerManager:GetMulSelectVer()
  return self.mulSelectVer
end

function SendPhotoToServerManager:GetMulSelectCfgOpen()
  if self.mulSelectCfgOpen == nil then
    local cfgVal = LuaEntry.DataConfig:TryGetNum("alliance_announcement_multiple_images", "k1", 0)
    self.mulSelectCfgOpen = cfgVal == 1
  end
  return self.mulSelectCfgOpen
end

function SendPhotoToServerManager:IsMulSelectOpen()
  local isVerPass = CS.StringUtils.VersionCompare(CS.GameEntry.Sdk.Version, self:GetMulSelectVer()) >= 0
  local isCfgPass = self:GetMulSelectCfgOpen()
  local isPlatPass = false
  if SDKManager.IS_Android() or SDKManager.IS_IPhonePlayer() then
    isPlatPass = true
  end
  local isPass = isVerPass and isCfgPass and isPlatPass
  return isPass
end

function SendPhotoToServerManager:CheckIsInclueImgFuncType(imgFuncType)
  if imgFuncType ~= nil and self.ctrlFuncType[imgFuncType] then
    return true
  end
  return false
end

function SendPhotoToServerManager:CheckCDPassAndTip()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime > self.selectImgCDFinTime then
    return true
  else
    return false, ""
  end
end

function SendPhotoToServerManager:SetSendCD()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.selectImgCDFinTime = curTime + selectImgCD
end

function SendPhotoToServerManager:OnSelectImg(imgFuncType, selectFuncType, selectId, selectNum, selectFinCallBackFunc, selectFinParam, inPhotoResolutionLimit, inPhotoFileSizeLimit, inSuitableResolutionSizeBig, inSuitableResolutionSizeSmall)
  local isIncludeType = self:CheckIsInclueImgFuncType(imgFuncType)
  if not isIncludeType then
    Logger.LogError("\228\188\160\229\155\190\231\177\187\229\158\139\230\178\161\230\156\137\230\179\168\229\134\140")
    return
  end
  if imgFuncType == nil or selectFuncType == nil or selectId == nil or selectNum == nil then
    Logger.LogError("\228\188\160\229\155\190\229\143\130\230\149\176\230\156\137\231\169\186\231\154\132")
    return
  end
  local isCDPass, cdTip = self:CheckCDPassAndTip()
  if not isCDPass then
    if not string.IsNullOrEmpty(cdTip) then
      UIUtil.ShowTips(cdTip)
    end
    return
  end
  local isMulSelectOpen = self:IsMulSelectOpen()
  if inPhotoResolutionLimit == nil then
    inPhotoResolutionLimit = photoResolutionLimit
  end
  if inPhotoFileSizeLimit == nil then
    inPhotoFileSizeLimit = photoFileSizeLimit
  end
  if inSuitableResolutionSizeBig == nil then
    inSuitableResolutionSizeBig = suitableResolutionSizeBig
  end
  if inSuitableResolutionSizeSmall == nil then
    inSuitableResolutionSizeSmall = suitableResolutionSizeSmall
  end
  self.selectInData = {
    imgFuncType = imgFuncType,
    selectFuncType = selectFuncType,
    selectId = selectId,
    selectNum = selectNum,
    selectFinCallBackFunc = selectFinCallBackFunc,
    selectFinParam = selectFinParam,
    inPhotoResolutionLimit = inPhotoResolutionLimit,
    inPhotoFileSizeLimit = inPhotoFileSizeLimit,
    inSuitableResolutionSizeBig = inSuitableResolutionSizeBig,
    inSuitableResolutionSizeSmall = inSuitableResolutionSizeSmall
  }
  self:TrySaveAPicVer(imgFuncType)
  self:SetSendCD()
  if isMulSelectOpen then
    CS.UploadImageManager.Instance:SetUploadImageLimit(inPhotoResolutionLimit, inPhotoFileSizeLimit, inSuitableResolutionSizeBig, inSuitableResolutionSizeSmall)
    CS.UploadImageManager.Instance:OpenPhotoAlbumSelectPhotos(selectFuncType, PhotoNativeFuncType.PickPhotoList, selectNum)
  else
    CS.UploadImageManager.Instance:SetUploadImageLimit(inPhotoResolutionLimit, inPhotoFileSizeLimit, inSuitableResolutionSizeBig, inSuitableResolutionSizeSmall)
    CS.UploadImageManager.Instance:OpenPhotoAlbum(selectFuncType)
  end
end

function SendPhotoToServerManager:OnSelectSingleImgFinish(compressedPhotoPath, compressedWidth, compressedHeight)
  local selectData = self.selectInData
  if selectData == nil then
    return
  end
  self.selectImgCDFinTime = 0
  local selectId = selectData.selectId
  local imgFuncType = selectData.imgFuncType
  local sendIdList = {}
  local sendId = self:GetSendImgId()
  table.insert(sendIdList, sendId)
  local sendData = {
    sendId = sendId,
    imgFuncType = imgFuncType,
    compressedPhotoPath = compressedPhotoPath,
    compressedWidth = compressedWidth,
    compressedHeight = compressedHeight,
    state = PhotoUploadState.WaitPicVer,
    senderUid = LuaEntry.Player.uid,
    picVer = nil,
    photoData = nil
  }
  table.insert(self.sendPhotoTaskList, sendData)
  self.sendIdToTaskDataDict[sendId] = sendData
  if selectData.selectFinCallBackFunc then
    selectData.selectFinCallBackFunc(selectData.selectFinParam, selectId, sendIdList)
  end
  EventManager:GetInstance():Broadcast(EventId.SelectPhotoFinishAndData, {selectId = selectId, sendIdList = sendIdList})
  self:TryTriggerRequestUploadImg()
end

function SendPhotoToServerManager:OnSelectImgListFinish(compressedPhotoPathListStr, compressedWidthListStr, compressedHeightListStr)
  local selectData = self.selectInData
  if selectData == nil then
    return
  end
  local compressedPhotoPathList = string.split(compressedPhotoPathListStr, "|")
  local compressedWidthList = string.string2array_num_oneSep(compressedWidthListStr, "|")
  local compressedHeightList = string.string2array_num_oneSep(compressedHeightListStr, "|")
  if not (compressedPhotoPathList and compressedWidthList and compressedHeightList) or #compressedPhotoPathList ~= #compressedWidthList or #compressedPhotoPathList ~= #compressedHeightList then
    return
  end
  self.selectImgCDFinTime = 0
  local selectId = selectData.selectId
  local imgFuncType = selectData.imgFuncType
  local sendIdList = {}
  for i = 1, #compressedPhotoPathList do
    local sendId = self:GetSendImgId()
    table.insert(sendIdList, sendId)
    local sendData = {
      sendId = sendId,
      imgFuncType = imgFuncType,
      compressedPhotoPath = compressedPhotoPathList[i],
      compressedWidth = compressedWidthList[i],
      compressedHeight = compressedHeightList[i],
      state = PhotoUploadState.WaitPicVer,
      senderUid = LuaEntry.Player.uid,
      picVer = nil,
      photoData = nil
    }
    table.insert(self.sendPhotoTaskList, sendData)
    self.sendIdToTaskDataDict[sendId] = sendData
  end
  if selectData.selectFinCallBackFunc then
    selectData.selectFinCallBackFunc(selectData.selectFinParam, selectId, sendIdList)
  end
  EventManager:GetInstance():Broadcast(EventId.SelectPhotoFinishAndData, {selectId = selectId, sendIdList = sendIdList})
  self:TryTriggerRequestUploadImg()
end

function SendPhotoToServerManager:TryTriggerRequestUploadImg()
  if #self.sendPhotoTaskList == 0 then
    return
  end
  local data = self.sendPhotoTaskList[1]
  if data.state == PhotoUploadState.WaitPicVer then
    if 0 < #self.picVerTempList then
      local picVer = self.picVerTempList[1]
      table.remove(self.picVerTempList, 1)
      data.picVer = picVer
      data.state = PhotoUploadState.Uploading
      local assetKey = CS.UploadImageManager.Instance:GenAssetKey(LuaEntry.Player.uid, picVer, false)
      local assetKeyBig = CS.UploadImageManager.Instance:GenAssetKey(LuaEntry.Player.uid, picVer, true)
      local photoData = {
        compressedPhotoPath = data.compressedPhotoPath,
        bigHeight = data.compressedHeight,
        bigWidth = data.compressedWidth,
        assetKey = assetKey,
        assetKeyBig = assetKeyBig
      }
      data.photoData = photoData
      local senderId = data.sendId
      self.picVerToSenderIdDict[picVer] = senderId
      CS.DynamicResourceManager.Instance:CopyCompressedPhotoToTargetPathByPhotoFuncType(data.compressedPhotoPath, PhotoFuncType.CommonMulSelect, assetKey, assetKeyBig)
      CS.UploadImageManager.Instance:SetSendPhotoNewPhotoDir(data.compressedPhotoPath)
      CS.UploadImageManager.Instance:StartUploadPhoto(LuaEntry.Player.uid, picVer, CSharpCallLuaInterface.FinishedUploadPhotoCommon)
      EventManager:GetInstance():Broadcast(EventId.PhotoGetPicVerToUpload, senderId)
      if #self.sendPhotoTaskList > 1 then
        local nextData = self.sendPhotoTaskList[2]
        self:TrySaveAPicVer(nextData.imgFuncType)
      end
    else
      self:TrySaveAPicVer(data.imgFuncType)
    end
  else
  end
end

function SendPhotoToServerManager:FinishedUploadPhotoCommon(ret, resData, uploadPicVer, compressedPhotoPath)
  if ret ~= "true" then
    UIUtil.ShowTipsId("avatar_tips010")
    Logger.LogInfo("\228\184\138\228\188\160\232\182\133\230\151\182 5 ret:" .. tostring(ret) .. " resData:" .. tostring(resData))
    self:ProcessPhotoDataByUploadFail(uploadPicVer, compressedPhotoPath)
    EventManager:GetInstance():Broadcast(EventId.PhotoUploadStateChange, uploadPicVer)
    return
  end
  local serverMsg = rapidjson.decode(resData)
  if serverMsg == nil then
    Logger.LogError("#FinishedUploadPhotoCommon#  Lua:\228\184\138\228\188\160\230\136\144\229\138\159\229\144\142resData\230\149\176\230\141\174\228\184\186\231\169\186\239\188\129")
    self:ProcessPhotoDataByUploadFail(uploadPicVer, compressedPhotoPath)
    EventManager:GetInstance():Broadcast(EventId.PhotoUploadStateChange, uploadPicVer)
    return
  end
  if not serverMsg.status then
    UIUtil.ShowTipsId("avatar_tips010")
    Logger.LogInfo("\228\184\138\228\188\160\232\182\133\230\151\182 6 ret:" .. tostring(ret) .. " resData:" .. tostring(resData))
    self:ProcessPhotoDataByUploadFail(uploadPicVer, compressedPhotoPath)
    EventManager:GetInstance():Broadcast(EventId.PhotoUploadStateChange, uploadPicVer)
    return
  end
  if serverMsg.code then
    local code = tonumber(serverMsg.code)
    if code == 0 then
      if uploadPicVer and uploadPicVer ~= -1 then
        CS.DynamicResourceManager.Instance:DeleteCacheCompressedPhoto(compressedPhotoPath)
        self:ProcessPhotoDataByUploadSuccecss(uploadPicVer, compressedPhotoPath, serverMsg)
        EventManager:GetInstance():Broadcast(EventId.PhotoUploadStateChange, uploadPicVer)
        EventManager:GetInstance():Broadcast(EventId.SelfUploadImgSuccess, {uploadPicVer, serverMsg})
      end
    elseif code == 1 then
      UIUtil.ShowTipsId("avatar_tips009")
      CS.DynamicResourceManager.Instance:DeleteCacheCompressedPhoto(compressedPhotoPath)
      self:ProcessPhotoDataByUploadClear(uploadPicVer, compressedPhotoPath)
      EventManager:GetInstance():Broadcast(EventId.PhotoUploadStateChange, uploadPicVer)
      EventManager:GetInstance():Broadcast(EventId.PhotoUploadBan, uploadPicVer)
    else
      Logger.LogError("\228\184\138\228\188\160\231\187\147\230\158\156\231\154\132Code\229\188\130\229\184\184:" .. code)
      self:ProcessPhotoDataByUploadFail(uploadPicVer, compressedPhotoPath)
      EventManager:GetInstance():Broadcast(EventId.PhotoUploadStateChange, uploadPicVer)
    end
  end
end

function SendPhotoToServerManager:StopAllNoPicVerTask()
  for i = #self.sendPhotoTaskList, 1, -1 do
    local taskData = self.sendPhotoTaskList[i]
    if taskData.state == PhotoUploadState.WaitPicVer then
      taskData.state = PhotoUploadState.UploadFail
      table.remove(self.sendPhotoTaskList, i)
    end
  end
  self.waitPicVerMsgBack = false
  EventManager:GetInstance():Broadcast(EventId.PicVerGetMsgErr)
end

function SendPhotoToServerManager:RemoveTaskDataBySendId(sendId)
  local removeIndex
  for k, v in ipairs(self.sendPhotoTaskList) do
    if v.sendId == sendId then
      removeIndex = k
      break
    end
  end
  if removeIndex ~= nil then
    table.remove(self.sendPhotoTaskList, removeIndex)
  end
  self:TryTriggerRequestUploadImg()
end

function SendPhotoToServerManager:ProcessPhotoDataByUploadClear(uploadPicVer, compressedPhotoPath)
  local sendId = self.picVerToSenderIdDict[uploadPicVer]
  if sendId == nil then
    return
  end
  local data = self.sendIdToTaskDataDict[sendId]
  data.state = PhotoUploadState.None
  self:RemoveTaskDataBySendId(sendId)
end

function SendPhotoToServerManager:ProcessPhotoDataByUploadFail(uploadPicVer, compressedPhotoPath)
  local sendId = self.picVerToSenderIdDict[uploadPicVer]
  if sendId == nil then
    return
  end
  local data = self.sendIdToTaskDataDict[sendId]
  data.state = PhotoUploadState.UploadFail
  self:RemoveTaskDataBySendId(sendId)
end

function SendPhotoToServerManager:ProcessPhotoDataByUploadSuccecss(uploadPicVer, compressedPhotoPath, serverMsg)
  local sendId = self.picVerToSenderIdDict[uploadPicVer]
  if sendId == nil then
    return
  end
  local data = self.sendIdToTaskDataDict[sendId]
  data.state = PhotoUploadState.UploadSuccess
  if data.photoData then
    data.photoData.bigHeight = serverMsg.heightBig or data.photoData.bigHeight
    data.photoData.bigWidth = serverMsg.widthBig or data.photoData.bigWidth
    data.photoData.smallHeight = serverMsg.height or data.photoData.smallHeight
    data.photoData.smallWidth = serverMsg.width or data.photoData.smallWidth
    data.photoData.rate = serverMsg.rate or 0
  end
  self:RemoveTaskDataBySendId(sendId)
end

function SendPhotoToServerManager:OnClickPhotoReupload(sendId)
  local data = self.sendIdToTaskDataDict[sendId]
  if data == nil then
    return
  end
  local newSendId = self:GetSendImgId()
  local imgFuncType = data.imgFuncType
  local sendIdList = {}
  table.insert(sendIdList, newSendId)
  local sendData = {
    sendId = newSendId,
    imgFuncType = imgFuncType,
    compressedPhotoPath = data.compressedPhotoPath,
    compressedWidth = data.compressedWidth,
    compressedHeight = data.compressedHeight,
    state = PhotoUploadState.WaitPicVer,
    senderUid = LuaEntry.Player.uid,
    picVer = nil,
    photoData = nil
  }
  table.insert(self.sendPhotoTaskList, sendData)
  self.sendIdToTaskDataDict[newSendId] = sendData
  EventManager:GetInstance():Broadcast(EventId.PhotoReuploadSet, {oldSendId = sendId, newSendId = newSendId})
  self:TryTriggerRequestUploadImg()
end

function SendPhotoToServerManager:TryDelPicTaskBySendId(sendId)
  for i = #self.sendPhotoTaskList, 1, -1 do
    local data = self.sendPhotoTaskList[i]
    if data.sendId == sendId then
      table.remove(self.sendPhotoTaskList, i)
      break
    end
  end
end

function SendPhotoToServerManager:GetTaskDataBySendId(sendId)
  local taskData
  if sendId and self.sendIdToTaskDataDict[sendId] then
    taskData = self.sendIdToTaskDataDict[sendId]
  end
  return taskData
end

function SendPhotoToServerManager:GetSendIdByPicVer(picVer)
  local sendId
  if picVer and self.picVerToSenderIdDict[picVer] then
    sendId = self.picVerToSenderIdDict[picVer]
  end
  return sendId
end

return SendPhotoToServerManager
