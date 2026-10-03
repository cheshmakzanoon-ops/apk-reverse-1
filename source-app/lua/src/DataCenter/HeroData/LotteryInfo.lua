local LotteryInfo = BaseClass("LotteryInfo")
local PreviewComponent = require("UI/UIHero2/UIHeroRecruit/Component/Preview/UIHeroRecruitPreviewComponent")

local function __init(self)
  self.id = ""
  self.type = 0
  self.name = ""
  self.picture_small = ""
  self.picture = ""
  self.descIcon = ""
  self.order = 0
  self.item = ""
  self.protect_des = ""
  self.color = 0
  self.textColor = ""
  self.des = ""
  self.goods_tips = ""
  self.bubble_icon = ""
  self.startTime = 0
  self.endTime = 0
  self.season_function = ""
  self.dailyFreeLimit = 0
  self.dailyFree = 0
  self.dailyFreeNextFreshTime = 0
  self.nextFreeTime = 0
  self.totalLottery = 0
  self.totalLotteryLimit = 0
  self.seasonId = 0
  self.protectLeftCount = 0
  self.protectHeroQuality = 0
  self.pityProProtectNum = 0
  self.pityCurProtectNum = 0
  self.pityProNum = 0
  self.pityMaxProtectNum = 0
  self.pityProType = 0
  self.dailyLimit = 0
  self.dailyTimes = 0
  self.resource = ""
  self.spineParam = {}
  self.imgBg = ""
  self.recruit_lucky_info = nil
  self.foreground_image = nil
  self.dropInfoDetail = nil
  self.pity_dropInfoDetail = nil
  self.workerDropInfoDetail = nil
  self.wishList = {}
  self.wishSwitch = false
  self.wishHero = ""
  self.gachaPreviewTime = 0
  self.wishCondition = ""
  self.afterId = ""
  self.previousId = ""
  self.condition = ""
  self.wishPityCurNum = 0
  self.wishPityReceiveNum = 0
  self.wishPity = 0
  self.gachaNewEndtime = ""
  self.item_extraInfo = ""
  self.recruit100ConditionInfo = nil
  self.recruit100CostInfo = nil
  self.pity = nil
end

local function __delete(self)
  self.id = nil
  self.type = nil
  self.name = nil
  self.picture_small = nil
  self.picture = nil
  self.descIcon = nil
  self.order = nil
  self.item = nil
  self.protect_des = nil
  self.textColor = nil
  self.goods_tips = nil
  self.bubble_icon = nil
  self.startTime = nil
  self.endTime = nil
  self.season_function = nil
  self.dailyFreeLimit = nil
  self.dailyFree = nil
  self.dailyFreeNextFreshTime = nil
  self.nextFreeTime = nil
  self.totalLottery = nil
  self.totalLotteryLimit = nil
  self.seasonId = nil
  self.protectLeftCount = nil
  self.protectHeroQuality = nil
  self.resource = nil
  self.costItems = nil
  self.costResources = nil
  self.spineParam = nil
  self.imgBg = nil
  self.recruit_lucky_info = nil
  self.foreground_image = nil
  self.dropInfoDetail = nil
  self.pity_dropInfoDetail = nil
  self.workerDropInfoDetail = nil
  self.wishList = nil
  self.wishEndTime = nil
  self.wishSwitch = nil
  self.wishHero = nil
  self.gachaPreviewTime = nil
  self.wishCondition = nil
  self.afterId = nil
  self.previousId = nil
  self.condition = nil
  self.wishPityCurNum = nil
  self.wishPityReceiveNum = nil
  self.wishPity = nil
  self.gachaNewEndtime = nil
  self.item_extraInfo = nil
  self.recruit100ConditionInfo = nil
  self.recruit100CostInfo = nil
  self.pity = nil
end

