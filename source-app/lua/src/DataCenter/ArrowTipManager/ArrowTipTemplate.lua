local ArrowTipTemplate = BaseClass("ArrowTipTemplate")

local function __init(self)
  self.id = 0
  self.name = ""
end

local function __delete(self)
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.type = row:getValue("type")
  self.number = tonumber(row:getValue("number")) or -1
  self.order = row:getValue("order")
  self.time = row:getValue("time")
  self.showMainCityLv = 0
  self.showMaxCityLv = IntMaxValue
  local base = row:getValue("base")
  if string.IsNullOrEmpty(base) == false then
    local vec = string.split(base, "-")
    if vec ~= nil and table.count(vec) == 2 then
      self.showMainCityLv = toInt(vec[1])
      self.showMaxCityLv = toInt(vec[2])
    end
  end
end

local function CheckCondition(self, currentNum)
  local mainBuildLV = DataCenter.BuildManager.MainLv
  if mainBuildLV < self.showMainCityLv or mainBuildLV > self.showMaxCityLv then
    return false
  end
  if self.number >= 0 and currentNum >= self.number then
    return false
  end
  return true
end

ArrowTipTemplate.__init = __init
ArrowTipTemplate.__delete = __delete
ArrowTipTemplate.InitData = InitData
ArrowTipTemplate.CheckCondition = CheckCondition
return ArrowTipTemplate
