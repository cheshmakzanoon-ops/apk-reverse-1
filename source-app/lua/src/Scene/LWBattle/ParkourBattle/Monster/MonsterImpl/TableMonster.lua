local base = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.ColliderMonsterBase")
local TableMonster = BaseClass("TableMonster", base)
local TriggerEnum = require("Scene.LWBattle.ParkourBattle.TriggerEvent.TriggerEnum")
local MonsterEnergyBarCell = require("DataCenter.ZombieBattle.HpBar.MonsterEnergyBarCell")
local pveUnitViewUtil = require("Scene.LWBattle.BarrageBattle.Unit.PveUnitViewUtil")
local BattleColliderUtils = CS.BattleColliderUtils

function TableMonster:Init(logic, mgr, guid, x, y, monsterMeta)
  base.Init(self, logic, mgr, guid, x, y, monsterMeta)
  self.triggerMeta = DataCenter.LWTriggerItemTemplateManager:GetTemplate(self.deathEvent)
  self:PreSelectHeroUuid()
  self.delayAnim = nil
  self.hitLength = nil
  self.delayRemoveAnim = nil
  self.deathLength = nil
  self.bloodDirty = false
  self.effectByBuff = true
end

function TableMonster:DestroyData()
  self.preSelectHeroUuid = nil
  self.triggerMeta = nil
  if self.delayAnim then
    self.delayAnim:Stop()
    self.delayAnim = nil
  end
  if self.delayRemoveAnim then
    self.delayRemoveAnim:Stop()
    self.delayRemoveAnim = nil
  end
  self.anim = nil
  self.deathPlaying = nil
  base.DestroyData(self)
end

function TableMonster:DestroyView()
  if not IsNull(self.nodeGo) then
    self.nodeGo:SetActive(true)
  end
  self:HideEnergyBar()
  base.DestroyView(self)
end

function TableMonster:PreSelectHeroUuid()
  if self.preSelectHeroUuid then
    return
  end
  if not self.triggerMeta then
    return
  end
  local triggerType = self.triggerMeta.type
  self.triggerType = triggerType
  if triggerType == TriggerEnum.EventType.AddSingleHeroSkill or triggerType == TriggerEnum.EventType.AddSingleHeroBuff or triggerType == TriggerEnum.EventType.ReplaceSingleHeroNormalAttack then
    if DataCenter.LWBattleManager.logic.GetRandomInitUuid then
      self.preSelectHeroUuid = DataCenter.LWBattleManager.logic:GetRandomInitUuid()
    end
  elseif triggerType == TriggerEnum.EventType.ReplaceHeroIdNormalAttack or triggerType == TriggerEnum.EventType.ReplaceHeroIdNormalAttackWithoutInterrupt or triggerType == TriggerEnum.EventType.ReplaceHeroIdActiveAttackWithoutInterrupt then
    local para = self.triggerMeta.para
    if not string.IsNullOrEmpty(para) then
      local paraList = string.split(para, "|")
      if #paraList == 2 then
        self.preSelectHeroUuid = tonumber(paraList[1]) or 0
      end
    end
  elseif triggerType == TriggerEnum.EventType.ReplaceHeroIdAppearance or triggerType == TriggerEnum.EventType.ReplaceHeroIdAppearanceSaveLv then
    local para = self.triggerMeta.para
    if not string.IsNullOrEmpty(para) then
      local paraList = string.split(para, "|")
      if #paraList == 2 then
        self.preSelectHeroUuid = tonumber(paraList[1]) or 0
      end
    end
  elseif triggerType == TriggerEnum.EventType.AddEnergy then
    local para = self.triggerMeta.para
    local index = tonumber(para) or 0
    if 0 < index and DataCenter.LWBattleManager.logic.GetInitUuidAuto then
      self.preSelectHeroUuid = DataCenter.LWBattleManager.logic:GetInitUuidAuto(index)
    end
  elseif triggerType == TriggerEnum.EventType.ThreeChoices then
    local triggerCount = self.triggerMeta.paraArray and #self.triggerMeta.paraArray or 0
    if 0 < triggerCount and DataCenter.LWBattleManager.logic.GetRandomInitUuid then
      self.preSelectHeroUuid = {}
      for i = 1, triggerCount do
        table.insert(self.preSelectHeroUuid, DataCenter.LWBattleManager.logic:GetRandomInitUuid())
      end
    end
  elseif triggerType == TriggerEnum.EventType.AddHero then
    self.preSelectHeroUuid = tonumber(self.monsterMeta.trigger_para) or 1
  elseif triggerType == TriggerEnum.EventType.AddHeroIdEnergy then
    local para = self.triggerMeta.para
    local heroId, index
    if not string.IsNullOrEmpty(para) then
      local paraList = string.split(para, "|")
      heroId = tonumber(paraList[1])
      index = tonumber(paraList[2])
      if heroId and index == nil then
        index = 1
      end
    end
    if heroId and index and DataCenter.LWBattleManager.logic.GetInitUuidByHeroIdOrIndex then
      self.preSelectHeroUuid = DataCenter.LWBattleManager.logic:GetInitUuidByHeroIdOrIndex(heroId, index)
    end
  end
