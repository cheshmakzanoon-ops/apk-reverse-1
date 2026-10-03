local PvePhysicsUtil = {}
local ColliderArrayCapacity = 64
local OverlapSphereNonAllocParamArray, OverlapSphereNonAllocParamArrayAccess, OverlapSphereNonAllocResultArray, OverlapSphereNonAllocResultArrayAccess
local BattleColliderUtils = CS.BattleColliderUtils
local BulletColliderResultArray, BulletColliderResultArrayAccess, MonsterColliderResultArray, MonsterColliderResultArrayAccess, UnitColliderResultArray, UnitColliderResultArrayAccess, PlayerColliderResultArray, PlayerColliderResultArrayAccess, ObstacleColliderResultArray, ObstacleColliderResultArrayAccess
local lastCollideFrame = 0
local lastColliderUpdateFrame = 0

function PvePhysicsUtil.OverlapSphereNonAlloc(center, radius, layerMask, sortByDistance, targetPos)
  sortByDistance = sortByDistance or false
  if not DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) then
    sortByDistance = false
  end
  if OverlapSphereNonAllocParamArray == nil then
    OverlapSphereNonAllocParamArray = LuaCSharpArray.New(8)
    OverlapSphereNonAllocParamArrayAccess = OverlapSphereNonAllocParamArray:GetCSharpAccess()
    OverlapSphereNonAllocResultArray = LuaCSharpArray.New(ColliderArrayCapacity + 4)
    OverlapSphereNonAllocResultArrayAccess = OverlapSphereNonAllocResultArray:GetCSharpAccess()
    BattleColliderUtils.InitOverlapSphereNonAllocAccess(ColliderArrayCapacity, OverlapSphereNonAllocParamArrayAccess, OverlapSphereNonAllocResultArrayAccess)
  end
  targetPos = targetPos or center
  OverlapSphereNonAllocParamArray[1] = center.x
  OverlapSphereNonAllocParamArray[2] = center.y
  OverlapSphereNonAllocParamArray[3] = center.z
  OverlapSphereNonAllocParamArray[4] = radius
  OverlapSphereNonAllocParamArray[5] = layerMask
  OverlapSphereNonAllocParamArray[6] = targetPos.x
  OverlapSphereNonAllocParamArray[7] = targetPos.y
  OverlapSphereNonAllocParamArray[8] = targetPos.z
  BattleColliderUtils.OverlapSphereNonAlloc(sortByDistance)
  local count = OverlapSphereNonAllocResultArray[1]
  return count
end

function PvePhysicsUtil.GetOverlapSphereNonAllocResultObjId(index)
  return OverlapSphereNonAllocResultArray[index + 1] or 0
end

function PvePhysicsUtil.OverlapBoxNonAlloc(center, distance, halfExtents, layerMask, sortByDistance)
  sortByDistance = sortByDistance or false
  if OverlapSphereNonAllocParamArray == nil then
    OverlapSphereNonAllocParamArray = LuaCSharpArray.New(8)
    OverlapSphereNonAllocParamArrayAccess = OverlapSphereNonAllocParamArray:GetCSharpAccess()
    OverlapSphereNonAllocResultArray = LuaCSharpArray.New(ColliderArrayCapacity + 4)
    OverlapSphereNonAllocResultArrayAccess = OverlapSphereNonAllocResultArray:GetCSharpAccess()
    BattleColliderUtils.InitOverlapSphereNonAllocAccess(ColliderArrayCapacity, OverlapSphereNonAllocParamArrayAccess, OverlapSphereNonAllocResultArrayAccess)
  end
  OverlapSphereNonAllocParamArray[1] = center.x
  OverlapSphereNonAllocParamArray[2] = center.y
  OverlapSphereNonAllocParamArray[3] = center.z
  OverlapSphereNonAllocParamArray[4] = distance
  OverlapSphereNonAllocParamArray[5] = layerMask
  OverlapSphereNonAllocParamArray[6] = halfExtents.x
  OverlapSphereNonAllocParamArray[7] = halfExtents.y
  OverlapSphereNonAllocParamArray[8] = halfExtents.z
  BattleColliderUtils.OverlapBoxNonAlloc(sortByDistance)
  local count = OverlapSphereNonAllocResultArray[1]
  return count
