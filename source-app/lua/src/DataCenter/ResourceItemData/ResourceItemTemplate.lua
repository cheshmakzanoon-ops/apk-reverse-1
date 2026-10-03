local ResourceItemTemplate = BaseClass("ResourceItemTemplate")

local function __init(self)
  self.id = 0
  self.itemType = 0
  self.name = ""
  self.desc = ""
  self.pic = ""
  self.order = 0
  self.building = ResourceItemOutType.Farm
  self.price = 0
  self.show = 1
  self.monster = {}
  self.unlock_condition = {}
  self.price_diamond = 0
  self.type = 0
  self.discard = 0
  self.activity_discard = 0
  self.condition_discard = ""
  self.trade_num = 0
  self.use_type = 0
  self.quality = 0
  self.page = 0
  self.bubble_icon = ""
end

local function __delete(self)
  self.id = nil
  self.itemType = nil
  self.name = nil
  self.desc = nil
  self.pic = nil
  self.order = nil
  self.building = nil
  self.price = nil
  self.unlock_condition = nil
  self.show = nil
  self.monster = nil
  self.price_diamond = nil
  self.type = nil
  self.discard = nil
  self.activity_discard = nil
  self.condition_discard = nil
  self.trade_num = nil
  self.use_type = nil
  self.quality = nil
  self.page = nil
  self.bubble_icon = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.itemType = row:getValue("itemType")
  self.name = tostring(row:getValue("name"))
  self.desc = tostring(row:getValue("desc"))
  self.pic = row:getValue("pic")
  self.pic_new = row:getValue("pic_new")
  self.order = row:getValue("order")
  self.building = row:getValue("building")
  self.price = row:getValue("price")
  self.show = row:getValue("show")
  self.type = tonumber(row:getValue("type")) or 0
  self.unlock_condition = {}
  local conditionStr = row:getValue("unlock_condition")
  if conditionStr ~= nil then
    local conditionArr = string.split(conditionStr, ";")
    if conditionArr ~= nil and 2 <= #conditionArr then
      self.unlock_condition[tonumber(conditionArr[1])] = tonumber(conditionArr[2])
    end
  end
  self.monster = row:getValue("monster")
  local price_diamond = row:getValue("price_diamond")
  if price_diamond == nil or price_diamond == "" then
    self.price_diamond = 0
  else
    self.price_diamond = tonumber(price_diamond)
  end
  self.page = row:getValue("page") or 0
  self.discard = row:getValue("discard")
  self.activity_discard = row:getValue("activity_discard")
  self.condition_discard = row:getValue("condition_discard") or ""
  self.trade_num = tonumber(row:getValue("trade_num")) or 0
  self.use_type = row:getValue("use_type")
  self.quality = tonumber(row:getValue("quality")) or 0
  if self.quality == 0 then
    self.quality = 2
  end
  self.bubble_icon = row:getValue("bubble_icon") or ""
end

local function GetMonsterJumpParam(self)
  if self.monster == nil or self.monster == "" then
    return nil
  end
  local vec = string.split(self.monster, ";")
  if table.count(vec) < 2 then
    Logger("ResourceItemTemplate config error")
    return nil
  end
  local lvVec = string.split(vec[2], "-")
  if table.count(lvVec) < 2 then
    Logger("ResourceItemTemplate config error")
    return nil
  end
  local configMinLv = toInt(lvVec[1])
  local configMaxLv = toInt(lvVec[2])
  local maxLevel = DataCenter.MonsterManager:GetCurCanAttackMaxLevel()
  if configMinLv > maxLevel then
    return toInt(vec[1]), configMinLv, configMinLv
  end
  local pveLevel = LuaEntry.Player.pveLevel
  local level = math.min(pveLevel, configMaxLv)
  level = math.max(level, configMinLv)
  return toInt(vec[1]), configMinLv, level
end

local function ShowInCapacity(self)
  local itemData = DataCenter.ResourceItemDataManager:GetItemDataByItemId(self.id, LuaEntry.Player.uid)
  if itemData ~= nil and itemData.number > 0 then
    return true
  end
  local isUnlock = true
  table.walk(self.unlock_condition, function(k, v)
    local buildId = k
    local buildLv = v
    if buildId ~= nil and buildLv ~= nil and isUnlock == true then
      isUnlock = DataCenter.BuildManager:IsExistBuildByTypeLv(buildId, buildLv)
    end
  end)
  if isUnlock == true and self.monster ~= nil and self.monster ~= "" then
    local vec = string.split(self.monster, ";")
    if table.count(vec) < 2 then
      Logger("ResourceItemTemplate config error")
      return false
    end
    local lvVec = string.split(vec[2], "-")
    if table.count(lvVec) < 2 then
      Logger("ResourceItemTemplate config error")
      return false
    end
    if toInt(vec[1]) == ResourceItemMonsterJumpType.MonsterJumpType_Boss then
      return false
    end
    local configMinLv = toInt(lvVec[1])
    local maxLevel = DataCenter.MonsterManager:GetCurCanAttackMaxLevel()
    if configMinLv > maxLevel then
      return false
    end
  end
  return isUnlock
end

function ResourceItemTemplate:GetIconPath()
  if string.IsNullOrEmpty(self.pic_new) then
    return string.format(LoadPath.ItemPath, self.pic)
  else
    return self.pic_new
  end
end

ResourceItemTemplate.__init = __init
ResourceItemTemplate.__delete = __delete
ResourceItemTemplate.InitData = InitData
ResourceItemTemplate.GetMonsterJumpParam = GetMonsterJumpParam
ResourceItemTemplate.ShowInCapacity = ShowInCapacity
return ResourceItemTemplate
