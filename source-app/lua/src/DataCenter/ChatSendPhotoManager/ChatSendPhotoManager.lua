local ChatSendPhotoManager = BaseClass("ChatSendPhotoManager")
local rapidjson = require("rapidjson")
local Localization = CS.GameEntry.Localization
local photoResolutionLimit = 4000
local photoFileSizeLimit = 3072
local suitableResolutionSizeBig = 1280
local suitableResolutionSizeSmall = 200
local compressedWidthFromNative = 0
local compressedHeightFromNative = 0
local selectedCompressedPhotoPath = 0

function ChatSendPhotoManager:__init()
  self.curPhotoFuncType = PhotoFuncType.None
  self.isGetPicVerInCD = true
end

function ChatSendPhotoManager:__delete()
end

function ChatSendPhotoManager:SetCurPhotoFuncType(photoFuncType)
  self.curPhotoFuncType = photoFuncType
end

function ChatSendPhotoManager:RequestStartUploadPhoto()
  local uploadPicVer = toInt(LuaEntry.GlobalData.lastestPicVer_ChatPhoto)
  if uploadPicVer <= 0 then
    UIUtil.ShowTipsId("avatar_tips006")
    return
  end
  if self.curPhotoFuncType == PhotoFuncType.ChatSendPickPhoto then
    self:RequestStartUploadChatPhoto(uploadPicVer)
  elseif self.curPhotoFuncType == PhotoFuncType.MomentPickPhoto then
    self:RequestStartUploadMomentPhoto(uploadPicVer)
  elseif self.curPhotoFuncType == PhotoFuncType.ChatAllianceNoticePhoto then
    self:RequestStartUploadAllianceNoticePhoto(uploadPicVer)
  end
  LuaEntry.GlobalData.lastestPicVer_ChatPhoto = -1
  LuaEntry.GlobalData.readyForPicVer = false
  LuaEntry.GlobalData.readyForSelectPic = false
end

function ChatSendPhotoManager:OnPhotoClick(targetRoomId, targetUserInfoUid)
  LuaEntry.GlobalData.targetRoomId = targetRoomId
  LuaEntry.GlobalData.targetUserInfoUid = targetUserInfoUid
  if LuaEntry.GlobalData.lastestPicVer_ChatPhoto == -1 then
    SFSNetwork.SendMessage(MsgDefines.FetchNewPicVer, FetchPicVerFuncType.ChatSendPhoto)
  end
  CS.UploadImageManager.Instance:SetUploadImageLimit(photoResolutionLimit, photoFileSizeLimit, suitableResolutionSizeBig, suitableResolutionSizeSmall)
  self:SetCurPhotoFuncType(PhotoFuncType.ChatSendPickPhoto)
  CS.UploadImageManager.Instance:OpenPhotoAlbum(PhotoFuncType.ChatSendPickPhoto)
end

function ChatSendPhotoManager:FinishedSelectSinglePhotoChat(compressedPhotoPath, compressedWidth, compressedHeight)
  LuaEntry.GlobalData.readyForSelectPic = true
  compressedWidthFromNative = compressedWidth
  compressedHeightFromNative = compressedHeight
  selectedCompressedPhotoPath = compressedPhotoPath
  if LuaEntry.GlobalData.lastestPicVer_ChatPhoto == -1 then
    SFSNetwork.SendMessage(MsgDefines.FetchNewPicVer, FetchPicVerFuncType.ChatSendPhoto)
    return
  end
  if LuaEntry.GlobalData.readyForSelectPic and LuaEntry.GlobalData.readyForPicVer then
    self:CheckUploadShowSecondConfirmBox()
  end
end

function ChatSendPhotoManager:CheckUploadShowSecondConfirmBox()
  if CS.SDKManager.IS_UNITY_ANDROID() then
    UIUtil.ShowMessage(Localization:GetString("pic_send_check_des"), 2, "btn_send", GameDialogDefine.CANCEL, function()
      self:RequestStartUploadPhoto()
    end, function()
      CS.DynamicResourceManager.Instance:DeleteCacheCompressedPhoto(CS.UploadImageManager.Instance.chatPhotoNewPhotoDir)
    end)
  else
    self:RequestStartUploadPhoto()
  end
