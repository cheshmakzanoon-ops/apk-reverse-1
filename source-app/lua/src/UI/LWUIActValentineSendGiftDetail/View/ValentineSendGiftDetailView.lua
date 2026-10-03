local ValentineSendGiftDetailView = BaseClass("ValentineSendGiftDetailView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local PhotoItem = require("UI.LWUIActValentineSendGiftDetail.Component.ValentineDetailPhotoItemComponent")
local panel_path = "panel"
local close_btn_path = "Root/CloseBtn"
local like_num_text_path = "Root/PhotoContent/LikeArea/LikeNumText"
local tex_num_text_path = "Root/PhotoContent/TexNumInfo/TexNumText"
local gender_img_path = "Root/PhotoContent/NameArea/GenderImg"
local nick_name_text_path = "Root/PhotoContent/NameArea/NickNameText"
local prev_btn_path = "Root/PhotoContent/PrevBtn"
local next_btn_path = "Root/PhotoContent/NextBtn"
local like_btn_path = "Root/BtnArea/LikeBtn"
local send_gift_btn_path = "Root/BtnArea/SendGiftBtn"
local chat_btn_path = "Root/BtnArea/ChatBtn"
local cur_photo_item_path = "Root/PhotoContent/CurPhotoItem"
local next_photo_item_path = "Root/PhotoContent/NextPhotoItem"
local prev_photo_item_path = "Root/PhotoContent/PrevPhotoItem"
local scroll_view_content1_path = "Root/PhotoContent/PhotoItemRoot/ScrollView1/Viewport/ScrollViewContent1"
local scroll_view_content2_path = "Root/PhotoContent/PhotoItemRoot/ScrollView2/Viewport/ScrollViewContent2"
local scroll_view_content3_path = "Root/PhotoContent/PhotoItemRoot/ScrollView3/Viewport/ScrollViewContent3"
local scroll_view3_path = "Root/PhotoContent/PhotoItemRoot/ScrollView3"
local photo_content_path = "Root/PhotoContent"
local player_head_path = "Root/PhotoContent/NameArea/HeadContent/UIPlayerHead"
local follow_eff_node_path = "Root/BtnArea/FollowBtn/followEffNode"
local GENDER_IMAGE_FOLDER = "Assets/Main/Sprites/UI/UILWPlayerInfo/"
local likeEffectPath = "Assets/Main/Prefabs/UI/ActivityCenter/Valentine/Eff_ui_Valentine2026_like_Variant.prefab"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.param = self:GetUserData()
  self:ReInit()
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
  self.panelCloseBtn = self:AddComponent(UIButton, panel_path)
  self.panelCloseBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closeBtn = self:AddComponent(UIButton, close_btn_path)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.likeNumText = self:AddComponent(UIText, like_num_text_path)
  self.texNumText = self:AddComponent(UIText, tex_num_text_path)
  self.genderImg = self:AddComponent(UIImage, gender_img_path)
  self.nickNameText = self:AddComponent(UIText, nick_name_text_path)
  self.prevBtn = self:AddComponent(UIButton, prev_btn_path)
  self.prevBtn:SetOnClick(function()
    self:PrevBtnClick()
  end)
  self.nextBtn = self:AddComponent(UIButton, next_btn_path)
  self.nextBtn:SetOnClick(function()
    self:NextBtnClick()
  end)
  self.likeBtn = self:AddComponent(UIButton, like_btn_path)
  self.likeBtn:SetOnClick(function()
    self:LikeBtnClick()
  end)
  self.sendGiftBtn = self:AddComponent(UIButton, send_gift_btn_path)
  self.sendGiftBtn:SetOnClick(function()
    self:SendGiftBtnClick()
  end)
  self.chatBtn = self:AddComponent(UIButton, chat_btn_path)
  self.chatBtn:SetOnClick(function()
    self:ChatBtnClick()
  end)
  self.uiEventTrigger = self:AddComponent(UIEventTrigger, scroll_view3_path)
  self.uiEventTrigger:OnBeginDrag(function(eventData)
    self:OnStartDrag(eventData)
  end)
  self.uiEventTrigger:OnEndDrag(function(eventData)
    self:OnEndDrag(eventData)
  end)
  self.scrollContent1 = self:AddComponent(UIBaseContainer, scroll_view_content1_path)
  self.scrollContent2 = self:AddComponent(UIBaseContainer, scroll_view_content2_path)
  self.scrollContent3 = self:AddComponent(UIBaseContainer, scroll_view_content3_path)
  self.prevPhotoItem = self:AddComponent(PhotoItem, prev_photo_item_path)
  self.curPhotoItem = self:AddComponent(PhotoItem, cur_photo_item_path)
  self.nextPhotoItem = self:AddComponent(PhotoItem, next_photo_item_path)
  self.photoItemObj = self:AddComponent(UIBaseContainer, photo_content_path)
  self.simpleAni = self:AddComponent(UISimpleAnimation, "")
  self.playerHead = self:AddComponent(UICommonHead, player_head_path)
  self.followBtn = self:AddComponent(UIButton, "Root/BtnArea/FollowBtn")
  self.followBtn:SetOnClick(function()
    self:OnFollowBtnClick()
  end)
  self.followBtn:SetActive(false)
  self.headContentNode = self:AddComponent(UIBaseContainer, "Root/PhotoContent/NameArea/HeadContent")
  self.followEffNode = self:AddComponent(UIVfx, follow_eff_node_path, {
    lifeType = UIVfxLifeType.HideAfterOnce
  })
  self.followEffNode:SetActive(false)
end

local function ComponentDestroy(self)
  self.prevPhotoItem.transform:SetParent(self.photoItemObj.transform)
  self.curPhotoItem.transform:SetParent(self.photoItemObj.transform)
  self.nextPhotoItem.transform:SetParent(self.photoItemObj.transform)
  self.playerHead = nil
  self.followEffNode = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetPlayFriendsCirclePicData, self.OnGetPlayFriendsCirclePicData)
  self:AddUIListener(EventId.ValentineSendGiftListDataUpdate, self.OnSendGiftListDataUpdate)
  self:AddUIListener(EventId.GetNewUserInfoSucc, self.OnLikeDataUpdate)
  self:AddUIListener(EventId.ValentineFollowSuccess, self.OnRecFollowSuccess)
  self:AddUIListener(EventId.ValentineNpcRewardGet, self.OnValentineNpcRewardGet)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.GetPlayFriendsCirclePicData, self.OnGetPlayFriendsCirclePicData)
  self:RemoveUIListener(EventId.ValentineSendGiftListDataUpdate, self.OnSendGiftListDataUpdate)
  self:RemoveUIListener(EventId.GetNewUserInfoSucc, self.OnLikeDataUpdate)
  self:RemoveUIListener(EventId.ValentineFollowSuccess, self.OnRecFollowSuccess)
  self:RemoveUIListener(EventId.ValentineNpcRewardGet, self.OnValentineNpcRewardGet)
  base.OnRemoveListener(self)
