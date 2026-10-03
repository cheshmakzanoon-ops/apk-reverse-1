local ActGhostreconTaskSuperConditionTemplate = BaseClass("ActGhostreconTaskSuperConditionTemplate")

local function __init(self)
  self.heroId = 0
  self.star = 0
  self.level = 0
  self.num = 0
end

local function __delete(self)
  self.star = nil
  self.level = nil
  self.num = nil
end

local function InitData(self, cfg)
  local heroId, star, level, num = string.match(cfg, "(%d+)[;](%d+)[;](%d+)[;](%d+)")
  self.heroId = tonumber(heroId)
  self.star = tonumber(star)
  self.level = tonumber(level)
  self.num = tonumber(num)
end

ActGhostreconTaskSuperConditionTemplate.__init = __init
ActGhostreconTaskSuperConditionTemplate.__delete = __delete
ActGhostreconTaskSuperConditionTemplate.InitData = InitData
return ActGhostreconTaskSuperConditionTemplate
