local ArmyFormationUtils = {}
local lua_tostring = tostring
local lua_tonumber = tonumber
ArmyFormationUtils.EnterSquadWay2FormationDataType = {
  [EnterHeroSquadPanelWay.ParkingLotBuilding] = FormationDataType.ArmyFormation,
  [EnterHeroSquadPanelWay.ToMarch] = FormationDataType.ArmyFormation,
  [EnterHeroSquadPanelWay.MainUI] = FormationDataType.ArmyFormation,
  [EnterHeroSquadPanelWay.Gate] = FormationDataType.Gate,
  [EnterHeroSquadPanelWay.Marching] = FormationDataType.ArmyFormation,
  [EnterHeroSquadPanelWay.TruckDeparture] = FormationDataType.TruckDeparture,
  [EnterHeroSquadPanelWay.HSRDeparture] = FormationDataType.TruckDeparture,
  [EnterHeroSquadPanelWay.PVE] = FormationDataType.PVE,
  [EnterHeroSquadPanelWay.PveEnterBattle] = FormationDataType.PVE,
  [EnterHeroSquadPanelWay.DetectEventPVE] = FormationDataType.PVE,
  [EnterHeroSquadPanelWay.TruckRob] = FormationDataType.TruckRob,
  [EnterHeroSquadPanelWay.HSRRob] = FormationDataType.TruckRob,
  [EnterHeroSquadPanelWay.Arena3V3Attack] = FormationDataType.Formation3V3Atk,
  [EnterHeroSquadPanelWay.Arena3V3Defence] = FormationDataType.Formation3V3Def,
  [EnterHeroSquadPanelWay.TrailTower] = FormationDataType.TrailTower,
  [EnterHeroSquadPanelWay.ChampionDuel] = FormationDataType.ChampionDuel,
  [EnterHeroSquadPanelWay.KOFAttack] = FormationDataType.KOFAttack,
  [EnterHeroSquadPanelWay.KOFDefence] = FormationDataType.KOFDefence
}
ArmyFormationUtils.ExclusiveFormationTypes = {
  [FormationDataType.ArmyFormation] = true,
  [FormationDataType.Formation3V3Def] = true,
  [FormationDataType.Formation3V3Atk] = true,
  [FormationDataType.TruckDeparture] = true,
  [FormationDataType.ChampionDuel] = true,
  [FormationDataType.KOFDefence] = true,
  [FormationDataType.KOFAttack] = true
}

function ArmyFormationUtils.GetDataTypeByEnterWay(enterWay)
  return ArmyFormationUtils.EnterSquadWay2FormationDataType[enterWay]
end

function ArmyFormationUtils.GetArmyFormationDataByEnterWay(enterWay, idx, squadData)
  local dataType = ArmyFormationUtils.GetDataTypeByEnterWay(enterWay)
  if not dataType then
    if squadData then
      return squadData
    end
    return nil
  end
  local _armyFormation = ArmyFormationUtils.GetArmyFormationData(dataType, idx)
  _armyFormation = _armyFormation or squadData
  return _armyFormation, dataType
end

function ArmyFormationUtils.GetArmyFormationData(dataType, idx)
  if dataType == FormationDataType.ArmyFormation then
    return DataCenter.ArmyFormationDataManager:GetOneArmyInfoByIndex(idx)
  elseif dataType == FormationDataType.Formation3V3Atk then
    if 3 < idx then
      return nil
    end
    return DataCenter.LW3V3Manager:GetAtkTeamByIndex(idx)
  elseif dataType == FormationDataType.Formation3V3Def then
    if 3 < idx then
      return nil
    end
    return DataCenter.LW3V3Manager:GetSelfDefTeamByIndex(idx)
  elseif dataType == FormationDataType.ChampionDuel then
    if 3 < idx then
      return nil
    end
    return DataCenter.ChampionDuelManager:GetSelfTeamByOrder(idx)
  elseif dataType == FormationDataType.TruckDeparture then
    return DataCenter.LWMyStationDataManager:GetDefenceFormation(idx)
  elseif dataType == FormationDataType.PVE then
    return DataCenter.ArmyFormationDataManager:GetTemplateFormationByIndex(idx)
  elseif dataType == FormationDataType.TruckRob then
    return DataCenter.LWMyStationDataManager:GetRobFormation(idx)
  elseif dataType == FormationDataType.Gate then
    return DataCenter.ArmyFormationDataManager:GetDefenceFormation(idx)
  elseif dataType == FormationDataType.KOFDefence then
    if 3 < idx then
      return nil
    end
    return DataCenter.LWKOFBattleManager:GetSelfDefTeamByIndex(idx)
  elseif dataType == FormationDataType.KOFAttack then
    if 3 < idx then
      return nil
    end
    return DataCenter.LWKOFBattleManager:GetAtkTeamByIndex(idx)
  end
  return nil
end