end

function ValentineSendGiftDetailView:OnValentineNpcRewardGet(npcId)
  if not (self.data and self.data.npcId) or self.data.npcId ~= npcId then
    return
  end
  local npcData = DataCenter.ValentineDataManager:GetNpcData(npcId)
  if not npcData then
    return
  end
  UIGray.SetGray(self.likeBtn.transform, npcData:IsGetReward(ValentineNpcRewardGetType.Like), true)
  UIGray.SetGray(self.sendGiftBtn.transform, npcData:IsGetReward(ValentineNpcRewardGetType.Gift), true)
  UIGray.SetGray(self.followBtn.transform, npcData:IsGetReward(ValentineNpcRewardGetType.Follow), true)
end

function ValentineSendGiftDetailView:ReInit()
  self.index = self.param.index
  self.activityId = self.param.activityId
  self.scope = self.param.curSelectScope
  self.genderType = self.param.curSelectGender
  if self.param.customDataList and self.param.customDataList[self.index] then
    self.data = self.param.customDataList[self.index]
  else
    self.data = DataCenter.ValentineDataManager:GetTargetSendGiftPlayerData(self.activityId, self.scope, self.genderType, self.index)
  end
  self:ResetPhotoParent(self.prevPhotoItem, self.curPhotoItem, self.nextPhotoItem)
  self:RefreshUI()
  self.simpleAni:Play("Open")
  self.checkFlipTipTimer = 0
  local showFollowBtn = DataCenter.ValentineDataManager:GetIfOpenMatch()
  self.followBtn:SetActive(showFollowBtn)
end

