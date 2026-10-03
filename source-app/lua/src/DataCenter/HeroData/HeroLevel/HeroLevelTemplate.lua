local HeroLevelTemplate = BaseClass("HeroLevelTemplate")

local function __init(self)
  self.id = 0
  self.level = 0
  self.next_exp = 0
  self.coins = 0
  self.resource = {}
  self.unlock_function = {}
  self.city_exp_get = 0
  self.tech_condition = ""
end

local function __delete(self)
  self.id = nil
  self.level = nil
  self.next_exp = nil
  self.coins = nil
  self.resource = nil
  self.unlock_function = nil
  self.city_exp_get = nil
  self.tech_condition = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = row:getValue("id") or 0
  self.level = row:getValue("level") or 0
  self.next_exp = row:getValue("next_exp") or 0
  self.coins = row:getValue("coins") or 0
  self.resource = row:getValue("resource") or {}
  self.unlock_function = row:getValue("unlock_function") or {}
  self.city_exp_get = row:getValue("city_exp_get") or 0
  self.tech_condition = row:getValue("tech_condition") or ""
end

HeroLevelTemplate.__init = __init
HeroLevelTemplate.__delete = __delete
HeroLevelTemplate.InitData = InitData
return HeroLevelTemplate
