local Localization = CS.GameEntry.Localization
local RewardUtil = {}

local function GetPic(rewardType, itemId)
  if rewardType ~= nil then
    if rewardType ~= RewardType.GOODS or itemId == nil then
    else
      local goods = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
      if goods ~= nil then
        return string.format(LoadPath.ItemPath, goods.icon)
      else
        local resourceType = tonumber(itemId)
        if resourceType < 100 then
          return DataCenter.ResourceManager:GetResourceIconByType(resourceType)
        end
      end
    end
    return DataCenter.RewardManager:GetPicByType(rewardType, itemId)
  end
  return ""
end

local function GetName(rewardType, itemId)
  local name = ""
  if rewardType == nil then
  elseif rewardType == RewardType.GOODS then
    if itemId == nil then
    else
      local goods = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
      if goods ~= nil then
        name = DataCenter.ItemTemplateManager:GetName(itemId)
      else
        local resourceType = tonumber(itemId)
        name = DataCenter.ResourceManager:GetResourceNameByType(resourceType)
      end
    end
  elseif rewardType == RewardType.GOLD then
    name = Localization:GetString("100183")
  elseif rewardType == RewardType.OIL or rewardType == RewardType.METAL or rewardType == RewardType.FORMATION_STAMINA or rewardType == RewardType.WATER or rewardType == RewardType.PVE_POINT or rewardType == RewardType.DETECT_EVENT or rewardType == RewardType.FOOD or rewardType == RewardType.ELECTRICITY or rewardType == RewardType.WOOD or rewardType == RewardType.FLINT or rewardType == RewardType.OBSIDIAN then
    name = Localization:GetString(ResourceTypeTxt[rewardType])
  elseif rewardType == RewardType.ARM then
    local army = DataCenter.ArmyTemplateManager:GetArmyTemplate(itemId)
    if army ~= nil then
      name = Localization:GetString(army.name)
    end
  elseif rewardType == RewardType.EQUIP then
    local xmlData = LocalController:instance():getLine("equip_info_new_equip", itemId)
    if xmlData ~= nil then
      name = Localization:GetString(xmlData:GetString("name"))
    end
  elseif rewardType == RewardType.HERO then
  elseif rewardType == RewardType.HONOR or rewardType == RewardType.ALLIANCE_POINT then
    name = DataCenter.RewardManager:GetNameByType(rewardType, itemId)
  elseif rewardType == RewardType.MATERIAL then
    local goods = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
    if goods ~= nil then
      name = DataCenter.ItemTemplateManager:GetName(itemId)
    end
  elseif rewardType == RewardType.RESOURCE_ITEM then
    local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(itemId)
    if template ~= nil then
      name = DataCenter.RewardManager:GetNameByType(rewardType, itemId)
    end
  elseif rewardType == RewardType.EXP then
    name = DataCenter.RewardManager:GetNameByType(rewardType)
  elseif rewardType == RewardType.WORKER or rewardType == RewardType.VISITOR then
  end
  return name
end

local function IsHaveWorldReward()
  local list = DataCenter.CollectRewardDataManager:GetRewardListBySort()
  if not table.IsNullOrEmpty(list) and UITimeManager:GetInstance():GetServerTime() <= list[1].expireTime then
    return true
  end
  if not BattleFieldUtil.InBattleField() then
    local cardBoxList = DataCenter.SeasonDataManager.cardBoxList
    if cardBoxList ~= nil and table.count(cardBoxList) > 0 then
      return true
    end
  end
  if not BattleFieldUtil.InBattleField() then
    local isExistFlowerArrived = FlowerTrainUtils.IsExistAnySelfFlowerTrainArrived()
    if isExistFlowerArrived then
      return true
    end
  end
  return false
end

local function GetRewardItem(rewardId)
  local res = {}
  local rewardConfig = LocalController:instance():getLine(TableName.RewardConfig, tonumber(rewardId))
  if rewardConfig ~= nil then
    local itemValues = rewardConfig:getValue("item") or ""
    local numValues = rewardConfig:getValue("num") or ""
    if not string.IsNullOrEmpty(itemValues) and not string.IsNullOrEmpty(numValues) then
      local ids = string.split(itemValues, "|")
      local nums = string.split(numValues, "|")
      if ids ~= nil and 0 < #ids then
        for i, id in pairs(ids) do
          local oneData = {}
          oneData.itemId = id
          oneData.count = tonumber(nums[i]) or 0
          oneData.rewardType = RewardType.GOODS
          table.insert(res, oneData)
        end
      end
    end
  end
  return res
end

