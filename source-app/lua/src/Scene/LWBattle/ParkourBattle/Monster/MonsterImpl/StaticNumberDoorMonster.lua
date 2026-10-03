local base = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.ColliderMonsterBase")
local StaticNumberDoorMonster = BaseClass("StaticNumberDoorMonster", base)
local TINY_VECTOR = Vector3.New(0, 0, 0.001)
local BattleColliderUtils = CS.BattleColliderUtils

function StaticNumberDoorMonster:Init(logic, mgr, guid, x, y, monsterMeta)
  base.Init(self, logic, mgr, guid, x, y, monsterMeta)
  self.curBlood = 100
  self.maxBlood = 100
  if logic and logic.parkourDoorHeroId and logic.parkourDoorHeroId > 0 then
    self.controlHeroId = logic.parkourDoorHeroId
  else
    self.controlHeroId = LuaEntry.DataConfig:TryGetNum("parkour_door_hero_id", "k1")
  end
  self.initColliderRadius = monsterMeta.collide_radius
end

function StaticNumberDoorMonster:BeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff)
end

function StaticNumberDoorMonster:AfterBeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff, skill, deathEff)
  if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) and self.afterBeAttackDone then
    return
  end
  if self.heroEffectMeta then
    local effectMeta = self.heroEffectMeta
    if (self.logic.lowQualityMode == nil or self.logic.lowQualityMode == false) and not string.IsNullOrEmpty(effectMeta.hit_effect) then
      if self.logic.ShowHitEffectForViewTarget then
        self.logic:ShowHitEffectForViewTarget(effectMeta.hit_effect, hitPoint, hitDir, effectMeta.hit_effect_direction or 2, 0.4, self.viewHandle)
      else
        local quaternion
        if hitDir then
          if Vector3.SqrMagnitude(hitDir) < 1.0E-8 then
            hitDir = TINY_VECTOR
          end
          local localRot = self.transform:InverseTransformDirection(hitDir)
          self.calcLocalRot.x = localRot.x
          self.calcLocalRot.y = localRot.y
          self.calcLocalRot.z = localRot.z
          if effectMeta.hit_effect_direction == 1 then
            quaternion = Quaternion.LookRotation(self.calcLocalRot)
          elseif effectMeta.hit_effect_direction == 2 then
            quaternion = Quaternion.LookRotation(-self.calcLocalRot)
          end
        end
        local localPos = BattleColliderUtils.GetInverseTransformPoint(self.transform, hitPoint.x, hitPoint.y, hitPoint.z)
        self.logic:ShowEffectObj(effectMeta.hit_effect, localPos, quaternion, nil, self.transform)
      end
    end
    if effectMeta.hitVibrateParam and #effectMeta.hitVibrateParam == 3 and self.logic.DoVibration then
      self.logic:DoVibration(effectMeta.hitVibrateParam[1], effectMeta.hitVibrateParam[2], effectMeta.hitVibrateParam[3])
    end
  end
  self.afterBeAttackDone = true
end

function StaticNumberDoorMonster:OnCollisionViewHandle(colliderCount, startIndex, resultList)
  if 0 < colliderCount then
    if self.controlHeroId == 0 then
      return
    end
    if self.logic:CheckHasPetUnit() then
      local collideValid = false
      for i = 1, colliderCount do
        local index = startIndex + i
        local targetObjId = resultList[index]
        local isPet = self.logic:CheckIsPetUnit(targetObjId)
        if not isPet then
          collideValid = true
          break
        end
      end
      if not collideValid then
        return
      end
    end
    PostEventLog.Track(PostEventLog.Defines.ParkourStaticNumberDoorDeath, {
      monsterid = self.monsterMetaId
    })
    if self.logic and self.logic.TryMonsterCheatOther then
      local checkNumber = self.initColliderRadius + 2
      local addHeroId = self.controlHeroId + 2
      self.logic:TryMonsterCheatOther(5, self.monsterMetaId, checkNumber, addHeroId)
    end
    local level = tonumber(self.monsterMeta.trigger_para) or 1
    DataCenter.LWBattleManager.logic:AddMember(self.controlHeroId, level, true)
    if DataCenter.LWBattleManager.logic.detailLog and DataCenter.LWBattleManager.logic.GetMemberCount then
      local memberCount = DataCenter.LWBattleManager.logic:GetMemberCount()
      Logger.LogInfo("parkour staticNumberDoor memberCount : " .. memberCount .. ". metaId : " .. self.monsterMetaId)
    end
    self:Death()
  end
end

function StaticNumberDoorMonster:Death()
  if self.heroEffectMeta then
    local effectMeta = self.heroEffectMeta
    local effectAdd = effectMeta.death_effect_blue
    if not string.IsNullOrEmpty(effectAdd) then
      self.logic:ShowEffectObj(effectAdd, self:GetPosition())
    elseif not string.IsNullOrEmpty(effectMeta.death_effect_nomal) then
      self.logic:ShowEffectObj(effectMeta.death_effect_nomal, hitPoint, nil, nil)
    end
    if effectMeta.sound_id_dead > 0 then
      DataCenter.LWSoundManager:PlaySoundWithLimit(effectMeta.sound_id_dead, SoundLimitType.UnitDeath)
    end
    local bloodEffect = effectMeta:GetRandomBlood()
    if bloodEffect then
      self.logic:ShowEffectObj(bloodEffect, self:GetPosition(), nil, DEATH_BLOOD_TIME, nil, EffectObjType.Sprite)
    end
    if effectMeta.deathShakeParam then
      self.logic:ShakeCameraWithParam(effectMeta.deathShakeParam)
    end
    if effectMeta.deathVibrateParam and #effectMeta.deathVibrateParam == 3 and self.logic.DoVibration then
      self.logic:DoVibration(effectMeta.deathVibrateParam[1], effectMeta.deathVibrateParam[2], effectMeta.deathVibrateParam[3])
    end
  end
  base.Death(self)
end

return StaticNumberDoorMonster
