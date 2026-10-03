local MonthCardNewManager = BaseClass("MonthCardNewManager")
local TruckMonthCardPrivilege = require("DataCenter.MonthCardNewManager.TruckMonthCardPrivilege")

local function __init(self)
  self.golloesMonthCard = nil
  self.expiredFormationData = nil
  self.truckMonthCardPrivilege = nil
  self:AddListener()
end

local function __delete(self)
  self.golloesMonthCard = nil
  self.expiredFormationData = nil
  self.truckMonthCardPrivilege = nil
  self:RemoveListener()
end

local function AddListener(self)
  EventManager:GetInstance():AddListener(EventId.OnPackageInfoUpdated, self.ResetGolloesMonthCardPack)
end

local function ResetGolloesMonthCardPack()
  local manager = DataCenter.MonthCardNewManager
  if manager.golloesMonthCard then
    manager.golloesMonthCard.packageData = GiftPackageData.get(manager.golloesMonthCard.monthCardId)
  end
end

local function RemoveListener(self)
  EventManager:GetInstance():RemoveListener(EventId.OnPackageInfoUpdated, self.ResetGolloesMonthCardPack)
end

local function InitGolloesMonthCard(self, message)
  if not self.golloesMonthCard then
    self.golloesMonthCard = MonthCardNewInfo.New()
    local allLines = DataCenter.RechargeManager:GetAllLines()
    for i, lineData in pairs(allLines) do
      local tempType = lineData.type
      if tempType == WelfareTagType.MonthCard then
        local tempId = lineData.para1
        self.golloesMonthCard:SetMonthCardId(tempId)
      end
    end
  end
  if not message then
    return
  end
  if not message.golloesMonthCard then
    return
  end
  self.golloesMonthCard:ParseData(message.golloesMonthCard)
  if message.truckMonthCardPrivilege then
    self:UpdateMonthCardPrivilege(message.truckMonthCardPrivilege)
  end
end

local function UpdateMonthCardData(self, message)
  if not message then
    return
  end
  if message.golloesMonthCard then
    if not self.golloesMonthCard then
      self.golloesMonthCard = MonthCardNewInfo.New()
    end
    self.golloesMonthCard:ParseData(message.golloesMonthCard)
  end
  if message.gold then
    LuaEntry.Player.gold = message.gold
    EventManager:GetInstance():Broadcast(EventId.UpdateGold)
  end
  EventManager:GetInstance():Broadcast(EventId.MonthCardInfoUpdated)
  EventManager:GetInstance():Broadcast(EventId.RefreshWelfareRedDot)
end

local function GetGolloesMonthCard(self)
  return self.golloesMonthCard
end

local function CheckIfMonthCardActive(self)
  if self.golloesMonthCard and self.golloesMonthCard:IsBought() then
    return true
  else
    return false
  end
end

local function CheckIfHasGolloesGift(self)
  if not self:CheckIfMonthCardActive() then
    return false
  end
  return not self.golloesMonthCard:IsTodayClaimed()
end

local function GetGolloesHeadBg(self)
end

local function CheckIfGolloesMonthCardAvailable(self)
  return self.golloesMonthCard and self.golloesMonthCard.packageData
end

