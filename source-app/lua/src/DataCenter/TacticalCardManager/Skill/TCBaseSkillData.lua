local TCBaseSkillData = BaseClass("TCBaseSkillData")

local function __init(self)
end

local function __delete(self)
end

function TCBaseSkillData:InitData(cardUuid)
  self.cardUuid = cardUuid
end

function TCBaseSkillData:UpdateData(skillId, serverData)
  if not skillId then
    return
  end
  self.skillId = skillId
  self.template = DataCenter.TacticalCardDataManager:GetSkillTemplateData(skillId)
  self.skillType = self.template.active
end

function TCBaseSkillData:GetSkillType()
  return self.skillType
end

function TCBaseSkillData:GetSkillGroupId()
  if not self.template then
    return
  end
  return self.template.group
end

function TCBaseSkillData:GetSkillEffectType()
  if not self.template then
    return
  end
  return self.template.effect
end

TCBaseSkillData.__init = __init
TCBaseSkillData.__delete = __delete
return TCBaseSkillData
