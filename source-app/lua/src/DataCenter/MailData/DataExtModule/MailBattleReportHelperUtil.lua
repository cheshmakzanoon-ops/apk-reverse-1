local MailBattleReportHelperUtil = {}
local helperData, battleReport

function MailBattleReportHelperUtil.SetContext(helper, report)
  helperData = helper
  battleReport = report
end

function MailBattleReportHelperUtil.ClearContext()
  helperData = nil
  battleReport = nil
end

function MailBattleReportHelperUtil.PlayerLevel()
  local selfPlayerLevel = helperData.selfPlayerLevel
  local enemyPlayerLevel = helperData.enemyPlayerLevel or 0
  local score = {selfScore = selfPlayerLevel, enemyScore = enemyPlayerLevel}
  return math.max(enemyPlayerLevel - selfPlayerLevel, 0) * 40, score
end

function MailBattleReportHelperUtil.HeroLevel()
  local selfHeroLevelList = helperData.selfHeroLevelList
  local enemyHeroLevelList = helperData.enemyHeroLevelList
  local selfHeroLevel = 0
  for _, value in ipairs(selfHeroLevelList) do
    selfHeroLevel = selfHeroLevel + value
    if value == nil then
      return 0
    end
  end
  local enemyHeroLevel = 0
  for _, value in ipairs(enemyHeroLevelList) do
    enemyHeroLevel = enemyHeroLevel + value
  end
  local diff = enemyHeroLevel - selfHeroLevel
  local score = {
    selfScore = selfHeroLevel / #selfHeroLevelList,
    enemyScore = enemyHeroLevel / #enemyHeroLevelList
  }
  return math.min(diff * 4, 100), score
end

function MailBattleReportHelperUtil.HeroRank()
  local selfHeroLevelList = helperData.selfHeroLevelList
  local enemyHeroLevelList = helperData.enemyHeroLevelList
  local selfHeroStar = helperData.selfHeroStar
  local enemyHeroStar = helperData.enemyHeroStar
  local len1 = #selfHeroLevelList
  local len2 = #enemyHeroLevelList
  local temp = enemyHeroStar / len2 - selfHeroStar / len1
  local score = {
    selfScore = (selfHeroStar / len1 - 1) / 5,
    enemyScore = (enemyHeroStar / len2 - 1) / 5
  }
  return math.min(temp * 20, 100), score
end

function MailBattleReportHelperUtil.HeroSkill()
  local enemyHeroSkillBattlePower = helperData.enemyHeroSkillBattlePower
  local selfHeroSkillBattlePower = helperData.selfHeroSkillBattlePower
  local selfHeroEquipLevel = helperData.selfHeroEquipLevel
  local enemyHeroEquipLevel = helperData.enemyHeroEquipLevel
  local temp = (enemyHeroSkillBattlePower - selfHeroSkillBattlePower) / selfHeroSkillBattlePower
  local score = {selfScore = selfHeroSkillBattlePower, enemyScore = enemyHeroSkillBattlePower}
  if selfHeroEquipLevel == enemyHeroEquipLevel then
    return 0, score
  end
  return math.min(temp / 0.2 * 100, 98), score
end

function MailBattleReportHelperUtil.Equip()
  local enemyHeroEquipmentBattlePower = helperData.enemyHeroEquipmentBattlePower
  local selfHeroEquipmentBattlePower = helperData.selfHeroEquipmentBattlePower
  local temp = (enemyHeroEquipmentBattlePower - selfHeroEquipmentBattlePower) / selfHeroEquipmentBattlePower
  local score = {selfScore = selfHeroEquipmentBattlePower, enemyScore = enemyHeroEquipmentBattlePower}
  return math.min(temp / 0.25 * 100, 99), score
end

function MailBattleReportHelperUtil.Soldier()
  local selfSoldierMaxLevel = helperData.selfSoldierMaxLevel
  local enemySoldierMaxLevel = helperData.enemySoldierMaxLevel
  local score = {selfScore = selfSoldierMaxLevel, enemyScore = enemySoldierMaxLevel}
  if selfSoldierMaxLevel < enemySoldierMaxLevel then
    return 100, score
  else
    return 0, score
  end
end

function MailBattleReportHelperUtil.HonorWall()
  local selfHonorWallBattlePower = helperData.selfHonorWallBattlePower
  local enemyHonorWallBattlePower = helperData.enemyHonorWallBattlePower
  local score = {selfScore = selfHonorWallBattlePower, enemyScore = enemyHonorWallBattlePower}
  if selfHonorWallBattlePower == 0 then
    return 0, score
  end
  local temp = (enemyHonorWallBattlePower - selfHonorWallBattlePower) / selfHonorWallBattlePower
  return math.min(temp * 100, 93), score
