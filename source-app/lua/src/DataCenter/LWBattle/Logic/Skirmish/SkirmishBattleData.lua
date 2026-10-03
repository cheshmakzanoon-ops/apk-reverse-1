local SkirmishBattleData = BaseClass("SkirmishBattleData")

local function __init(self, data)
  self:InitData(data)
end

local function __delete(self)
  self.extData = nil
  self.playerData = nil
  self.heroData = nil
  self.topSoldierId = nil
  self.actions = nil
end

local function Swap(index)
  if index <= 10 then
    return (index + 4) % 10 + 1
  elseif 11 <= index and index <= 12 then
    return index == 11 and 12 or 11
  elseif 13 <= index and index <= 14 then
    return index == 13 and 14 or 13
  else
    return index
  end
end

local function InitData(self, mailExtData)
  self.extData = mailExtData
  if mailExtData.isDefend then
    self.topPlayerWin = mailExtData.attackerWin
  else
    self.topPlayerWin = not mailExtData.attackerWin
  end
  self.playerData = {}
  if mailExtData.isDefend then
    self.playerData = {
      mailExtData.player[2],
      mailExtData.player[1]
    }
  else
    self.playerData = {
      mailExtData.player[1],
      mailExtData.player[2]
    }
  end
  self.heroData = {}
  for _, v in pairs(self.extData.hero) do
    if self.extData.isDefend then
      self.heroData[Swap(v.index)] = v
    else
      self.heroData[v.index] = v
    end
  end
  self.topSoldierId = {
    [1] = 0,
    [2] = 0
  }
  for i = 1, 2 do
    for _, soldierLost in pairs(self.extData.player[i].soldierLost) do
      if self.topSoldierId[i] < soldierLost.soldierId then
        self.topSoldierId[i] = soldierLost.soldierId
      end
    end
  end
  if self.extData.isDefend then
    self.topSoldierId[1], self.topSoldierId[2] = self.topSoldierId[2], self.topSoldierId[1]
  end
  self.weaponData = {}
  if not table.IsNullOrEmpty(self.extData.weapon) then
    for _, v in pairs(self.extData.weapon) do
      if self.extData.isDefend then
        self.weaponData[Swap(v.index)] = v
      else
        self.weaponData[v.index] = v
      end
    end
  end
  self.actions = {}
  local actions = self.extData.pb_BattleReport.detail.actions
  if self.extData.isDefend then
    for i = 1, #actions do
      local action = DeepCopy(actions[i])
      action.time = action.time / 1000
      action.casterIndex = Swap(action.casterIndex)
      for _, v in pairs(action.targets) do
        v.index = Swap(v.index)
      end
      if action.bulletIndex and 0 < action.bulletIndex then
        action.bulletIndex = Swap(action.bulletIndex)
      end
      table.insert(self.actions, action)
    end
  else
    for i = 1, #actions do
      local action = DeepCopy(actions[i])
      action.time = action.time / 1000
      table.insert(self.actions, action)
    end
  end
  if 0 < #actions then
    self.fightDuration = self.actions[#actions].time
  else
    self.fightDuration = 0
  end
  local maxDamage, maxInjured, maxEnhance, maxWeaken = 0, 0, 0, 0
  for k, v in pairs(self.heroData) do
    if maxDamage < v.stat.damage then
      maxDamage = v.stat.damage
    end
    if maxInjured < v.stat.injured then
      maxInjured = v.stat.injured
    end
    if maxEnhance < v.stat.enhance then
      maxEnhance = v.stat.enhance
    end
    if maxWeaken < v.stat.weaken then
      maxWeaken = v.stat.weaken
    end
  end
  for k, v in pairs(self.weaponData) do
    if maxDamage < v.stat.damage then
      maxDamage = v.stat.damage
    end
    if maxInjured < v.stat.injured then
      maxInjured = v.stat.injured
    end
    if maxEnhance < v.stat.enhance then
      maxEnhance = v.stat.enhance
    end
    if maxWeaken < v.stat.weaken then
      maxWeaken = v.stat.weaken
    end
  end
  self.maxDamage, self.maxInjured, self.maxEnhance, self.maxWeaken = maxDamage, maxInjured, maxEnhance, maxWeaken
  self.hideMinion = self.extData.battleType == MailBattleReportType.TRAIN_PVP or self.extData.battleType == MailBattleReportType.TRAIN_PERSON_PVP or self.extData.battleType == MailBattleReportType.ALLIANCE_TRAIN_BATTLE or self.extData.battleType == MailBattleReportType.CROSS_ARENA or self.extData.battleType == MailBattleReportType.TRIAL_TOWER
end

local function MailIndex2PosIndex(self, mailIndex)
  if self.extData.isDefend then
    return Swap(mailIndex)
  else
    return mailIndex
  end
end

local function NeedSwap(self)
  return self.extData.isDefend
end

local function IsArmyHero(armyIndex, heroIndex)
  if armyIndex == 1 then
    return 1 <= heroIndex and heroIndex <= 5 or heroIndex == 13
  elseif armyIndex == 2 then
    return 6 <= heroIndex and heroIndex <= 10 or heroIndex == 14
  end
end

local function IsAtkHero(heroIndex)
  return 1 <= heroIndex and heroIndex <= 5 or heroIndex == 11 or heroIndex == 13
end

local function SelfHaveDominator(self)
  return self.heroData and self.heroData[PVPBattleSlot.SelfDominator] ~= nil
end

local function EnemyHasDominator(self)
  return self.heroData and self.heroData[PVPBattleSlot.EnemyDominator] ~= nil
end

SkirmishBattleData.__init = __init
SkirmishBattleData.__delete = __delete
SkirmishBattleData.InitData = InitData
SkirmishBattleData.MailIndex2PosIndex = MailIndex2PosIndex
SkirmishBattleData.NeedSwap = NeedSwap
SkirmishBattleData.Swap = Swap
SkirmishBattleData.IsArmyHero = IsArmyHero
SkirmishBattleData.IsAtkHero = IsAtkHero
SkirmishBattleData.SelfHaveDominator = SelfHaveDominator
SkirmishBattleData.EnemyHasDominator = EnemyHasDominator
return SkirmishBattleData