end

function ChatSendPhotoManager:RequestStartUploadChatPhoto(uploadPicVer)
  self:CreateFakePhotoChatData(uploadPicVer)
  CS.UploadImageManager.Instance:StartUploadPhoto(LuaEntry.Player.uid, uploadPicVer, CSharpCallLuaInterface.FinishedUploadPhotoChat)
end

function ChatSendPhotoManager:FinishedUploadPhotoChat(ret, resData, uploadPicVer, compressedPhotoPath)
  CS.DynamicResourceManager.Instance:DeleteCacheCompressedPhoto(compressedPhotoPath)
  if ret ~= "true" then
    self:RemoveFakePhotoChatData(LuaEntry.GlobalData.targetRoomId, uploadPicVer, true)
    UIUtil.ShowTipsId("avatar_tips010")
    Logger.LogInfo("\228\184\138\228\188\160\232\182\133\230\151\182 1 ret:" .. tostring(ret) .. " resData:" .. tostring(resData))
    return
  end
  local serverMsg = rapidjson.decode(resData)
  if serverMsg == nil then
    Logger.LogError("#UploadChatPhoto#  Lua:\228\184\138\228\188\160\230\136\144\229\138\159\229\144\142resData\230\149\176\230\141\174\228\184\186\231\169\186\239\188\129")
    self:RemoveFakePhotoChatData(LuaEntry.GlobalData.targetRoomId, uploadPicVer, true)
    return
  end
  if not serverMsg.status then
    UIUtil.ShowTipsId("avatar_tips010")
    Logger.LogInfo("\228\184\138\228\188\160\232\182\133\230\151\182 2 ret:" .. tostring(ret) .. " resData:" .. tostring(resData))
    self:RemoveFakePhotoChatData(LuaEntry.GlobalData.targetRoomId, uploadPicVer, true)
    return
  end
  if serverMsg.code then
    local code = tonumber(serverMsg.code)
    if code == 0 then
      if uploadPicVer and uploadPicVer ~= -1 then
        ChatManager2:GetInstance():SendMessage_ChatPhoto("<lwPhoto:" .. uploadPicVer .. ":>", PostType.Chat_SendPhoto, uploadPicVer, serverMsg.height, serverMsg.width, serverMsg.heightBig, serverMsg.widthBig)
      end
      EventManager:GetInstance():Broadcast(EventId.SelfUploadImgSuccess, {uploadPicVer, serverMsg})
    elseif code == 1 then
      UIUtil.ShowTipsId("avatar_tips009")
      self:RemoveFakePhotoChatData(LuaEntry.GlobalData.targetRoomId, uploadPicVer, true)
    else
      Logger.LogError("\228\184\138\228\188\160\231\187\147\230\158\156\231\154\132Code\229\188\130\229\184\184:" .. code)
    end
  end
end

function ChatSendPhotoManager:CreateFakePhotoChatData(picVer)
  local extra = {
    bigWidth = compressedWidthFromNative,
    bigHeight = compressedHeightFromNative,
    picVer = picVer
  }
  local targetGroup = ChatGroupType.GROUP_ALLIANCE
  local roomData = ChatManager2:GetInstance().Room:GetRoomData(LuaEntry.GlobalData.targetRoomId)
  if roomData then
    targetGroup = roomData.group
  end
  local chatTabData = {
    roomId = LuaEntry.GlobalData.targetRoomId,
    group = targetGroup,
    post = PostType.Chat_SendPhoto,
    msg = ChatFakePhotoMsg,
    extra = extra
  }
  return ChatInterface.getRoomMgr():CreateFakePhotoChatData(chatTabData)
end

