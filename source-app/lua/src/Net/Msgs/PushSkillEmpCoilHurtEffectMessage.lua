local PushSkillEmpCoilHurtEffectMessage = BaseClass("PushSkillEmpCoilHurtEffectMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushSkillEmpCoilHurtEffectMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.AllianceSkillManager:SkillEmpCoilHurtEffect(t)
  end
end

return PushSkillEmpCoilHurtEffectMessage
