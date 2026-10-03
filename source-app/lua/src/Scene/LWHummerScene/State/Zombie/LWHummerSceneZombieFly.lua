local FSMachine = require("Common.FSMachine")
local State = {}
State.__index = State
setmetatable(State, FSMachine.State)
local Constant = require("Scene.LWHummerScene.LWHummerSceneConstant")
local animName = "fly"

function State.Create()
  local copy = {}
  setmetatable(copy, State)
  copy:Init()
  return copy
end

function State:Init()
end

function State:OnEnter()
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
  self.effectMeta = self.owner.effectMeta
  if self.effectMeta and 0 < self.effectMeta.sound_id_dead then
    DataCenter.LWSoundManager:PlaySoundWithLimit(self.effectMeta.sound_id_dead, SoundLimitType.UnitDeath)
  end
  self.flyTime, self.zombieFlyDistance = self.owner.logic.data:GetZombieFlyData()
  local random = math.random(0, 1)
  if self.owner:GetPosition().z > self.owner.logic.player:GetPosition().z then
    self.normalized = Vector3.Lerp(Vector3.forward, -self.owner.transform.forward, random)
  else
    self.normalized = Vector3.Lerp(-Vector3.forward, -self.owner.transform.forward, random)
  end
  self.beginPos = self.owner:GetPosition()
  self.targetPos = self.beginPos + self.normalized * self.zombieFlyDistance
  self.flyDelay = self.flyTime
end

function State:OnExit()
end

function State:OnUpdate(deltaTime)
  if self.flyDelay then
    self.flyDelay = self.flyDelay - deltaTime
    if self.flyDelay <= 0 then
      self.owner:SetPosition(self.targetPos.x, self.targetPos.z)
      if self.effectMeta then
        local bloodEffect = self.effectMeta:GetRandomBlood()
        if bloodEffect then
          self.owner:PlayReplayableEffect(bloodEffect, self.targetPos, nil, Constant.DEATH_BLOOD_TIME, nil, EffectObjType.Sprite)
        end
      end
      self.flyDelay = nil
    else
      local pos = Vector3.Lerp(self.beginPos, self.targetPos, self.flyTime - self.flyDelay)
      self.owner:SetPosition(pos.x, pos.z)
    end
  end
  if self.dropDelay then
    self.dropDelay = self.dropDelay - deltaTime
    if 0 >= self.dropDelay then
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