local function UpdateInfo(self, message)
  if message.id ~= nil then
    self.id = message.id
  end
  local heroRecruitCfgRowData = LocalController:instance():getLine(TableName.HeroRecruit, toInt(self.id))
  if message.type ~= nil then
    self.type = message.type
  else
    self.type = heroRecruitCfgRowData.type
  end
  if message.name ~= nil then
    self.name = message.name
  end
  if message.picture_small ~= nil then
    self.picture_small = message.picture_small
  else
    self.picture_small = heroRecruitCfgRowData.picture_small
  end
  if message.picture ~= nil then
    self.picture = message.picture
  else
    self.picture = heroRecruitCfgRowData.picture
  end
  if message.timeType ~= nil then
    self.time_type = tostring(message.timeType)
  else
    self.time_type = heroRecruitCfgRowData.time_type
  end
  self.spineParam = heroRecruitCfgRowData.scale_and_pos
  if message.panel_name ~= nil then
    self.descIcon = message.panel_name
  end
  if message.order ~= nil then
    self.order = message.order
  end
  if message.item ~= nil then
    self.item = message.item
    self.costItems = {}
    local list1 = string.split(self.item, "|")
    for k, value in ipairs(list1) do
      local list2 = string.split(value, ";")
      local t = {}
      t.itemId = list2[1]
      t.itemNum = tonumber(list2[2])
      self.costItems[k] = t
    end
  end
  if message.protect_des ~= nil then
    self.protect_des = message.protect_des
  end
  if message.text_color ~= nil then
    self.textColor = message.text_color
  end
  if message.goods_tips ~= nil then
    self.goods_tips = message.goods_tips
  end
  if message.bubbleicon ~= nil then
    self.bubble_icon = message.bubbleicon
  end
  if message.startTime ~= nil then
    self.startTime = message.startTime * 1000
  end
  if message.endTime ~= nil then
    self.endTime = message.endTime * 1000
  end
  if message.season_function ~= nil then
    self.season_function = message.season_function
  end
  if message.dailyFreeLimit ~= nil then
    self.dailyFreeLimit = message.dailyFreeLimit
  end
  if message.dailyFree ~= nil then
    self.dailyFree = message.dailyFree
  end
  if message.dailyFreeNextFreshTime ~= nil then
    self.dailyFreeNextFreshTime = message.dailyFreeNextFreshTime
  end
  if message.nextFreeTime ~= nil then
    self.nextFreeTime = message.nextFreeTime
  end
  if message.totalLottery ~= nil then
    self.totalLottery = message.totalLottery
  end
  if message.recruit_limit ~= nil then
    self.totalLotteryLimit = message.recruit_limit
  end
  if message.season ~= nil then
    self.seasonId = message.season
  end
  if message.pityLeftProtectNum ~= nil then
    self.protectLeftCount = message.pityLeftProtectNum
  end
  if message.pityType ~= nil then
    self.protectHeroQuality = message.pityType
  end
  if message.pityProType ~= nil then
    self.pityProType = message.pityProType
  end
  if message.dropinfo ~= nil then
    self.dropInfo = message.dropinfo
  else
    self.dropInfo = heroRecruitCfgRowData.dropinfo
  end
  if message.dropheroinfo ~= nil then
    self.dropHeroInfo = message.dropheroinfo
  end
  if message.pityProProtectNum ~= nil then
    self.pityProProtectNum = message.pityProProtectNum
  end
  if message.pityCurProtectNum ~= nil then
    self.pityCurProtectNum = message.pityCurProtectNum
  end
  if message.pityProNum ~= nil then
    self.pityProNum = message.pityProNum
  end
  if message.pityMaxProtectNum ~= nil then
    self.pityMaxProtectNum = message.pityMaxProtectNum
  end
  if message.recruit_camp ~= nil then
    self.dropCampInfo = message.recruit_camp
  end
  if message.totalLottery ~= nil then
    self.dailyTimes = message.totalLottery
  end
  if message.totalLotteryLimit ~= nil then
    self.dailyLimit = message.totalLotteryLimit
  end
  if message.extra_res and not string.IsNullOrEmpty(message.extra_res) then
    self.resource = message.extra_res
    self.costResources = {}
    local list = string.split(self.resource, ";")
    local t = {}
    t.id = tonumber(list[1])
    t.num = tonumber(list[2])
    self.costResources[1] = t
  end
  if message.img_bg ~= nil then
    self.imgBg = message.img_bg
  else
    self.imgBg = heroRecruitCfgRowData.img_bg
  end
  if message.recruit_lucky_info then
    self.recruit_lucky_info = message.recruit_lucky_info
  else
    self.recruit_lucky_info = heroRecruitCfgRowData.recruit_lucky_info
  end
  self.dropInfoDetail = heroRecruitCfgRowData.dropInfoDetail
  self.pity_dropInfoDetail = heroRecruitCfgRowData.pity_dropInfoDetail
  self.workerDropInfoDetail = heroRecruitCfgRowData.WorkerdropInfoDetail
  self.foreground_image = heroRecruitCfgRowData.foreground_image
  self.is_season = toInt(heroRecruitCfgRowData.is_season)
  self.afterId = heroRecruitCfgRowData.after_id
  self.previousId = heroRecruitCfgRowData.forward_id
  self.wishList = {}
  local wish_list = heroRecruitCfgRowData.wish_list or ""
  if not string.IsNullOrEmpty(wish_list) then
    local wishListSplit = string.split(wish_list, "|")
    for i, v in pairs(wishListSplit) do
      table.insert(self.wishList, v)
    end
  end
  self.wishCondition = heroRecruitCfgRowData.wish_condition
  self.gachaPreviewTime = toInt(heroRecruitCfgRowData.gacha_preview_time)
  self.condition = heroRecruitCfgRowData.condition
  if message.wishSwitch ~= nil then
    self.wishSwitch = message.wishSwitch
  end
  if message.wishHero ~= nil then
    self.wishHero = message.wishHero
  end
  if message.wishPityCurNum ~= nil then
    self.wishPityCurNum = message.wishPityCurNum
  end
  if message.wishPityReceiveNum ~= nil then
    self.wishPityReceiveNum = message.wishPityReceiveNum
  end
  self.wishPity = heroRecruitCfgRowData.wish_pity
  self.gachaNewEndtime = heroRecruitCfgRowData.gacha_new_endtime
  self.item_extraInfo = heroRecruitCfgRowData.item_extra
  if not string.IsNullOrEmpty(self.item_extraInfo) then
    self.recruit100ConditionInfo = {}
    self.recruit100CostInfo = {}
    local item_extraInfoSplit1 = string.split(self.item_extraInfo, ";")
    if table.count(item_extraInfoSplit1) >= 3 then
      local showConditionItemCount = item_extraInfoSplit1[1]
      local costItemId = item_extraInfoSplit1[2]
      local costNum = item_extraInfoSplit1[3]
      self.recruit100ConditionInfo.itemId = costItemId
      self.recruit100ConditionInfo.itemNum = toInt(showConditionItemCount)
      self.recruit100CostInfo.itemId = costItemId
      self.recruit100CostInfo.itemNum = toInt(costNum)
    end
  end
  self.pity = heroRecruitCfgRowData.pity
