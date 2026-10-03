local LotteryDataManager = BaseClass("LotteryDataManager")
local LotteryInfo = require("DataCenter.HeroData.LotteryInfo")
local RecruitDisplayConfig = require("DataCenter.HeroData.RecruitDisplayConfig")
local BaseLotteryId = 221500

local function __init(self)
  self.lotteryDict = {}
  self.workerOfficerDic = {}
  self.displayConfig = nil
  self.switchConfig = nil
  self.campChangeFreeCount = 0
  self.campChangeFreeMax = 0
  self.nextCampLotteryId = 0
  self.needTipItemId2Num = nil
  self.needTipItemId = 0
  self.curTipBubbleType = LotteryDataManager.BubbleTipType.None
  self.QualityLotteryList = {
    "221541",
    "221542",
    "221543",
    "221544"
  }
  self.curRecruitIdList = {}
  self.wishPreviewReward = false
end

local function __delete(self)
  self.lotteryDict = nil
  self.workerOfficerDic = nil
  self.displayConfig = nil
  self.switchConfig = nil
  self.campChangeFreeCount = nil
  self.campChangeFreeMax = nil
  self.nextCampLotteryId = nil
  self.needTipItemId2Num = nil
  self.curRecruitIdList = nil
  self.wishPreviewReward = nil
end

local function UpdateLotteryData(self, message)
  local wishPreviewReward = message.wishPreviewReward
  if wishPreviewReward ~= nil then
    self.wishPreviewReward = wishPreviewReward
  end
  local array = message.lotteryFreeInfo
  if array == nil then
    Logger.LogError("#zlh#", "LotteryDataManager lotteryFreeInfo is nil!")
    return
  end
  local removeIdsTemp = {}
  if self.lotteryDict then
    for i, v in pairs(self.lotteryDict) do
      removeIdsTemp[v.id] = true
    end
  else
    self.lotteryDict = {}
  end
  for _, sfsObj in pairs(array) do
    local id = sfsObj.id
    local dt = self.lotteryDict[id]
    if dt ~= nil then
      dt:UpdateInfo(sfsObj)
      if removeIdsTemp[dt.id] then
        removeIdsTemp[dt.id] = nil
      end
    else
      dt = LotteryInfo.New()
      dt:UpdateInfo(sfsObj)
      if dt.type ~= 2 and dt.type ~= 3 then
        self.lotteryDict[id] = dt
        if removeIdsTemp[dt.id] then
          removeIdsTemp[dt.id] = nil
        end
      end
    end
  end
  for i, v in pairs(removeIdsTemp) do
    if self.lotteryDict[i] then
      self.lotteryDict[i] = nil
    end
  end
  array = message.workerOfficerIds
  if array == nil then
    Logger.LogError("LotteryDataManager workerOfficerIds is nil!")
    return
  end
  for i = 1, #array do
    local officerId = array[i]
    local params = {id = officerId}
    local lotteryInfo = self.workerOfficerDic[officerId]
    if lotteryInfo ~= nil then
      lotteryInfo:UpdateInfo(params)
    else
      lotteryInfo = LotteryInfo.New()
      lotteryInfo:UpdateInfo(params)
      self.workerOfficerDic[officerId] = lotteryInfo
    end
  end
end

local function InitData(self, message)
  local wishPreviewReward = message.wishPreviewReward
  if wishPreviewReward ~= nil then
    self.wishPreviewReward = wishPreviewReward
  end
  local array = message.lotteryFreeInfo
  if array == nil then
    Logger.LogError("#zlh#", "LotteryDataManager lotteryFreeInfo is nil!")
    return
  end
  self.lotteryDict = {}
  for _, sfsObj in pairs(array) do
    local id = sfsObj.id
    local dt = self.lotteryDict[id]
    if dt ~= nil then
      dt:UpdateInfo(sfsObj)
    else
      dt = LotteryInfo.New()
      dt:UpdateInfo(sfsObj)
      if dt.type ~= 2 and dt.type ~= 3 then
        self.lotteryDict[id] = dt
      end
    end
  end
  local displayConfig = RecruitDisplayConfig.New()
  displayConfig:Init()
  self.displayConfig = displayConfig
  self.needTipItemId = LuaEntry.DataConfig:TryGetStr("get_recruitment_props_tips", "k1")
  self.needTipItemNum = LuaEntry.DataConfig:TryGetStr("get_recruitment_props_tips", "k2")
  array = message.workerOfficerIds
  if array == nil then
    Logger.LogError("LotteryDataManager workerOfficerIds is nil!")
    return
  end
  for i = 1, #array do
    local officerId = array[i]
    local params = {id = officerId}
    local lotteryInfo = self.workerOfficerDic[officerId]
    if lotteryInfo ~= nil then
      lotteryInfo:UpdateInfo(params)
    else
      lotteryInfo = LotteryInfo.New()
      lotteryInfo:UpdateInfo(params)
      self.workerOfficerDic[officerId] = lotteryInfo
    end
  end
