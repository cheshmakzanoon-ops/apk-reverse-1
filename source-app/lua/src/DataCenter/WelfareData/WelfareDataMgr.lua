require("DataCenter.WelfareData.WelfareTagInfo")
require("DataCenter.WelfareData.WelfareTagInfoCumulativeRecharge")
require("DataCenter.WelfareData.WelfareTagInfoMonthCard")
require("DataCenter.WelfareData.WelfareTagInfoPremiumPack")
require("DataCenter.WelfareData.WelfareTagInfoSpecialPack")
require("DataCenter.WelfareData.WelfareTagInfoSpecialPackStoreStyle")
require("DataCenter.WelfareData.WelfareTagInfoStorePack")
require("DataCenter.WelfareData.WelfareTagInfoVip1")
require("DataCenter.WelfareData.WelfareTagInfoWeekCard")
require("DataCenter.WelfareData.WelfareTagInfoRobotPack")
require("DataCenter.WelfareData.WelfareTagType")
require("DataCenter.WelfareData.WelfareTagInfoPiggyBank")
require("DataCenter.WelfareData.WelfareTagInfoSingleActivity")
require("DataCenter.WelfareData.WelfareTagInfoGoldBrickStore")
local Setting = CS.GameEntry.Setting
local SDKManager = CS.SDKManager
WelfareController = {}
local M = WelfareController
local tagInfos, tagInfosActivityType, selectedID, welfareCache, popupRecharges, packageRechargeMap
local afterInitSendGetGoldBrickInfo = false
local isGetGoldBrickInfo = false

function M.getPopupPacks()
  local list = {}
  local tagInfos = WelfareController.getShowTagInfos()
  for _, v in pairs(tagInfos) do
    if v:isSpecialPackTag() then
      table.insertto(list, v:getPopPackList(false))
    elseif v:getType() == WelfareTagType.PremiumPack then
      table.insertto(list, v:getPopPackList(false))
    end
  end
  M._sortByPopup(list)
  return list
end

function M._sortByPopup(t)
  if t == nil then
    return
  end
  table.sort(t, function(a, b)
    if a == nil then
      return false
    end
    if b == nil then
      return true
    end
    if a:getPopup() == b:getPopup() then
      return tonumber(a:getID()) > tonumber(b:getID())
    end
    return a:getPopup() > b:getPopup()
  end)
end

local NotShowTagTypes = {
  [WelfareTagType.Unknown] = true,
  [WelfareTagType.SpecialPack] = true,
  [WelfareTagType.SpecialPackNotPop] = true,
  [WelfareTagType.HeroMonthCard] = true,
  [WelfareTagType.Vip1] = true,
  [WelfareTagType.SpecialPackUnique] = true,
  [WelfareTagType.PvePack] = true,
  [WelfareTagType.FirstCharge] = true,
  [WelfareTagType.BuildQueueWeekCard] = true
}

function M.InitTagInfos()
  if tagInfos == nil then
    tagInfos = {}
    tagInfosActivityType = {}
    local allLines = DataCenter.RechargeManager:GetAllLines()
    for id, lineData in pairs(allLines) do
      if lineData.type == WelfareTagType.Activity then
      else
        local _modelClass = WelfareController.InitConfigTemplate(lineData.type)
        if _modelClass ~= nil then
          _modelClass:parse(lineData)
          table.insert(tagInfos, _modelClass)
        end
      end
    end
  end
end

function M.getShowTagInfos()
  M.InitTagInfos()
  local t = {}
  for _, v in ipairs(tagInfos) do
    local tempType = v:getType()
    if not NotShowTagTypes[tempType] and v:isShow(v:getID()) then
      table.insert(t, v)
    end
  end
  local nowList = DataCenter.ActivityListDataManager:GetActivityList()
  if nowList then
    for _, activity in pairs(nowList) do
      if activity:IsValid() and activity.isShowCenter == 0 and activity.entry_type and 0 < activity.entry_type then
        if tagInfosActivityType[activity.id] == nil then
          local _modelClass = WelfareController.InitConfigTemplate(WelfareTagType.SingleActivity)
          if _modelClass ~= nil then
            _modelClass:parse(activity)
            tagInfosActivityType[activity.id] = _modelClass
          end
        end
        table.insert(t, tagInfosActivityType[activity.id])
      end
    end
  end
  table.sort(t, function(a, b)
    if a == nil or b == nil then
      return false
    end
    if a:getOrder() == b:getOrder() then
      if a.type == WelfareTagType.SingleActivity and b.type == WelfareTagType.SingleActivity then
        if a._activityOrder and b._activityOrder then
          return a._activityOrder < b._activityOrder
        else
          return false
        end
      end
      return false
    end
    return a:getOrder() < b:getOrder()
  end)
  return t
