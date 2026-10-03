local SendGiftListItemComponent = BaseClass("SendGiftListItemComponent", UIBaseContainer)
local UIGray = CS.UIGray
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local head_icon_path = "Root/HeadMask/HeadIcon"
local like_num_text_path = "Root/LikeInfo/LikeArea/LikeNumText"
local tex_num_text_path = "Root/LikeInfo/TexNumInfo/TexNumText"
local gender_img_path = "Root/NameArea/GenderImg"
local nick_name_text_path = "Root/NameArea/NickNameText"
local like_btn_path = "Root/BtnArea/LikeBtn"
local send_gift_btn_path = "Root/BtnArea/SendGiftBtn"
local click_btn_path = "Root/ClickBtn"
local btn_bg_path = "Root/BtnArea/BG"
local follow_btn_path = "Root/BtnArea/FollowBtn"
local follow_eff_node_path = "Root/BtnArea/FollowBtn/FollowEffNode"
local likeEffectPath = "Assets/Main/Prefabs/UI/ActivityCenter/Valentine/Eff_ui_Valentine2026_like_Variant.prefab"
local GENDER_IMAGE_FOLDER = "Assets/Main/Sprites/UI/UILWPlayerInfo/"
local VFX_MOVE_TIME = 0.6

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
  self.icon = self:AddComponent(UIPlayerHead, head_icon_path)
  self.likeNumText = self:AddComponent(UIText, like_num_text_path)
  self.texNumText = self:AddComponent(UIText, tex_num_text_path)
  self.genderImg = self:AddComponent(UIImage, gender_img_path)
  self.nickNameText = self:AddComponent(UIText, nick_name_text_path)
  self.likeBtn = self:AddComponent(UIButton, like_btn_path)
  self.likeBtn:SetOnClick(function()
    self:LikeBtnClick()
  end)
  self.sendGiftBtn = self:AddComponent(UIButton, send_gift_btn_path)
  self.sendGiftBtn:SetOnClick(function()
    self:SendGiftBtnClick()
  end)
  self.icon:SetCustomLoadCallback(function()
  end)
  self.clickBtn = self:AddComponent(UIButton, click_btn_path)
  self.clickBtn:SetOnClick(function()
    self:ShowDetailPanel()
  end)
  self.btnBg = self:AddComponent(UIImage, btn_bg_path)
  self.followBtn = self:AddComponent(UIButton, follow_btn_path)
  self.followBtn:SetOnClick(function()
    self:ClickFollowBtn()
  end)
  self.specialFlag = self:AddComponent(UIBaseContainer, "Root/specialFlag")
  self.specialFlagText = self:AddComponent(UITextMeshProUGUIEx, "Root/specialFlag/specialFlagText")
  self.bilingVfxNode = self:AddComponent(UIVfx, "Root/bilingVfxNode")
  self.flyVfxNode = self:AddComponent(UIVfx, "Root/flyVfxNode")
  self.root = self:AddComponent(UIBaseContainer, "Root")
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.callback = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.ValentineFollowSuccess, self.OnRecFollowSuccess)
  self:AddUIListener(EventId.ValentineNpcRewardGet, self.OnValentineNpcRewardGet)
  self:AddUIListener(EventId.ValentineNpcRewardGetUIClose, self.OnRewardGetUIClose)
  self:AddUIListener(EventId.ValentineNpcGetRewardWeekFinger, self.OnWeekFinger)
  self:AddUIListener(EventId.OnSendUserGiftMsgBack, self.OnSendGift)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.ValentineFollowSuccess, self.OnRecFollowSuccess)
  self:RemoveUIListener(EventId.ValentineNpcRewardGet, self.OnValentineNpcRewardGet)
  self:RemoveUIListener(EventId.ValentineNpcRewardGetUIClose, self.OnRewardGetUIClose)
  self:RemoveUIListener(EventId.ValentineNpcGetRewardWeekFinger, self.OnWeekFinger)
  self:RemoveUIListener(EventId.OnSendUserGiftMsgBack, self.OnSendGift)
  base.OnRemoveListener(self)
end

function SendGiftListItemComponent:OnSendGift()
  if not self.data or self.data.npcId and self.data.npcId > 0 then
    return
  end
  local thermalPower = self:CalculateHot()
  self.likeNumText:SetText(string.GetFormattedStr(thermalPower))
end