end

local function InitCurLotteryIdList(self, message)
  if message.officerIds then
    self.curRecruitIdList = message.officerIds
  end
end

local function GetAllLotteryDict(self)
  return self.lotteryDict
end

local function GetAllShowLotteryDict(self)
  local result = {}
  local curTime = UITimeManager:GetInstance():GetServerTime()
  for k, v in pairs(self.lotteryDict) do
    if v.time_type == LotteryTimeType.LotteryTimeType_Expert then
      if curTime >= v.startTime and curTime <= v.endTime then
        result[k] = v
      end
    else
      result[k] = v
    end
  end
  return result
end

local function GetQualityLotteryDict(self)
  local result = {}
  local curTime = UITimeManager:GetInstance():GetServerTime()
  for k, v in pairs(self.QualityLotteryList) do
    local lotteryInfo = self.lotteryDict[v]
    if lotteryInfo ~= nil then
      if lotteryInfo.time_type == LotteryTimeType.LotteryTimeType_Expert then
        if curTime >= lotteryInfo.startTime and curTime <= lotteryInfo.endTime then
          result[v] = lotteryInfo
        end
      else
        result[v] = lotteryInfo
      end
    end
  end
  return result
end

local function GetOtherLotteryDict(self)
  local result = {}
  local curTime = UITimeManager:GetInstance():GetServerTime()
  for k, v in pairs(self.lotteryDict) do
    if v.time_type == LotteryTimeType.LotteryTimeType_Expert then
      if curTime >= v.startTime and curTime <= v.endTime then
        result[k] = v
      end
    else
      result[k] = v
    end
  end
  return result
end

local function GetWorkerLotteryDict(self)
  return self.workerOfficerDic or {}
end

local function UpdateOneLottery(self, message)
  local id = message.id
  local dt = self.lotteryDict[id]
  if dt ~= nil then
    dt:UpdateInfo(message)
  end
end

local function GetLotteryDataById(self, lotteryId)
  return self.lotteryDict[lotteryId] or self.workerOfficerDic[lotteryId]
end

function LotteryDataManager:GetOnlyWorkerLotteryData()
  local workerLotteryList = table.values(self.workerOfficerDic)
  return workerLotteryList[1]
end

function LotteryDataManager:GetOnlyWorkerLotteryCostItemId()
  local onlyWorkerLotteryData = self:GetOnlyWorkerLotteryData()
  local res
  if onlyWorkerLotteryData then
    local item_extraInfoSplitStr = string.split(onlyWorkerLotteryData.item_extraInfo, ";")
    if not string.IsNullOrEmpty(item_extraInfoSplitStr) then
      res = tonumber(item_extraInfoSplitStr[2])
    end
  end
  return res
end

function LotteryDataManager:GetOnlyWorkerLotteryGuaranteedDrawNum()
  local onlyWorkerLotteryData = self:GetOnlyWorkerLotteryData()
  local res
  if onlyWorkerLotteryData then
    local pityStr = string.split(onlyWorkerLotteryData.pity, ";")
    if not string.IsNullOrEmpty(pityStr) then
      res = tonumber(pityStr[3])
    end
  end
  return res
end

local function GetDisplayConfig(self)
  return self.displayConfig
end

local function SetCampChangeInfo(self, freeCount, freeMaxCount, nextCampLotteryId)
  self.campChangeFreeCount = freeCount
  self.campChangeFreeMax = freeMaxCount
  if nextCampLotteryId ~= nil then
    self.nextCampLotteryId = nextCampLotteryId
  end
end