end

function M.getShowTagInfosWithType(entry_Type)
  local t = {}
  t = M.getShowTagInfos()
  local filterdCanBuyList = {}
  local filterdList = {}
  for _, v in pairs(t) do
    if v:CanShow() and v:getEntryType() == entry_Type then
      if v:CanBuy() then
        table.insert(filterdCanBuyList, v)
      else
        table.insert(filterdList, v)
      end
    end
  end
  local resultList = {}
  table.insertto(resultList, filterdCanBuyList)
  table.insertto(resultList, filterdList)
  return resultList
end

function M.GetEntryTypeByRechargeType(type)
  local t = {}
  t = M.getShowTagInfos()
  for _, v in pairs(t) do
    if v:getType() == type then
      return v:getEntryType()
    end
  end
  return nil
end

function M.HasShowTag()
  local hasShowTag = false
  local allLines = DataCenter.RechargeManager:GetAllLines()
  for i, lineData in pairs(allLines) do
    if not hasShowTag then
      local type = lineData.type
      local pack = WelfareController.InitConfigTemplate(type)
      if pack ~= nil then
        pack:parse(lineData)
        if pack:isShow() and (type == WelfareTagType.PackStore or type == WelfareTagType.PremiumPack or type == WelfareTagType.RobotPack or type == WelfareTagType.WeeklyPackage or type == WelfareTagType.WeeklyPackageNew or type == WelfareTagType.HeroMedalPackage or type == WelfareTagType.SinglePack or type == WelfareTagType.PiggyBank or type == WelfareTagType.EnergyBank or type == WelfareTagType.ScrollPack or type == WelfareTagType.GrowthPlan or type == WelfareTagType.HeroMonthCardNew) then
          hasShowTag = true
        end
      end
    end
  end
  return hasShowTag
end

function M.getShowTagInfoByType(tagType)
  local infos = M.getShowTagInfos()
  if infos == nil or #infos < 1 then
    return nil
  end
  for _, v in ipairs(infos) do
    if v:getType() == tagType then
      return v
    end
  end
  return nil
end

function M.getShowTagInfoListByType(tagType)
  local list = {}
  local infos = M.getShowTagInfos()
  if not table.IsNullOrEmpty(infos) then
    for _, v in ipairs(infos) do
      if v:getType() == tagType then
        table.insert(list, v)
      end
    end
  end
  return list
end

function M.getShowTagInfoById(tagID)
  local infos = M.getShowTagInfos()
  if infos == nil or #infos < 1 then
    return nil
  end
  for _, v in ipairs(infos) do
    if tostring(v:getID()) == tagID then
      return v
    end
  end
  return nil
end

function M.setSelectedID(id)
  selectedID = id
end

function M.getSelectedID()
  return selectedID
end

