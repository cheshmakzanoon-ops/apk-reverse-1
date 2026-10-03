local ArmyAttrInfo = BaseClass("ArmyAttrInfo")

function ArmyAttrInfo:InitData(armyAttrInfo)
  self.reason = armyAttrInfo.reason
  self.value = armyAttrInfo.value
end

return ArmyAttrInfo
