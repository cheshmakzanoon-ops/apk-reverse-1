local LWUIChatCommonShareView = BaseClass("LWUIChatCommonShareView", UIBaseView)
local base = UIBaseView
local ResourceManager = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization
local ImgCreateContent = require("UI.LWUIChatCommonShare.Component.ImgCreateContent")
local close_bg_path = "CloseBg"
local top_pic_content_path = "Content/TopPicContent"
local share_btn_content_path = "Content/ShareBtnContent"
local share_tip_txt_path = "Content/ShareBtnContent/shareTipTxt"
local btn_close_path = "Content/btnClose"
local share_btn1_path = "Content/ShareBtnContent/shareBtnList/shareBtn1"
local btn_icon1_path = "Content/ShareBtnContent/shareBtnList/shareBtn1/btnIcon1"
local btn_txt1_path = "Content/ShareBtnContent/shareBtnList/shareBtn1/btnTxt1"
local share_btn2_path = "Content/ShareBtnContent/shareBtnList/shareBtn2"
local btn_icon2_path = "Content/ShareBtnContent/shareBtnList/shareBtn2/btnIcon2"
local btn_txt2_path = "Content/ShareBtnContent/shareBtnList/shareBtn2/btnTxt2"
local share_btn3_path = "Content/ShareBtnContent/shareBtnList/shareBtn3"
local btn_icon3_path = "Content/ShareBtnContent/shareBtnList/shareBtn3/btnIcon3"
local btn_txt3_path = "Content/ShareBtnContent/shareBtnList/shareBtn3/btnTxt3"
local top_pic_img_path = "Content/TopPicContent/TopPicImg"
local imgCreatePrefab = "Assets/Main/Prefabs/UI/ChatNew/ChatCommonShare/ChatCommonShareImgCreate.prefab"

function LWUIChatCommonShareView:OnCreate()
  base.OnCreate(self)
  self.inputParam, self.extra = self:GetUserData()
  self:ComponentDefine()
  self:DataDefine()
  self:InitView()
end

function LWUIChatCommonShareView:OnDestroy()
  self:ImgCreateContentDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIChatCommonShareView:ComponentDefine()
  self.close_bg = self:AddComponent(UIButton, close_bg_path)
  self.top_pic_content = self:AddComponent(UIBaseContainer, top_pic_content_path)
  self.share_btn_content = self:AddComponent(UIBaseContainer, share_btn_content_path)
  self.share_tip_txt = self:AddComponent(UITextMeshProUGUIEx, share_tip_txt_path)
  self.btn_close = self:AddComponent(UIButton, btn_close_path)
  self.close_bg:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.btn_close:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.share_btn1 = self:AddComponent(UIButton, share_btn1_path)
  self.btn_icon1 = self:AddComponent(UIImage, btn_icon1_path)
  self.btn_txt1 = self:AddComponent(UITextMeshProUGUIEx, btn_txt1_path)
  self.share_btn2 = self:AddComponent(UIButton, share_btn2_path)
  self.btn_icon2 = self:AddComponent(UIImage, btn_icon2_path)
  self.btn_txt2 = self:AddComponent(UITextMeshProUGUIEx, btn_txt2_path)
  self.share_btn3 = self:AddComponent(UIButton, share_btn3_path)
  self.btn_icon3 = self:AddComponent(UIImage, btn_icon3_path)
  self.btn_txt3 = self:AddComponent(UITextMeshProUGUIEx, btn_txt3_path)
  self.share_btn_list = {
    {
      share_btn = self.share_btn1,
      btn_icon = self.btn_icon1,
      btn_txt = self.btn_txt1
    },
    {
      share_btn = self.share_btn2,
      btn_icon = self.btn_icon2,
      btn_txt = self.btn_txt2
    },
    {
      share_btn = self.share_btn3,
      btn_icon = self.btn_icon3,
      btn_txt = self.btn_txt3
    }
  }
  for i, v in ipairs(self.share_btn_list) do
    v.share_btn:SetOnClick(function()
      self:OnShareBtnClick(i)
    end)
  end
  self.top_pic_img = self:AddComponent(UIRawImage, top_pic_img_path)
