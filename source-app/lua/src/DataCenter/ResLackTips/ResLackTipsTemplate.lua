local ResLackTipsTemplate = BaseClass("ResLackTipsTemplate")

local function __init(self)
  self.id = 0
  self.res = 0
  self.tips = 0
  self.order = 0
  self.isCalculate = false
  self.baseline = 0
  self.name = 0
  self.btnName = 0
  self.base = {
    min = IntMinValue,
    max = IntMaxValue
  }
  self.para1 = ""
  self.pic = ""
  self.group = 0
  self.level = {
    min = IntMinValue,
    max = IntMaxValue
  }
  self.goods = 0
  self.monsterLevelLimit = {
    min = IntMinValue,
    max = IntMaxValue
  }
  self.activeShow = false
  self.res_item = 0
end

local function __delete(self)
  self.id = nil
  self.res = nil
  self.tips = nil
  self.order = nil
  self.isCalculate = nil
  self.baseline = nil
  self.name = nil
  self.btnName = nil
  self.base = nil
  self.para1 = nil
  self.pic = nil
  self.group = nil
  self.level = nil
  self.goods = nil
  self.monsterLevelLimit = nil
  self.activeShow = nil
  self.res_item = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.res = tonumber(row:getValue("res")) or 0
  self.tips = tonumber(row:getValue("tips")) or 0
  self.order = tonumber(row:getValue("order")) or 0
  self.isCalculate = tonumber(row:getValue("is_calculate")) == 1
  self.baseline = tonumber(row:getValue("baseline")) or 0
  self.name = tonumber(row:getValue("name")) or 0
  self.btnName = tonumber(row:getValue("btn_name")) or 0
  self.base = {}
  local baseStrs = string.split(row:getValue("base") or "", "-")
  if #baseStrs == 2 then
    self.base.min = tonumber(baseStrs[1]) or 0
    self.base.max = tonumber(baseStrs[2]) or 0
  end
  self.para1 = row:getValue("para1") or ""
  self.pic = row:getValue("pic") or ""
  self.group = tonumber(row:getValue("group")) or 0
  self.level = {}
  local levelStrs = string.split(row:getValue("level") or "", "-")
  if #levelStrs == 2 then
    self.level.min = tonumber(levelStrs[1]) or 0
    self.level.max = tonumber(levelStrs[2]) or 0
  end
  self.goods = tonumber(row:getValue("goods")) or 0
  self.monsterLevelLimit = {}
  local monsterLevelLimitStrs = string.split(row:getValue("monster_level_limit") or "", "-")
  if #monsterLevelLimitStrs == 2 then
    self.level.min = tonumber(monsterLevelLimitStrs[1]) or 0
    self.level.max = tonumber(monsterLevelLimitStrs[2]) or 0
  end
  self.activeShow = tonumber(row:getValue("active_show")) == 1
  self.res_item = tonumber(row:getValue("res_item")) or 0
end

local function CheckMainLevelAndPlayerLevel(self)
  return DataCenter.BuildManager.MainLv >= self.base.min and DataCenter.BuildManager.MainLv <= self.base.max and DataCenter.PlayerLevelManager:GetLevel() >= self.level.min and DataCenter.PlayerLevelManager:GetLevel() <= self.level.max
end

ResLackTipsTemplate.__init = __init
ResLackTipsTemplate.__delete = __delete
ResLackTipsTemplate.InitData = InitData
ResLackTipsTemplate.CheckMainLevelAndPlayerLevel = CheckMainLevelAndPlayerLevel
return ResLackTipsTemplate