function ChatSendPhotoManager:RemoveFakePhotoChatData(roomId, picVer, isRefreshScroll)
  ChatInterface.getRoomMgr():RemoveFakePhotoChatData(roomId, picVer)
  EventManager:GetInstance():Broadcast(EventId.ChatDeleteChatDataByPicVer, {
    roomId = roomId,
    picVer = picVer,
    isRefreshScroll = isRefreshScroll
  })
end

function ChatSendPhotoManager:RemoveAllFakePhotoChatData()
  ChatInterface.getRoomMgr():RemoveAllFakePhotoChatData()
end

function ChatSendPhotoManager:OnClickSelectPhoto(targetFetchPicVerFuncType, targetPhotoFuncType)
  if targetFetchPicVerFuncType == nil then
    targetFetchPicVerFuncType = FetchPicVerFuncType.MomentPhoto
  end
  if targetPhotoFuncType == nil then
    targetPhotoFuncType = PhotoFuncType.MomentPickPhoto
  end
  if LuaEntry.GlobalData.lastestPicVer_ChatPhoto == -1 then
    SFSNetwork.SendMessage(MsgDefines.FetchNewPicVer, targetFetchPicVerFuncType)
  end
  CS.UploadImageManager.Instance:SetUploadImageLimit(photoResolutionLimit, photoFileSizeLimit, suitableResolutionSizeBig, suitableResolutionSizeSmall)
  self:SetCurPhotoFuncType(targetPhotoFuncType)
  CS.UploadImageManager.Instance:OpenPhotoAlbum(targetPhotoFuncType)
end

function ChatSendPhotoManager:FinishedSelectSinglePhotoMoment(compressedPhotoPath, compressedWidth, compressedHeight)
  LuaEntry.GlobalData.readyForSelectPic = true
  compressedWidthFromNative = compressedWidth
  compressedHeightFromNative = compressedHeight
  selectedCompressedPhotoPath = compressedPhotoPath
  if LuaEntry.GlobalData.lastestPicVer_ChatPhoto == -1 then
    SFSNetwork.SendMessage(MsgDefines.FetchNewPicVer, FetchPicVerFuncType.MomentPhoto)
    return
  end
  if LuaEntry.GlobalData.readyForSelectPic and LuaEntry.GlobalData.readyForPicVer then
    self:RequestStartUploadPhoto()
  end
end

function ChatSendPhotoManager:RequestStartUploadMomentPhoto(uploadPicVer)
  local uploadPicVerCache, photoDataCache = ChatInterface.getRoomMgr():GetUploadPicVerAndPhotoDataInPanel()
  ChatInterface.getRoomMgr():ClearPhotoPicVerStateAndFlag(uploadPicVerCache)
  ChatInterface.getRoomMgr():ClearPhotoDataInMoment(uploadPicVerCache)
  ChatInterface.getRoomMgr():SetMomentCurUploadPicVer(uploadPicVer)
  ChatInterface.getRoomMgr():SetPhotoUploadState(uploadPicVer, PhotoUploadState.Uploading)
  ChatInterface.getRoomMgr():SetPhotoTmpSaveFlag(uploadPicVer, true)
  local assetKey = CS.UploadImageManager.Instance:GenAssetKey(LuaEntry.Player.uid, uploadPicVer, false)
  local assetKeyBig = CS.UploadImageManager.Instance:GenAssetKey(LuaEntry.Player.uid, uploadPicVer, true)
  local photoData = {
    compressedPhotoPath = selectedCompressedPhotoPath,
    bigHeight = compressedHeightFromNative,
    bigWidth = compressedWidthFromNative,
    assetKey = assetKey,
    assetKeyBig = assetKeyBig
  }
  ChatInterface.getRoomMgr():SetPhotoData(uploadPicVer, photoData)
  CS.DynamicResourceManager.Instance:CopyCompressedPhotoToTargetPath(selectedCompressedPhotoPath, assetKey, assetKeyBig)
  EventManager:GetInstance():Broadcast(EventId.PostMomentPhotoStateRefresh, uploadPicVer)
  CS.UploadImageManager.Instance:StartUploadPhoto(LuaEntry.Player.uid, LuaEntry.GlobalData.lastestPicVer_ChatPhoto, CSharpCallLuaInterface.FinishedUploadPhotoMoment)