function M.InitConfigTemplate(_cType)
  if _cType == nil then
    return nil
  end
  if type(_cType) == "string" then
    if string.IsNullOrEmpty(_cType) then
      return nil
    else
      _cType = tonumber(_cType)
    end
  end
  local tag
  if _cType == WelfareTagType.SpecialPack or _cType == WelfareTagType.SpecialPackUnique or _cType == WelfareTagType.SpecialPackNotPop then
    tag = require("DataCenter.WelfareData.WelfareTagInfoSpecialPack").New()
  elseif _cType == WelfareTagType.PremiumPack then
    tag = require("DataCenter.WelfareData.WelfareTagInfoPremiumPack").New()
  elseif _cType == WelfareTagType.PackStore then
    tag = require("DataCenter.WelfareData.WelfareTagInfoStorePack").New()
  elseif _cType == WelfareTagType.MonthCard then
    tag = require("DataCenter.WelfareData.WelfareTagInfoMonthCard").New()
  elseif _cType == WelfareTagType.HeroMedalPackage then
    tag = require("DataCenter.WelfareData.WelfareTagInfoHeroMedal").New()
  elseif _cType == WelfareTagType.WeeklyPackage then
    tag = require("DataCenter.WelfareData.WelfareTagInfoWeeklyPackage").New()
  elseif _cType == WelfareTagType.WeeklyPackageNew then
    tag = require("DataCenter.WelfareData.WelfareTagInfoWeeklyPackageNew").New()
  elseif _cType == WelfareTagType.WeekCard then
    tag = require("DataCenter.WelfareData.WelfareTagInfoWeekCardNew").New()
  elseif _cType == WelfareTagType.Vip1 then
    tag = require("DataCenter.WelfareData.WelfareTagInfoVip1").New()
  elseif _cType == WelfareTagType.CumulativeRecharge then
    tag = require("DataCenter.WelfareData.WelfareTagInfoCumulativeRecharge").New()
  elseif _cType == WelfareTagType.SpecialPackStoreStyle then
    tag = require("DataCenter.WelfareData.WelfareTagInfoSpecialPackStoreStyle").New()
  elseif _cType == WelfareTagType.RobotPack then
    tag = require("DataCenter.WelfareData.WelfareTagInfoRobotPack").New()
  elseif _cType == WelfareTagType.PiggyBank then
    tag = require("DataCenter.WelfareData.WelfareTagInfoPiggyBank").New()
  elseif _cType == WelfareTagType.EnergyBank then
    tag = require("DataCenter.WelfareData.WelfareTagInfoEnergyBank").New()
  elseif _cType == WelfareTagType.GrowthPlan then
    tag = require("DataCenter.WelfareData.WelfareTagInfoGrowthPlan").New()
  elseif _cType == WelfareTagType.ScrollPack then
    tag = require("DataCenter.WelfareData.WelfareTagInfoScrollPack").New()
  elseif _cType == WelfareTagType.HeroMonthCardNew then
    tag = require("DataCenter.WelfareData.WelfareTagHeroMonthCard").New()
  elseif _cType == WelfareTagType.DailyPackage then
    tag = require("DataCenter.WelfareData.WelfareTagInfoDailyPackage").New()
  elseif _cType == WelfareTagType.PvePack then
    tag = require("DataCenter.WelfareData.WelfareTagInfoPvePack").New()
  elseif _cType == WelfareTagType.DiamondShop then
    tag = require("DataCenter.WelfareData.DiamondShopPageTagInfo").New()
  elseif _cType == WelfareTagType.GoldBrickStore then
    tag = require("DataCenter.WelfareData.WelfareTagInfoGoldBrickStore").New()
  elseif _cType == WelfareTagType.BrickGiftPack then
    tag = require("DataCenter.WelfareData.WelfareTagInfoBrickGiftPack").New()
  elseif _cType == WelfareTagType.Activity then
    tag = require("DataCenter.WelfareData.WelfareTagInfoActivity").New()
  elseif _cType == WelfareTagType.DailyMustBuy then
    tag = require("DataCenter.WelfareData.WelfareTagInfoDailyMustBuy").New()
  elseif _cType == WelfareTagType.SingleActivity then
    tag = require("DataCenter.WelfareData.WelfareTagInfoSingleActivity").New()
  elseif _cType == WelfareTagType.PopRechargeCollect then
    tag = require("DataCenter.WelfareData.WelfareTagInfoPopCollectPackage")
  else
    tag = require("DataCenter.WelfareData.WelfareTagInfo").New()
  end
  return tag
end

function M.checkTagCanShow(type)
  local tagInfo = M.getShowTagInfoByType(type)
  if tagInfo == nil then
    return false
  end
  return tagInfo:isShow()
end

function M.openWelfarePop(packs)
  OpenGameUI("UIWelfarePopup", "UIResourcePopUp", {fromType = 2, giftpackInfos = packs})
end

function M.isSpecialPackTag(tagType)
  return tagType == WelfareTagType.SpecialPackStoreStyle or tagType == WelfareTagType.SpecialPack or tagType == WelfareTagType.SpecialPackUnique or tagType == WelfareTagType.SpecialPackNotPop
end

function M.setWelfareCache(key, info)
  if welfareCache == nil then
    welfareCache = {}
  end
  welfareCache[key] = info
end

function M.getWelfareCache(key)
  if welfareCache == nil then
    welfareCache = {}
  end
  return welfareCache[key]
end

function M.getTagInfoByActId(actId)
  local infos = M.getShowTagInfos()
  if infos == nil or #infos < 1 then
    return nil
  end
  for _, v in pairs(infos) do
    if v:getType() == WelfareTagType.SingleActivity and v._activityId and v._activityId == actId then
      return v
    end
  end
  return nil
