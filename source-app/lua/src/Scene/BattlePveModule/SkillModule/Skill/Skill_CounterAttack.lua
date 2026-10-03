local base = require("Scene.BattlePveModule.SkillModule.Skill.SkillBase")
local Skill_CounterAttack = BaseClass("Skill_CounterAttack", base)

function Skill_CounterAttack:DoAttack(actionItem, callback, maxTime)
  base.DoAttack(self, actionItem, callback)
  self:DoCallback()
end

return Skill_CounterAttack
