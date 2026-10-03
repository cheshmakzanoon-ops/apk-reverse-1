local FSMachine = require("Common.FSMachine")
local State = {}
State.__index = State
setmetatable(State, FSMachine.State)
local Resource = CS.GameEntry.Resource
local Const = require("DataCenter/T11IdleGame/IdleBattle/T11IdleGameIdleBattleConstant")
local speed = Vector3.zero

function State.Create()
  local copy = {}
  setmetatable(copy, State)
  copy:Init()
  return copy
end

function State:Init()
end

function State:OnUpdate(deltaTime)
  local owner = self.owner
  if not owner then
    return
  end
  if not self.hasBullet then
    return
  end
  if not self.curCD then
    return
  end
  if self.curWaveIndex > Const.NodeBattleFireWave then
    return
  end
  if self.curCD >= 0 then
    self.curCD = self.curCD - deltaTime
    if self.curCD < 0 then
      local isFirstBullet = self.curBulletIndex % Const.NodeBattleSoldierBulletCount == 1
      if isFirstBullet then
        owner:PlayAnim("idle_game_attack")
      end
      owner:TryPlayFireSound(self.curBulletIndex)
      local startPos = owner:GetFirePoint().position
      local monsterPos = self.monster:GetHitPosition()
      local targetPos = Vector3.New(monsterPos.x, startPos.y, monsterPos.z)
      owner:FireBullet(self.bulletMeta.bullet_effect, startPos, targetPos, self.bulletMeta.bullet_fly_speed, function()
        if isFirstBullet and self.monster then
          self.monster:BeHit()
        end
      end)
      if self.curBulletIndex % Const.NodeBattleSoldierBulletCount == 0 then
        self.maxCD = Const.NodeBattleSoldierSkillCD2
        self.curWaveIndex = self.curWaveIndex + 1
      else
        self.maxCD = Const.NodeBattleSoldierSkillCD1
      end
      self.curCD = self.maxCD
      self.curBulletIndex = self.curBulletIndex + 1
    end
  end
end

function State:OnExit()
  self.skillMeta = nil
  self.bulletMeta = nil
  self.hasBullet = nil
  local owner = self.owner
  if owner then
    owner:SetSoldierForward(180)
  end
end

function State:OnEnter(monster)
  local owner = self.owner
  if not owner then
    return
  end
  self.monster = monster
  self.curCD = Const.NodeBattleSoldierSkillPreCD
  self.maxCD = Const.NodeBattleSoldierSkillCD1
  self.curBulletIndex = 1
  self.curWaveIndex = 1
  self.skillMeta = owner:GetSkillMeta()
  self.bulletMeta = nil
  if self.skillMeta.bullet > 0 then
    self.bulletMeta = DataCenter.PveBulletTemplateManager:GetTemplate(self.skillMeta.bullet)
  end
  self.hasBullet = self.bulletMeta ~= nil
  owner:SetSoldierLookAt(self.monster:GetHitPosition())
end

function State:Dispose()
  self.unit = nil
  self.skill = nil
  self.bulletMeta = nil
  self.hasBullet = nil
end

return State