end

local function IsShowTime(self)
  return self.endTime > self.startTime and self.time_type ~= LotteryTimeType.LotteryTimeType_Expert
end

local function IsDurationType(self)
  return self.time_type == LotteryTimeType.LotteryTimeType_Ten and self.endTime > self.startTime
end

local function IsOpen(self)
  if self.endTime <= self.startTime then
    return true
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  return now > self.startTime and now < self.endTime
end

local function GetCostItems(self)
  return self.costItems
end

local function GetCostResources(self)
  return self.costResources
end

local function IsAllowMultiRecruit(self)
  return self.costResources or self.costItems and #self.costItems >= 2
end

local function GetIconName(self)
  return self.picture_small
end

local function GetTabBgName(self)
  return string.format(LoadPath.HeroRecruitPath, self.imgBg)
end

local function IsSupportFreeRecruit(self)
  return self.dailyFreeLimit > 0
end

local function CanFreeRecruit(self)
  local now = UITimeManager:GetInstance():GetServerSeconds()
  local canFreeRecruit = now >= self.dailyFreeNextFreshTime
  return canFreeRecruit
end

function LotteryInfo:GetDropInfoDetailData()
  if self.dropInfoDetailData == nil then
    self.dropInfoDetailData = {}
    self.dropInfoDetailData[ItemColor.GOLDEN] = {}
    self.dropInfoDetailData[ItemColor.ORANGE] = {}
    self.dropInfoDetailData[ItemColor.PURPLE] = {}
    self.dropInfoDetailData[ItemColor.BLUE] = {}
    self.dropInfoDetailData[ItemColor.GREEN] = {}
    self.dropInfoDetailData[ItemColor.WHITE] = {}
    if not string.IsNullOrEmpty(self.dropInfoDetail) then
      local dropList = string.split(self.dropInfoDetail, "|")
      for _, v in ipairs(dropList) do
        local dropItem = string.split(v, ";")
        if 4 <= #dropItem then
          local type = toInt(dropItem[1])
          local id = toInt(dropItem[2])
          local num = toInt(dropItem[3])
          local rate = tonumber(dropItem[4])
          local flag = toInt(dropItem[5])
          rate = rate * 100
          local quality = LotteryInfo.GetQualityByTypeAndId(type, id)
          if self.dropInfoDetailData[quality] ~= nil then
            local itemData = {
              type = type,
              id = id,
              num = num,
              rate = rate,
              flag = flag
            }
            table.insert(self.dropInfoDetailData[quality], itemData)
          end
        end
      end
    end
  end
  return self.dropInfoDetailData
