local base = require("Scene.LWBattle.Bullet.BulletBase")
local IgnoreTrigger = CS.UnityEngine.QueryTriggerInteraction.Ignore
local Physics = CS.UnityEngine.Physics
local Array = CS.System.Array
local SUPER_FAST_SPEED = 50
local sqrt = math.sqrt
local BulletRay = BaseClass("BulletRay", base)
local BulletViewFacade = CS.PVEBattleLogic.Bullet.BulletViewFacade

function BulletRay:Create()
  if self.index == 1 then
    self.inertiaVelocity = self.owner:GetMoveVelocity()
  else
    self.inertiaVelocity = Vector3.zero
  end
  self.diePercent = DIE_PERCENT
  self.defenders = {}
  base.Create(self)
end

function BulletRay:Destroy()
  base.Destroy(self)
  self.filterdRayHitArray = nil
  if self.rayHitArray then
    Array.Clear(self.rayHitArray)
  end
  self.rayHitArray = nil
  self.defenders = nil
  self.totalDistance = nil
end

function BulletRay:OnUpdateCollision()
end

function BulletRay:OnShow()
  if self.skill ~= nil and self.skill.isWorldTroopEffect then
    self.duration = self.meta.lifetime_world
  else
    self.duration = self.meta.lifetime
  end
  self.scaledTime = 0
  self.worldForwardX, self.worldForwardY, self.worldForwardZ = BulletViewFacade.GetForward(self.viewHandle)
  if self.noCollision then
    local forceLifeTime = self:GetForceLifeTime()
    if forceLifeTime > self.duration then
      self.duration = forceLifeTime * 1.2
    end
    if 0 < self.skill.meta.horizontal_speed then
      self.flySpeed = self.skill.meta.horizontal_speed
    else
      local forceLifeDistance = self:GetForceLifeDistance()
      if forceLifeDistance and 0 < forceLifeDistance then
        self.flySpeed = forceLifeDistance / self.duration
      else
        self.flySpeed = 20
      end
    end
    self.worldVelocityX = self.worldForwardX * self.flySpeed
    self.worldVelocityY = self.worldForwardY * self.flySpeed
    self.worldVelocityZ = self.worldForwardZ * self.flySpeed
  else
    self.worldVelocityX = self.worldForwardX * self.flySpeed + self.inertiaVelocity.x
    self.worldVelocityY = self.worldForwardY * self.flySpeed + self.inertiaVelocity.y
    self.worldVelocityZ = self.worldForwardZ * self.flySpeed + self.inertiaVelocity.z
  end
  self.totalDisplacementX = self.worldVelocityX * self.duration
  self.totalDisplacementY = self.worldVelocityY * self.duration
  self.totalDisplacementZ = self.worldVelocityZ * self.duration
  self.totalDistance = sqrt(self.totalDisplacementX * self.totalDisplacementX + self.totalDisplacementZ * self.totalDisplacementZ)
  if self.base_type == BulletDurabilityType.Collide or self.base_type == BulletDurabilityType.CollideInfinity then
    self.rayHitArray = Array.CreateInstance(typeof(CS.UnityEngine.RaycastHit), 32)
    self.filterdRayHitArray = {}
    self:RaycastDetection()
  else
    Logger.LogError("\229\176\132\231\186\191\229\173\144\229\188\185\230\140\129\231\187\173\229\158\139")
  end
end

function BulletRay:OnUpdateTransform(deltaTime)
  if self.animCurve then
    self.scaledTime = self.scaledTime + deltaTime
    local t = self.scaledTime / self.duration
    if t < self.diePercent then
      local p = self.animCurve:Evaluate(t)
      local newX = self.startPos.x + self.totalDisplacementX * p
      local newY = self.startPos.y + self.totalDisplacementY * p
      local newZ = self.startPos.z + self.totalDisplacementZ * p
      self:SetPositionXYZ(newX, newY, newZ)
      if self.flySpeed <= SUPER_FAST_SPEED then
        for i = #self.defenders, 1, -1 do
          if p > self.defenders[i].perDis then
            self:DoCollision(self.defenders[i].rayHit)
            table.remove(self.defenders, i)
          else
            break
          end
        end
      end
    else
      for i = #self.defenders, 1, -1 do
        self:DoCollision(self.defenders[i].rayHit)
      end
      self:LogicDie()
    end
  else
    local z = self.flySpeed * deltaTime
    BulletViewFacade.Translate(self.viewHandle, z)
  end
