local BulletViewUtil = {}
local BulletViewLuaArray, BulletViewLuaArrayAccess, CreateStraightLuaArray, CreateStraightLuaArrayAccess, CreateStraightListLuaArray, CreateStraightListLuaArrayAccess, CreateStraightGatlingLuaArray, CreateStraightGatlingLuaArrayAccess, BulletViewFacade
local loadedCount = 0
local viewNameMap = {}
local viewNameId = 0
local animationCurveMap = {}
local animationCurveId = 0
local INVALID_HANDLE = -1
local lastUpdateStraightFrame = 0

function BulletViewUtil.InitView()
  if BulletViewLuaArray == nil then
    BulletViewLuaArray = LuaCSharpArray.New(1024)
    BulletViewLuaArrayAccess = BulletViewLuaArray:GetCSharpAccess()
    CreateStraightLuaArray = LuaCSharpArray.New(32)
    CreateStraightLuaArrayAccess = CreateStraightLuaArray:GetCSharpAccess()
    CreateStraightListLuaArray = LuaCSharpArray.New(4096)
    CreateStraightListLuaArrayAccess = CreateStraightListLuaArray:GetCSharpAccess()
    CreateStraightGatlingLuaArray = LuaCSharpArray.New(640)
    CreateStraightGatlingLuaArrayAccess = CreateStraightGatlingLuaArray:GetCSharpAccess()
    BulletViewFacade = CS.PVEBattleLogic.Bullet.BulletViewFacade
    BulletViewFacade.InitBulletViewArrayAccess(BulletViewLuaArrayAccess, CreateStraightLuaArrayAccess, CreateStraightListLuaArrayAccess, CreateStraightGatlingLuaArrayAccess)
  end
end

function BulletViewUtil.ClearData()
  if BulletViewFacade ~= nil then
    BulletViewFacade.ClearAll()
  end
end

function BulletViewUtil.UnInitView()
  if BulletViewLuaArray ~= nil then
    BulletViewLuaArray:DestroyCSharpAccess()
    BulletViewLuaArray = nil
    BulletViewLuaArrayAccess = nil
    CreateStraightLuaArray:DestroyCSharpAccess()
    CreateStraightLuaArray = nil
    CreateStraightLuaArrayAccess = nil
    CreateStraightListLuaArray:DestroyCSharpAccess()
    CreateStraightListLuaArray = nil
    CreateStraightListLuaArrayAccess = nil
    CreateStraightGatlingLuaArray:DestroyCSharpAccess()
    CreateStraightGatlingLuaArray = nil
    CreateStraightGatlingLuaArrayAccess = nil
    BulletViewFacade.UnInitBulletViewArrayAccess()
    BulletViewFacade.ClearAll()
    BulletViewFacade = nil
  end
end

function BulletViewUtil.CheckLoadedCount()
  BulletViewFacade.CheckLoaded()
  loadedCount = BulletViewLuaArray[1]
  return loadedCount
end

function BulletViewUtil.GetLoadedObjId(index)
  if index <= loadedCount then
    local idIndex = index * 2
    local cdIndex = index * 2 + 1
    return BulletViewLuaArray[idIndex], BulletViewLuaArray[cdIndex]
  end
  return 0
end

function BulletViewUtil.UpdateStraightCount(deltaTime)
  local curFrame = Time.frameCount
  if lastUpdateStraightFrame == curFrame then
    deltaTime = 0
  else
    lastUpdateStraightFrame = curFrame
  end
  local res = BulletViewFacade.UpdateStraightLuaArray(deltaTime)
  if not res then
    BulletViewLuaArray[1] = 0
  end
  loadedCount = BulletViewLuaArray[1]
  return loadedCount
end

function BulletViewUtil.GetStraight(index)
  if index <= loadedCount then
    index = index * 2
    local objId = BulletViewLuaArray[index]
    local lifeEnd = BulletViewLuaArray[index + 1]
    return objId, lifeEnd
  end
end

function BulletViewUtil.ResizeBulletViewLuaArray(size)
  if BulletViewLuaArray ~= nil then
    BulletViewLuaArray[size] = 0
    return true
  end
  return false
end