end

function LWUIChatCommonShareView:ComponentDestroy()
  self.close_bg = nil
  self.top_pic_content = nil
  self.share_btn_content = nil
  self.share_tip_txt = nil
  self.btn_close = nil
  self.share_btn1 = nil
  self.btn_icon1 = nil
  self.btn_txt1 = nil
  self.share_btn2 = nil
  self.btn_icon2 = nil
  self.btn_txt2 = nil
  self.share_btn3 = nil
  self.btn_icon3 = nil
  self.btn_txt3 = nil
  self.top_pic_img = nil
end

function LWUIChatCommonShareView:DataDefine()
  self.shareBtnTypeData = {
    [ChatCommonShareMethodType.Download] = {
      type = ChatCommonShareMethodType.Download,
      icon = "Assets/Main/Sprites/UI/LWChat_v2/Common/mjc_fenxiang_anniu_xiazai.png",
      txtKey = "btn_save_image"
    },
    [ChatCommonShareMethodType.Chat] = {
      type = ChatCommonShareMethodType.Chat,
      icon = "Assets/Main/Sprites/UI/LWChat_v2/Common/mjc_fenxiang_anniu_fenxiang.png",
      txtKey = "btn_share"
    },
    [ChatCommonShareMethodType.FriendCircle] = {
      type = ChatCommonShareMethodType.FriendCircle,
      icon = "Assets/Main/Sprites/UI/LWChat_v2/Common/mjc_fenxiang_anniu_dongtai.png",
      txtKey = "btn_post_moment"
    }
  }
  self.shareBtnData = {}
  self.savePicPath = nil
  self.savePicName = nil
  self.savePicCompletePath = nil
  self.saveSmallPicCompletePath = nil
  self.savePicDownloadPath = nil
  self.savePicWidth = 0
  self.savePicHeight = 0
  self.waitingPicUploadPicVer = nil
  self.savePicUploadServerMsg = nil
  self.savePicUploadPicVer = nil
  self.instanceRequest = nil
  self.instanceObj = nil
  self.imgCreateContent = nil
  self.renderTexture = nil
  self.waitShareMsgBack = false
end

function LWUIChatCommonShareView:DataDestroy()
  self.shareBtnData = nil
  if self.savePicCompletePath then
    CS.DynamicResourceManager.Instance:DeleteCacheCompressedPhoto(self.savePicCompletePath)
  end
  if self.saveSmallPicCompletePath then
    CS.DynamicResourceManager.Instance:DeleteCacheCompressedPhoto(self.saveSmallPicCompletePath)
  end
  if self.savePicDownloadPath then
    CS.DynamicResourceManager.Instance:DeleteCacheCompressedPhoto(self.savePicDownloadPath)
  end
  self.savePicPath = nil
  self.savePicName = nil
  self.savePicCompletePath = nil
  self.saveSmallPicCompletePath = nil
  self.savePicDownloadPath = nil
  self.savePicWidth = nil
  self.savePicHeight = nil
  self.waitingPicUploadPicVer = nil
  self.savePicUploadServerMsg = nil
  self.savePicUploadPicVer = nil
  self.instanceRequest = nil
  self.instanceObj = nil
  self.imgCreateContent = nil
  self.renderTexture = nil
  self.waitShareMsgBack = nil
end

function LWUIChatCommonShareView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.CHAT_SEND_ROOM_MSG_COMMAND, self.OnChatPhotoSend)
  self:AddUIListener(EventId.SelfUploadImgSuccess, self.OnSelfUploadImgSuccess)
end

function LWUIChatCommonShareView:OnRemoveListener()
  self:RemoveUIListener(EventId.CHAT_SEND_ROOM_MSG_COMMAND, self.OnChatPhotoSend)
  self:RemoveUIListener(EventId.SelfUploadImgSuccess, self.OnSelfUploadImgSuccess)
  base.OnRemoveListener(self)
end

function LWUIChatCommonShareView:ImgCreateContentDestroy()
  if self.imgCreateContent ~= nil and self.instanceObj ~= nil then
    self:RemoveComponentOnly(self.instanceObj.name, ImgCreateContent)
  end
  if self.instanceRequest ~= nil then
    self.instanceRequest:Destroy()
    self.instanceRequest = nil
    self.instanceObj = nil
  end