end

local function partition_distance(arr, left, right)
  local pivotIndex = math.floor((left + right) / 2)
  local pivotValue = arr[pivotIndex].distance
  arr[pivotIndex], arr[right] = arr[right], arr[pivotIndex]
  local storeIndex = left
  for i = left, right - 1 do
    if pivotValue > arr[i].distance then
      arr[i], arr[storeIndex] = arr[storeIndex], arr[i]
      storeIndex = storeIndex + 1
    end
  end
  arr[storeIndex], arr[right] = arr[right], arr[storeIndex]
  return storeIndex
end

local function quickselect_distance(arr, left, right, n)
  if left == right then
    return arr[left]
  end
  local pivotIndex = partition_distance(arr, left, right)
  local k = pivotIndex - left + 1
  if n == k then
    return arr[pivotIndex]
  elseif n < k then
    return quickselect_distance(arr, left, pivotIndex - 1, n)
  else
    return quickselect_distance(arr, pivotIndex + 1, right, n - k)
  end
end

local function find_min_distance_n(arr, n)
  local left = 1
  local right = #arr
  local min_n = {}
  for i = 1, n do
    local min = quickselect_distance(arr, left, right, i)
    table.insert(min_n, min)
  end
  return min_n
end

function BulletRay:RaycastDetection()
  local layerMask = self.targetLayerMask
  local origin = Vector3.New(self.startPos.x + self.totalDisplacementX, self.startPos.y + self.totalDisplacementY, self.startPos.z + self.totalDisplacementZ)
  local dir = Vector3.New(-self.worldVelocityX, -self.worldVelocityY, -self.worldVelocityZ)
  local cnt = Physics.RaycastNonAlloc(origin, dir, self.rayHitArray, self.totalDistance, layerMask, IgnoreTrigger)
  origin:ReturnPool()
  dir:ReturnPool()
  if not cnt or cnt <= 0 then
    return
  end
  self.filterdRayHitArray = {}
  if 0 < cnt then
    for i = 1, cnt do
      local rayHit = self.rayHitArray[i - 1]
      local trigger = rayHit.transform:GetComponent(typeof(CS.CitySpaceManTrigger))
      if trigger and not (0 >= trigger.ObjectId) then
        local objId = trigger.ObjectId
        local obj = self.bulletMgr:GetUnit(objId)
        if obj and not (0 >= obj:GetCurBlood()) then
          local searchType = obj:GetSearchType()
          if not self.targetSearchType or self.targetSearchType & searchType ~= 0 then
            table.insert(self.filterdRayHitArray, rayHit)
          end
        end
      end
    end
  end
  cnt = #self.filterdRayHitArray
  local limit = self.noCollision and 1 or self.meta.bullet_damage_count
  if self.flySpeed > SUPER_FAST_SPEED then
    if limit < 0 or cnt < limit then
      for i = 1, cnt do
        self:DoCollision(self.filterdRayHitArray[i])
      end
    else
      local arr = {}
      for i = 1, cnt do
        arr[i] = self.filterdRayHitArray[i]
      end
      arr = self:FindMax(arr, limit)
      for i = 1, limit do
        self:DoCollision(arr[i])
      end
      self.diePercent = (self.totalDistance - arr[1].distance) / self.totalDistance
    end
  elseif limit < 0 or cnt < limit then
    for i = 1, cnt do
      local defender = {
        rayHit = self.filterdRayHitArray[i],
        perDis = (self.totalDistance - self.filterdRayHitArray[i].distance) / self.totalDistance
      }
      self.defenders[i] = defender
      table.sort(self.defenders, function(a, b)
        return a.perDis > b.perDis
      end)
    end
  else
    local arr = {}
    for i = 1, cnt do
      arr[i] = self.filterdRayHitArray[i]
    end
    arr = self:FindMax(arr, limit)
    for i = 1, limit do
      local defender = {
        rayHit = self.filterdRayHitArray[i],
        perDis = (self.totalDistance - self.filterdRayHitArray[i].distance) / self.totalDistance
      }
      self.defenders[i] = defender
    end
    self.diePercent = (self.totalDistance - arr[1].distance) / self.totalDistance
  end