local function GetLeftCampChangeFreeCount(self)
  return math.min(0, self.campChangeFreeMax - self.campChangeFreeCount)
end

local function GetCampChangeCost(self)
  local costInfo = LuaEntry.DataConfig:TryGetStr("recruit_switch", "k2")
  local array = string.split(costInfo, ";")
  return tonumber(array[1]), tonumber(array[2])
end

local function GetLotteryIdByCamp(self, campId)
  campId = tonumber(campId)
  local info = LuaEntry.DataConfig:TryGetStr("recruit_switch", "k1")
  local array = string.split(info, ";")
  for _, lotteryId in ipairs(array) do
    if self.displayConfig:GetCampId(lotteryId) == campId then
      return lotteryId
    end
  end
  return nil
end

local function GetSpecialCampCurLotteryId(self)
  local info = LuaEntry.DataConfig:TryGetStr("recruit_switch", "k1")
  local array = string.split(info, ";")
  for _, lotteryId in ipairs(array) do
    local dt = self:GetLotteryDataById(lotteryId)
    if dt ~= nil and dt:IsShowTime() and dt:IsOpen() then
      return lotteryId
    end
  end
  return nil
end

local function IsSpecialCampLottery(self, lotteryId)
  local info = LuaEntry.DataConfig:TryGetStr("recruit_switch", "k1")
  local array = string.split(info, ";")
  return table.hasvalue(array, lotteryId)
end

local function CanShowTipBubble(self, basic)
  for lotteryId, v in pairs(self.lotteryDict) do
    if tonumber(lotteryId) == BaseLotteryId then
      if basic then
        if v:IsAllowMultiRecruit() then
          local costItems = v:GetCostItems()
          local itemId = costItems[2].itemId
          local itemNum = costItems[2].itemNum
          local item = DataCenter.ItemData:GetItemById(itemId)
          local have = item and item.count or 0
          if itemNum <= have then
            self.curTipBubbleType = LotteryDataManager.BubbleTipType.Normal
            return true
          end
        else
          local costItems = v:GetCostItems()
          local itemId = costItems[1].itemId
          local itemNum = costItems[1].itemNum
          local item = DataCenter.ItemData:GetItemById(itemId)
          local have = item and item.count or 0
          if itemNum <= have then
            self.curTipBubbleType = LotteryDataManager.BubbleTipType.Normal
            return true
          end
        end
      end
    elseif not basic then
      if v:IsAllowMultiRecruit() then
        local costItems = v:GetCostItems()
        local itemId = costItems[2].itemId
        local itemNum = costItems[2].itemNum
        local item = DataCenter.ItemData:GetItemById(itemId)
        local have = item and item.count or 0
        if itemNum <= have then
          self.curTipBubbleType = LotteryDataManager.BubbleTipType.Camp
          return true
        end
      else
        local costItems = v:GetCostItems()
        local itemId = costItems[1].itemId
        local itemNum = costItems[1].itemNum
        local item = DataCenter.ItemData:GetItemById(itemId)
        local have = item and item.count or 0
        if itemNum <= have then
          self.curTipBubbleType = LotteryDataManager.BubbleTipType.Camp
          return true
        end
      end
    end
  end
  return false
end

local function CheckCampRecruitFlag(self)
  if self.curTipBubbleType == LotteryDataManager.BubbleTipType.Camp then
    local now = UITimeManager:GetInstance():GetServerSeconds()
    Setting:SetPrivateFloat(SettingKeys.CAMP_RECRUIT_BUBBLE_TIP, now)
    self.curTipBubbleType = LotteryDataManager.BubbleTipType.None
    EventManager:GetInstance():Broadcast(EventId.CheckPubBubble)
  end
end

local function IsNeedTipItemId(self, itemId)
  itemId = toInt(itemId)
  if self.needTipItemId2Num == nil then
    self:InitNeedTipItemId()
  end
  return self.needTipItemId2Num ~= nil and self.needTipItemId2Num[itemId] ~= nil
end

local function GetNeedTipItemMaxNum(self, itemId)
  itemId = toInt(itemId)
  if self.needTipItemId2Num == nil then
    self:InitNeedTipItemId()
  end
  if self.needTipItemId2Num == nil or self.needTipItemId2Num[itemId] == nil then
    return 1
  end
  return self.needTipItemId2Num[itemId]
end

