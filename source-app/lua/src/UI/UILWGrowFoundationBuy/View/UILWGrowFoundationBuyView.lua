local UILWGrowFoundationBuyView = BaseClass("UILWGrowFoundationBuyView", UIBaseView)
local base = UIBaseView
local UIGiftPackagePoint = require("UI.UIGiftPackage.Component.UIGiftPackagePoint")
local panel_path = "UICommonPopUpTitle/panel"
local closeBtn_path = "UICommonPopUpTitle/CloseBtn"
local rewardItem_path = "Rewards/UICommonResItem"
local rewardCountText_path = "Rewards/RewardCountText"
local buyBtn_path = "BuyBtn"
local buyBtnPriceText_path = "BuyBtn/PriceText"
local giftPackPoint_path = "BuyBtn/UIGiftPackagePoint"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.actId = self:GetUserData()
  if not self.actId then
    self.ctrl:CloseSelf()
    return
  end
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:ReInit()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.close_btn = self:AddComponent(UIButton, closeBtn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.panelBtn = self:AddComponent(UIButton, panel_path)
  self.panelBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.rewardItem = self:AddComponent(UICommonResItem, rewardItem_path)
  self.rewardCountText = self:AddComponent(UIText, rewardCountText_path)
  self.buyBtn = self:AddComponent(UIButton, buyBtn_path)
  self.buyBtn:SetOnClick(function()
    self:OnBuyBtnClick()
  end)
  self.buyBtn:SetSafeClickMode(true)
  self.buyBtnPriceText = self:AddComponent(UIText, buyBtnPriceText_path)
  self.giftPackPoint = self:AddComponent(UIGiftPackagePoint, giftPackPoint_path)
end

local function OnBuyBtnClick(self)
  if self.giftPackData then
    if self.giftPackData:isTimeValid() then
      DataCenter.PayManager:CallPayment(self.giftPackData, "GoldExchangeView")
    else
      UIUtil.ShowTipsId(2000431)
    end
  else
    UIUtil.ShowTipsId(2000431)
  end
end

local function ComponentDestroy(self)
  self.close_btn = nil
  self.panelBtn = nil
  self.rewardItem = nil
  self.rewardCountText = nil
  self.buyBtn = nil
  self.buyBtnPriceText = nil
  self.giftPackPoint = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function RefreshGiftPack(self)
  if self.giftPackGroupId then
    local packs = GiftPackageData.GetPacksByGroupId(self.giftPackGroupId)
    if not table.IsNullOrEmpty(packs) then
      self.giftPackData = packs[1]
    else
      self.giftPackData = nil
    end
    if not self.giftPackData then
      self.ctrl:CloseSelf()
    end
  end
end

local function OnUpdateActivityInfo(self)
  if self.actDetailInfo then
    local buyState = false
    if self.actDetailInfo.extraData then
      buyState = self.actDetailInfo.extraData.buy_gift == 1
    end
    if buyState then
      self.ctrl:CloseSelf()
      return
    end
  end
end

local function OnAddListener(self)
  self:AddUIListener(EventId.UpdateGiftPackData, self.RefreshGiftPack)
  self:AddUIListener(EventId.RefreshActivityDetailData, self.OnUpdateActivityInfo)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.UpdateGiftPackData, self.RefreshGiftPack)
  self:RemoveUIListener(EventId.RefreshActivityDetailData, self.OnUpdateActivityInfo)
  base.OnRemoveListener(self)
end

local function ReInit(self)
  self.actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.actId)
  if not self.actInfo then
    self.ctrl:CloseSelf()
    return
  end
  self.actDetailInfo = DataCenter.ActivityListDataManager:GetActEventInfo(self.actId)
  if not self.actDetailInfo then
    self.ctrl:CloseSelf()
    return
  end
  local buyState = false
  if self.actDetailInfo.extraData then
    buyState = self.actDetailInfo.extraData.buy_gift == 1
  end
  if buyState then
    self.ctrl:CloseSelf()
    return
  end
  self.giftPackGroupId = self.actDetailInfo:GetStageGiftPackGroupId(1)
  local packs = GiftPackageData.GetPacksByGroupId(self.giftPackGroupId)
  if not table.IsNullOrEmpty(packs) then
    self.giftPackData = packs[1]
  else
    self.giftPackData = nil
  end
  if not self.giftPackData then
    self.ctrl:CloseSelf()
    return
  end
  local rewardDiamondCount = 0
  local targets = self.actDetailInfo:GetStageQuests(1)
  for _, target in ipairs(targets) do
    local taskValue = DataCenter.TaskManager:FindTaskInfo(target)
    if taskValue and taskValue.state == TaskState.CanReceive and not table.IsNullOrEmpty(taskValue.rewardList) then
      local rewardList = DataCenter.RewardManager:RewardItemList(taskValue.rewardList)
      local diamondRewardCount = 0
      for i, v in pairs(rewardList) do
        if v.rewardType == RewardType.GOLD then
          diamondRewardCount = diamondRewardCount + v.count
        end
      end
      rewardDiamondCount = rewardDiamondCount + diamondRewardCount
    end
  end
  local param = {}
  param.rewardType = RewardType.GOLD
  param.itemId = 0
  self.rewardItem:ReInit(param)
  self.rewardCountText:SetText(rewardDiamondCount)
  self.giftPackPoint:RefreshPoint(self.giftPackData)
end

UILWGrowFoundationBuyView.OnCreate = OnCreate
UILWGrowFoundationBuyView.OnDestroy = OnDestroy
UILWGrowFoundationBuyView.OnEnable = OnEnable
UILWGrowFoundationBuyView.OnDisable = OnDisable
UILWGrowFoundationBuyView.ComponentDefine = ComponentDefine
UILWGrowFoundationBuyView.ComponentDestroy = ComponentDestroy
UILWGrowFoundationBuyView.DataDefine = DataDefine
UILWGrowFoundationBuyView.DataDestroy = DataDestroy
UILWGrowFoundationBuyView.OnAddListener = OnAddListener
UILWGrowFoundationBuyView.OnRemoveListener = OnRemoveListener
UILWGrowFoundationBuyView.RefreshGiftPack = RefreshGiftPack
UILWGrowFoundationBuyView.OnBuyBtnClick = OnBuyBtnClick
UILWGrowFoundationBuyView.OnUpdateActivityInfo = OnUpdateActivityInfo
UILWGrowFoundationBuyView.ReInit = ReInit
return UILWGrowFoundationBuyView
