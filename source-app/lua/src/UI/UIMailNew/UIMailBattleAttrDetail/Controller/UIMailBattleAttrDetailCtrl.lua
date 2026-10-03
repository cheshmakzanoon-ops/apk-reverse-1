local UIMailBattleAttrDetailCtrl = BaseClass("UIMailBattleAttrDetailCtrl", UIBaseCtrl)
local needCheckList = {
  GameEffectReason.Building,
  GameEffectReason.Science,
  GameEffectReason.Hero,
  GameEffectReason.VIP,
  GameEffectReason.Status,
  GameEffectReason.World_Alliance_City,
  GameEffectReason.Tank,
  GameEffectReason.Career,
  GameEffectReason.Alliance_Career,
  GameEffectReason.Alliance_Science,
  GameEffectReason.FormationBuff,
  GameEffectReason.FormationRestraintValue,
  GameEffectReason.BASE_TALENT,
  GameEffectReason.HERO_OFFICIAL,
  GameEffectReason.ARTIFACT
}

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIMailBattleAttrDetail)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function GetDetailList(self, leftFightData, rightFightData, leftBattleEffect, rightBattleEffect, leftUuid, rightUuid)
  local showList = {}
  table.insert(showList, self:GetHeroAttackData(leftFightData, rightFightData, leftBattleEffect, rightBattleEffect, leftUuid, rightUuid))
  table.insert(showList, self:GetHeroDefenceData(leftFightData, rightFightData, leftBattleEffect, rightBattleEffect, leftUuid, rightUuid))
  table.insert(showList, self:GetAttackAddData(leftFightData, rightFightData, leftBattleEffect, rightBattleEffect, leftUuid, rightUuid))
  table.insert(showList, self:GetDefenceAddData(leftFightData, rightFightData, leftBattleEffect, rightBattleEffect, leftUuid, rightUuid))
  table.insert(showList, self:GetHealthAddData(leftFightData, rightFightData, leftBattleEffect, rightBattleEffect, leftUuid, rightUuid))
  table.insert(showList, self:GetMarchLimitAddData(leftFightData, rightFightData, leftBattleEffect, rightBattleEffect, leftUuid, rightUuid))
  local leftHeroRestraint, rightHeroRestraint = self:GetHeroRestraintValue(leftFightData, rightFightData, leftBattleEffect, rightBattleEffect, leftUuid, rightUuid)
  local leftHeroCampAdd, rightHeroCampAdd = self:GetHeroCampAdd(leftFightData, rightFightData, leftBattleEffect, rightBattleEffect, leftUuid, rightUuid)
  local skillHurtData = self:GetSkillHurtAddData(leftFightData, rightFightData, leftBattleEffect, rightBattleEffect, leftUuid, rightUuid)
  if skillHurtData ~= nil and skillHurtData.reasonList ~= nil then
    local reason1 = skillHurtData.reasonList[GameEffectReason.FormationRestraintValue]
    skillHurtData.leftNum = skillHurtData.leftNum + leftHeroRestraint
    skillHurtData.rightNum = skillHurtData.rightNum + rightHeroRestraint
    reason1.leftData.totalNum = reason1.leftData.totalNum + leftHeroRestraint
    reason1.rightData.totalNum = reason1.rightData.totalNum + rightHeroRestraint
    local reason2 = skillHurtData.reasonList[GameEffectReason.FormationBuff]
    skillHurtData.leftNum = skillHurtData.leftNum + leftHeroCampAdd
    skillHurtData.rightNum = skillHurtData.rightNum + rightHeroCampAdd
    reason2.leftData.totalNum = reason2.leftData.totalNum + leftHeroCampAdd
    reason2.rightData.totalNum = reason2.rightData.totalNum + rightHeroCampAdd
  end
  local normalHurtData = self:GetNormalHurtAddData(leftFightData, rightFightData, leftBattleEffect, rightBattleEffect, leftUuid, rightUuid)
  if normalHurtData ~= nil and normalHurtData.reasonList ~= nil then
    local reason1 = normalHurtData.reasonList[GameEffectReason.FormationRestraintValue]
    normalHurtData.leftNum = normalHurtData.leftNum + leftHeroRestraint
    normalHurtData.rightNum = normalHurtData.rightNum + rightHeroRestraint
    reason1.leftData.totalNum = reason1.leftData.totalNum + leftHeroRestraint
    reason1.rightData.totalNum = reason1.rightData.totalNum + rightHeroRestraint
    local reason2 = normalHurtData.reasonList[GameEffectReason.FormationBuff]
    normalHurtData.leftNum = normalHurtData.leftNum + leftHeroCampAdd
    normalHurtData.rightNum = normalHurtData.rightNum + rightHeroCampAdd
    reason2.leftData.totalNum = reason2.leftData.totalNum + leftHeroCampAdd
    reason2.rightData.totalNum = reason2.rightData.totalNum + rightHeroCampAdd
  end
  local backHurtData = self:GetBackHurtAddData(leftFightData, rightFightData, leftBattleEffect, rightBattleEffect, leftUuid, rightUuid)
  if backHurtData ~= nil and backHurtData.reasonList ~= nil then
    local reason1 = backHurtData.reasonList[GameEffectReason.FormationRestraintValue]
    backHurtData.leftNum = backHurtData.leftNum + leftHeroRestraint
    backHurtData.rightNum = backHurtData.rightNum + rightHeroRestraint
    reason1.leftData.totalNum = reason1.leftData.totalNum + leftHeroRestraint
    reason1.rightData.totalNum = reason1.rightData.totalNum + rightHeroRestraint
    local reason2 = backHurtData.reasonList[GameEffectReason.FormationBuff]
    backHurtData.leftNum = backHurtData.leftNum + leftHeroCampAdd
    backHurtData.rightNum = backHurtData.rightNum + rightHeroCampAdd
    reason2.leftData.totalNum = reason2.leftData.totalNum + leftHeroCampAdd
    reason2.rightData.totalNum = reason2.rightData.totalNum + rightHeroCampAdd
  end
  table.insert(showList, skillHurtData)
  table.insert(showList, normalHurtData)
  table.insert(showList, backHurtData)
  table.insert(showList, self:GetSkillHurtDecData(leftFightData, rightFightData, leftBattleEffect, rightBattleEffect, leftUuid, rightUuid))
  table.insert(showList, self:GetNormalHurtDecData(leftFightData, rightFightData, leftBattleEffect, rightBattleEffect, leftUuid, rightUuid))
  table.insert(showList, self:GetBackHurtDecData(leftFightData, rightFightData, leftBattleEffect, rightBattleEffect, leftUuid, rightUuid))
  table.insert(showList, self:GetCurveData(leftFightData, rightFightData, leftBattleEffect, rightBattleEffect, leftUuid, rightUuid))
  return showList
end

