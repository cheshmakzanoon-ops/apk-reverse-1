local SkirmishSceneData = BaseClass("SkirmishSceneData")

local function __init(self, selfHaveDominator, enemyHasDominator)
  self:InitData(selfHaveDominator, enemyHasDominator)
end

local function __delete(self)
end

local function InitData(self, selfHaveDominator, enemyHasDominator, selfPositionType)
  self.selfPositionType = selfPositionType or ArmyFormationPositionType.Normal
  self.sceneName = "LastWar_Scene_army_001_clean_03"
  self.enterType = PVEEnterType.Default
  self.scenePosOffset = Vector3(-1000, 0, -1000)
  self.armyBirthPos = {}
  self.armyBirthPos[1] = Vector3.New(36, 0, 11.13) + self.scenePosOffset
  self.armyBirthPos[2] = Vector3.New(36, 0, 36.19) + self.scenePosOffset
  self.minionLocalPos = {
    [1] = Vector3.New(-1.51, 0, 3.09),
    [2] = Vector3.New(-1.51, 0, 1.14),
    [3] = Vector3.New(-0.74, 0, 2.64),
    [4] = Vector3.New(-0.06, 0, 2.73),
    [5] = Vector3.New(0.7, 0, 2.56),
    [6] = Vector3.New(1.42, 0, 2.04),
    [7] = Vector3.New(-1.43, 0, 2.18),
    [8] = Vector3.New(-0.79, 0, 1.69),
    [9] = Vector3.New(-0.07, 0, 1.65),
    [10] = Vector3.New(0.65, 0, 1.6),
    [11] = Vector3.New(1.38, 0, 1.09),
    [12] = Vector3.New(1.56, 0, 2.95),
    [13] = Vector3.New(1.56, 0, 1.14),
    [14] = Vector3.New(0.74, 0, 2.64)
  }
  self.MAX_MINION_PER_HERO = 12
  self.MOVE_SPEED = 1
  self.OPENING_TIME = 2
  self.camPoint = Vector3.New(36, 0, 23.8) + self.scenePosOffset
  self.OPENING_CAMERA_HEIGHT = 80
  self.OPENING_CAMERA_FOV = 25
  self.OPENING_CAMERA_ROTATION = 55
  self.FIGHT_CAMERA_HEIGHT = 65
  self.MINION_ATTACK_PRECD = 5
  self.MINION_ATTACK_CD = 3
  self.platoonLocalPos = {}
  self.armyEndPos = {}
  self.platoonWorldPos = {}
  for i = 1, 16 do
    local lineData = LocalController:instance():getLine(TableName.LW_Replay_Distance, i)
    if i == 1 then
      local posStrs = string.split(lineData.pos_center, ",")
      self.armyEndPos[1] = Vector3.New(tonumber(posStrs[1]), tonumber(posStrs[2]), tonumber(posStrs[3])) + self.scenePosOffset
    end
    if i == 6 then
      local posStrs = string.split(lineData.pos_center, ",")
      self.armyEndPos[2] = Vector3.New(tonumber(posStrs[1]), tonumber(posStrs[2]), tonumber(posStrs[3])) + self.scenePosOffset
    end
    local posLineData, posStrs
    local useDefaultPosition = self:UseDefaultPosition(i)
    if useDefaultPosition then
      if (i <= PVPBattleSlot.SelfHero5 or i == PVPBattleSlot.SelfDominator) and selfHaveDominator then
        posLineData = lineData.pos_adjust
      elseif (i >= PVPBattleSlot.EnemyHero1 or i == PVPBattleSlot.EnemyDominator) and enemyHasDominator then
        posLineData = lineData.pos_adjust
      end
    elseif self.selfPositionType == ArmyFormationPositionType.DominatorAndHero345 then
      posLineData = lineData.pos_dominator_four
    elseif self.selfPositionType == ArmyFormationPositionType.OnlyDominator then
      posLineData = lineData.pos_dominator_one
    end
    if string.IsNullOrEmpty(posLineData) then
      posLineData = lineData.pos
    end
    posStrs = string.split(posLineData, ",")
    self.platoonLocalPos[i] = Vector3.New(tonumber(posStrs[1]), tonumber(posStrs[2]), tonumber(posStrs[3]))
  end
  for i = 1, 5 do
    self.platoonWorldPos[i] = self.armyEndPos[1] + self.platoonLocalPos[i]
  end
  for i = 6, 10 do
    self.platoonWorldPos[i] = self.armyEndPos[2] - self.platoonLocalPos[i]
  end
  if self.platoonLocalPos[11] then
    self.platoonWorldPos[11] = self.armyEndPos[1] + self.platoonLocalPos[11]
  end
  if self.platoonLocalPos[12] then
    self.platoonWorldPos[12] = self.armyEndPos[2] - self.platoonLocalPos[12]
  end
  if self.platoonLocalPos[13] then
    self.platoonWorldPos[13] = self.armyEndPos[1] + self.platoonLocalPos[13]
  end
  if self.platoonLocalPos[14] then
    self.platoonWorldPos[14] = self.armyEndPos[2] - self.platoonLocalPos[14]
  end
  if self.platoonLocalPos[15] then
    self.platoonWorldPos[15] = self.armyEndPos[1] + self.platoonLocalPos[15]
  end
  if self.platoonLocalPos[16] then
    self.platoonWorldPos[16] = self.armyEndPos[2] - self.platoonLocalPos[16]
  end
  self.distanceTable = {}
  for i = 1, 14 do
    self.distanceTable[i] = {}
  end
  for i = 1, 14 do
    for j = 1, i - 1 do
      self.distanceTable[i][j] = self.distanceTable[j][i]
    end
    self.distanceTable[i][i] = 0
    for j = i + 1, 14 do
      self.distanceTable[i][j] = Vector3.Distance(self.platoonWorldPos[i], self.platoonWorldPos[j])
    end
  end
