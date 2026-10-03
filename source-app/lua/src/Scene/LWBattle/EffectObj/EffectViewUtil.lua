local EffectViewUtil = {}
local EffectViewLuaArray, EffectViewLuaArrayAccess, EffectViewFacade
local viewNameMap = {}
local viewNameId = 0

function EffectViewUtil.InitView()
  if EffectViewLuaArray == nil then
    EffectViewLuaArray = LuaCSharpArray.New(16)
    EffectViewLuaArrayAccess = EffectViewLuaArray:GetCSharpAccess()
    EffectViewFacade = CS.PVEBattleLogic.Effect.EffectViewFacade
    EffectViewFacade.InitEffectViewArrayAccess(EffectViewLuaArrayAccess)
  end
end

function EffectViewUtil.ClearAll()
  if EffectViewFacade then
    EffectViewFacade.ClearAll()
  end
end

function EffectViewUtil.UnInitView()
  if EffectViewLuaArray ~= nil then
    EffectViewLuaArray:DestroyCSharpAccess()
    EffectViewLuaArray = nil
    EffectViewLuaArrayAccess = nil
    EffectViewFacade.UnInitEffectViewArrayAccess()
    EffectViewFacade.ClearAll()
    EffectViewFacade = nil
  end
end

function EffectViewUtil.Update(deltaTime)
  if EffectViewFacade then
    EffectViewFacade.Update(deltaTime)
  end
end

function EffectViewUtil.GetEffectViewNameId(viewName)
  local id = viewNameMap[viewName]
  if id ~= nil then
    return id
  end
  viewNameId = viewNameId + 1
  id = viewNameId
  viewNameMap[viewName] = id
  EffectViewFacade.SyncNameId(viewName, id)
  return id
end

function EffectViewUtil.PreloadEffectGameObject(viewName, count)
  local viewId = EffectViewUtil.GetEffectViewNameId(viewName)
  EffectViewFacade.PreloadEffectGameObjectWhitId(viewId, count)
end

function EffectViewUtil.ShowEffectOnlyParent(path, time, type, parent, scale)
  local viewId = EffectViewUtil.GetEffectViewNameId(path)
  EffectViewLuaArray[1] = viewId
  EffectViewLuaArray[2] = time
  EffectViewLuaArray[3] = type
  EffectViewLuaArray[4] = scale and scale or 1
  if parent == nil then
    return EffectViewFacade.ShowEffectDefaultLuaAccess()
  else
    return EffectViewFacade.ShowEffectDefaultParentLuaAccess(parent)
  end
end

function EffectViewUtil.ShowEffectZeroPos(path, time, type, rot, parent)
  local viewId = EffectViewUtil.GetEffectViewNameId(path)
  EffectViewLuaArray[1] = viewId
  EffectViewLuaArray[2] = time
  EffectViewLuaArray[3] = type
  EffectViewLuaArray[4] = rot.x
  EffectViewLuaArray[5] = rot.y
  EffectViewLuaArray[6] = rot.z
  EffectViewLuaArray[7] = rot.w
  if parent == nil then
    return EffectViewFacade.ShowEffectZeroPosLuaAccess()
  else
    return EffectViewFacade.ShowEffectZeroPosParentLuaAccess(parent)
  end
end

function EffectViewUtil.ShowEffectZeroRot(path, time, type, pos, parent)
  local viewId = EffectViewUtil.GetEffectViewNameId(path)
  EffectViewLuaArray[1] = viewId
  EffectViewLuaArray[2] = time
  EffectViewLuaArray[3] = type
  EffectViewLuaArray[4] = pos.x
  EffectViewLuaArray[5] = pos.y
  EffectViewLuaArray[6] = pos.z
  if parent == nil then
    return EffectViewFacade.ShowEffectZeroRotLuaAccess()
  else
    return EffectViewFacade.ShowEffectZeroRotParentLuaAccess(parent)
  end
end

function EffectViewUtil.ShowEffect(path, time, type, pos, rot, parent)
  local viewId = EffectViewUtil.GetEffectViewNameId(path)
  EffectViewLuaArray[1] = viewId
  EffectViewLuaArray[2] = time
  EffectViewLuaArray[3] = type
  EffectViewLuaArray[4] = pos.x
  EffectViewLuaArray[5] = pos.y
  EffectViewLuaArray[6] = pos.z
  EffectViewLuaArray[7] = rot.x
  EffectViewLuaArray[8] = rot.y
  EffectViewLuaArray[9] = rot.z
  EffectViewLuaArray[10] = rot.w
  if parent == nil then
    return EffectViewFacade.ShowEffectLuaArray()
  else
    return EffectViewFacade.ShowEffectParentLuaArray(parent)
  end
end

function EffectViewUtil.ShowHitEffectForViewTarget(path, worldPos, worldHitDir, hitDirType, time, parentViewHandle, type, hitEffectLimitNum, useLossyScale)
  local viewId = EffectViewUtil.GetEffectViewNameId(path)
  EffectViewLuaArray[1] = viewId
  EffectViewLuaArray[2] = time
  EffectViewLuaArray[3] = type
  if worldPos ~= nil then
    EffectViewLuaArray[4] = worldPos.x
    EffectViewLuaArray[5] = worldPos.y
    EffectViewLuaArray[6] = worldPos.z
  else
    EffectViewLuaArray[4] = -1
    EffectViewLuaArray[5] = -1
    EffectViewLuaArray[6] = -1
  end
  local lossyScale = useLossyScale and 1 or 0
  if worldHitDir == nil then
    EffectViewLuaArray[7] = parentViewHandle
    EffectViewLuaArray[8] = lossyScale
    EffectViewFacade.ShowHitEffectForViewTargetZeroRot()
  else
    EffectViewLuaArray[7] = worldHitDir.x
    EffectViewLuaArray[8] = worldHitDir.y
    EffectViewLuaArray[9] = worldHitDir.z
    EffectViewLuaArray[10] = hitDirType
    EffectViewLuaArray[11] = parentViewHandle
    local limit = hitEffectLimitNum and hitEffectLimitNum or 0
    EffectViewLuaArray[12] = limit
    EffectViewLuaArray[13] = lossyScale
    EffectViewFacade.ShowHitEffectForViewTarget()
  end
end

function EffectViewUtil.ShowEffectParent(id, parent)
  if EffectViewFacade then
    EffectViewFacade.ShowEffectParents(id, parent)
  end
end

function EffectViewUtil.ResetPosition(id, x, y, z)
  if EffectViewFacade then
    EffectViewFacade.ResetPosition(id, x, y, z)
  end
end

function EffectViewUtil.RemoveEffect(id)
  if EffectViewFacade then
    EffectViewFacade.RemoveEffect(id)
  end
end

function EffectViewUtil.RemoveAllHitEffectByParentViewHandle(parentViewHandle)
  if EffectViewFacade then
    EffectViewFacade.RemoveAllHitEffectByParentViewHandle(parentViewHandle)
  end
end

return ConstClass("EffectViewUtil", EffectViewUtil)
