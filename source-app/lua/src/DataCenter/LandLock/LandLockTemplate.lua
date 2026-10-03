local LandLockTemplate = BaseClass("LandLockTemplate")

local function __init(self)
  self.id = 0
  self.prefabName = ""
  self.unity_type = 0
  self.pos = {x = 0, y = 0}
  self.costResource = {}
  self.costItem = {}
  self.costResourceItem = {}
  self.order = 0
  self.priorList = {}
  self.nextList = {}
  self.pveList = {}
  self.buildIdList = {}
  self.buildPosList = {}
  self.needBuild = {}
  self.tileList = {}
  self.height = 0
  self.rect = {
    left = 0,
    right = 0,
    bottom = 0,
    top = 0
  }
  self.needArmy = {level = 0, count = 0}
  self.rewardItemList = {}
  self.rewardType = LandLockRewardType.None
  self.rewardInitCount = 0
  self.bubbleType = 0
  self.needChapter = 0
  self.noviceBoot = ""
  self.dynamicObj = {}
  self.needQuest = {}
  self.domeRange = DomeRange.Zero
  self.boundingRectTiles = nil
  self.animOff = false
  self.showRewards = {}
  self.showBuildIds = {}
  self.unlockModel = nil
  self.cheerleader = nil
  self.cheerleaderEnd = nil
  self.city_fog = nil
  self.landToZone = nil
  self.hideRewardPop = false
end

