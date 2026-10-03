local UILWPostCircleFriendView = BaseClass("UILWPostCircleFriendView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local ChatSendPhotoLoadingBgPath = _ENV.ChatSendPhotoLoadingBgPath
local ChatInterface = _ENV.ChatInterface
local UIDurationDrop = require("UI.UIChatNewV2.Component.UIDurationDrop")
local maxCount = 200
local photoShowSize = 190
local compBook = {
  {
    path = "PopUpTitle/RawImage/inputMsg",
    name = "inputMsgMobile",
    rawType = CS.Mopsicus.Plugins.MobileInputField
  },
  {
    path = "PopUpTitle/RawImage/tipText",
    name = "tipText",
    type = UIText
  },
  {
    path = "PopUpTitle/selectImage/selectImageBtn",
    name = "selectImageBtn",
    type = UIButton,
    onClick = function(self)
      self:OnClickSelectPhoto()
    end
  },
  {
    path = "PopUpTitle/selectImage/photoMask/photo",
    name = "rawImgPhoto",
    type = UIRawImage
  },
  {
    path = "PopUpTitle/selectImage/photoMask/photo",
    name = "btnPhoto",
    type = UIButton
  },
  {
    path = "PopUpTitle/selectImage/photoMask/photo",
    name = "photoNode",
    type = UIBaseContainer
  },
  {
    path = "PopUpTitle/selectImage/photoMask/photo/imgLoading",
    name = "photoLoading",
    type = UIBaseContainer
  },
  {
    path = "PopUpTitle/selectImage/photoMask/photo/imgLoadFail",
    name = "photoLoadFail",
    type = UIBaseContainer
  },
  {
    path = "PopUpTitle/selectImage/btnCross",
    name = "btnPhotoCross",
    type = UIButton,
    onClick = function(self)
      self:OnClickDeletePhoto()
    end
  },
  {
    path = "PopUpTitle/BtnLayout/closeBtn",
    name = "closeBtn",
    type = UIButton,
    onClick = function(self)
      self:OnCloseBtnClick()
    end
  },
  {
    path = "PopUpTitle/BtnLayout/postBtn",
    name = "postBtn",
    type = UIButton,
    onClick = function(self)
      self:OnPostBtnClick()
    end
  },
  {
    path = "PopUpTitle/bg/BtnClose",
    name = "bgCloseBtn",
    type = UIButton,
    onClick = function(self)
      self:OnCloseBtnClick()
    end
  },
  {
    path = "panel",
    name = "panelBtn",
    type = UIButton,
    onClick = function(self)
      self:OnCloseBtnClick()
    end
  },
  {
    path = "PopUpTitle/RawImage/inputMsg",
    name = "inputMsgUnity",
    type = UIInput,
    active = true
  },
  {
    path = "UIDurationDrop",
    name = "durationDrop",
    type = UIDurationDrop,
    active = true
  },
  {
    path = "bgKeyBtn",
    name = "hideKeyBtn",
    type = UIButton,
    active = false,
    onClick = function(self)
      self:OnHideKeyClick()
    end
  },
  {
    path = "PopUpTitle/errorCom",
    name = "errorCom",
    type = UIBaseComponent,
    active = false,
    onClick = function(self)
      self:OnHideKeyClick()
    end
  }
}
local __IGNORE_WHITE_LIST = {
  UIWindowNames.UIChatNew_v2,
  UIWindowNames.UICommonIntroTip,
  UIWindowNames.UICommonUseItemTip,
  UIWindowNames.UICommonMessageSpecialBar,
  UIWindowNames.UICommonMessageBar,
  UIWindowNames.UICommonSingleMsgBar,
  UIWindowNames.UIPermanentTips,
  UIWindowNames.UINoticeTips,
  UIWindowNames.UINoticeHeroTips,
  UIWindowNames.UICommonBuyItem,
  UIWindowNames.UICommonUseResItemTips,
  UIWindowNames.UICommonItemProbability,
  UIWindowNames.LWUIAllianceNoticeDetail,
  UIWindowNames.LWUIMasteryExpGet,
  UIWindowNames.UIGetDuelScoreTip,
  UIWindowNames.UIOfficialMessageBar,
  UIWindowNames.UICommonMessageBarOld,
  UIWindowNames.UIAttackUnitsTips,
  UIWindowNames.UIBattleMessageBar
}

function UILWPostCircleFriendView:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:ReInit()
  self:TryinputParamView()
end

function UILWPostCircleFriendView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWPostCircleFriendView:OnHideKeyClick()
  self.inputMsgMobile:SetFocus(false)
  self.hideKeyBtn:SetActive(false)
end

function UILWPostCircleFriendView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GF_window_opened, self.OnWindowOpened)
  self:AddUIListener(EventId.GF_window_closed, self.OnWindowClosed)
  self:AddUIListener(EventId.PostMomentPhotoStateRefresh, self.InitPhotoStateShow)
  self:AddUIListener(EventId.ChatSendPhotoSetSuccess, self.SetUILoadedSuccessShow)
  self:AddUIListener(EventId.CHAT_UPLAOD_PIC_ERROR, self.RefreshError)
