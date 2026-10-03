local Resource = CS.GameEntry.Resource
local GameObject = CS.UnityEngine.GameObject
local Base = require("Scene.LWBattle.Skirmish.BasePlatoon")
local Platoon = BaseClass("Platoon", Base)
local Captain = require("Scene.LWBattle.Skirmish.Unit.Captain")
local Minion = require("Scene.LWBattle.Skirmish.Unit.Minion")

function Platoon:__init(logic, army, index, captainInitShowState, param)
  Base.__init(self, logic, army, index, captainInitShowState)
  self.heroData = self.battleData.heroData[self.index]
  self.dirMultiplier = self.army.dirMultiplier
  self.isMoving = true
  self.captainInitShowState = captainInitShowState
  if self.captainInitShowState == nil then
    self.captainInitShowState = true
  end
  self.curPlayerData = nil
  if self.battleData.playerData then
    if self.index >= 1 and self.index <= 5 or self.index == PVPBattleSlot.SelfDominator then
      self.curPlayerData = self.battleData.playerData[1]
    else
      self.curPlayerData = self.battleData.playerData[2]
    end
  end
  self:CreateCaptain()
  self:CreateMinions()
end

function Platoon:CreateCaptain()
  self.captain = ObjectPool:GetInstance():Load(Captain)
  self.captain:Init(self.logic, self, self.heroData, Vector3.zero, self.index, self.captainInitShowState)
  self.logic:AddCaptain(self.index, self.captain)
  self.logic:AddUnit(self.captain)
end

function Platoon:CreateMinions()
  self.minions = {}
  self.deadMinions = {}
  if self.battleData.hideMinion then
    return
  end
  self.minionHero = HeroInfo.New()
  local minionsNum = self:Hp2MinionsNum(self.heroData.initHp)
  if minionsNum <= 0 then
    return
  end
  local soldierMeta = DataCenter.SoldierDataManager:GetTemplate(self.battleData.topSoldierId[self.army.index])
  if soldierMeta then
    local positionCount = #self.sceneData.minionLocalPos
    if minionsNum > positionCount then
      Logger.LogError("Platoon CreateMinions \229\176\143\229\133\181\230\149\176\233\135\143 > \228\189\141\231\189\174\230\149\176\233\135\143\239\188\136\231\142\176\229\156\168\229\143\170\230\156\13714\228\184\170\239\188\137,initHp:" .. self.heroData.initHp .. ", maxHp:" .. self.heroData.maxHp .. ", heroId:" .. self.heroData.heroId)
      minionsNum = positionCount
    end
    self.minionHero:UpdateFromTemplate(soldierMeta.playback_hero_id, 1)
    self:CheckT11ModelReplace(soldierMeta)
    for i = 1, minionsNum do
      local minion = ObjectPool:GetInstance():Load(Minion)
      minion:Init(self.logic, self, self.minionHero, self.sceneData.minionLocalPos[i], i)
      table.insert(self.minions, minion)
      self.logic:AddUnit(minion)
    end
  end
end

function Platoon:CheckT11ModelReplace(soldierMeta)
  if not soldierMeta then
    return
  end
  if not T11Util.IsSuperSoldier(soldierMeta.lv, soldierMeta.type) then
    return
  end
  if not self.curPlayerData or not self.curPlayerData.soldierEleven then
    return
  end
  local t11Data = self.curPlayerData.soldierEleven
  local t11Stage = t11Data.stage
  local t11SelectMode = T11Util.GetSoldierTypeByEffectList(t11Data.effects)
  if not t11Stage or not t11SelectMode then
    return
  end
  local t11Tmp = T11Util.GetT11SoldierDataByStageAndType(t11Stage, t11SelectMode)
  if not t11Tmp then
    return
  end
  local targetModelId = t11Tmp.hero_appearance_id
  if not targetModelId or targetModelId <= 0 then
    return
  end
  self.minionHero.modelId = targetModelId
  self.minionHero.appearanceMeta = DataCenter.AppearanceTemplateManager:GetTemplate(targetModelId)
end

function Platoon:Destroy()
  for _, v in pairs(self.minions) do
    self.logic:RemoveUnit(v)
  end
  self.minions = {}
  self.logic:RemoveUnit(self.captain)
  self.heroData = nil
  self.minionHero = nil
  Base.Destroy(self)
end

function Platoon:ChangeStage(stage)
  if stage == SkirmishStage.Load then
  elseif stage == SkirmishStage.Opening then
  end
  self.captain:ChangeStage(stage)
  for _, unit in pairs(self.minions) do
    unit:ChangeStage(stage)
  end
end

function Platoon:OnCaptainTakeDamage(curHp)
  if self.battleData.hideMinion then
    return
  end
  local targetMinionsNum = self:Hp2MinionsNum(curHp)
  local curMinionNum = #self.minions
  local needDeadNum = curMinionNum - targetMinionsNum
  for i = 1, needDeadNum do
    local minion = table.remove(self.minions, math.random(#self.minions))
    table.insert(self.deadMinions, minion)
    minion:GoDie()
  end
end

function Platoon:OnCaptainHeal(curHp)
  if self.battleData.hideMinion then
    return
  end
  local targetMinionsNum = self:Hp2MinionsNum(curHp)
  local curMinionNum = #self.minions
  local needReviveNum = targetMinionsNum - curMinionNum
  for i = 1, needReviveNum do
    local minion = table.remove(self.deadMinions)
    table.insert(self.minions, minion)
    minion:Revive()
  end
end

function Platoon:HasIndexMinion(index)
  for k, v in ipairs(self.minions) do
    if v.index == index then
      return true
    end
  end
  return false
end

function Platoon:Hp2MinionsNum(curHp)
  return math.ceil(self.sceneData.MAX_MINION_PER_HERO * curHp / self.heroData.maxHp)
end

function Platoon:StopMoving()
  self.captain:StopMoving()
  for _, unit in pairs(self.minions) do
    unit:StopMoving()
  end
  Base.StopMoving(self)
end

return Platoon