function BulletViewUtil.GetBulletViewNameId(viewName)
  local id = viewNameMap[viewName]
  if id ~= nil then
    return id
  end
  viewNameId = viewNameId + 1
  id = viewNameId
  viewNameMap[viewName] = id
  BulletViewFacade.SyncNameId(viewName, id)
  return id
end

function BulletViewUtil.GetAnimationCurveId(animationCurve)
  local id = animationCurveMap[animationCurve]
  if id ~= nil then
    return id
  end
  animationCurveId = animationCurveId + 1
  id = animationCurveId
  animationCurveMap[animationCurve] = id
  BulletViewFacade.SyncAnimationCurve(animationCurve, id)
  return id
end

function BulletViewUtil.CreateStraightView(viewName, objId, startPosX, startPosY, startPosZ, rotY, targetLayerMask, inertiaVelocityX, inertiaVelocityY, inertiaVelocityZ, lifeTime, bulletScale, colliderRadius, noCollision, duration, spiral_loops, spiral_radius, speed, curve, colliderType, defaultDotCD, needSetGrowShader)
  local viewId = BulletViewUtil.GetBulletViewNameId(viewName)
  local noCollisionValue = noCollision and 1 or 0
  local curveId = BulletViewUtil.GetAnimationCurveId(curve)
  local colliderTypeValue = colliderType and 1 or 0
  CreateStraightLuaArray[1] = viewId
  CreateStraightLuaArray[2] = objId
  CreateStraightLuaArray[3] = startPosX
  CreateStraightLuaArray[4] = startPosY
  CreateStraightLuaArray[5] = startPosZ
  CreateStraightLuaArray[6] = rotY
  CreateStraightLuaArray[7] = targetLayerMask
  CreateStraightLuaArray[8] = inertiaVelocityX
  CreateStraightLuaArray[9] = inertiaVelocityY
  CreateStraightLuaArray[10] = inertiaVelocityZ
  CreateStraightLuaArray[11] = lifeTime
  CreateStraightLuaArray[12] = bulletScale
  CreateStraightLuaArray[13] = colliderRadius
  CreateStraightLuaArray[14] = noCollisionValue
  CreateStraightLuaArray[15] = duration
  CreateStraightLuaArray[16] = spiral_loops
  CreateStraightLuaArray[17] = spiral_radius
  CreateStraightLuaArray[18] = speed
  CreateStraightLuaArray[19] = curveId
  CreateStraightLuaArray[20] = colliderTypeValue
  CreateStraightLuaArray[21] = defaultDotCD
  CreateStraightLuaArray[22] = needSetGrowShader
  return BulletViewFacade.CreateBulletViewStraightLuaArray()
end

function BulletViewUtil.PreStraightViewList(bullet, index)
  local indexFix = 32 * (index - 1)
  local viewId = BulletViewUtil.GetBulletViewNameId(bullet.bulletEffectStraight)
  local noCollisionValue = noCollision and 1 or 0
  local curveId = BulletViewUtil.GetAnimationCurveId(bullet.curveStraight)
  local colliderTypeValue = colliderType and 1 or 0
  CreateStraightListLuaArray[indexFix + 1] = viewId
  CreateStraightListLuaArray[indexFix + 2] = bullet.objId
  CreateStraightListLuaArray[indexFix + 3] = bullet.startPos.x
  CreateStraightListLuaArray[indexFix + 4] = bullet.startPos.y
  CreateStraightListLuaArray[indexFix + 5] = bullet.startPos.z
  CreateStraightListLuaArray[indexFix + 6] = bullet.rotY
  CreateStraightListLuaArray[indexFix + 7] = bullet.targetLayerMask
  CreateStraightListLuaArray[indexFix + 8] = bullet.inertiaVelocity.x
  CreateStraightListLuaArray[indexFix + 9] = bullet.inertiaVelocity.y
  CreateStraightListLuaArray[indexFix + 10] = bullet.inertiaVelocity.z
  CreateStraightListLuaArray[indexFix + 11] = bullet.lifetime
  CreateStraightListLuaArray[indexFix + 12] = bullet.bulletScale
  CreateStraightListLuaArray[indexFix + 13] = bullet.meta.colliderRadius
  CreateStraightListLuaArray[indexFix + 14] = bullet.noCollision ~= nil
  CreateStraightListLuaArray[indexFix + 15] = bullet.duration
  CreateStraightListLuaArray[indexFix + 16] = bullet.meta.spiral_loops
  CreateStraightListLuaArray[indexFix + 17] = bullet.meta.spiral_radius
  CreateStraightListLuaArray[indexFix + 18] = bullet.speedStraight
  CreateStraightListLuaArray[indexFix + 19] = curveId
  CreateStraightListLuaArray[indexFix + 20] = bullet.base_type == BulletDurabilityType.Collide or bullet.base_type == BulletDurabilityType.CollideInfinity
  CreateStraightListLuaArray[indexFix + 21] = bullet.dotMaxCD
  CreateStraightListLuaArray[indexFix + 22] = bullet.needSetGrowShader