end

function UILWPostCircleFriendView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.GF_window_opened, self.OnWindowOpened)
  self:RemoveUIListener(EventId.GF_window_closed, self.OnWindowClosed)
  self:RemoveUIListener(EventId.PostMomentPhotoStateRefresh, self.InitPhotoStateShow)
  self:RemoveUIListener(EventId.ChatSendPhotoSetSuccess, self.SetUILoadedSuccessShow)
  self:RemoveUIListener(EventId.CHAT_UPLAOD_PIC_ERROR, self.RefreshError)
end

function UILWPostCircleFriendView:ComponentDefine()
  self:DefineCompsByBook(compBook)
  
  function self.OnTextChangeFromPlatform(str)
    self:OnInputMsgChanged(str)
  end
  
  self.inputMsgUnity:SetOnValueChange(function(value)
    self:OnInputMsgChanged(value)
  end)
  self.mobilId = self.inputMsgMobile:GetMobilId()
  
  function self.OnShowKeyboard(mobilId, isShow, height)
    self.hideKeyBtn:SetActive(isShow)
  end
  
  if ChatInterface.GetMobilSupportMultiple() then
    self.inputMsgMobile.OnShowKeyboard = self.OnShowKeyboard
    self.inputMsgMobile.OnTextChangeFromPlatform = self.OnTextChangeFromPlatform
  else
    CS.Mopsicus.Plugins.MobileInput.OnShowKeyboard = self.OnShowKeyboard
    CS.Mopsicus.Plugins.MobileInput.OnTextChangeFromPlatform = self.OnTextChangeFromPlatform
  end
  self.durationDrop:SetOnValueChanged(function(index)
    self:OnDropChange(index)
  end)
  self.inputMsgMobile:SetVisible(true)
  self.UIChatSendPhoto = self.photoNode.gameObject:GetComponent(typeof(CS.UIChatSendPhoto))
end

function UILWPostCircleFriendView:DataDefine()
  self.roomId, self.inputParam = self:GetUserData()
  self.hasTempChatData = nil
  self.isUseInputPicData = false
end

function UILWPostCircleFriendView:OnWindowClosed(windowName)
  if not self.inputMsgMobile then
    return
  end
  local isCover = self:GetWindowIsBottom()
  if isCover and self.hiddenKeyboard then
    self.inputMsgMobile:SetVisible(isCover)
    self.hiddenKeyboard = false
  end
end

function UILWPostCircleFriendView:IsCover(wind)
  if not wind then
    return false
  end
  local isBottom = true
  local windowStack = UIManager.Instance.windowStack
  while wind and isBottom do
    wind = windowStack:next(wind)
    if wind and wind.value then
      local config = UIManager.Instance:GetWindowConfig(wind.value.Name)
      if config ~= nil and config.Layer == UILayer.Normal then
        isBottom = false
      end
    end
  end
  return isBottom
end

function UILWPostCircleFriendView:GetWindowIsBottom()
  if UIManager.Instance:HasWindowByLayer(UILayer.Dialog) then
    return false
  end
  local window = UIManager.Instance:GetWindow(UIWindowNames.UILWPostCircleFriend)
  if window then
    local wind = UIManager.Instance.windowStack:find(window)
    return self:IsCover(wind)
  end
  return false
