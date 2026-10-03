local Const = require("Scene.LWBattle.Const")
local ZombieStateDie = BaseClass("ZombieStateDie")

function ZombieStateDie:__init(zombie)
  self.zombie = zombie
  self.animLength = self.zombie:GetAnimLength(MemberAnim.Dead)
  self.animLength = self.animLength > 0 and self.animLength or 2
end

function ZombieStateDie:__delete()
  self.zombie = nil
  self.animLength = nil
  self.countdown = nil
end

function ZombieStateDie:OnEnter()
  self.zombie:RemoveDestination()
  self.zombie:PlaySimpleAnim(ZombieAnim.Dead, 1)
  self.zombie.battleMgr:OnMonsterDeath(self.zombie)
  self.countdown = self.animLength
end

function ZombieStateDie:OnExit()
end

function ZombieStateDie:OnUpdate()
  if self.countdown then
    self.countdown = self.countdown - Time.deltaTime
    if self.countdown < 0 then
      self.zombie.battleMgr:RemoveUnit(self.zombie)
      self.countdown = nil
    end
  end
end

return ZombieStateDie
