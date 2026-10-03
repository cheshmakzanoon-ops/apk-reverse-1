local T11IdleGameBossBattleSoldierStateFire = BaseClass("T11IdleGameBossBattleSoldierStateFire")
local Const = require("DataCenter/T11IdleGame/IdleBattle/T11IdleGameIdleBattleConstant")
local speed = Vector3.zero

function T11IdleGameBossBattleSoldierStateFire:__init(owner)
  self.owner = owner
  self.boss = nil
  self.hitIndex = nil
end

function T11IdleGameBossBattleSoldierStateFire:__delete()
  self.owner = nil
  self.hitIndex = nil
end

function T11IdleGameBossBattleSoldierStateFire:OnEnter(boss, hitIndex)
  self.boss = boss
  self.hitIndex = hitIndex
  self.curCD = Const.BossBattleSoldierSkillPreCD
  self.maxCD = Const.NodeBattleSoldierSkillCD1
  self.curBulletIndex = 1
  self.curWaveIndex = 1
  self.skillMeta = self.owner:GetSkillMeta()
  self.bulletMeta = nil
  if self.skillMeta.bullet > 0 then
    self.bulletMeta = DataCenter.PveBulletTemplateManager:GetTemplate(self.skillMeta.bullet)
  end
  self.hasBullet = self.bulletMeta ~= nil
  self.owner:SetSoldierLookAt(self.boss:GetHitPosition(self.hitIndex))
end

function T11IdleGameBossBattleSoldierStateFire:OnExit()
  self.skillMeta = nil
  self.bulletMeta = nil
  self.owner:SetSoldierForward(0)
end

function T11IdleGameBossBattleSoldierStateFire:OnUpdate(deltaTime)
  if not self.owner then
    return
  end
  if not self.boss then
    return
  end
  if not self.hasBullet then
    return
  end
  if self.curWaveIndex > Const.BossBattleFireWave then
    return
  end
  if self.curCD >= 0 then
    self.curCD = self.curCD - deltaTime
    if self.curCD < 0 then
      local isFirstBullet = self.curBulletIndex % Const.NodeBattleSoldierBulletCount == 1
      if isFirstBullet then
        self.owner:PlayAnim("idle_game_attack")
      end
      self.owner:TryPlayFireSound(self.curBulletIndex)
      local startPos = self.owner:GetFirePoint().position
      local monsterPos = self.boss:GetHitPosition(self.hitIndex)
      local targetPos = Vector3.New(monsterPos.x, monsterPos.y, monsterPos.z)
      local isFinalWave = self.curWaveIndex == Const.BossBattleFireWave
      self.owner:FireBullet(self.bulletMeta.bullet_effect, startPos, targetPos, self.bulletMeta.bullet_fly_speed, function()
        if isFirstBullet and self.boss then
          self.boss:BeHit(isFinalWave)
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

function T11IdleGameBossBattleSoldierStateFire:Dispose()
end

return T11IdleGameBossBattleSoldierStateFire
