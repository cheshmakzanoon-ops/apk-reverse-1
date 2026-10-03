local base = UIBaseView
local UISubscriptionListPanelView = BaseClass("UISubscriptionListPanelView", base)
local Localization = CS.GameEntry.Localization
local UISubscriptionItem = require("UI.UISubscriptionListPanel.Component.UISubscriptionItem")
local backBtnPath = "Root/BottomBar/BtnBack"
local claimAllBtnPath = "Root/BottomBar/ClaimAllBtn"
local subsItemListPath = "Root/MiddleContentContainer/SubsList"

local function OnItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.subsList:AddComponent(UISubscriptionItem, itemObj)
  local reward = self.subsData[index]
  cellItem:ReInit(reward)
end

local function OnItemMoveOut(self, itemObj, index)
  self.subsList:RemoveComponent(itemObj.name, UISubscriptionItem)
end

local function ClearScroll(self)
  if self.subsList then
    self.subsList:ClearCells()
    self.subsList:RemoveComponents(UISubscriptionItem)
  end
end

local function CollectSubscriptions(self)
  self.subsData = {}
  local isFunctionOn = LuaEntry.DataConfig:CheckSwitch("free_chest_receive")
  if isFunctionOn then
    local weekCardTag = WelfareController.getShowTagInfoByType(WelfareTagType.WeekCard)
    if weekCardTag and weekCardTag:isShow() then
      local subsInfo = {}
      subsInfo.type = SubscriptionItemType.FreeGift_Weekly
      table.insert(self.subsData, subsInfo)
    end
    local isOpenSeasonCard = DataCenter.ActivityListDataManager:CheckIfActivityOpen(EnumActivity.SeasonPeriodicCard.Type)
    local seasonConfig = DataCenter.SeasonDataManager:GetSeasonConfig()
    if seasonConfig and isOpenSeasonCard then
      local cardId = tonumber(seasonConfig.week_card)
      local cardData = DataCenter.SeasonPeriodicCardManager:GetCardData(cardId)
      if cardData then
        local subsInfo = {}
        subsInfo.type = SubscriptionItemType.FreeGift_SeasonWeekly
        subsInfo.detailData = cardData
        table.insert(self.subsData, subsInfo)
      end
    end
    local subsInfo = {}
    subsInfo.type = SubscriptionItemType.FreeGift_Daily
    table.insert(self.subsData, subsInfo)
  end
  local monthCardTag = WelfareController.getShowTagInfoByType(WelfareTagType.MonthCard)
  if monthCardTag and monthCardTag:isShow() then
    local monthCard = DataCenter.MonthCardNewManager:GetGolloesMonthCard()
    if monthCard then
      local subsInfo = {}
      subsInfo.type = SubscriptionItemType.Monthly
      subsInfo.detailData = monthCard
      table.insert(self.subsData, subsInfo)
    end
  end
  if isFunctionOn then
    local isOpenSeasonCard = DataCenter.ActivityListDataManager:CheckIfActivityOpen(EnumActivity.SeasonPeriodicCard.Type)
    local seasonConfig = DataCenter.SeasonDataManager:GetSeasonConfig()
    if seasonConfig and isOpenSeasonCard then
      local cardId = tonumber(seasonConfig.week_card)
      local cardData = DataCenter.SeasonPeriodicCardManager:GetCardData(cardId)
      if cardData then
        local subsInfo = {}
        subsInfo.type = SubscriptionItemType.SeasonWeekly
        subsInfo.detailData = cardData
        table.insert(self.subsData, subsInfo)
      end
    end
  end
  local weekCardTag = WelfareController.getShowTagInfoByType(WelfareTagType.WeekCard)
  if weekCardTag and weekCardTag:isShow() then
    local weekCardList = DataCenter.WeekCardManager:GetWeekCardList()
    if weekCardList then
      for i, v in ipairs(weekCardList) do
        local subsInfo = {}
        subsInfo.type = SubscriptionItemType.Weekly
        subsInfo.detailData = v
        table.insert(self.subsData, subsInfo)
      end
    end
  end
end

local function RefreshClaimAllBtn(self)
  if self.subsData then
    local isShow = false
    for i, v in pairs(self.subsData) do
      if v.type == SubscriptionItemType.Monthly then
        if v.detailData:IsBought() and not v.detailData:IsTodayClaimed() then
          isShow = true
          break
        end
      elseif v.type == SubscriptionItemType.Weekly then
        v.detailData:RefreshStatus()
        local status = v.detailData:GetStatus()
        if status == WeekCardPackageStatus.CanClaim then
          isShow = true
          break
        end
      elseif v.type == SubscriptionItemType.FreeGift_Daily then
        if GiftPackageData.CheckIfHasFreeWeeklyPackage() then
          isShow = true
          break
        end
      elseif v.type == SubscriptionItemType.FreeGift_SeasonWeekly then
        local isOpenSeasonCard = DataCenter.ActivityListDataManager:CheckIfActivityOpen(EnumActivity.SeasonPeriodicCard.Type)
        if isOpenSeasonCard and not v.detailData:IsTodayClaimedFree() then
          isShow = true
          break
        end
      elseif v.type == SubscriptionItemType.FreeGift_Weekly then
        if DataCenter.WeekCardManager:CheckIfHasFreeReward() then
          isShow = true
          break
        end
      elseif v.type == SubscriptionItemType.SeasonWeekly then
        local isOpenSeasonCard = DataCenter.ActivityListDataManager:CheckIfActivityOpen(EnumActivity.SeasonPeriodicCard.Type)
        if v.detailData:IsBought() and isOpenSeasonCard and not v.detailData:IsTodayClaimed() then
          isShow = true
          break
        end
      end
    end
    self.claimAllBtn:SetActive(isShow)
  end
