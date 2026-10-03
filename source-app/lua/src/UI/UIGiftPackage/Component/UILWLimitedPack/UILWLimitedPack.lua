local UILWLimitedPack = BaseClass("UILWLimitedPack", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local UIGiftPackagePoint = require("UI.UIGiftPackage.Component.UIGiftPackagePoint")
local packBg_path = "Bg"
local packImg_path = "Dec1"
local giftTitleText_path = "Rect_Package/ImageTop/Rect_Top/Txt_GiftTitle"
local giftDescText_path = "Rect_Package/ImageTop/Rect_Top/Txt_Desc"
local timeContainer_path = "Rect_Package/ImageTop/Rect_Bottom/TimeContianer"
local timeTitleText_path = "Rect_Package/ImageTop/Rect_Bottom/TimeContianer/TimeTitle"
local remainTimeText_path = "Rect_Package/ImageTop/Rect_Bottom/TimeContianer/TimeBg/remainTime"
local rewardsTitleText_path = "Rect_Package/ImageTop/Rect_Bottom/Rewards/RewardsTitle"
local rewardsScroll_path = "Rect_Package/ImageTop/Rect_Bottom/Rewards/RewardScroll"
local rewardsContent_path = "Rect_Package/ImageTop/Rect_Bottom/Rewards/RewardScroll/Viewport/Content"
local buyBtn_path = "Rect_Package/buy_btn"
local buyBtnCostText_path = "Rect_Package/buy_btn/Txt_Cost"
local buyBtnBoughtStateText_path = "Rect_Package/buy_btn/boughtStateText"
local buyBtnOverTimeStateText_path = "Rect_Package/buy_btn/OverTimeText"
local giftPackPointPath = "Rect_Package/buy_btn/UIGiftPackagePoint"
local discount_content_path = "Rect_Package/ImageTop/Rect_Top/DiscountContent"
local discount_text_path = "Rect_Package/ImageTop/Rect_Top/DiscountContent/DiscountText"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function ClearScroll(self)
  self.rewardsContent:RemoveComponents(UICommonResItem)
  self.rewardsScroll:ClearAllItems()
end

local function OnDestroy(self)
  if self.delayUpdate then
    self.delayUpdate:Stop()
    self.delayUpdate = nil
  end
  ClearScroll(self)
  self:DelTimer()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateGiftPackData, self.OnUpdateGifthPack)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.UpdateGiftPackData, self.OnUpdateGifthPack)
  base.OnRemoveListener(self)
end

