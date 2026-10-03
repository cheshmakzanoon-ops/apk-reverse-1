local base = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.MonsterObj")
local ColliderMonsterBase = BaseClass("ColliderMonsterBase", base)
local Const = require("Scene.LWBattle.Const")
local BattleColliderUtils = CS.BattleColliderUtils
local UnitViewFacade = CS.PVEBattleLogic.Unit.UnitViewFacade

function ColliderMonsterBase:Init(logic, mgr, guid, x, y, monsterMeta)
  base.Init(self, logic, mgr, guid, x, y, monsterMeta)
  self.dontCollid = {}
  self.collidCnt = monsterMeta.collide_count
end

function ColliderMonsterBase:OnLoadComplete()
  BattleColliderUtils.AddMonsterCollider(self.viewHandle, self.guid, LayerMask.GetMask("Member"))
  self:RegisterUpdateReversePos()
  local defaultAnim = self:GetDefaultAnimName()
  if defaultAnim ~= "Default" then
    self:PlaySimpleAnim(defaultAnim)
  end
end

function ColliderMonsterBase:OnUpdate(deltaTime)
  base.OnUpdate(self, deltaTime)
  if not DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) and self.logic.battleType and self.logic.battleType == Const.ParkourBattleType.Defense and (not self.airDropping or self.forceUpdateReversePos) then
    if self.effectByBuff and self:IsFrozen() then
      return
    end
    self:UpdateReversePos(deltaTime)
  end
end

function ColliderMonsterBase:UpdateReversePos(deltaTime)
  local pos = self:GetPosition()
  local add = self.logic:GetMoveSpeedZ() * self:GetMoveSpeedPercent() * deltaTime
  local z = pos.z - add
  self.y = z
  if self.transform then
    self.transform:Set_position(pos.x, 0, z)
  else
    self.curWorldPos.z = z
  end
end

function ColliderMonsterBase:OnCollisionViewHandle(colliderCount, startIndex, resultList)
  for i = 1, colliderCount do
    local index = startIndex + i
    local targetObjId = resultList[index]
    self:AttackTarget(targetObjId)
  end
end

function ColliderMonsterBase:AttackTarget(targetObjId)
  if self.dontCollid[targetObjId] ~= nil then
    return
  end
  base.DoColliderEffect(self)
  self.dontCollid[targetObjId] = 1
  local tar = DataCenter.LWBattleManager.logic:GetUnit(targetObjId)
  local collide_damage = self.monsterMeta.collide_damage
  if tar and 0 < (tar.curBlood or 0) and #collide_damage == 3 and collide_damage[1] == 2 then
    self:CollidEffect(tar)
    local params = self:GetDealDamageParamTable()
    params.attacker = self
    params.defender = tar
    params.bulletMeta = {}
    params.damageMultiplier = 1
    params.hitPoint = tar:GetPosition()
    params.hitDir = nil
    params.whiteTime = 0.2
    params.stiffTime = nil
    params.hitBackDistance = nil
    params.hitEff = nil
    params.skill = nil
    params.exType = collide_damage[2]
    params.exValue = collide_damage[3]
    params.isCritical = nil
    params.isSplash = nil
    self.battleMgr:DealDamage(params)
    self.collidCnt = self.collidCnt - 1
    if self.collidCnt == 0 then
      self:Death()
    end
  end
end

function ColliderMonsterBase:DestroyView()
  self:UnregisterUpdateReversePos()
  base.DestroyView(self)
  BattleColliderUtils.RemoveMonsterCollider(self.guid)
end

function ColliderMonsterBase:DestroyData()
  self.dontCollid = nil
  self.collidCnt = nil
  self.speedPercent = nil
  self.buffPropertyDirty = nil
  base.DestroyData(self)
end

function ColliderMonsterBase:CollidEffect(tar)
  self.battleMgr:ShowEffectObj(Const.ParkourCollidEffectPath, tar:GetPosition(), nil, 1, nil)
end

function ColliderMonsterBase:RegisterUpdateReversePos()
  if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) and self.logic.battleType and self.logic.battleType == Const.ParkourBattleType.Defense and (not self.airDropping or self.forceUpdateReversePos) then
    if self.effectByBuff and self:IsFrozen() then
      return
    end
    UnitViewFacade.RegisterUpdater(self.viewHandle, -self.logic:GetMoveSpeedZ())
  end
end

function ColliderMonsterBase:UnregisterUpdateReversePos()
  if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) then
    UnitViewFacade.UnregisterUpdater(self.viewHandle)
  end
end

function ColliderMonsterBase:OnBuffAdded(buff)
  if not self.effectByBuff then
    base.OnBuffAdded(self, buff)
    return
  end
  local buffType = buff.meta.type
  if buffType == BuffType.Property then
    self.buffPropertyDirty = true
    self:OnBuffPropertyChanged()
  elseif buffType == BuffType.Frozen then
    self:ShowFrozen()
    self:PauseUpdateReversePos(true)
  end
end

function ColliderMonsterBase:OnBuffRemoved(buff)
  if not self.effectByBuff then
    base.OnBuffRemoved(self, buff)
    return
  end
  local buffType = buff.meta.type
  if buffType == BuffType.Property then
    self.buffPropertyDirty = true
    self:OnBuffPropertyChanged()
  elseif buffType == BuffType.Frozen then
    self:HideFrozen()
    self:PauseUpdateReversePos(false)
  end
end

function ColliderMonsterBase:ShowFrozen()
  if self.viewHandle then
    UnitViewFacade.MPBFrozen(self.viewHandle)
  end
end

function ColliderMonsterBase:HideFrozen()
  if self.viewHandle then
    UnitViewFacade.MPBResetFrozen(self.viewHandle)
  end
end

function ColliderMonsterBase:OnBuffPropertyChanged()
end

function ColliderMonsterBase:GetMoveSpeedPercent()
  if self.speedPercent == nil or self.buffPropertyDirty then
    self.speedPercent = 1 + self:GetProperty(HeroEffectDefine.BattleHeroMoveSpeed)
    self.buffPropertyDirty = nil
    return self.speedPercent
  end
  return self.speedPercent
end

return ColliderMonsterBase
