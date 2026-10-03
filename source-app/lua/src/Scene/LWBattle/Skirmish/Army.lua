local Resource = CS.GameEntry.Resource
local GameObject = CS.UnityEngine.GameObject
local Army = BaseClass("Army")
local FSM = require("Framework.Common.FSM")
local Platoon = require("Scene.LWBattle.Skirmish.Platoon")
local PetPlatoon = require("Scene.LWBattle.Skirmish.PetPlatoon")
local TacticalWeaponUnit = require("Scene.LWBattle.Skirmish.Unit.TacticalWeaponUnit")
local MoveStatePath = require("Scene.LWBattle.Skirmish.ArmyFSM.MoveStatePath")
local MoveStateStay = require("Scene.LWBattle.Skirmish.ArmyFSM.MoveStateStay")
local MailBattleParseHelper = require("DataCenter.MailData.MailBattleParseHelper")

function Army:__init(logic, index)
  local go = GameObject("ArmyRoot")
  self.gameObject = go
  self.transform = go.transform
  self.logic = logic
  self.sceneData = self.logic.sceneData
  self.battleData = self.logic.battleData
  self.index = index
  self.dirMultiplier = 1
  if index == 2 then
    self.transform:Set_eulerAngles(0, 180, 0)
    self.dirMultiplier = -1
  end
  self.curPos = Vector3.zero
  local pos = self.sceneData.armyBirthPos[index]
  self:SetPosition(pos.x, pos.z)
  self:CreatePlatoon()
  self:CreateTacticalWeapon()
  self:InitFSM()
end

function Army:__delete()
  self:Destroy()
end

function Army:CreatePlatoon()
  self.platoons = {}
  self.platoonsIndexList = {}
  self.deadPlatoons = {}
  local initShowStates = {}
  local hasFunction = self.logic ~= nil and self.logic.UnitHaveOpenningSkill ~= nil
  for index, _ in pairs(self.battleData.heroData) do
    if self.battleData.IsArmyHero(self.index, index) then
      local initShowState = true
      if hasFunction then
        initShowState = not self.logic:UnitHaveOpenningSkill(index)
      end
      self.platoons[index] = Platoon.New(self.logic, self, index, initShowState)
      table.insert(self.platoonsIndexList, index)
    end
  end
end

function Army:CreateTacticalWeapon()
  if self.index == 1 and self.battleData.weaponData[11] ~= nil then
    self.tacticalWeapon = ObjectPool:GetInstance():Load(TacticalWeaponUnit)
    self.tacticalWeapon:Init(self.logic, self, self.battleData.weaponData[11], 11)
  end
  if self.index == 2 and self.battleData.weaponData[12] ~= nil then
    self.tacticalWeapon = ObjectPool:GetInstance():Load(TacticalWeaponUnit)
    self.tacticalWeapon:Init(self.logic, self, self.battleData.weaponData[12], 12)
  end
end

function Army:OnUpdate()
  if self.fsm then
    self.fsm:OnUpdate()
  end
end

function Army:Destroy()
  if self.gameObject then
    CS.UnityEngine.GameObject.Destroy(self.gameObject)
    self.gameObject = nil
    self.transform = nil
  end
  self.logic = nil
  self.sceneData = nil
  self.battleData = nil
  self.index = nil
  self.curPos = nil
end

function Army:InitFSM()
  self.fsm = FSM.New()
  self.fsm:AddState(SkirmishMoveState.Path, MoveStatePath.New(self))
  self.fsm:AddState(SkirmishMoveState.Stay, MoveStateStay.New(self))
  self.fsm:ChangeState(SkirmishMoveState.Stay)
end

function Army:SetPosition(x, z)
  self.curPos.x = x
  self.curPos.z = z
  self.transform:Set_position(x, 0, z)
end

function Army:GetPosition()
  return self.curPos
end

function Army:ChangeStage(stage)
  if stage == SkirmishStage.Load then
  elseif stage == SkirmishStage.Opening then
    local destinationQueue = {}
    table.insert(destinationQueue, self.sceneData.armyEndPos[self.index])
    self.fsm:ChangeState(SkirmishMoveState.Path, destinationQueue)
  elseif stage == SkirmishStage.Fight then
  end
  for _, platoon in pairs(self.platoons) do
    platoon:ChangeStage(stage)
  end
  if self.tacticalWeapon then
    self.tacticalWeapon:ChangeStage(stage)
  end
end

function Army:GetMoveVelocity()
  if self.fsm and self.fsm:GetStateIndex() == SkirmishMoveState.Path then
    return Vector3.New(0, 0, self:GetMoveSpeed() * self.dirMultiplier)
  else
    return Vector3.zero
  end
end

function Army:GetMoveSpeed()
  return self.sceneData.MOVE_SPEED
end

function Army:OnCaptainDie(index)
  self.deadPlatoons[index] = self.platoons[index]
  self.platoons[index] = nil
  table.removebyvalue(self.platoonsIndexList, index)
end

function Army:OnCaptainRevive(index)
  self.platoons[index] = self.deadPlatoons[index]
  self.deadPlatoons[index] = nil
  table.insert(self.platoonsIndexList, index)
end

function Army:GetRandomPosition()
  if #self.platoonsIndexList > 0 then
    local randIndex = table.randomArrayValue(self.platoonsIndexList)
    return self.platoons[randIndex]:GetPosition() + Vector3.New(math.random(-2, 2), 0, math.random(-2, 2))
  else
    return self:GetPosition() + Vector3.New(math.random(-2, 2), 0, math.random(-2, 2))
  end
end

function Army:OnLose()
end

function Army:GetZeroWorldPos()
  if not IsNull(self.transform) then
    if not self._cachePos then
      self._cachePos = Vector3.zero
    end
    self._cachePos.x, self._cachePos.y, self._cachePos.z = self.transform:Get_position()
    return self._cachePos
  end
  return Vector3.zero
end

function Army:CreatePet(unit)
  if not unit then
    return
  end
  local hasFunction = self.logic ~= nil and self.logic.UnitHaveOpenningSkill ~= nil
  local index = unit.index
  unit.maxSoldierCount = 1
  unit.soldierCount = 1
  if not MailBattleParseHelper.DecodeSingleLWBattleHero(unit) then
    Logger.LogError("CreatePet DecodeSingleLWBattleHero failed")
    return
  end
  if self.index == 1 and index <= 5 or self.index == 2 and 5 < index then
    local initShowState = true
    if hasFunction then
      initShowState = not self.logic:UnitHaveOpenningSkill(index)
    end
    self.platoons[index] = PetPlatoon.New(self.logic, self, index, initShowState, unit)
    table.insert(self.platoonsIndexList, index)
  end
end

function Army:GetRootTransform()
  return self.transform
end

return Army
