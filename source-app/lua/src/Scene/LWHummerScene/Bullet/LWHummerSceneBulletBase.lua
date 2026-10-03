local LWHummerSceneBulletBase = BaseClass("LWHummerSceneBulletBase")
local Resource = CS.GameEntry.Resource
local RIGHT = Vector3.right
local UP = Vector3.up
local FORWARD = Vector3.forward
local ZERO = Vector3.zero
local BattleColliderUtils = CS.BattleColliderUtils
local TrailRenderer = CS.UnityEngine.TrailRenderer
local CSCitySpaceManTrigger = CS.CitySpaceManTrigger

function LWHummerSceneBulletBase:__init()
end

function LWHummerSceneBulletBase:__delete()
  self:Destory()
end

function LWHummerSceneBulletBase:Destory()
  BattleColliderUtils.RemoveBullet(self.objId)
  self.bulletMgr = nil
  self.objId = nil
  self.params = nil
  self.meta = nil
  self.startPos = nil
  self.flySpeed = nil
  self.lifetime = nil
  self.animCurve = nil
  if self.bulletEffectReq then
    self.bulletEffectReq:Destroy()
    self.bulletEffectReq = nil
  end
  self.bulletEffect = nil
  self.bulletEffectTrans = nil
  self.colliderType = nil
  self.collider = nil
  self.targetLayerMask = nil
  self.logicDie = nil
  self.dead_delay = nil
  self.colliderCenterOffset = nil
  self.collidedIdList = nil
  self.target = nil
  self.heightWidthRatio = nil
  self.angleOffset = nil
end

function LWHummerSceneBulletBase:Init(bulletMgr, objId, params)
  self.bulletMgr = bulletMgr
  self.objId = objId
  self.params = params
  self.meta = params.meta
  self.startPos = params.startPos
  self.target = params.target
  self.fireTrans = params.fireTrans
  self.curPos = self.startPos * 1
  self.flySpeed = self.meta.bullet_fly_speed
  self.lifetime = self.meta.lifetime
  self.heightWidthRatio = self.meta.mvt_type_para
  self.animCurve = self.bulletMgr:StringToCurve(self.meta.motion_curve)
  self.bulletEffect = nil
  self.bulletEffectReq = nil
  self.bulletEffectTrans = nil
  self.colliderType = ColliderType.Sphere
  self.targetLayerMask = LayerMask.GetMask(LayerType.Zombie)
  self.logicDie = false
  self.dead_delay = self.meta.dead_delay
  self.angleOffset = params.angleOffset
  if params.angleOffset then
    self.rotY = params.angleOffset
  else
    self.rotY = 0
  end
  self.colliderCenterOffset = ZERO
  self.collidedIdList = {}
end

function LWHummerSceneBulletBase:Create()
  local bulletEffect = self.meta.bullet_effect
  self:DoCreateSound()
  self.bulletEffectReq = Resource:InstantiateAsync(bulletEffect, ObjectPoolTag.BattleBullet)
  self.bulletEffectReq:completed("+", function(req)
    if not (self.bulletMgr and self.bulletMgr.logic) or not self.bulletMgr.logic.inLogic then
      req:Destroy()
      return
    end
    local go = req.gameObject
    if go then
      self.bulletEffect = go
      self.bulletEffectTrans = go.transform
      self:InitBulletEffect()
      self:OnShow()
    else
      Logger.LogError("\232\181\132\230\186\144\230\137\190\228\184\141\229\136\176\239\188\129\232\175\183\230\163\128\230\159\165\232\183\175\229\190\132\239\188\129" .. bulletEffect)
    end
  end)
end

function LWHummerSceneBulletBase:OnShow()
end

function LWHummerSceneBulletBase:InitBulletEffect()
  if self.fireTrans then
    self.startPos = self.fireTrans.position + self.startPos
    self.curPos = self.startPos * 1
  end
  self.bulletScale = self.meta.bullet_effect_size
  self.bulletEffectTrans:Set_localScale(self.bulletScale, self.bulletScale, self.bulletScale)
  self.bulletEffectTrans.position = self.startPos
  self.bulletEffectTrans:Set_eulerAngles(0, self.rotY, 0)
  self:InitCollider()
  self:InitTrailRenderer()
end