end

function UILWPostCircleFriendView:OnWindowOpened(windowName)
  if table.indexof(__IGNORE_WHITE_LIST, windowName) then
    return
  end
  if not self.inputMsgMobile then
    return
  end
  if not self.inputMsgUnity or IsNull(self.inputMsgUnity.gameObject) or not self.inputMsgUnity.gameObject.activeSelf then
    return
  end
  if windowName == UIWindowNames.UICommonMessageTip or windowName == UIWindowNames.UISellConfirm then
    self.inputMsgMobile:SetFocus(false)
    self.inputMsgMobile:SetVisible(false)
    self.hiddenKeyboard = true
    return
  end
  local isCover = self:GetWindowIsBottom()
  if not isCover then
    self.inputMsgMobile:SetFocus(isCover)
    self.inputMsgMobile:SetVisible(isCover)
    self.hiddenKeyboard = true
  end
end

function UILWPostCircleFriendView:DataDestroy()
  self.hiddenKeyboard = nil
  if self.hasTempChatData then
    ChatManager2:GetInstance().Room:RemoveRoomData(self.roomId)
  end
end

function UILWPostCircleFriendView:ComponentDestroy()
  if ChatInterface.GetMobilSupportMultiple() then
    self.inputMsgMobile.OnTextChangeFromPlatform = nil
    self.inputMsgMobile.OnShowKeyboard = nil
  else
    CS.Mopsicus.Plugins.MobileInput.OnShowKeyboard = nil
    CS.Mopsicus.Plugins.MobileInput.OnTextChangeFromPlatform = nil
  end
  self.OnShowKeyboard = nil
  self.OnTextChangeFromPlatform = nil
  self:ClearCompsByBook(compBook)
end

function UILWPostCircleFriendView:ReInit()
  self.tipText:SetText("0/" .. maxCount)
  self.inputMsgMobile.Text = ""
  if self.roomId then
    local roomData = ChatManager2:GetInstance().Room:GetRoomData(self.roomId)
    if roomData then
      self.inputMsgMobile.Text = roomData:GetCacheData().text
    else
      ChatManager2:GetInstance().Room:CreateChatRoom(self.roomId, ChatGroupType.GROUP_FRIENDS_CIRCLE_ROOM)
      self.hasTempChatData = true
    end
  end
  self.opList = self.ctrl:GetOpList()
  local textList = {}
  for i = 1, #self.opList do
    table.insert(textList, Localization:GetString(self.opList[i].lanKay))
  end
  local param = {
    generalColor = Color.New(0.5843137254901961, 0.5764705882352941, 0.6274509803921569, 1),
    selectColor = Color.New(0.16470588235294117, 0.1568627450980392, 0.18823529411764706, 1)
  }
  self.durationDrop:ReInit(textList, param)
  self.durationDrop:SetValue(1)
  self.selectType = self.opList[1].visibilityRange
  local uploadPicVer, photoData = ChatInterface.getRoomMgr():GetUploadPicVerAndPhotoDataInPanel()
  self:InitPhotoStateShow(uploadPicVer)
end

function UILWPostCircleFriendView:OnDropChange(index)
  self.selectType = self.opList[index].visibilityRange
end

function UILWPostCircleFriendView:OnInputMsgChanged(str)
  local text = str
  local count = string.word_count(text)
  if count > maxCount then
    local temp = string.SubStr(str, 1, maxCount)
    count = maxCount
    self.inputMsgMobile.Text = temp
  end
  self.tipText:SetText(count .. "/" .. maxCount)
  local canPost = self:CanPostMoment()
  CS.UIGray.SetGray(self.postBtn.transform, not canPost, canPost)
end

function UILWPostCircleFriendView:CanPostMoment()
  local uploadState = ChatInterface.getRoomMgr():GetMomentCurPhotoUploadState()
  local typeWithoutPhoto = not string.IsNullOrEmpty(self.inputMsgMobile.Text) and uploadState == PhotoUploadState.None
  local isUploadSuccess = uploadState == PhotoUploadState.UploadSuccess
  return typeWithoutPhoto or isUploadSuccess or self.isUseInputPicData
