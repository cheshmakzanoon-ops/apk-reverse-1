local OrderTemplate = BaseClass("OrderTemplate")

local function __init(self)
  self.id = 0
  self.type = OrderType.Resident
  self.money = {}
  self.exp = 0
  self.bubble_name = nil
  self.tile = nil
  self.des = nil
  self.npc = nil
  self.needResourceItems = {}
  self.added_money = 0
  self.state = nil
  self.prior_show = OrderPriorShowType.Normal
  self.time = 0
  self.icon = ""
  self.add_item = {}
  self.random_value = 0
end

local function __delete(self)
  self.id = nil
  self.type = nil
  self.money = nil
  self.exp = nil
  self.bubble_name = nil
  self.tile = nil
  self.des = nil
  self.npc = nil
  self.needResourceItems = nil
  self.added_money = nil
  self.state = nil
  self.prior_show = nil
  self.time = nil
  self.icon = nil
  self.add_item = nil
  self.product_type = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.type = row:getValue("type")
  self.money = row:getValue("money")
  self.exp = row:getValue("exp") or "0"
  self.bubble_name = row:getValue("bubble_name")
  self.title = row:getValue("title")
  self.des = row:getValue("des")
  self.npc = row:getValue("npc")
  self.added_money = row:getValue("added_money")
  self.state = row:getValue("state")
  self.prior_show = row:getValue("prior_show")
  self.time = row:getValue("time")
  self.icon = row:getValue("icon")
  local resource = row:getValue("resource_goods")
  local product_type = row:getValue("product_type") or ""
  if product_type == "" then
    self.product_type = 0
  else
    self.product_type = toInt(row:getValue("product_type"))
  end
  local random_value_str = row:getValue("random_value") or ""
  if string.IsNullOrEmpty(random_value_str) then
    self.random_value = 0
  else
    self.random_value = toInt(random_value_str)
  end
  if resource ~= nil and string.contains(resource, "|") then
    local list = string.split(resource, "|")
    if 0 < #list then
      table.walk(list, function(k, v)
        local item = string.split(v, ";")
        if #item == 2 then
          local need = {}
          need.needId = tonumber(item[1])
          need.count = tonumber(item[2])
          table.insert(self.needResourceItems, need)
        end
      end)
    end
  elseif resource ~= nil then
    local item = string.split(resource, ";")
    if #item == 2 then
      local need = {}
      need.needId = tonumber(item[1])
      need.count = tonumber(item[2])
      table.insert(self.needResourceItems, need)
    end
  end
  local items = row:getValue("added_item")
  if items ~= nil then
    if string.contains(items, "|") then
      local lists = string.split(items, "|")
      if 0 < #lists then
        table.walk(lists, function(k, v)
          local item = string.split(v, ";")
          if #item == 2 then
            local addItem = {}
            addItem.itemId = tonumber(item[1])
            addItem.count = tonumber(item[2])
            table.insert(self.add_item, addItem)
          end
        end)
      end
    elseif items ~= nil then
      local item = string.split(items, ";")
      if #item == 2 then
        local addItem = {}
        addItem.itemId = tonumber(item[1])
        addItem.count = tonumber(item[2])
        table.insert(self.add_item, addItem)
      end
    end
  end
end

local function GetNeedResourceItem(self)
  return self.needResourceItems
end

local function GetAddItem(self)
  return self.add_item
end

local function GetResidentOrderMoney(self)
  if #self.money > 0 then
    return self.money[1]
  end
  return 0
end

local function GetEarthOrderMoney(self, index)
  if index <= #self.money then
    return self.money[index]
  end
  return 0
end

OrderTemplate.__init = __init
OrderTemplate.__delete = __delete
OrderTemplate.InitData = InitData
OrderTemplate.GetNeedResourceItem = GetNeedResourceItem
OrderTemplate.GetResidentOrderMoney = GetResidentOrderMoney
OrderTemplate.GetEarthOrderMoney = GetEarthOrderMoney
OrderTemplate.GetAddItem = GetAddItem
return OrderTemplate