local function __delete(self)
  self.id = nil
  self.prefabName = nil
  self.unity_type = nil
  self.pos = nil
  self.costResource = nil
  self.costItem = nil
  self.costResourceItem = nil
  self.order = nil
  self.priorList = nil
  self.nextList = nil
  self.pveList = nil
  self.buildIdList = nil
  self.buildPosList = nil
  self.needBuild = nil
  self.tileList = nil
  self.height = nil
  self.rect = nil
  self.needArmy = nil
  self.rewardItemList = nil
  self.rewardType = nil
  self.rewardInitCount = nil
  self.bubbleType = nil
  self.needChapter = nil
  self.noviceBoot = nil
  self.dynamicObj = nil
  self.needQuest = nil
  self.domeRange = nil
  self.boundingRectTiles = nil
  self.animOff = nil
  self.showRewards = nil
  self.showBuildIds = nil
  self.unlockModel = nil
  self.cheerleader = nil
  self.cheerleaderEnd = nil
  self.city_fog = nil
  self.landToZone = nil
  self.hideRewardPop = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.prefabName = row:getValue("icon") or ""
  self.unity_type = tonumber(row:getValue("UnityType")) or 0
  local posStrs = string.split(row:getValue("Pos") or "", ";")
  if #posStrs == 2 then
    self.pos.x = tonumber(posStrs[1]) or 0
    self.pos.y = tonumber(posStrs[2]) or 0
  end
  self.costResource = {}
  local costResourceStrs = string.split(row:getValue("cost_resource") or "", "|")
  for _, str in ipairs(costResourceStrs) do
    local spls = string.split(str, ";")
    if #spls == 2 then
      self.costResource[tonumber(spls[1])] = tonumber(spls[2])
    end
  end
  self.costItem = {}
  local costItemStrs = string.split(row:getValue("cost_item") or "", "|")
  for _, str in ipairs(costItemStrs) do
    local spls = string.split(str, ";")
    if #spls == 2 then
      self.costItem[tonumber(spls[1])] = tonumber(spls[2])
    end
  end
  self.costResourceItem = {}
  local costResourceItemStrs = string.split(row:getValue("cost_resource_item") or "", "|")
  for _, str in ipairs(costResourceItemStrs) do
    local spls = string.split(str, ";")
    if #spls == 2 then
      self.costResourceItem[tonumber(spls[1])] = tonumber(spls[2])
    end
  end
  self.order = tonumber(row:getValue("order")) or 0
  self.priorList = {}
  local priorStrs = string.split(row:getValue("pre") or "", ";")
  for _, str in ipairs(priorStrs) do
    table.insert(self.priorList, tonumber(str))
  end
  self.pveList = {}
  local pveStrs = string.split(row:getValue("pve") or "", ";")
  for _, str in ipairs(pveStrs) do
    local pve = tonumber(str) or 0
    if pve ~= 0 then
      table.insert(self.pveList, pve)
    end
  end
  self.buildIdList = {}
  local buildIdStrs = string.split(row:getValue("building") or "", ";")
  for _, str in ipairs(buildIdStrs) do
    table.insert(self.buildIdList, tonumber(str))
  end
  self.buildPosList = {}
  local buildPosStrs = string.split(row:getValue("bPos") or "", "|")
  for _, str in ipairs(buildPosStrs) do
    local spls = string.split(str, ";")
    if #spls == 2 then
      local x = tonumber(spls[1])
      local y = tonumber(spls[2])
      table.insert(self.buildPosList, {x = x, y = y})
    end
  end
  self.needBuild = {}
  local needBuildStrs = string.split(row:getValue("pre_build") or "", ";")
  for _, str in ipairs(needBuildStrs) do
    local n = tonumber(str)
    if n ~= nil then
      local buildId = n // BuildLevelCap * BuildLevelCap
      local level = n % BuildLevelCap
      table.insert(self.needBuild, {buildId = buildId, level = level})
    end
  end
  self.tileList = {}
  self.rect = {}
  local tileStrs = string.split(row:getValue("Tiles") or "", "|")
  for _, str in ipairs(tileStrs) do
    local spls = string.split(str, ";")
    if #spls == 2 then
      local x = tonumber(spls[1])
      local y = tonumber(spls[2])
      table.insert(self.tileList, {x = x, y = y})
      local localX = x - self.pos.x
      local localY = y - self.pos.y
      if self.rect.left == nil or localX < self.rect.left then
        self.rect.left = localX
      end
      if self.rect.right == nil or localX > self.rect.right then
        self.rect.right = localX
      end
      if self.rect.bottom == nil or localY < self.rect.bottom then
        self.rect.bottom = localY
      end
      if self.rect.top == nil or localY > self.rect.top then
        self.rect.top = localY
      end
    end
  end
  self.height = tonumber(row:getValue("Height")) or 0
  local needArmyStrs = string.split(row:getValue("need_army") or "", ";")
  if #needArmyStrs == 2 then
    self.needArmy.level = tonumber(needArmyStrs[1]) or 0
    self.needArmy.count = tonumber(needArmyStrs[2]) or 0
  end
  self.rewardItemList = {}
  self.rewardInitCount = tonumber(row:getValue("split_group")) or 0
  if self.rewardInitCount == 1 then
    self.rewardType = LandLockRewardType.Chest
  elseif 1 < self.rewardInitCount then
    self.rewardType = LandLockRewardType.Call
  else
    self.rewardType = LandLockRewardType.None
  end
  self.bubbleType = tonumber(row:getValue("bubble")) or 0
  self.needChapter = tonumber(row:getValue("pre_chapter")) or 0
  self.noviceBoot = row:getValue("noviceboot") or ""
  self.dynamicObj = {}
  local dynamicObjStrs = string.split(row:getValue("dynamic_obj") or "", "|")
  for _, str in ipairs(dynamicObjStrs) do
    local spls = string.split(str, ";")
    if #spls == 2 then
      local alter = spls[1]
      local path = spls[2]
      if self.dynamicObj[alter] == nil then
        self.dynamicObj[alter] = {}
      end
      table.insert(self.dynamicObj[alter], path)
    end
  end
  self.needQuest = {}
  local needQuestStr = string.split(row:getValue("pre_quest") or "", ";")
  for _, str in ipairs(needQuestStr) do
    table.insert(self.needQuest, tonumber(str))
  end
  self.domeRange = tonumber(row:getValue("dome_range")) or DomeRange.Zero
  self.animOff = tonumber(row:getValue("animationoff")) == 1
  self.showRewards = {}
  local showRewardStrs = string.split(row:getValue("reward_item") or "", "|")
  for _, str in ipairs(showRewardStrs) do
    local spls = string.split(str, ";")
    if #spls == 3 then
      local reward = {}
      reward.type = tonumber(spls[1])
      reward.itemId = tonumber(spls[2])
      reward.count = tonumber(spls[3])
      table.insert(self.showRewards, reward)
    end
  end
  self.unlockModel = row.unlock_model
  self.showBuildIds = {}
  local showBuildStr = row:getValue("show_building") or ""
  if not string.IsNullOrEmpty(showBuildStr) then
    local spls = string.split(showBuildStr, "|")
    for _, spl in ipairs(spls) do
      table.insert(self.showBuildIds, tonumber(spl))
    end
  end
  self.cheerleader = {}
  local cheerleaderStr = row:getValue("cheerleader")
  if not string.IsNullOrEmpty(cheerleaderStr) then
    local sp = string.split(cheerleaderStr, "|")
    for _, v in ipairs(sp) do
      local posArray = string.split(v, ";")
      if #posArray == 2 then
        local pos = {
          tonumber(posArray[1]),
          tonumber(posArray[2])
        }
        table.insert(self.cheerleader, pos)
      end
    end
  end
  self.cheerleaderEnd = {}
  cheerleaderStr = row:getValue("cheerleader_1")
  if not string.IsNullOrEmpty(cheerleaderStr) then
    local sp = string.split(cheerleaderStr, "|")
    for _, v in ipairs(sp) do
      local posArray = string.split(v, ";")
      if #posArray == 2 then
        local pos = {
          tonumber(posArray[1]),
          tonumber(posArray[2])
        }
        table.insert(self.cheerleaderEnd, pos)
      end
    end
  end
  self.city_fog = row:getValue("city_fog")
  self.landToZone = row:getValue("land_zone")
  self.hideRewardPop = row:getValue("hide_reward_pop") == 1