end

function UILWPostCircleFriendView:OnCloseBtnClick()
  local uploadState = ChatInterface.getRoomMgr():GetMomentCurPhotoUploadState()
  if string.IsNullOrEmpty(self.inputMsgMobile.Text) and uploadState == PhotoUploadState.None then
    self.ctrl:CloseSelf()
    return
  end
  UIUtil.ShowSecondMessage("", Localization:GetString("moment_post_tips"), 2, "moment_post_btn1", "moment_post_btn2", function()
    local roomData = ChatManager2:GetInstance().Room:GetRoomData(self.roomId)
    self:SavePhotoDataByUploadState()
    if roomData then
      local cache = roomData:GetCacheData()
      cache.text = self.inputMsgMobile.Text
      self.ctrl:CloseSelf()
    end
  end, nil, function()
    self:ClearPhotoDataByUploadState()
    local roomData = ChatManager2:GetInstance().Room:GetRoomData(self.roomId)
    if roomData then
      roomData:ClearTemp()
    end
    self.ctrl:CloseSelf()
  end, nil, nil, nil, nil, nil, nil, false, nil, nil)
end

function UILWPostCircleFriendView:SaveData()
  local roomData = ChatManager2:GetInstance().Room:GetRoomData(self.roomId)
  local cache = roomData:GetCacheData()
  cache.text = self.inputMsgMobile.Text
  self:SavePhotoDataByUploadState()
  self.inputMsgMobile.text = ""
end

function UILWPostCircleFriendView:OnPostBtnClick()
  local room = ChatInterface.getRoomData(self.roomId)
  if not room then
    UIUtil.ShowTipsId(129063)
    return
  end
  local canChat = DataCenter.LWRefundPunishManager:GetCanChat()
  if not canChat then
    return
  end
  local uploadPicVer, photoData = ChatInterface.getRoomMgr():GetUploadPicVerAndPhotoDataInPanel()
  local uploadState = ChatInterface.getRoomMgr():GetMomentCurPhotoUploadState()
  if self.isUseInputPicData then
    uploadState = PhotoUploadState.UploadSuccess
    uploadPicVer = self.inputParam.uploadPicVer
    local serverMsg = self.inputParam.serverMsg
    photoData = {
      smallHeight = serverMsg.height,
      smallWidth = serverMsg.width,
      bigHeight = serverMsg.heightBig,
      bigWidth = serverMsg.widthBig
    }
  end
  if uploadState == PhotoUploadState.Uploading then
    UIUtil.ShowTipsId("moment_post_tips1")
    return
  elseif uploadState == PhotoUploadState.UploadFail then
    UIUtil.ShowTipsId("moment_post_tips2")
    return
  end
  local authTable = ChatInterface.getMoment():GetAuth()
  authTable[self.selectType] = 1
  local cmdTbl = {
    roomId = self.roomId,
    msg = self.inputMsgMobile.Text,
    extra = {
      smallHeight = photoData.smallHeight,
      smallWidth = photoData.smallWidth,
      bigHeight = photoData.bigHeight,
      bigWidth = photoData.bigWidth,
      picVer = uploadPicVer,
      timeline = {
        rate = photoData.rate,
        auth = authTable
      }
    },
    post = uploadPicVer == -1 and PostType.FriendsCirleBody or PostType.FriendsCirleBodyHasIcon
  }
  local intHasPhoto = uploadState == PhotoUploadState.None and 1 or 0
  PostEventLog.Track(PostEventLog.Defines.FriendsCirlePost, {i_para1 = intHasPhoto})
  EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_SEND_ROOM_MSG_COMMAND, cmdTbl)
  self.inputMsgMobile.Text = ""
  ChatInterface.getRoomMgr():ClearPhotoPicVerStateAndFlag(uploadPicVer)
  ChatInterface.getRoomMgr():ClearPhotoDataInMoment(uploadPicVer)
  local roomData = ChatManager2:GetInstance().Room:GetRoomData(self.roomId)
  roomData:ClearTemp()
  UIUtil.ShowTipsId("moment_post_success_tips")
  self.ctrl:CloseSelf()
end

