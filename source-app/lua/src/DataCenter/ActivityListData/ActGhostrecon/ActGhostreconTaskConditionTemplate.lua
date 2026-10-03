local ActGhostreconTaskConditionTemplate = BaseClass("ActGhostreconTaskConditionTemplate")

local function __init(self)
  self.type = 0
  self.value = 0
  self.num = 0
end

local function __delete(self)
  self.type = nil
  self.value = nil
  self.num = nil
end

local function InitData(self, cfg)
  local type, value, num = string.match(cfg, "(%d+)[;](%d+)[;](%d+)")
  self.type = tonumber(type)
  self.value = tonumber(value)
  self.num = tonumber(num)
end

ActGhostreconTaskConditionTemplate.__init = __init
ActGhostreconTaskConditionTemplate.__delete = __delete
ActGhostreconTaskConditionTemplate.InitData = InitData
return ActGhostreconTaskConditionTemplate
