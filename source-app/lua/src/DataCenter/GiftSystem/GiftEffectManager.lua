local GiftEffectManager = BaseClass("GiftEffectManager")
local Resource = CS.GameEntry.Resource
local effectNameCount = 0
local GiftCheerEffectItem = require("UI/LWPlayerInfo/UILWGiftSystem/Common/GiftCheerEffectItem")
local effectConfig = GiftSystemConst.CheerEffectConfig
local prefabPath = "Assets/Main/Prefabs/UI/LWPlayerInfo/GiftSystem/GiftCheerEffectItem.prefab"

function GiftEffectManager:AddCheerEffect(param)
  if not (param and param.parent) or not param.effectInfo then
    return
  end
  local parentTransform = param.parent.transform
  local cfg = effectConfig
  local targetTrans = param.targetTrans
  local info = param.effectInfo
  local baseX, baseY, rect
  if targetTrans then
    local localPos = parentTransform:InverseTransformPoint(targetTrans.position)
    baseX, baseY = localPos.x, localPos.y
  else
    rect = parentTransform.rect
  end
  local res
  local giftId = info.giftId
  local playerUid = info.playerUid
  local spawnFromLeft = math.random() > 0.5
  local startX, startY, targetPos
  if targetTrans then
    local offset = cfg.targetOffsetSmall
    startX = spawnFromLeft and baseX + cfg.startOffsetX or baseX - cfg.startOffsetX
    startY = baseY + cfg.startOffsetY
    targetPos = Vector3.New(startX + (spawnFromLeft and offset or -offset), startY + offset, 0)
  else
    local halfWidth, halfHeight = rect.width * 0.5, rect.height * 0.5
    startX = math.random(math.floor(-halfWidth * 0.8), math.floor(halfWidth * 0.8))
    startY = math.random(math.floor(-halfHeight * 0.8), math.floor(halfHeight * 0.8))
    local offsetX = spawnFromLeft and cfg.targetOffsetSmall or -cfg.targetOffsetSmall
    targetPos = Vector3.New(startX + offsetX, startY + cfg.targetOffsetSmall, 0)
  end
  res = Resource:InstantiateAsync(prefabPath)
  res:completed("+", function(request)
    if request.isError then
      res = nil
      return
    end
    effectNameCount = effectNameCount + 1
    local cheerObject = request.gameObject
    cheerObject.name = "GiftEffectCheer_" .. effectNameCount
    cheerObject:SetActive(true)
    local trans = cheerObject.transform
    trans:SetParent(parentTransform)
    trans:Set_localScale(cfg.scale, cfg.scale, cfg.scale)
    local cheerComponent = param.parent:GetComponent(cheerObject.name, GiftCheerEffectItem)
    cheerComponent = cheerComponent or param.parent:AddComponent(GiftCheerEffectItem, cheerObject.name)
    if cheerComponent then
      local isLeft = startX < 0
      cheerComponent:ReInit(playerUid, isLeft, giftId)
      cheerComponent:SetLocalPositionXYZ(startX, startY, 0)
    end
    trans:DOLocalMove(targetPos, cfg.moveDuration):SetDelay(cfg.moveDelay):OnComplete(function()
      if param.parent then
        param.parent:RemoveComponent(cheerObject.name, GiftCheerEffectItem)
        request:Destroy()
        res = nil
      end
    end)
  end)
  return res
end

function GiftEffectManager:RemoveCheerComponents(effectParent)
  if not effectParent or not effectParent.RemoveComponents then
    return
  end
  effectParent:RemoveComponents(GiftCheerEffectItem)
end

return GiftEffectManager