function LWHummerSceneBulletBase:InitCollider()
  self.colliderRadius = 1
  local haveSphereCollider, sphereCollider = self.bulletEffectTrans:TryGetComponent(typeof(CS.UnityEngine.SphereCollider))
  if haveSphereCollider then
    self.colliderType = ColliderType.Sphere
    self.collider = sphereCollider
    self.colliderRadius = self.collider.radius
    self.dimension = self.bulletScale * self.colliderRadius
    self.colliderCenterOffset = self.bulletEffectTrans:TransformPoint(self.collider.center) - self.startPos
    self.curColliderCenterPos = self:GetPosition() + self.colliderCenterOffset
    self.lastColliderCenterPos = self:GetPosition() + self.colliderCenterOffset
    BattleColliderUtils.AddBullet(self.bulletEffectTrans, self.objId, self.bulletScale * self.colliderRadius, self.targetLayerMask)
    return
  end
  local haveCapsuleCollider, capsuleCollider = self.bulletEffectTrans:TryGetComponent(typeof(CS.UnityEngine.CapsuleCollider))
  if haveCapsuleCollider then
    self.colliderType = ColliderType.Capsule
    self.collider = capsuleCollider
    self.colliderRadius = self.collider.radius
    self.colliderHeight = self.collider.height
    local dir = self.collider.direction
    local colliderDirection = RIGHT
    if dir == 1 then
      colliderDirection = UP
    elseif dir == 2 then
      colliderDirection = FORWARD
    end
    self.localHalfVector = colliderDirection * (self.colliderHeight * 0.5)
    self.dimension = self.bulletScale * (self.colliderRadius + self.colliderHeight)
    self.curColliderCenterPos = self:GetPosition() + self.colliderCenterOffset
    self.lastColliderCenterPos = self:GetPosition() + self.colliderCenterOffset
    self.tmpCapsulePoint1 = CS.UnityEngine.Vector3.one
    self.tmpCapsulePoint2 = CS.UnityEngine.Vector3.one
    local colliderCenter = self.collider.center
    self.colliderCenterOffset = self.bulletEffectTrans:TransformPoint(colliderCenter) - self.startPos
    local colliderCenterOffsetX = colliderCenter.x
    local colliderCenterOffsetY = colliderCenter.y
    local colliderCenterOffsetZ = colliderCenter.z
    local localHalfVectorX = self.localHalfVector.x
    local localHalfVectorY = self.localHalfVector.y
    local localHalfVectorZ = self.localHalfVector.z
    BattleColliderUtils.AddCapsuleBullet(self.bulletEffectTrans, self.objId, self.bulletScale * self.colliderRadius, self.targetLayerMask, colliderCenterOffsetX - localHalfVectorX, colliderCenterOffsetY - localHalfVectorY, colliderCenterOffsetZ - localHalfVectorZ, colliderCenterOffsetX + localHalfVectorX, colliderCenterOffsetY + localHalfVectorY, colliderCenterOffsetZ + localHalfVectorZ)
    return
  end
end

function LWHummerSceneBulletBase:InitTrailRenderer()
  local trailRenderer = self.bulletEffect:GetComponentsInChildren(typeof(TrailRenderer))
  for i = 0, trailRenderer.Length - 1 do
    trailRenderer[i]:Clear()
  end
end

function LWHummerSceneBulletBase:OnUpdate(collide)
  if self:CheckDeath() then
    return
  end
  self:OnUpdateTransform()
end

function LWHummerSceneBulletBase:OnUpdateTransform()
end

function LWHummerSceneBulletBase:CollisionDetection()
  local colliderCount, colliderList = self.bulletMgr:TryGetCollideList(self.objId)
  if colliderCount then
    if colliderCount == 1 then
      self:DoCollisionForTargetObjId(colliderList, self.curColliderCenterPos)
    else
      for i = 1, colliderCount do
        self:DoCollisionForTargetObjId(colliderList[i], self.curColliderCenterPos)
      end
    end
  end
end

function LWHummerSceneBulletBase:DoCollisionForTargetObjId(objectId, bulletEffectPos)
  local unit = self.bulletMgr:GetUnit(objectId)
  if unit then
    local trigger = unit.citySpaceManTrigger
    if trigger ~= nil and unit.transform ~= self.bulletEffectTrans and unit.unitType == HummerSceneUnitType.Zombie then
      local collider = unit.collider
      if collider then
        local hitPoint = collider:ClosestPoint(bulletEffectPos)
        local hitDir = Vector3.New(hitPoint.x - self.startPos.x, 0, hitPoint.z - self.startPos.z)
        self.bulletMgr:HitUnit(unit, self.meta, hitPoint, hitDir)
        self.collidedIdList[trigger.ObjectId] = true
      end
    end
  end
end

function LWHummerSceneBulletBase:IsCollideDuplicately(objId)
  if self.collidedIdList and self.collidedIdList[objId] then
    return true
  end
  return false
end

function LWHummerSceneBulletBase:GetPosition()
  return self.curPos
end

function LWHummerSceneBulletBase:SetPosition(pos)
  self.curPos = pos
  if self.bulletEffect then
    self.bulletEffectTrans:Set_localPosition(pos.x, pos.y, pos.z)
  end
end

function LWHummerSceneBulletBase:SetPositionXYZ(x, y, z)
  self.curPos:Set(x, y, z)
  if self.bulletEffect then
    self.bulletEffectTrans:Set_localPosition(x, y, z)
  end
end

function LWHummerSceneBulletBase:GetColliderCenterWorldPos()
  local selfPos = self:GetPosition()
  return selfPos.x + self.colliderCenterOffset.x, selfPos.y + self.colliderCenterOffset.y, selfPos.z + self.colliderCenterOffset.z
end

function LWHummerSceneBulletBase:CheckDeath()
  self.lifetime = self.lifetime - Time.deltaTime
  if self.lifetime <= 0 then
    if not self.logicDie then
      self:LogicDie()
    else
      self:RenderDie()
    end
    return true
  end
  return self.logicDie
end

function LWHummerSceneBulletBase:LogicDie()
  if self.logicDie then
    return
  end
  self.logicDie = true
  if self.dead_delay > 0 then
    self.lifetime = self.dead_delay
  else
    self:RenderDie()
  end
end

function LWHummerSceneBulletBase:RenderDie()
  self.bulletMgr:RemoveBullet(self)
end

function LWHummerSceneBulletBase:GetTargetPos()
  if not self.target then
    return self:GetPosition()
  elseif self.target.unitType then
    return self.target:GetPosition()
  elseif self.target.x and self.target.z then
    return self.target
  end
  return nil
end

function LWHummerSceneBulletBase:DoCreateSound()
  if self.meta.sound_id_create and self.meta.sound_id_create > 0 then
    DataCenter.LWSoundManager:PlaySound(self.meta.sound_id_create)
  end
end

return LWHummerSceneBulletBase