local function GetRewardItemAndResource(rewardId, firstSep)
  firstSep = firstSep or "|"
  local res = {}
  local rewardConfig = LocalController:instance():getLine(TableName.RewardConfig, tonumber(rewardId))
  if rewardConfig ~= nil then
    local itemValues = rewardConfig:getValue("item") or ""
    local numValues = rewardConfig:getValue("num") or ""
    if not string.IsNullOrEmpty(itemValues) and not string.IsNullOrEmpty(numValues) then
      local ids = string.split(itemValues, firstSep)
      local nums = string.split(numValues, firstSep)
      if ids ~= nil and 0 < #ids then
        for i, id in pairs(ids) do
          local oneData = {}
          oneData.itemId = id
          oneData.count = tonumber(nums[i]) or 0
          oneData.rewardType = RewardType.GOODS
          table.insert(res, oneData)
        end
      end
    end
    local resourceRandomType = rewardConfig:getValue("resource_randomtype") or ""
    local resourceRate = rewardConfig:getValue("resource_rate") or ""
    if not string.IsNullOrEmpty(resourceRandomType) and not string.IsNullOrEmpty(resourceRate) then
      local ids = string.split(resourceRandomType, firstSep)
      local nums = string.split(resourceRate, firstSep)
      if ids ~= nil and 0 < #ids then
        for i, id in pairs(ids) do
          local oneData = {}
          oneData.itemId = id
          if nums[i] then
            local numss = string.split(nums[i], ";")
            oneData.count = tonumber(numss[1]) or 0
          else
            oneData.count = 0
          end
          oneData.rewardType = RewardType.RESOURCE
          table.insert(res, oneData)
        end
      end
    end
  end
  return res
end

local __heroEventUserData = {}

function RewardUtil.UpdateHeroEventData(data)
  if __heroEventUserData == nil then
    __heroEventUserData = {}
  end
  if data then
    for uuid, value in pairs(data) do
      __heroEventUserData[uuid] = value
    end
  end
end

function RewardUtil.UpdateHeroEventDataSingle(data)
  if table.IsNullOrEmpty(data) then
    return
  end
  local uuid = tostring(data.uuid or "")
  if string.IsNullOrEmpty(uuid) then
    return
  end
  if __heroEventUserData == nil then
    __heroEventUserData = {}
  end
  local existData = __heroEventUserData[uuid] or {}
  existData.score = data.score or existData.score or 0
  existData.scoreRewardIndex = data.scoreRewardIndex or existData.scoreRewardIndex or {}
  __heroEventUserData[uuid] = existData
  EventManager:GetInstance():Broadcast(EventId.HeroEventDataUpdate, uuid)
end

function RewardUtil.FetchHeroEventData(uuid)
  if __heroEventUserData == nil or uuid == nil or uuid == 0 or uuid == "" then
    return nil
  end
  return __heroEventUserData[uuid] or __heroEventUserData[tostring(uuid)] or {
    score = 0,
    scoreRewardIndex = {}
  }
end

function RewardUtil.AddHeroEventData(uuid, data)
  if __heroEventUserData == nil then
    __heroEventUserData = {}
  end
  if uuid and data and __heroEventUserData[uuid] == nil then
    __heroEventUserData[uuid] = data
  end
end

local __rewardsCache = {}

local function _AddToList(list, line, keyItem, keyNum, rewardType)
  local itemValues = line:getValue(keyItem) or ""
  local numValues = line:getValue(keyNum) or ""
  local MyStrNull = string.IsNullOrEmpty
  if not MyStrNull(itemValues) and not MyStrNull(numValues) then
    local MySplit = string.split
    local MyToNum = tonumber
    local MyInsert = table.insert
    local ids = MySplit(itemValues, "|")
    local nums = MySplit(numValues, "|")
    if ids ~= nil and 0 < #ids then
      for i, id in pairs(ids) do
        local oneData = {}
        oneData.itemId = id
        if rewardType == RewardType.GOODS then
          oneData.count = MyToNum(nums[i]) or 0
        else
          local numss = MySplit(nums[i], ";")
          oneData.count = MyToNum(numss[1]) or 0
        end
        oneData.rewardType = rewardType
        MyInsert(list, oneData)
      end
    end
  end
end

function RewardUtil.GetRewardsById(rewardId, bSortReversal)
  if __rewardsCache == nil then
    __rewardsCache = {}
  end
  local groups = {}
  if rewardId == nil or rewardId == 0 then
    return groups
  end
  local cacheKey = string.format("%s_%s", rewardId, bSortReversal and "R" or "N")
  local list = __rewardsCache[cacheKey]
  if list ~= nil then
    return list
  end
  local line = LocalController:instance():getLine(TableName.RewardConfig, rewardId)
  if line == nil then
    return groups
  end
  if bSortReversal then
    _AddToList(groups, line, "resource_randomtype", "resource_rate", RewardType.RESOURCE)
  else
    _AddToList(groups, line, "item", "num", RewardType.GOODS)
  end
  _AddToList(groups, line, "resource_item_random_type", "resource_item_rate", RewardType.RESOURCE_ITEM)
  if bSortReversal then
    _AddToList(groups, line, "item", "num", RewardType.GOODS)
  else
    _AddToList(groups, line, "resource_randomtype", "resource_rate", RewardType.RESOURCE)
  end
  __rewardsCache[cacheKey] = groups
  return groups
end

RewardUtil.GetPic = GetPic
RewardUtil.GetName = GetName
RewardUtil.IsHaveWorldReward = IsHaveWorldReward
RewardUtil.GetRewardItem = GetRewardItem
RewardUtil.GetRewardItemAndResource = GetRewardItemAndResource
return ConstClass("RewardUtil", RewardUtil)