end

function TableMonster:OnLoadComplete()
  base.OnLoadComplete(self)
  pveUnitViewUtil.InitHpText(self.viewHandle, math.ceil(self.curBlood))
  local nodeTrans = self.transform:Find("Node")
  if nodeTrans then
    self.nodeGo = nodeTrans.gameObject
  end
  self:ShowHead()
end

function TableMonster:ComponentDefine()
  base.ComponentDefine(self)
  if not self.anim then
    self.anim = self.gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
  end
end

function TableMonster:OnUpdate(deltaTime)
  base.OnUpdate(self, deltaTime)
  if self.bloodDirty then
    self.bloodDirty = false
    pveUnitViewUtil.SetNumberHpText(self.viewHandle, math.ceil(self.curBlood))
  end
end

function TableMonster:UpdateReversePos(deltaTime)
  if self.deathPlaying then
    return
  end
  base.UpdateReversePos(self, deltaTime)
end

function TableMonster:BeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, dir)
  base.BeAttack(self, hurt, hitPoint, hitDir, whiteTime, stiffTime, dir)
  if hurt ~= 0 then
    self.bloodDirty = true
  end
  if 0 >= self.curBlood then
    if 100 < hurt and self.logic and self.logic.TryCheatCheck then
      self.logic:TryCheatCheck()
    end
    if self.logic and self.logic.TryMonsterCheatCheck then
      local checkNumber = self.maxBlood + 2
      self.logic:TryMonsterCheatCheck(self.monsterMetaId, checkNumber)
    end
  end
end

function TableMonster:Death()
  self:HideEnergyBar()
  BattleColliderUtils.RemoveMonsterCollider(self.guid)
  if self.heroEffectMeta then
    local death_action = self.heroEffectMeta.death_action
    if not string.IsNullOrEmpty(death_action) then
      if self.delayRemoveAnim == nil then
        if self.deathLength == nil then
          self.deathLength = self:GetAnimLength(death_action)
        end
        if self.deathLength > 0 then
          self:RewindAndPlaySimpleAnim(death_action)
          self.delayRemoveAnim = TimerManager:GetInstance():DelayInvoke(function()
            self.delayRemoveAnim = nil
            if self.mgr then
              self.mgr:RemoveMonster(self.guid)
            end
          end, self.deathLength)
          if self.delayAnim then
            self.delayAnim:Stop()
            self.delayAnim = nil
          end
          pveUnitViewUtil.NumberHpTextActive(self.viewHandle, false)
          if not IsNull(self.nodeGo) then
            self.nodeGo:SetActive(false)
          end
          self.deathPlaying = true
        else
          base.Death(self)
          return
        end
      end
      return
    end
  end
  base.Death(self)
end