function UILWPostCircleFriendView:TryinputParamView()
  if self.inputParam == nil then
    return
  end
  local picUrlPathSmall = self.inputParam.picUrlPathSmall
  local picUrlPath = self.inputParam.picUrlPath
  local picWidth = self.inputParam.picWidth
  local picHeight = self.inputParam.picHeight
  local uploadPicVer = self.inputParam.uploadPicVer
  local serverMsg = self.inputParam.serverMsg
  if uploadPicVer and serverMsg then
    self.isUseInputPicData = true
    self.inputParamAssetKey = CS.UploadImageManager.Instance:GenAssetKey(LuaEntry.Player.uid, uploadPicVer, false)
    local originalHeight = serverMsg.heightBig
    local originalWidth = serverMsg.widthBig
    local finalWidth, finalHeight = 0, 0
    if originalHeight <= originalWidth then
      finalHeight = photoShowSize
      finalWidth = math.floor(originalWidth * finalHeight / originalHeight)
    else
      finalWidth = photoShowSize
      finalHeight = math.floor(originalHeight * finalWidth / originalWidth)
    end
    self.photoNode:SetSizeDeltaXY(finalWidth, finalHeight)
    self:InitPhotoStateShow(uploadPicVer)
    local cacheItem = self.UIChatSendPhoto:GetSmallPhotoCacheItem(self.inputParamAssetKey)
    if cacheItem == nil or IsNull(cacheItem) then
      self.UIChatSendPhoto:SetData(PhotoFuncType.MomentPickPhoto, LuaEntry.Player.uid, uploadPicVer, self.inputParamAssetKey, false)
      self.UIChatSendPhoto:StartUpdateSmallPhoto()
    else
      self.rawImgPhoto:SetTexture(cacheItem.textureAsset)
    end
  elseif not string.IsNullOrEmpty(picUrlPath) then
    CS.UploadImageManager.Instance:SetUploadImageLimit(4000, 3072, 1280, 200)
    DataCenter.ChatSendPhotoManager:SetCurPhotoFuncType(PhotoFuncType.MomentPickPhoto)
    CS.UploadImageManager.Instance.curPhotoFuncType = PhotoFuncType.MomentPickPhoto
    CS.UploadImageManager.Instance:FinishedSelectSingleImage(picUrlPathSmall, picWidth, picHeight)
  end
end

function UILWPostCircleFriendView:OnClickSelectPhoto()
  DataCenter.ChatSendPhotoManager:OnClickSelectPhoto()
end

function UILWPostCircleFriendView:OnClickDeletePhoto()
  if self.isUseInputPicData then
    self.isUseInputPicData = false
    local uploadPicVer, photoData = ChatInterface.getRoomMgr():GetUploadPicVerAndPhotoDataInPanel()
    self:InitPhotoStateShow(uploadPicVer)
  end
  local uploadState = ChatInterface.getRoomMgr():GetMomentCurPhotoUploadState()
  if uploadState == PhotoUploadState.None then
    return
  end
  self:ClearPhotoDataByUploadState()
  local canPost = self:CanPostMoment()
  CS.UIGray.SetGray(self.postBtn.transform, not canPost, canPost)
end

function UILWPostCircleFriendView:ClearPhotoDataByUploadState()
  local uploadPicVer, photoData = ChatInterface.getRoomMgr():GetUploadPicVerAndPhotoDataInPanel()
  local uploadState = ChatInterface.getRoomMgr():GetMomentCurPhotoUploadState()
  if uploadState == PhotoUploadState.Uploading then
    self.UIChatSendPhoto:AbortUploadSmallCacheItem(uploadPicVer, UploadImageType.Chat)
  end
  ChatInterface.getRoomMgr():ClearPhotoPicVerStateAndFlag(uploadPicVer)
  ChatInterface.getRoomMgr():ClearPhotoDataInMoment(uploadPicVer)
  CS.DynamicResourceManager.Instance:DeleteCacheCompressedPhoto(photoData.compressedPhotoPath)
  self:MomentPhotoResetSelect()
end