end

function PvePhysicsUtil.GetOverlapBoxNonAllocResultObjId(index)
  return OverlapSphereNonAllocResultArray[index + 1] or 0
end

function PvePhysicsUtil.UpdateCollider()
  local curFrame = Time.frameCount
  if lastColliderUpdateFrame == curFrame then
    return
  end
  lastColliderUpdateFrame = curFrame
  BattleColliderUtils.UpdateCollider()
end

function PvePhysicsUtil.BulletCollider(deltaTime)
  if BulletColliderResultArray == nil then
    BulletColliderResultArray = LuaCSharpArray.New(1024)
    BulletColliderResultArrayAccess = BulletColliderResultArray:GetCSharpAccess()
    BattleColliderUtils.InitBulletColliderResultAccess(BulletColliderResultArrayAccess)
  end
  local curFrame = Time.frameCount
  if lastCollideFrame == curFrame then
    return BulletColliderResultArray
  end
  lastCollideFrame = curFrame
  local res = BattleColliderUtils.BulletColliderLuaArray(deltaTime)
  if not res then
    BulletColliderResultArray[1] = 0
  end
  return BulletColliderResultArray
end

function PvePhysicsUtil.EnterBattle(useCollider2D)
  if DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.ParkourPerformance) then
    PvePhysicsUtil.useCollider2D = useCollider2D
  end
  BattleColliderUtils.EnterBattle(useCollider2D)
end

function PvePhysicsUtil.ExitBattle()
  BattleColliderUtils.ExitBattle()
end

function PvePhysicsUtil.ResizeBulletColliderResultArray(size)
  if BulletColliderResultArray ~= nil then
    BulletColliderResultArray[size] = 0
    return true
  end
  return false
end

function PvePhysicsUtil.UnInitBulletCollider()
  if BulletColliderResultArray then
    BulletColliderResultArray:DestroyCSharpAccess()
    BulletColliderResultArray = nil
    BulletColliderResultArrayAccess = nil
    BattleColliderUtils.UnInitBulletColliderResultAccess()
  end
end

function PvePhysicsUtil.MonsterCollider()
  if MonsterColliderResultArray == nil then
    MonsterColliderResultArray = LuaCSharpArray.New(1)
    MonsterColliderResultArrayAccess = MonsterColliderResultArray:GetCSharpAccess()
    BattleColliderUtils.InitMonsterColliderResultAccess(MonsterColliderResultArrayAccess)
  end
  local res = BattleColliderUtils.MonsterColliderLuaArray()
  if not res then
    MonsterColliderResultArray[1] = 0
  end
  return MonsterColliderResultArray
end

function PvePhysicsUtil.ResizeMonsterColliderResultArray(size)
  if MonsterColliderResultArray ~= nil then
    MonsterColliderResultArray[size] = 0
    return true
  end
  return false
end

function PvePhysicsUtil.UnInitMonsterCollider()
  if MonsterColliderResultArray then
    MonsterColliderResultArray:DestroyCSharpAccess()
    MonsterColliderResultArray = nil
    MonsterColliderResultArrayAccess = nil
    BattleColliderUtils.UnInitMonsterColliderResultAccess()
  end
end

function PvePhysicsUtil.UnitCollider()
  if UnitColliderResultArray == nil then
    UnitColliderResultArray = LuaCSharpArray.New(1)
    UnitColliderResultArrayAccess = UnitColliderResultArray:GetCSharpAccess()
    BattleColliderUtils.InitUnitColliderResultAccess(UnitColliderResultArrayAccess)
  end
  local res = BattleColliderUtils.UnitColliderLuaArray()
  if not res then
    UnitColliderResultArray[1] = 0
  end
  return UnitColliderResultArray
end

function PvePhysicsUtil.ResizeUnitColliderResultArray(size)
  if UnitColliderResultArray ~= nil then
    UnitColliderResultArray[size] = 0
    return true
  end
  return false
end

