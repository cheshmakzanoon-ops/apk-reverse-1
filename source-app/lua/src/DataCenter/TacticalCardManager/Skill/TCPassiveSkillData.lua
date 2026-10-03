local TCBaseSkillData = require("DataCenter.TacticalCardManager.Skill.TCBaseSkillData")
local TCPassiveSkillData = BaseClass("TCPassiveSkillData", TCBaseSkillData)
local base = TCBaseSkillData

local function __init(self)
  base.__init(self)
end

local function __delete(self)
  base.__delete(self)
end

function TCPassiveSkillData:UpdateData(skillId, serverData)
  base.UpdateData(self, skillId, serverData)
end

TCPassiveSkillData.__init = __init
TCPassiveSkillData.__delete = __delete
return TCPassiveSkillData