function SendGiftListItemComponent:OnWeekFinger(rank)
  if not (self.data and rank and self.data.npcId) or self.data.rank ~= rank then
    return
  end
  local npcId = self.data.npcId
  local npcData = DataCenter.ValentineDataManager:GetNpcData(npcId)
  if not npcData or npcData:IsComplete() then
    return
  end
  local target
  if npcData.like == 0 then
    target = self.likeBtn
  elseif npcData.gift == 0 then
    target = self.sendGiftBtn
  elseif npcData.follow == 0 then
    target = self.followBtn
  end
  if not target then
    return
  end
  local param = {}
  param.position = target.transform.position
  local halfWidth = target.rectTransform.rect.width * 0.5
  local halfHeight = target.rectTransform.rect.height * 0.5
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  param.position.x = param.position.x + scaleFactor * halfWidth
  param.position.y = param.position.y - scaleFactor * halfHeight
  param.positionType = PositionType.Screen
  param.isPanel = true
  param.isAutoClose = 2
  DataCenter.ArrowManager:ShowFingerArrow(param)
end

function SendGiftListItemComponent:OnRewardGetUIClose(npcId)
  if not self.data then
    return
  end
  local npcData = DataCenter.ValentineDataManager:GetNpcData(npcId)
  if not npcData then
    return
  end
  if npcData.npcId ~= self.data.npcId or not npcData:IsComplete() then
    return
  end
  local mainUI = UIManager:GetInstance():GetWindow(UIWindowNames.ValentineSendGiftList)
  if not mainUI or not mainUI.View then
    return
  end
  mainUI.View:PlayIconFlyAni(npcId, self.root.transform, function()
    self.bilingVfxNode:PlayByOnce(VfxAssets.ValentineNpcRewardCompleteBiling)
  end)
end

function SendGiftListItemComponent:ClearRewardGetVfx()
  if self.flyReq then
    self.flyReq:Destroy()
    self.flyReq = nil
  end
  if self.delayFlyTimer then
    self.delayFlyTimer:Stop()
    self.delayFlyTimer = nil
  end
end

function SendGiftListItemComponent:OnValentineNpcRewardGet(npcId)
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

function SendGiftListItemComponent:SetNpcData(data)
  self.data = data
  if not self.data then
    return
  end
  if self.data.npcId and self.data.npcId > 0 then
    self:ShowNpcDisplay()
  end
end

function SendGiftListItemComponent:SetData(param)
  self.specialFlag:SetActive(false)
  self.param = param
  self.index = param.index
  self.activityId = param.activityId
  self.scope = param.curSelectScope
  self.genderType = param.curSelectGender
  self.isShowRankBg = param.isShowRankBg
  if param.npcId and param.npcId > 0 then
    self.data = DataCenter.ValentineDataManager:GetNpcData(param.npcId)
    self:ShowNpcDisplay()
    return
  end
  if param.customDataList and param.customDataList[self.index] then
    self.data = param.customDataList[self.index]
  else
    self.data = DataCenter.ValentineDataManager:GetTargetSendGiftPlayerData(self.activityId, self.scope, self.genderType, self.index)
  end
  if not self.data then
    return
  end
  if self.data.npcId and 0 < self.data.npcId then
    self:ShowNpcDisplay()
    return
  end
  if not self.data.shareInfo then
    return
  end
  local shareInfo = self.data.shareInfo
  self.nickNameText:SetText(shareInfo.name)
  local thermalPower = self:CalculateHot()
  self.likeNumText:SetText(string.GetFormattedStr(thermalPower))
  local uid = self.data.playerUid
  local pic = self.data.shareInfo.pic
  local picVer = self.data.shareInfo.picVer or self.data.shareInfo.picver
  self.icon:SetBigData(uid, pic or "", picVer or 0, true)
  local texNum = 0
  if self.data.shareInfo.photoAlbum and not string.IsNullOrEmpty(self.data.shareInfo.photoAlbum) then
    local photoInfo = string.split(self.data.shareInfo.photoAlbum, ",")
    for _, v in ipairs(photoInfo) do
      if v ~= "0" then
        texNum = texNum + 1
      end
    end
  end
  self.texNumText:SetText(texNum)
  local gender = self.data.shareInfo.gender
  self:RefreshGender(gender)
  self.btnBg:SetActive(self.isShowRankBg and self.index and self.index <= 4)
  self:CheckFollowBtnIfOpen()
end

function SendGiftListItemComponent:CalculateHot()
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

