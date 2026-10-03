local PosConverse = {}

function PosConverse.WorldToScreenPos(worldPos, camera)
  local screenPos = CS.UnityEngine.RectTransformUtility.WorldToScreenPoint(camera, worldPos)
  return screenPos
end

function PosConverse.ScreenToUIPos(rect, screenPos)
  if CS.GameEntry.UICamera ~= nil then
    local _, localPoint = CS.UnityEngine.RectTransformUtility.ScreenPointToLocalPointInRectangle(rect, screenPos, CS.GameEntry.UICamera)
    return localPoint
  else
    Logger.LogError("Cant find UICamera")
    return Vector3.zero
  end
end

function PosConverse.UIWorldToScreenPos(worldPos)
  if CS.GameEntry.UICamera ~= nil then
    local screenPos = CS.UnityEngine.RectTransformUtility.WorldToScreenPoint(CS.GameEntry.UICamera, worldPos)
    return screenPos
  else
    Logger.LogError("Cant find UICamera")
    return Vector3.zero
  end
end

function PosConverse.ScreenToUIWorldPos(screenPos, targetRectTransform)
  local camera = CS.GameEntry.UICamera
  if camera ~= nil then
    local success, worldPoint = CS.UnityEngine.RectTransformUtility.ScreenPointToWorldPointInRectangle(targetRectTransform, screenPos, camera)
    if success then
      return worldPoint
    end
    return Vector3.zero
  else
    Logger.LogError("Cant find UICamera")
    return Vector3.zero
  end
end

function PosConverse.WorldToAnchoredPosition(worldPos, targetRectTransform)
  local camera = CS.GameEntry.UICamera
  if camera ~= nil then
    local screenPoint = CS.UnityEngine.RectTransformUtility.WorldToScreenPoint(camera, worldPos)
    local localPoint = CS.PointUtils.ScreenPointToLocalPointInRectangle(targetRectTransform, screenPoint, camera)
    return localPoint
  end
  return Vector2.zero
end

return PosConverse
