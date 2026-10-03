local AdaptiveBoxTemplateManager = BaseClass("AdaptiveBoxTemplateManager")

local function __init(self)
  self.groupAndLevelDic = {}
  self.templateDic = {}
  self:InitAll()
end

local function InitAll(self)
  LocalController:instance():visitTable(TableName.Adaptive_Box, function(id, lineData)
    local group = tonumber(lineData:getValue("group"))
    local level = tonumber(lineData:getValue("level"))
    local id = tonumber(lineData:getValue("id"))
    if not self.groupAndLevelDic[group] then
      self.groupAndLevelDic[group] = {}
    end
    if not self.groupAndLevelDic[group][level] then
      self.groupAndLevelDic[group][level] = id
    end
  end)
end

local function GetReturnItem(self, group, playerLevel, para)
  if not (group and playerLevel) or not para then
    return nil
  end
  local id = self.groupAndLevelDic[tonumber(group)][tonumber(playerLevel)]
  if not id then
    return nil
  end
  local line = LocalController:instance():getLine(TableName.Adaptive_Box, id)
  if not line then
    return nil
  end
  local type = line.type
  if type then
    type = tonumber(type)
  else
    return nil
  end
  local itemId = line.base_itemid
  if itemId then
    itemId = tonumber(itemId)
  else
    return nil
  end
  local base_num = line.base_num
  if base_num then
    base_num = tonumber(base_num)
  else
    return nil
  end
  local count = base_num * tonumber(para)
  local data = {}
  if type == 1 then
    data = {
      id = itemId,
      num = count,
      rewardType = RewardType.GOODS,
      count = count
    }
  elseif type == 2 then
    local rewardType = ResTypeToReward[itemId]
    if not rewardType then
      return nil
    end
    data = {
      id = itemId,
      num = count,
      rewardType = rewardType,
      count = count
    }
  elseif type == 3 then
    data = {
      id = itemId,
      num = count,
      rewardType = RewardType.RESOURCE_ITEM,
      count = count
    }
  end
  return data
end

local function __delete(self)
  self.groupAndLevelDic = nil
  self.templateDic = nil
end

AdaptiveBoxTemplateManager.__init = __init
AdaptiveBoxTemplateManager.__delete = __delete
AdaptiveBoxTemplateManager.InitAll = InitAll
AdaptiveBoxTemplateManager.GetReturnItem = GetReturnItem
return AdaptiveBoxTemplateManager