function ArmyFormationUtils.GetAllArmyFormationData(dataType)
  local list = {}
  if dataType == FormationDataType.ArmyFormation then
    list = DataCenter.ArmyFormationDataManager:GetArmyFormationList()
  elseif dataType == FormationDataType.Formation3V3Atk then
    for i = 1, 3 do
      list[i] = DataCenter.LW3V3Manager:GetAtkTeamByIndex(i)
    end
  elseif dataType == FormationDataType.Formation3V3Def then
    for i = 1, 3 do
      list[i] = DataCenter.LW3V3Manager:GetSelfDefTeamByIndex(i)
    end
  elseif dataType == FormationDataType.ChampionDuel then
    for i = 1, 3 do
      list[i] = DataCenter.ChampionDuelManager:GetSelfTeamByOrder(i)
    end
  elseif dataType == FormationDataType.TruckDeparture then
    for i = 1, 4 do
      local formationData = DataCenter.LWMyStationDataManager:GetDefenceFormation(i)
      if formationData then
        list[i] = DataCenter.LWMyStationDataManager:GetDefenceFormation(i)
      end
    end
  elseif dataType == FormationDataType.PVE then
    list = DataCenter.ArmyFormationDataManager:GetTemplateFormations()
  elseif dataType == FormationDataType.TrailTower then
    list = DataCenter.LWTrailTowerManager:GetTrailTowerFormations()
  elseif dataType == FormationDataType.TruckRob then
    list = DataCenter.LWMyStationDataManager:GetRobFormations()
  elseif dataType == FormationDataType.Gate then
    list = DataCenter.ArmyFormationDataManager:GetDefenceFormations()
  elseif dataType == FormationDataType.KOFDefence then
    for i = 1, 3 do
      list[i] = DataCenter.LWKOFBattleManager:GetSelfDefTeamByIndex(i)
    end
  elseif dataType == FormationDataType.KOFAttack then
    for i = 1, 3 do
      list[i] = DataCenter.LWKOFBattleManager:GetAtkTeamByIndex(i)
    end
  end
  return list
end

function ArmyFormationUtils.GenerateServerHeroArray(heroes, dominatorUuid)
  local heroInfos = heroes
  local heroArray = SFSArray.New()
  table.walk(heroInfos, function(k, v)
    local key = k
    if type(key) == "string" then
      key = lua_tonumber(key)
    end
    local obj = SFSObject.New()
    obj:PutLong("heroUuid", v)
    obj:PutInt("index", key)
    heroArray:AddSFSObject(obj)
  end)
  if dominatorUuid then
    local dominatorInfo = DataCenter.DominatorManager:GetInfoByUuid(dominatorUuid)
    if dominatorInfo then
      local obj = SFSObject.New()
      obj:PutLong("heroUuid", dominatorUuid)
      obj:PutInt("index", lua_tonumber(ArmyFormationSlot.Dominator))
      heroArray:AddSFSObject(obj)
    end
  end
  return heroArray
end

function ArmyFormationUtils.GetArmyFormationOrderByIndex(dataType, index, squadData)
  if not squadData then
    return nil
  end
  if dataType == FormationDataType.ChampionDuel then
    return DataCenter.ChampionDuelManager:GetSelfTeamOrderByIndex(index)
  elseif dataType == FormationDataType.Formation3V3Def then
    return DataCenter.LW3V3Manager:GetSelfDefTeamOrderByIdx(index)
  elseif dataType == FormationDataType.Formation3V3Atk then
    return DataCenter.LW3V3Manager:GetSelfAtkTeamOrderByIdx(index)
  elseif dataType == FormationDataType.KOFDefence then
    return DataCenter.LWKOFBattleManager:GetSelfDefTeamOrderByIdx(index)
  elseif dataType == FormationDataType.KOFAttack then
    return DataCenter.LWKOFBattleManager:GetSelfAtkTeamOrderByIdx(index)
  else
    return squadData.index
  end
  return nil
end

function ArmyFormationUtils.IsHeroCanTakeDown(squadData, heroUuid)
  if squadData:GetLocalHeroIndex(heroUuid) == nil then
    return false
  end
  if squadData:GetLocalHeroesCount() == 1 then
    local dominatorUuid = squadData:GetLocalDominatorUuid()
    local hasDominator = false
    if dominatorUuid then
      hasDominator = DataCenter.DominatorManager:GetInfoByUuid(dominatorUuid) ~= nil
    end
    if hasDominator then
      return false
    end
  end
  return true
end

function ArmyFormationUtils.GetStrongestHeroType()
  local bestFormation
  local bestPower = -1
  local formations = DataCenter.ArmyFormationDataManager:GetArmyFormationList()
  if formations then
    table.sort(formations, function(a, b)
      return a.index < b.index
    end)
    for _, formation in ipairs(formations) do
      local p = formation:GetLocalHeroesCapacity() or 0
      if bestPower < p then
        bestPower = p
        bestFormation = formation
      end
    end
  end
  if not bestFormation then
    return nil
  end
  local countByType = {}
  local sumPowerByType = {}
  for slotIndex = ArmyFormationSlot.Hero1, ArmyFormationSlot.Hero5 do
    local heroUuid = bestFormation:GetLocalHeroAtSlotIndex(slotIndex)
    if heroUuid then
      local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
      if heroData and heroData.heroType then
        local t = heroData.heroType
        countByType[t] = (countByType[t] or 0) + 1
        sumPowerByType[t] = (sumPowerByType[t] or 0) + (heroData.power or 0)
      end
    end
  end
  local maxCount = 0
  for _, c in pairs(countByType) do
    if c > maxCount then
      maxCount = c
    end
  end
  if maxCount <= 0 then
    return nil
  end
  local allType = {
    HeroType.Tank,
    HeroType.Aircraft,
    HeroType.Missile
  }
  local strongestType
  local bestSumPower = -1
  for _, v in ipairs(allType) do
    local t = v
    local c = countByType[t] or 0
    if c == maxCount then
      local sumP = sumPowerByType[t] or 0
      if strongestType == nil or bestSumPower < sumP then
        bestSumPower = sumP
        strongestType = t
      end
    end
  end
  return strongestType
end

return ArmyFormationUtils
