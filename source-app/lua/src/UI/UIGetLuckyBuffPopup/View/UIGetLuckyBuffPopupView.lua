local UIGetLuckyBuffPopupView = BaseClass("UIGetLuckyBuffPopupView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local GET_LUCKY_TYPE = {LUCKY_BUFF = 1, LUCKY_REWARD = 2}
local BG_IMG_PATH = "Assets/Main/TextureEx/UIGetLucky/zxl_qingrenjie_zhanshi_bg1800.png"

function UIGetLuckyBuffPopupView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitPopup()
end

function UIGetLuckyBuffPopupView:OnDestroy()
  if not table.IsNullOrEmpty(self.curRewardItemList) then
    for _, v in pairs(self.curRewardItemList) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  if self.curGetLuckyType == GET_LUCKY_TYPE.LUCKY_BUFF then
    local redPacketData = self:GetUserData().redPacket
    if not table.IsNullOrEmpty(redPacketData) then
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIRedPacketDetails, {anim = true}, self:GetUserData().redPacket)
    end
  end
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIGetLuckyBuffPopupView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnMask = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnMask:SetOnClick(function()
    self:OnBtnMaskClick()
  end)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.compGetLuckyGroup = self.viewSkin:AddComponent(self, UIBaseComponent, 3)
  self.compGetRewardGroup = self.viewSkin:AddComponent(self, UIBaseComponent, 4)
  self.textBuffTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.compSendPlayerIcon = self.viewSkin:AddComponent(self, UICommonHead, 6)
  self.compReceivePlayIcon = self.viewSkin:AddComponent(self, UICommonHead, 7)
  self.scrollRectRewardList = self.viewSkin:AddComponent(self, UIScrollRect, 8)
  self.textGift = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.compGivePlayerIcon = self.viewSkin:AddComponent(self, UICommonHead, 10)
  self.btnLike = self.viewSkin:AddComponent(self, UIButton, 11)
  self.btnLike:SetOnClick(function()
    self:OnBtnLikeClick()
  end)
  self.imgGetLuckyIcon = self.viewSkin:AddComponent(self, UIImage, 12)
  self.imgRewardLuckyIcon = self.viewSkin:AddComponent(self, UIImage, 13)
  self.compRewardContent = self.viewSkin:AddComponent(self, UIBaseContainer, 14)
  self.rawImgBG = self.viewSkin:AddComponent(self, UIRawImage, 15)
end

function UIGetLuckyBuffPopupView:ComponentDestroy()
  self.viewSkin = nil
  self.btnMask = nil
  self.textTitle = nil
  self.compGetLuckyGroup = nil
  self.compGetRewardGroup = nil
  self.textBuffTip = nil
  self.compSendPlayerIcon = nil
  self.compReceivePlayIcon = nil
  self.scrollRectRewardList = nil
  self.textGift = nil
  self.compGivePlayerIcon = nil
  self.btnLike = nil
  self.imgGetLuckyIcon = nil
  self.imgRewardLuckyIcon = nil
  self.compRewardContent = nil
  self.rawImgBG = nil
  self.textSenderName = nil
  self.textReceiverName = nil
  self.textGiverName = nil
end

function UIGetLuckyBuffPopupView:DataDefine()
  self.initParam = {}
  self.curGetLuckyType = 0
  self.curRedPacketData = {}
  self.curTreasureData = {}
  self.curRewardItemList = {}
end

function UIGetLuckyBuffPopupView:DataDestroy()
  self.initParam = nil
  self.curGetLuckyType = nil
  self.curRedPacketData = nil
  self.curTreasureData = nil
  self.curRewardItemList = nil
end

function UIGetLuckyBuffPopupView:OnAddListener()
  base.OnAddListener(self)
end

function UIGetLuckyBuffPopupView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIGetLuckyBuffPopupView:OnBtnMaskClick()
  self.ctrl:CloseSelf()
end

function UIGetLuckyBuffPopupView:OnBtnLikeClick()
  if self.curGetLuckyType ~= GET_LUCKY_TYPE.LUCKY_REWARD then
    return
  end
  local sendUserData = self.curTreasureData.luckSiphonbuffSenderInfo
  InteractiveUtil.TryThumbsUp(sendUserData.uid, InteractiveUtil.ThumbsUpType.AllianceLuckSiphonBuff, "LuckyBuffTrigger", function()
    UIUtil.ShowTipsId("activity_sports_uitips_021")
  end)
end

function UIGetLuckyBuffPopupView:InitPopup()
  self.initParam = self:GetUserData() or {}
  self.curGetLuckyType = self.initParam.type or 0
  if self.curGetLuckyType == nil or not table.hasvalue(GET_LUCKY_TYPE, self.curGetLuckyType) then
    self.ctrl:CloseSelf()
    return
  end
  self.rawImgBG:LoadSpriteAuto(BG_IMG_PATH)
  self.compGetLuckyGroup.gameObject:SetActive(self.curGetLuckyType == GET_LUCKY_TYPE.LUCKY_BUFF)
  self.compGetRewardGroup.gameObject:SetActive(self.curGetLuckyType == GET_LUCKY_TYPE.LUCKY_REWARD)
  if self.curGetLuckyType == GET_LUCKY_TYPE.LUCKY_BUFF then
    self.textTitle:SetLocalText("luckyBuff_title_getBuff")
    self.textSenderName = self.compSendPlayerIcon:AddComponent(UITextMeshProUGUIEx, "PlayerNameText")
    self.textReceiverName = self.compReceivePlayIcon:AddComponent(UITextMeshProUGUIEx, "PlayerNameText")
    self:RefreshGetLuckyContent()
  elseif self.curGetLuckyType == GET_LUCKY_TYPE.LUCKY_REWARD then
    self.textTitle:SetLocalText("luckyBuff_title_getReward")
    self.textGiverName = self.compGivePlayerIcon:AddComponent(UITextMeshProUGUIEx, "PlayerNameText")
    self:RefreshGetRewardContent()
  end
