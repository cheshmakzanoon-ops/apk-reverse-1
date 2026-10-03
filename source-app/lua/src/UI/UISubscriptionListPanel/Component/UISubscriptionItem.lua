local UISubscriptionItem = BaseClass("UISubscriptionItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local UISubscriptionRewardItem = require("UI.UISubscriptionListPanel.Component.UISubscriptionRewardItem")
local ResourceManager = CS.GameEntry.Resource

local function ComponentDefine(self)
  self.ownedContent = self:AddComponent(UIBaseContainer, "OwnedContent")
  self.unownedContent = self:AddComponent(UIBaseContainer, "UnownedContent")
  self.rewardBtn = self:AddComponent(UIButton, "OwnedContent/RewardBtn")
  self.rewardBtn:SetOnClick(function()
    self:OnRewardBtnClick()
  end)
  self.rewardBtnText = self:AddComponent(UIText, "OwnedContent/RewardBtn/RewardBtnText")
  self.countDownText = self:AddComponent(UIText, "OwnedContent/CountDownText")
  self.buyBtn = self:AddComponent(UIButton, "UnownedContent/BuyBtn")
  self.buyBtn:SetOnClick(function()
    self:OnBuyBtnClick()
  end)
  self.buyBtnText = self:AddComponent(UIText, "UnownedContent/BuyBtn/BuyBtnText")
  self.nameText = self:AddComponent(UIText, "NameText")
  self.rewardScroll = self:AddComponent(UIBaseContainer, "RewardScroll")
  self.rewardScrollContent = self:AddComponent(UIBaseContainer, "RewardScroll/Content")
end

local function ComponentDestroy(self)
  self.ownedContent = nil
  self.unownedContent = nil
  self.rewardBtn = nil
  self.rewardBtnText = nil
  self.countDownText = nil
  self.buyBtn = nil
  self.buyBtnText = nil
  self.nameText = nil
  self.rewardScroll = nil
  self.rewardScrollContent = nil
end

local function OnCreate(self)
  base.OnCreate(self)
  self.rewardItemReqs = {}
  self.rewardItems = {}
  self.timer_action = BindCallback(self, self.RefreshTime)
  self:ComponentDefine()
end

local function DestoryRewardItems(self)
  if self.rewardItemReqs then
    self:RemoveComponents(UISubscriptionRewardItem)
    for i = 1, #self.rewardItemReqs do
      self.rewardItemReqs[i]:Destroy()
    end
    self.rewardItemReqs = {}
    self.rewardItems = {}
  end
end

local function OnDestroy(self)
  self:DeleteTimer()
  DestoryRewardItems(self)
  self.timer_action = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function GetActiveState(self)
  if not self.param then
    return false
  end
  if self.param.type == SubscriptionItemType.Weekly then
    local status = self.weekCardData:RefreshStatus()
    return status == WeekCardPackageStatus.CanClaim or status == WeekCardPackageStatus.BuyAgain
  elseif self.param.type == SubscriptionItemType.Monthly then
    return self.monthCardData:IsBought()
  elseif self.param.type == SubscriptionItemType.FreeGift_Daily or self.param.type == SubscriptionItemType.FreeGift_SeasonWeekly or self.param.type == SubscriptionItemType.FreeGift_Weekly then
    return true
  elseif self.param.type == SubscriptionItemType.SeasonWeekly then
    return self.seasonWeeklyCardData:IsBought()
  end
end

local function GetCanClaimState(self)
  if not self.param then
    return true
  end
  if self.param.type == SubscriptionItemType.Weekly then
    local status = self.weekCardData:RefreshStatus()
    return status == WeekCardPackageStatus.CanClaim
  elseif self.param.type == SubscriptionItemType.Monthly then
    return not self.monthCardData:IsTodayClaimed()
  elseif self.param.type == SubscriptionItemType.FreeGift_Daily then
    return GiftPackageData.CheckIfHasFreeWeeklyPackage()
  elseif self.param.type == SubscriptionItemType.FreeGift_SeasonWeekly then
    local isOpenSeasonCard = DataCenter.ActivityListDataManager:CheckIfActivityOpen(EnumActivity.SeasonPeriodicCard.Type)
    return self.seasonWeeklyCardData and isOpenSeasonCard and not self.seasonWeeklyCardData:IsTodayClaimedFree()
  elseif self.param.type == SubscriptionItemType.FreeGift_Weekly then
    return DataCenter.WeekCardManager:CheckIfHasFreeReward()
  elseif self.param.type == SubscriptionItemType.SeasonWeekly then
    local isOpenSeasonCard = DataCenter.ActivityListDataManager:CheckIfActivityOpen(EnumActivity.SeasonPeriodicCard.Type)
    return self.seasonWeeklyCardData and isOpenSeasonCard and not self.seasonWeeklyCardData:IsTodayClaimed()
  end
end

local function OnBuyBtnClick(self)
  if not self.param then
    return
  end
  if self.param.type == SubscriptionItemType.Weekly then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWBuyDiamond, {anim = true}, WelfareTagType.WeekCard)
    self.view.ctrl.CloseSelf()
  elseif self.param.type == SubscriptionItemType.Monthly then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWBuyDiamond, {anim = true}, WelfareTagType.MonthCard)
    self.view.ctrl.CloseSelf()
  elseif self.param.type == SubscriptionItemType.SeasonWeekly then
    GoToUtil.GotoSeasonWeekCardView()
  end
