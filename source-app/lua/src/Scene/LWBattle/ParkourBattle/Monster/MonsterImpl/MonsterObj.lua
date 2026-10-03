local base = require("Scene.LWBattle.ParkourBattle.ParkourUnit")
local MonsterObj = BaseClass("MonsterObj", base)
local Resource = CS.GameEntry.Resource
local Const = require("Scene.LWBattle.Const")
local VIEW_INVALID_HANDLE = -1
local pveUnitViewUtil = require("Scene.LWBattle.BarrageBattle.Unit.PveUnitViewUtil")
local UnitViewFacade = CS.PVEBattleLogic.Unit.UnitViewFacade

function MonsterObj:Init(logic, mgr, guid, x, y, monsterMeta)
  base.Init(self, logic)
  self.mgr = mgr
  self.battleMgr = mgr.logic
  self.guid = guid
  self.x = x
  self.metaY = y
  self.y = y
  self.realY = 0
  self.curWorldPos = Vector3.New(x, self.realY, self.y)
  self.monsterMeta = monsterMeta
  self.meta = monsterMeta
  if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) then
    self.monsterProperty = self.monsterMeta.property
  end
  if monsterMeta.monster_effect then
    self.heroEffectMeta = DataCenter.PveHeroEffectTemplateManager:GetTemplate(monsterMeta.monster_effect)
  end
  self.curBlood = self:GetRawProperty(HeroEffectDefine.HealthPoint) * (1 + self:GetRawProperty(HeroEffectDefine.HpAddRate))
  self.maxBlood = self.curBlood
  self.type = Const.ParkourUnitType.Monster
  self.unitType = self.monsterMeta.monster_type == Const.MonsterType.Junk and UnitType.Junk or UnitType.Zombie
  self.searchType = self.monsterMeta.monster_type == Const.MonsterType.Junk and UnitType.Junk or UnitType.Zombie
  self:ProcessBuff(monsterMeta)
  self.eulerY = 0
  self.layer = -1
  self.monsterMetaId = monsterMeta.id or -1
  self.hitCounter = 0
  self.isFromSummon = false
  self.dealDamageParamTable = {}
end

function MonsterObj:ModifyPosY(y)
  self.y = y
  if self.curWorldPos and self.curWorldPos.z then
    self.curWorldPos.z = y
  end
end

function MonsterObj:SetLocalPosition(localPos)
  if not self.viewLoaded then
    self.x = localPos.x
    self.realY = localPos.y
    self.y = localPos.z
    if self.curWorldPos and self.curWorldPos.z then
      self.curWorldPos.x = localPos.x
      self.curWorldPos.y = localPos.y
      self.curWorldPos.z = localPos.z
    end
    if self.viewHandle then
      UnitViewFacade.SetLocalPosition(self.viewHandle, localPos.x, localPos.y, localPos.z)
    end
  end
  base.SetLocalPosition(self, localPos)
end

function MonsterObj:ResetHp(hp, meta)
  self.overwriteMeta = meta
  if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) then
    self.overwriteProperty = self.overwriteMeta.property
  end
  self.maxBlood = hp
  self.curBlood = hp
end

function MonsterObj:Load()
  self.viewLoaded = false
  self.viewHandle = VIEW_INVALID_HANDLE
  local scale = ResetScale.x
  if self.meta.model_size then
    scale = self.meta.model_size
  end
  if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) then
    pveUnitViewUtil.CreateUnitViewListRequest(self, self.guid, self.monsterMeta.asset, nil, scale, self.x, self.realY, self.y, ResetPosition.x, self.eulerY, ResetPosition.z, self.layer)
  else
    self.viewHandle, self.viewLoaded = pveUnitViewUtil.CreateUnitView(self.guid, self.monsterMeta.asset, nil, scale, self.x, self.realY, self.y, ResetPosition.x, self.eulerY, ResetPosition.z, self.layer)
    if self.viewLoaded then
      self:OnViewLoaded(true)
    end
  end
end

function MonsterObj:OnViewLoaded(force, objHandle)
  if self.viewLoaded and not force then
    return
  end
  self.viewLoaded = true
  self.gameObject = UnitViewFacade.GetGameObject(self.viewHandle)
  self.transform = UnitViewFacade.GetTransform(self.viewHandle)
  self:ComponentDefineWithoutView()
  self:OnLoadComplete()
end

function MonsterObj:ComponentDefine()
  base.ComponentDefine(self)
end

function MonsterObj:OnLoadComplete()
end

function MonsterObj:OnUpdate(deltaTime)
  base.OnUpdate(self, deltaTime)
end

function MonsterObj:BeAttack(hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff)
  base.BeAttack(self, hurt, hitPoint, hitDir, whiteTime, stiffTime, hitBackDistance, hitEff)
  if 0 < hurt and 0 < self.curBlood then
    hurt = self:ReduceShieldValue(hurt)
    self.curBlood = math.max(self.curBlood - hurt, 0)
    if 0 >= self.curBlood then
      DataCenter.LWBattleManager.logic:OnMonsterDeath(self)
      self:TriggerEvent(self.deathEvent, self.preSelectHeroUuid)
      self:Death()
    end
    self.hitCounter = self.hitCounter + 1
  end