local function GetAttackAddData(self, leftFightData, rightFightData, leftBattleEffect, rightBattleEffect, leftUuid, rightUuid)
  local oneData = {}
  oneData.dialogId = "163138"
  oneData.leftNum = 0
  oneData.rightNum = 0
  oneData.showType = BattleSubTitleShowType.AttackAdd
  local reasonList = {}
  for k, v in pairs(needCheckList) do
    local tempData = {}
    tempData.leftData = {}
    tempData.leftData.totalNum = 0
    tempData.leftData.totalReason = {}
    tempData.rightData = {}
    tempData.rightData.totalNum = 0
    tempData.rightData.totalReason = {}
    reasonList[v] = tempData
  end
  local aLeftData = self:GetEffectDataByEffectId(35000, leftBattleEffect, leftFightData, leftUuid)
  local aRightData = self:GetEffectDataByEffectId(35000, rightBattleEffect, rightFightData, rightUuid)
  oneData.leftNum = oneData.leftNum + aLeftData.totalNum
  oneData.rightNum = oneData.rightNum + aRightData.totalNum
  self:SetReasonShowList(35000, 129030, reasonList, aLeftData, aRightData, 1, 1)
  local bLeftPercent = 0
  local bRightPercent = 0
  if leftFightData ~= nil and leftFightData.unitData ~= nil then
    bLeftPercent = leftFightData.unitData:GetSoldierPercentByType(ArmType.Tank)
  end
  if rightFightData ~= nil and rightFightData.unitData ~= nil then
    bRightPercent = rightFightData.unitData:GetSoldierPercentByType(ArmType.Tank)
  end
  local bLeftData = self:GetEffectDataByEffectId(35001, leftBattleEffect, leftFightData, leftUuid)
  local bRightData = self:GetEffectDataByEffectId(35001, rightBattleEffect, rightFightData, rightUuid)
  oneData.leftNum = oneData.leftNum + bLeftData.totalNum * bLeftPercent
  oneData.rightNum = oneData.rightNum + bRightData.totalNum * bRightPercent
  self:SetReasonShowList(35001, 220050, reasonList, bLeftData, bRightData, bLeftPercent, bRightPercent)
  local cLeftPercent = 0
  local cRightPercent = 0
  if leftFightData ~= nil and leftFightData.unitData ~= nil then
    cLeftPercent = leftFightData.unitData:GetSoldierPercentByType(ArmType.Robot)
  end
  if rightFightData ~= nil and rightFightData.unitData ~= nil then
    cRightPercent = rightFightData.unitData:GetSoldierPercentByType(ArmType.Robot)
  end
  local cLeftData = self:GetEffectDataByEffectId(35002, leftBattleEffect, leftFightData, leftUuid)
  local cRightData = self:GetEffectDataByEffectId(35002, rightBattleEffect, rightFightData, rightUuid)
  oneData.leftNum = oneData.leftNum + cLeftData.totalNum * cLeftPercent
  oneData.rightNum = oneData.rightNum + cRightData.totalNum * cRightPercent
  self:SetReasonShowList(35002, 220051, reasonList, cLeftData, cRightData, cLeftPercent, cRightPercent)
  local dLeftPercent = 0
  local dRightPercent = 0
  if leftFightData ~= nil and leftFightData.unitData ~= nil then
    dLeftPercent = leftFightData.unitData:GetSoldierPercentByType(ArmType.Plane)
  end
  if rightFightData ~= nil and rightFightData.unitData ~= nil then
    dRightPercent = rightFightData.unitData:GetSoldierPercentByType(ArmType.Plane)
  end
  local dLeftData = self:GetEffectDataByEffectId(35003, leftBattleEffect, leftFightData, leftUuid)
  local dRightData = self:GetEffectDataByEffectId(35003, rightBattleEffect, rightFightData, rightUuid)
  oneData.leftNum = oneData.leftNum + dLeftData.totalNum * dLeftPercent
  oneData.rightNum = oneData.rightNum + dRightData.totalNum * dRightPercent
  self:SetReasonShowList(35003, 220052, reasonList, dLeftData, dRightData, dLeftPercent, dRightPercent)
  if leftFightData ~= nil and rightFightData ~= nil then
    if leftFightData.battleType == BattleType.Building and leftFightData.buildId ~= BuildingTypes.APS_BUILD_WORMHOLE_SUB or leftFightData.battleType == BattleType.City or leftFightData.battleType == BattleType.ALLIANCE_OCCUPIED_CITY or leftFightData.battleType == BattleType.ALLIANCE_NEUTRAL_CITY or leftFightData.battleType == BattleType.Turret and leftFightData.buildId ~= BuildingTypes.APS_BUILD_WORMHOLE_SUB then
      local LeftData = self:GetEffectDataByEffectId(35048, leftBattleEffect, leftFightData, leftUuid)
      oneData.leftNum = oneData.leftNum + LeftData.totalNum
      self:SetReasonShowList(35048, 220097, reasonList, LeftData, nil, 1, 1)
    end
    if rightFightData.battleType == BattleType.Building and rightFightData.buildId ~= BuildingTypes.APS_BUILD_WORMHOLE_SUB or rightFightData.battleType == BattleType.City or rightFightData.battleType == BattleType.ALLIANCE_OCCUPIED_CITY or rightFightData.battleType == BattleType.ALLIANCE_NEUTRAL_CITY or rightFightData.battleType == BattleType.Turret then
      local RightData = self:GetEffectDataByEffectId(35048, rightBattleEffect, rightFightData, rightUuid)
      oneData.rightNum = oneData.rightNum + RightData.totalNum
      self:SetReasonShowList(35048, 220097, reasonList, nil, RightData, 1, 1)
    end
    if rightFightData.battleType == BattleType.Building and rightFightData.buildId ~= BuildingTypes.APS_BUILD_WORMHOLE_SUB or rightFightData.battleType == BattleType.City or rightFightData.battleType == BattleType.ALLIANCE_OCCUPIED_CITY or rightFightData.battleType == BattleType.ALLIANCE_NEUTRAL_CITY or rightFightData.battleType == BattleType.Turret then
      local LeftData = self:GetEffectDataByEffectId(35040, leftBattleEffect, leftFightData, leftUuid)
      oneData.leftNum = oneData.leftNum + LeftData.totalNum
      self:SetReasonShowList(35040, 220089, reasonList, LeftData, nil, 1, 1)
    end
    if leftFightData.battleType == BattleType.Building and leftFightData.buildId ~= BuildingTypes.APS_BUILD_WORMHOLE_SUB or leftFightData.battleType == BattleType.City or leftFightData.battleType == BattleType.ALLIANCE_OCCUPIED_CITY or leftFightData.battleType == BattleType.ALLIANCE_NEUTRAL_CITY or leftFightData.battleType == BattleType.Turret then
      local RightData = self:GetEffectDataByEffectId(35040, rightBattleEffect, rightFightData, rightUuid)
      oneData.rightNum = oneData.rightNum + RightData.totalNum
      self:SetReasonShowList(35040, 220089, reasonList, nil, RightData, 1, 1)
    end
    if (leftFightData.battleType == BattleType.RallyFormation or leftFightData.battleType == BattleType.Formation or leftFightData.buildId == BuildingTypes.APS_BUILD_WORMHOLE_SUB) and (rightFightData.battleType == BattleType.RallyFormation or rightFightData.battleType == BattleType.Formation or rightFightData.buildId == BuildingTypes.APS_BUILD_WORMHOLE_SUB) then
      local LeftData = self:GetEffectDataByEffectId(35024, leftBattleEffect, leftFightData, leftUuid)
      oneData.leftNum = oneData.leftNum + LeftData.totalNum
      self:SetReasonShowList(35024, 220073, reasonList, LeftData, nil, 1, 1)
      local RightData = self:GetEffectDataByEffectId(35024, rightBattleEffect, rightFightData, rightUuid)
      oneData.rightNum = oneData.rightNum + RightData.totalNum
      self:SetReasonShowList(35024, 220073, reasonList, nil, RightData, 1, 1)
    end
    if (leftFightData.battleType == BattleType.RallyFormation or leftFightData.battleType == BattleType.Formation) and (rightFightData.battleType == BattleType.Monster or rightFightData.battleType == BattleType.ACT_BOSS or rightFightData.battleType == BattleType.Boss or rightFightData.battleType == BattleType.PUZZLE_BOSS or rightFightData.battleType == BattleType.CHALLENGE_BOSS) then
      local LeftData = self:GetEffectDataByEffectId(35056, leftBattleEffect, leftFightData, leftUuid)
      oneData.leftNum = oneData.leftNum + LeftData.totalNum
      self:SetReasonShowList(35056, 220105, reasonList, LeftData, nil, 1, 1)
      local RightData = self:GetEffectDataByEffectId(35056, rightBattleEffect, rightFightData, rightUuid)
      oneData.rightNum = oneData.rightNum + RightData.totalNum
      self:SetReasonShowList(35056, 220105, reasonList, nil, RightData, 1, 1)
    end
    if leftFightData.battleType == BattleType.RallyFormation then
      local LeftData = self:GetEffectDataByEffectId(35032, leftBattleEffect, leftFightData, leftUuid)
      oneData.leftNum = oneData.leftNum + LeftData.totalNum
      self:SetReasonShowList(35032, 220081, reasonList, LeftData, nil, 1, 1)
    end
    if rightFightData.battleType == BattleType.RallyFormation then
      local RightData = self:GetEffectDataByEffectId(35032, rightBattleEffect, rightFightData, rightUuid)
      oneData.rightNum = oneData.rightNum + RightData.totalNum
      self:SetReasonShowList(35032, 220081, reasonList, nil, RightData, 1, 1)
    end
    if (leftFightData.battleType == BattleType.Building and leftFightData.buildId ~= BuildingTypes.APS_BUILD_WORMHOLE_SUB or leftFightData.battleType == BattleType.City or leftFightData.battleType == BattleType.ALLIANCE_OCCUPIED_CITY or leftFightData.battleType == BattleType.ALLIANCE_NEUTRAL_CITY or leftFightData.battleType == BattleType.Turret) and leftFightData.unitData ~= nil and leftFightData.unitData:GetSpecialType() == SpecialUnitType.NONE then
      local LeftData = self:GetEffectDataByEffectId(35133, leftBattleEffect, leftFightData, leftUuid)
      oneData.leftNum = oneData.leftNum + LeftData.totalNum
      self:SetReasonShowList(35133, 163158, reasonList, LeftData, nil, 1, 1)
    end
    if (rightFightData.battleType == BattleType.Building and rightFightData.buildId ~= BuildingTypes.APS_BUILD_WORMHOLE_SUB or rightFightData.battleType == BattleType.City or rightFightData.battleType == BattleType.ALLIANCE_OCCUPIED_CITY or rightFightData.battleType == BattleType.ALLIANCE_NEUTRAL_CITY or rightFightData.battleType == BattleType.Turret) and rightFightData.unitData ~= nil and rightFightData.unitData:GetSpecialType() == SpecialUnitType.NONE then
      local RightData = self:GetEffectDataByEffectId(35133, rightBattleEffect, rightFightData, rightUuid)
      oneData.rightNum = oneData.rightNum + RightData.totalNum
      self:SetReasonShowList(35133, 163158, reasonList, nil, RightData, 1, 1)
    end
    if leftFightData.unitData ~= nil then
      local index = leftFightData.unitData:GetFormationIndex()
      local effectId = 0
      if rightFightData.battleType == BattleType.Building and rightFightData.buildId ~= BuildingTypes.APS_BUILD_WORMHOLE_SUB or rightFightData.battleType == BattleType.City or rightFightData.battleType == BattleType.ALLIANCE_OCCUPIED_CITY or rightFightData.battleType == BattleType.ALLIANCE_NEUTRAL_CITY or rightFightData.battleType == BattleType.Turret then
        if index == 1 then
          effectId = 40051
        elseif index == 2 then
          effectId = 40052
        elseif index == 3 then
          effectId = 40053
        elseif index == 4 then
          effectId = 40054
        end
        if 0 < effectId then
          local effectNum = leftBattleEffect:GetValue(effectId)
          local tempData = reasonList[GameEffectReason.Tank]
          if tempData ~= nil then
            oneData.leftNum = oneData.leftNum + effectNum
            tempData.leftData.totalNum = tempData.leftData.totalNum + effectNum
          end
        end
      end
      effectId = 0
      if index == 1 then
        effectId = 40036
      elseif index == 2 then
        effectId = 40037
      elseif index == 3 then
        effectId = 40038
      elseif index == 4 then
        effectId = 40039
      end
      if 0 < effectId then
        local effectNum = leftBattleEffect:GetValue(effectId)
        local tempData = reasonList[GameEffectReason.Tank]
        if tempData ~= nil then
          oneData.leftNum = oneData.leftNum + effectNum
          tempData.leftData.totalNum = tempData.leftData.totalNum + effectNum
        end
      end
    end
    if rightFightData.unitData ~= nil then
      local index = rightFightData.unitData:GetFormationIndex()
      local effectId = 0
      if leftFightData.battleType == BattleType.Building and leftFightData.buildId ~= BuildingTypes.APS_BUILD_WORMHOLE_SUB or leftFightData.battleType == BattleType.City or leftFightData.battleType == BattleType.ALLIANCE_OCCUPIED_CITY or leftFightData.battleType == BattleType.ALLIANCE_NEUTRAL_CITY or leftFightData.battleType == BattleType.Turret then
        if index == 1 then
          effectId = 40051
        elseif index == 2 then
          effectId = 40052
        elseif index == 3 then
          effectId = 40053
        elseif index == 4 then
          effectId = 40054
        end
        if 0 < effectId then
          local effectNum = rightBattleEffect:GetValue(effectId)
          local tempData = reasonList[GameEffectReason.Tank]
          if tempData ~= nil then
            oneData.rightNum = oneData.rightNum + effectNum
            tempData.rightData.totalNum = tempData.rightData.totalNum + effectNum
          end
        end
      end
      effectId = 0
      if index == 1 then
        effectId = 40036
      elseif index == 2 then
        effectId = 40037
      elseif index == 3 then
        effectId = 40038
      elseif index == 4 then
        effectId = 40039
      end
      if 0 < effectId then
        local effectNum = rightBattleEffect:GetValue(effectId)
        local tempData = reasonList[GameEffectReason.Tank]
        if tempData ~= nil then
          oneData.rightNum = oneData.rightNum + effectNum
          tempData.rightData.totalNum = tempData.rightData.totalNum + effectNum
        end
      end
    end
  end
  oneData.reasonList = reasonList
  return oneData
end