function PvePhysicsUtil.UnInitUnitCollider()
  if UnitColliderResultArray then
    UnitColliderResultArray:DestroyCSharpAccess()
    UnitColliderResultArray = nil
    UnitColliderResultArrayAccess = nil
    BattleColliderUtils.UnInitUnitColliderResultAccess()
  end
end

function PvePhysicsUtil.PlayerCollider()
  if PlayerColliderResultArray == nil then
    PlayerColliderResultArray = LuaCSharpArray.New(1)
    PlayerColliderResultArrayAccess = PlayerColliderResultArray:GetCSharpAccess()
    BattleColliderUtils.InitPlayerColliderResultAccess(PlayerColliderResultArrayAccess)
  end
  local res = BattleColliderUtils.PlayerColliderLuaArray()
  if not res then
    PlayerColliderResultArray[1] = 0
  end
  return PlayerColliderResultArray
end

function PvePhysicsUtil.GhostPlayerCollider()
  if PlayerColliderResultArray == nil then
    PlayerColliderResultArray = LuaCSharpArray.New(1)
    PlayerColliderResultArrayAccess = PlayerColliderResultArray:GetCSharpAccess()
    BattleColliderUtils.InitPlayerColliderResultAccess(PlayerColliderResultArrayAccess)
  end
  local res = BattleColliderUtils.GhostPlayerColliderLuaArray()
  if not res then
    PlayerColliderResultArray[1] = 0
  end
  return PlayerColliderResultArray
end

function PvePhysicsUtil.ResetPlayerColliderData()
  BattleColliderUtils.ResetPlayerColliderData()
end

function PvePhysicsUtil.ObstacleCollider()
  if ObstacleColliderResultArray == nil then
    ObstacleColliderResultArray = LuaCSharpArray.New(1)
    ObstacleColliderResultArrayAccess = ObstacleColliderResultArray:GetCSharpAccess()
    BattleColliderUtils.InitObstacleColliderResultAccess(ObstacleColliderResultArrayAccess)
  end
  local res = BattleColliderUtils.ObstacleColliderLuaArray()
  if not res then
    ObstacleColliderResultArray[1] = 0
  end
  return ObstacleColliderResultArray
end

function PvePhysicsUtil.ResetObstacleColliderData()
  BattleColliderUtils.ResetObstacleColliderData()
end

function PvePhysicsUtil.TryGetSurfingPlayerCollideZ(attackerObjId)
  return BattleColliderUtils.TryGetSurfingPlayerCollideZ(attackerObjId)
end

function PvePhysicsUtil.TryGetGhostPlayerCollideDir(attackerObjId)
  return BattleColliderUtils.TryGetGhostPlayerCollideDir(attackerObjId)
end

function PvePhysicsUtil.ResizePlayerColliderResultArray(size)
  if PlayerColliderResultArray ~= nil then
    PlayerColliderResultArray[size] = 0
    return true
  end
  return false
end

function PvePhysicsUtil.ResizeObstacleColliderResultArray(size)
  if ObstacleColliderResultArray ~= nil then
    ObstacleColliderResultArray[size] = 0
    return true
  end
  return false
end

function PvePhysicsUtil.UnInitPlayerCollider()
  if PlayerColliderResultArray then
    PlayerColliderResultArray:DestroyCSharpAccess()
    PlayerColliderResultArray = nil
    PlayerColliderResultArrayAccess = nil
    BattleColliderUtils.UnInitPlayerColliderResultAccess()
  end
end

function PvePhysicsUtil.UnInitObstacleCollider()
  if ObstacleColliderResultArray then
    ObstacleColliderResultArray:DestroyCSharpAccess()
    ObstacleColliderResultArray = nil
    ObstacleColliderResultArrayAccess = nil
    BattleColliderUtils.UnInitObstacleColliderResultAccess()
  end
end

function PvePhysicsUtil.UnInit()
  PvePhysicsUtil.UnInitBulletCollider()
  PvePhysicsUtil.UnInitMonsterCollider()
  PvePhysicsUtil.UnInitUnitCollider()
  PvePhysicsUtil.UnInitPlayerCollider()
  PvePhysicsUtil.UnInitObstacleCollider()
  PvePhysicsUtil.ExitBattle()
end

return ConstClass("PvePhysicsUtil", PvePhysicsUtil)
