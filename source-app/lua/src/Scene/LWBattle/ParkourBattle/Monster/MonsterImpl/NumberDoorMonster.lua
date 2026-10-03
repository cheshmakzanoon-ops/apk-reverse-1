local base = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.ColliderMonsterBase")
local NumberDoorMonster = BaseClass("NumberDoorMonster", base)
local TINY_VECTOR = Vector3.New(0, 0, 0.001)
local Resource = CS.GameEntry.Resource
local redDoorPath = "Assets/_Art_LastWar/Models/Environment/Prop/O_env_beizengmen_01/prefab/O_env_beizengmen_hong.prefab"
local blueDoorPath = "Assets/_Art_LastWar/Models/Environment/Prop/O_env_beizengmen_01/prefab/O_env_beizengmen_lan.prefab"
local redDoorPath_B = "Assets/_Art_LastWar/Models/Environment/Prop/O_env_beizengmen_01/prefab/O_env_beizengmen_hong_B.prefab"
local blueDoorPath_B = "Assets/_Art_LastWar/Models/Environment/Prop/O_env_beizengmen_01/prefab/O_env_beizengmen_lan_B.prefab"
local redDoorPath_x3 = "Assets/_Art_LastWar/Models/Environment/Prop/O_env_beizengmen_01/prefab/O_env_beizengmen_hong_x3.prefab"
local blueDoorPath_x3 = "Assets/_Art_LastWar/Models/Environment/Prop/O_env_beizengmen_01/prefab/O_env_beizengmen_lan_x3.prefab"
local scaleFrom = Vector3.New(1.25, 1.25, 1.25)
local BattleColliderUtils = CS.BattleColliderUtils
local pveUnitViewUtil = require("Scene.LWBattle.BarrageBattle.Unit.PveUnitViewUtil")

function NumberDoorMonster:Init(logic, mgr, guid, x, y, monsterMeta)
  base.Init(self, logic, mgr, guid, x, y, monsterMeta)
  self.number = monsterMeta.start_hp
  self.curBlood = 100
  self.maxBlood = 100
  self.bloodDirty = false
  self.ignoreDamage = true
  if logic and logic.parkourDoorHeroId and logic.parkourDoorHeroId > 0 then
    self.controlHeroId = logic.parkourDoorHeroId
  else
    self.controlHeroId = LuaEntry.DataConfig:TryGetNum("parkour_door_hero_id", "k1")
  end
  self.calcLocalRot = Vector3.zero
  self.initNumber = self.number
  self.initColliderRadius = monsterMeta.collide_radius
  self.bigCollider = self.initColliderRadius >= 3
  self.checkRes = {}
  self.lastNumber = {}
end

function NumberDoorMonster:SetCustomRedDoorPath(customRedDoorPath)
  self.customRedDoorPath = customRedDoorPath
end

function NumberDoorMonster:SetCustomBlueDoorPath(customBlueDoorPath)
  self.customBlueDoorPath = customBlueDoorPath
end

function NumberDoorMonster:SetCustomRedDoorX3Path(customRedDoorX3Path)
  self.customRedDoorX3Path = customRedDoorX3Path
end

function NumberDoorMonster:SetCustomBlueDoorX3Path(customBlueDoorX3Path)
  self.customBlueDoorX3Path = customBlueDoorX3Path
end

function NumberDoorMonster:DestroyData()
  base.DestroyData(self)
  self.customRedDoorPath = nil
  self.customBlueDoorPath = nil
  self.customRedDoorX3Path = nil
  self.customBlueDoorX3Path = nil
end

function NumberDoorMonster:DestroyView()
  if self.redDoorReq then
    self.redDoorReq:Destroy()
    self.redDoorReq = nil
  end
  if self.blueDoorReq then
    self.blueDoorReq:Destroy()
    self.blueDoorReq = nil
  end
  if self.sequence then
    self.sequence:Kill()
    self.sequence = nil
  end
  self.blueDoorGameObject = nil
  self.blueDoorTransform = nil
  self.redDoorGameObject = nil
  self.redDoorTransform = nil
  base.DestroyView(self)