end

function LWUIChatCommonShareView:InitView()
  local cfgId = self.inputParam
  if cfgId == nil then
    return
  end
  local oneTemplate
  oneTemplate = LocalController:instance():tryGetLine(TableName.SHARE_COMPONENTS, tostring(cfgId))
  if oneTemplate == nil then
    return
  end
  self.targetTemplate = oneTemplate
  if oneTemplate.btn_save > 0 then
    table.insert(self.shareBtnData, self.shareBtnTypeData[ChatCommonShareMethodType.Download])
  end
  if 0 < oneTemplate.btn_share then
    table.insert(self.shareBtnData, self.shareBtnTypeData[ChatCommonShareMethodType.Chat])
  end
  if 0 < oneTemplate.btn_moment then
    table.insert(self.shareBtnData, self.shareBtnTypeData[ChatCommonShareMethodType.FriendCircle])
  end
  local titleTxtKey = oneTemplate.content
  local picPath = oneTemplate.pic_path
  local inputParam = {
    titleTxtKey = titleTxtKey,
    picPath = picPath,
    extra = self.extra
  }
  local prefabPath = imgCreatePrefab
  if not string.IsNullOrEmpty(oneTemplate.prefab_path) then
    prefabPath = oneTemplate.prefab_path
  end
  local component = ImgCreateContent
  if not string.IsNullOrEmpty(oneTemplate.script_path) then
    component = require(oneTemplate.script_path)
  end
  self.top_pic_img:LoadSpriteAuto(picPath, function()
    self.instanceRequest = ResourceManager:InstantiateAsyncImmediately(prefabPath, function(request)
      local go = request.gameObject
      local trans = go.transform
      self.instanceObj = go
      trans:Set_localPosition(0, -10000, 0)
      self.imgCreateContent = self:AddComponent(component, go)
      self.renderTexture = self.imgCreateContent:ReInit(inputParam, self.top_pic_img)
    end)
  end)
  for i, v in ipairs(self.share_btn_list) do
    local data = self.shareBtnData[i]
    if data then
      v.share_btn:SetActive(true)
      v.btn_icon:LoadSprite(data.icon)
      v.btn_txt:SetLocalText(data.txtKey)
    else
      v.share_btn:SetActive(false)
    end
  end
end

function LWUIChatCommonShareView:OnShareBtnClick(index)
  if self.targetTemplate == nil then
    return
  end
  if self.waitShareMsgBack == true then
    return
  end
  local data = self.shareBtnData[index]
  if data == nil then
    return
  end
  local shareType = data.type
  if shareType == ChatCommonShareMethodType.Download then
    self:OnShareByDownload()
  elseif shareType == ChatCommonShareMethodType.Chat then
    if CoppaUtil.IsCoppaLimitWithTips() then
      return
    end
    self:OnShareByChat()
  elseif shareType == ChatCommonShareMethodType.FriendCircle then
    if CoppaUtil.IsCoppaLimitWithTips() then
      return
    end
    self:OnShareByFriendCircle()
  end
end

function LWUIChatCommonShareView:TrySavePic()
  if self.renderTexture == nil then
    return
  end
  local isNeedCreatePic = false
  if self.savePicCompletePath == nil then
    isNeedCreatePic = true
    self.savePicPath = UIUtil.GetUICapturePath()
    self.savePicName = UIUtil.GetPicUniqueName()
  elseif self.savePicUploadPicVer == nil and self.savePicUploadServerMsg == nil then
    isNeedCreatePic = true
  end
  if isNeedCreatePic == false then
    return
  end
  self.savePicCompletePath = self.savePicPath .. "/" .. self.savePicName .. "_big.jpg"
  self.saveSmallPicCompletePath = self.savePicPath .. "/" .. self.savePicName .. ".jpg"
  self.savePicDownloadPath = self.savePicPath .. "/" .. self.savePicName .. "_download.jpg"
  local renderTextureSmall = self.imgCreateContent:CameraRenderTestureSmall()
  CS.UploadImageManager.Instance:SaveRenderTextureToFolder(renderTextureSmall, self.saveSmallPicCompletePath)
  CS.UploadImageManager.Instance:SaveRenderTextureToFolder(self.renderTexture, self.savePicCompletePath)
  CS.UploadImageManager.Instance:SaveRenderTextureToFolder(self.renderTexture, self.savePicDownloadPath)
  self.savePicWidth = self.renderTexture.width
  self.savePicHeight = self.renderTexture.height
  self.waitingPicUploadPicVer = true