end

function UIGetLuckyBuffPopupView:RefreshGetLuckyContent()
  self.curRedPacketData = DeepCopy(self.initParam.redPacket)
  if table.IsNullOrEmpty(self.curRedPacketData) then
    self.ctrl:CloseSelf()
    return
  end
  local sendUserData, receiveUserData
  local sendUid = self.curRedPacketData.sendUid or ""
  local receiveUid = self.curRedPacketData.buffReceiverUid or ""
  for _, redPacketDetail in ipairs(self.curRedPacketData.detail) do
    if redPacketDetail.uid == sendUid then
      sendUserData = redPacketDetail
    elseif redPacketDetail.uid == receiveUid then
      receiveUserData = redPacketDetail
    end
  end
  local luckyBuffCfgId = self.curRedPacketData.luckSiphonId or 0
  local luckyBuffCfg = DataCenter.LuckyBuffManager:GetLuckyConfigById(luckyBuffCfgId) or {}
  local luckyStatusID = luckyBuffCfg.lw_status or 0
  local luckyStatusCfg = DataCenter.StatusManager:GetTemplate(luckyStatusID) or {}
  if table.IsNullOrEmpty(luckyStatusCfg) or table.IsNullOrEmpty(sendUserData) or table.IsNullOrEmpty(receiveUserData) then
    self.ctrl:CloseSelf()
    return
  end
  self.compSendPlayerIcon:SetHeadAndFrame(sendUserData.uid, sendUserData.pic, sendUserData.picVer, false, sendUserData.headSkinId, sendUserData.headSkinET)
  self.textSenderName:SetText(sendUserData.name)
  self.compReceivePlayIcon:SetHeadAndFrame(receiveUserData.uid, receiveUserData.pic, receiveUserData.picVer, false, receiveUserData.headSkinId, receiveUserData.headSkinET)
  self.textReceiverName:SetText(receiveUserData.name)
  self.imgGetLuckyIcon:LoadSprite(luckyStatusCfg.icon)
  self.textBuffTip:SetLocalText(luckyStatusCfg.description)
end

function UIGetLuckyBuffPopupView:RefreshGetRewardContent()
  self.curTreasureData = DeepCopy(self.initParam.treasureData)
  if table.IsNullOrEmpty(self.curTreasureData) then
    self.ctrl:CloseSelf()
    return
  end
  local treasureRewardList = self.curTreasureData.reward
  local sendUserData = self.curTreasureData.luckSiphonbuffSenderInfo
  local isBigReward = self.curTreasureData.isBigReward == 1 and true or false
  local bigRewardMultiple = self.curTreasureData.bigRewardMultiple or 1
  if table.IsNullOrEmpty(treasureRewardList) or table.IsNullOrEmpty(sendUserData) then
    self.ctrl:CloseSelf()
    return
  end
  treasureRewardList = DataCenter.RewardManager:ReturnRewardParamForMessage(treasureRewardList)
  self.textGift:SetLocalText("luckyBuff_limit_buffFrom")
  self.compGivePlayerIcon:SetHeadAndFrame(sendUserData.uid, sendUserData.pic, sendUserData.picVer, false, sendUserData.headSkinId, sendUserData.headSkinET)
  self.textGiverName:SetText(sendUserData.name)
  self:RefreshRewardList(treasureRewardList, isBigReward, bigRewardMultiple)
end

function UIGetLuckyBuffPopupView:RefreshRewardList(reward_data_list, isBigReward, bigRewardMultiple)
  local rewardItemCount = 0
  for i, v in ipairs(reward_data_list) do
    rewardItemCount = rewardItemCount + 1
    self.curRewardItemList[rewardItemCount] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.gameObject:SetActive(true)
      go.transform:SetParent(self.compRewardContent.transform)
      go.transform.localScale = Vector3.New(1, 1, 1)
      local nameStr = tostring(NameCount)
      go.name = nameStr
      NameCount = NameCount + 1
      local cell = self.compRewardContent:AddComponent(UICommonResItem, nameStr)
      local param = UICommonResItem.Param.New()
      param.rewardType = v.rewardType
      param.itemId = v.itemId
      local multiple = bigRewardMultiple or 2
      param.count = isBigReward and v.count / multiple or v.count
      param.heroUuid = v.heroUuid
      param.isHeroBox = v.isHeroBox
      param.bUuid = v.bUuid
      param.isShowDoubleMark = isBigReward
      param.multiple = bigRewardMultiple
      cell:ReInit(param)
      cell:SetSizeDelta(Vector2.New(162, 170))
    end)
  end
end

return UIGetLuckyBuffPopupView