end

function M.GetPacksMinRemainTime(packs)
  if table.IsNullOrEmpty(packs) then
    return
  end
  local minTime, packInfo
  minTime = LongMaxValue
  for i, v in ipairs(packs) do
    local tempPackage = v
    if not tempPackage:isBought() then
      local leftTime = tempPackage:getCountdown()
      if 1500 <= leftTime and minTime > leftTime then
        minTime = leftTime
        packInfo = tempPackage
      end
    end
  end
  return minTime, packInfo
end

function M.IsPopupIconCanShow(rechargeId)
  local packagesArr = GiftPackageData.GetAllAvailablePackageByRechargeId(rechargeId)
  if not packagesArr or #packagesArr == 0 then
    return false
  end
  local minTimeLeft, tempPackage = M.GetPacksMinRemainTime(packagesArr)
  if not tempPackage or not minTimeLeft then
    return false
  else
    return true, minTimeLeft
  end
end

function M.HasPopupPackage()
  for _, rechargeId in pairs(popupRecharges) do
    local isCanShow = M.IsPopupIconCanShow(rechargeId)
    if isCanShow then
      return true
    end
  end
end

function M.GetPopupPackages(targetEntryType)
  if popupRecharges == nil then
    popupRecharges = {}
    local allLines = DataCenter.RechargeManager:GetAllLines()
    for i, lineData in pairs(allLines) do
      if tonumber(lineData.type) == WelfareTagType.SpecialPack or tonumber(lineData.type) == WelfareTagType.SpecialPackNotPop then
        table.insert(popupRecharges, i)
      end
    end
  end
  local showPackages = {}
  local remainTimes = {}
  for i, rechargeId in pairs(popupRecharges) do
    local isCanShow, minLeftTime = M.IsPopupIconCanShow(rechargeId)
    local isTargetEntryType = true
    if targetEntryType then
      local lineData = DataCenter.RechargeManager:GetLine(rechargeId)
      if lineData and not string.IsNullOrEmpty(lineData.entry_type) and toInt(lineData.entry_type) ~= targetEntryType then
        isTargetEntryType = false
      end
    end
    if isCanShow and isTargetEntryType then
      table.insert(showPackages, rechargeId)
      remainTimes[rechargeId] = minLeftTime
    end
  end
  table.sort(showPackages, function(a, b)
    local orderA = DataCenter.RechargeManager:getStrValue(a, "order")
    local orderB = DataCenter.RechargeManager:getStrValue(b, "order")
    if orderA ~= orderB then
      return orderA < orderB
    end
    local aRemainTime = remainTimes[a]
    local bRemainTime = remainTimes[b]
    if aRemainTime == bRemainTime then
      return tonumber(a) < tonumber(b)
    else
      return aRemainTime < bRemainTime
    end
  end)
  return showPackages
end

function M.InitPackageRechargeMap()
  if packageRechargeMap == nil then
    packageRechargeMap = {}
    local allLines = DataCenter.RechargeManager:GetAllLines()
    for i, lineData in pairs(allLines) do
      local type = lineData.type
      type = tonumber(type)
      if type ~= WelfareTagType.Activity then
        local packStr = lineData.para1
        if not string.IsNullOrEmpty(packStr) then
          local packs = string.split(packStr, "|")
          for _, pack in pairs(packs) do
            if packageRechargeMap[pack] == nil then
              packageRechargeMap[pack] = {}
            end
            table.insert(packageRechargeMap[pack], i)
          end
        end
      end
    end
  end
end

function M.IsPackagePopUp(packageId)
  M.InitPackageRechargeMap()
  local rechargeIds = packageRechargeMap[packageId]
  if table.IsNullOrEmpty(rechargeIds) then
    return false
  end
  for _, rechargeId in pairs(rechargeIds) do
    local rechargeType = DataCenter.RechargeManager:getStrValue(rechargeId, "type")
    rechargeType = tonumber(rechargeType)
    if rechargeType == WelfareTagType.SpecialPack then
      return true, rechargeType, rechargeId
    end
  end
  return false
end

function M.GetPackageRecharges(packageId)
  M.InitPackageRechargeMap()
  local rechargeIds = packageRechargeMap[packageId]
  if table.IsNullOrEmpty(rechargeIds) then
    return nil
  end
  return rechargeIds
end

