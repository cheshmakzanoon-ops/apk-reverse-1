local ActMonsterTemplate = BaseClass("ActMonsterTemplate")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.difficulty_des = 0
  self.id = 0
  self.description = 0
  self.monster_des = ""
  self.help_time = 0
  self.call_consume = 0
end

local function __delete(self)
  self.id = nil
  self.difficulty_des = nil
  self.description = nil
  self.monster_des = nil
  self.help_time = nil
  self.call_consume = nil
end

local function InitData(self, row)
  self.id = row:getValue("id")
  self.difficulty_des = row:getValue("difficulty_des")
  self.description = row:getValue("description")
  self.monster_des = row:getValue("monster_des")
  self.help_time = row:getValue("help_time")
  self.call_consume = row:getValue("call_consume")
end

ActMonsterTemplate.__init = __init
ActMonsterTemplate.__delete = __delete
ActMonsterTemplate.InitData = InitData
return ActMonsterTemplate