end

function ChatSendPhotoManager:FinishedUploadPhotoMoment(ret, resData, uploadPicVer, compressedPhotoPath)
  if ret ~= "true" then
    UIUtil.ShowTipsId("avatar_tips010")
    Logger.LogInfo("\228\184\138\228\188\160\232\182\133\230\151\182 3 ret:" .. tostring(ret) .. " resData:" .. tostring(resData))
    self:ProcessPhotoDataByUploadFail(uploadPicVer, compressedPhotoPath)
    EventManager:GetInstance():Broadcast(EventId.PostMomentPhotoStateRefresh, uploadPicVer)
    return
  end
  local serverMsg = rapidjson.decode(resData)
  if serverMsg == nil then
    Logger.LogError("#UploadMomentPhoto#  Lua:\228\184\138\228\188\160\230\136\144\229\138\159\229\144\142resData\230\149\176\230\141\174\228\184\186\231\169\186\239\188\129")
    self:ProcessPhotoDataByUploadFail(uploadPicVer, compressedPhotoPath)
    EventManager:GetInstance():Broadcast(EventId.PostMomentPhotoStateRefresh, uploadPicVer)
    return
  end
  if not serverMsg.status then
    UIUtil.ShowTipsId("avatar_tips010")
    Logger.LogInfo("\228\184\138\228\188\160\232\182\133\230\151\182 4 ret:" .. tostring(ret) .. " resData:" .. tostring(resData))
    self:ProcessPhotoDataByUploadFail(uploadPicVer, compressedPhotoPath)
    EventManager:GetInstance():Broadcast(EventId.PostMomentPhotoStateRefresh, uploadPicVer)
    return
  end
  local picVerId
  if serverMsg.code then
    local code = tonumber(serverMsg.code)
    if code == 0 then
      if uploadPicVer and uploadPicVer ~= -1 then
        picVerId = uploadPicVer
        self:ProcessPhotoDataByUploadSuccecss(uploadPicVer, compressedPhotoPath, serverMsg)
        EventManager:GetInstance():Broadcast(EventId.PostMomentPhotoStateRefresh, uploadPicVer)
        EventManager:GetInstance():Broadcast(EventId.SelfUploadImgSuccess, {uploadPicVer, serverMsg})
      end
    elseif code == 1 then
      UIUtil.ShowTipsId("avatar_tips009")
      ChatInterface.getRoomMgr():ClearPhotoPicVerStateAndFlag(uploadPicVer)
      ChatInterface.getRoomMgr():TryClearSamePicVerPhotoDataInMoment(uploadPicVer)
      CS.DynamicResourceManager.Instance:DeleteCacheCompressedPhoto(compressedPhotoPath)
      local picVer, photoData = ChatInterface.getRoomMgr():GetUploadPicVerAndPhotoDataInPanel()
      picVerId = picVer
      EventManager:GetInstance():Broadcast(EventId.PostMomentPhotoStateRefresh, picVer)
    else
      Logger.LogError("\228\184\138\228\188\160\231\187\147\230\158\156\231\154\132Code\229\188\130\229\184\184:" .. code)
    end
    EventManager:GetInstance():Broadcast(EventId.CHAT_UPLAOD_PIC_ERROR, {picVer = picVerId, code = code})
  end
end

function ChatSendPhotoManager:FinishedSelectSinglePhotoChatAllianceNotice(compressedPhotoPath, compressedWidth, compressedHeight)
  LuaEntry.GlobalData.readyForSelectPic = true
  compressedWidthFromNative = compressedWidth
  compressedHeightFromNative = compressedHeight
  selectedCompressedPhotoPath = compressedPhotoPath
  if LuaEntry.GlobalData.lastestPicVer_ChatPhoto == -1 then
    SFSNetwork.SendMessage(MsgDefines.FetchNewPicVer, FetchPicVerFuncType.ChatAllianceNoticePhoto)
    return
  end
  if LuaEntry.GlobalData.readyForSelectPic and LuaEntry.GlobalData.readyForPicVer then
    self:RequestStartUploadPhoto()
  end