function M.getRechargeIdListByType(tagType)
  local list = {}
  M.InitTagInfos()
  for _, v in ipairs(tagInfos) do
    if v:getType() == tagType then
      table.insert(list, v:getID())
    end
  end
  return list
end

function M.EntryShowNewTag(entryType)
  if not entryType then
    return false
  end
  local SettingKey = string.format("%s_%s", SettingKeys.LASTTIME_REFRESH_STORE_NEW, entryType)
  local lastTime = Setting:GetString(SettingKey, "0")
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  local isSameDay = UITimeManager:GetInstance():IsSameDayForServer(tonumber(lastTime), curTime)
  if not isSameDay then
    return true
  end
  local rechargeList = M.getShowTagInfosWithType(entryType)
  for i, v in pairs(rechargeList) do
    if v.CanShowNewTag ~= nil and v:CanShowNewTag() == true then
      return true
    end
  end
  return false
end

function M.SetShowNewTagRecord(entryType)
  if not entryType then
    return
  end
  local SettingKey = string.format("%s_%s", SettingKeys.LASTTIME_REFRESH_STORE_NEW, entryType)
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  Setting:SetString(SettingKey, tostring(curTime))
end

function M.CanPopup(id)
  if not id then
    return false
  end
  id = tonumber(id)
  local template = DataCenter.RechargeManager:GetLine(id)
  if not template then
    return false
  end
  local popup_limit = template.showTimes
  if table.IsNullOrEmpty(popup_limit) then
    return true
  end
  local limitDay = popup_limit[1]
  local limitTimes = popup_limit[2]
  if 0 < limitDay and limitTimes and 0 < limitTimes then
    local curDay = UITimeManager:GetInstance():GetOpenServerDayByOpenServerZero()
    if limitDay <= curDay then
      return false
    end
    local timeKey = string.format("%s", SettingKeys.LASTTIME_POPUP_GIFTPACK, id)
    local lastTime = Setting:GetPrivateString(timeKey, "0")
    local curTime = UITimeManager:GetInstance():GetServerSeconds()
    local isSameDay = UITimeManager:GetInstance():IsSameDayForServer(tonumber(lastTime), curTime)
    if isSameDay then
      local timesKey = string.format("%s", SettingKeys.POPUP_GIFTPACK_TIMES, id)
      local times = Setting:GetInt(timesKey, 0)
      if limitTimes <= times then
        return false
      else
        return true
      end
    else
      return true
    end
  end
  return false
end

function M.GetPopupLimit(id)
  if not id then
    return 0, 0
  end
  id = tonumber(id)
  local template = DataCenter.RechargeManager:GetLine(id)
  if not template then
    return 0, 0
  end
  local popup_limit = template.showTimes
  if table.IsNullOrEmpty(popup_limit) then
    return 0, 0
  end
  local limitDay = popup_limit[1]
  local limitTimes = popup_limit[2]
  return limitDay, limitTimes
end

function M.AddPopupTimes(id)
  if not id then
    return
  end
  id = tonumber(id)
  local timeKey = string.format("%s", SettingKeys.LASTTIME_POPUP_GIFTPACK, id)
  local lastTime = Setting:GetPrivateString(timeKey, "0")
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  local isSameDay = UITimeManager:GetInstance():IsSameDayForServer(tonumber(lastTime), curTime)
  local timesKey = string.format("%s", SettingKeys.POPUP_GIFTPACK_TIMES, id)
  if not isSameDay then
    Setting:SetPrivateString(timeKey, tostring(curTime))
    Setting:SetInt(timesKey, 1)
  else
    local times = Setting:GetInt(timesKey, 0)
    Setting:SetInt(timesKey, times + 1)
  end
end

local GoldBrickStoreItem = {
  goods_id = "",
  currency_symbol = "",
  amount = "",
  pay_brick_num = 0,
  free_brick_num = 0
}

function M.GetGoldBrickIcon(goldBrickItem)
  local path = "Assets/Main/Sprites/UI/LWGoldBrick/lrb_pc_Goldbricks_"
  local goods_id = goldBrickItem.goods_id
  if goods_id == "goods_1" then
    path = path .. "01.png"
  elseif goods_id == "goods_2" then
    path = path .. "02.png"
  elseif goods_id == "goods_3" then
    path = path .. "03.png"
  elseif goods_id == "goods_4" then
    path = path .. "04.png"
  elseif goods_id == "goods_5" then
    path = path .. "05.png"
  elseif goods_id == "goods_6" then
    path = path .. "06.png"
  elseif goods_id == "goods_7" then
    path = path .. "07.png"
  else
    path = path .. "00.png"
  end
  return path