function TableMonster:AfterBeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff, skill, deathEff)
  if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) and self.afterBeAttackDone then
    return
  end
  base.AfterBeAttack(self, hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff, skill, deathEff)
  if self.heroEffectMeta and self.curBlood > 0 then
    local hit_action = self.heroEffectMeta.hit_action
    if not string.IsNullOrEmpty(hit_action) then
      if self.hitLength == nil then
        self.hitLength = self:GetAnimLength(hit_action)
      end
      if 0 < self.hitLength then
        self:RewindAndPlaySimpleAnim(hit_action)
        if self.delayAnim == nil then
          self.delayAnim = TimerManager:GetInstance():DelayInvoke(function()
            self.delayAnim = nil
            self:PlaySimpleAnim(self:GetDefaultAnimName())
          end, self.hitLength)
        else
          self.delayAnim:Reset()
        end
        pveUnitViewUtil.ShowHpTweenScale(self.viewHandle)
      end
    end
  end
  self.afterBeAttackDone = true
end

function TableMonster:ShowHead()
  if self.meta and self.meta.headshot_show and (self.triggerType == TriggerEnum.EventType.AddEnergy or self.triggerType == TriggerEnum.EventType.AddHeroIdEnergy) and self.preSelectHeroUuid then
    local heroData = DataCenter.BattleLevel:GetPveHeroData(self.preSelectHeroUuid)
    assert(heroData ~= nil, "TableMonster.ShowHead heroData is nil ! heroUuid : " .. self.preSelectHeroUuid)
    self.headIcon = HeroUtils.GetHeroIconPath(heroData.modelId, HeroIconType.small_icon, heroData:GetSkinId())
    local heroConfig = DataCenter.HeroTemplateManager:GetTemplate(heroData.heroId)
    if heroConfig ~= nil then
      local quality = heroConfig.quality
      self.qualityIcon = HeroUtils.GetQualityIconPath(quality, false)
    end
    if not self.energyBar then
      self.energyBar = MonsterEnergyBarCell.New()
      self.energyBar:Load(self.headIcon, self.qualityIcon, self.transform, 3.5)
    end
  end
end

function TableMonster:HideEnergyBar()
  if self.energyBar then
    self.energyBar:Delete()
    self.energyBar = nil
  end
end

function TableMonster:TriggerEvent(eventId, extra)
  if eventId then
    local meta = DataCenter.LWTriggerItemTemplateManager:GetTemplate(eventId)
    if meta then
      if meta.type == TriggerEnum.EventType.AddEnergy or meta.type == TriggerEnum.EventType.AddHeroIdEnergy then
        local extraData = {}
        extraData.extra = extra
        extraData.fromPos = self:GetPosition()
        DataCenter.LWBattleManager.logic.triggerEventMgr:Trigger(meta.type, meta, extraData, self.monsterMetaId)
      elseif meta.type == TriggerEnum.EventType.SummonMonsterBatch then
        local summonMonsterBatchData = meta.summonMonsterBatchData
        if summonMonsterBatchData ~= nil and #summonMonsterBatchData == 4 then
          local extraData = {}
          extraData.fromPos = self:GetPosition()
          extraData.monsterMeta = self.meta
          extraData.hp = self.maxBlood * summonMonsterBatchData[4]
          extraData.summonMonsterId = summonMonsterBatchData[1]
          extraData.summonCount = summonMonsterBatchData[2]
          extraData.posOffset = summonMonsterBatchData[3]
          DataCenter.LWBattleManager.logic.triggerEventMgr:Trigger(meta.type, meta, extraData, self.monsterMetaId)
        end
      elseif meta.type == TriggerEnum.EventType.SummonFriendlyPet then
        local extraData = {}
        local pos = self:GetPosition()
        extraData.fromPos = Vector3.New(pos.x, pos.y, pos.z)
        DataCenter.LWBattleManager.logic.triggerEventMgr:Trigger(meta.type, meta, extraData, self.monsterMetaId)
      else
        DataCenter.LWBattleManager.logic.triggerEventMgr:Trigger(meta.type, meta, extra, self.monsterMetaId)
      end
    end
  end
end

return TableMonster
