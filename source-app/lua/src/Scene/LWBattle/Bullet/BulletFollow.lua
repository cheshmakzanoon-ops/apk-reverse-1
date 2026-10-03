local base = require("Scene.LWBattle.Bullet.BulletBase")
local BulletFollow = BaseClass("BulletFollow", base)
local BulletViewFacade = CS.PVEBattleLogic.Bullet.BulletViewFacade

function BulletFollow:Create()
  self.skill:RegisterChantBullet(self.objId, self)
  self.viewHandlePos = Vector3.New(self.curPos.x, self.curPos.y, self.curPos.z)
  base.Create(self)
end

function BulletFollow:OnShow()
  if self.skill:IsNil() then
    self:LogicDie()
    return
  end
  local firePointTransform
  local firePointTransformNull = false
  if self.skill.owner.GetFirePointById and self.firePointIndex and self.firePointIndex > 0 then
    firePointTransform, firePointTransformNull = self.skill.owner:GetFirePointById(self.firePointIndex)
  else
    firePointTransform, firePointTransformNull = self.skill.owner:GetFirePoint()
  end
  if 0 < self.viewHandle then
    BulletViewFacade.SetParent(self.viewHandle, firePointTransform)
    BulletViewFacade.ResetLocalPosition(self.viewHandle)
    self:ResetBulletLengthBackend()
  end
end

function BulletFollow:LogicDie()
  if self.skill then
    self.skill:UnregisterChantBullet(self.objId)
  end
  base.LogicDie(self)
end

function BulletFollow:Destroy()
  if self.skill then
    self.skill:UnregisterChantBullet(self.objId)
  end
  base.Destroy(self)
end

function BulletFollow:GetPosition()
  if self.viewHandle > 0 then
    local curFrame = Time.frameCount
    if self.getPosCurFrame == curFrame then
      return self.viewHandlePos
    end
    self.getPosCurFrame = curFrame
    local x, y, z = BulletViewFacade.GetPositionXYZ(self.viewHandle)
    self.viewHandlePos:Set(x, y, z)
    return self.viewHandlePos
  else
    return self.curPos
  end
end

function BulletFollow:GetColliderCenterWorldPos()
  if self.collider then
    local x, y, z = BulletViewFacade.GetTransformPoint(self.viewHandle, self.collider.center.x, self.collider.center.y, self.collider.center.z)
    return x, y, z
  end
  return base.GetColliderCenterWorldPos(self)
end

function BulletFollow:ReInit()
  self:InitLifeTime()
  self:ResetBulletLengthBackend()
end

function BulletFollow:ResetBulletLengthBackend()
  if self.skill and self.skill.forceLifeDistance and self.viewHandle > 0 and self.viewLoaded and self.noCollision then
    BulletViewFacade.SetLocalScale(self.viewHandle, self.bulletScale, self.bulletScale, self.skill.forceLifeDistance / self.meta.effect_length)
  end
end

return BulletFollow