end

function BulletRay:DoCollision(rayHit)
  self:DoCollisionForTarget(rayHit)
  self:DoCollisionForBullet(rayHit.point)
end

function BulletRay:FindMax(arr, n)
  local cnt = #arr
  local ret = {}
  for i = 1, n do
    local max = arr[1]
    local maxIndex = 1
    for j = 2, cnt - i + 1 do
      if arr[j].distance > max.distance then
        max = arr[j]
        maxIndex = j
      end
    end
    table.remove(arr, maxIndex)
    ret[n - i + 1] = max
  end
  return ret
end

function BulletRay:FindMin(arr, n)
  local cnt = #arr
  local ret = {}
  for i = 1, n do
    local min = arr[1]
    local minIndex = 1
    for j = 2, cnt - i + 1 do
      if arr[j].distance < min.distance then
        min = arr[j]
        minIndex = j
      end
    end
    table.remove(arr, minIndex)
    ret[n - i + 1] = min
  end
  return ret
end

function BulletRay:find_closest_n(arr, n)
  local heap = {}
  for i = 1, #arr do
    local elem = arr[i]
    table.insert(heap, elem)
    local j = #heap
    while 1 < j do
      local parent = math.floor(j / 2)
      if heap[j].distance > heap[parent].distance then
        heap[j], heap[parent] = heap[parent], heap[j]
        j = parent
      else
        break
      end
    end
    if n < #heap then
      table.remove(heap, 1)
      local j = 1
      while true do
        local left = j * 2
        local right = left + 1
        local smallest = j
        if left <= #heap and heap[left].distance > heap[smallest].distance then
          smallest = left
        end
        if right <= #heap and heap[right].distance > heap[smallest].distance then
          smallest = right
        end
        if smallest ~= j then
          heap[j], heap[smallest] = heap[smallest], heap[j]
          j = smallest
        else
          break
        end
      end
    end
  end
  return heap
end

function BulletRay:DoCollisionForTarget(rayHit)
  local damage = self.skill:GetBulletDamageFactor(self.index) * self.meta.damage
  if damage <= 0 then
    return
  end
  local trigger = rayHit.transform:GetComponent(typeof(CS.CitySpaceManTrigger))
  if not trigger or 0 >= trigger.ObjectId then
    return
  end
  local objId = trigger.ObjectId
  local obj = self.bulletMgr:GetUnit(objId)
  if not obj or 0 >= obj:GetCurBlood() then
    return
  end
  local center = rayHit.transform:TransformPoint(rayHit.collider.center)
  center.y = rayHit.point.y
  local hitPoint = 2 * center - rayHit.point
  local hitDir = Vector3.New(hitPoint.x - self.startPos.x, 0, hitPoint.z - self.startPos.z)
  local hitBackDistance
  if 0 < self.meta.hit_back_distance then
    hitBackDistance = hitDir:SetNormalize() * self.meta.hit_back_distance
  end
  self:DealDamage(obj, damage, hitPoint, hitDir, hitBackDistance)
end

function BulletRay:DoCollisionForBullet(pos)
  self:DoHitShake()
  self:DoHitTriggerNewBullet(pos)
end

return BulletRay