function ValentineSendGiftDetailView:RefreshUI()
  self.curShowPhotoIndex = 1
  if not self.data and self.param.npcId and self.param.npcId > 0 then
    self.data = DataCenter.ValentineDataManager:GetNpcData(self.param.npcId)
    if self.data then
      self.index = self.data.rank
    end
  end
  if not self.data then
    return
  end
  if self.data.npcId and self.data.npcId > 0 then
    self:ShowNpcDisplay()
  else
    self:ShowPlayerDisplay()
  end
end

function ValentineSendGiftDetailView:ShowPlayerDisplay()
  self.chatBtn:SetActive(true)
  self.headContentNode:SetActive(true)
  self:RefreshBaseInfo()
  self:UpdatePhotoData()
  self:ShowPhotoInfo()
  local hasFollowed = self.data.isFollow == 1
  local canInteract = not hasFollowed
  UIGray.SetGray(self.followBtn.transform, hasFollowed, canInteract)
end

function ValentineSendGiftDetailView:ShowNpcDisplay()
  local npcId = self.data.npcId
  local npcData = DataCenter.ValentineDataManager:GetNpcData(npcId)
  if not npcData then
    return
  end
  self.nickNameText:SetLocalText(npcData.name)
  self:RefreshGender(npcData.gender)
  self.allPhotoData = {}
  if npcData.headIcons then
    for i, v in ipairs(npcData.headIcons) do
      local headData = {}
      headData.uid = npcData.npcId
      headData.type = SendGiftDetailPhotoType.NpcIcon
      headData.pic = v
      headData.picVer = 0
      table.insert(self.allPhotoData, headData)
    end
    self:ShowPhotoInfo()
    self.headTexNum = #npcData.headIcons
    self.friendsCircleNum = 0
    self:RefreshTexNumInfo()
  end
  self.chatBtn:SetActive(false)
  self.headContentNode:SetActive(false)
  self.likeNumText:SetText(npcData.hot or 0)
  UIGray.SetGray(self.likeBtn.transform, npcData:IsGetReward(ValentineNpcRewardGetType.Like), true)
  UIGray.SetGray(self.sendGiftBtn.transform, npcData:IsGetReward(ValentineNpcRewardGetType.Gift), true)
  UIGray.SetGray(self.followBtn.transform, npcData:IsGetReward(ValentineNpcRewardGetType.Follow), true)
end

function ValentineSendGiftDetailView:RefreshBaseInfo()
  if not self.data or not self.data.shareInfo then
    return
  end
  local shareInfo = self.data.shareInfo
  self.nickNameText:SetText(shareInfo.name)
  self:RefreshLikeInfo()
  local uid = self.data.playerUid
  local pic = self.data.shareInfo.pic
  local picVer = self.data.shareInfo.picVer or 0
  self.playerHead:SetData(uid, pic, picVer)
  self.playerHead:SetEnableClickShowInfo(true)
  self.headTexNum = 0
  if self.data.shareInfo.photoAlbum and not string.IsNullOrEmpty(self.data.shareInfo.photoAlbum) then
    local photoInfo = string.split(self.data.shareInfo.photoAlbum, ",")
    for _, v in ipairs(photoInfo) do
      if v ~= "0" then
        self.headTexNum = self.headTexNum + 1
      end
    end
  end
  local gender = self.data.shareInfo.gender
  self:RefreshGender(gender)
  self:RefreshTexNumInfo()
end

function ValentineSendGiftDetailView:RefreshGender(gender)
  if gender == 1 then
    self.genderImg:SetActive(true)
    self.genderImg:LoadSprite(GENDER_IMAGE_FOLDER .. "icon_pop_sex_male.png")
  elseif gender == 2 then
    self.genderImg:SetActive(true)
    self.genderImg:LoadSprite(GENDER_IMAGE_FOLDER .. "icon_pop_sex_female.png")
  else
    self.genderImg:SetActive(false)
  end
  self.genderImg:SetNativeSize()
end

function ValentineSendGiftDetailView:RefreshLikeInfo()
  if not self.data or not self.data.shareInfo then
    return
  end
  local thermalPower = self:CalculateHot()
  self.likeNumText:SetText(thermalPower)
end