end

function LotteryInfo:GetPityDropInfoDetailData()
  if self.pityDropInfoDetailData == nil then
    self.pityDropInfoDetailData = {}
    self.pityDropInfoDetailData[ItemColor.GOLDEN] = {}
    self.pityDropInfoDetailData[ItemColor.ORANGE] = {}
    self.pityDropInfoDetailData[ItemColor.PURPLE] = {}
    self.pityDropInfoDetailData[ItemColor.BLUE] = {}
    self.pityDropInfoDetailData[ItemColor.GREEN] = {}
    self.pityDropInfoDetailData[ItemColor.WHITE] = {}
    if not string.IsNullOrEmpty(self.pity_dropInfoDetail) then
      local dropList = string.split(self.pity_dropInfoDetail, "|")
      for _, v in ipairs(dropList) do
        local dropItem = string.split(v, ";")
        if 4 <= #dropItem then
          local type = toInt(dropItem[1])
          local id = toInt(dropItem[2])
          local num = toInt(dropItem[3])
          local rate = tonumber(dropItem[4])
          local flag = toInt(dropItem[5])
          rate = rate * 100
          local quality = LotteryInfo.GetQualityByTypeAndId(type, id)
          if self.pityDropInfoDetailData[quality] ~= nil then
            local itemData = {
              type = type,
              id = id,
              num = num,
              rate = rate,
              flag = flag
            }
            table.insert(self.pityDropInfoDetailData[quality], itemData)
          end
        end
      end
    end
  end
  return self.pityDropInfoDetailData
end

local function GetQualityByTypeAndId(type, id)
  if type == HeroRecruitRateDetailInfoType.Hero then
    local heroTemplate = DataCenter.HeroTemplateManager:GetTemplate(id)
    return heroTemplate.quality
  elseif type == HeroRecruitRateDetailInfoType.Goods then
    local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(id)
    return itemTemplate.quality
  elseif type == HeroRecruitRateDetailInfoType.ResItem then
    local resItemTemplate = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(id)
    return resItemTemplate.quality
  elseif type == HeroRecruitRateDetailInfoType.Worker then
    local workerTemplate = DataCenter.WorkerTemplateManager:GetShowTemplateById(id)
    return workerTemplate.quality
  elseif type == HeroRecruitRateDetailInfoType.SquadEquip then
    local squadEquipTemplate = DataCenter.CommonEquipTemplateManager:GetTemplate(id)
    return squadEquipTemplate.quality
  elseif type == HeroRecruitRateDetailInfoType.Equip then
    local equipTemplate = DataCenter.EquipTemplateManager:GetTemplate(id)
    return equipTemplate.quality
  elseif type == HeroRecruitRateDetailInfoType.SkillChip then
    local chipTemplate = DataCenter.TWSkillChipTemplateManager:GetTemplate(id)
    return chipTemplate.quality
  end
end

local function IsShowWish(self)
  local isOpen = self.wishSwitch
  if isOpen then
    local now = UITimeManager:GetInstance():GetServerTime()
    if self:IsDurationType() and now < self.startTime then
      return false
    end
    return self.wishPityReceiveNum > 0 and not table.IsNullOrEmpty(self.wishList)
  end
  return false
end

local function GetCurSelectWishHeroId(self)
  if self.wishHero and not string.IsNullOrEmpty(self.wishHero) then
    return self.wishHero
  end
end

local function GetHeroIdList(self)
  local res = {}
  if not string.IsNullOrEmpty(self.dropInfoDetail) then
    local dropList = string.split(self.dropInfoDetail, "|")
    for _, v in ipairs(dropList) do
      local dropItem = string.split(v, ";")
      if 4 <= #dropItem then
        local type = toInt(dropItem[1])
        local id = toInt(dropItem[2])
        if type == 1 then
          table.insert(res, id)
        end
      end
    end
  end
  return res