local function InitNeedTipItemId(self)
  if self.needTipItemId2Num == nil then
    local str = LuaEntry.DataConfig:TryGetStr("hero_reset", "k9")
    local vec = string.split(str, "|")
    if vec ~= nil then
      self.needTipItemId2Num = {}
      for _, v in ipairs(vec) do
        local tmpVec = string.split(v, ";")
        if table.count(tmpVec) == 2 then
          self.needTipItemId2Num[toInt(tmpVec[1])] = toInt(tmpVec[2])
        end
      end
    end
  end
end

local function GetCurTipBubbleType(self)
  return self.curTipBubbleType
end

LotteryDataManager.BubbleTipType = {
  None = 0,
  Normal = 1,
  Camp = 2
}

local function GetFreeRecruitLotteryData(self)
  if self.lotteryDict == nil then
    return nil
  end
  for lotteryId, v in pairs(self.lotteryDict) do
    if v:CanFreeRecruit() then
      return v.id
    end
  end
  return nil
end

local function GetClosestFreeRecruitLottery(self)
  if self.lotteryDict == nil then
    return nil
  end
  local now = UITimeManager:GetInstance():GetServerSeconds()
  local minTime = 0
  local lotteryId
  for id, v in pairs(self.lotteryDict) do
    if v:IsSupportFreeRecruit() then
      local time = v.dailyFreeNextFreshTime
      if (minTime == 0 or minTime > time) and now < time then
        minTime = time
        lotteryId = id
      end
    end
  end
  return lotteryId
end

function LotteryDataManager:GetHeroWishFunctionOpenSeasonCondition()
  local k1 = LuaEntry.DataConfig:TryGetStr("recruit_wish_config", "k1", "")
  if not string.IsNullOrEmpty(k1) then
    local k1Pair = string.split(k1, ",")
    if #k1Pair == 2 then
      local season = tonumber(k1Pair[1])
      local day = tonumber(k1Pair[2])
      return season, day
    end
  end
end

function LotteryDataManager:IsHeroWishFunctionOpen()
  local season, day = self:GetHeroWishFunctionOpenSeasonCondition()
  if season and day then
    local seasonNum = SeasonUtil.GetSeason()
    if season < seasonNum then
      return true
    elseif season > seasonNum then
      return false
    end
    return day <= SeasonUtil.GetSeasonDay()
  end
  return false
end

function LotteryDataManager:SendSelectWishHeroMessage(lotteryId, heroId)
  SFSNetwork.SendMessage(MsgDefines.HeroLotterySwitchWish, {lotteryId = lotteryId, wishHero = heroId})
end

function LotteryDataManager:SendClaimWishHeroMessage(lotteryId)
  SFSNetwork.SendMessage(MsgDefines.HeroLotteryClaimWish, {lotteryId = lotteryId})
end

function LotteryDataManager:OnClaimWishHeroCallback(message)
  if message == nil then
    return
  end
  DataCenter.RewardManager:AddRewardsAndRes(message)
  DataCenter.RewardManager:ShowCommonReward(message)
  DataCenter.LotteryDataManager:UpdateOneLottery(message)
  EventManager:GetInstance():Broadcast(EventId.HeroLotteryClaimWishSuccess)
end

function LotteryDataManager:GetHeroWishGuideSeasonCondition()
  local k2 = LuaEntry.DataConfig:TryGetStr("recruit_wish_config", "k2", "")
  if not string.IsNullOrEmpty(k2) then
    local k2Pair = string.split(k2, ",")
    if #k2Pair == 2 then
      local season = tonumber(k2Pair[1])
      local day = tonumber(k2Pair[2])
      return season, day
    end
  end
end

function LotteryDataManager:IsShowHeroWishGuide()
  local isBeforeFunctionStart = false
  local isAfterGuideStart = false
  local curSeason = SeasonUtil.GetSeason()
  local curDay = SeasonUtil.GetSeasonDay()
  local functionOpenStartSeason, functionOpenStartDay = self:GetHeroWishFunctionOpenSeasonCondition()
  if functionOpenStartSeason and functionOpenStartDay then
    if curSeason == functionOpenStartSeason then
      if curDay < functionOpenStartDay then
        isBeforeFunctionStart = true
      end
    elseif curSeason < functionOpenStartSeason then
      isBeforeFunctionStart = true
    end
  end
  if isBeforeFunctionStart then
    local guideStartSeason, guideStartDay = self:GetHeroWishGuideSeasonCondition()
    if guideStartSeason and guideStartDay then
      if curSeason == guideStartSeason then
        if curDay >= guideStartDay then
          isAfterGuideStart = true
        end
      elseif curSeason > guideStartSeason then
        isAfterGuideStart = true
      end
    end
  end
  return isBeforeFunctionStart == true and isAfterGuideStart == true
