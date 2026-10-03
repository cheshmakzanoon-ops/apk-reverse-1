local ArmyTemplateManager = BaseClass("ArmyTemplateManager")

local function __init(self)
  self.armyTemplateDic = {}
end

local function __delete(self)
  self.armyTemplateDic = nil
end

local function GetArmyTemplate(self, id)
  return nil
end

ArmyTemplateManager.__init = __init
ArmyTemplateManager.__delete = __delete
ArmyTemplateManager.GetArmyTemplate = GetArmyTemplate
return ArmyTemplateManager