function ValentineSendGiftDetailView:CalculateHot()
  local hotAdd = 0
  local cacheThumbsUpCount = self.data.shareInfo.thumbsUpCount
  local cachePlayerData = DataCenter.PlayerInfoDataManager:GetPlayerDataByUid(self.data.shareInfo.uid)
  if cachePlayerData then
    local newThumbsUpCount = cachePlayerData.thumbsUpCount
    if cacheThumbsUpCount < newThumbsUpCount then
      hotAdd = DataCenter.ValentineDataManager:GetHotAddByLikeDelta(self.activityId, cacheThumbsUpCount, newThumbsUpCount)
    end
  end
  local uid = self.data.shareInfo.uid
  local hotAddByGift = DataCenter.ValentineDataManager:GetOtherPlayerGiftHotAddCache(uid)
  hotAdd = hotAdd + hotAddByGift
  local hotAddByFollow = DataCenter.ValentineDataManager:GetPlayerFollowHotAdd(uid)
  hotAdd = hotAdd + hotAddByFollow
  local thermalPower = 0
  if self.data.thermalPower then
    thermalPower = self.data.thermalPower
  elseif self.data.shareInfo.thermalPower then
    thermalPower = self.data.shareInfo.thermalPower
  end
  thermalPower = thermalPower + hotAdd
  return thermalPower
end

function ValentineSendGiftDetailView:OnLikeDataUpdate()
  self:RefreshLikeInfo()
end

function ValentineSendGiftDetailView:RefreshTexNumInfo()
  local curIndex = self.curShowPhotoIndex
  local headTexCount = math.max(self.headTexNum, 1)
  local friendsTexCount = self.friendsCircleNum or 0
  local texTotalNum = headTexCount + friendsTexCount
  self.texNumText:SetText(string.format("%s/%s", curIndex, texTotalNum))
end

function ValentineSendGiftDetailView:PrevBtnClick(isPlayAni)
  local targetPhotoIndex = self.curShowPhotoIndex - 1
  self.checkFlipTipTimer = 0
  if targetPhotoIndex <= 0 then
    if 1 >= self.index then
      return
    end
    local targetData = self:GetPlayerDataByIndex(self.index - 1)
    if targetData then
      if isPlayAni then
        self:PlayToPrevPhotoAni()
      end
      self.index = self.index - 1
      self.data = targetData
      self:RefreshUI()
    end
    return
  end
  self.curShowPhotoIndex = targetPhotoIndex
  if isPlayAni then
    self:PlayToPrevPhotoAni()
  end
  self:RefreshTexNumInfo()
  self:ShowPhotoInfo()
end

function ValentineSendGiftDetailView:NextBtnClick(isPlayAni)
  local targetPhotoIndex = self.curShowPhotoIndex + 1
  self.checkFlipTipTimer = 0
  if targetPhotoIndex > #self.allPhotoData then
    local targetData = self:GetPlayerDataByIndex(self.index + 1)
    if targetData then
      if isPlayAni then
        self:PlayToNextPhotoAni()
      end
      self.index = self.index + 1
      self.data = targetData
      self:RefreshUI()
    end
    return
  end
  self.curShowPhotoIndex = targetPhotoIndex
  if isPlayAni then
    self:PlayToNextPhotoAni()
  end
  self:RefreshTexNumInfo()
  self:ShowPhotoInfo()
end

function ValentineSendGiftDetailView:GetPlayerDataByIndex(targetIndex)
  if self.param.customDataList then
    return self.param.customDataList[targetIndex]
  else
    return DataCenter.ValentineDataManager:GetTargetSendGiftPlayerData(self.activityId, self.scope, self.genderType, targetIndex)
  end
end

function ValentineSendGiftDetailView:LikeBtnClick()
  if self:TryShowNpcRewardCard(ValentineNpcRewardGetType.Like) then
    return
  end
  if not self.data.playerUid then
    return
  end
  local thePlayerUid = self.data.playerUid
  InteractiveUtil.TryThumbsUp(thePlayerUid, InteractiveUtil.ThumbsUpType.PlayerInfo, "PlayerDetailMain", function()
  end)
end

function ValentineSendGiftDetailView:SendGiftBtnClick()
  if self:TryShowNpcRewardCard(ValentineNpcRewardGetType.Gift) then
    return
  end
  if not self.data.playerUid or not self.data.shareInfo then
    return
  end
  DataCenter.GiftSystemManager:OpenOperationView({
    windowType = GiftSystemConst.WindowType.Send,
    targetUid = self.data.playerUid,
    targetServerId = self.data.shareInfo.server
  })
end