end

function LotteryDataManager:GetHeroWishGuideRewardInfo()
  local k3 = LuaEntry.DataConfig:TryGetStr("recruit_wish_config", "k3", "")
  if not string.IsNullOrEmpty(k3) then
    local k3Pair = string.split(k3, ";")
    if #k3Pair == 2 then
      local itemId = tonumber(k3Pair[1])
      local count = tonumber(k3Pair[2])
      return itemId, count
    end
  end
end

function LotteryDataManager:IsCanClaimHeroWishGuideReward()
  return self:IsShowHeroWishGuide() and (self.wishPreviewReward == nil or self.wishPreviewReward == false)
end

function LotteryDataManager:SendClaimWishGuideRewardMessage()
  SFSNetwork.SendMessage(MsgDefines.HeroLotteryClaimWishGuideReward)
end

function LotteryDataManager:OnClaimWishGuideReward(message)
  if not message then
    return
  end
  DataCenter.RewardManager:AddRewardsAndRes(message)
  DataCenter.RewardManager:ShowCommonReward(message)
  self.wishPreviewReward = true
  EventManager:GetInstance():Broadcast(EventId.HeroLotteryClaimWishGuideSuccess)
end

function LotteryDataManager:IsHasShownWish()
  local key = "hero_recruit_wish_has_shown"
  return CS.GameEntry.Setting:GetBool(key .. LuaEntry.Player.uid, false)
end

function LotteryDataManager:SetHasShownWish()
  local key = "hero_recruit_wish_has_shown"
  CS.GameEntry.Setting:SetBool(key .. LuaEntry.Player.uid, true)
end

function LotteryDataManager:IsHasShownNewHero(lotteryId)
  local key = "hero_recruit_new_hero_" .. tostring(lotteryId)
  return CS.GameEntry.Setting:GetBool(key .. LuaEntry.Player.uid, false)
end

function LotteryDataManager:SetHasShownNewHero(lotteryId)
  local key = "hero_recruit_new_hero_" .. tostring(lotteryId)
  CS.GameEntry.Setting:SetBool(key .. LuaEntry.Player.uid, true)
end

function LotteryDataManager:GetBuildBubbleGotoLotteryId()
  local function GetWishLotteryId()
    if self.lotteryDict == nil then
      return nil
    end
    for lotteryId, v in pairs(self.lotteryDict) do
      if v:IsShowWish() then
        return lotteryId
      end
    end
    return nil
  end
  
  local function GetNewHeroLotteryId()
    if self.lotteryDict == nil then
      return nil
    end
    for lotteryId, v in pairs(self.lotteryDict) do
      local newHeroIdList = v:GetCurLotteryNewHeroIdListForPreview()
      if not table.IsNullOrEmpty(newHeroIdList) and not self:IsHasShownNewHero(tostring(lotteryId)) then
        return lotteryId
      end
    end
    return nil
  end
  
  local wishLotteryId = GetWishLotteryId()
  if wishLotteryId ~= nil then
    return wishLotteryId
  end
  local newHeroLotteryId = GetNewHeroLotteryId()
  if newHeroLotteryId ~= nil then
    return newHeroLotteryId
  end
  return nil
end

function LotteryDataManager:ShowBuildBubbleNew()
  local function ShowWishBubble()
    if self:IsHasShownWish() then
      return false
    end
    if self.lotteryDict == nil then
      return false
    end
    for lotteryId, v in pairs(self.lotteryDict) do
      if v:IsShowWish() then
        return true
      end
    end
    return false
  end
  
  local function ShowNewHeroBubble()
    if self.lotteryDict == nil then
      return false
    end
    for lotteryId, v in pairs(self.lotteryDict) do
      local newHeroIdList = v:GetCurLotteryNewHeroIdListForPreview()
      if not table.IsNullOrEmpty(newHeroIdList) and not self:IsHasShownNewHero(tostring(lotteryId)) then
        return true
      end
    end
    return false
  end
  
  local showWish = ShowWishBubble()
  local showNewHeroBubble = ShowNewHeroBubble()
  return showWish or showNewHeroBubble
