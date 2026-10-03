local Physics = CS.UnityEngine.Physics
local ColliderComponent = BaseClass("ColliderColliderComponent")
local ColliderType = {
  None = 0,
  Capsule = 1,
  Box = 2,
  Sphere = 3
}

function ColliderComponent:__init(transform, maxCollid, layerMask)
  self.onCollid = nil
  self.active = true
  self:InitCollider(transform, maxCollid, layerMask)
end

function ColliderComponent:__delete()
  self.colliderArray = nil
end

function ColliderComponent:InitCollider(transform, maxCollid, layerMask)
  self.transform = transform
  self.collider = nil
  self.colliderType = ColliderType.None
  self.colliderParam = {}
  self.colliderArray = CS.System.Array.CreateInstance(typeof(CS.UnityEngine.Collider), maxCollid or 10)
  if not transform then
    return false
  end
  local layerMask = layerMask or 4294967295
  local have, collider = transform:TryGetComponent(typeof(CS.UnityEngine.BoxCollider))
  if have then
    self.collider = collider
    self.colliderType = ColliderType.Box
    self.colliderParam = {
      halfExtents = collider.size / 2,
      layerMask = layerMask
    }
    return true
  end
  local have, collider = transform:TryGetComponent(typeof(CS.UnityEngine.CapsuleCollider))
  if have then
    self.collider = collider
    self.colliderType = ColliderType.Capsule
    local halfVec = ({
      Vector3.right,
      Vector3.up,
      Vector3.forward
    })[tonumber(collider.direction) + 1] * (collider.height / 2)
    self.colliderParam = {
      radius = collider.radius,
      halfVector = halfVec,
      layerMask = layerMask
    }
    return true
  end
  local have, collider = transform:TryGetComponent(typeof(CS.UnityEngine.SphereCollider))
  if have then
    self.collider = collider
    self.colliderType = ColliderType.Sphere
    self.colliderParam = {
      radius = collider.radius,
      layerMask = layerMask
    }
    return true
  end
  Logger.LogError("self.collider is nil.")
end

function ColliderComponent:CollisionDetect()
  if self.active == false then
    return
  end
  if self.colliderType == ColliderType.None then
    return
  end
  local collderCnt = 0
  local pos = self.transform:TransformPoint(self.collider.center)
  if self.colliderType == ColliderType.Sphere then
    collderCnt = Physics.OverlapSphereNonAlloc(pos, self.colliderParam.radius, self.colliderArray, self.colliderParam.layerMask)
  elseif self.colliderType == ColliderType.Box then
    collderCnt = Physics.OverlapBoxNonAlloc(pos, self.colliderParam.halfExtents, self.colliderArray, self.transform.rotation, self.colliderParam.layerMask)
  elseif self.colliderType == ColliderType.Capsule then
    collderCnt = Physics.OverlapCapsuleNonAlloc(pos + self.colliderParam.halfVector, pos - self.colliderParam.halfVector, self.colliderParam.radius, self.colliderArray, self.colliderParam.layerMask)
  end
  if self.onCollid and 0 < collderCnt then
    self.onCollid(collderCnt, self.colliderArray)
  end
end

function ColliderComponent:SetOnCollide(callback)
  self.onCollid = callback
end

function ColliderComponent:RemoveOnCollide()
  self.onCollid = nil
end

function ColliderComponent:Destroy()
  self:RemoveOnCollide()
  self.transform = nil
  self.collider = nil
end

return ColliderComponent