end

function LotteryInfo:GetOpenServerDay()
  local openServerTime = LuaEntry.Player.openServerTime
  local openServerDayZeroTimeMS = UITimeManager:GetInstance():GetTodayZeroServerTime(openServerTime / 1000) * 1000
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local curDayZeroTimeMS = UITimeManager:GetInstance():GetTodayZeroServerTime(curTime / 1000) * 1000
  return (curDayZeroTimeMS - openServerDayZeroTimeMS) // 86400000 + 1
end

function LotteryInfo:GetNewHeroShowEndTimeForPreview()
  if string.IsNullOrEmpty(self.gachaNewEndtime) then
    return nil
  end
  local conditionPair = string.split(self.gachaNewEndtime, "|")
  if #conditionPair == 2 then
    if tonumber(conditionPair[1]) == 1 then
      local openServerStartDay = tonumber(conditionPair[2])
      local openServerCurDay = self:GetOpenServerDay()
      local curTime = UITimeManager:GetInstance():GetServerTime()
      local todayZeroTimeMS = UITimeManager:GetInstance():GetTodayZeroServerTime(curTime / 1000) * 1000
      local startTime = todayZeroTimeMS + (openServerStartDay - openServerCurDay) * 60 * 60 * 24 * 1000
      return startTime
    end
    if tonumber(conditionPair[1]) == 2 then
      local subConditionPair = string.split(conditionPair[2], ",")
      if #subConditionPair == 2 then
        local season = tonumber(subConditionPair[1])
        local day = tonumber(subConditionPair[2])
        local curSeason = SeasonUtil.GetSeason()
        local curSeasonDay = SeasonUtil.GetSeasonDay()
        if season == curSeason then
          local curTime = UITimeManager:GetInstance():GetServerTime()
          local todayZeroTimeMS = UITimeManager:GetInstance():GetTodayZeroServerTime(curTime / 1000) * 1000
          local startTime = todayZeroTimeMS + (day - curSeasonDay) * 60 * 60 * 24 * 1000
          return startTime
        end
      end
    end
  end
end

function LotteryInfo:GetStartTimeForPreview()
  if string.IsNullOrEmpty(self.condition) then
    return nil
  end
  local conditionPair = string.split(self.condition, "|")
  local conditionDict = {}
  for i, v in pairs(conditionPair) do
    local subPair = string.split(v, ";")
    if #subPair == 2 then
      conditionDict[subPair[1]] = subPair[2]
    end
  end
  if conditionDict[HeroRecruitTimeConditionType.Season] ~= nil and conditionDict[HeroRecruitTimeConditionType.SeasonStartDay] ~= nil then
    local seasonConditionPair = string.split(conditionDict[HeroRecruitTimeConditionType.Season], "-")
    if #seasonConditionPair == 2 then
      local seasonStart = tonumber(seasonConditionPair[1])
      local seasonEnd = tonumber(seasonConditionPair[2])
      if seasonStart == seasonEnd then
        local curSeason = SeasonUtil.GetSeason()
        local curSeasonDay = SeasonUtil.GetSeasonDay()
        if curSeason == seasonStart then
          local startSeasonDay = tonumber(conditionDict[HeroRecruitTimeConditionType.SeasonStartDay])
          local curTime = UITimeManager:GetInstance():GetServerTime()
          local todayZeroTimeMS = UITimeManager:GetInstance():GetTodayZeroServerTime(curTime / 1000) * 1000
          local startTime = todayZeroTimeMS + (startSeasonDay - curSeasonDay) * 60 * 60 * 24 * 1000
          return startTime
        end
      end
    end
  end
  if conditionDict[HeroRecruitTimeConditionType.ServerOpenDay] ~= nil then
    local openServerStartDay = tonumber(conditionDict[HeroRecruitTimeConditionType.ServerOpenDay])
    local openServerCurDay = self:GetOpenServerDay()
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local todayZeroTimeMS = UITimeManager:GetInstance():GetTodayZeroServerTime(curTime / 1000) * 1000
    local startTime = todayZeroTimeMS + (openServerStartDay - openServerCurDay) * 60 * 60 * 24 * 1000
    return startTime
  end
end