end

function LotteryDataManager:IsHasShownNewHeroNewTag(lotteryId, heroId)
  if lotteryId == nil or heroId == nil then
    return true
  end
  local key = "hero_recruit_new_tag_new_hero_" .. tostring(lotteryId) .. tostring(heroId)
  return CS.GameEntry.Setting:GetBool(key .. LuaEntry.Player.uid, false)
end

function LotteryDataManager:SetHasShownNewHeroNewTag(lotteryId, heroId)
  if lotteryId == nil or heroId == nil then
    return
  end
  local key = "hero_recruit_new_tag_new_hero_" .. tostring(lotteryId) .. tostring(heroId)
  CS.GameEntry.Setting:SetBool(key .. LuaEntry.Player.uid, true)
end

local CUR_LOTTERY_NEW_HERO_KEY = "hero_recruit_cur_new_hero"

function LotteryDataManager:GetAllShownCurLotteryNewHeroIdList()
  local str = CS.GameEntry.Setting:GetPrivateString(CUR_LOTTERY_NEW_HERO_KEY, "")
  local res = {}
  if not string.IsNullOrEmpty(str) then
    local splitStr = string.split(str, ";")
    for i, v in pairs(splitStr) do
      table.insert(res, checknumber(v))
    end
  end
  return res
end

function LotteryDataManager:SetHasShownCurLotteryNewHeroIdList(heroId)
  local curHeroIdList = self:GetAllShownCurLotteryNewHeroIdList()
  table.insert(curHeroIdList, heroId)
  local str = ""
  for i, v in ipairs(curHeroIdList) do
    if i == #curHeroIdList then
      str = str .. tostring(v)
    else
      str = str .. tostring(v) .. ";"
    end
  end
  CS.GameEntry.Setting:SetPrivateString(CUR_LOTTERY_NEW_HERO_KEY, str)
end

LotteryDataManager.__init = __init
LotteryDataManager.__delete = __delete
LotteryDataManager.InitData = InitData
LotteryDataManager.GetAllLotteryDict = GetAllLotteryDict
LotteryDataManager.GetAllShowLotteryDict = GetAllShowLotteryDict
LotteryDataManager.GetQualityLotteryDict = GetQualityLotteryDict
LotteryDataManager.GetOtherLotteryDict = GetOtherLotteryDict
LotteryDataManager.GetWorkerLotteryDict = GetWorkerLotteryDict
LotteryDataManager.UpdateOneLottery = UpdateOneLottery
LotteryDataManager.GetLotteryDataById = GetLotteryDataById
LotteryDataManager.GetDisplayConfig = GetDisplayConfig
LotteryDataManager.SetCampChangeInfo = SetCampChangeInfo
LotteryDataManager.GetLeftCampChangeFreeCount = GetLeftCampChangeFreeCount
LotteryDataManager.GetLotteryIdByCamp = GetLotteryIdByCamp
LotteryDataManager.GetCampChangeCost = GetCampChangeCost
LotteryDataManager.GetSpecialCampCurLotteryId = GetSpecialCampCurLotteryId
LotteryDataManager.IsSpecialCampLottery = IsSpecialCampLottery
LotteryDataManager.CanShowTipBubble = CanShowTipBubble
LotteryDataManager.GetCurTipBubbleType = GetCurTipBubbleType
LotteryDataManager.CheckCampRecruitFlag = CheckCampRecruitFlag
LotteryDataManager.UpdateLotteryData = UpdateLotteryData
LotteryDataManager.IsNeedTipItemId = IsNeedTipItemId
LotteryDataManager.GetNeedTipItemMaxNum = GetNeedTipItemMaxNum
LotteryDataManager.InitNeedTipItemId = InitNeedTipItemId
LotteryDataManager.GetFreeRecruitLotteryData = GetFreeRecruitLotteryData
LotteryDataManager.GetClosestFreeRecruitLottery = GetClosestFreeRecruitLottery
LotteryDataManager.InitCurLotteryIdList = InitCurLotteryIdList
return LotteryDataManager
