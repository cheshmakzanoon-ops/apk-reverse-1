local Base = require("DataCenter.CommonSimpleTemplateManager.CommonSimpleBaseTemplate")
local LWBattlePetTemplate = BaseClass("LWBattlePetTemplate", Base)

local function __init(self)
  Base.__init(self)
  self.heroId = 0
  self.attribute_self = {}
  self.attribute_inherit = {}
  self.target_rule = 0
  self.if_attackable = false
  self.lifetime = 0
  self.index_type = 0
  self.follow = false
  self.useSkillFormation = false
  self.useCollider = false
  self.collider_type = -1
  self.useTaunt = false
  self.movable = false
  self.moveVelocityX = 0
  self.moveVelocityY = 0
  self.moveSpeed = 0
  self.moveDuration = 0
  self.bornRotationFlow = false
end

local function __delete(self)
  self.heroId = 0
  self.attribute_self = {}
  self.attribute_inherit = {}
  self.target_rule = 0
  self.if_attackable = false
  self.lifetime = 0
  self.index_type = 0
  self.follow = false
  self.useSkillFormation = false
  self.useCollider = false
  self.collider_type = -1
  self.useTaunt = false
  self.movable = false
  self.moveVelocityX = 0
  self.moveVelocityY = 0
  self.moveSpeed = 0
  self.moveDuration = 0
  Base.__delete(self)
end

local function InitData(self, row)
  Base.InitData(self, row)
  self.heroId = tonumber(row:getValue("heroid")) or 0
  self.attribute_self = row:getValue("attribute_self") or {}
  self.attribute_inherit = row:getValue("attribute_inherit") or {}
  self.target_rule = tonumber(row:getValue("target_rule")) or 0
  self.if_attackable = row:getValue("if_attackable") == "1"
  self.lifetime = tonumber(row:getValue("lifetime")) or 0
  self.index_type = tonumber(row:getValue("index_type")) or 0
  self.follow = row:getValue("follow") == 1
  self.useSkillFormation = row:getValue("useSkillFormation") == 1
  self.useCollider = row:getValue("useCollider") == 1
  self.collider_type = row:getValue("collider_type")
  self.useTaunt = row:getValue("useTaunt") == 1
  local movement_on_spawn = row:getValue("movement_on_spawn")
  if movement_on_spawn and #movement_on_spawn == 4 then
    self.moveVelocityX = movement_on_spawn[1]
    self.moveVelocityY = movement_on_spawn[2]
    self.moveSpeed = movement_on_spawn[3]
    self.moveDuration = movement_on_spawn[4]
    self.movable = (self.moveVelocityY ~= 0 or self.moveVelocityX ~= 0) and self.moveSpeed ~= 0
  else
    self.movable = false
  end
  self.bornRotationFlow = row:getValue("born_rotation_follow") == 1
end

LWBattlePetTemplate.__init = __init
LWBattlePetTemplate.__delete = __delete
LWBattlePetTemplate.InitData = InitData
return LWBattlePetTemplate