end

function BulletViewUtil.CreateStraightViewList(bulletManger, bulletList, count)
  if 0 < count then
    local success = BulletViewFacade.CreateBulletViewStraightListLuaArray(count)
    for i = 1, count do
      local bullet = bulletList[i]
      local indexFix = 32 * (i - 1)
      bullet:AfterCreateViewList(CreateStraightListLuaArray[indexFix + 1], CreateStraightListLuaArray[indexFix + 2] == 1, CreateStraightListLuaArray[indexFix + 3])
      bulletManger:TryAddBullet(bullet, true)
    end
  end
end

function BulletViewUtil.SyncStraightGatlingViewData(data)
  local viewId = BulletViewUtil.GetBulletViewNameId(data.bulletEffect)
  local curveId = BulletViewUtil.GetAnimationCurveId(data.curve)
  local colliderTypeValue = 1
  local noCollisionValue = data.noCollision and 1 or 0
  CreateStraightLuaArray[1] = viewId
  CreateStraightLuaArray[2] = data.targetLayerMask
  CreateStraightLuaArray[3] = data.inertiaVelocityX
  CreateStraightLuaArray[4] = data.inertiaVelocityY
  CreateStraightLuaArray[5] = data.inertiaVelocityZ
  CreateStraightLuaArray[6] = data.lifeTime
  CreateStraightLuaArray[7] = data.bulletScale
  CreateStraightLuaArray[8] = data.colliderRadius
  CreateStraightLuaArray[9] = noCollisionValue
  CreateStraightLuaArray[10] = data.duration
  CreateStraightLuaArray[11] = data.speed
  CreateStraightLuaArray[12] = curveId
  CreateStraightLuaArray[13] = colliderTypeValue
  CreateStraightLuaArray[14] = data.needSetGrowShader
  BulletViewFacade.SyncStraightGatlingViewDataLuaArray()
end

function BulletViewUtil.CreateStraightGatlingView(objId, ownerHandle)
  CreateStraightLuaArray[1] = objId
  CreateStraightLuaArray[2] = ownerHandle
  local viewHandle = BulletViewFacade.CreateStraightGatlingViewLuaArray()
  if viewHandle > INVALID_HANDLE then
    return viewHandle, CreateStraightLuaArray[1], CreateStraightLuaArray[2], CreateStraightLuaArray[3], CreateStraightLuaArray[4]
  end
  return viewHandle, 0, 0, 0, 0
end

function BulletViewUtil.PreStraightGatlingViewList(bullet, index)
  local indexFix = 5 * (index - 1)
  CreateStraightGatlingLuaArray[indexFix + 1] = bullet.objId
  CreateStraightGatlingLuaArray[indexFix + 2] = bullet.owner.viewHandle
end

function BulletViewUtil.CreateStraightGatlingViewList(bulletManger, bulletList, count)
  if 0 < count then
    local success = BulletViewFacade.CreateStraightGatlingViewListLuaArray(count)
    for i = 1, count do
      local bullet = bulletList[i]
      local indexFix = 5 * (i - 1)
      bullet:AfterCreateViewList(CreateStraightGatlingLuaArray[indexFix + 1], CreateStraightGatlingLuaArray[indexFix + 2], CreateStraightGatlingLuaArray[indexFix + 3], CreateStraightGatlingLuaArray[indexFix + 4], CreateStraightGatlingLuaArray[indexFix + 5])
      bulletManger:TryAddBullet(bullet, true)
    end
  end
end

return ConstClass("BulletViewUtil", BulletViewUtil)
