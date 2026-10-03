local FarmTemplate = BaseClass("FarmTemplate")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.id = 0
  self.product_name = ""
  self.build_id = 0
  self.unlock_type = 0
  self.unlock_condition = {}
  self.need_resource = {}
  self.need_goods = {}
  self.produce_time = 0
  self.get_goods = {}
  self.second_need_goods = {}
  self.second_produce_time = 0
  self.second_get_goods = {}
  self.icon = ""
  self.order = 0
  self.unlock_order = 0
  self.modelName = ""
  self.second_product_name = ""
  self.speed_item = 0
  self.unlock_player_level = 0
  self.exp = 0
  self.group = 0
  self.show_num = 1
  self.show_level = 1
end

local function __delete(self)
  self.id = nil
  self.product_name = nil
  self.build_id = nil
  self.unlock_type = nil
  self.unlock_condition = nil
  self.need_resource = nil
  self.need_goods = nil
  self.produce_time = nil
  self.get_goods = nil
  self.second_need_goods = nil
  self.second_produce_time = nil
  self.second_get_goods = nil
  self.icon = nil
  self.order = nil
  self.unlock_order = nil
  self.modelName = nil
  self.second_product_name = nil
  self.speed_item = nil
  self.unlock_player_level = nil
  self.exp = nil
  self.group = nil
  self.show_level = nil
end

local function GetNeedResource(self, times)
  local result = {}
  if not table.isarray(self.need_resource) then
    return self.need_resource
  else
    for k, v in ipairs(self.need_resource) do
      local flag = false
      if table.count(result) == 0 and k == table.count(self.need_resource) then
        flag = true
      end
      if table.isarray(v) and table.count(v) == 3 then
        local time = v[1]
        local id = v[2]
        local num = v[3]
        if times < time then
          flag = true
        end
        if flag then
          result[id] = num
          break
        end
      end
    end
  end
  return result
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.product_name = row:getValue("product_name")
  self.build_id = row:getValue("build_id")
  local tempType = row:getValue("unlock_type")
  if tempType == nil or tempType == "" then
    self.unlock_type = -1
  else
    self.unlock_type = tonumber(tempType)
  end
  self.unlock_condition = {}
  local conditionStr = row:getValue("unlock_condition")
  if conditionStr ~= nil and 2 <= #conditionStr then
    self.unlock_condition[tonumber(conditionStr[1])] = tonumber(conditionStr[2])
  end
  if conditionStr ~= nil and #conditionStr == 1 then
    self.unlock_condition[tonumber(conditionStr[1])] = 1
  end
  self.need_resource = {}
  local resource = row:getValue("input_resource")
  if resource ~= nil and resource ~= "" then
    local vec = string.split(resource, "|")
    table.walk(vec, function(k, v)
      local vec1 = string.split(v, ";")
      local count = table.count(vec1)
      if count == 2 then
        table.insert(self.need_resource, {
          -2,
          tonumber(vec1[1]),
          tonumber(vec1[2])
        })
      elseif count == 3 then
        table.insert(self.need_resource, {
          tonumber(vec1[1]),
          tonumber(vec1[2]),
          tonumber(vec1[3])
        })
      end
    end)
  end
  self.show_level = toInt(row:getValue("show_lv")) or 0
  self.need_goods = {}
  local goods = row:getValue("input_goods")
  if goods ~= nil and 2 <= #goods then
    self.need_goods[tonumber(goods[1])] = tonumber(goods[2])
  end
  self.produce_time = row:getValue("produce_time") * 1000
  self.get_goods = {}
  local product = row:getValue("get_resource_goods")
  if not string.IsNullOrEmpty(product) then
    local vec = string.split(product, "|")
    table.walk(vec, function(_, v)
      local tmpVec = string.split(v, ";")
      if tmpVec ~= nil and table.count(tmpVec) == 2 then
        self.get_goods[tonumber(tmpVec[1])] = tonumber(tmpVec[2])
      end
    end)
  end
  self.second_need_goods = {}
  local second_goods = row:getValue("input_by_goods")
  if second_goods ~= nil and 2 <= #second_goods then
    self.second_need_goods[tonumber(second_goods[1])] = tonumber(second_goods[2])
  end
  self.second_produce_time = row:getValue("by_produce_time") * 1000
  self.second_get_goods = {}
  local second_product = row:getValue("get_by_resource_goods")
  if not string.IsNullOrEmpty(second_product) then
    local vec = string.split(second_product, "|")
    table.walk(vec, function(_, v)
      local tmpVec = string.split(v, ";")
      if tmpVec ~= nil and table.count(tmpVec) == 2 then
        self.second_get_goods[tonumber(tmpVec[1])] = tonumber(tmpVec[2])
      end
    end)
  end
  self.icon = row:getValue("icon")
  self.order = row:getValue("order")
  self.unlock_order = row:getValue("unlock_order") or self.order
  self.modelName = row:getValue("model_name")
  self.second_product_name = row:getValue("second_product_name")
  self.speed_item = row:getValue("speed_item") or 0
  self.unlock_player_level = tonumber(row:getValue("unlock_player_level")) or 0
  self.exp = tonumber(row:getValue("exp"))
  self.group = tonumber(row:getValue("group"))
  self.show_num = row:getValue("show_num") or 1
end

local function GetResourceItemId(self)
  for k, _ in pairs(self.get_goods) do
    return k
  end
  return nil
end

local function GetNumProductName(self)
  if self.show_num > 1 then
    return Localization:GetString(self.product_name) .. "x" .. self.show_num
  end
  return Localization:GetString(self.product_name)
end

FarmTemplate.__init = __init
FarmTemplate.__delete = __delete
FarmTemplate.InitData = InitData
FarmTemplate.GetNeedResource = GetNeedResource
FarmTemplate.GetResourceItemId = GetResourceItemId
FarmTemplate.GetNumProductName = GetNumProductName
FarmTemplate.GetResourceGoodIdAndNum = GetResourceGoodIdAndNum
return FarmTemplate
