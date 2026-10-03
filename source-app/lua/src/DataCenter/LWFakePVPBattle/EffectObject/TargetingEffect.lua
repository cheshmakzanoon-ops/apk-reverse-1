local TargetingEffect = BaseClass("targetingEffect")
local Resource = CS.GameEntry.Resource

function TargetingEffect:__init()
  self.srcIdx = nil
  self.dstIdx = nil
  self.dstEffectPath = nil
  self.dstEffectReq = nil
  self.lineEffectPath = nil
  self.lineEffectReq = nil
  self.logic = nil
  self.lineTransform = nil
  self.lineRenderers = nil
  self.dstEffectGo = nil
end

function TargetingEffect:Init(srcIdx, dstIdx, dstEffectPath, lineEffectPath, logic)
  self.srcIdx = srcIdx
  self.dstIdx = dstIdx
  self.dstEffectPath = dstEffectPath
  self.dstEffectReq = nil
  self.lineEffectPath = lineEffectPath
  self.lineEffectReq = nil
  self.logic = logic
end

function TargetingEffect:GetStartIdxPos()
  return self:GetPosByIdx(self.srcIdx)
end

function TargetingEffect:GetTargetIdxPos()
  return self:GetPosByIdx(self.dstIdx)
end

function TargetingEffect:GetPosByIdx(idx)
  local unitPos = Vector3.zero
  local sceneData = self.logic.sceneData
  local enemyOffset = self.logic.LINEUP_ENEMY_OFFSET or Vector3.zero
  local squad = self.logic.squad
  if not sceneData.IsSelfUnitsPVPSlot(idx) then
    unitPos = (enemyOffset or Vector3.zero) + sceneData.scenePosOffset
    unitPos.x = unitPos.x - sceneData.platoonLocalPos[idx].x
    unitPos.y = 0.2
    unitPos.z = unitPos.z - sceneData.platoonLocalPos[idx].z
  else
    unitPos = squad:GetFormationPosByIndex(idx) + sceneData.armyBirthPos[1]
  end
  return unitPos
end

function TargetingEffect:Load()
  if not self.logic then
    return
  end
  local selfUnitPos = self:GetStartIdxPos()
  local targetUnitPos = self:GetTargetIdxPos()
  if self.dstEffectPath and not self.dstEffectReq then
    self.dstEffectReq = Resource:InstantiateAsync(self.dstEffectPath, ObjectPoolTag.Battle)
    self.dstEffectReq:completed("+", function(req)
      local req = self.dstEffectReq
      local go = req.gameObject
      if not IsNull(go) then
        local transform = go.transform
        transform:Set_position(targetUnitPos.x, targetUnitPos.y, targetUnitPos.z)
        transform:Set_localScale(1, 1, 1)
        transform:Set_eulerAngles(0, 0, 0)
        go:SetActive(true)
        self.dstEffectGo = go
      end
    end)
  end
  if self.lineEffectPath and not self.lineEffectReq then
    self.lineEffectReq = Resource:InstantiateAsync(self.lineEffectPath, ObjectPoolTag.Battle)
    self.lineEffectReq:completed("+", function(req)
      local req = self.lineEffectReq
      local go = req.gameObject
      if not IsNull(go) then
        local transform = go.transform
        transform:Set_position(selfUnitPos.x, selfUnitPos.y, selfUnitPos.z)
        transform:Set_localScale(1, 1, 1)
        transform:Set_eulerAngles(0, 0, 0)
        local posArray = {}
        posArray[1] = selfUnitPos
        posArray[2] = targetUnitPos
        local lineRenderers = go:GetComponentsInChildren(typeof(CS.UnityEngine.LineRenderer))
        local lua_arr
        if not IsNull(lineRenderers) and 0 < lineRenderers.Length then
          lua_arr = {}
          for i = 0, lineRenderers.Length - 1 do
            table.insert(lua_arr, lineRenderers[i])
          end
        end
        if not table.IsNullOrEmpty(lua_arr) then
          for i = 1, #lua_arr do
            lua_arr[i]:SetPositions(posArray)
          end
        end
        go:SetActive(true)
        self.lineTransform = transform
        self.lineRenderers = lua_arr
      end
    end)
  end
end

function TargetingEffect:Unload()
  if self.dstEffectReq then
    self.dstEffectReq:Destroy()
    self.dstEffectReq = nil
  end
  if self.lineEffectReq then
    self.lineEffectReq:Destroy()
    self.lineEffectReq = nil
  end
  self.lineTransform = nil
  self.lineRenderers = nil
  self.dstEffectGo = nil
end

function TargetingEffect:__delete()
  self:Unload()
  self.srcIdx = nil
  self.dstIdx = nil
  self.dstEffectPath = nil
  self.dstEffectReq = nil
  self.lineEffectPath = nil
  self.lineEffectReq = nil
  self.sceneData = nil
end

function TargetingEffect.GetHash(srcIdx, dstIdx, dstEffectPath, lineEffectPath)
  local hash = 17
  hash = hash * 31 + (srcIdx or 0)
  hash = hash * 31 + (dstIdx or 0)
  hash = hash * 31 + (dstEffectPath and string.len(dstEffectPath) or 0)
  hash = hash * 31 + (lineEffectPath and string.len(lineEffectPath) or 0)
  return hash
end

function TargetingEffect:UpdateStartPos(pos)
  if self.lineTransform then
    self.lineTransform:Set_position(pos)
  end
  if not table.IsNullOrEmpty(self.lineRenderers) then
    local posArray = {}
    posArray[1] = pos
    posArray[2] = self.lineRenderers[1]:GetPosition(1)
    for i = 1, #self.lineRenderers do
      self.lineRenderers[i]:SetPosition(0, pos)
    end
  end
end

function TargetingEffect:UpdateTargetPos(pos)
  if not table.IsNullOrEmpty(self.lineRenderers) then
    local posArray = {}
    posArray[1] = self.lineRenderers[1]:GetPosition(0)
    posArray[2] = pos
    for i = 1, #self.lineRenderers do
      self.lineRenderers[i]:SetPositions(posArray)
    end
  end
end

function TargetingEffect:ReplayDstEffect()
  if self.dstEffectGo then
    self.dstEffectGo:SetActive(false)
    self.dstEffectGo:SetActive(true)
  end
end

function TargetingEffect.GetOppositeIdx(sceneData, allUnits, idx)
  return sceneData.GetOpponentHero(idx)
end

return TargetingEffect
