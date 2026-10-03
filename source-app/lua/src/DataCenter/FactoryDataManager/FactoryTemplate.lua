local FactoryTemplate = BaseClass("FactoryTemplate")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.id = 0
  self.product_name = ""
  self.build_type = 0
  self.unlock_type = 0
  self.unlock_condition = {}
  self.need_resource_goods = {}
  self.produce_time = 0
  self.get_resource_goods = {}
  self.need_resource = {}
  self.icon = ""
  self.order = 0
  self.speed_item = 0
  self.exp = 0
  self.group = 0
  self.unlock_player_level = 0
  self.show_num = 1
  self.productList = {}
end

local function __delete(self)
  self.id = nil
  self.product_name = nil
  self.build_type = nil
  self.unlock_type = nil
  self.unlock_condition = nil
  self.need_resource_goods = nil
  self.produce_time = nil
  self.get_resource_goods = nil
  self.need_resource = nil
  self.icon = nil
  self.order = nil
  self.speed_item = nil
  self.exp = nil
  self.unlock_player_level = nil
  self.group = nil
  self.productList = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.product_name = row:getValue("name")
  self.build_type = row:getValue("build_type")
  local tempType = row:getValue("unlock_type")
  if tempType == nil or tempType == "" then
    self.unlock_type = -1
  else
    self.unlock_type = tonumber(tempType)
  end
  self.unlock_condition = {}
  local conditionStr = row:getValue("unlock_condition")
  if conditionStr ~= nil and self.unlock_type == TemplateUnlockType.Talent and #conditionStr == 1 then
    self.unlock_condition[tonumber(conditionStr[1])] = 1
  elseif conditionStr ~= nil and 2 <= #conditionStr then
    self.unlock_condition[tonumber(conditionStr[1])] = tonumber(conditionStr[2])
  end
  self.need_resource = {}
  local resStr = row:getValue("input_resource")
  if resStr ~= nil and resStr ~= "" then
    local vec = string.split(resStr, "|")
    table.walk(vec, function(_, k)
      local tmp = string.split(k, ";")
      if 2 <= #tmp then
        self.need_resource[tonumber(tmp[1])] = tonumber(tmp[2])
      end
    end)
  end
  self.need_resource_goods = {}
  local goods = row:getValue("input_resource_goods")
  if goods ~= nil then
    table.walk(goods, function(k, v)
      self.need_resource_goods[tonumber(k)] = tonumber(v)
    end)
  end
  self.show_num = row:getValue("show_num") or 1
  self.produce_time = row:getValue("time") * 1000
  self.get_resource_goods = {}
  local product = row:getValue("get_resource_goods")
  if 2 <= #product then
    self.get_resource_goods[tonumber(product[1])] = tonumber(product[2])
  end
  self.icon = row:getValue("icon")
  self.order = row:getValue("order")
  self.speed_item = row:getValue("speed_item") or 0
  self.exp = tonumber(row:getValue("exp")) or 0
  self.unlock_player_level = tonumber(row:getValue("unlock_player_level")) or 0
  self.group = tonumber(row:getValue("group")) or 0
  self:InitProductList(row)
end

local function GetProductTime(self)
  local original = self.produce_time
  local effect = DataCenter.BuildManager:GetReduceFactoryTimeEffectByBuildId(DataCenter.BuildManager:GetBuildId(self.build_type))
  if effect == nil then
    return original
  else
    local effectAdd = LuaEntry.Effect:GetGameEffect(effect)
    local x, y = math.modf(original / (1 + effectAdd / 100))
    return x
  end
end

local function GetResourceItemId(self)
  for k, v in ipairs(self.productList) do
    if v.type == FactoryProductType.FactoryProductType_Resource_Item then
      return v.itemId
    end
  end
  return nil
end

local function GetNumProductName(self)
  if self.show_num > 1 then
    return Localization:GetString(self.product_name) .. "x" .. self.show_num
  end
  return Localization:GetString(self.product_name)
end

local function GetProductList(self)
  return self.productList or {}
end

local function GetProductShowIcon(self)
  if table.count(self.productList) == 0 then
    return ""
  end
  local first = self.productList[1]
  return DataCenter.FactoryDataManager:GetProductShowIcon(first)
end

local function GetProductShowName(self)
  if table.count(self.productList) == 0 then
    return ""
  end
  local first = self.productList[1]
  if first.type == FactoryProductType.FactoryProductType_Resource_Item then
    local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(tonumber(first.itemId))
    if template ~= nil then
      return Localization:GetString(template.name)
    end
  elseif first.type == FactoryProductType.FactoryProductType_Item then
    return DataCenter.ItemTemplateManager:GetName(tonumber(first.itemId))
  elseif first.type == FactoryProductType.FactoryProductType_Resource then
    local template = DataCenter.ResourceTemplateManager:GetResourceTemplate(tonumber(first.itemId))
    if template then
      return Localization:GetString(template.name)
    end
  elseif first.type == FactoryProductType.FactoryProductType_Score then
  end
  return ""
end

local function GetMainProduct(self)
  return self.productList[1]
end

local function GetProductResourceItemNum(self)
  local result = 0
  table.walk(self.productList, function(_, v)
    if v.type == FactoryProductType.FactoryProductType_Resource_Item then
      result = result + v.num
    end
  end)
  return result
end

local function InitProductList(self, row)
  local function AddData(type, itemId, num)
    local data = {}
    
    data.type = type
    data.itemId = itemId
    data.num = num
    table.insert(self.productList, data)
  end
  
  local product = row:getValue("get_resource_goods")
  if product and table.count(product) > 0 then
    AddData(FactoryProductType.FactoryProductType_Resource_Item, toInt(product[1]), toInt(product[2]))
  end
  local getReward = row:getValue("get_reward")
  if not string.IsNullOrEmpty(getReward) then
    local vec1 = string.split(getReward, "|")
    table.walk(vec1, function(_, v)
      local vec2 = string.split(v, ";")
      if table.count(vec2) == 3 then
        AddData(toInt(vec2[1]), toInt(vec2[2]), toInt(vec2[3]))
      end
    end)
  end
end

FactoryTemplate.__init = __init
FactoryTemplate.__delete = __delete
FactoryTemplate.InitData = InitData
FactoryTemplate.GetProductTime = GetProductTime
FactoryTemplate.GetResourceItemId = GetResourceItemId
FactoryTemplate.GetNumProductName = GetNumProductName
FactoryTemplate.GetProductList = GetProductList
FactoryTemplate.GetProductShowIcon = GetProductShowIcon
FactoryTemplate.GetProductResourceItemNum = GetProductResourceItemNum
FactoryTemplate.InitProductList = InitProductList
FactoryTemplate.GetMainProduct = GetMainProduct
FactoryTemplate.GetProductShowName = GetProductShowName
return FactoryTemplate