end

local function OnRewardBtnClick(self)
  if not self.param then
    return
  end
  local state = GetCanClaimState(self)
  if not state then
    UIUtil.ShowTipsId(2000443)
    return
  end
  if self.param.type == SubscriptionItemType.Weekly then
    SFSNetwork.SendMessage(MsgDefines.ClaimWeekCardReward, self.weekCardData.id)
  elseif self.param.type == SubscriptionItemType.Monthly then
    SFSNetwork.SendMessage(MsgDefines.ClaimGolloesDailyReward, self.monthCardData.monthCardId)
  elseif self.param.type == SubscriptionItemType.FreeGift_Daily then
    local hasFree = GiftPackageData.CheckIfHasFreeWeeklyPackage()
    if hasFree then
      SFSNetwork.SendMessage(MsgDefines.BuyFreeWeeklyPackage, false)
    end
  elseif self.param.type == SubscriptionItemType.FreeGift_SeasonWeekly then
    local seasonConfig = DataCenter.SeasonDataManager:GetSeasonConfig()
    if seasonConfig then
      local cardId = tonumber(seasonConfig.week_card)
      local cardData = DataCenter.SeasonPeriodicCardManager:GetCardData(cardId)
      if cardData then
        SFSNetwork.SendMessage(MsgDefines.LWSeasonWeekCardFreeReward, cardId, false)
      end
    end
  elseif self.param.type == SubscriptionItemType.FreeGift_Weekly then
    local hasFree = DataCenter.WeekCardManager:CheckIfHasFreeReward()
    if hasFree then
      SFSNetwork.SendMessage(MsgDefines.ClaimWeekCardFreeReward, false)
    end
  elseif self.param.type == SubscriptionItemType.SeasonWeekly then
    local seasonConfig = DataCenter.SeasonDataManager:GetSeasonConfig()
    if seasonConfig then
      local cardId = tonumber(seasonConfig.week_card)
      local cardData = DataCenter.SeasonPeriodicCardManager:GetCardData(cardId)
      if cardData then
        SFSNetwork.SendMessage(MsgDefines.LWSeasonWeekCardDailyReward, cardId)
      end
    end
  end
end

