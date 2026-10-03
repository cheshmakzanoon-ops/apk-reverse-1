require("DataCenter.GiftPackageData.GiftPackConst")
require("DataCenter.GiftPackageData.GiftPackInfoBase")
require("DataCenter.GiftPackageData.GiftPackInfoDefault")
GiftPackManager = {}
local M = GiftPackManager
local Timer = CS.GameEntry.Timer
local _inited = false
local _packDict = {}
local _weeklyFreePackage
local _weeklyFreePackageClaimT = 0
local _heroMedalPackList
local _buildingDict = {}
local WeeklyFreePackage = {
  is_show = "4",
  popup_image_mini = "icon_WeeklyPackage04",
  item = "210316;40|210121;10|210131;10"
}
local _groupPackDict = {}
local _nextReInitTime = 0
local _nextEndPackId = 0
local _lastInitTime = 0
local _timer, _dayTimer
local _sendExchangeTimes = {}

function M.CheckSendExchangeTimes(logMsg)
  local curSec = UITimeManager:GetInstance():GetServerSeconds()
  if 0 < #_sendExchangeTimes then
    for i = #_sendExchangeTimes, 1, -1 do
      if 60 < curSec - _sendExchangeTimes[i] then
        table.remove(_sendExchangeTimes, i)
      end
    end
  end
  table.insert(_sendExchangeTimes, curSec)
  if 10 < #_sendExchangeTimes then
    local msg = string.format([[
Too many times to send message "MsgDefines.ExchangeInfo" in one minute:
 %s
 Timestamp:%s]], logMsg, curSec)
    CommonUtil.SendErrorMessageToServer(curSec, curSec, msg)
    Logger.LogError(msg)
    _sendExchangeTimes = {}
  end
end

function M.InitPackageReq()
  SFSNetwork.SendMessage(MsgDefines.ExchangeInfo)
end

local DAY_END_TIME_RANGE = 500

function M.CheckPackEndTime(pack, curTime, endOfServerDayTime, startTimer)
  if not pack then
    return
  end
  local _endOfServerDayTime = endOfServerDayTime
  if _endOfServerDayTime == nil then
    _endOfServerDayTime = UITimeManager:GetInstance():GetNextDayMs()
  end
  local _curTime = curTime
  if _curTime == nil then
    _curTime = UITimeManager:GetInstance():GetServerTime()
  end
  local prevNextEndTime = _nextReInitTime
  local endTime = pack:getEndTime()
  if _curTime < endTime and endTime < _nextReInitTime then
    if _endOfServerDayTime <= endTime and endTime < _endOfServerDayTime + DAY_END_TIME_RANGE then
      return
    end
    _nextReInitTime = endTime
    _nextEndPackId = pack:getID()
  end
  if startTimer and _timer == nil and 0 < _nextReInitTime then
    _timer = TimerManager:GetInstance():GetTimer(1, M.TimerAction, nil, false, false, false)
    _timer:Start()
  end
end

function M.OnUpdatePack(pack)
  if not pack then
    return
  end
  local group = pack:getGroup()
  if not _groupPackDict[group] then
    _groupPackDict[group] = {}
  end
  _groupPackDict[group][pack:getID()] = pack
end

function M.InitPackage(message)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  _nextReInitTime = 0
  _nextEndPackId = 0
  local exchange = message.exchange
  if exchange ~= nil then
    M._clear()
    if table.IsNullOrEmpty(exchange) then
      pcall(function()
        Logger.LogInfo("GiftPackManager.InitPackage: exchange is empty")
      end)
    end
    local endOfServerDayTime = UITimeManager:GetInstance():GetNextDayMs()
    for _, v in ipairs(exchange) do
      local packType = tonumber(v.type)
      local pack = M._create(packType)
      if pack then
        pack:update(v)
        _packDict[pack:getID()] = pack
        if pack:isGrowthPlanPack() then
          SFSNetwork.SendMessage(MsgDefines.GrowthPlanGetInfo)
        end
        M.CheckPackEndTime(pack, curTime, endOfServerDayTime)
        M.OnUpdatePack(pack)
      end
    end
    EventManager:GetInstance():BroadcastDeferred(EventId.OnPackageInfoUpdated)
    EventManager:GetInstance():Broadcast(EventId.UpdateGiftPackData)
    DataCenter.LoginPopManager:NoticeInitPackage()
    _lastInitTime = UITimeManager:GetInstance():GetServerTime()
    if 0 < _nextReInitTime then
      if _timer ~= nil then
        _timer:Stop()
      end
      _timer = TimerManager:GetInstance():GetTimer(1, M.TimerAction, nil, false, false, false)
      _timer:Start()
    end
    if _dayTimer ~= nil then
      _dayTimer:Stop()
    end
    _dayTimer = TimerManager:GetInstance():GetTimer(1, M.DayTimerAction, nil, false, false, false)
    _dayTimer:Start()
  end