end

function MonsterObj:Death()
  self.mgr:RemoveMonster(self.guid)
end

function MonsterObj:HideHpBar()
  if self.hpBar then
    self.hpBar:Destroy()
    self.hpBar = nil
  end
end

function MonsterObj:DestroyView()
  base.DestroyView(self)
  self.collider = nil
  if self.viewHandle and self.viewHandle > VIEW_INVALID_HANDLE then
    self.viewHandle = UnitViewFacade.DestroyUnitView(self.viewHandle)
  end
  self.gameObject = nil
  self.transform = nil
  if self.req then
    self.req:Destroy()
    self.req = nil
    self.gameObject = nil
    self.transform = nil
  end
end

function MonsterObj:DestroyData()
  self.mgr = nil
  self.battleMgr = nil
  self.x = nil
  self.metaY = nil
  self.y = nil
  self.monsterMeta = nil
  self.monsterProperty = nil
  self.type = nil
  self.overwriteMeta = nil
  self.overwriteProperty = nil
  self.forceUpdateReversePos = nil
  self.airDropping = nil
  base.DestroyData(self)
end

function MonsterObj:ProcessBuff(monsterMeta)
  self.deathEvent = tonumber(monsterMeta.death_trigger_item)
end

function MonsterObj:TriggerEvent(eventId, extra)
  if eventId then
    local meta = DataCenter.LWTriggerItemTemplateManager:GetTemplate(eventId)
    if meta then
      DataCenter.LWBattleManager.logic.triggerEventMgr:Trigger(meta.type, meta, extra, self.monsterMetaId)
    end
  end
end

function MonsterObj:GetRawProperty(type)
  if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) then
    if self.overwriteProperty then
      return self.overwriteProperty[type] or 0
    end
    return self.monsterProperty[type] or 0
  else
    if self.overwriteMeta then
      return self.overwriteMeta.property[type] or 0
    end
    return self.monsterMeta.property[type] or 0
  end
end

function MonsterObj:DoColliderEffect()
  if self.monsterMeta.crash_shake then
    local strs = string.split(self.monsterMeta.crash_shake, "|")
    local hitShakeParam = {}
    hitShakeParam.duration = tonumber(strs[1])
    hitShakeParam.strength = Vector3.New(tonumber(strs[2]), tonumber(strs[3]), tonumber(strs[4]))
    hitShakeParam.vibrato = tonumber(strs[5])
    DataCenter.LWBattleManager:ShakeCameraWithParam(hitShakeParam)
  end
end

function MonsterObj:SetIsFromSummon(isFromSummon)
  self.isFromSummon = isFromSummon
end

function MonsterObj:GetIsCountKillNum()
  if self.isFromSummon then
    return false
  elseif self.monsterMeta.monster_type == Const.MonsterType.Normal then
    return true
  elseif self.monsterMeta.monster_type == Const.MonsterType.Elite then
    return true
  elseif self.monsterMeta.monster_type == Const.MonsterType.Car then
    return true
  elseif self.monsterMeta.monster_type == Const.MonsterType.Bus then
    return true
  elseif self.monsterMeta.monster_type == Const.MonsterType.SkyBattleNormal then
    return true
  elseif self.monsterMeta.monster_type == Const.MonsterType.SkyBattleCollider then
    return true
  end
  return false
end

function MonsterObj:SetForceUpdateReversePos()
  self.forceUpdateReversePos = true
end

function MonsterObj:SetAirDropping(dropping)
  self.airDropping = dropping
  self:RegisterUpdateReversePos()
end

function MonsterObj:IsUntargetable()
  return base.IsUntargetable(self) or self.airDropping
end

function MonsterObj:GetDealDamageParamTable()
  if not self.dealDamageParamTable then
    self.dealDamageParamTable = {}
  end
  return self.dealDamageParamTable
end

function MonsterObj:AfterCreateUnitViewList(viewHandle, viewLoaded)
  self.viewHandle = viewHandle
  self.viewLoaded = viewLoaded
  if self.viewLoaded then
    self:OnViewLoaded(true)
  end
end

function MonsterObj:RegisterUpdateReversePos()
end

function MonsterObj:GetDefaultAnimName()
  if not self.monsterMeta.use_idle_anim or self.monsterMeta.use_idle_anim ~= 1 then
    return "Default"
  end
  local monsterType = self.monsterMeta.monster_type
  if monsterType ~= Const.MonsterType.Junk and monsterType ~= Const.MonsterType.Table and monsterType ~= Const.MonsterType.DynamicTable and monsterType ~= Const.MonsterType.JunkWithSkill then
    return "Default"
  end
  if self.logic and self.logic.battleType == Const.ParkourBattleType.Attack then
    return "idle"
  end
  return "Default"
end

function MonsterObj:UnregisterUpdateReversePos()
end

function MonsterObj:PauseUpdateReversePos(pause)
  if pause then
    self:UnregisterUpdateReversePos()
  else
    self:RegisterUpdateReversePos()
  end
end

return MonsterObj