function ValentineSendGiftDetailView:OnFollowBtnClick()
  if self:TryShowNpcRewardCard(ValentineNpcRewardGetType.Follow) then
    return
  end
  if not self.data.playerUid then
    return
  end
  if not self.activityId then
    return
  end
  local param = {
    activityId = tonumber(self.activityId),
    otherUid = self.data.playerUid
  }
  SFSNetwork.SendMessage(MsgDefines.ValentineFollow, param)
end

function ValentineSendGiftDetailView:ChatBtnClick()
  self.ctrl:CloseSelf()
  local userInfo = {}
  userInfo.uid = self.data.playerUid
  userInfo.userName = self.data.shareInfo.name
  GoToUtil.OpenChatView(false, {anim = false}, {privateUserInfo = userInfo})
end

function ValentineSendGiftDetailView:UpdatePhotoData()
  self.allPhotoData = {}
  self:GetHeadIconData()
  self:GetFriendPhotoData()
end

function ValentineSendGiftDetailView:GetHeadIconData()
  if self.data.shareInfo.photoAlbum and not string.IsNullOrEmpty(self.data.shareInfo.photoAlbum) then
    local photoInfo = string.split(self.data.shareInfo.photoAlbum, ",")
    for _, v in ipairs(photoInfo) do
      if v ~= "0" then
        local headData = {}
        headData.uid = self.data.playerUid
        headData.type = SendGiftDetailPhotoType.HeadIcon
        headData.pic = self.data.shareInfo.pic
        headData.picVer = v
        table.insert(self.allPhotoData, headData)
      end
    end
  end
  if #self.allPhotoData <= 0 then
    local headData = {}
    headData.uid = self.data.playerUid
    headData.type = SendGiftDetailPhotoType.HeadIcon
    headData.pic = self.data.shareInfo.pic or ""
    headData.picVer = self.data.shareInfo.picVer or 0
    table.insert(self.allPhotoData, headData)
  end
end

function ValentineSendGiftDetailView:GetFriendPhotoData()
  ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.GetFriendsCirclePic, self.data.playerUid)
end

function ValentineSendGiftDetailView:OnGetPlayFriendsCirclePicData(param)
  if not param or param.uid ~= self.data.playerUid or not param.picInfo then
    return
  end
  for k, v in pairs(self.allPhotoData) do
    if v.type == SendGiftDetailPhotoType.FriendCircle then
      self.allPhotoData[k] = nil
    end
  end
  for _, v in pairs(param.picInfo) do
    local circlePhotoData = {}
    circlePhotoData.uid = self.data.playerUid
    circlePhotoData.type = SendGiftDetailPhotoType.FriendCircle
    circlePhotoData.picVer = v or ""
    table.insert(self.allPhotoData, circlePhotoData)
  end
  self.friendsCircleNum = #param.picInfo
  self:RefreshTexNumInfo()
end

function ValentineSendGiftDetailView:ShowPhotoInfo()
  local curPhotoData = self.allPhotoData[self.curShowPhotoIndex]
  if curPhotoData then
    self.curPhotoItem:SetData(curPhotoData)
  end
  local nextPhotoData = self.allPhotoData[self.curShowPhotoIndex + 1]
  if nextPhotoData then
    self.nextPhotoItem:SetData(nextPhotoData)
  else
    self.nextPhotoItem:SetEmptyState()
  end
end

function ValentineSendGiftDetailView:OnSendGiftListDataUpdate(dataList)
  self.data = DataCenter.ValentineDataManager:GetTargetSendGiftPlayerData(self.activityId, self.scope, self.genderType, self.index)
  self:RefreshUI()
end

function ValentineSendGiftDetailView:OnStartDrag(eventData)
  if not self.transform then
    return
  end
  self.startDragPos = eventData.position
  self.checkFlipTipTimer = 0
end

function ValentineSendGiftDetailView:OnEndDrag(eventData)
  if not (self.transform and self.startDragPos and self.holder) or self.photoAniTimer then
    return
  end
  self.checkFlipTipTimer = 0
  local endPos = eventData.position
  if endPos.x - self.startDragPos.x > 20 and not self:IsFirstPhoto() then
    self:PrevBtnClick(true)
  elseif self.startDragPos.x - endPos.x > 20 then
    self:NextBtnClick(true)
  end
  self.startDragPos = nil
end

function ValentineSendGiftDetailView:IsFirstPhoto()
  if not self.curShowPhotoIndex or not self.index then
    return false
  end
  return self.curShowPhotoIndex <= 1 and self.index <= 1
end

