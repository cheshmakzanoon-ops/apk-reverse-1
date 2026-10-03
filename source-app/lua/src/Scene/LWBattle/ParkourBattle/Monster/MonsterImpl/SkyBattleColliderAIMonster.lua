local base = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.SkyBattleAIMonster")
local SkyBattleColliderAIMonster = BaseClassCache("SkyBattleColliderAIMonster", base)
local pveUnitViewUtil = require("Scene.LWBattle.BarrageBattle.Unit.PveUnitViewUtil")
local BattleColliderUtils = CS.BattleColliderUtils
local Const = require("Scene.LWBattle.Const")

function SkyBattleColliderAIMonster:Init(logic, mgr, guid, x, y, monsterMeta)
  base.Init(self, logic, mgr, guid, x, y, monsterMeta)
  self.dontCollid = {}
  self.collidCnt = monsterMeta.collide_count
end

function SkyBattleColliderAIMonster:OnVisible()
  base.OnVisible(self)
  BattleColliderUtils.AddMonsterCollider(self.viewHandle, self.guid, LayerMask.GetMask("Member"))
end

function SkyBattleColliderAIMonster:OnCollisionViewHandle(colliderCount, startIndex, resultList)
  for i = 1, colliderCount do
    local index = startIndex + i
    local targetObjId = resultList[index]
    self:AttackTarget(targetObjId)
  end
end

function SkyBattleColliderAIMonster:AttackTarget(targetObjId)
  if self.dontCollid[targetObjId] ~= nil then
    return
  end
  base.DoColliderEffect(self)
  self.dontCollid[targetObjId] = 1
  local tar = DataCenter.LWBattleManager.logic:GetUnit(targetObjId)
  local collide_damage = self.monsterMeta.collide_damage
  if tar and 0 < (tar.curBlood or 0) and #collide_damage == 3 and collide_damage[1] == 2 then
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
      self:BeAttack(self.curBlood, self:GetPosition(), nil, 0.2)
      self:AfterBeAttack(self.curBlood, self:GetPosition(), nil, 0.2)
    end
  end
end

function SkyBattleColliderAIMonster:DestroyView()
  base.DestroyView(self)
  BattleColliderUtils.RemoveMonsterCollider(self.guid)
end

function SkyBattleColliderAIMonster:DestroyData()
  self.dontCollid = nil
  self.collidCnt = nil
  base.DestroyData(self)
end

function SkyBattleColliderAIMonster:ColliderEffect(tar)
  self.battleMgr:ShowEffectObj(Const.ParkourCollidEffectPath, self:GetPosition(), nil, 1, nil)
end

return SkyBattleColliderAIMonster