local function RefreshRewards(self)
  if not self.param then
    return
  end
  local rewards
  if self.param.type == SubscriptionItemType.Weekly then
    rewards = self.weekCardData:GetDailyReward()
  elseif self.param.type == SubscriptionItemType.Monthly then
    rewards = self.monthCardData:GetDailyRewards()
  elseif self.param.type == SubscriptionItemType.FreeGift_Daily then
    local rewardId = LuaEntry.DataConfig:TryGetNum("aps_dailypackage", "k5")
    local rewardList = DataCenter.RewardTemplateManager:GetList(rewardId)
    local itemList = {}
    for i = 1, #rewardList do
      local item = DataCenter.RewardManager:ParseOneReward(rewardList[i].itemId, rewardList[i].rewardType, rewardList[i].count)
      table.insert(itemList, item)
    end
    rewards = itemList
  elseif self.param.type == SubscriptionItemType.FreeGift_SeasonWeekly then
    local itemList = {}
    local seasonConfig = DataCenter.SeasonDataManager:GetSeasonConfig()
    if seasonConfig then
      local cardId = tonumber(seasonConfig.week_card)
      local cardData = DataCenter.SeasonPeriodicCardManager:GetCardData(cardId)
      if cardData then
        local weekConfig = LocalController:instance():getLine(TableName.Season_Week_Card, cardId)
        if weekConfig then
          local rewardList = DataCenter.RewardTemplateManager:GetList(weekConfig.reward_free)
          for i = 1, #rewardList do
            local item = DataCenter.RewardManager:ParseOneReward(rewardList[i].itemId, rewardList[i].rewardType, rewardList[i].count)
            table.insert(itemList, item)
          end
        end
      end
    end
    rewards = itemList
  elseif self.param.type == SubscriptionItemType.FreeGift_Weekly then
    local rewardId = LuaEntry.DataConfig:TryGetNum("weekcard_para", "k1")
    local rewardList = DataCenter.RewardTemplateManager:GetList(rewardId)
    local itemList = {}
    for i = 1, #rewardList do
      local item = DataCenter.RewardManager:ParseOneReward(rewardList[i].itemId, rewardList[i].rewardType, rewardList[i].count)
      table.insert(itemList, item)
    end
    rewards = itemList
  elseif self.param.type == SubscriptionItemType.SeasonWeekly then
    local itemList = {}
    local seasonConfig = DataCenter.SeasonDataManager:GetSeasonConfig()
    if seasonConfig then
      local cardId = tonumber(seasonConfig.week_card)
      local cardData = DataCenter.SeasonPeriodicCardManager:GetCardData(cardId)
      if cardData then
        local weekConfig = LocalController:instance():getLine(TableName.Season_Week_Card, cardId)
        if weekConfig then
          local rewardList = DataCenter.RewardTemplateManager:GetList(weekConfig.reward_daily)
          for i = 1, #rewardList do
            local item = DataCenter.RewardManager:ParseOneReward(rewardList[i].itemId, rewardList[i].rewardType, rewardList[i].count)
            table.insert(itemList, item)
          end
        end
      end
    end
    rewards = itemList
  end
  DestoryRewardItems(self)
  if not rewards then
    return
  end
  for i = 1, #rewards do
    local request = ResourceManager:InstantiateAsync(UIAssets.UISubscriptionRewardItem)
    request:completed("+", function()
      if request.isError then
        return
      end
      request.gameObject.name = "Reward" .. i
      request.gameObject:SetActive(true)
      request.gameObject.transform:SetParent(self.rewardScrollContent.transform)
      request.gameObject.transform:Set_localScale(0.78, 0.8, 1)
      local reward = self:AddComponent(UISubscriptionRewardItem, request.gameObject)
      reward:ReInit(rewards[i])
      local activeState = GetActiveState(self)
      reward:SetLocked(not activeState)
      table.insert(self.rewardItems, reward)
    end)
    table.insert(self.rewardItemReqs, request)
  end
  self.showRewards = rewards
end

local function RefreshUI(self)
  local activeState = GetActiveState(self)
  if activeState then
    self.ownedContent:SetActive(true)
    self.unownedContent:SetActive(false)
    local canClaimState = GetCanClaimState(self)
    CS.UIGray.SetGray(self.rewardBtn.transform, not canClaimState, true)
    local btnText = canClaimState and 2000441 or 2000442
    self.rewardBtnText:SetLocalText(btnText)
    self:AddTimer()
    for i = 1, #self.rewardItems do
      self.rewardItems[i]:SetLocked(false)
    end
  else
    self.ownedContent:SetActive(false)
    self.unownedContent:SetActive(true)
    for i = 1, #self.rewardItems do
      self.rewardItems[i]:SetLocked(true)
    end
  end
end

local function ReInit(self, param)
  self.param = param
  if self.param.type == SubscriptionItemType.Weekly then
    self.weekCardData = self.param.detailData
  elseif self.param.type == SubscriptionItemType.Monthly then
    self.monthCardData = self.param.detailData
  elseif (self.param.type == SubscriptionItemType.SeasonWeekly or self.param.type == SubscriptionItemType.FreeGift_SeasonWeekly) and self.param.detailData then
    self.seasonWeeklyCardData = self.param.detailData
  end
  if self.param.type == SubscriptionItemType.Weekly then
    self.nameText:SetLocalText(self.weekCardData.name)
  elseif self.param.type == SubscriptionItemType.Monthly then
    self.nameText:SetLocalText(2000148)
  elseif self.param.type == SubscriptionItemType.FreeGift_Daily then
    self.nameText:SetLocalText("auto_receive_title_02")
  elseif self.param.type == SubscriptionItemType.FreeGift_SeasonWeekly then
    self.nameText:SetLocalText("auto_receive_title_03")
  elseif self.param.type == SubscriptionItemType.FreeGift_Weekly then
    self.nameText:SetLocalText("auto_receive_title_01")
  elseif self.param.type == SubscriptionItemType.SeasonWeekly then
    self.nameText:SetLocalText("season_week_card_001")
  end
  RefreshUI(self)
  RefreshRewards(self)
end

local function AddTimer(self)
  self:DeleteTimer()
  self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  self.timer:Start()
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function GetActiveStateCountDownStr(self)
  if not self.param then
    return ""
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  local endTime = 0
  if self.param.type == SubscriptionItemType.Weekly then
    endTime = self.weekCardData.endTime
  elseif self.param.type == SubscriptionItemType.Monthly then
    endTime = self.monthCardData.endTime
  elseif self.param.type == SubscriptionItemType.SeasonWeekly then
    endTime = self.seasonWeeklyCardData.endTime
  end
  if now >= endTime then
    return ""
  else
    local countDown = endTime - now
    return UITimeManager:GetInstance():MilliSecondToFmtString(countDown)
  end
