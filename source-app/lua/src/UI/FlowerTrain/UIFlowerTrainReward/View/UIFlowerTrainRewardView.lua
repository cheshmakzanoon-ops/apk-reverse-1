local UIFlowerTrainRewardView = BaseClass("UIFlowerTrainRewardView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIFlowerTrainRewardView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.params = self:GetUserData()
  self.treasureId = self.params.cfgId
  self.rewardDataList = self.params.reward
  self:RefreshView()
end

function UIFlowerTrainRewardView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIFlowerTrainRewardView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.rawImgFlowerTrainRawImg = self.viewSkin:AddComponent(self, UIRawImage, 1)
  self.btnLWInfo = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnLWInfo:SetOnClick(function()
    self:OnBtnLWInfoClick()
  end)
  self.btnRewardPreview = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnRewardPreview:SetOnClick(function()
    self:OnBtnRewardPreviewClick()
  end)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.btnClaim = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnClaim:SetOnClick(function()
    self:OnBtnClaimClick()
  end)
  self.loopListView2RewardScrollView = self.viewSkin:AddComponent(self, UILoopListView2, 7)
  self.rawImgBg = self.viewSkin:AddComponent(self, UIRawImage, 8)
  self.loopListView2RewardScrollView:InitListView(0, function(loopView, index)
    return self:OnGetRewardItemByIndex(loopView, index)
  end)
end

function UIFlowerTrainRewardView:ComponentDestroy()
  self.compContent:RemoveComponents(UICommonResItem)
  self.viewSkin = nil
  self.rawImgFlowerTrainRawImg = nil
  self.btnLWInfo = nil
  self.btnRewardPreview = nil
  self.compContent = nil
  self.btnClose = nil
  self.btnClaim = nil
  self.loopListView2RewardScrollView = nil
  self.rawImgBg = nil
end

function UIFlowerTrainRewardView:DataDefine()
end

function UIFlowerTrainRewardView:DataDestroy()
end

function UIFlowerTrainRewardView:OnAddListener()
  base.OnAddListener(self)
end

function UIFlowerTrainRewardView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIFlowerTrainRewardView:RefreshView()
  self:ParseData()
  self:RefreshBannerImgAndBottomBG()
  self:RefreshBaseArea()
  self:RefreshRewardArea()
end

function UIFlowerTrainRewardView:ParseData()
  if not self.treasureId then
    Logger.LogError("UIFlowerTrainRewardView:ParseData treasureId is nil")
    return
  end
  local giftMeta = LocalController:instance():tryGetLine(TableName.WorldTreasure, self.treasureId)
  if not giftMeta then
    Logger.LogError("UIFlowerTrainRewardView:ParseData giftMeta is nil")
    return false
  end
  local boxShowMetaId = giftMeta.custom_para
  if boxShowMetaId then
    self.boxShowMeta = DataCenter.FlowerTrainDataManager:GetWorldBoxRewardShowMeta(boxShowMetaId)
    self.flowerTrainGoodsId = toInt(self.boxShowMeta.treasure_goods)
    self.bgPath = self.boxShowMeta.reward_board_di
    self.bannerImgPath = self.boxShowMeta.reward_board_pic
  end
end

function UIFlowerTrainRewardView:RefreshBaseArea()
  if not self.treasureId then
    return
  end
end

function UIFlowerTrainRewardView:RefreshBannerImgAndBottomBG()
  if self.bannerImgPath then
    self.rawImgFlowerTrainRawImg:LoadSpriteAsync(self.bannerImgPath)
  end
  if self.bgPath then
    self.rawImgBg:LoadSpriteAsync(self.bgPath)
  end
end

function UIFlowerTrainRewardView:RefreshRewardArea()
  if not self.rewardDataList then
    return
  end
  self.loopListView2RewardScrollView:SetListItemCount(#self.rewardDataList, false, false)
  self.loopListView2RewardScrollView:RefreshAllShownItem()
end

function UIFlowerTrainRewardView:OnBtnLWInfoClick()
  if not self.boxShowMeta then
    return
  end
  local infoData = self.boxShowMeta.info
  if not infoData or #infoData < 2 then
    Logger.LogError("UIFlowerTrainRewardView:OnBtnLWInfoClick infoData is nil or length is less than 2")
    return
  end
  local param = {}
  param.title = infoData[1]
  param.activityRulesStr = Localization:GetString(infoData[2])
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  PostEventLog.Track(PostEventLog.Defines.FlowerTrain_Show_BoxRule_Panel)
end

function UIFlowerTrainRewardView:OnBtnRewardPreviewClick()
  if not self.boxShowMeta then
    Logger.LogError("UIFlowerTrainRewardView:OnBtnRewardPreviewClick boxShowMeta is nil")
    return
  end
  local dropInfoId = self.boxShowMeta.box_dropinfo
  if dropInfoId and not string.IsNullOrEmpty(dropInfoId) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIProbabilityNotice)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIProbabilityNotice, {anim = true}, dropInfoId)
  elseif self.flowerTrainGoodsId then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIFlowerTrainProbability, {anim = true}, {
      itemId = self.flowerTrainGoodsId
    })
  else
    Logger.LogError("UIFlowerTrainRewardView:OnBtnRewardPreviewClick flowerTrainGoodsId is nil")
  end
end

function UIFlowerTrainRewardView:OnBtnCloseClick()
  self:CloseView()
end

function UIFlowerTrainRewardView:OnBtnClaimClick()
  self:CloseView()
end

function UIFlowerTrainRewardView:CloseView()
  self.ctrl:CloseSelf()
  FlowerTrainUtils.ShowFlyReward(self.rewardDataList, self.compContent)
end

function UIFlowerTrainRewardView:OnGetRewardItemByIndex(loopView, index)
  index = index + 1
  if index < 1 or index > #self.rewardDataList then
    return nil
  end
  local item = loopView:NewListViewItem("UICommonResItem")
  local script = self.compContent:GetComponent(item.gameObject.name, UICommonResItem)
  if script == nil then
    local objectName = tostring(NameCount)
    NameCount = NameCount + 1
    item.gameObject.name = objectName
    script = self.compContent:AddComponent(UICommonResItem, objectName)
  end
  script:SetActive(true)
  item.transform.localScale = Vector3.New(1, 1, 1)
  local rewardData = self.rewardDataList[index]
  if rewardData then
    script:ReInit(rewardData)
  end
  return item
end

return UIFlowerTrainRewardView
