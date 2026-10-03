local FSMachine = require("Common.FSMachine")
local State = {}
State.__index = State
setmetatable(State, FSMachine.State)
local Constant = require("Scene.LWHummerScene.LWHummerSceneConstant")

function State.Create()
  local copy = {}
  setmetatable(copy, State)
  copy:Init()
  return copy
end

function State:Init()
end

function State:OnEnter()
  self.owner:OnChangeDropParent()
  local animName = self.owner.AnimType.Drop[self.owner.targetTransDirType]
  self.animLength = self.owner:GetAnimLength(animName)
  self.animLength = self.animLength > 0 and self.animLength or 2
  self.owner:RemoveDestination()
  self.owner:PlaySimpleAnim(animName, 1)
  self.countdown = self.animLength
  if self.owner.showRewardDrop then
    self.dropDelay = Constant.DROP_DELAY_TIME
  else
    self.dropDelay = nil
  end
  local effectMeta = self.owner.effectMeta
  if effectMeta then
    if 0 < effectMeta.sound_id_dead then
      DataCenter.LWSoundManager:PlaySoundWithLimit(effectMeta.sound_id_dead, SoundLimitType.UnitDeath)
    end
    local bloodEffect = effectMeta:GetRandomBlood()
    if bloodEffect then
      self.owner:PlayReplayableEffect(bloodEffect, self.owner:GetPosition(), nil, Constant.DEATH_BLOOD_TIME, nil, EffectObjType.Sprite)
    end
  end
  self.owner.logic:RemoveOneJumpZombieSpeedBuff(self.owner)
end

function State:OnExit()
end

function State:OnUpdate(deltaTime)
  if self.dropDelay then
    self.dropDelay = self.dropDelay - deltaTime
    if self.dropDelay <= 0 then
      self.owner.logic:AddDrop(self.owner:GetPosition())
      self.dropDelay = nil
    end
  end
  if self.countdown then
    self.countdown = self.countdown - deltaTime
    if 0 > self.countdown then
      self.owner.logic:RemoveUnit(self.owner)
      self.countdown = nil
    end
  end
end

return State
