local DamagePercentInfo = BaseClass("DamagePercentInfo")

function DamagePercentInfo:InitData(damagePercentInfo)
  self.targetUuid = damagePercentInfo.targetUuid
  self.damagePercent = damagePercentInfo.damagePercent
  self.woundedPercent = damagePercentInfo.woundedPercent
  self.injuredPercent = damagePercentInfo.injuredPercent
  self.deadPercent = damagePercentInfo.deadPercent
  self.selfUuid = damagePercentInfo.selfUuid
end

return DamagePercentInfo