end

local function GetCaptainDistance(self, i, j)
  return self.distanceTable[i][j]
end

local function GetHeroPos(self, index)
  return self.platoonWorldPos[index] or Vector3.zero
end

local function UseDefaultPosition(self, index)
  if self.selfPositionType == nil or self.selfPositionType == ArmyFormationPositionType.Normal then
    return true
  else
    local isSelfHero = index <= PVPBattleSlot.SelfHero5 or index == PVPBattleSlot.SelfDominator
    if isSelfHero then
      return false
    else
      return true
    end
  end
end

local function GetOpponentHero(heroIndex)
  if 1 <= heroIndex and heroIndex <= 5 then
    return heroIndex + 5
  elseif 6 <= heroIndex and heroIndex <= 10 then
    return heroIndex - 5
  elseif heroIndex == 11 then
    return 14
  elseif heroIndex == 13 then
    return 14
  elseif heroIndex == 14 then
    return 13
  elseif heroIndex == 15 then
    return 16
  elseif heroIndex == 16 then
    return 15
  end
end

local function FormationSlot2PVPSlot(idx, mySide)
  if mySide then
    if idx ~= ArmyFormationSlot.Dominator then
      return idx
    else
      return PVPBattleSlot.SelfDominator
    end
  elseif idx <= ArmyFormationSlot.Hero5 then
    return idx + ArmyFormationSlot.Hero5
  elseif idx == ArmyFormationSlot.Dominator then
    return PVPBattleSlot.EnemyDominator
  end
end

local function PVPSlot2FormationSlot(idx)
  if idx <= PVPBattleSlot.SelfHero5 then
    return idx
  end
  if idx >= PVPBattleSlot.EnemyHero1 and idx <= PVPBattleSlot.EnemyHero5 then
    return idx - PVPBattleSlot.SelfHero1
  end
  if idx == PVPBattleSlot.SelfDominator then
    return ArmyFormationSlot.Dominator
  end
  if idx == PVPBattleSlot.EnemyDominator then
    return ArmyFormationSlot.Dominator
  end
end

local function IsSelfUnitsPVPSlot(idx)
  if idx <= PVPBattleSlot.SelfHero5 or idx == PVPBattleSlot.SelfDominator then
    return true
  end
  return false
end

SkirmishSceneData.__init = __init
SkirmishSceneData.__delete = __delete
SkirmishSceneData.InitData = InitData
SkirmishSceneData.GetCaptainDistance = GetCaptainDistance
SkirmishSceneData.GetHeroPos = GetHeroPos
SkirmishSceneData.UseDefaultPosition = UseDefaultPosition
SkirmishSceneData.GetOpponentHero = GetOpponentHero
SkirmishSceneData.FormationSlot2PVPSlot = FormationSlot2PVPSlot
SkirmishSceneData.PVPSlot2FormationSlot = PVPSlot2FormationSlot
SkirmishSceneData.IsSelfUnitsPVPSlot = IsSelfUnitsPVPSlot
return SkirmishSceneData
