local PveSkillTestTemplate = BaseClass("PveSkillTestTemplate")

local function __init(self)
end

local function __delete(self)
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.hero = tonumber(row:getValue("hero")) or 0
end

PveSkillTestTemplate.__init = __init
PveSkillTestTemplate.__delete = __delete
PveSkillTestTemplate.InitData = InitData
return PveSkillTestTemplate