function LotteryInfo:GetNextLotteryNewHeroIdList()
  local res = {}
  local nextLottery = self:GetAfterInfo()
  if nextLottery then
    local nextHeroList = nextLottery:GetHeroIdList()
    if not table.IsNullOrEmpty(nextHeroList) then
      local curHeroList = self:GetHeroIdList()
      for _, v in pairs(nextHeroList) do
        local isContains = false
        for _, k in pairs(curHeroList) do
          if k == v then
            isContains = true
            break
          end
        end
        if not isContains then
          table.insert(res, v)
        end
      end
    end
  end
  return res
end

function LotteryInfo:GetNextLotteryNewHeroIdListForPreview()
  local nextLottery = self:GetAfterInfo()
  if not nextLottery then
    return nil
  end
  local nextLotteryStartTime = nextLottery:GetStartTimeForPreview()
  if not nextLotteryStartTime then
    return nil
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  local nextLeftTime = nextLotteryStartTime - now
  if nextLeftTime <= 0 then
    return nil
  end
  if nextLeftTime <= self.gachaPreviewTime * 1000 then
    return self:GetNextLotteryNewHeroIdList(), nextLotteryStartTime
  end
end

function LotteryInfo:GetCurLotteryNewHeroIdListForPreview()
  local res = {}
  local tmpList = {}
  local preLottery = self:GetPreviousInfo()
  if preLottery then
    local curHeroList = self:GetHeroIdList()
    if not table.IsNullOrEmpty(curHeroList) then
      local isOn = true
      local lotteryStartTime = self:GetStartTimeForCurNewHero()
      if lotteryStartTime ~= nil then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local passedTime = curTime - lotteryStartTime
        if 604800000 < passedTime then
          isOn = false
        end
        if isOn then
          local preHeroList = preLottery:GetHeroIdList()
          for _, v in pairs(curHeroList) do
            local isContains = false
            for _, k in pairs(preHeroList) do
              if k == v then
                isContains = true
                break
              end
            end
            if not isContains then
              table.insert(tmpList, v)
            end
          end
        end
      end
    end
  end
  local hasShownHeroIdList = DataCenter.LotteryDataManager:GetAllShownCurLotteryNewHeroIdList()
  for _, v in pairs(tmpList) do
    local isContains = false
    for _, k in pairs(hasShownHeroIdList) do
      if k == v then
        isContains = true
        break
      end
    end
    if not isContains then
      table.insert(res, v)
    end
  end
  return res
end

function LotteryInfo:GetNextLotteryNewWishIdList(includeEmptyCurWish)
  local res = {}
  local nextLottery = self:GetAfterInfo()
  if nextLottery then
    local nextWishList = nextLottery.wishList
    if not table.IsNullOrEmpty(nextWishList) then
      local curWishList = self.wishList
      for _, v in pairs(nextWishList) do
        if table.IsNullOrEmpty(curWishList) then
          if includeEmptyCurWish then
            table.insert(res, v)
          end
        else
          local isContains = false
          for _, k in pairs(curWishList) do
            if k == v then
              isContains = true
              break
            end
          end
          if not isContains then
            table.insert(res, v)
          end
        end
      end
    end
  end
  return res
end

function LotteryInfo:GetPreviewInfo()
  local res = {}
  local curNewHeroList = self:GetCurLotteryNewHeroIdListForPreview()
  if not table.IsNullOrEmpty(curNewHeroList) then
    for i, v in pairs(curNewHeroList) do
      local info = {
        type = PreviewComponent.Type.CurNew,
        heroId = v,
        lotteryId = self.id,
        startTime = nil
      }
      table.insert(res, info)
    end
  end
  local nextNewHeroList, nextStartTime = self:GetNextLotteryNewHeroIdListForPreview()
  if not table.IsNullOrEmpty(nextNewHeroList) then
    for i, v in pairs(nextNewHeroList) do
      local info = {
        type = PreviewComponent.Type.NextPreview,
        heroId = v,
        startTime = nextStartTime
      }
      local nextInfo = self:GetAfterInfo()
      if nextInfo then
        info.lotteryId = nextInfo.id
      end
      table.insert(res, info)
    end
  end
  return res
end