end

local function GetCost(self)
  for resourceType, count in pairs(self.costResource) do
    local resCount = LuaEntry.Resource:GetCntByResType(resourceType)
    return DataCenter.ResourceManager:GetResourceIconByType(resourceType), count, resCount
  end
  for itemId, count in pairs(self.costItem) do
    local itemData = DataCenter.ItemData:GetItemById(itemId)
    local itemCount = itemData and itemData.count or 0
    local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
    if itemTemplate then
      return string.format(LoadPath.ItemPath, itemTemplate.icon), count, itemCount
    end
  end
  for resItemId, count in pairs(self.costResourceItem) do
    local resItemData = DataCenter.ResourceItemDataManager:GetItemDataByItemId(resItemId)
    local resItemCount = resItemData and resItemData.number or 0
    local resItemTemplate = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(resItemId)
    if resItemTemplate then
      return resItemTemplate:GetIconPath(), count, resItemCount
    end
  end
  return "", 0, 0
end

local function GetBoundingRect(self)
  local xMin, xMax, yMin, yMax = IntMaxValue, IntMinValue, IntMaxValue, IntMinValue
  for _, tile in ipairs(self.tileList) do
    xMin = math.min(xMin, tile.x)
    xMax = math.max(xMax, tile.x)
    yMin = math.min(yMin, tile.y)
    yMax = math.max(yMax, tile.y)
  end
  return xMin, xMax, yMin, yMax
end

local function GetBoundingRectTiles(self)
  if self.boundingRectTiles ~= nil then
    return self.boundingRectTiles
  end
  local xMin, xMax, yMin, yMax = self:GetBoundingRect()
  local list = {}
  for x = xMin, xMax do
    for _, y in ipairs({yMin, yMax}) do
      local found = false
      for _, tile in ipairs(list) do
        if tile.x == x and tile.y == y then
          found = true
          break
        end
      end
      if not found then
        local tile = {x = x, y = y}
        table.insert(list, tile)
      end
    end
  end
  for y = yMin, yMax do
    for _, x in ipairs({xMin, xMax}) do
      local found = false
      for _, tile in ipairs(list) do
        if tile.x == x and tile.y == y then
          found = true
          break
        end
      end
      if not found then
        local tile = {x = x, y = y}
        table.insert(list, tile)
      end
    end
  end
  self.boundingRectTiles = list
  return list
end

LandLockTemplate.__init = __init
LandLockTemplate.__delete = __delete
LandLockTemplate.InitData = InitData
LandLockTemplate.GetCost = GetCost
LandLockTemplate.GetBoundingRect = GetBoundingRect
LandLockTemplate.GetBoundingRectTiles = GetBoundingRectTiles
return LandLockTemplate