end

function MailBattleReportHelperUtil.Drone()
  local selfUavLevel = helperData.selfUavLevel
  local enemyUavLevel = helperData.enemyUavLevel
  local temp = enemyUavLevel - selfUavLevel
  local score = {selfScore = selfUavLevel, enemyScore = enemyUavLevel}
  if selfUavLevel == 0 then
    return 0, score
  end
  if 110 < selfUavLevel then
    return math.min(temp * 5, 80), score
  end
  return math.min(temp * 5, 95), score
end

function MailBattleReportHelperUtil.DroneComponent()
  local selfUavEquipLevel = helperData.selfUavEquipLevel
  local enemyUavEquipLevel = helperData.enemyUavEquipLevel
  local temp = enemyUavEquipLevel - selfUavEquipLevel
  local score = {
    selfScore = selfUavEquipLevel / 6,
    enemyScore = enemyUavEquipLevel / 6
  }
  if selfUavEquipLevel == 0 then
    return 0, score
  end
  if 42 < selfUavEquipLevel then
    return math.min(temp * 20, 70), score
  end
  return math.min(temp * 20, 94), score
end

function MailBattleReportHelperUtil.Chip()
  local selfUavChipLevel = helperData.selfUavChipLevel
  local enemyUavChipLevel = helperData.enemyUavChipLevel
  local temp = enemyUavChipLevel - selfUavChipLevel
  local score = {selfScore = selfUavChipLevel, enemyScore = enemyUavChipLevel}
  if selfUavChipLevel == 0 then
    return 0, score
  end
  if 400 < selfUavChipLevel then
    return math.min(temp, 80), score
  end
  return math.min(temp, 96), score
end

function MailBattleReportHelperUtil.ChipStar()
  local selfUavChipStar = helperData.selfUavChipStar
  local enemyUavChipStar = helperData.enemyUavChipStar
  local selfUavChipLevel = helperData.selfUavChipLevel
  local temp = enemyUavChipStar - selfUavChipStar
  local score = {
    selfScore = selfUavChipStar / 4,
    enemyScore = enemyUavChipStar / 4
  }
  if selfUavChipLevel == 0 then
    return 0, score
  end
  if 20 < selfUavChipStar then
    return math.min(temp * 25, 60), score
  end
  return math.min(temp * 25, 93), score
end

function MailBattleReportHelperUtil.Science()
  local selfTechBattlePower = helperData.selfTechBattlePower
  local enemyTechBattlePower = helperData.enemyTechBattlePower
  local temp = (enemyTechBattlePower - selfTechBattlePower) / selfTechBattlePower
  local score = {selfScore = selfTechBattlePower, enemyScore = enemyTechBattlePower}
  return math.min(temp / 0.35 * 100, 96), score
end

function MailBattleReportHelperUtil.UniqueWeapon()
  local selfHeroEquipLevel = helperData.selfHeroEquipLevel
  local enemyHeroEquipLevel = helperData.enemyHeroEquipLevel
  local temp = enemyHeroEquipLevel - selfHeroEquipLevel
  local score = {selfScore = selfHeroEquipLevel, enemyScore = enemyHeroEquipLevel}
  if selfHeroEquipLevel == 0 then
    return 0, score
  end
  return math.min(temp * 8, 97), score
end