function LotteryInfo:IsInServerCondition(serverId)
  if string.IsNullOrEmpty(self.condition) then
    return false
  end
  local conditionPair = string.split(self.condition, "|")
  local conditionDict = {}
  for i, v in pairs(conditionPair) do
    local subPair = string.split(v, ";")
    if #subPair == 2 then
      conditionDict[subPair[1]] = subPair[2]
    end
  end
  if conditionDict[HeroRecruitTimeConditionType.ServerId] ~= nil and conditionDict[HeroRecruitTimeConditionType.ServerId] ~= nil then
    local serverConditionPair = string.split(conditionDict[HeroRecruitTimeConditionType.ServerId], "-")
    if #serverConditionPair == 2 then
      local serverIdStart = tonumber(serverConditionPair[1])
      local serverIdEnd = tonumber(serverConditionPair[2])
      if serverIdStart and serverIdEnd and serverId >= serverIdStart and serverId <= serverIdEnd then
        return true
      end
    end
  end
  return false
end

function LotteryInfo:GetPreviousInfo()
  if self.previousInfo == nil and not string.IsNullOrEmpty(self.previousId) then
    local curServerId = LuaEntry.Player:GetCurServerId()
    local splitIds = string.split(self.previousId, "|")
    if #splitIds == 1 then
      local info = LotteryInfo.New()
      info:UpdateInfo({
        id = self.previousId
      })
      self.previousInfo = info
    else
      for _, id in pairs(splitIds) do
        local info = LotteryInfo.New()
        info:UpdateInfo({id = id})
        if info:IsInServerCondition(curServerId) then
          self.previousInfo = info
          break
        end
      end
    end
  end
  return self.previousInfo
end

function LotteryInfo:GetAfterInfo()
  if self.afterInfo == nil and not string.IsNullOrEmpty(self.afterId) then
    local info = LotteryInfo.New()
    info:UpdateInfo({
      id = self.afterId
    })
    self.afterInfo = info
  end
  return self.afterInfo
end

function LotteryInfo:IsCanClaimWish()
  if self.wishSwitch and self.wishPityReceiveNum > 0 and self.wishPityCurNum >= self.wishPityReceiveNum then
    return true
  end
  return false
end

function LotteryInfo:GetWishStartTimeForNewTag()
  if not string.IsNullOrEmpty(self.wishCondition) then
    local strSplit = string.split(self.wishCondition, "|")
    for i, v in pairs(strSplit) do
      local strSplitSub = string.split(v, ";")
      if #strSplitSub == 2 then
        if strSplitSub[1] == "149" then
          local strSplitSub2 = string.split(strSplitSub[2], ",")
          if #strSplitSub2 == 2 then
            local startSeason = tonumber(strSplitSub2[1])
            local startDay = tonumber(strSplitSub2[2])
            local curSeason = SeasonUtil.GetSeason()
            if curSeason == startSeason then
              local curDay = SeasonUtil.GetSeasonDay()
              local curTime = UITimeManager:GetInstance():GetServerTime()
              local todayZeroTimeMS = UITimeManager:GetInstance():GetTodayZeroServerTime(curTime / 1000) * 1000
              local startTime = todayZeroTimeMS + (startDay - curDay) * 60 * 60 * 24 * 1000
              return startTime
            end
          end
        end
        if strSplitSub[1] == 8 then
          local openServerDay = self:GetOpenServerDay()
          local startOpenServerDay = tonumber(strSplitSub[2])
          local curTime = UITimeManager:GetInstance():GetServerTime()
          local todayZeroTimeMS = UITimeManager:GetInstance():GetTodayZeroServerTime(curTime / 1000) * 1000
          local startTime = todayZeroTimeMS + (startOpenServerDay - openServerDay) * 60 * 60 * 24 * 1000
          return startTime
        end
      end
    end
  end
end