function ValentineSendGiftDetailView:PlayToNextPhotoAni()
  local curScrollContentPos = self.scrollContent3.transform.position
  local targetCur = self.nextPhotoItem
  local targetPrev = self.curPhotoItem
  local targetNext = self.prevPhotoItem
  self:ResetPhotoParent(targetPrev, targetCur, targetNext)
  self.scrollContent1.transform.position = curScrollContentPos
  local content1LocalPos = self.scrollContent1.transform.localPosition
  self.scrollContent3.transform.localPosition = Vector3.Normalize(content1LocalPos) * -10
  self.curPhotoItem = targetCur
  self.prevPhotoItem = targetPrev
  self.nextPhotoItem = targetNext
end

function ValentineSendGiftDetailView:PlayToPrevPhotoAni()
  local curScrollContentPos = self.scrollContent3.transform.position
  local targetCur = self.prevPhotoItem
  local targetPrev = self.nextPhotoItem
  local targetNext = self.curPhotoItem
  self:ResetPhotoParent(targetPrev, targetCur, targetNext)
  self.scrollContent2.transform.position = curScrollContentPos
  local content2LocalPos = self.scrollContent2.transform.localPosition
  self.scrollContent3.transform.localPosition = Vector3.Normalize(content2LocalPos) * -10
  self.curPhotoItem = targetCur
  self.prevPhotoItem = targetPrev
  self.nextPhotoItem = targetNext
end

function ValentineSendGiftDetailView:ResetPhotoParent(prevItem, curItem, nextItem)
  prevItem.transform:SetParent(self.scrollContent1.transform)
  prevItem.transform:Set_localPosition(0, 0, 0)
  prevItem.transform:Set_localRotation(0, 0, 0, 1)
  prevItem.transform.localScale = Vector3.one
  curItem.transform:SetParent(self.scrollContent3.transform)
  curItem.transform:Set_localPosition(0, 0, 0)
  curItem.transform:Set_localRotation(0, 0, 0, 1)
  curItem.transform.localScale = Vector3.one
  nextItem.transform:SetParent(self.scrollContent2.transform)
  nextItem.transform:Set_localPosition(0, 0, 0)
  nextItem.transform:Set_localRotation(0, 0, 0, 1)
  nextItem.transform.localScale = Vector3.one
end

function ValentineSendGiftDetailView:Update1000MS()
  self.checkFlipTipTimer = self.checkFlipTipTimer + 1
  if self.checkFlipTipTimer >= 10 and self.simpleAni then
    if self.simpleAni:IsPlaying("TipAni") then
      self.simpleAni:Rewind("TipAni")
    else
      self.simpleAni:Play("TipAni")
    end
    self.checkFlipTipTimer = 0
  end
end

function ValentineSendGiftDetailView:TryShowNpcRewardCard(rewardGetType)
  if self.data.npcId and self.data.npcId > 0 then
    local npcId = self.data.npcId
    local npcData = DataCenter.ValentineDataManager:GetNpcData(npcId)
    if not npcData then
      return false
    end
    if npcData:IsGetReward(rewardGetType) then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIValentineNpcRewardCard, {anim = true}, npcData, rewardGetType, nil, false)
    else
      DataCenter.ValentineDataManager:ReqGetNpcReward(self.activityId, rewardGetType, self.data.npcId)
    end
    return true
  end
  return false
end

function ValentineSendGiftDetailView:OnRecFollowSuccess(otherUid)
  if not self.data or not self.data.playerUid then
    return
  end
  if otherUid == self.data.playerUid then
    self.data.isFollow = 1
    UIGray.SetGray(self.followBtn.transform, true, false)
    self.followEffNode:SetActive(true)
    self.followEffNode:Play(likeEffectPath)
  end
end

ValentineSendGiftDetailView.OnCreate = OnCreate
ValentineSendGiftDetailView.OnDestroy = OnDestroy
ValentineSendGiftDetailView.OnEnable = OnEnable
ValentineSendGiftDetailView.OnDisable = OnDisable
ValentineSendGiftDetailView.ComponentDefine = ComponentDefine
ValentineSendGiftDetailView.ComponentDestroy = ComponentDestroy
ValentineSendGiftDetailView.DataDefine = DataDefine
ValentineSendGiftDetailView.DataDestroy = DataDestroy
ValentineSendGiftDetailView.OnAddListener = OnAddListener
ValentineSendGiftDetailView.OnRemoveListener = OnRemoveListener
return ValentineSendGiftDetailView