local function GetDefenceAddData(self, leftFightData, rightFightData, leftBattleEffect, rightBattleEffect, leftUuid, rightUuid)
  local oneData = {}
  oneData.dialogId = "163139"
  oneData.leftNum = 0
  oneData.rightNum = 0
  oneData.showType = BattleSubTitleShowType.DefenceAdd
  local reasonList = {}
  for k, v in pairs(needCheckList) do
    local tempData = {}
    tempData.leftData = {}
    tempData.leftData.totalNum = 0
    tempData.leftData.totalReason = {}
    tempData.rightData = {}
    tempData.rightData.totalNum = 0
    tempData.rightData.totalReason = {}
    reasonList[v] = tempData
  end
  local aLeftData = self:GetEffectDataByEffectId(35004, leftBattleEffect, leftFightData, leftUuid)
  local aRightData = self:GetEffectDataByEffectId(35004, rightBattleEffect, rightFightData, rightUuid)
  oneData.leftNum = oneData.leftNum + aLeftData.totalNum
  oneData.rightNum = oneData.rightNum + aRightData.totalNum
  self:SetReasonShowList(35004, 220053, reasonList, aLeftData, aRightData, 1, 1)
  local bLeftPercent = 0
  local bRightPercent = 0
  if leftFightData ~= nil and leftFightData.unitData ~= nil then
    bLeftPercent = leftFightData.unitData:GetSoldierPercentByType(ArmType.Tank)
  end
  if rightFightData ~= nil and rightFightData.unitData ~= nil then
    bRightPercent = rightFightData.unitData:GetSoldierPercentByType(ArmType.Tank)
  end
  local bLeftData = self:GetEffectDataByEffectId(35005, leftBattleEffect, leftFightData, leftUuid)
  local bRightData = self:GetEffectDataByEffectId(35005, rightBattleEffect, rightFightData, rightUuid)
  oneData.leftNum = oneData.leftNum + bLeftData.totalNum * bLeftPercent
  oneData.rightNum = oneData.rightNum + bRightData.totalNum * bRightPercent
  self:SetReasonShowList(35005, 220054, reasonList, bLeftData, bRightData, bLeftPercent, bRightPercent)
  local cLeftPercent = 0
  local cRightPercent = 0
  if leftFightData ~= nil and leftFightData.unitData ~= nil then
    cLeftPercent = leftFightData.unitData:GetSoldierPercentByType(ArmType.Robot)
  end
  if rightFightData ~= nil and rightFightData.unitData ~= nil then
    cRightPercent = rightFightData.unitData:GetSoldierPercentByType(ArmType.Robot)
  end
  local cLeftData = self:GetEffectDataByEffectId(35006, leftBattleEffect, leftFightData, leftUuid)
  local cRightData = self:GetEffectDataByEffectId(35006, rightBattleEffect, rightFightData, rightUuid)
  oneData.leftNum = oneData.leftNum + cLeftData.totalNum * cLeftPercent
  oneData.rightNum = oneData.rightNum + cRightData.totalNum * cRightPercent
  self:SetReasonShowList(35006, 220055, reasonList, cLeftData, cRightData, cLeftPercent, cRightPercent)
  local dLeftPercent = 0
  local dRightPercent = 0
  if leftFightData ~= nil and leftFightData.unitData ~= nil then
    dLeftPercent = leftFightData.unitData:GetSoldierPercentByType(ArmType.Plane)
  end
  if rightFightData ~= nil and rightFightData.unitData ~= nil then
    dRightPercent = rightFightData.unitData:GetSoldierPercentByType(ArmType.Plane)
  end
  local dLeftData = self:GetEffectDataByEffectId(35007, leftBattleEffect, leftFightData, leftUuid)
  local dRightData = self:GetEffectDataByEffectId(35007, rightBattleEffect, rightFightData, rightUuid)
  oneData.leftNum = oneData.leftNum + dLeftData.totalNum * dLeftPercent
  oneData.rightNum = oneData.rightNum + dRightData.totalNum * dRightPercent
  self:SetReasonShowList(35007, 220056, reasonList, dLeftData, dRightData, dLeftPercent, dRightPercent)
  if leftFightData ~= nil and rightFightData ~= nil then
    if leftFightData.battleType == BattleType.Building and leftFightData.buildId ~= BuildingTypes.APS_BUILD_WORMHOLE_SUB or leftFightData.battleType == BattleType.City or leftFightData.battleType == BattleType.ALLIANCE_OCCUPIED_CITY or leftFightData.battleType == BattleType.ALLIANCE_NEUTRAL_CITY or leftFightData.battleType == BattleType.Turret then
      local LeftData = self:GetEffectDataByEffectId(35052, leftBattleEffect, leftFightData, leftUuid)
      oneData.leftNum = oneData.leftNum + LeftData.totalNum
      self:SetReasonShowList(35052, 220101, reasonList, LeftData, nil, 1, 1)
    end
    if rightFightData.battleType == BattleType.Building and rightFightData.buildId ~= BuildingTypes.APS_BUILD_WORMHOLE_SUB or rightFightData.battleType == BattleType.City or rightFightData.battleType == BattleType.ALLIANCE_OCCUPIED_CITY or rightFightData.battleType == BattleType.ALLIANCE_NEUTRAL_CITY or rightFightData.battleType == BattleType.Turret then
      local RightData = self:GetEffectDataByEffectId(35052, rightBattleEffect, rightFightData, rightUuid)
      oneData.rightNum = oneData.rightNum + RightData.totalNum
      self:SetReasonShowList(35052, 220101, reasonList, nil, RightData, 1, 1)
    end
    if rightFightData.battleType == BattleType.Building and rightFightData.buildId ~= BuildingTypes.APS_BUILD_WORMHOLE_SUB or rightFightData.battleType == BattleType.City or rightFightData.battleType == BattleType.ALLIANCE_OCCUPIED_CITY or rightFightData.battleType == BattleType.ALLIANCE_NEUTRAL_CITY or rightFightData.battleType == BattleType.Turret then
      local LeftData = self:GetEffectDataByEffectId(35044, leftBattleEffect, leftFightData, leftUuid)
      oneData.leftNum = oneData.leftNum + LeftData.totalNum
      self:SetReasonShowList(35044, 220093, reasonList, LeftData, nil, 1, 1)
    end
    if leftFightData.battleType == BattleType.Building and leftFightData.buildId ~= BuildingTypes.APS_BUILD_WORMHOLE_SUB or leftFightData.battleType == BattleType.City or leftFightData.battleType == BattleType.ALLIANCE_OCCUPIED_CITY or leftFightData.battleType == BattleType.ALLIANCE_NEUTRAL_CITY or leftFightData.battleType == BattleType.Turret then
      local RightData = self:GetEffectDataByEffectId(35044, rightBattleEffect, rightFightData, rightUuid)
      oneData.rightNum = oneData.rightNum + RightData.totalNum
      self:SetReasonShowList(35044, 220093, reasonList, nil, RightData, 1, 1)
    end
    if (leftFightData.battleType == BattleType.RallyFormation or leftFightData.battleType == BattleType.Formation or leftFightData.buildId == BuildingTypes.APS_BUILD_WORMHOLE_SUB) and (rightFightData.battleType == BattleType.RallyFormation or rightFightData.battleType == BattleType.Formation or rightFightData.buildId == BuildingTypes.APS_BUILD_WORMHOLE_SUB) then
      local LeftData = self:GetEffectDataByEffectId(35028, leftBattleEffect, leftFightData, leftUuid)
      oneData.leftNum = oneData.leftNum + LeftData.totalNum
      self:SetReasonShowList(35028, 220077, reasonList, LeftData, nil, 1, 1)
      local RightData = self:GetEffectDataByEffectId(35028, rightBattleEffect, rightFightData, rightUuid)
      oneData.rightNum = oneData.rightNum + RightData.totalNum
      self:SetReasonShowList(35028, 220077, reasonList, nil, RightData, 1, 1)
    end
    if (leftFightData.battleType == BattleType.RallyFormation or leftFightData.battleType == BattleType.Formation) and (rightFightData.battleType == BattleType.Monster or rightFightData.battleType == BattleType.ACT_BOSS or rightFightData.battleType == BattleType.Boss or rightFightData.battleType == BattleType.PUZZLE_BOSS or rightFightData.battleType == BattleType.CHALLENGE_BOSS) then
      local LeftData = self:GetEffectDataByEffectId(35060, leftBattleEffect, leftFightData, leftUuid)
      oneData.leftNum = oneData.leftNum + LeftData.totalNum
      self:SetReasonShowList(35060, 220109, reasonList, LeftData, nil, 1, 1)
      local RightData = self:GetEffectDataByEffectId(35060, rightBattleEffect, rightFightData, rightUuid)
      oneData.rightNum = oneData.rightNum + RightData.totalNum
      self:SetReasonShowList(35060, 220109, reasonList, nil, RightData, 1, 1)
    end
    if leftFightData.battleType == BattleType.RallyFormation then
      local LeftData = self:GetEffectDataByEffectId(35036, leftBattleEffect, leftFightData, leftUuid)
      oneData.leftNum = oneData.leftNum + LeftData.totalNum
      self:SetReasonShowList(35036, 220085, reasonList, LeftData, nil, 1, 1)
    end
    if rightFightData.battleType == BattleType.RallyFormation then
      local RightData = self:GetEffectDataByEffectId(35036, rightBattleEffect, rightFightData, rightUuid)
      oneData.rightNum = oneData.rightNum + RightData.totalNum
      self:SetReasonShowList(35036, 220085, reasonList, nil, RightData, 1, 1)
    end
    if (leftFightData.battleType == BattleType.Building and leftFightData.buildId ~= BuildingTypes.APS_BUILD_WORMHOLE_SUB or leftFightData.battleType == BattleType.City or leftFightData.battleType == BattleType.ALLIANCE_OCCUPIED_CITY or leftFightData.battleType == BattleType.ALLIANCE_NEUTRAL_CITY or leftFightData.battleType == BattleType.Turret) and leftFightData.unitData ~= nil and leftFightData.unitData:GetSpecialType() == SpecialUnitType.NONE then
      local LeftData = self:GetEffectDataByEffectId(35134, leftBattleEffect, leftFightData, leftUuid)
      oneData.leftNum = oneData.leftNum + LeftData.totalNum
      self:SetReasonShowList(35134, 163159, reasonList, LeftData, nil, 1, 1)
    end
    if (rightFightData.battleType == BattleType.Building and rightFightData.buildId ~= BuildingTypes.APS_BUILD_WORMHOLE_SUB or rightFightData.battleType == BattleType.City or rightFightData.battleType == BattleType.ALLIANCE_OCCUPIED_CITY or rightFightData.battleType == BattleType.ALLIANCE_NEUTRAL_CITY or rightFightData.battleType == BattleType.Turret) and rightFightData.unitData ~= nil and rightFightData.unitData:GetSpecialType() == SpecialUnitType.NONE then
      local RightData = self:GetEffectDataByEffectId(35134, rightBattleEffect, rightFightData, rightUuid)
      oneData.rightNum = oneData.rightNum + RightData.totalNum
      self:SetReasonShowList(35134, 163159, reasonList, nil, RightData, 1, 1)
    end
    if leftFightData.unitData ~= nil then
      local index = leftFightData.unitData:GetFormationIndex()
      local effectId = 0
      if rightFightData.battleType == BattleType.Building and rightFightData.buildId ~= BuildingTypes.APS_BUILD_WORMHOLE_SUB or rightFightData.battleType == BattleType.City or rightFightData.battleType == BattleType.ALLIANCE_OCCUPIED_CITY or rightFightData.battleType == BattleType.ALLIANCE_NEUTRAL_CITY or rightFightData.battleType == BattleType.Turret then
        if index == 1 then
          effectId = 40055
        elseif index == 2 then
          effectId = 40056
        elseif index == 3 then
          effectId = 40057
        elseif index == 4 then
          effectId = 40058
        end
        if 0 < effectId then
          local effectNum = leftBattleEffect:GetValue(effectId)
          local tempData = reasonList[GameEffectReason.Tank]
          if tempData ~= nil then
            oneData.leftNum = oneData.leftNum + effectNum
            tempData.leftData.totalNum = tempData.leftData.totalNum + effectNum
          end
        end
      end
      effectId = 0
      if index == 1 then
        effectId = 40040
      elseif index == 2 then
        effectId = 40041
      elseif index == 3 then
        effectId = 40042
      elseif index == 4 then
        effectId = 40043
      end
      if 0 < effectId then
        local effectNum = leftBattleEffect:GetValue(effectId)
        local tempData = reasonList[GameEffectReason.Tank]
        if tempData ~= nil then
          oneData.leftNum = oneData.leftNum + effectNum
          tempData.leftData.totalNum = tempData.leftData.totalNum + effectNum
        end
      end
    end
    if rightFightData.unitData ~= nil then
      local index = rightFightData.unitData:GetFormationIndex()
      local effectId = 0
      if leftFightData.battleType == BattleType.Building and leftFightData.buildId ~= BuildingTypes.APS_BUILD_WORMHOLE_SUB or leftFightData.battleType == BattleType.City or leftFightData.battleType == BattleType.ALLIANCE_OCCUPIED_CITY or leftFightData.battleType == BattleType.ALLIANCE_NEUTRAL_CITY or leftFightData.battleType == BattleType.Turret then
        if index == 1 then
          effectId = 40055
        elseif index == 2 then
          effectId = 40056
        elseif index == 3 then
          effectId = 40057
        elseif index == 4 then
          effectId = 40058
        end
        if 0 < effectId then
          local effectNum = rightBattleEffect:GetValue(effectId)
          local tempData = reasonList[GameEffectReason.Tank]
          if tempData ~= nil then
            oneData.rightNum = oneData.rightNum + effectNum
            tempData.rightData.totalNum = tempData.rightData.totalNum + effectNum
          end
        end
      end
      effectId = 0
      if index == 1 then
        effectId = 40040
      elseif index == 2 then
        effectId = 40041
      elseif index == 3 then
        effectId = 40042
      elseif index == 4 then
        effectId = 40043
      end
      if 0 < effectId then
        local effectNum = rightBattleEffect:GetValue(effectId)
        local tempData = reasonList[GameEffectReason.Tank]
        if tempData ~= nil then
          oneData.rightNum = oneData.rightNum + effectNum
          tempData.rightData.totalNum = tempData.rightData.totalNum + effectNum
        end
      end
    end
  end
  oneData.reasonList = reasonList
  return oneData
