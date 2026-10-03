local HeroLevelPropertyTemplate = BaseClass("HeroLevelPropertyTemplate")

local function __init(self)
  self.id = 0
  self.type = 0
  self.level = 0
  self.hp = 0
  self.atk = 0
  self.def = 0
  self.acc = 0
  self.crit = 0
  self.sc = 0
end

local function __delete(self)
  self.id = nil
  self.type = nil
  self.level = nil
  self.hp = nil
  self.atk = nil
  self.def = nil
  self.acc = nil
  self.crit = nil
  self.sc = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.type = tonumber(row:getValue("type")) or 0
  self.level = tonumber(row:getValue("level")) or 0
  self.hp = tonumber(row:getValue("base_hp")) or 0
  self.atk = tonumber(row:getValue("base_patk")) or 0
  self.def = tonumber(row:getValue("base_pdef")) or 0
  self.acc = tonumber(row:getValue("base_acc")) or 0
  self.crit = tonumber(row:getValue("base_crit")) or 0
  self.sc = tonumber(row:getValue("base_soldier_capacity")) or 0
end

HeroLevelPropertyTemplate.__init = __init
HeroLevelPropertyTemplate.__delete = __delete
HeroLevelPropertyTemplate.InitData = InitData
return HeroLevelPropertyTemplate