end

function M.TimerAction()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime >= _nextReInitTime then
    M.InitPackageReq()
    if _timer ~= nil then
      _timer:Stop()
    end
    local pack = _packDict[_nextEndPackId]
    local idStr = pack and pack:getID() or "?"
    local endTimeStr = pack and pack:getEndTime() or "?"
    M.CheckSendExchangeTimes(string.format("Pack ended, n_id: %s, n_et: %s, p_id: %s, p_et: %s", _nextEndPackId, _nextReInitTime, idStr, endTimeStr))
  end
end

function M.DayTimerAction()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local sameDay = UITimeManager:GetInstance():IsSameDayForServer(curTime // 1000, _lastInitTime // 1000)
  if not sameDay then
    M.InitPackageReq()
    if _dayTimer ~= nil then
      _dayTimer:Stop()
    end
    M.CheckSendExchangeTimes(string.format("Day ended, lt: %s", _lastInitTime))
  end
end

function M.init(message)
  if message == nil then
    return
  end
  if not _inited then
    _inited = true
    M._addListener()
  end
  if message.weekFreeReward then
    local tempData = message.weekFreeReward
    M.InitWeeklyFreePackage()
    _weeklyFreePackageClaimT = tempData.lastRewardTime
    _weeklyFreePackage.rewards = tempData.reward
    table.sort(_weeklyFreePackage.rewards, function(a, b)
      if a.type ~= b.type then
        if a.type == RewardType.GOLD then
          return true
        elseif b.type == RewardType.GOLD then
          return false
        end
      else
        return false
      end
    end)
  end
  local buildingGiftNotBought = message.buildingGiftNotBought
  if not string.IsNullOrEmpty(buildingGiftNotBought) then
    _buildingDict = {}
    local arr = string.split(buildingGiftNotBought, "|")
    for _, v in ipairs(arr) do
      if not string.IsNullOrEmpty(v) then
        _buildingDict[v] = true
      end
    end
  end
  EventManager:GetInstance():BroadcastDeferred(EventId.OnPackageInfoUpdated)
  EventManager:GetInstance():Broadcast(EventId.UpdateGiftPackData)
end

function M.pushPack(message)
  if message == nil then
    return
  end
  local exchange = message.exchange
  if exchange == nil then
    return
  end
  local monopolyLandPackage = false
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local endOfServerDayTime = UITimeManager:GetInstance():GetNextDayMs()
  for _, v in ipairs(exchange) do
    local pop = false
    local pack = M.get(v.id)
    if pack == nil then
      pop = true
    elseif not pack:isTimeValid() then
      pop = true
    end
    local isLogInPush = message.isOffline and message.isOffline == 1
    if isLogInPush then
      pop = false
      Logger.Log("GiftPackPush: Login push, no popup. ID: " .. v.id)
    end
    local success = M.update(v)
    if not success then
      logErrorWithTag("GiftPackPushFail", "ID: " .. v.id)
    end
    pack = M.get(v.id)
    if pack ~= nil and pop then
      local result, rechargeType, rechargeId = M.CheckIfIsPopupPackage(v.id)
      if result then
        local result = M.TryShowPopupPackage(pack, rechargeType, rechargeId)
      end
      if pack:getType() == GiftPackType.MonopolyLandPackage then
        monopolyLandPackage = true
      end
    end
  end
  EventManager:GetInstance():BroadcastDeferred(EventId.OnPackageInfoUpdated)
  if monopolyLandPackage then
    EventManager:GetInstance():Broadcast(EventId.UpdateGiftPackageBuilding)
  end
end

function M.clickMainGift()
end

function M.clickMainUIDiamond()
  if DataCenter.MonthCardNewManager:CheckIfMonthCardActive() then
    M.openGiftPackByTag(_, WelfareTagType.PremiumPack)
  else
    M.openGiftPackByTag(_, WelfareTagType.MonthCard)
  end
end

function M.hasPopup()
  local time = M.getMainCountdown()
  return 0 < time
end

function M.getMainCountdown()
  local list = M.getPopupPacks()
  if #list < 1 then
    return -1
  end
  return list[1]:getCountdown()
end

function M.getPremiumPacks(isSort)
  local list = {}
  for _, v in pairs(_packDict) do
    local prem = v:isPremiumPack()
    if prem == true then
      local a = 1
    end
    local isBound = v:isBought()
    local timev = v:isTimeValid()
    if v:isPremiumPack() and not v:isBought() and v:isTimeValid() then
      table.insert(list, v)
    end
  end
  if isSort == nil or isSort then
    M._sortByPopup(list)
  end
  return list
end

function M.InitWeeklyFreePackage()
  if not _weeklyFreePackage then
    _weeklyFreePackage = M._create("4")
    _weeklyFreePackage:update(WeeklyFreePackage)
    _weeklyFreePackage.isWeeklyFreePackage = true
  end
end

function M.UpdateClaimFreeWeeklyPackageT(t, isAutoClaim)
  if t.lastRewardTime then
    _weeklyFreePackageClaimT = t.lastRewardTime
  end
  local tips = isAutoClaim and CS.GameEntry.Localization:GetString("auto_receive_desc") or ""
  DataCenter.RewardManager:ShowCommonReward(t, nil, nil, nil, nil, nil, nil, tips)
  DataCenter.RewardManager:AddRewardsAndRes(t)
  EventManager:GetInstance():Broadcast(EventId.FreeWeeklyPackage)
  EventManager:GetInstance():Broadcast(EventId.RefreshWelfareRedDot)
end

function M.GetWeeklyPackageList()
  local list = {}
  for _, v in pairs(_packDict) do
    local isWeekly = v:IsWeeklyPackage()
    if isWeekly then
      table.insert(list, v)
    end
  end
  if 0 < #list then
    if not _weeklyFreePackage then
      M.InitWeeklyFreePackage()
    end
    table.insert(list, _weeklyFreePackage)
  end
  return list
end

function M.GetWeeklyPackageNewList()
  local list = {}
  for _, v in pairs(_packDict) do
    local isWeeklyNew = v:IsWeeklyPackageNew()
    if isWeeklyNew and v:canGet() then
      table.insert(list, v)
    end
  end
  table.sort(list, function(a, b)
    if a:getPopup() ~= b:getPopup() then
      return a:getPopup() > b:getPopup()
    else
      return a:getID() < b:getID()
    end
  end)
  return list
end

function M.GetFreeWeeklyPackage()
  if not _weeklyFreePackage then
    M.InitWeeklyFreePackage()
  end
  return _weeklyFreePackage
end

function M.GetLastBuyFreeWeekPackageT()
  return _weeklyFreePackageClaimT
end

function M.GetHeroMedalPackageList()
  if _heroMedalPackList == nil or #_heroMedalPackList == 0 then
    _heroMedalPackList = {}
    local allLines = DataCenter.RechargeManager:GetAllLines()
    for id, lineData in pairs(allLines) do
      local tempType = lineData.type
      if tempType == WelfareTagType.HeroMedalPackage then
        local strConf = lineData.para1
        local heroConfs = string.split(strConf, "|")
        if heroConfs and 0 < #heroConfs then
          for i, heroConf in ipairs(heroConfs) do
            local tempConf = string.split(heroConf, "@")
            if tempConf and #tempConf == 2 then
              local newHeroPack = {}
              newHeroPack.heroId = tempConf[1]
              local tempPackages = string.split(tempConf[2], ";")
              newHeroPack.packageIdList = tempPackages
              table.insert(_heroMedalPackList, newHeroPack)
            end
          end
        end
      end
    end
  end
  local retList = {}
  for i, v in ipairs(_heroMedalPackList) do
    local temp = {}
    temp.heroId = v.heroId
    temp.packageIdList = {}
    for m, tempId in ipairs(v.packageIdList) do
      local tempInfo = GiftPackageData.get(tempId)
      if tempInfo then
        table.insert(temp.packageIdList, tempId)
      end
    end
    if 0 < #temp.packageIdList then
      table.insert(retList, temp)
    end
  end
  return retList
end

function M.CheckIfHasNewHeroMedalPack()
  local packList = M.GetHeroMedalPackageList()
  local strOldPacks = CS.GameEntry.Setting:GetString("CacheHeroMedalPack_" .. LuaEntry.Player.uid)
  local oldPacks = string.split(strOldPacks, ";")
  for i, v in ipairs(packList) do
    if not table.hasvalue(oldPacks, v.heroId) then
      return true
    end
  end
end

function M.CheckIfNewWeeklyPackageOpen()
  local isOpen = LuaEntry.DataConfig:CheckSwitch("weekgift_new_switch")
  if isOpen then
    local k1 = LuaEntry.DataConfig:TryGetStr("weekly_sale", "k1")
    local k1Num = tonumber(k1) or 0
    local mainLv = DataCenter.BuildManager.MainLv or 0
    if k1Num > mainLv then
      isOpen = false
    end
  end
  return isOpen
end

function M.CheckIfHasFreeWeeklyPackage()
  local lastT = M.GetLastBuyFreeWeekPackageT()
  local lastTimeS = math.modf(lastT / 1000)
  local serverTime = UITimeManager:GetInstance():GetServerSeconds()
  local todayClaimed = UITimeManager:GetInstance():IsSameDayForServer(lastTimeS, serverTime)
  return not todayClaimed
end

function M.getPopPremiumPacks(isSort)
  local list = {}
  for _, v in pairs(_packDict) do
    if v:isPremiumPack() and not v:isBought() and v:isPremiumPackCanInPop() and v:isTimeValid() then
      table.insert(list, v)
    end
  end
  if isSort == nil or isSort then
    M._sortByPopup(list)
  end
  return list
end

function M.getStorePacks()
  local list = {}
  for _, v in pairs(_packDict) do
    if v:isStorePack() and not v:isBought() then
      table.insert(list, v)
    end
  end
  M._sortByPopup(list)
  return list
end

function M.hasStorePacks()
  for _, v in pairs(_packDict) do
    if v:isStorePack() and not v:isBought() then
      return true
    end
  end
  return false
end

function M.getRobotPacks()
  local list = {}
  for _, v in pairs(_packDict) do
    if v:isRobotPack() and not v:isBought() then
      table.insert(list, v)
    end
  end
  return list
end

function M.getRobotPacksByRechargeId(rechargeId)
  local list = {}
  for _, v in pairs(_packDict) do
    if v:isRechargeId(rechargeId) and not v:isBought() then
      table.insert(list, v)
    end
  end
  return list
end

function M.getFirstShowTypeGiftPack(showType)
  local list = {}
  for _, v in pairs(_packDict) do
    if not v:isBought() and v:getShowType(showType) ~= nil then
      table.insert(list, v)
    end
  end
  if table.count(list) == 0 then
    return nil
  end
  M._sortByPopup(list)
  return list[1]
end

function M.GetFirstGiftPackByShowType(mainType, subType)
  mainType = tostring(mainType)
  subType = tostring(subType)
  local list = {}
  for _, v in pairs(_packDict) do
    if v:getID() == "81011" or v:getID() == 81011 then
      local tempSub = v:getShowType(mainType)
    end
    if not v:isBought() and v:getShowType(mainType) == subType then
      table.insert(list, v)
    end
  end
  if table.count(list) == 0 then
    return nil
  end
  M._sortByPopup(list)
  return list[1]
end

function M.getPiggyBankPack()
  for _, v in pairs(_packDict) do
    if v:isPiggyBankPack() and not v:isBought() then
      return v
    end
  end
  return nil
end

function M.getEnergyBankPack()
  for _, v in pairs(_packDict) do
    if v:isEnergyBankPack() and not v:isBought() then
      return v
    end
  end
  return nil
end

function M.getGrowthPlanPack()
  for _, v in pairs(_packDict) do
    if v:isGrowthPlanPack() and not v:isBought() then
      return v
    end
  end
  return nil
end

function M.getScrollPack(rechargeId)
  local list = {}
  for _, v in pairs(_packDict) do
    if v:isScrollPack() and not v:isBought() and v:getRechargeLineData().id == rechargeId then
      table.insert(list, v)
    end
  end
  list = M.FilterVipPacks(list, VipPayGoodState.CanBuy, true)
  return list
end

function M.getPvePack(rechargeId)
  local list = {}
  for _, v in pairs(_packDict) do
    if v:isPvePack() and not v:isBought() and v:getRechargeLineData().id == rechargeId then
      table.insert(list, v)
    end
  end
  return list
end

function M.GetResourcePacks(resType)
  local retTb = {}
  local strResType = tostring(resType)
  for k, v in pairs(_packDict) do
    if v:isTimeValid() and not v:isBought() and v:isContainShowType("2", strResType) then
      table.insert(retTb, v)
    end
  end
  table.sort(retTb, function(a, b)
    local popupA = a:getPopup()
    local popupB = b:getPopup()
    if popupA ~= popupB then
      return popupA > popupB
    else
      return a:getID() < b:getID()
    end
  end)
  return retTb
end

function M.GetResourceItemPacks(resId)
  local retTb = {}
  local strResType = tostring(resId)
  for k, v in pairs(_packDict) do
    if v:isTimeValid() and not v:isBought() and v:isContainShowType("8", strResType) then
      table.insert(retTb, v)
    end
  end
  table.sort(retTb, function(a, b)
    local popupA = a:getPopup()
    local popupB = b:getPopup()
    if popupA ~= popupB then
      return popupA > popupB
    else
      return a:getID() < b:getID()
    end
  end)
  return retTb
end

function M.GetAddTimePacks(speedType)
  local retTb = {}
  local strResType = tostring(speedType)
  for k, v in pairs(_packDict) do
    if v:isTimeValid() and not v:isBought() and v:isContainShowType("4", strResType) then
      table.insert(retTb, v)
    end
  end
  table.sort(retTb, function(a, b)
    local popupA = a:getPopup()
    local popupB = b:getPopup()
    if popupA ~= popupB then
      return popupA > popupB
    else
      return a:getID() < b:getID()
    end
  end)
  return retTb
end

function M.GetTalentPackage()
  local talentPackList = {}
  for i, v in pairs(_packDict) do
    if not v:isBought() and v:isContainShowType("2", "200035") then
      table.insert(talentPackList, v)
    end
  end
  local retPack
  local maxPopup = 0
  if 0 < #talentPackList then
    for i, v in ipairs(talentPackList) do
      if maxPopup < v:getPopup() then
        retPack = v
      end
    end
  end
  return retPack
end

function M.GetGivenPacks(itemId)
  local retTb = {}
  for k, v in pairs(_packDict) do
    if v:isTimeValid() and not v:isBought() and v:isContainShowType("6", tostring(itemId)) then
      table.insert(retTb, v)
    end
  end
  table.sort(retTb, function(a, b)
    local popupA = a:getPopup()
    local popupB = b:getPopup()
    if popupA ~= popupB then
      return popupA > popupB
    else
      return a:getID() < b:getID()
    end
  end)
  return retTb
end

function M.GenerateDataByType(showMainType, showSubType)
  return M.getStorePacks()
end

function M.getPacks(ids, isSort)
  local list = {}
  if ids == nil then
    return list
  end
  for _, v in pairs(ids) do
    local pack = M.get(v)
    if pack and not pack:isBought() and pack:isTimeValid() then
      table.insert(list, pack)
    end
  end
  if isSort == nil or isSort then
    M._sortByPopup(list)
  end
  return list
end

function M.getPacksIgnoreTime(ids, isSort, ignoreStart, ignoreEnd)
  local list = {}
  if ids == nil then
    return list
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  for _, v in pairs(ids) do
    local pack = M.get(v)
    if pack and not pack:isBought() then
      if not ignoreStart then
        local startTime = pack:getStartTime()
        if startTime and curTime < startTime then
          goto lbl_46
        end
      end
      if not ignoreEnd then
        local endTime = pack:getEndTime()
        local countDown = pack:getCountdown()
        if curTime > endTime or countDown <= 0 then
          goto lbl_46
        end
      end
      table.insert(list, pack)
    end
    ::lbl_46::
  end
  if isSort == nil or isSort then
    M._sortByPopup(list)
  end
  return list
end

function M.getPacksIgnoreBoughtStatus(ids, isSort)
  local list = {}
  if ids == nil then
    return list
  end
  for _, v in ipairs(ids) do
    local pack = M.get(v)
    if pack then
      table.insert(list, pack)
    end
  end
  if isSort == nil or isSort then
    M._sortByPopup(list)
  end
  return list
end

function M.getPopSpecialPacksById(ids, isSort)
  local list = {}
  if ids == nil then
    return list
  end
  for _, v in ipairs(ids) do
    local pack = M.get(v)
    if pack and not pack:isBought() and pack:isSpecialPackCanInPop() and pack:isTimeValid() then
      table.insert(list, pack)
    end
  end
  if isSort == nil or isSort then
    M._sortByPopup(list)
  end
  return list
end

function M.get(id)
  if string.IsNullOrEmpty(id) then
    return nil
  end
  return _packDict[id]
end

function M.checkPackIsValid(id, ignoreStart, ignoreEnd)
  local pack = M.get(id)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if pack and not pack:isBought() then
    if not ignoreStart then
      local startTime = pack:getStartTime()
      if startTime and curTime < startTime then
        return false
      end
    end
    if not ignoreEnd then
      local endTime = pack:getEndTime()
      local countDown = pack:getCountdown()
      if curTime > endTime or countDown <= 0 then
        return false
      end
    end
    return true
  end
  return false
end

function M.getOnePackByType(type)
  for _, v in pairs(_packDict) do
    if v:getType() == type then
      return v
    end
  end
end

function M.update(data)
  if data == nil then
    return false
  end
  local pack = M.get(data.id)
  if pack == nil then
    pack = M._create(data.type)
    pack:update(data)
    _packDict[pack:getID()] = pack
  else
    pack:update(data)
  end
  M.OnUpdatePack(pack)
  M.CheckPackEndTime(pack)
  return true
end

function M.purge()
  _inited = false
  M._removeListener()
end

function M.isBuildingGiftPackBought(_, id)
  local result = _buildingDict[id]
  if result then
    return false
  end
  return true
end

function M.setPlayCallbackFlag(_, id)
  local pack = M.get(id)
  if pack ~= nil and pack:getType() == GiftPackType.PromotionPay then
    pack.isPayCallback = true
  end
end

function M.buyPack(_, id)
  M.buy(id)
end

function M.hasPack(_, id)
  local pack = M.get(id)
  return pack ~= nil
end

function M.getPacksByType(_, type)
  local list = {}
  for _, pack in pairs(_packDict) do
    if pack:getType() == tonumber(type) then
      table.insert(list, pack)
    end
  end
  return list
end

function M.getPacksIDByShowType(_, type, values)
  if string.IsNullOrEmpty(type) then
    return ""
  end
  local list = M.getPacksByShowType(type, values)
  local result = {}
  for _, v in pairs(list) do
    table.insert(result, v:getID())
  end
  local rapidjson = require("Common.dkjson")
  local jsonData = rapidjson.encode(result)
  return jsonData
end

function M.getPacksByShowType(type, values)
  if string.IsNullOrEmpty(type) then
    return ""
  end
  local list = {}
  for _, pack in pairs(_packDict) do
    if pack:getType() ~= GiftPackType.MonthCard and pack:getType() ~= GiftPackType.WeekCard and pack:getType() ~= GiftPackType.HeroMonthCard and not pack:isBought() and pack:isTimeValid() then
      if string.IsNullOrEmpty(values) then
        if pack:isContainShowType(type, "") then
          table.insert(list, pack)
        end
      else
        local arrValues = string.split(values, "@")
        for _, v in ipairs(arrValues) do
          if pack:isContainShowType(type, v) then
            table.insert(list, pack)
            break
          end
        end
      end
    end
  end
  M._sortByPopup(list)
  return list
end

function M.getPacksInfoByShowType(_, type, values, checkCanGet)
  if string.IsNullOrEmpty(type) then
    return ""
  end
  local list = M.getPacksByShowType(type, values)
  local result = {}
  for _, v in pairs(list) do
    if not checkCanGet or v:canGet() then
      table.insert(result, v:toJsonForGiftBar())
    end
  end
  local rapidjson = require("Common.dkjson")
  local jsonData = rapidjson.encode(result)
  return jsonData
end

function M.getPackInfoById(_, id)
  local pack = M.get(id)
  return pack:toJsonForGiftBar()
end

function M._addListener()
  EventManager:GetInstance():AddListener(EventId.RefreshGuide, M.OnRefreshGuide)
end

function M._removeListener()
  EventManager:GetInstance():RemoveListener(EventId.RefreshGuide, M.OnRefreshGuide)
end

function M._create(type)
  return require("DataCenter.GiftPackageData.GiftPackInfoDefault").New()
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

function M._clear()
  for _, v in pairs(_packDict) do
    v:dispose()
  end
  _packDict = {}
  _groupPackDict = {}
end

function M.onMainLevelChangeRefreshEnd()
  logInfoWithTag("GiftPack", "RefreshEnd")
  local packs = M.getPacksByShowType("15", "1")
  if packs == nil or #packs < 1 then
    logInfoWithTag("GiftPack", "NoPack")
    return
  end
  M.openWelfarePopByShowTypeUp(_, "15", "1")
  logInfoWithTag("GiftPack", "Pop Succeed")
end

function M.openGiftPackByTag(_, typeID)
  if typeID == nil then
    return
  end
  local tagInfos = WelfareController.getShowTagInfos()
  for _, v in pairs(tagInfos) do
    if v:getType() == typeID then
      local tagInfo = v
      local tagID = tagInfo:getID()
      OpenGameUI("UIWelfare", "Default", {tagID = tagID})
      return
    end
  end
end

function M.openGiftPackByTagID(tagID)
  if tagID == nil then
    return
  end
  OpenGameUI("UIWelfare", "Default", {tagID = tagID})
end

function M.getWelfareTagName(_, tagID)
  if tagID == nil then
    return
  end
  local tagInfos = WelfareController.getShowTagInfos()
  for _, v in pairs(tagInfos) do
    if v:getID() == tagID then
      if v:isSpecialPackTag() then
        return v:getNameForIcon()
      end
      return v:getName()
    end
  end
  return ""
end

function M.getGiftIcon()
  local packs = M.getPopupPacks()
  if packs == nil or #packs < 1 then
    return "close"
  end
  local packFirst = packs[1]
  if packFirst == nil then
    return "close"
  end
  return packFirst:getUIKey()
end

function M.isIconCanShowByTag(_, tagID)
  local tagInfos = WelfareController.getShowTagInfos()
  for _, v in pairs(tagInfos) do
    if v:getID() == tagID then
      return v:isShowIcon() and v:isShow()
    end
  end
  return false
end

function M.hasRedPointByTag(_, tagID)
  local tagInfos = WelfareController.getShowTagInfos()
  for _, v in pairs(tagInfos) do
    if v:getID() == tagID then
      return v:hasRedPoint()
    end
  end
  return false
end

function M.hasBought(id)
  local pack = M.get(id)
  if pack == nil then
    return false
  end
  return pack:isBought()
end

function M.getPackItemsStr(_, id)
  local pack = M.get(id)
  if pack == nil then
    return ""
  end
  return pack:getItemsStr()
end

function M.getPackHeroesStr(_, id)
  local pack = M.get(id)
  if pack == nil then
    return ""
  end
  return pack:getHeroesStr()
end

function M.checkPackSpecialItem(_, packID, id)
  local pack = M.get(packID)
  if pack == nil then
    return false
  end
  return pack:isSpecialShowItem(id)
end

function M.checkPackSpecialHero(_, packID, id)
  local pack = M.get(packID)
  if pack == nil then
    return false
  end
  return pack:isSpecialShowHero(id)
end

function M.getPackPrice(id)
  local pack = M.get(id)
  if pack == nil then
    return ""
  end
  return pack:getPriceText()
end

function M.getPackPercent(_, id)
  local pack = M.get(id)
  if pack == nil then
    return ""
  end
  return pack:getPercent()
end

function M.getPackPoint(_, id)
  local pack = M.get(id)
  if pack == nil then
    return ""
  end
  return pack:getRechargePoint()
end

function M.GetAllPackagesInGroup(tempPackageId, isPopUp)
  local result, rechargeId = M.CheckIfIsPopupPackage(tempPackageId)
  if not isPopUp or result then
    local tempRecharges = WelfareController.GetPackageRecharges(tempPackageId)
    if not table.IsNullOrEmpty(tempRecharges) then
      local retTb = {}
      for i, v in ipairs(tempRecharges) do
        local packageIds = DataCenter.RechargeManager:GetSplitedPara1(v)
        for m, tempId in ipairs(packageIds) do
          table.insert(retTb, tempId)
        end
        if not table.IsNullOrEmpty(packageIds) then
          return retTb
        end
      end
    end
  end
end

function M.GetAllAvailablePackagesInGroup(tempPackageId, isPopUp)
  local retTb = {}
  local allPackages = M.GetAllPackagesInGroup(tempPackageId, isPopUp)
  if allPackages then
    local curTime = Timer:GetServerTime()
    for i, v in ipairs(allPackages) do
      local tempPackage = M.get(v)
      if tempPackage then
        local leftTime, b2 = math.modf(tempPackage:getEndTime() - curTime)
        if 0 <= leftTime and not tempPackage:isBought() then
          table.insert(retTb, tempPackage)
        end
      end
    end
  end
  return retTb
end

function M.GetAllAvailablePackageByRechargeId(rechargeId, isPopUp)
  local packageIds = DataCenter.RechargeManager:GetSplitedPara1(rechargeId)
  local retTb = {}
  if 0 < #packageIds then
    retTb = M.GetAllAvailablePackagesInGroup(packageIds[1], isPopUp)
    retTb = M.FilterVipPacks(retTb, VipPayGoodState.CanBuy, true)
  end
  return retTb
end

function M.CheckIfIsPopupPackage(packageId)
  return WelfareController.IsPackagePopUp(packageId)
end

function M.CheckPackageEntryType(packageId)
  local tempRecharges = WelfareController.GetPackageRecharges(packageId)
  local tempRechargeId
  if tempRecharges then
    tempRechargeId = tempRecharges[1]
  end
  if not tempRechargeId then
    return false, nil
  end
  local tempType = DataCenter.RechargeManager:getStrValue(tempRechargeId, "entry_type")
  local tempType = tonumber(tempType)
  return true, tempType, tempRechargeId
end

function M.GetRechargeDataByPackageId(packageID)
  local rechargeIDs = WelfareController.GetPackageRecharges(packageID)
  if not table.IsNullOrEmpty(rechargeIDs) then
    return DataCenter.RechargeManager:GetLine(rechargeIDs[1])
  end
end

function M.GetRechargeIdListByType(type)
  return WelfareController.getRechargeIdListByType(type)
end

function M.TryShowPopupPackage(packageInfo, rechargeType, rechargeId)
  if rechargeType == WelfareTagType.PiggyBank then
    DataCenter.UIPopWindowManager:Push(UIWindowNames.UIPiggyBank)
    return true
  elseif rechargeType == WelfareTagType.EnergyBank then
    DataCenter.UIPopWindowManager:Push(UIWindowNames.UIEnergyBank)
    return true
  else
    local window = UIManager:GetInstance():GetWindow(UIWindowNames.UIPlayerLevelPackage)
    if not window then
      DataCenter.UIPopWindowManager:Push(UIWindowNames.UIPlayerLevelPackage, {anim = true}, rechargeId, {rechargeId})
      return true
    end
  end
  return false
end

function M.OnRefreshGuide()
  local guideTemplate = DataCenter.GuideManager:GetCurTemplate()
  if guideTemplate and guideTemplate.id == LuaEntry.DataConfig:TryGetNum("first_pay", "k4") and DataCenter.PayManager:CheckIfFirstPayOpen() then
    local shown = CS.GameEntry.Setting:GetBool(SettingKeys.FIRST_PAY_SHOWN .. LuaEntry.Player.uid, false)
    if not shown then
      TimerManager:GetInstance():DelayInvoke(function()
        DataCenter.UIPopWindowManager:Push(UIWindowNames.UIFirstPay, {
          anim = false,
          UIMainAnim = UIMainAnimType.AllHide
        })
      end, 1.5)
    end
  end
end

function M.FilterVipPacks(packList, includeState, keepNonVip)
  local packs = {}
  local list = {}
  local hasVip = false
  for _, pack in ipairs(packList) do
    table.insert(packs, pack)
  end
  table.sort(packs, function(a, b)
    if a:getPopup() ~= b:getPopup() then
      return a:getPopup() > b:getPopup()
    else
      return a:getID() < b:getID()
    end
  end)
  for _, pack in ipairs(packs) do
    local insert = true
    local packId = pack:getID()
    if DataCenter.VIPManager:IsVipPack(packId) then
      local vipLv = DataCenter.VIPManager:GetPackVipLv(packId)
      local packState = DataCenter.VIPManager:AnalyzePayGoodState(vipLv, packId)
      if packState ~= includeState or hasVip then
        insert = false
      else
        hasVip = true
      end
    else
      insert = keepNonVip
    end
    if insert then
      table.insert(list, pack)
    end
  end
  return list
end

function M.FilterVipPacksExclude(packList, excludeState, keepNonVip)
  local packs = {}
  local list = {}
  local hasVip = false
  for _, pack in ipairs(packList) do
    table.insert(packs, pack)
  end
  table.sort(packs, function(a, b)
    if a:getPopup() ~= b:getPopup() then
      return a:getPopup() > b:getPopup()
    else
      return a:getID() < b:getID()
    end
  end)
  for _, pack in ipairs(packs) do
    local insert = true
    local packId = pack:getID()
    if DataCenter.VIPManager:IsVipPack(packId) then
      local vipLv = DataCenter.VIPManager:GetPackVipLv(packId)
      local packState = DataCenter.VIPManager:AnalyzePayGoodState(vipLv, packId)
      if packState == excludeState or hasVip then
        insert = false
      else
        hasVip = true
      end
    else
      insert = keepNonVip
    end
    if insert then
      table.insert(list, pack)
    end
  end
  return list
end

function M.GetPacksByGroupId(groupId, containIsBought, ignoreTime)
  if not groupId then
    return {}
  end
  local _groupId = tostring(groupId)
  local list = {}
  if not table.IsNullOrEmpty(_packDict) and _groupPackDict[_groupId] then
    local packDict = _groupPackDict[_groupId]
    for packId, v in pairs(packDict) do
      if ignoreTime or v:isTimeValid() then
        if containIsBought then
          table.insert(list, v)
        elseif not v:isBought() then
          table.insert(list, v)
        end
      end
    end
  end
  table.sort(list, function(a, b)
    return a:getID() < b:getID()
  end)
  return list
end

return M