end

local function GetHealthAddData(self, leftFightData, rightFightData, leftBattleEffect, rightBattleEffect, leftUuid, rightUuid)
  local oneData = {}
  oneData.dialogId = "163140"
  oneData.leftNum = 0
  oneData.rightNum = 0
  oneData.showType = BattleSubTitleShowType.HealthAdd
  local reasonList = {}
  for k, v in pairs(needCheckList) do
    local tempData = {}
    tempData.leftData = {}
    tempData.leftData.totalNum = 0
    tempData.leftData.totalReason = {}
    tempData.rightData = {}
    tempData.rightData.totalNum = 0
    tempData.rightData.totalReason = {}
    reasonList[v] = tempData
  end
  local aLeftData = self:GetEffectDataByEffectId(35012, leftBattleEffect, leftFightData, leftUuid)
  local aRightData = self:GetEffectDataByEffectId(35012, rightBattleEffect, rightFightData, rightUuid)
  oneData.leftNum = oneData.leftNum + aLeftData.totalNum
  oneData.rightNum = oneData.rightNum + aRightData.totalNum
  self:SetReasonShowList(35012, 163160, reasonList, aLeftData, aRightData, 1, 1)
  local bLeftPercent = 0
  local bRightPercent = 0
  if leftFightData ~= nil and leftFightData.unitData ~= nil then
    bLeftPercent = leftFightData.unitData:GetSoldierPercentByType(ArmType.Tank)
  end
  if rightFightData ~= nil and rightFightData.unitData ~= nil then
    bRightPercent = rightFightData.unitData:GetSoldierPercentByType(ArmType.Tank)
  end
  local bLeftData = self:GetEffectDataByEffectId(35013, leftBattleEffect, leftFightData, leftUuid)
  local bRightData = self:GetEffectDataByEffectId(35013, rightBattleEffect, rightFightData, rightUuid)
  oneData.leftNum = oneData.leftNum + bLeftData.totalNum * bLeftPercent
  oneData.rightNum = oneData.rightNum + bRightData.totalNum * bRightPercent
  self:SetReasonShowList(35013, 220058, reasonList, bLeftData, bRightData, bLeftPercent, bRightPercent)
  local cLeftPercent = 0
  local cRightPercent = 0
  if leftFightData ~= nil and leftFightData.unitData ~= nil then
    cLeftPercent = leftFightData.unitData:GetSoldierPercentByType(ArmType.Robot)
  end
  if rightFightData ~= nil and rightFightData.unitData ~= nil then
    cRightPercent = rightFightData.unitData:GetSoldierPercentByType(ArmType.Robot)
  end
  local cLeftData = self:GetEffectDataByEffectId(35014, leftBattleEffect, leftFightData, leftUuid)
  local cRightData = self:GetEffectDataByEffectId(35014, rightBattleEffect, rightFightData, rightUuid)
  oneData.leftNum = oneData.leftNum + cLeftData.totalNum * cLeftPercent
  oneData.rightNum = oneData.rightNum + cRightData.totalNum * cRightPercent
  self:SetReasonShowList(35014, 220059, reasonList, cLeftData, cRightData, cLeftPercent, cRightPercent)
  local dLeftPercent = 0
  local dRightPercent = 0
  if leftFightData ~= nil and leftFightData.unitData ~= nil then
    dLeftPercent = leftFightData.unitData:GetSoldierPercentByType(ArmType.Plane)
  end
  if rightFightData ~= nil and rightFightData.unitData ~= nil then
    dRightPercent = rightFightData.unitData:GetSoldierPercentByType(ArmType.Plane)
  end
  local dLeftData = self:GetEffectDataByEffectId(35015, leftBattleEffect, leftFightData, leftUuid)
  local dRightData = self:GetEffectDataByEffectId(35015, rightBattleEffect, rightFightData, rightUuid)
  oneData.leftNum = oneData.leftNum + dLeftData.totalNum * dLeftPercent
  oneData.rightNum = oneData.rightNum + dRightData.totalNum * dRightPercent
  self:SetReasonShowList(35015, 220060, reasonList, dLeftData, dRightData, dLeftPercent, dRightPercent)
  oneData.reasonList = reasonList
  return oneData
end

