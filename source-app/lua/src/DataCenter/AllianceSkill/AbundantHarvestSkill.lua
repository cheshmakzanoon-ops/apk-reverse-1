local AllianceBaseSkill = require("DataCenter.AllianceSkill.AllianceBaseSkill")
local base = AllianceBaseSkill
local AbundantHarvestSkill = BaseClass("AbundantHarvestSkill", base)

function AbundantHarvestSkill:LodChange()
  if self.theLod > 2 then
    self:ReleaseSkillEff()
  end
end

function AbundantHarvestSkill:DoPlayEffect(effect)
  if effect.Tags == "sole" then
    local allianceBaseData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    if allianceBaseData then
      local theWorld = CS.SceneManager.World
      if theWorld ~= nil and CS.SceneManager:IsInWorld() then
        local cityList = theWorld:GetAllMainBaseList()
        for _, v in pairs(cityList) do
          if v.allianceId == allianceBaseData.uid then
            local soleEffectPath = effect.Path
            self:PlaySkillEff(v.mainIndex, soleEffectPath, 2, nil, true, true, nil, effect)
          end
        end
      end
    end
    return true
  else
    return base.DoPlayEffect(self, effect)
  end
end

return AbundantHarvestSkill
