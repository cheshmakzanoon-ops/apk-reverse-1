local base = UIBaseContainer
local UILWTrainSaveHighGoodsComponent = BaseClass("UILWTrainSaveHighGoodsComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UILWTrainSaveHighGoodsComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWTrainSaveHighGoodsComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWTrainSaveHighGoodsComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compHighGoodsTipsBubble = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
  self.textSaveHighGoodsBubbleTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnSave = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnSave:SetOnClick(function()
    self:OnBtnSaveClick()
  end)
  self.textSaveHighGoodsBubbleTips:SetLocalText("alliance_train_golden_progress_tips_limit_15")
end

function UILWTrainSaveHighGoodsComponent:ComponentDestroy()
  self.viewSkin = nil
  self.compHighGoodsTipsBubble = nil
  self.textSaveHighGoodsBubbleTips = nil
  self.btnSave = nil
end

function UILWTrainSaveHighGoodsComponent:DataDefine()
  self.trainData = nil
  self.isShowBubbleByFirstSeeUR = false
end

function UILWTrainSaveHighGoodsComponent:DataDestroy()
  self.trainData = nil
  self.isShowBubbleByFirstSeeUR = false
end

function UILWTrainSaveHighGoodsComponent:OnAddListener()
  base.OnAddListener(self)
end

function UILWTrainSaveHighGoodsComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWTrainSaveHighGoodsComponent:RefreshShow(curPage, trainData, platformState)
  self.trainData = trainData
  if self.trainData == nil then
    Logger.LogInfo("UILWTrainSaveHighGoodsComponent trainData is nil")
    self:SetActive(false)
    return
  end
  if curPage == TrainPreparePage.Driver then
    self:SetActive(false)
  else
    local isURTrain = self.trainData:IsUR()
    local isShow = self.trainData and self.trainData:IsMyTrain() and platformState ~= TrainPlatformState.TrainNoDriver and isURTrain
    self:SetActive(isShow)
    if isShow then
      self:RefreshButtonShow(isURTrain)
    end
  end
end

function UILWTrainSaveHighGoodsComponent:RefreshButtonShow(isURTrain)
  self.btnSave:SetActive(isURTrain)
  local hasHighGoods = self.trainData:GetIsContainHighGoods()
  local bakReward2DiamondPrice = self.trainData:GetBakReward2DiamondPrice()
  local fullReward2DiamondPrice = self.trainData:GetFullReward2DiamondPrice()
  local highDiamondPrice = 0 < bakReward2DiamondPrice and bakReward2DiamondPrice < fullReward2DiamondPrice
  local isShowBubble = isURTrain and not self.trainData.saveMark and (hasHighGoods or highDiamondPrice)
  local isFirstSeeURTrain = Setting:GetPrivateBool("IsFirstSeeURTrain", true)
  if isFirstSeeURTrain and not isShowBubble then
    isShowBubble = true
    self.isShowBubbleByFirstSeeUR = true
    self.textSaveHighGoodsBubbleTips:SetLocalText("alliance_train_golden_progress_tips_limit_20")
    Setting:SetPrivateBool("IsFirstSeeURTrain", false)
  else
    self.isShowBubbleByFirstSeeUR = false
    self.textSaveHighGoodsBubbleTips:SetLocalText("alliance_train_golden_progress_tips_limit_15")
  end
  self.compHighGoodsTipsBubble:SetActive(isShowBubble)
end

function UILWTrainSaveHighGoodsComponent:OnBtnSaveClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTrainPrepareReplace, {anim = true}, self.trainData)
  if self.isShowBubbleByFirstSeeUR then
    self.compHighGoodsTipsBubble:SetActive(false)
  end
end

return UILWTrainSaveHighGoodsComponent