local function GetMarchLimitAddData(self, leftFightData, rightFightData, leftBattleEffect, rightBattleEffect, leftUuid, rightUuid)
  local oneData = {}
  oneData.dialogId = "100508"
  oneData.leftNum = 0
  oneData.rightNum = 0
  oneData.showType = BattleSubTitleShowType.MarchLimitAdd
  local reasonList = {}
  for k, v in pairs(needCheckList) do
    local tempData = {}
    tempData.leftData = {}
    tempData.leftData.totalNum = 0
    tempData.leftData.totalReason = {}
    tempData.rightData = {}
    tempData.rightData.totalNum = 0
    tempData.rightData.totalReason = {}
    reasonList[v] = tempData
  end
  local aLeftNum = leftBattleEffect:GetValue(40001)
  local aRightNum = rightBattleEffect:GetValue(40001)
  oneData.leftNum = oneData.leftNum + aLeftNum
  oneData.rightNum = oneData.rightNum + aRightNum
  local tData = reasonList[GameEffectReason.Science]
  if tData ~= nil then
    tData.leftData.totalNum = tData.leftData.totalNum + aLeftNum
    tData.rightData.totalNum = tData.rightData.totalNum + aRightNum
  end
  if leftFightData ~= nil and rightFightData ~= nil then
    if leftFightData.unitData ~= nil then
      local index = leftFightData.unitData:GetFormationIndex()
      local effectId = 0
      if index == 1 then
        effectId = 40044
      elseif index == 2 then
        effectId = 40045
      elseif index == 3 then
        effectId = 40046
      elseif index == 4 then
        effectId = 40047
      end
      if 0 < effectId then
        local effectNum = leftBattleEffect:GetValue(effectId)
        local tempData = reasonList[GameEffectReason.Tank]
        if tempData ~= nil then
          oneData.leftNum = oneData.leftNum + effectNum
          tempData.leftData.totalNum = tempData.leftData.totalNum + effectNum
        end
      end
      local heroes = leftFightData.unitData:GetPlayerHeroes()
      local limitNumInLevel = 0
      local limitNumInRarity = 0
      for k, v in pairs(heroes) do
        local level = v.heroLevel
        local heroId = v.heroId
        local rankLv = v.rankLv or 0
        local stage = v.stage or 0
        local curMilitaryRankId = HeroUtils.GetRankIdByLvAndStage(heroId, rankLv, stage)
        local rarity = GetTableData(HeroUtils.GetHeroXmlName(), heroId, "rarity")
        limitNumInLevel = limitNumInLevel + GetTableData(TableName.NewHeroesLevelUp, level, "army_num" .. rarity)
        local rankTroop = string.split(GetTableData(TableName.HeroMilitaryRankLv, curMilitaryRankId, "troop"), "|")[rarity]
        if rankTroop ~= nil then
          limitNumInRarity = limitNumInRarity + toInt(rankTroop)
        end
        local config = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), heroId)
        local starAddTroop = config.hero_star_troops[math.min(#config.hero_star_troops, curMilitaryRankId)]
        if starAddTroop ~= nil then
          limitNumInRarity = limitNumInRarity + toInt(starAddTroop)
        end
      end
      local tempData = reasonList[GameEffectReason.Hero]
      if tempData ~= nil then
        oneData.leftNum = oneData.leftNum + limitNumInLevel + limitNumInRarity
        tempData.leftData.totalNum = tempData.leftData.totalNum + limitNumInLevel + limitNumInRarity
        local levelEffectOneData = {}
        levelEffectOneData.effectId = effectId
        levelEffectOneData.dialog = "163153"
        levelEffectOneData.addNum = limitNumInLevel
        table.insert(tempData.leftData.totalReason, levelEffectOneData)
        local rankEffectOneData = {}
        rankEffectOneData.effectId = effectId
        rankEffectOneData.dialog = "163154"
        rankEffectOneData.addNum = limitNumInRarity
        table.insert(tempData.leftData.totalReason, rankEffectOneData)
      end
    end
    if rightFightData.unitData ~= nil then
      local index = rightFightData.unitData:GetFormationIndex()
      local effectId = 0
      if index == 1 then
        effectId = 40044
      elseif index == 2 then
        effectId = 40045
      elseif index == 3 then
        effectId = 40046
      elseif index == 4 then
        effectId = 40047
      end
      if 0 < effectId then
        local effectNum = rightBattleEffect:GetValue(effectId)
        local tempData = reasonList[GameEffectReason.Tank]
        if tempData ~= nil then
          oneData.rightNum = oneData.rightNum + effectNum
          tempData.rightData.totalNum = tempData.rightData.totalNum + effectNum
        end
      end
      local heroes = rightFightData.unitData:GetPlayerHeroes()
      local limitNumInLevel = 0
      local limitNumInRarity = 0
      for k, v in pairs(heroes) do
        local level = v.heroLevel
        local heroId = v.heroId
        local rankLv = v.rankLv or 0
        local stage = v.stage or 0
        local curMilitaryRankId = HeroUtils.GetRankIdByLvAndStage(heroId, rankLv, stage)
        local rarity = GetTableData(HeroUtils.GetHeroXmlName(), heroId, "rarity")
        limitNumInLevel = limitNumInLevel + GetTableData(TableName.NewHeroesLevelUp, level, "army_num" .. rarity)
        local rankTroop = string.split(GetTableData(TableName.HeroMilitaryRankLv, curMilitaryRankId, "troop"), "|")[rarity]
        if rankTroop ~= nil then
          limitNumInRarity = limitNumInRarity + toInt(rankTroop)
        end
        local config = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), heroId)
        local starAddTroop = config.hero_star_troops[math.min(#config.hero_star_troops, curMilitaryRankId)]
        if starAddTroop ~= nil then
          limitNumInRarity = limitNumInRarity + toInt(starAddTroop)
        end
      end
      local tempData = reasonList[GameEffectReason.Hero]
      if tempData ~= nil then
        oneData.rightNum = oneData.rightNum + limitNumInLevel + limitNumInRarity
        tempData.rightData.totalNum = tempData.rightData.totalNum + limitNumInLevel + limitNumInRarity
        local levelEffectOneData = {}
        levelEffectOneData.effectId = effectId
        levelEffectOneData.dialog = "163153"
        levelEffectOneData.addNum = limitNumInLevel
        table.insert(tempData.rightData.totalReason, levelEffectOneData)
        local rankEffectOneData = {}
        rankEffectOneData.effectId = effectId
        rankEffectOneData.dialog = "163154"
        rankEffectOneData.addNum = limitNumInRarity
        table.insert(tempData.rightData.totalReason, rankEffectOneData)
      end
    end
  end
  oneData.reasonList = reasonList
  return oneData
end

local function GetSkillHurtAddData(self, leftFightData, rightFightData, leftBattleEffect, rightBattleEffect, leftUuid, rightUuid)
  local oneData = {}
  oneData.dialogId = "163143"
  oneData.leftNum = 0
  oneData.rightNum = 0
  oneData.showType = BattleSubTitleShowType.SkillHurtAdd
  local reasonList = {}
  for k, v in pairs(needCheckList) do
    local tempData = {}
    tempData.leftData = {}
    tempData.leftData.totalNum = 0
    tempData.leftData.totalReason = {}
    tempData.rightData = {}
    tempData.rightData.totalNum = 0
    tempData.rightData.totalReason = {}
    reasonList[v] = tempData
  end
  local effectNumla = leftBattleEffect:GetValue(35064)
  local tempDatala = reasonList[GameEffectReason.Hero]
  if tempDatala ~= nil then
    oneData.leftNum = oneData.leftNum + effectNumla
    tempDatala.leftData.totalNum = tempDatala.leftData.totalNum + effectNumla
  end
  local effectNumlb = leftBattleEffect:GetValue(35104)
  local tempDatalb = reasonList[GameEffectReason.Hero]
  if tempDatalb ~= nil then
    oneData.leftNum = oneData.leftNum + effectNumlb
    tempDatalb.leftData.totalNum = tempDatalb.leftData.totalNum + effectNumlb
  end
  local effectNumra = rightBattleEffect:GetValue(35064)
  local tempDatara = reasonList[GameEffectReason.Hero]
  if tempDatara ~= nil then
    oneData.rightNum = oneData.rightNum + effectNumra
    tempDatara.rightData.totalNum = tempDatara.rightData.totalNum + effectNumra
  end
  local effectNumrb = rightBattleEffect:GetValue(35104)
  local tempDatarb = reasonList[GameEffectReason.Hero]
  if tempDatarb ~= nil then
    oneData.rightNum = oneData.rightNum + effectNumrb
    tempDatarb.rightData.totalNum = tempDatarb.rightData.totalNum + effectNumrb
  end
  if leftFightData ~= nil and rightFightData ~= nil then
    if leftFightData.battleType == BattleType.RallyFormation then
      local effectNumlc = leftBattleEffect:GetValue(35084)
      local tempDatalc = reasonList[GameEffectReason.Hero]
      if tempDatalc ~= nil then
        oneData.leftNum = oneData.leftNum + effectNumlc
        tempDatalc.leftData.totalNum = tempDatalc.leftData.totalNum + effectNumlc
      end
    end
    if rightFightData.battleType == BattleType.RallyFormation then
      local effectNumrc = rightBattleEffect:GetValue(35084)
      local tempDatarc = reasonList[GameEffectReason.Hero]
      if tempDatarc ~= nil then
        oneData.rightNum = oneData.rightNum + effectNumrc
        tempDatarc.rightData.totalNum = tempDatarc.rightData.totalNum + effectNumrc
      end
    end
  end
  oneData.reasonList = reasonList
  return oneData
end

local function GetNormalHurtAddData(self, leftFightData, rightFightData, leftBattleEffect, rightBattleEffect, leftUuid, rightUuid)
  local oneData = {}
  oneData.dialogId = "163144"
  oneData.leftNum = 0
  oneData.rightNum = 0
  oneData.showType = BattleSubTitleShowType.NormalHurtAdd
  local reasonList = {}
  for k, v in pairs(needCheckList) do
    local tempData = {}
    tempData.leftData = {}
    tempData.leftData.totalNum = 0
    tempData.leftData.totalReason = {}
    tempData.rightData = {}
    tempData.rightData.totalNum = 0
    tempData.rightData.totalReason = {}
    reasonList[v] = tempData
  end
  local effectNumla = leftBattleEffect:GetValue(35064)
  local tempDatala = reasonList[GameEffectReason.Hero]
  if tempDatala ~= nil then
    oneData.leftNum = oneData.leftNum + effectNumla
    tempDatala.leftData.totalNum = tempDatala.leftData.totalNum + effectNumla
  end
  local effectNumlb = leftBattleEffect:GetValue(35103)
  local tempDatalb = reasonList[GameEffectReason.Hero]
  if tempDatalb ~= nil then
    oneData.leftNum = oneData.leftNum + effectNumlb
    tempDatalb.leftData.totalNum = tempDatalb.leftData.totalNum + effectNumlb
  end
  local effectNumra = rightBattleEffect:GetValue(35064)
  local tempDatara = reasonList[GameEffectReason.Hero]
  if tempDatara ~= nil then
    oneData.rightNum = oneData.rightNum + effectNumra
    tempDatara.rightData.totalNum = tempDatara.rightData.totalNum + effectNumra
  end
  local effectNumrb = rightBattleEffect:GetValue(35103)
  local tempDatarb = reasonList[GameEffectReason.Hero]
  if tempDatarb ~= nil then
    oneData.rightNum = oneData.rightNum + effectNumrb
    tempDatarb.rightData.totalNum = tempDatarb.rightData.totalNum + effectNumrb
  end
  if leftFightData ~= nil and rightFightData ~= nil then
    if leftFightData.battleType == BattleType.RallyFormation then
      local effectNumlc = leftBattleEffect:GetValue(35084)
      local tempDatalc = reasonList[GameEffectReason.Hero]
      if tempDatalc ~= nil then
        oneData.leftNum = oneData.leftNum + effectNumlc
        tempDatalc.leftData.totalNum = tempDatalc.leftData.totalNum + effectNumlc
      end
    end
    if rightFightData.battleType == BattleType.RallyFormation then
      local effectNumrc = rightBattleEffect:GetValue(35084)
      local tempDatarc = reasonList[GameEffectReason.Hero]
      if tempDatarc ~= nil then
        oneData.rightNum = oneData.rightNum + effectNumrc
        tempDatarc.rightData.totalNum = tempDatarc.rightData.totalNum + effectNumrc
      end
    end
  end
  oneData.reasonList = reasonList
  return oneData
end

local function GetBackHurtAddData(self, leftFightData, rightFightData, leftBattleEffect, rightBattleEffect, leftUuid, rightUuid)
  local oneData = {}
  oneData.dialogId = "163145"
  oneData.leftNum = 0
  oneData.rightNum = 0
  oneData.showType = BattleSubTitleShowType.BackHurtAdd
  local reasonList = {}
  for k, v in pairs(needCheckList) do
    local tempData = {}
    tempData.leftData = {}
    tempData.leftData.totalNum = 0
    tempData.leftData.totalReason = {}
    tempData.rightData = {}
    tempData.rightData.totalNum = 0
    tempData.rightData.totalReason = {}
    reasonList[v] = tempData
  end
  local effectNumla = leftBattleEffect:GetValue(35064)
  local tempDatala = reasonList[GameEffectReason.Hero]
  if tempDatala ~= nil then
    oneData.leftNum = oneData.leftNum + effectNumla
    tempDatala.leftData.totalNum = tempDatala.leftData.totalNum + effectNumla
  end
  local effectNumlb = leftBattleEffect:GetValue(35105)
  local tempDatalb = reasonList[GameEffectReason.Hero]
  if tempDatalb ~= nil then
    oneData.leftNum = oneData.leftNum + effectNumlb
    tempDatalb.leftData.totalNum = tempDatalb.leftData.totalNum + effectNumlb
  end
  local effectNumra = rightBattleEffect:GetValue(35064)
  local tempDatara = reasonList[GameEffectReason.Hero]
  if tempDatara ~= nil then
    oneData.rightNum = oneData.rightNum + effectNumra
    tempDatara.rightData.totalNum = tempDatara.rightData.totalNum + effectNumra
  end
  local effectNumrb = rightBattleEffect:GetValue(35105)
  local tempDatarb = reasonList[GameEffectReason.Hero]
  if tempDatarb ~= nil then
    oneData.rightNum = oneData.rightNum + effectNumrb
    tempDatarb.rightData.totalNum = tempDatarb.rightData.totalNum + effectNumrb
  end
  if leftFightData ~= nil and rightFightData ~= nil then
    if leftFightData.battleType == BattleType.RallyFormation then
      local effectNumlc = leftBattleEffect:GetValue(35084)
      local tempDatalc = reasonList[GameEffectReason.Hero]
      if tempDatalc ~= nil then
        oneData.leftNum = oneData.leftNum + effectNumlc
        tempDatalc.leftData.totalNum = tempDatalc.leftData.totalNum + effectNumlc
      end
    end
    if rightFightData.battleType == BattleType.RallyFormation then
      local effectNumrc = rightBattleEffect:GetValue(35084)
      local tempDatarc = reasonList[GameEffectReason.Hero]
      if tempDatarc ~= nil then
        oneData.rightNum = oneData.rightNum + effectNumrc
        tempDatarc.rightData.totalNum = tempDatarc.rightData.totalNum + effectNumrc
      end
    end
  end
  oneData.reasonList = reasonList
  return oneData
end

local function GetSkillHurtDecData(self, leftFightData, rightFightData, leftBattleEffect, rightBattleEffect, leftUuid, rightUuid)
  local oneData = {}
  oneData.dialogId = "163146"
  oneData.leftNum = 0
  oneData.rightNum = 0
  oneData.showType = BattleSubTitleShowType.SkillHurtDec
  local reasonList = {}
  for k, v in pairs(needCheckList) do
    local tempData = {}
    tempData.leftData = {}
    tempData.leftData.totalNum = 0
    tempData.leftData.totalReason = {}
    tempData.rightData = {}
    tempData.rightData.totalNum = 0
    tempData.rightData.totalReason = {}
    reasonList[v] = tempData
  end
  local effectNumla = leftBattleEffect:GetValue(35065)
  local tempDatala = reasonList[GameEffectReason.Hero]
  if tempDatala ~= nil then
    oneData.leftNum = oneData.leftNum + effectNumla
    tempDatala.leftData.totalNum = tempDatala.leftData.totalNum + effectNumla
  end
  local effectNumlb = leftBattleEffect:GetValue(35100)
  local tempDatalb = reasonList[GameEffectReason.Hero]
  if tempDatalb ~= nil then
    oneData.leftNum = oneData.leftNum + effectNumlb
    tempDatalb.leftData.totalNum = tempDatalb.leftData.totalNum + effectNumlb
  end
  local effectNumra = rightBattleEffect:GetValue(35065)
  local tempDatara = reasonList[GameEffectReason.Hero]
  if tempDatara ~= nil then
    oneData.rightNum = oneData.rightNum + effectNumra
    tempDatara.rightData.totalNum = tempDatara.rightData.totalNum + effectNumra
  end
  local effectNumrb = rightBattleEffect:GetValue(35100)
  local tempDatarb = reasonList[GameEffectReason.Hero]
  if tempDatarb ~= nil then
    oneData.rightNum = oneData.rightNum + effectNumrb
    tempDatarb.rightData.totalNum = tempDatarb.rightData.totalNum + effectNumrb
  end
  if leftFightData ~= nil and rightFightData ~= nil then
    if leftFightData.battleType == BattleType.RallyFormation then
      local effectNumlc = leftBattleEffect:GetValue(35090)
      local tempDatalc = reasonList[GameEffectReason.Hero]
      if tempDatalc ~= nil then
        oneData.leftNum = oneData.leftNum + effectNumlc
        tempDatalc.leftData.totalNum = tempDatalc.leftData.totalNum + effectNumlc
      end
    end
    if rightFightData.battleType == BattleType.RallyFormation then
      local effectNumrc = rightBattleEffect:GetValue(35090)
      local tempDatarc = reasonList[GameEffectReason.Hero]
      if tempDatarc ~= nil then
        oneData.rightNum = oneData.rightNum + effectNumrc
        tempDatarc.rightData.totalNum = tempDatarc.rightData.totalNum + effectNumrc
      end
    end
  end
  oneData.reasonList = reasonList
  return oneData
end

local function GetNormalHurtDecData(self, leftFightData, rightFightData, leftBattleEffect, rightBattleEffect, leftUuid, rightUuid)
  local oneData = {}
  oneData.dialogId = "163147"
  oneData.leftNum = 0
  oneData.rightNum = 0
  oneData.showType = BattleSubTitleShowType.NormalHurtDec
  local reasonList = {}
  for k, v in pairs(needCheckList) do
    local tempData = {}
    tempData.leftData = {}
    tempData.leftData.totalNum = 0
    tempData.leftData.totalReason = {}
    tempData.rightData = {}
    tempData.rightData.totalNum = 0
    tempData.rightData.totalReason = {}
    reasonList[v] = tempData
  end
  local effectNumla = leftBattleEffect:GetValue(35065)
  local tempDatala = reasonList[GameEffectReason.Hero]
  if tempDatala ~= nil then
    oneData.leftNum = oneData.leftNum + effectNumla
    tempDatala.leftData.totalNum = tempDatala.leftData.totalNum + effectNumla
  end
  local effectNumlb = leftBattleEffect:GetValue(35099)
  local tempDatalb = reasonList[GameEffectReason.Hero]
  if tempDatalb ~= nil then
    oneData.leftNum = oneData.leftNum + effectNumlb
    tempDatalb.leftData.totalNum = tempDatalb.leftData.totalNum + effectNumlb
  end
  local effectNumra = rightBattleEffect:GetValue(35065)
  local tempDatara = reasonList[GameEffectReason.Hero]
  if tempDatara ~= nil then
    oneData.rightNum = oneData.rightNum + effectNumra
    tempDatara.rightData.totalNum = tempDatara.rightData.totalNum + effectNumra
  end
  local effectNumrb = rightBattleEffect:GetValue(35099)
  local tempDatarb = reasonList[GameEffectReason.Hero]
  if tempDatarb ~= nil then
    oneData.rightNum = oneData.rightNum + effectNumrb
    tempDatarb.rightData.totalNum = tempDatarb.rightData.totalNum + effectNumrb
  end
  if leftFightData ~= nil and rightFightData ~= nil then
    if leftFightData.battleType == BattleType.RallyFormation then
      local effectNumlc = leftBattleEffect:GetValue(35090)
      local tempDatalc = reasonList[GameEffectReason.Hero]
      if tempDatalc ~= nil then
        oneData.leftNum = oneData.leftNum + effectNumlc
        tempDatalc.leftData.totalNum = tempDatalc.leftData.totalNum + effectNumlc
      end
    end
    if rightFightData.battleType == BattleType.RallyFormation then
      local effectNumrc = rightBattleEffect:GetValue(35090)
      local tempDatarc = reasonList[GameEffectReason.Hero]
      if tempDatarc ~= nil then
        oneData.rightNum = oneData.rightNum + effectNumrc
        tempDatarc.rightData.totalNum = tempDatarc.rightData.totalNum + effectNumrc
      end
    end
  end
  oneData.reasonList = reasonList
  return oneData
end

local function GetBackHurtDecData(self, leftFightData, rightFightData, leftBattleEffect, rightBattleEffect, leftUuid, rightUuid)
  local oneData = {}
  oneData.dialogId = "163148"
  oneData.leftNum = 0
  oneData.rightNum = 0
  oneData.showType = BattleSubTitleShowType.BackHurtDec
  local reasonList = {}
  for k, v in pairs(needCheckList) do
    local tempData = {}
    tempData.leftData = {}
    tempData.leftData.totalNum = 0
    tempData.leftData.totalReason = {}
    tempData.rightData = {}
    tempData.rightData.totalNum = 0
    tempData.rightData.totalReason = {}
    reasonList[v] = tempData
  end
  local effectNumla = leftBattleEffect:GetValue(35065)
  local tempDatala = reasonList[GameEffectReason.Hero]
  if tempDatala ~= nil then
    oneData.leftNum = oneData.leftNum + effectNumla
    tempDatala.leftData.totalNum = tempDatala.leftData.totalNum + effectNumla
  end
  local effectNumlb = leftBattleEffect:GetValue(35101)
  local tempDatalb = reasonList[GameEffectReason.Hero]
  if tempDatalb ~= nil then
    oneData.leftNum = oneData.leftNum + effectNumlb
    tempDatalb.leftData.totalNum = tempDatalb.leftData.totalNum + effectNumlb
  end
  local effectNumra = rightBattleEffect:GetValue(35065)
  local tempDatara = reasonList[GameEffectReason.Hero]
  if tempDatara ~= nil then
    oneData.rightNum = oneData.rightNum + effectNumra
    tempDatara.rightData.totalNum = tempDatara.rightData.totalNum + effectNumra
  end
  local effectNumrb = rightBattleEffect:GetValue(35101)
  local tempDatarb = reasonList[GameEffectReason.Hero]
  if tempDatarb ~= nil then
    oneData.rightNum = oneData.rightNum + effectNumrb
    tempDatarb.rightData.totalNum = tempDatarb.rightData.totalNum + effectNumrb
  end
  if leftFightData ~= nil and rightFightData ~= nil then
    if leftFightData.battleType == BattleType.RallyFormation then
      local effectNumlc = leftBattleEffect:GetValue(35090)
      local tempDatalc = reasonList[GameEffectReason.Hero]
      if tempDatalc ~= nil then
        oneData.leftNum = oneData.leftNum + effectNumlc
        tempDatalc.leftData.totalNum = tempDatalc.leftData.totalNum + effectNumlc
      end
    end
    if rightFightData.battleType == BattleType.RallyFormation then
      local effectNumrc = rightBattleEffect:GetValue(35090)
      local tempDatarc = reasonList[GameEffectReason.Hero]
      if tempDatarc ~= nil then
        oneData.rightNum = oneData.rightNum + effectNumrc
        tempDatarc.rightData.totalNum = tempDatarc.rightData.totalNum + effectNumrc
      end
    end
  end
  oneData.reasonList = reasonList
  return oneData
end

local function GetCurveData(self, leftFightData, rightFightData, leftBattleEffect, rightBattleEffect, leftUuid, rightUuid)
  local oneData = {}
  oneData.dialogId = "163104"
  oneData.leftNum = 0
  oneData.rightNum = 0
  oneData.showType = BattleSubTitleShowType.Curve
  local reasonList = {}
  for k, v in pairs(needCheckList) do
    local tempData = {}
    tempData.leftData = {}
    tempData.leftData.totalNum = 0
    tempData.leftData.totalReason = {}
    tempData.rightData = {}
    tempData.rightData.totalNum = 0
    tempData.rightData.totalReason = {}
    reasonList[v] = tempData
  end
  local effectNumla = leftBattleEffect:GetValue(35114)
  local tempDatala = reasonList[GameEffectReason.Hero]
  if tempDatala ~= nil then
    oneData.leftNum = oneData.leftNum + effectNumla
    tempDatala.leftData.totalNum = tempDatala.leftData.totalNum + effectNumla
  end
  local effectNumra = rightBattleEffect:GetValue(35114)
  local tempDatara = reasonList[GameEffectReason.Hero]
  if tempDatara ~= nil then
    oneData.rightNum = oneData.rightNum + effectNumra
    tempDatara.rightData.totalNum = tempDatara.rightData.totalNum + effectNumra
  end
  oneData.reasonList = reasonList
  return oneData
end

local function SetReasonShowList(self, effectId, dialog, reasonList, LeftData, RightData, leftPercent, rightPercent)
  if LeftData ~= nil then
    for k, v in pairs(LeftData.dataReason) do
      local tempData = reasonList[k]
      if tempData ~= nil then
        tempData.leftData.totalNum = tempData.leftData.totalNum + v * leftPercent
        local effectOneData = {}
        effectOneData.effectId = effectId
        effectOneData.dialog = dialog
        effectOneData.addNum = v * leftPercent
        table.insert(tempData.leftData.totalReason, effectOneData)
      end
    end
  end
  if RightData ~= nil then
    if RightData.battleType == BattleType.Monster or RightData.battleType == BattleType.ACT_BOSS or RightData.battleType == BattleType.Boss or RightData.battleType == BattleType.Explore or RightData.battleType == BattleType.PUZZLE_BOSS or RightData.battleType == BattleType.CHALLENGE_BOSS then
      local tempData = reasonList[GameEffectReason.Hero]
      if tempData ~= nil then
        tempData.rightData.totalNum = tempData.rightData.totalNum + RightData.totalNum * rightPercent
        local effectOneData = {}
        effectOneData.effectId = effectId
        effectOneData.dialog = dialog
        effectOneData.addNum = RightData.totalNum * rightPercent
        table.insert(tempData.rightData.totalReason, effectOneData)
      end
    else
      for k, v in pairs(RightData.dataReason) do
        local tempData = reasonList[k]
        if tempData ~= nil then
          tempData.rightData.totalNum = tempData.rightData.totalNum + v * rightPercent
          local effectOneData = {}
          effectOneData.effectId = effectId
          effectOneData.dialog = dialog
          effectOneData.addNum = v * rightPercent
          table.insert(tempData.rightData.totalReason, effectOneData)
        end
      end
    end
  end
end

local function GetEffectDataByEffectId(self, effectId, battleEffect, FightData, uuid)
  local oneData = {}
  oneData.totalNum = battleEffect:GetValue(effectId)
  oneData.battleType = FightData.battleType
  local tempNum = battleEffect:GetValue(effectId)
  local dataReason = {}
  local reason = battleEffect:GetReasonList(effectId)
  for k, v in pairs(reason) do
    local num = v
    if 0 < num then
      dataReason[k] = num
      tempNum = tempNum - num
    end
  end
  if 0 < tempNum and FightData ~= nil and FightData.unitData ~= nil then
    local buffList = FightData.unitData:GetBuffIdListByEffectId(effectId, uuid)
    for k, v in pairs(buffList) do
      local type2 = GetTableData(TableName.StatusTab, k, "type2")
      if type2 == 22 or type2 == 21 then
        dataReason[GameEffectReason.Status] = v
      end
    end
  end
  oneData.dataReason = dataReason
  return oneData
end

local function GetHeroRestraintValue(self, leftFightData, rightFightData, leftBattleEffect, rightBattleEffect, leftUuid, rightUuid)
  local campRestraintLeft = 0
  local campRestraintRight = 0
  if leftFightData ~= nil and rightFightData ~= nil and leftFightData.unitData ~= nil and rightFightData.unitData ~= nil then
    local leftHeroes = leftFightData.unitData:GetPlayerHeroes()
    local rightHeroes = rightFightData.unitData:GetPlayerHeroes()
    local leftHeroKey = table.keys(leftHeroes)
    local rightHeroKey = table.keys(rightHeroes)
    local leftEffectList = {}
    local rightEffectList = {}
    table.walk(CheckHeroRestraintEffectList, function(k, v)
      local leftValue = 0
      local rightValue = 0
      if leftBattleEffect ~= nil then
        leftValue = leftBattleEffect:GetValue(v)
      end
      if rightBattleEffect ~= nil then
        rightValue = rightBattleEffect:GetValue(v)
      end
      if 0 < leftValue then
        leftEffectList[v] = leftValue
      end
      if 0 < rightValue then
        rightEffectList[v] = rightValue
      end
    end)
    local RestraintData = MarchUtil.GetBaseHeroRestraintValue(leftHeroKey, rightHeroKey, leftEffectList, rightEffectList)
    if RestraintData ~= nil then
      if RestraintData.isLeft then
        campRestraintLeft = RestraintData.value
        campRestraintRight = 0
      else
        campRestraintLeft = 0
        campRestraintRight = RestraintData.value
      end
    end
  end
  return campRestraintLeft, campRestraintRight
end

local function GetHeroCampAdd(self, leftFightData, rightFightData, leftBattleEffect, rightBattleEffect, leftUuid, rightUuid)
  local leftCampAdd = 0
  local rightCampAdd = 0
  if leftFightData ~= nil and leftFightData.unitData ~= nil then
    local leftHeroes = leftFightData.unitData:GetPlayerHeroes()
    local leftHeroKey = table.keys(leftHeroes)
    local leftCampData = MarchUtil.GetCampParamByHeroIdList(leftHeroKey)
    if 0 < #leftCampData then
      for i = 1, #leftCampData do
        leftCampAdd = leftCampAdd + leftCampData[i].addEffectNum
      end
    end
  end
  if rightFightData ~= nil and rightFightData.unitData ~= nil then
    local rightHeroes = rightFightData.unitData:GetPlayerHeroes()
    local rightHeroKey = table.keys(rightHeroes)
    local rightCampData = MarchUtil.GetCampParamByHeroIdList(rightHeroKey)
    if 0 < #rightCampData then
      for i = 1, #rightCampData do
        rightCampAdd = rightCampAdd + rightCampData[i].addEffectNum
      end
    end
  end
  return leftCampAdd, rightCampAdd
end

local function GetHeroAttackData(self, leftFightData, rightFightData, leftBattleEffect, rightBattleEffect, leftUuid, rightUuid)
  local oneData = {}
  oneData.dialogId = "220206"
  oneData.leftNum = 0
  oneData.rightNum = 0
  oneData.showType = BattleSubTitleShowType.HeroAttack
  local reasonList = {}
  for k, v in pairs(needCheckList) do
    local tempData = {}
    tempData.leftData = {}
    tempData.leftData.totalNum = 0
    tempData.leftData.totalReason = {}
    tempData.rightData = {}
    tempData.rightData.totalNum = 0
    tempData.rightData.totalReason = {}
    reasonList[v] = tempData
  end
  if leftFightData ~= nil and rightFightData ~= nil then
    if leftFightData.unitData ~= nil then
      local heroes = leftFightData.unitData:GetPlayerHeroes()
      local atkInLevel = 0
      local atkInQuality = 0
      local atkInRarity = 0
      local atkInCamp = 0
      for k, v in pairs(heroes) do
        local level = v.heroLevel
        local heroId = v.heroId
        local rankLv = v.rankLv or 0
        local stage = v.stage or 0
        local quality = v.heroQuality or 0
        local beyondTimes = HeroUtils.GetBeyondTimesByLevel(level)
        local config = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), heroId)
        local curMilitaryRankId = HeroUtils.GetRankIdByLvAndStage(heroId, rankLv, stage)
        local starAddAttack = config.hero_star_attack[math.min(#config.hero_star_attack, quality)]
        local rarityAddAtt = GetTableData(TableName.NewHeroesLevelUp, level, "lv_attr_atk" .. config.rarity)
        local levelAttack = config.base_attack + config.attr_attack * rarityAddAtt + config.special_attr_attack * beyondTimes
        local rankAtk = 0
        local strArr = string.split(GetTableData(TableName.HeroMilitaryRankLv, curMilitaryRankId, "atk"), "|")
        if 0 < #strArr then
          rankAtk = tonumber(strArr[config.rarity])
        end
        atkInLevel = atkInLevel + levelAttack
        atkInQuality = atkInQuality + starAddAttack
        if rankAtk ~= nil then
          atkInRarity = atkInRarity + rankAtk
        end
        local camp = config.camp
        local effectId = HeroUtils.GetExtraAtkByCamp(camp)
        if leftBattleEffect ~= nil then
          local addNum = leftBattleEffect:GetValue(effectId)
          atkInCamp = atkInCamp + addNum
        end
      end
      oneData.leftNum = oneData.leftNum + atkInLevel + atkInQuality + atkInRarity + atkInCamp
      local tempData = reasonList[GameEffectReason.Hero]
      if tempData ~= nil then
        tempData.leftData.totalNum = tempData.leftData.totalNum + atkInLevel + atkInQuality + atkInRarity + atkInCamp
        local levelEffectOneData = {}
        levelEffectOneData.effectId = 0
        levelEffectOneData.dialog = "163153"
        levelEffectOneData.addNum = atkInLevel
        table.insert(tempData.leftData.totalReason, levelEffectOneData)
        local qualityEffectOneData = {}
        qualityEffectOneData.effectId = 0
        qualityEffectOneData.dialog = "129211"
        qualityEffectOneData.addNum = atkInQuality
        table.insert(tempData.leftData.totalReason, qualityEffectOneData)
        local rankEffectOneData = {}
        rankEffectOneData.effectId = 0
        rankEffectOneData.dialog = "163154"
        rankEffectOneData.addNum = atkInRarity
        table.insert(tempData.leftData.totalReason, rankEffectOneData)
        if 0 < atkInCamp then
          local campEffectOneData = {}
          campEffectOneData.effectId = 0
          campEffectOneData.dialog = "133000"
          campEffectOneData.addNum = atkInCamp
          table.insert(tempData.leftData.totalReason, campEffectOneData)
        end
      end
    end
    if rightFightData.unitData ~= nil then
      local heroes = rightFightData.unitData:GetPlayerHeroes()
      local atkInLevel = 0
      local atkInQuality = 0
      local atkInRarity = 0
      local atkInCamp = 0
      for k, v in pairs(heroes) do
        local level = v.heroLevel
        local heroId = v.heroId
        local rankLv = v.rankLv or 0
        local stage = v.stage or 0
        local quality = v.heroQuality or 0
        local beyondTimes = HeroUtils.GetBeyondTimesByLevel(level)
        local config = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), heroId)
        local curMilitaryRankId = HeroUtils.GetRankIdByLvAndStage(heroId, rankLv, stage)
        local starAddAttack = config.hero_star_attack[math.min(#config.hero_star_attack, quality)]
        local rarityAddAtt = GetTableData(TableName.NewHeroesLevelUp, level, "lv_attr_atk" .. config.rarity)
        local levelAttack = config.base_attack + config.attr_attack * rarityAddAtt + config.special_attr_attack * beyondTimes
        local rankAtk = 0
        local strArr = string.split(GetTableData(TableName.HeroMilitaryRankLv, curMilitaryRankId, "atk"), "|")
        if 0 < #strArr then
          rankAtk = tonumber(strArr[config.rarity])
        end
        atkInLevel = atkInLevel + levelAttack
        atkInQuality = atkInQuality + starAddAttack
        if rankAtk ~= nil then
          atkInRarity = atkInRarity + rankAtk
        end
        local camp = config.camp
        local effectId = HeroUtils.GetExtraAtkByCamp(camp)
        if rightBattleEffect ~= nil then
          local addNum = rightBattleEffect:GetValue(effectId)
          atkInCamp = atkInCamp + addNum
        end
      end
      oneData.rightNum = oneData.rightNum + atkInLevel + atkInQuality + atkInRarity + atkInCamp
      local tempData = reasonList[GameEffectReason.Hero]
      if tempData ~= nil then
        tempData.rightData.totalNum = tempData.rightData.totalNum + atkInLevel + atkInQuality + atkInRarity + atkInCamp
        local levelEffectOneData = {}
        levelEffectOneData.effectId = 0
        levelEffectOneData.dialog = "163153"
        levelEffectOneData.addNum = atkInLevel
        table.insert(tempData.rightData.totalReason, levelEffectOneData)
        local qualityEffectOneData = {}
        qualityEffectOneData.effectId = 0
        qualityEffectOneData.dialog = "129211"
        qualityEffectOneData.addNum = atkInQuality
        table.insert(tempData.rightData.totalReason, qualityEffectOneData)
        local rankEffectOneData = {}
        rankEffectOneData.effectId = 0
        rankEffectOneData.dialog = "163154"
        rankEffectOneData.addNum = atkInRarity
        table.insert(tempData.rightData.totalReason, rankEffectOneData)
        if 0 < atkInCamp then
          local campEffectOneData = {}
          campEffectOneData.effectId = 0
          campEffectOneData.dialog = "133000"
          campEffectOneData.addNum = atkInCamp
          table.insert(tempData.leftData.totalReason, campEffectOneData)
        end
      end
    end
  end
  oneData.reasonList = reasonList
  return oneData
end

local function GetHeroDefenceData(self, leftFightData, rightFightData, leftBattleEffect, rightBattleEffect, leftUuid, rightUuid)
  local oneData = {}
  oneData.dialogId = "220207"
  oneData.leftNum = 0
  oneData.rightNum = 0
  oneData.showType = BattleSubTitleShowType.HeroDefence
  local reasonList = {}
  for k, v in pairs(needCheckList) do
    local tempData = {}
    tempData.leftData = {}
    tempData.leftData.totalNum = 0
    tempData.leftData.totalReason = {}
    tempData.rightData = {}
    tempData.rightData.totalNum = 0
    tempData.rightData.totalReason = {}
    reasonList[v] = tempData
  end
  if leftFightData ~= nil and rightFightData ~= nil then
    if leftFightData.unitData ~= nil then
      local heroes = leftFightData.unitData:GetPlayerHeroes()
      local defInLevel = 0
      local defInQuality = 0
      local defInRarity = 0
      local defInCamp = 0
      for k, v in pairs(heroes) do
        local level = v.heroLevel
        local heroId = v.heroId
        local rankLv = v.rankLv or 0
        local stage = v.stage or 0
        local quality = v.heroQuality or 0
        local beyondTimes = HeroUtils.GetBeyondTimesByLevel(level)
        local config = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), heroId)
        local curMilitaryRankId = HeroUtils.GetRankIdByLvAndStage(heroId, rankLv, stage)
        local starAddDefence = config.hero_star_defens[math.min(#config.hero_star_defens, quality)]
        local rarityAddDef = GetTableData(TableName.NewHeroesLevelUp, level, "lv_attr_def" .. config.rarity)
        local levelDefence = config.base_defens + config.attr_defens * rarityAddDef + config.special_attr_defens * beyondTimes
        local rankDef = 0
        local strArr = string.split(GetTableData(TableName.HeroMilitaryRankLv, curMilitaryRankId, "def"), "|")
        if 0 < #strArr then
          rankDef = tonumber(strArr[config.rarity])
        end
        defInLevel = defInLevel + levelDefence
        defInQuality = defInQuality + starAddDefence
        if rankDef ~= nil then
          defInRarity = defInRarity + rankDef
        end
        local camp = config.camp
        local effectId = HeroUtils.GetExtraDefByCamp(camp)
        if leftBattleEffect ~= nil then
          local addNum = leftBattleEffect:GetValue(effectId)
          defInCamp = defInCamp + addNum
        end
      end
      oneData.leftNum = oneData.leftNum + defInLevel + defInQuality + defInRarity + defInCamp
      local tempData = reasonList[GameEffectReason.Hero]
      if tempData ~= nil then
        tempData.leftData.totalNum = tempData.leftData.totalNum + defInLevel + defInQuality + defInRarity + defInCamp
        local levelEffectOneData = {}
        levelEffectOneData.effectId = 0
        levelEffectOneData.dialog = "163153"
        levelEffectOneData.addNum = defInLevel
        table.insert(tempData.leftData.totalReason, levelEffectOneData)
        local qualityEffectOneData = {}
        qualityEffectOneData.effectId = 0
        qualityEffectOneData.dialog = "129211"
        qualityEffectOneData.addNum = defInQuality
        table.insert(tempData.leftData.totalReason, qualityEffectOneData)
        local rankEffectOneData = {}
        rankEffectOneData.effectId = 0
        rankEffectOneData.dialog = "163154"
        rankEffectOneData.addNum = defInRarity
        table.insert(tempData.leftData.totalReason, rankEffectOneData)
        if 0 < defInCamp then
          local campEffectOneData = {}
          campEffectOneData.effectId = 0
          campEffectOneData.dialog = "133000"
          campEffectOneData.addNum = defInCamp
          table.insert(tempData.leftData.totalReason, campEffectOneData)
        end
      end
    end
    if rightFightData.unitData ~= nil then
      local heroes = rightFightData.unitData:GetPlayerHeroes()
      local defInLevel = 0
      local defInQuality = 0
      local defInRarity = 0
      local defInCamp = 0
      for k, v in pairs(heroes) do
        local level = v.heroLevel
        local heroId = v.heroId
        local rankLv = v.rankLv or 0
        local stage = v.stage or 0
        local quality = v.heroQuality or 0
        local beyondTimes = HeroUtils.GetBeyondTimesByLevel(level)
        local config = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), heroId)
        local curMilitaryRankId = HeroUtils.GetRankIdByLvAndStage(heroId, rankLv, stage)
        local starAddDefence = config.hero_star_defens[math.min(#config.hero_star_defens, quality)]
        local rarityAddDef = GetTableData(TableName.NewHeroesLevelUp, level, "lv_attr_def" .. config.rarity)
        local levelDefence = config.base_defens + config.attr_defens * rarityAddDef + config.special_attr_defens * beyondTimes
        local rankDef = 0
        local strArr = string.split(GetTableData(TableName.HeroMilitaryRankLv, curMilitaryRankId, "def"), "|")
        if 0 < #strArr then
          rankDef = tonumber(strArr[config.rarity])
        end
        defInLevel = defInLevel + levelDefence
        defInQuality = defInQuality + starAddDefence
        if rankDef ~= nil then
          defInRarity = defInRarity + rankDef
        end
        local camp = config.camp
        local effectId = HeroUtils.GetExtraDefByCamp(camp)
        if rightBattleEffect ~= nil then
          local addNum = rightBattleEffect:GetValue(effectId)
          defInCamp = defInCamp + addNum
        end
      end
      oneData.rightNum = oneData.rightNum + defInLevel + defInQuality + defInRarity + defInCamp
      local tempData = reasonList[GameEffectReason.Hero]
      if tempData ~= nil then
        tempData.rightData.totalNum = tempData.rightData.totalNum + defInLevel + defInQuality + defInRarity + defInCamp
        local levelEffectOneData = {}
        levelEffectOneData.effectId = 0
        levelEffectOneData.dialog = "163153"
        levelEffectOneData.addNum = defInLevel
        table.insert(tempData.rightData.totalReason, levelEffectOneData)
        local qualityEffectOneData = {}
        qualityEffectOneData.effectId = 0
        qualityEffectOneData.dialog = "129211"
        qualityEffectOneData.addNum = defInQuality
        table.insert(tempData.rightData.totalReason, qualityEffectOneData)
        local rankEffectOneData = {}
        rankEffectOneData.effectId = 0
        rankEffectOneData.dialog = "163154"
        rankEffectOneData.addNum = defInRarity
        table.insert(tempData.rightData.totalReason, rankEffectOneData)
        if 0 < defInCamp then
          local campEffectOneData = {}
          campEffectOneData.effectId = 0
          campEffectOneData.dialog = "133000"
          campEffectOneData.addNum = defInCamp
          table.insert(tempData.leftData.totalReason, campEffectOneData)
        end
      end
    end
  end
  oneData.reasonList = reasonList
  return oneData
end

UIMailBattleAttrDetailCtrl.CloseSelf = CloseSelf
UIMailBattleAttrDetailCtrl.Close = Close
UIMailBattleAttrDetailCtrl.GetDetailList = GetDetailList
UIMailBattleAttrDetailCtrl.GetAttackAddData = GetAttackAddData
UIMailBattleAttrDetailCtrl.GetDefenceAddData = GetDefenceAddData
UIMailBattleAttrDetailCtrl.GetHealthAddData = GetHealthAddData
UIMailBattleAttrDetailCtrl.GetMarchLimitAddData = GetMarchLimitAddData
UIMailBattleAttrDetailCtrl.GetSkillHurtAddData = GetSkillHurtAddData
UIMailBattleAttrDetailCtrl.GetNormalHurtAddData = GetNormalHurtAddData
UIMailBattleAttrDetailCtrl.GetBackHurtAddData = GetBackHurtAddData
UIMailBattleAttrDetailCtrl.GetSkillHurtDecData = GetSkillHurtDecData
UIMailBattleAttrDetailCtrl.GetNormalHurtDecData = GetNormalHurtDecData
UIMailBattleAttrDetailCtrl.GetBackHurtDecData = GetBackHurtDecData
UIMailBattleAttrDetailCtrl.GetCurveData = GetCurveData
UIMailBattleAttrDetailCtrl.SetReasonShowList = SetReasonShowList
UIMailBattleAttrDetailCtrl.GetEffectDataByEffectId = GetEffectDataByEffectId
UIMailBattleAttrDetailCtrl.GetHeroRestraintValue = GetHeroRestraintValue
UIMailBattleAttrDetailCtrl.GetHeroCampAdd = GetHeroCampAdd
UIMailBattleAttrDetailCtrl.GetHeroAttackData = GetHeroAttackData
UIMailBattleAttrDetailCtrl.GetHeroDefenceData = GetHeroDefenceData
return UIMailBattleAttrDetailCtrl
