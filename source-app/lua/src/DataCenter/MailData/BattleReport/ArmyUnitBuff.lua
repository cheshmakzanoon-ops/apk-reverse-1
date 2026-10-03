local ArmyUnitBuff = BaseClass("ArmyUnitBuff")

function ArmyUnitBuff:InitData(unitBuff)
  self.buffId = unitBuff.buffId
  local idList = unitBuff.effectId
  self.effectDict = {}
  for k, v in pairs(unitBuff.value) do
    if idList[k] ~= nil and idList[k] ~= 0 and v ~= nil then
      self.effectDict[idList[k]] = v
    end
  end
  self.expireTime = unitBuff.expireTime
end

function ArmyUnitBuff:GetEffectNum(effectId)
  if self.effectDict[effectId] ~= nil then
    return self.effectDict[effectId]
  end
  return 0
end

return ArmyUnitBuff