end

function ChatSendPhotoManager:RequestStartUploadAllianceNoticePhoto(uploadPicVer)
  local uploadPicVerCache, photoDataCache = ChatInterface.getRoomMgr():GetUploadPicVerAndPhotoDataInPanel()
  ChatInterface.getRoomMgr():ClearPhotoPicVerStateAndFlag(uploadPicVerCache)
  ChatInterface.getRoomMgr():ClearPhotoDataInMoment(uploadPicVerCache)
  ChatInterface.getRoomMgr():SetMomentCurUploadPicVer(uploadPicVer)
  ChatInterface.getRoomMgr():SetPhotoUploadState(uploadPicVer, PhotoUploadState.Uploading)
  ChatInterface.getRoomMgr():SetPhotoTmpSaveFlag(uploadPicVer, true)
  local assetKey = CS.UploadImageManager.Instance:GenAssetKey(LuaEntry.Player.uid, uploadPicVer, false)
  local assetKeyBig = CS.UploadImageManager.Instance:GenAssetKey(LuaEntry.Player.uid, uploadPicVer, true)
  local photoData = {
    compressedPhotoPath = selectedCompressedPhotoPath,
    bigHeight = compressedHeightFromNative,
    bigWidth = compressedWidthFromNative,
    assetKey = assetKey,
    assetKeyBig = assetKeyBig
  }
  ChatInterface.getRoomMgr():SetPhotoData(uploadPicVer, photoData)
  CS.DynamicResourceManager.Instance:CopyCompressedPhotoToTargetPath(selectedCompressedPhotoPath, assetKey, assetKeyBig)
  EventManager:GetInstance():Broadcast(EventId.PostChatAllianceNoticePhotoStateRefresh, uploadPicVer)
  CS.UploadImageManager.Instance:StartUploadPhoto(LuaEntry.Player.uid, LuaEntry.GlobalData.lastestPicVer_ChatPhoto, CSharpCallLuaInterface.FinishedUploadPhotoChatAllianceNotice)
end

function ChatSendPhotoManager:FinishedUploadPhotoChatAllianceNotice(ret, resData, uploadPicVer, compressedPhotoPath)
  if ret ~= "true" then
    UIUtil.ShowTipsId("avatar_tips010")
    Logger.LogInfo("\228\184\138\228\188\160\232\182\133\230\151\182 5 ret:" .. tostring(ret) .. " resData:" .. tostring(resData))
    self:ProcessPhotoDataByUploadFail(uploadPicVer, compressedPhotoPath)
    EventManager:GetInstance():Broadcast(EventId.PostChatAllianceNoticePhotoStateRefresh, uploadPicVer)
    return
  end
  local serverMsg = rapidjson.decode(resData)
  if serverMsg == nil then
    Logger.LogError("#UploadPostChatAllianceNoticePhoto#  Lua:\228\184\138\228\188\160\230\136\144\229\138\159\229\144\142resData\230\149\176\230\141\174\228\184\186\231\169\186\239\188\129")
    self:ProcessPhotoDataByUploadFail(uploadPicVer, compressedPhotoPath)
    EventManager:GetInstance():Broadcast(EventId.PostChatAllianceNoticePhotoStateRefresh, uploadPicVer)
    return
  end
  if not serverMsg.status then
    UIUtil.ShowTipsId("avatar_tips010")
    Logger.LogInfo("\228\184\138\228\188\160\232\182\133\230\151\182 6 ret:" .. tostring(ret) .. " resData:" .. tostring(resData))
    self:ProcessPhotoDataByUploadFail(uploadPicVer, compressedPhotoPath)
    EventManager:GetInstance():Broadcast(EventId.PostChatAllianceNoticePhotoStateRefresh, uploadPicVer)
    return
  end
  if serverMsg.code then
    local code = tonumber(serverMsg.code)
    if code == 0 then
      if uploadPicVer and uploadPicVer ~= -1 then
        self:ProcessPhotoDataByUploadSuccecss(uploadPicVer, compressedPhotoPath, serverMsg)
        EventManager:GetInstance():Broadcast(EventId.PostChatAllianceNoticePhotoStateRefresh, uploadPicVer)
        EventManager:GetInstance():Broadcast(EventId.SelfUploadImgSuccess, {uploadPicVer, serverMsg})
      end
    elseif code == 1 then
      UIUtil.ShowTipsId("avatar_tips009")
      ChatInterface.getRoomMgr():ClearPhotoPicVerStateAndFlag(uploadPicVer)
      ChatInterface.getRoomMgr():TryClearSamePicVerPhotoDataInMoment(uploadPicVer)
      CS.DynamicResourceManager.Instance:DeleteCacheCompressedPhoto(compressedPhotoPath)
      local picVer, photoData = ChatInterface.getRoomMgr():GetUploadPicVerAndPhotoDataInPanel()
      EventManager:GetInstance():Broadcast(EventId.PostChatAllianceNoticePhotoStateRefresh, picVer)
    else
      Logger.LogError("\228\184\138\228\188\160\231\187\147\230\158\156\231\154\132Code\229\188\130\229\184\184:" .. code)
    end
  end
