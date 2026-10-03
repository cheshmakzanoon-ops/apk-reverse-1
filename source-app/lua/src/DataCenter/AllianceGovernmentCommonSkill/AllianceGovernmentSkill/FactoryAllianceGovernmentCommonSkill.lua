local FactoryAllianceGovernmentCommonSkill = BaseClass("FactoryAllianceGovernmentCommonSkill")
local CRefreshBallSkill = require("DataCenter.AllianceGovernmentCommonSkill.AllianceGovernmentSkill.CRefreshBallSkill")
local CReinforcementSkill = require("DataCenter.AllianceGovernmentCommonSkill.AllianceGovernmentSkill.CReinforcementSkill")
local CTeslaCoilSkill = require("DataCenter.AllianceGovernmentCommonSkill.AllianceGovernmentSkill.CTeslaCoilSkill")
local CAresMissileSkill = require("DataCenter.AllianceGovernmentCommonSkill.AllianceGovernmentSkill.CAresMissileSkill")
local CAbundantHarvestSkill = require("DataCenter.AllianceGovernmentCommonSkill.AllianceGovernmentSkill.CAbundantHarvestSkill")
local CGoddessMummySkill = require("DataCenter.AllianceGovernmentCommonSkill.AllianceGovernmentSkill.CGoddessMummySkill")

function FactoryAllianceGovernmentCommonSkill.GetSkillLogic(data)
  if data == nil then
    return nil
  end
  local skillFlag = data.config.skill_flag
  if skillFlag == AlOfficialSkillType.RefreshBall then
    return CRefreshBallSkill.New(data)
  elseif skillFlag == AlOfficialSkillType.Reinforcement then
    return CReinforcementSkill.New(data)
  elseif skillFlag == AlOfficialSkillType.AbundantHarvest then
    return CAbundantHarvestSkill.New(data)
  elseif skillFlag == AlOfficialSkillType.TeslaCoil then
    return CTeslaCoilSkill.New(data)
  elseif skillFlag == AlOfficialSkillType.AresMissile then
    return CAresMissileSkill.New(data)
  elseif skillFlag == AlOfficialSkillType.GoddessMummy then
    return CGoddessMummySkill.New(data)
  end
end

return ConstClass("FactoryAllianceGovernmentCommonSkill", FactoryAllianceGovernmentCommonSkill)
