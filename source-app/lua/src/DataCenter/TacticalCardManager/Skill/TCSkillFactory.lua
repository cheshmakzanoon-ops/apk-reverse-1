local TCSkillFactory = {}
TacticalCardSkillClsPathConfig = {
  [TacticalCardSkillType.Active] = "DataCenter.TacticalCardManager.Skill.TCActiveSkillData",
  [TacticalCardSkillType.Passive] = "DataCenter.TacticalCardManager.Skill.TCPassiveSkillData"
}
local BASE_SKILL_CLS_PATH = "DataCenter.TacticalCardManager.Skill.TCBaseSkillData"

function TCSkillFactory.CreateSkill(skillTmp)
  if not skillTmp then
    return require(BASE_SKILL_CLS_PATH).New()
  end
  local skillType = skillTmp.active
  local skillEffect = skillTmp.effect
  local classPath = TacticalCardSkillClsPathConfig[skillType]
  if skillEffect == TCCardSkillEffectType.GetRemainResourceImmediate then
    classPath = "DataCenter.TacticalCardManager.Skill.ActiveSkill.TCActiveFastCollectSkillData"
  end
  return require(classPath).New()
end

return ConstClass("TCSkillFactory", TCSkillFactory)