function LotteryInfo:GetWishLotterySecondConfirmKey()
  local function IsOtherHerosNotReachMaxRank(heroId)
    local heroIdList = self.wishList
    
    if not table.IsNullOrEmpty(heroIdList) then
      for i, v in pairs(heroIdList) do
        if tostring(v) ~= tostring(heroId) then
          local heroInfo = DataCenter.HeroDataManager:GetHeroByHeroId(v)
          if heroInfo and not heroInfo:IsReachMaxRank() then
            return true
          end
        end
      end
    end
    return false
  end
  
  local function IsOtherHerosNotReachHonorMaxLevel(heroId)
    local heroIdList = self.wishList
    if not table.IsNullOrEmpty(heroIdList) then
      for i, v in pairs(heroIdList) do
        if tostring(v) ~= tostring(heroId) then
          local heroInfo = DataCenter.HeroDataManager:GetHeroByHeroId(v)
          if heroInfo and not heroInfo:IsReachMaxHonorLevel() then
            return true
          end
        end
      end
    end
    return false
  end
  
  if not self:IsShowWish() then
    return nil
  end
  local curSelect = self:GetCurSelectWishHeroId()
  if curSelect == nil then
    return nil
  end
  local heroInfo = DataCenter.HeroDataManager:GetHeroByHeroId(curSelect)
  if not heroInfo then
    return nil
  end
  if not heroInfo:IsReachMaxRank() then
    return nil
  end
  if IsOtherHerosNotReachMaxRank(curSelect) then
    return "herorecruit_alert2"
  end
  if not heroInfo:IsReachMaxHonorLevel() then
    return nil
  end
  if IsOtherHerosNotReachHonorMaxLevel(curSelect) then
    return "herorecruit_alert5"
  end
  return nil
end

function LotteryInfo:GetHundredBtnShowCondition()
  return self.recruit100ConditionInfo
end

function LotteryInfo:GetHundredCost()
  return self.recruit100CostInfo
end

function LotteryInfo:GetStartTimeForCurNewHero()
  if string.IsNullOrEmpty(self.condition) then
    return nil
  end
  local conditionPair = string.split(self.condition, "|")
  local conditionDict = {}
  for i, v in pairs(conditionPair) do
    local subPair = string.split(v, ";")
    if #subPair == 2 then
      conditionDict[subPair[1]] = subPair[2]
    end
  end
  if conditionDict[HeroRecruitTimeConditionType.ServerOpenDay] ~= nil then
    local openServerStartDay = tonumber(conditionDict[HeroRecruitTimeConditionType.ServerOpenDay])
    local openServerCurDay = self:GetOpenServerDay()
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local todayZeroTimeMS = UITimeManager:GetInstance():GetTodayZeroServerTime(curTime / 1000) * 1000
    local startTime = todayZeroTimeMS + (openServerStartDay - openServerCurDay) * 60 * 60 * 24 * 1000
    return startTime
  end
  if conditionDict[HeroRecruitTimeConditionType.Season] ~= nil then
    local seasonConditionPair = string.split(conditionDict[HeroRecruitTimeConditionType.Season], "-")
    if #seasonConditionPair == 2 then
      local seasonStart = tonumber(seasonConditionPair[1])
      local seasonEnd = tonumber(seasonConditionPair[2])
      if seasonStart == seasonEnd then
        local curSeason = SeasonUtil.GetSeason()
        local curSeasonDay = SeasonUtil.GetSeasonDay()
        if curSeason == seasonStart then
          local startSeasonDay = 1
          if conditionDict[HeroRecruitTimeConditionType.SeasonStartDay] ~= nil then
            startSeasonDay = tonumber(conditionDict[HeroRecruitTimeConditionType.SeasonStartDay])
          end
          local curTime = UITimeManager:GetInstance():GetServerTime()
          local todayZeroTimeMS = UITimeManager:GetInstance():GetTodayZeroServerTime(curTime / 1000) * 1000
          local startTime = todayZeroTimeMS + (startSeasonDay - curSeasonDay) * 60 * 60 * 24 * 1000
          return startTime
        end
      end
    end
  end
end

LotteryInfo.__init = __init
LotteryInfo.__delete = __delete
LotteryInfo.UpdateInfo = UpdateInfo
LotteryInfo.IsShowTime = IsShowTime
LotteryInfo.IsOpen = IsOpen
LotteryInfo.GetCostItems = GetCostItems
LotteryInfo.IsAllowMultiRecruit = IsAllowMultiRecruit
LotteryInfo.GetIconName = GetIconName
LotteryInfo.GetTabBgName = GetTabBgName
LotteryInfo.GetCostResources = GetCostResources
LotteryInfo.IsSupportFreeRecruit = IsSupportFreeRecruit
LotteryInfo.CanFreeRecruit = CanFreeRecruit
LotteryInfo.IsDurationType = IsDurationType
LotteryInfo.GetQualityByTypeAndId = GetQualityByTypeAndId
LotteryInfo.IsShowWish = IsShowWish
LotteryInfo.GetCurSelectWishHeroId = GetCurSelectWishHeroId
LotteryInfo.GetHeroIdList = GetHeroIdList
return LotteryInfo
