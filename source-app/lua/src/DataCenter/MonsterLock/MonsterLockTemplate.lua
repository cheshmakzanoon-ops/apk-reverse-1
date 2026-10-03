local MonsterLockTemplate = BaseClass("MonsterLockTemplate")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.id = 0
  self.rect = {
    left = 0,
    right = 0,
    bottom = 0,
    top = 0
  }
  self.needArmyLevel = 0
  self.needArmyCount = 0
  self.sizeX = 1
  self.sizeY = 1
  self.recommend_power = 0
  self.duration = 0
  self.name = ""
  self.level = 1
  self.rewardType = LandLockRewardType.None
  self.rewardInitCount = 0
end

local function __delete(self)
  self.id = nil
  self.pre_build = nil
  self.pve = nil
  self.need_army = nil
  self.cost_resource_item = nil
  self.reward_item = nil
  self.duration = nil
  self.name = nil
  self.level = nil
  self.rewardType = nil
  self.rewardInitCount = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.costItem = {}
  self.costResourceItem = {}
  local costResourceItemStrs = string.split(row:getValue("cost_resource_item") or "", "|")
  for _, str in ipairs(costResourceItemStrs) do
    local spls = string.split(str, ";")
    if #spls == 2 then
      self.costResourceItem[tonumber(spls[1])] = tonumber(spls[2])
    end
  end
  self.pve = tonumber(row:getValue("pve")) or 0
  local pveTemplate = DataCenter.PveLevelTemplateManager:GetTemplate(self.pve)
  if pveTemplate ~= nil and 2 <= #pveTemplate.triggerList then
    local triggerId = pveTemplate.triggerList[2]
    local monsterId = GetTableData(TableName.PVETrigger, tonumber(triggerId), "UnclockPara")
    if monsterId ~= nil then
      local MonsterTemplate = DataCenter.MonsterTemplateManager:GetMonsterTemplate(tonumber(monsterId))
      if MonsterTemplate ~= nil then
        self.recommend_power = MonsterTemplate.recommend_power
      end
    end
  end
  self.name = row:getValue("name")
  self.level = tonumber(row:getValue("level")) or 1
  local needArmyStrs = string.split(row:getValue("need_army") or "", ";")
  if #needArmyStrs == 2 then
    self.needArmyLevel = tonumber(needArmyStrs[1]) or 0
    self.needArmyCount = tonumber(needArmyStrs[2]) or 0
  end
  local sizeVec = string.split(row:getValue("size") or "", ";")
  if table.count(sizeVec) == 2 then
    self.sizeX = toInt(sizeVec[1])
    self.sizeY = toInt(sizeVec[2])
    self.rect.left = 1 - self.sizeX
    self.rect.bottom = 1 - self.sizeY
  end
  self.duration = tonumber(row:getValue("duration")) or 0
  self.rewardInitCount = tonumber(row:getValue("split_group")) or 0
  if self.rewardInitCount == 1 then
    self.rewardType = LandLockRewardType.Chest
  elseif 1 < self.rewardInitCount then
    self.rewardType = LandLockRewardType.Call
  else
    self.rewardType = LandLockRewardType.None
  end
end

local function GetCost(self)
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

local function GetName(self)
  return Localization:GetString(self.name, self.level)
end

MonsterLockTemplate.__init = __init
MonsterLockTemplate.__delete = __delete
MonsterLockTemplate.InitData = InitData
MonsterLockTemplate.GetCost = GetCost
MonsterLockTemplate.GetName = GetName
return MonsterLockTemplate