function UILWPostCircleFriendView:SavePhotoDataByUploadState()
  local uploadState = ChatInterface.getRoomMgr():GetMomentCurPhotoUploadState()
  if uploadState == PhotoUploadState.Uploading then
    local uploadPicVer, photoData = ChatInterface.getRoomMgr():GetUploadPicVerAndPhotoDataInPanel()
    ChatInterface.getRoomMgr():SetPhotoTmpSaveFlag(uploadPicVer, true)
  end
end

function UILWPostCircleFriendView:RefreshError(picData)
  local uploadPicVer, photoData = ChatInterface.getRoomMgr():GetUploadPicVerAndPhotoDataInPanel()
  if picData and picData.picVer ~= uploadPicVer then
    return
  end
  if picData.code == 1 then
    self.errorCom:SetActive(true)
  else
    self.errorCom:SetActive(false)
  end
end

function UILWPostCircleFriendView:InitPhotoStateShow(picVer)
  if self.isUseInputPicData then
    self.selectImageBtn:SetActive(false)
    self.photoNode:SetActive(true)
    self.photoLoading:SetActive(false)
    self.photoLoadFail:SetActive(false)
    self.btnPhotoCross:SetActive(true)
    self.btnPhoto:SetOnClick(function()
      self:OpenBigPhotoViewByFakeData()
    end)
    local canPost = self:CanPostMoment()
    CS.UIGray.SetGray(self.postBtn.transform, not canPost, canPost)
    return
  end
  local uploadPicVer, photoData = ChatInterface.getRoomMgr():GetUploadPicVerAndPhotoDataInPanel()
  if picVer ~= uploadPicVer then
    return
  end
  local uploadState = ChatInterface.getRoomMgr():GetMomentCurPhotoUploadState()
  if uploadState == PhotoUploadState.None then
    self:MomentPhotoResetSelect()
  elseif uploadState == PhotoUploadState.Uploading then
    self:MomentPhotoUploading()
  elseif uploadState == PhotoUploadState.UploadSuccess then
    self:MomentPhotoUploadSuccess()
  elseif uploadState == PhotoUploadState.UploadFail then
    self:MomentPhotoUploadFail()
  end
  local canPost = self:CanPostMoment()
  CS.UIGray.SetGray(self.postBtn.transform, not canPost, canPost)
end

function UILWPostCircleFriendView:MomentPhotoResetSelect()
  self.selectImageBtn:SetActive(true)
  self.photoNode:SetActive(false)
  self.photoLoading:SetActive(false)
  self.photoLoadFail:SetActive(false)
  self.btnPhotoCross:SetActive(false)
  self.btnPhoto:SetOnClick(function()
  end)
  self.rawImgPhoto:SetTexture(ChatSendPhotoLoadingBgPath)
end

function UILWPostCircleFriendView:MomentPhotoUploading()
  self.selectImageBtn:SetActive(false)
  self.photoNode:SetActive(true)
  self.photoLoading:SetActive(true)
  self.photoLoadFail:SetActive(false)
  self.btnPhotoCross:SetActive(true)
  self.btnPhoto:SetOnClick(function()
    self:OpenBigPhotoViewByFakeData()
  end)
  self:StartUpdateSmallPhoto()
end

function UILWPostCircleFriendView:MomentPhotoUploadSuccess()
  self.selectImageBtn:SetActive(false)
  self.photoNode:SetActive(true)
  self.photoLoading:SetActive(false)
  self.photoLoadFail:SetActive(false)
  self.btnPhotoCross:SetActive(true)
  self.btnPhoto:SetOnClick(function()
    self:OpenBigPhotoViewByFakeData()
  end)
  self:StartUpdateSmallPhoto()
end

function UILWPostCircleFriendView:MomentPhotoUploadFail()
  self.selectImageBtn:SetActive(false)
  self.photoNode:SetActive(true)
  self.photoLoading:SetActive(false)
  self.photoLoadFail:SetActive(true)
  self.btnPhotoCross:SetActive(true)
  self.btnPhoto:SetOnClick(function()
    DataCenter.ChatSendPhotoManager:OnClickPhotoReupload()
    self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
      DataCenter.ChatSendPhotoManager:OnClickPhotoReupload()
    end, 1.5)
  end)
  self:StartUpdateSmallPhoto()
end