end

function NumberDoorMonster:OnLoadComplete()
  base.OnLoadComplete(self)
  self.numberTransform = pveUnitViewUtil.InitTxtNumberText(self.viewHandle, self.number)
  local bluePath = self.bigCollider and (self.customBlueDoorX3Path or blueDoorPath_x3) or self.customBlueDoorPath or blueDoorPath_B
  self.blueDoorReq = Resource:InstantiateAsync(bluePath)
  self.blueDoorReq:completed("+", function(handle)
    if handle.isError then
      return
    end
    self.blueDoorGameObject = handle.gameObject
    self.blueDoorTransform = handle.gameObject.transform
    self.blueDoorTransform:SetParent(self.transform)
    self.blueDoorTransform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    self.blueDoorTransform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    if self.number < 0 then
      self.blueDoorGameObject:SetActive(false)
    end
  end)
  if self.number >= 0 then
    return
  end
  local redPath = self.bigCollider and (self.customRedDoorX3Path or redDoorPath_x3) or self.customRedDoorPath or redDoorPath_B
  self.redDoorReq = Resource:InstantiateAsync(redPath)
  self.redDoorReq:completed("+", function(handle)
    if handle.isError then
      return
    end
    self.redDoorGameObject = handle.gameObject
    self.redDoorTransform = handle.gameObject.transform
    self.redDoorTransform:SetParent(self.transform)
    self.redDoorTransform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    self.redDoorTransform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    if self.number >= 0 then
      self.redDoorGameObject:SetActive(false)
    end
  end)
end

function NumberDoorMonster:ComponentDefine()
  base.ComponentDefine(self)
end

function NumberDoorMonster:OnUpdate(deltaTime)
  base.OnUpdate(self, deltaTime)
  if self.bloodDirty then
    self.bloodDirty = false
    pveUnitViewUtil.SetNumberText(self.viewHandle, self.number)
  end
end

function NumberDoorMonster:BeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff)
  local last = self.number
  self.number = self.number + 1
  local cacheNumber = self.lastNumber.vvaa
  if cacheNumber then
    local cacheDiff = cacheNumber + 10000 - last
    local curDiff = self.number - last
    if -1 < cacheDiff and curDiff < 2 then
      self.checkRes.ababa = true
    else
      self.checkRes.acaca = true
      Logger.LogInfo("parkour numberDoor beAttack invalid counter : " .. cacheDiff .. "-" .. curDiff .. ". metaId : " .. self.monsterMetaId)
    end
  end
  self.lastNumber.vvaa = self.number - 10000
  self.bloodDirty = true
  if self.numberTransform and self.sequence == nil then
    local sequence = CS.DG.Tweening.DOTween.Sequence()
    self.sequence = sequence
    sequence:Append(self.numberTransform:DOScale(scaleFrom, 0.1))
    sequence:Append(self.numberTransform:DOScale(ResetScale, 0.1))
    sequence:AppendCallback(function()
      self.sequence = nil
    end)
  end
  if last < 0 and self.number >= 0 then
    if self.blueDoorGameObject then
      self.blueDoorGameObject:SetActive(true)
    end
    if self.redDoorGameObject then
      self.redDoorGameObject:SetActive(false)
    end
  end
  self.hitCounter = self.hitCounter + 1
  if self.hitCounter == 1 and self.logic and self.logic.detailLog and self.logic.bulletManager then
    local totalBullet = self.logic.bulletManager:GetTotalBulletCreate()
    local showCount = self.logic.bulletManager:GetShowBulletCount()
    Logger.LogInfo(string.format("parkour numberDoorFirstHit metaId : %s. showCount : %s. totalBullet : %s", self.monsterMetaId or 0, showCount, totalBullet))
    if self.logic.LogTeamPos then
      self.logic:LogTeamPos()
    end
  end
end

function NumberDoorMonster:AfterBeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff, skill, deathEff)
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