local function ShowSubscriptionBubble(self)
  local weekCardTag = WelfareController.getShowTagInfoByType(WelfareTagType.WeekCard)
  local monthCardTag = WelfareController.getShowTagInfoByType(WelfareTagType.MonthCard)
  if weekCardTag and not weekCardTag:isShow() then
    return false
  end
  if monthCardTag and not monthCardTag:isShow() then
    return false
  end
  local weekCard = DataCenter.WeekCardManager:GetWeekCardList()
  local monthCard = DataCenter.MonthCardNewManager:GetGolloesMonthCard()
  local hasActiveSubscription = false
  if weekCard and 0 < #weekCard then
    for i, v in pairs(weekCard) do
      v:RefreshStatus()
      local status = v:GetStatus()
      if status ~= WeekCardPackageStatus.CanBuy then
        hasActiveSubscription = true
      end
      if status == WeekCardPackageStatus.CanClaim then
        return true
      end
    end
  end
  if monthCard then
    hasActiveSubscription = hasActiveSubscription or monthCard:IsBought()
    if monthCard:IsBought() and not monthCard:IsTodayClaimed() then
      return true
    end
  end
  local isFunctionOn = LuaEntry.DataConfig:CheckSwitch("free_chest_receive")
  if isFunctionOn then
    if GiftPackageData.CheckIfHasFreeWeeklyPackage() then
      return true
    end
    if DataCenter.WeekCardManager:CheckIfHasFreeReward() then
      return true
    end
    local seasonConfig = DataCenter.SeasonDataManager:GetSeasonConfig()
    if seasonConfig then
      local cardId = tonumber(seasonConfig.week_card)
      local cardData = DataCenter.SeasonPeriodicCardManager:GetCardData(cardId)
      if cardData then
        local isOpenSeasonCard = DataCenter.ActivityListDataManager:CheckIfActivityOpen(EnumActivity.SeasonPeriodicCard.Type)
        if isOpenSeasonCard and not cardData:IsTodayClaimedFree() then
          return true
        end
        if cardData:IsBought() and isOpenSeasonCard and not cardData:IsTodayClaimed() then
          return true
        end
      end
    end
  end
  if hasActiveSubscription then
    return false
  end
  local todayShow = DataCenter.SecondConfirmManager:GetTodayCanShowSecondConfirm(TodayNoSecondConfirmType.ShowSubscriptionBubble)
  if todayShow then
    return true
  end
  return false
end

function MonthCardNewManager:CheckExistInMonthlyCardCfg(itemId)
  if itemId == nil then
    return false
  end
  if self.MonthlyCardIdList == nil then
    self.MonthlyCardIdList = {}
    LocalController:instance():visitTable("monthcard", function(id, lineData)
      local id = tonumber(lineData:getValue("id")) or 0
      table.insert(self.MonthlyCardIdList, id)
    end)
  end
  for i = 1, #self.MonthlyCardIdList do
    if self.MonthlyCardIdList[i] == itemId then
      return true
    end
  end
  return false
end

function MonthCardNewManager:GetExpiredFormationData()
  return self.expiredFormationData
end

function MonthCardNewManager:SetExpiredFormationData(data)
  self.expiredFormationData = data
end

function MonthCardNewManager:AbandonExpiredFormation()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIExpiredMonthlyCardRecover)
  UIUtil.ShowMessage(CS.GameEntry.Localization:GetString("weekcard_squad_save_desc_6"), 1, "weekcard_squad_save_button_4", "", function()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.LWBuyDiamond, {anim = false})
    local buildingData = DataCenter.BuildManager:GetBuildingDatasByBuildingId(BuildingTypes.LW_BUILD_PARKINGLOT_FOUR)[1]
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPVPFormation, {anim = true}, EnterHeroSquadPanelWay.ExpiredMonthlyCard, buildingData.uuid)
  end, nil, nil, "weekcard_squad_save_title_3")
end

function MonthCardNewManager:RecoverExpiredFormation(data)
  if data == nil then
    return
  end
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIExpiredMonthlyCardRecover)
  if data.complete == 0 then
    UIUtil.ShowMessage(CS.GameEntry.Localization:GetString("weekcard_squad_save_desc_4"), 1, "weekcard_squad_save_button_4", "", function()
      UIManager:GetInstance():DestroyWindow(UIWindowNames.LWBuyDiamond, {anim = false})
      local buildingData = DataCenter.BuildManager:GetBuildingDatasByBuildingId(BuildingTypes.LW_BUILD_PARKINGLOT_FOUR)[1]
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPVPFormation, {anim = true}, EnterHeroSquadPanelWay.ExpiredMonthlyCard, buildingData.uuid)
    end, nil, nil, "weekcard_squad_save_title_1")
  elseif data.complete == 1 then
    UIUtil.ShowMessage(CS.GameEntry.Localization:GetString("weekcard_squad_save_desc_3"), 1, "weekcard_squad_save_button_3", "", function()
      UIManager:GetInstance():DestroyWindow(UIWindowNames.LWBuyDiamond, {anim = false})
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWCityDefence)
    end, nil, nil, "weekcard_squad_save_title_1")
  end
  DataCenter.ArmyFormationDataManager:UpdateArmyFormationListData(data.formation)
  EventManager:GetInstance():Broadcast(EventId.ArmyFormatUpdate)
  EventManager:GetInstance():Broadcast(EventId.GF_hero_squad_saved, data.formation.index)
