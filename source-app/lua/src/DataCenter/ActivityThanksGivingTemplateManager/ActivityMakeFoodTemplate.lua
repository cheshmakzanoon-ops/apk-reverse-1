local ActivityMakeFoodTemplate = BaseClass("ActivityMakeFoodTemplate")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.id = 0
  self.activity = 0
  self.costItemDic = {}
  self.canSelectMin = 0
  self.canSelectMax = 0
  self.selectDefault = 0
end

local function __delete(self)
  self.id = nil
  self.activity = 0
  self.costItemDic = {}
  self.canSelectMin = 0
  self.canSelectMax = 0
  self.selectDefault = 0
end

local function ParseData(self, row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.activity = row:getValue("activity")
  local itemCost = row:getValue("cost_item_list")
  self.costItemDic = {}
  if not string.IsNullOrEmpty(itemCost) then
    local itemList = string.split(itemCost, ";")
    for _, v in ipairs(itemList) do
      local strList = string.split(v, "|")
      if 2 <= #strList then
        table.insert(self.costItemDic, {
          itemId = tonumber(strList[1]),
          costNum = tonumber(strList[2])
        })
      end
    end
  end
  local select_range = row:getValue("select_range")
  if not string.IsNullOrEmpty(select_range) then
    local strList = string.split(select_range, "|")
    if 3 <= #strList then
      self.canSelectMin = tonumber(strList[1])
      self.canSelectMax = tonumber(strList[2])
      self.selectDefault = tonumber(strList[3])
    end
  end
end

ActivityMakeFoodTemplate.__init = __init
ActivityMakeFoodTemplate.__delete = __delete
ActivityMakeFoodTemplate.ParseData = ParseData
return ActivityMakeFoodTemplate