end

function ChatSendPhotoManager:ProcessPhotoDataByUploadFail(uploadPicVer, compressedPhotoPath)
  local tmpSaveFlag = ChatInterface.getRoomMgr():GetPhotoTmpSaveFlag(uploadPicVer)
  if tmpSaveFlag then
    ChatInterface.getRoomMgr():SetPhotoUploadState(uploadPicVer, PhotoUploadState.UploadFail)
  else
    ChatInterface.getRoomMgr():ClearPhotoPicVerStateAndFlag(uploadPicVer)
    ChatInterface.getRoomMgr():TryClearSamePicVerPhotoDataInMoment(uploadPicVer)
    CS.DynamicResourceManager.Instance:DeleteCacheCompressedPhoto(compressedPhotoPath)
  end
end

function ChatSendPhotoManager:ProcessPhotoDataByUploadSuccecss(uploadPicVer, compressedPhotoPath, serverMsg)
  local tmpSaveFlag = ChatInterface.getRoomMgr():GetPhotoTmpSaveFlag(uploadPicVer)
  if tmpSaveFlag then
    ChatInterface.getRoomMgr():SetPhotoUploadState(uploadPicVer, PhotoUploadState.UploadSuccess)
    local photoData = ChatInterface.getRoomMgr():GetPhotoData(uploadPicVer)
    if photoData then
      photoData.bigHeight = serverMsg.heightBig or photoData.bigHeight
      photoData.bigWidth = serverMsg.widthBig or photoData.bigWidth
      photoData.smallHeight = serverMsg.height or photoData.bigHeight
      photoData.smallWidth = serverMsg.width or photoData.bigWidth
      photoData.rate = serverMsg.rate or 0
    end
  else
    ChatInterface.getRoomMgr():ClearPhotoPicVerStateAndFlag(uploadPicVer)
    ChatInterface.getRoomMgr():TryClearSamePicVerPhotoDataInMoment(uploadPicVer)
  end
  CS.DynamicResourceManager.Instance:DeleteCacheCompressedPhoto(compressedPhotoPath)
end

function ChatSendPhotoManager:OnClickPhotoReupload(targetFetchPicVerFuncType)
  if not self.isGetPicVerInCD then
    return
  end
  if targetFetchPicVerFuncType == nil then
    targetFetchPicVerFuncType = FetchPicVerFuncType.MomentPhoto
  end
  LuaEntry.GlobalData.readyForSelectPic = true
  SFSNetwork.SendMessage(MsgDefines.FetchNewPicVer, targetFetchPicVerFuncType)
  self.isGetPicVerInCD = false
  if self.delayTimer ~= nil then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
  self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.isGetPicVerInCD = true
  end, 1.6)
end

return ChatSendPhotoManager