end

local gold_brick_list = {}
local MAX_BUY_BRICK_NUM = 1000000

function M.GenerateGoldBrickList(data)
  gold_brick_list = {}
  if data and data.goodsInfo then
    for _, v in ipairs(data.goodsInfo) do
      local item = {
        goods_id = v.goods_id,
        currency_symbol = v.currency_symbol,
        amount = v.amount,
        pay_brick_num = v.pay_brick_num,
        free_brick_num = v.free_brick_num
      }
      table.insert(gold_brick_list, item)
    end
  end
end

function M.GetGoldBrickList()
  return gold_brick_list
end

function M.IsShowGoldBrickStoreSystem()
  local system = LuaEntry.DataConfig:TryGetStr("gold_brick_shop_phone", "k1")
  if not system or system == "" then
    return false
  end
  local splits = string.split(system, ";")
  local isIOS = SDKManager.IS_UNITY_IPHONE()
  local isGP = SDKManager.IS_UNITY_ANDROID()
  for _, v in ipairs(splits) do
    if v == "1" and isIOS then
      return true
    end
    if v == "2" and isGP then
      return true
    end
  end
  return false
end

function M.IsShowGoldBrickStoreRegion()
  local regions = LuaEntry.DataConfig:TryGetStr("gold_brick_shop_phone", "k2")
  if not regions or regions == "" then
    return false
  end
  local splits = string.split(regions, ";")
  local storefront = DataCenter.PayManager:GetStorefrontCode()
  if not storefront or storefront == "" then
    return false
  end
  storefront = string.upper(storefront)
  for _, v in ipairs(splits) do
    if v == "all" then
      return true
    end
    if v == storefront then
      return true
    end
  end
  return false
end

local function __GoldBrickSwitchOn()
  if not (LuaEntry and LuaEntry.DataConfig) or not LuaEntry.DataConfig.CheckSwitch then
    return false
  end
  return LuaEntry.DataConfig:CheckSwitch("gold_brick_shop_phone_on")
end

function M.IsNotReviewVersion()
  return not CS.GameEntry.Setting.IsReview
end

function M.CanOpenGoldBrickStoreByServer()
  if not LuaEntry.Player then
    return false
  end
  return LuaEntry.Player:GetGoldBrickSwitch()
end

function M.CanOpenGoldBrickStore()
  if Config.IsPC() then
    return gold_brick_list ~= nil and 0 < #gold_brick_list
  end
  local isVietnam = CS.GameEntry.Sdk:IsVNPlatform()
  if isVietnam then
    return false
  end
  if __GoldBrickSwitchOn() and M.IsShowGoldBrickStoreSystem() and M.IsShowGoldBrickStoreRegion() and M.CanOpenGoldBrickStoreByServer() and M.IsNotReviewVersion() then
    return true
  end
  return false
end

function M.GetGoldBrickItemById(goods_id)
  if not goods_id or goods_id == "" then
    return nil
  end
  for _, item in ipairs(gold_brick_list) do
    if item.goods_id == goods_id then
      return item
    end
  end
  return nil
end

function M.GetGoldBrickItemByCount(count)
  if not count or count <= 0 then
    return nil
  end
  for _, item in ipairs(gold_brick_list) do
    if item.pay_brick_num == count then
      return item
    end
  end
  return nil
end

function M.GetGoldBrickItemByAtLeastCount(count)
  if not count or count <= 0 then
    return nil
  end
  local ret
  for _, item in ipairs(gold_brick_list) do
    if count <= item.pay_brick_num and (not ret or item.pay_brick_num < ret.pay_brick_num) then
      ret = item
    end
  end
  return ret
end

function M.GetGoldBrickBuyLimit()
  return MAX_BUY_BRICK_NUM
end

function M.ResetGoldBrickInfoState()
  afterInitSendGetGoldBrickInfo = false
  isGetGoldBrickInfo = false
end

function M.SetAfterInitSendGetGoldBrickInfo(bl)
  afterInitSendGetGoldBrickInfo = bl
end

function M.IsAfterInitSendGetGoldBrickInfo()
  return afterInitSendGetGoldBrickInfo
end

function M.SetGetGoldBrickInfo(bl)
  isGetGoldBrickInfo = bl
end

function M.IsGetGoldBrickInfo()
  return isGetGoldBrickInfo
end

return M