end

local function OnClaimAllBtnClick(self)
  if self.subsData then
    local cardId = 0
    local seasonConfig = DataCenter.SeasonDataManager:GetSeasonConfig()
    if seasonConfig then
      cardId = tonumber(seasonConfig.week_card) or 0
    end
    SFSNetwork.SendMessage(MsgDefines.ClaimSubscriptionsReward, cardId)
    self.claimAllBtn:SetActive(false)
  end
end

local function RefreshScroll(self)
  if self.subsList then
    self:ClearScroll()
    if #self.subsData > 0 then
      self.subsList:SetTotalCount(#self.subsData)
      self.subsList:RefillCells()
    end
  end
end

local function RefreshView(self)
  self:CollectSubscriptions()
  RefreshScroll(self)
  RefreshClaimAllBtn(self)
end

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
end

local function OnDestroy(self)
  ClearScroll(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.backBtn = self:AddComponent(UIButton, backBtnPath)
  self.backBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.claimAllBtn = self:AddComponent(UIButton, claimAllBtnPath)
  self.claimAllBtn:SetOnClick(function()
    self:OnClaimAllBtnClick()
  end)
  self.subsList = self:AddComponent(UIScrollView, subsItemListPath)
  self.subsList:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.subsList:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
end

local function ComponentDestroy(self)
  self.backBtn = nil
  self.claimAllBtn = nil
  self.subsList = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.subsData = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.MonthCardInfoUpdated, self.RefreshClaimAllBtn)
  self:AddUIListener(EventId.OnWeekCardInfoChange, self.RefreshClaimAllBtn)
  self:AddUIListener(EventId.OnPassDay, self.RefreshView)
  self:AddUIListener(EventId.UpdateWeekCardFreeGiftData, self.RefreshClaimAllBtn)
  self:AddUIListener(EventId.FreeWeeklyPackage, self.RefreshClaimAllBtn)
  self:AddUIListener(EventId.LWSeasonWeekCardFreeRewardUpdate, self.RefreshClaimAllBtn)
  self:AddUIListener(EventId.LWSeasonWeekCardDailyRewardUpdate, self.RefreshClaimAllBtn)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.MonthCardInfoUpdated, self.RefreshClaimAllBtn)
  self:RemoveUIListener(EventId.OnWeekCardInfoChange, self.RefreshClaimAllBtn)
  self:RemoveUIListener(EventId.OnPassDay, self.RefreshView)
  self:RemoveUIListener(EventId.UpdateWeekCardFreeGiftData, self.RefreshClaimAllBtn)
  self:RemoveUIListener(EventId.FreeWeeklyPackage, self.RefreshClaimAllBtn)
  self:RemoveUIListener(EventId.LWSeasonWeekCardFreeRewardUpdate, self.RefreshClaimAllBtn)
  self:RemoveUIListener(EventId.LWSeasonWeekCardDailyRewardUpdate, self.RefreshClaimAllBtn)
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
end

UISubscriptionListPanelView.OnCreate = OnCreate
UISubscriptionListPanelView.OnDestroy = OnDestroy
UISubscriptionListPanelView.CollectSubscriptions = CollectSubscriptions
UISubscriptionListPanelView.ClearScroll = ClearScroll
UISubscriptionListPanelView.OnItemMoveIn = OnItemMoveIn
UISubscriptionListPanelView.OnItemMoveOut = OnItemMoveOut
UISubscriptionListPanelView.OnAddListener = OnAddListener
UISubscriptionListPanelView.OnRemoveListener = OnRemoveListener
UISubscriptionListPanelView.ComponentDefine = ComponentDefine
UISubscriptionListPanelView.ComponentDestroy = ComponentDestroy
UISubscriptionListPanelView.DataDefine = DataDefine
UISubscriptionListPanelView.DataDestroy = DataDestroy
UISubscriptionListPanelView.OnEnable = OnEnable
UISubscriptionListPanelView.OnDisable = OnDisable
UISubscriptionListPanelView.RefreshScroll = RefreshScroll
UISubscriptionListPanelView.RefreshClaimAllBtn = RefreshClaimAllBtn
UISubscriptionListPanelView.OnClaimAllBtnClick = OnClaimAllBtnClick
UISubscriptionListPanelView.RefreshView = RefreshView
return UISubscriptionListPanelView