end

function MonthCardNewManager:UpdateMonthCardPrivilege(t)
  if self.truckMonthCardPrivilege == nil then
    self.truckMonthCardPrivilege = TruckMonthCardPrivilege.New()
  end
  self.truckMonthCardPrivilege:ParseData(t)
end

function MonthCardNewManager:GetMonthCardPrivilege()
  return self.truckMonthCardPrivilege
end

function MonthCardNewManager:IsOpenTruckInsurance()
  if not self:CheckIfGolloesMonthCardAvailable() then
    return false
  end
  local activityOpen = DataCenter.ActivityListDataManager:CheckIfActivityOpen(EnumActivity.MonthCardInsurance.Type)
  local fogUnlocked = not DataCenter.LWMyStationDataManager:IsTruckFunctionLock()
  return activityOpen and fogUnlocked
end

function MonthCardNewManager:IsShowTruckInsuranceRedDot()
  if not self:CheckIfGolloesMonthCardAvailable() then
    return false
  end
  if self.truckMonthCardPrivilege == nil then
    return false
  end
  local canClaimFreeReward = #self.truckMonthCardPrivilege:GetFreeReward() > 0
  local isOpen = DataCenter.MonthCardNewManager:CheckIfMonthCardActive()
  local canClaimMonthCardReward = isOpen and 0 < #self.truckMonthCardPrivilege:GetVipReward()
  return canClaimFreeReward or canClaimMonthCardReward
end

function MonthCardNewManager:IsTruckInsuranceToLimit()
  if not self:CheckIfGolloesMonthCardAvailable() then
    return false
  end
  return self:IsTruckInsuranceToLimit_Free() or self:IsTruckInsuranceToLimit_MonthCard()
end

function MonthCardNewManager:IsTruckInsuranceToLimit_Free()
  if self.truckMonthCardPrivilege == nil or self.golloesMonthCard == nil then
    return false
  end
  local curFreeTimes = self.truckMonthCardPrivilege:GetFreeTimes()
  local monthCardCfg = self.golloesMonthCard:GetMonthCardCfg()
  return curFreeTimes >= monthCardCfg.free_limit
end

function MonthCardNewManager:IsTruckInsuranceToLimit_MonthCard()
  if self.truckMonthCardPrivilege == nil or self.golloesMonthCard == nil then
    return false
  end
  local curVipTimes = self.truckMonthCardPrivilege:GetVipTimes()
  local monthCardCfg = self.golloesMonthCard:GetMonthCardCfg()
  return curVipTimes >= monthCardCfg.pay_limit, monthCardCfg.pay_limit
end

MonthCardNewManager.__init = __init
MonthCardNewManager.__delete = __delete
MonthCardNewManager.UpdateMonthCardData = UpdateMonthCardData
MonthCardNewManager.InitGolloesMonthCard = InitGolloesMonthCard
MonthCardNewManager.GetGolloesMonthCard = GetGolloesMonthCard
MonthCardNewManager.CheckIfMonthCardActive = CheckIfMonthCardActive
MonthCardNewManager.GetGolloesHeadBg = GetGolloesHeadBg
MonthCardNewManager.CheckIfHasGolloesGift = CheckIfHasGolloesGift
MonthCardNewManager.CheckIfGolloesMonthCardAvailable = CheckIfGolloesMonthCardAvailable
MonthCardNewManager.AddListener = AddListener
MonthCardNewManager.RemoveListener = RemoveListener
MonthCardNewManager.ResetGolloesMonthCardPack = ResetGolloesMonthCardPack
MonthCardNewManager.ShowSubscriptionBubble = ShowSubscriptionBubble
return MonthCardNewManager