function UILWPostCircleFriendView:SetUILoadedSuccessShow(assetKey)
  if self.isUseInputPicData then
    local cacheItem = self.UIChatSendPhoto:SetUILoadedSuccessShow(self.inputParamAssetKey)
    if cacheItem == nil or IsNull(cacheItem) then
      return
    end
    self.rawImgPhoto:SetTexture(cacheItem.textureAsset)
    return
  end
  local uploadPicVer, photoData = ChatInterface.getRoomMgr():GetUploadPicVerAndPhotoDataInPanel()
  if assetKey ~= photoData.assetKey then
    return
  end
  local cacheItem = self.UIChatSendPhoto:SetUILoadedSuccessShow(assetKey)
  if cacheItem == nil or IsNull(cacheItem) then
    return
  end
  self.rawImgPhoto:SetTexture(cacheItem.textureAsset)
end

function UILWPostCircleFriendView:StartUpdateSmallPhoto()
  local uploadPicVer, photoData = ChatInterface.getRoomMgr():GetUploadPicVerAndPhotoDataInPanel()
  if uploadPicVer == -1 or photoData == nil then
    return
  end
  local assetKey = photoData.assetKey
  self.UIChatSendPhoto:SetData(PhotoFuncType.MomentPickPhoto, LuaEntry.Player.uid, uploadPicVer, assetKey, false)
  self:MaskPartPhoto()
  self.UIChatSendPhoto:StartUpdateSmallPhoto()
end

function UILWPostCircleFriendView:MaskPartPhoto()
  local uploadPicVer, photoData = ChatInterface.getRoomMgr():GetUploadPicVerAndPhotoDataInPanel()
  if photoData == nil then
    return
  end
  local originalHeight = photoData.bigHeight
  local originalWidth = photoData.bigWidth
  local finalWidth, finalHeight = 0, 0
  if originalHeight <= originalWidth then
    finalHeight = photoShowSize
    finalWidth = math.floor(originalWidth * finalHeight / originalHeight)
  else
    finalWidth = photoShowSize
    finalHeight = math.floor(originalHeight * finalWidth / originalWidth)
  end
  self.photoNode:SetSizeDeltaXY(finalWidth, finalHeight)
end

function UILWPostCircleFriendView:OpenBigPhotoViewByFakeData()
  local targetSenderUid, targetPicVer, targetPicBigHeight, targetPicBigWidth, assetKey
  if self.isUseInputPicData then
    targetSenderUid = LuaEntry.Player.uid
    local serverMsg = self.inputParam.serverMsg
    targetPicVer = self.inputParam.uploadPicVer
    targetPicBigHeight = serverMsg.heightBig
    targetPicBigWidth = serverMsg.widthBig
    assetKey = self.inputParamAssetKey
  else
    local uploadPicVer, photoData = ChatInterface.getRoomMgr():GetUploadPicVerAndPhotoDataInPanel()
    if uploadPicVer == -1 or photoData == nil then
      Logger.LogError("MomentPhoto\239\188\154 \230\137\147\229\188\128\229\164\167\229\155\190\231\149\140\233\157\162\230\151\182\239\188\140\229\173\152\229\130\168\231\154\132\229\155\190\231\137\135\230\149\176\230\141\174\228\184\186\231\169\186")
      return
    end
    targetSenderUid = LuaEntry.Player.uid
    targetPicVer = uploadPicVer
    targetPicBigHeight = photoData.bigHeight
    targetPicBigWidth = photoData.bigWidth
    assetKey = CS.UploadImageManager.Instance:GenAssetKey(LuaEntry.Player.uid, uploadPicVer, false)
  end
  local tmpChatData = {
    getSenderUid = function()
      return targetSenderUid
    end,
    getExtra = function()
      local tmpData = {
        picVer = targetPicVer,
        bigHeight = targetPicBigHeight,
        bigWidth = targetPicBigWidth
      }
      return tmpData
    end
  }
  local param = {}
  param.chatData = tmpChatData
  param.smallAssetKey = assetKey
  param.photoFuncType = PhotoFuncType.MomentPickPhoto
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIChatViewBigPhotoView, {anim = true}, param)
end

return UILWPostCircleFriendView