end

local function RefreshTime(self)
  local activeState = GetActiveState(self)
  if not activeState then
    DeleteTimer(self)
    RefreshUI(self)
    return
  else
    self.countDownText:SetText(GetActiveStateCountDownStr(self))
  end
end

local function OnUpdateMonthCardInfo(self)
  if not self.param then
    return
  end
  if self.param.type == SubscriptionItemType.Monthly then
    RefreshUI(self)
  end
end

local function OnUpdateWeekCardInfo(self, id)
  if not self.param then
    return
  end
  if self.param.type == SubscriptionItemType.Weekly and (not id or id == self.weekCardData.id) then
    RefreshUI(self)
  end
end

function UISubscriptionItem:OnUpdateWeeklyFreeGift()
  if not self.param then
    return
  end
  if self.param.type == SubscriptionItemType.FreeGift_Weekly then
    RefreshUI(self)
  end
end

function UISubscriptionItem:OnUpdateDailyFreeGift()
  if not self.param then
    return
  end
  if self.param.type == SubscriptionItemType.FreeGift_Daily then
    RefreshUI(self)
  end
end

function UISubscriptionItem:OnUpdateSeasonWeeklyFreeGift()
  if not self.param then
    return
  end
  if self.param.type == SubscriptionItemType.FreeGift_SeasonWeekly then
    RefreshUI(self)
  end
end

function UISubscriptionItem:OnUpdateSeasonWeeklyGift()
  if not self.param then
    return
  end
  if self.param.type == SubscriptionItemType.SeasonWeekly then
    RefreshUI(self)
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.MonthCardInfoUpdated, self.OnUpdateMonthCardInfo)
  self:AddUIListener(EventId.OnWeekCardInfoChange, self.OnUpdateWeekCardInfo)
  self:AddUIListener(EventId.OnPassDay, self.RefreshUI)
  self:AddUIListener(EventId.UpdateWeekCardFreeGiftData, self.OnUpdateWeeklyFreeGift)
  self:AddUIListener(EventId.FreeWeeklyPackage, self.OnUpdateDailyFreeGift)
  self:AddUIListener(EventId.LWSeasonWeekCardFreeRewardUpdate, self.OnUpdateSeasonWeeklyFreeGift)
  self:AddUIListener(EventId.LWSeasonWeekCardDailyRewardUpdate, self.OnUpdateSeasonWeeklyGift)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.MonthCardInfoUpdated, self.OnUpdateMonthCardInfo)
  self:RemoveUIListener(EventId.OnWeekCardInfoChange, self.OnUpdateWeekCardInfo)
  self:RemoveUIListener(EventId.OnPassDay, self.RefreshUI)
  self:RemoveUIListener(EventId.UpdateWeekCardFreeGiftData, self.OnUpdateWeeklyFreeGift)
  self:RemoveUIListener(EventId.FreeWeeklyPackage, self.OnUpdateDailyFreeGift)
  self:RemoveUIListener(EventId.LWSeasonWeekCardFreeRewardUpdate, self.OnUpdateSeasonWeeklyFreeGift)
  self:RemoveUIListener(EventId.LWSeasonWeekCardDailyRewardUpdate, self.OnUpdateSeasonWeeklyGift)
end

UISubscriptionItem.ComponentDefine = ComponentDefine
UISubscriptionItem.ComponentDestroy = ComponentDestroy
UISubscriptionItem.OnCreate = OnCreate
UISubscriptionItem.OnDestroy = OnDestroy
UISubscriptionItem.ReInit = ReInit
UISubscriptionItem.RefreshRewards = RefreshRewards
UISubscriptionItem.AddTimer = AddTimer
UISubscriptionItem.DeleteTimer = DeleteTimer
UISubscriptionItem.RefreshTime = RefreshTime
UISubscriptionItem.OnBuyBtnClick = OnBuyBtnClick
UISubscriptionItem.OnRewardBtnClick = OnRewardBtnClick
UISubscriptionItem.OnAddListener = OnAddListener
UISubscriptionItem.OnRemoveListener = OnRemoveListener
UISubscriptionItem.OnUpdateMonthCardInfo = OnUpdateMonthCardInfo
UISubscriptionItem.OnUpdateWeekCardInfo = OnUpdateWeekCardInfo
UISubscriptionItem.RefreshUI = RefreshUI
return UISubscriptionItem
