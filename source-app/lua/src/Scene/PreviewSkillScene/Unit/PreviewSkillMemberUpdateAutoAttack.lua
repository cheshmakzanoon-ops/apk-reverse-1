local base = require("Scene/LWBattle/BarrageBattle/MemberState/MemberUpStateAutoAttack")
local PreviewSkillMemberUpdateAutoAttack = BaseClass("PreviewSkillMemberUpdateAutoAttack", base)

function PreviewSkillMemberUpdateAutoAttack:OnEnter()
  base.OnEnter(self)
end

function PreviewSkillMemberUpdateAutoAttack:OnUpdate()
  base.OnUpdate(self)
  self:PassiveCast()
end

function PreviewSkillMemberUpdateAutoAttack:PassiveCast()
  local allSkills = self.unit.skillManager:GetAllSkills()
  for _, v in pairs(allSkills) do
    if v.meta.apType == SkillAPType.Passive and v.cd <= 0 then
      v:Cast()
    end
  end
end

return PreviewSkillMemberUpdateAutoAttack