local function OnGetItemByIndex(self, loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.rewards then
    return nil
  end
  local rewardData = self.rewards[index]
  local item = loopScroll:NewListViewItem("UICommonResItem")
  local script = self.rewardsContent:GetComponent(item.gameObject.name, UICommonResItem)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    script = self.rewardsContent:AddComponent(UICommonResItem, objectName)
  end
  script:SetActive(true)
  script:ReInit(rewardData)
  return item
end

local function ComponentDefine(self)
  self.bg = self:AddComponent(UIRawImage, packBg_path)
  self.packImg = self:AddComponent(UIRawImage, packImg_path)
  self.giftTitleText = self:AddComponent(UIText, giftTitleText_path)
  self.giftDescText = self:AddComponent(UIText, giftDescText_path)
  self.timeContainer = self:AddComponent(UIBaseContainer, timeContainer_path)
  self.timeTitleText = self:AddComponent(UIText, timeTitleText_path)
  self.remainTimeText = self:AddComponent(UIText, remainTimeText_path)
  self.rewardsTitleText = self:AddComponent(UIText, rewardsTitleText_path)
  self.rewardsScroll = self:AddComponent(UILoopListView2, rewardsScroll_path)
  self.rewardsScroll:InitListView(0, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
  end)
  self.rewardsContent = self:AddComponent(UIBaseContainer, rewardsContent_path)
  self.buyBtn = self:AddComponent(UIButton, buyBtn_path)
  self.buyBtn:SetOnClick(function()
    self:OnClickBtn()
  end)
  self.buyBtn:SetSafeClickMode(true)
  self.buyBtnCostText = self:AddComponent(UIText, buyBtnCostText_path)
  self.buyBtnBoughtStateText = self:AddComponent(UIText, buyBtnBoughtStateText_path)
  self.buyBtnOverTimeStateText = self:AddComponent(UIText, buyBtnOverTimeStateText_path)
  self.giftPackPoint = self:AddComponent(UIGiftPackagePoint, giftPackPointPath)
  self.discount_content = self:AddComponent(UIImage, discount_content_path)
  self.discount_text = self:AddComponent(UIText, discount_text_path)
end

local function ComponentDestroy(self)
  self.bg = nil
  self.packImg = nil
  self.giftTitleText = nil
  self.giftDescText = nil
  self.timeContainer = nil
  self.timeTitleText = nil
  self.remainTimeText = nil
  self.rewardsTitleText = nil
  self.rewardsScroll = nil
  self.rewardsContent = nil
  self.buyBtn = nil
  self.buyBtnCostText = nil
  self.buyBtnBoughtStateText = nil
  self.buyBtnOverTimeStateText = nil
  self.giftPackPoint = nil
  self.discount_content = nil
  self.discount_text = nil
end

local function DataDefine(self)
  function self.TimerAction()
    self:RefreshRemainTime()
  end
  
  self.itemIndex = 0
end

local function DataDestroy(self)
  self.TimerAction = nil
  self.itemIndex = nil
end

local function ReInit(self, rechargeId)
  self.rechargeId = rechargeId
  self.welfareTag = WelfareController.getShowTagInfoById(self.rechargeId)
  if not self.welfareTag then
    return
  end
  local packs = self.welfareTag:getPackList()
  self.packData = packs[1]
  self.isBought = true
  self:InitUI()
  self:RefreshUI()
  self:RefreshRewards()
end

local function InitUI(self)
  if self.rechargeId then
    local lineData = DataCenter.RechargeManager:GetLine(self.rechargeId)
    if lineData then
      local bgName = string.format(LoadPath.UILimitedPackFullBg, lineData.image)
      local bg1Name = string.format(LoadPath.UILimitedPackFullBg, lineData.image1)
      self.bg:LoadSprite(bgName)
      self.packImg:LoadSprite(bg1Name)
    end
  end
  if self.packData then
    self.giftTitleText:SetText(self.packData:getNameText())
    self.giftDescText:SetText(self.packData:getDescText())
  end
end

local function OnUpdateGifthPack(self)
  if self.welfareTag then
    local packs = self.welfareTag:getPackList()
    self.packData = packs[1]
  end
  self:RefreshUI()
  self:RefreshRewards()
end

local function RefreshUI(self)
  self:DelTimer()
  if self.packData then
    local timeValid = self.packData:getCountdown() > 0
    if timeValid then
      self.buyBtnCostText:SetActive(true)
      self.buyBtnBoughtStateText:SetActive(false)
      self.buyBtnOverTimeStateText:SetActive(false)
      self.buyBtnCostText:SetText(self.packData:getPriceText())
      UIGray.SetGray(self.buyBtn.transform, false, true)
      self.timeContainer:SetActive(true)
      self:AddTimer()
    else
      self.buyBtnCostText:SetActive(false)
      self.buyBtnBoughtStateText:SetActive(false)
      self.buyBtnOverTimeStateText:SetActive(true)
      self.timeContainer:SetActive(false)
      UIGray.SetGray(self.buyBtn.transform, true, true)
    end
    self.giftPackPoint:SetActive(true)
    self.giftPackPoint:RefreshPoint(self.packData)
    self.discount_content:SetActive(true)
    self.discount_text:SetText(string.format("%s%%", self.packData:getPercent()))
  else
    self.buyBtnCostText:SetActive(false)
    self.buyBtnBoughtStateText:SetActive(true)
    self.buyBtnOverTimeStateText:SetActive(false)
    self.timeContainer:SetActive(false)
    UIGray.SetGray(self.buyBtn.transform, true, true)
    self.giftPackPoint:SetActive(false)
    self.discount_content:SetActive(false)
  end
end

local function RefreshRewards(self)
  if self.packData then
    self.rewards = self.packData:getItems(true)
    self.rewardsScroll:SetListItemCount(#self.rewards, false, false)
    self.rewardsScroll:RefreshAllShownItem()
  end
end

local function AddTimer(self)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.TimerAction, self, false, false, false)
  end
  self.timer:Start()
end

local function RefreshRemainTime(self)
  if self.packData then
    local countDownTime = self.packData:getCountdown()
    if 0 < countDownTime then
      local countDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(countDownTime)
      self.remainTimeText:SetText(countDownTimeStr)
    else
      self:RefreshUI()
      self:DelTimer()
    end
  else
    self:DelTimer()
  end
end

local function DelTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function OnClickBtn(self)
  if self.packData then
    local timeValid = self.packData:getCountdown() > 0
    if timeValid then
      self.view.ctrl:BuyGift(self.packData)
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Ue_GetPayReward, false)
    else
      UIUtil.ShowTipsId(2000431)
    end
  else
    UIUtil.ShowTipsId(2000431)
  end
end

UILWLimitedPack.OnCreate = OnCreate
UILWLimitedPack.OnDestroy = OnDestroy
UILWLimitedPack.OnAddListener = OnAddListener
UILWLimitedPack.OnRemoveListener = OnRemoveListener
UILWLimitedPack.ComponentDefine = ComponentDefine
UILWLimitedPack.ComponentDestroy = ComponentDestroy
UILWLimitedPack.DataDefine = DataDefine
UILWLimitedPack.DataDestroy = DataDestroy
UILWLimitedPack.ReInit = ReInit
UILWLimitedPack.InitUI = InitUI
UILWLimitedPack.RefreshUI = RefreshUI
UILWLimitedPack.AddTimer = AddTimer
UILWLimitedPack.DelTimer = DelTimer
UILWLimitedPack.OnClickBtn = OnClickBtn
UILWLimitedPack.RefreshRemainTime = RefreshRemainTime
UILWLimitedPack.RefreshRewards = RefreshRewards
UILWLimitedPack.OnUpdateGifthPack = OnUpdateGifthPack
UILWLimitedPack.OnGetItemByIndex = OnGetItemByIndex
return UILWLimitedPack