function MailBattleReportHelperUtil.Camp()
  local function getCounter(camp1, camp2)
    local temp = camp2 - camp1
    
    if temp == 2 then
      return -1
    elseif temp == -2 then
      return 1
    else
      return temp
    end
  end
  
  local selfHeroCampList = helperData.selfHeroCampList
  local enemyHeroCampList = helperData.enemyHeroCampList
  local sum = 0
  for i = 1, math.max(#selfHeroCampList, #enemyHeroCampList) do
    local selfHeroCamp = selfHeroCampList[i]
    local enemyHeroCamp = enemyHeroCampList[i]
    if selfHeroCamp == nil and enemyHeroCamp == nil then
      sum = sum + 0
    elseif selfHeroCamp == nil then
      sum = sum - 1
    elseif enemyHeroCamp == nil then
      sum = sum + 1
    else
      sum = sum + getCounter(selfHeroCamp, enemyHeroCamp)
    end
  end
  return math.max(-sum * 45, 0)
end

function MailBattleReportHelperUtil.Position()
  local selfHeroJobList = helperData.selfHeroJobList
  if selfHeroJobList[1] and 1 < selfHeroJobList[1] or selfHeroJobList[2] and 1 < selfHeroJobList[2] then
    return 100
  else
    return 0
  end
end

function MailBattleReportHelperUtil.PhysicalDamage()
  local enemyDpsType = helperData.enemyDpsType
  if enemyDpsType == 0 then
    return 30
  end
  return 0
end

function MailBattleReportHelperUtil.EnergyDamage()
  local enemyDpsType = helperData.enemyDpsType
  if enemyDpsType == 1 then
    return 30
  end
  return 0
end

function MailBattleReportHelperUtil.Equal()
  return 1
end

function MailBattleReportHelperUtil.EnemyCrit()
  local enemyDpsCrit = helperData.enemyDpsCrit
  local temp = {
    dialogPara = {
      string.format("%.2f", enemyDpsCrit * 100)
    }
  }
  return math.max(enemyDpsCrit * 100 - 65, 0) * 2, temp
end

function MailBattleReportHelperUtil.EnemyStun()
  local enemyStunNum = helperData.enemyStunNum
  return math.min(enemyStunNum * 20, 100), {
    dialogPara = {enemyStunNum}
  }
end

function MailBattleReportHelperUtil.Position2()
  local selfHeroJobList = helperData.selfHeroJobList
  if selfHeroJobList[1] and 1 < selfHeroJobList[1] or selfHeroJobList[2] and 1 < selfHeroJobList[2] then
    return 200
  else
    return 0
  end
end

function MailBattleReportHelperUtil.PVEHeroLevel()
  local selfHeroLevelList = helperData.selfHeroLevelList
  local monsterLevelList = helperData.monsterLevelList
  local selfHeroLevel = 0
  for _, value in ipairs(selfHeroLevelList) do
    selfHeroLevel = selfHeroLevel + value
  end
  local enemyHeroLevel = 0
  for _, value in ipairs(monsterLevelList) do
    enemyHeroLevel = enemyHeroLevel + math.floor(value / 2)
  end
  local ratio = 0
  if 0 < selfHeroLevel then
    ratio = (enemyHeroLevel - selfHeroLevel) / selfHeroLevel
  end
  local result = math.min(ratio / 0.4 * 90, 100)
  if 0 < result then
    local maxHeroLevel = HeroUtils.GetMaxLevelWithScienceLimit()
    if maxHeroLevel <= selfHeroLevel / #selfHeroLevelList then
      return 0
    end
    return result
  else
    return 0
  end
end

function MailBattleReportHelperUtil.PVEHeroEquip()
  local enemyHeroEquipmentBattlePower = helperData.enemyHeroEquipmentBattlePower
  local selfHeroEquipmentBattlePower = helperData.selfHeroEquipmentBattlePower
  local temp = (enemyHeroEquipmentBattlePower - selfHeroEquipmentBattlePower) / selfHeroEquipmentBattlePower
  if math.max(selfHeroEquipmentBattlePower - 20000, 0) == 0 then
    return 0
  end
  return math.min(temp / 0.25 * 100, 98)
end

function MailBattleReportHelperUtil.PVESoldier()
  local selfSoldierMaxLevel = helperData.selfSoldierMaxLevel
  local monsterSoldierLevelList = helperData.monsterSoldierLevelList
  local maxMonsterLevel = toInt(monsterSoldierLevelList[1])
  for i = 2, #monsterSoldierLevelList do
    maxMonsterLevel = math.max(maxMonsterLevel, monsterSoldierLevelList[i])
  end
  local score = {selfScore = selfSoldierMaxLevel, enemyScore = maxMonsterLevel}
  if selfSoldierMaxLevel < maxMonsterLevel and maxMonsterLevel < 11 then
    return 100, score
  else
    return 0, score
  end
end

function MailBattleReportHelperUtil.PVEDrone()
  local enemyTacticalBattlePower = helperData.enemyTacticalBattlePower
  local selfTacticalBattlePower = helperData.selfTacticalBattlePower
  local temp = (enemyTacticalBattlePower - selfTacticalBattlePower) / selfTacticalBattlePower
  return math.min(temp / 0.4 * 100, 97)
end

function MailBattleReportHelperUtil.PVEScience()
  local selfTechBattlePower = helperData.selfTechBattlePower
  local enemyTechBattlePower = helperData.enemyTechBattlePower
  local temp = (enemyTechBattlePower - selfTechBattlePower) / selfTechBattlePower
  local score = {selfScore = selfTechBattlePower, enemyScore = enemyTechBattlePower}
  return math.min(temp / 0.5 * 100, 96), score
end

function MailBattleReportHelperUtil.Resistance()
  local hasResistance = helperData.hasResistance
  local needResistance = helperData.needResistance
  if needResistance == 0 then
    return 0
  else
    return (needResistance - hasResistance) / needResistance * 200
  end
end

function MailBattleReportHelperUtil.Hide()
  return 0
end

function MailBattleReportHelperUtil.Overtime()
  local isOvertime = helperData.isOvertime
  if isOvertime then
    return 100
  else
    return 0
  end
end

function MailBattleReportHelperUtil.DominatorTrainingLv()
  local selfTrainLvs = 0
  local selfTrainInfos = helperData.selfDominatorTrainInfos
  if not table.IsNullOrEmpty(selfTrainInfos) then
    for groupId, lv in pairs(selfTrainInfos) do
      selfTrainLvs = selfTrainLvs + lv
    end
  end
  local enemyTrainLvs = 0
  local enemyTrainInfos = helperData.enemyDominatorTrainInfos
  if not table.IsNullOrEmpty(enemyTrainInfos) then
    for groupId, lv in pairs(enemyTrainInfos) do
      enemyTrainLvs = enemyTrainLvs + lv
    end
  end
  local diff = enemyTrainLvs - selfTrainLvs
  local score = {selfScore = selfTrainLvs, enemyScore = enemyTrainLvs}
  return math.min(diff, 88), score
end

function MailBattleReportHelperUtil.DominatorRankLv()
  local selfDominator = helperData.selfDominator
  local enemyDominator = helperData.enemyDominator
  local enemyDominatorRankLv, selfDominatorRankLv = 0, 0
  if selfDominator then
    selfDominatorRankLv = selfDominator:GetRank()
  else
    return 0
  end
  if enemyDominator then
    enemyDominatorRankLv = enemyDominator:GetRank()
  end
  if selfDominatorRankLv <= 0 and enemyDominatorRankLv <= 0 then
    return 0
  end
  local diff = enemyDominatorRankLv - selfDominatorRankLv
  local score = {selfScore = selfDominatorRankLv, enemyScore = enemyDominatorRankLv}
  return math.min(diff * 10, 90), score
end

function MailBattleReportHelperUtil.DominatorMainTraining()
  local selfMainTrainLv = helperData.selfDominatorMainTrainingLevel
  local enemyMainTrainLv = helperData.enemyDominatorMainTrainingLevel
  if selfMainTrainLv <= 0 and enemyMainTrainLv <= 0 then
    return 0
  end
  local diff = enemyMainTrainLv - selfMainTrainLv
  local score = {selfScore = selfMainTrainLv, enemyScore = enemyMainTrainLv}
  return math.min(diff * 8, 89), score
end

function MailBattleReportHelperUtil.ArmyMorale()
  local selfMorale = helperData.selfTotalMorale
  local enemyMorale = helperData.enemyTotalMorale
  local selfSoldierMaxLevel = helperData.selfSoldierMaxLevel
  local enemySoldierMaxLevel = helperData.enemySoldierMaxLevel
  if selfMorale <= 0 or enemyMorale <= 0 then
    return 0
  end
  if selfSoldierMaxLevel ~= enemySoldierMaxLevel then
    return 0
  end
  local diff = (enemyMorale - selfMorale) / selfMorale * 100
  local score = {selfScore = selfMorale, enemyScore = enemyMorale}
  return math.min(diff * 10, 100), score
end

function MailBattleReportHelperUtil.WrongChip()
  local selfChips = helperData.selfSkillChips
  local heroTypes = helperData.selfHeroCampList
  local heroTypeMap = {}
  for i = 1, #heroTypes do
    local heroType = heroTypes[i]
    heroTypeMap[heroType] = (heroTypeMap[heroType] or 0) + 1
  end
  local dominantHeroType
  for heroType, count in pairs(heroTypeMap) do
    if 3 <= count then
      dominantHeroType = heroType
      break
    end
  end
  if dominantHeroType == nil then
    return 0
  end
  local chipHeroTypes = {}
  if not table.IsNullOrEmpty(selfChips) then
    for i, chip in ipairs(selfChips) do
      local chipHeroType = chip:GetHeroType()
      chipHeroTypes[chipHeroType] = (chipHeroTypes[chipHeroType] or 0) + 1
    end
  end
  local wrongChipCount = 0
  for heroType, chipCount in pairs(chipHeroTypes) do
    if heroType ~= dominantHeroType then
      wrongChipCount = wrongChipCount + chipCount
    end
  end
  return math.min(wrongChipCount * 100, 100)
end

function MailBattleReportHelperUtil.NoDominator()
  local selfDominator = helperData.selfDominator
  local enemyDominator = helperData.enemyDominator
  if selfDominator == nil and enemyDominator ~= nil then
    return 98
  else
    return 0
  end
end

return MailBattleReportHelperUtil