function NumberDoorMonster:OnCollisionViewHandle(colliderCount, startIndex, resultList)
  if 0 < colliderCount then
    if self.controlHeroId == 0 then
      return
    end
    if self.logic.CheckHasPetUnit and self.logic:CheckHasPetUnit() then
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
    PostEventLog.Track(PostEventLog.Defines.ParkourNumberDoorDeath, {
      monsterid = self.monsterMetaId,
      original_count = self.initNumber,
      count = self.hitCounter,
      remain_count = self.number
    })
    local calcValue = self.initNumber + self.hitCounter
    if self.number - calcValue > 10 and self.logic and self.logic.TryCheatCheck then
      self.logic:TryCheatCheck()
    end
    if self.logic and self.logic.TryMonsterCheatCheck then
      local checkNumber = self.initNumber + 2
      self.logic:TryMonsterCheatCheck(self.monsterMetaId, checkNumber)
    end
    if self.logic and self.logic.TryMonsterCheatOther then
      local checkNumber = self.initColliderRadius + 2
      local addHeroId = self.controlHeroId + 2
      self.logic:TryMonsterCheatOther(5, self.monsterMetaId, checkNumber, addHeroId)
      if self.checkRes.acaca then
        self.logic:TryMonsterCheatOther(5, self.monsterMetaId, checkNumber, -12)
      end
    end
    if 0 < self.number then
      if DataCenter.LWBattleManager.logic.AddMember then
        local level = tonumber(self.monsterMeta.trigger_para) or 1
        for i = 1, self.number do
          DataCenter.LWBattleManager.logic:AddMember(self.controlHeroId, level, true)
        end
      end
      if DataCenter.LWBattleManager.logic.detailLog and DataCenter.LWBattleManager.logic.GetMemberCount then
        local memberCount = DataCenter.LWBattleManager.logic:GetMemberCount()
        Logger.LogInfo("parkour numberDoor memberCount : " .. memberCount .. ". metaId : " .. self.monsterMetaId)
      end
    elseif 0 > self.number then
      local count = math.abs(self.number)
      local team = DataCenter.LWBattleManager.logic.team
      local heros = team.teamUnits
      if heros then
        local formationMaxPosCount = team.formationMaxPosCount
        if formationMaxPosCount then
          count = team:TryReduceOverflowUnit(count)
          if 0 < count then
            for i = formationMaxPosCount, 1, -1 do
              local hero = heros[i]
              if hero and hero.originalHeroId and hero.originalHeroId == self.controlHeroId and 0 < hero:GetCurBlood() then
                count = count - 1
                if hero.Die then
                  hero:Die()
                else
                  DataCenter.LWBattleManager.logic:DealMemberDie(hero)
                end
                if count <= 0 then
                  break
                end
              end
            end
          end
        end
      end
    end
    if self.logic and self.logic.detailLog then
      if self.logic.bulletManager then
        local totalBullet = self.logic.bulletManager:GetTotalBulletCreate()
        Logger.LogInfo(string.format("parkour numberDoorDeath metaId : %s. initNumber : %s. hitCounter : %s. remainCount : %s. totalBullet : %s", self.monsterMetaId or 0, self.initNumber, self.hitCounter, self.number, totalBullet))
      end
      if self.logic.LogTeamPos then
        self.logic:LogTeamPos()
      end
    end
    self:Death()
  end
end

function NumberDoorMonster:Death()
  if self.heroEffectMeta then
    local effectMeta = self.heroEffectMeta
    local effectAdd = effectMeta.death_effect_blue
    local effectReduce = effectMeta.death_effect_red
    local curDisperseEffect = self.number >= 0 and effectAdd or effectReduce
    if not string.IsNullOrEmpty(curDisperseEffect) then
      self.logic:ShowEffectObj(curDisperseEffect, self:GetPosition())
    elseif not string.IsNullOrEmpty(effectMeta.death_effect_nomal) then
      self.logic:ShowEffectObj(effectMeta.death_effect_nomal, hitPoint, nil, nil)
    end
    if 0 < effectMeta.sound_id_dead then
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

return NumberDoorMonster