function SendGiftListItemComponent:CheckFollowBtnIfOpen()
  local ifShowFollowBtn = DataCenter.ValentineDataManager:GetIfOpenMatch()
  self.followBtn:SetActive(ifShowFollowBtn)
  if ifShowFollowBtn then
    local hasFollowed = self.data.isFollow == 1 or self.data.shareInfo and self.data.shareInfo.isFollow == 1
    local canInteract = not hasFollowed
    UIGray.SetGray(self.followBtn.transform, hasFollowed, canInteract)
  end
end

function SendGiftListItemComponent:RefreshGender(gender)
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

function SendGiftListItemComponent:ShowNpcDisplay()
  local npcId = self.data.npcId
  local npcData = DataCenter.ValentineDataManager:GetNpcData(npcId)
  if not npcData then
    return
  end
  local headIconPath = ""
  local texNum = 0
  if npcData.headIcons and 0 < #npcData.headIcons then
    headIconPath = npcData.headIcons[1]
    texNum = #npcData.headIcons
  end
  self.specialFlag:SetActive(true)
  self.icon:UseSpecifiedRes(headIconPath)
  self.nickNameText:SetLocalText(npcData.name)
  self:RefreshGender(npcData.gender)
  self.likeNumText:SetText(string.GetFormattedStr(npcData.hot))
  self.btnBg:SetActive(false)
  self.texNumText:SetText(texNum)
  UIGray.SetGray(self.likeBtn.transform, npcData:IsGetReward(ValentineNpcRewardGetType.Like), true)
  UIGray.SetGray(self.sendGiftBtn.transform, npcData:IsGetReward(ValentineNpcRewardGetType.Gift), true)
  local ifShowFollowBtn = DataCenter.ValentineDataManager:GetIfOpenMatch()
  self.followBtn:SetActive(ifShowFollowBtn)
  if ifShowFollowBtn then
    UIGray.SetGray(self.followBtn.transform, npcData:IsGetReward(ValentineNpcRewardGetType.Follow), true)
  end
end

function SendGiftListItemComponent:ShowDetailPanel()
  if self.callback then
    self.callback()
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.ValentineSendGiftDetail, {anim = true}, self.param)
end

function SendGiftListItemComponent:SetCustomClick(handler)
  self.callback = handler
end

function SendGiftListItemComponent:LikeBtnClick()
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

function SendGiftListItemComponent:TryShowNpcRewardCard(rewardGetType)
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

function SendGiftListItemComponent:SendGiftBtnClick()
  if self:TryShowNpcRewardCard(ValentineNpcRewardGetType.Gift) then
    return
  end
  if not self.data.playerUid or not self.data.shareInfo then
    return
  end
  local isFastSend = false
  local fastItemId = DataCenter.ValentineDataManager:GetSendFastItemId(self.activityId)
  if 0 < fastItemId then
    local curNum = DataCenter.GiftSystemManager:GetGiftNum(fastItemId)
    if 0 < curNum then
      DataCenter.GiftSystemManager:SendGift(fastItemId, self.data.playerUid, false, "", 1)
      isFastSend = true
    end
  end
  if not isFastSend then
    DataCenter.GiftSystemManager:OpenOperationView({
      windowType = GiftSystemConst.WindowType.Send,
      targetUid = self.data.playerUid,
      targetServerId = self.data.shareInfo.server
    })
  end
end

function SendGiftListItemComponent:ClickFollowBtn()
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

function SendGiftListItemComponent:OnRecFollowSuccess(otherUid)
  if not self.data or not self.data.playerUid then
    return
  end
  if otherUid == self.data.playerUid then
    self.data.isFollow = 1
    UIGray.SetGray(self.followBtn.transform, true, false)
    local btnPos = self.followBtn.transform.position
    local pos = {
      x = btnPos.x,
      y = btnPos.y,
      z = btnPos.z
    }
    EventManager:GetInstance():Broadcast(EventId.ValentinePlayFollowEffect, pos)
    local thermalPower = self:CalculateHot()
    self.likeNumText:SetText(string.GetFormattedStr(thermalPower))
  end
end

SendGiftListItemComponent.OnCreate = OnCreate
SendGiftListItemComponent.OnDestroy = OnDestroy
SendGiftListItemComponent.OnEnable = OnEnable
SendGiftListItemComponent.OnDisable = OnDisable
SendGiftListItemComponent.ComponentDefine = ComponentDefine
SendGiftListItemComponent.ComponentDestroy = ComponentDestroy
SendGiftListItemComponent.DataDefine = DataDefine
SendGiftListItemComponent.DataDestroy = DataDestroy
SendGiftListItemComponent.OnAddListener = OnAddListener
SendGiftListItemComponent.OnRemoveListener = OnRemoveListener
return SendGiftListItemComponent
