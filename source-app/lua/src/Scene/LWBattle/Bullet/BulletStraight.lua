local base = require("Scene.LWBattle.Bullet.BulletBase")
local BulletStraight = BaseClass("BulletStraight", base)
local BulletViewFacade = CS.PVEBattleLogic.Bullet.BulletViewFacade
local BulletViewUtil = require("Scene.LWBattle.Bullet.BulletViewUtil")
local VIEW_INVALID_HANDLE = -1

function BulletStraight:Create()
  if self.index == 1 then
    self.inertiaVelocity = self.owner:GetMoveVelocity()
  else
    self.inertiaVelocity = Vector3.zero
  end
  return base.Create(self)
end

function BulletStraight:InitAnimCurve()
end

function BulletStraight:CreateBulletView(bulletEffect)
  ProfilerUtil.BeginSample("BulletStraightPrepareParam")
  if self.skill.isWorldTroopEffect then
    self.bulletScale = self.meta.bullet_effect_size_world
  else
    self.bulletScale = self.meta.bullet_effect_size
  end
  if self.skill ~= nil and self.skill.isWorldTroopEffect then
    self.duration = self.meta.lifetime_world
  else
    self.duration = self.meta.lifetime
  end
  local speed = self.flySpeed
  if self.noCollision then
    self.duration = self:GetForceLifeTime()
    if self.skill.meta.horizontal_speed > 0 then
      speed = self.skill.meta.horizontal_speed
    else
      local forceLifeDistance = self:GetForceLifeDistance()
      if forceLifeDistance and 0 < forceLifeDistance then
        speed = forceLifeDistance / self.duration
      else
        speed = 20
      end
    end
  end
  local curve = self.meta.motion_curve
  if string.IsNullOrEmpty(curve) then
    curve = DEFAULT_BULLET_MOTION_STRING
  end
  local inertiaVelocityX = self.inertiaVelocity.x
  local inertiaVelocityY = self.inertiaVelocity.y
  local inertiaVelocityZ = self.inertiaVelocity.z
  self.bulletEffectStraight = bulletEffect
  self.speedStraight = speed
  self.curveStraight = curve
  ProfilerUtil.EndSample()
  if not DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) then
    local tmpDotMaxCD = 0
    self.viewHandle, self.viewLoaded, tmpDotMaxCD = BulletViewUtil.CreateStraightView(bulletEffect, self.objId, self.startPos.x, self.startPos.y, self.startPos.z, self.rotY, self.targetLayerMask, inertiaVelocityX, inertiaVelocityY, inertiaVelocityZ, self.lifetime, self.bulletScale, self.meta.colliderRadius, self.noCollision ~= nil, self.duration, self.meta.spiral_loops, self.meta.spiral_radius, speed, curve, self.base_type == BulletDurabilityType.Collide or self.base_type == BulletDurabilityType.CollideInfinity, self.dotMaxCD, self.needSetGrowShader)
    self.isBulletVisible = true
    self.lifeTimeEnd = false
    self.curColliderCenterPos = self.curPos * 1
    if self.viewLoaded then
      self:OnLoaded(tmpDotMaxCD)
    end
  end
end

function BulletStraight:AfterCreateViewList(viewHandle, viewLoaded, tmpDotMaxCD)
  self.viewHandle = viewHandle
  self.viewLoaded = viewLoaded
  self.isBulletVisible = true
  self.lifeTimeEnd = false
  self.curColliderCenterPos = self.curPos * 1
  if self.viewLoaded then
    self:OnLoaded(tmpDotMaxCD)
  end
end

function BulletStraight:OnViewLoaded(cd)
  if self.viewLoaded then
    return
  end
  self.viewLoaded = true
  self:OnLoaded(cd)
end

function BulletStraight:OnStraightCollision()
  if not self.viewLoaded then
    local loaded, tmpDotMaxCD = BulletViewFacade.IsLoaded(self.viewHandle)
    if not loaded then
      return
    end
    self:OnViewLoaded(tmpDotMaxCD)
  end
  if self.logicDie or self.lifetime <= 0 or not self.isBulletVisible then
    return
  end
  if self.noCollision then
    return
  end
  ProfilerUtil.BeginSample("BulletCollisionDetection")
  self:CollisionDetection()
  ProfilerUtil.EndSample()
end

function BulletStraight:DestroyBulletView()
  if self.viewHandle and self.viewHandle ~= VIEW_INVALID_HANDLE then
    self.viewHandle = BulletViewFacade.DestroyBulletViewStraight(self.viewHandle)
  end
  self.viewHandle = VIEW_INVALID_HANDLE
end

function BulletStraight:Destroy()
  base.Destroy(self)
  self.arrayIndex = nil
  self.bulletEffectStraight = nil
  self.speedStraight = nil
  self.curveStraight = nil
end

function BulletStraight:OnLoaded(tmpDotMaxCD)
  self.dotMaxCD = tmpDotMaxCD
end

function BulletStraight:GetPosition()
  local curFrame = Time.frameCount
  if self.getPosCurFrame == curFrame then
    return self.curPos
  end
  self.getPosCurFrame = curFrame
  if self.viewLoaded then
    self.curPos.x, self.curPos.y, self.curPos.z = BulletViewFacade.GetPositionXYZ(self.viewHandle)
  end
  return self.curPos
end

function BulletStraight:OnShow()
end

function BulletStraight:GetColliderCenterWorldPos()
  return BulletViewFacade.GetColliderCenterWorldPos(self.viewHandle)
end

function BulletStraight:OnUpdateTransform(deltaTime)
end

function BulletStraight:CheckDeath(deltaTime)
  if not self.lifeTimeEnd then
    return false
  end
  return base.CheckDeath(self, deltaTime)
end

function BulletStraight:LogicDie()
  if not self.lifeTimeEnd then
    self.lifeTimeEnd = true
  end
  base.LogicDie(self)
end

function BulletStraight:OnLogicDie()
  base.OnLogicDie(self)
  BulletViewFacade.StraightLogicDie(self.viewHandle, self.lifetime)
end

function BulletStraight:OnUpdateTransformFinish(lifeEnd)
  if lifeEnd then
    self.lifeTimeEnd = true
    self.lifetime = 0
    self:CheckDeath(0.03)
    return
  end
  if 0 >= self.meta.spiral_loops then
    if self.noCollision then
      self:CollisionDetection()
    end
    self:LogicDie()
  end
end

return BulletStraight