end

function LWUIChatCommonShareView:OnShareByDownload()
  self:TrySavePic()
  if self.savePicCompletePath == nil then
    return
  end
  if CS.SDKManager.IS_UNITY_EDITOR() or Config.IsPC() then
    CS.UploadImageManager.Instance:SelectFolderSavePhotoByPath_WinAndEditor(self.savePicDownloadPath)
  else
    CS.SDKManager.SaveRTToAlbum(self.renderTexture)
  end
end

function LWUIChatCommonShareView:OnShareByChat()
  self:TrySavePic()
  local inAlliance = ChatInterface.isInAlliance()
  if not inAlliance then
    UIUtil.ShowTipsId(900531)
    return
  end
  local isOpen = ChatManager2:GetInstance():IsActivePhotoAlbum()
  if not isOpen then
    local limitLevel = LuaEntry.DataConfig:TryGetNum("alliance_pic_send_config", "k1")
    UIUtil.ShowTips(Localization:GetString("alliance_album_lock_notice", limitLevel))
    return
  end
  local share_param = {}
  share_param.postType = PostType.Chat_SendPhoto
  share_param.post = PostType.Chat_SendPhoto
  if self.savePicUploadServerMsg == nil then
    share_param.filePath = self.saveSmallPicCompletePath
    share_param.bigWidth = self.savePicWidth
    share_param.bigHeight = self.savePicHeight
  else
    local uploadPicVer = self.savePicUploadPicVer
    local serverMsg = self.savePicUploadServerMsg
    share_param.msg = "<lwPhoto:" .. uploadPicVer .. ":>"
    share_param.picVer = uploadPicVer
    share_param.smallHeight = serverMsg.height
    share_param.smallWidth = serverMsg.width
    share_param.bigHeight = serverMsg.heightBig
    share_param.bigWidth = serverMsg.widthBig
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, share_param)
end

function LWUIChatCommonShareView:OnShareByFriendCircle()
  self:TrySavePic()
  local targetRoomId
  local playerUid = LuaEntry.Player.uid
  targetRoomId = ChatManager2:GetInstance().Room:GetFriendsCircleRoomId(playerUid)
  if targetRoomId == nil then
    return
  end
  local inputParam = {
    picUrlPathSmall = self.saveSmallPicCompletePath,
    picUrlPath = self.savePicCompletePath,
    picWidth = self.savePicWidth,
    picHeight = self.savePicHeight,
    uploadPicVer = self.savePicUploadPicVer,
    serverMsg = self.savePicUploadServerMsg
  }
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPostCircleFriend, {anim = true}, targetRoomId, inputParam)
end

function LWUIChatCommonShareView:OnChatPhotoSend(cmdTbl)
  if cmdTbl and cmdTbl.roomId then
    local roomId = cmdTbl.roomId
    local roomData = ChatManager2:GetInstance().Room:GetRoomData(roomId)
    if roomData then
      if roomData:isAllianceRoom() then
        UIUtil.ShowTipsId("image_share_success")
      elseif roomData.group == ChatGroupType.GROUP_FRIENDS_CIRCLE_ROOM then
        UIUtil.ShowTipsId("image_post_success")
      end
    end
  end
  self.waitShareMsgBack = false
end

function LWUIChatCommonShareView:OnSelfUploadImgSuccess(inputTbl)
  if self.waitingPicUploadPicVer == true and self.savePicUploadPicVer == nil and self.savePicUploadServerMsg == nil and inputTbl and #inputTbl == 2 then
    self.savePicUploadPicVer = inputTbl[1]
    self.savePicUploadServerMsg = inputTbl[2]
  end
end

return LWUIChatCommonShareView
