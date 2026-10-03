local AllianceBaseSkill = BaseClass("AllianceBaseSkill")

function AllianceBaseSkill:OnCreate(go)
  if go ~= nil then
    self.gameObject = go
    self.transform = go.transform
  end
  if self.updateTimer == nil then
    self.updateTimer = TimerManager:GetInstance():GetTimer(0.05, self.Tick, self, false, false, false)
    self.updateTimer:Start()
  end
  self.releaseFinish = nil
  self.destroyStatus = false
end

function AllianceBaseSkill:OnDestroy()
  if not IsNull(self.gameObject) then
    self.gameObject:SetActive(false)
  end
  if self.updateTimer then
    self.updateTimer:Stop()
    self.updateTimer = nil
  end
  self:ReleaseAll()
  self.releaseFinish = nil
  self.destroyStatus = true
  self.startEffects = nil
  self.loopEffects = nil
  self.endEffects = nil
end

function AllianceBaseSkill:ReInit(uuid, fireTime, skillId, unityConfig)
  self.error = false
  self.uuid = uuid
  self.skillId = skillId
  self.unityConfig = unityConfig
  if not self.unityConfig then
    self.error = true
    Logger.LogWarning("[AllianceSkill] ReInit Error unityConfig is Null uuid: " .. uuid .. "skillId: " .. skillId)
    return
  end
  local theWorld = CS.SceneManager.World
  if not theWorld then
    self.error = true
    Logger.LogWarning("[AllianceSkill] ReInit Error World is Null uuid: " .. uuid .. "skillId: " .. skillId)
    return
  end
  self.info = CS.SceneManager.World:GetPointInfoByUuid(uuid)
  if IsNull(self.info) then
    Logger.LogWarning("[AllianceSkill] ReInit Error PointInfo is Null uuid: " .. uuid .. "skillId: " .. skillId)
    self.error = true
    return
  end
  if self.info.PointType ~= WorldPointType.PlayerBuilding then
    Logger.LogWarning("[AllianceSkill] ReInit Error PointType is not PlayerBuilding uuid: " .. uuid .. "skillId: " .. skillId)
    self.error = true
    return
  end
  self.skillConfig = DataCenter.AllianceGovernmentSkillManager:GetTemplatesById(skillId)
  if not self.skillConfig then
    Logger.LogWarning("[AllianceSkill] ReInit Error SkillConfig is Null uuid: " .. uuid .. "skillId: " .. skillId)
    self.error = true
    return
  end
  if self.gameObject then
    self.effectGo = self.gameObject.transform:Find("ModelGo/EffectGo")
    if not IsNull(self.effectGo) then
      self.effectGo.gameObject:SetActive(true)
    end
  end
  self.aosEndTime = toInt(fireTime)
  self.aosStartTime = toInt(self.info.aosStartTime)
  self.fireTime = self.aosEndTime
  self.timeAction = {}
  self.skillRequest = {}
  self.displayEffects = {}
  self.goEffects = {}
  self.startEffects = {}
  self.loopEffects = {}
  self.endEffects = {}
  local startEffects = self.unityConfig:GetBaseEffectsByType(AllianceEffectType.Start)
  if startEffects then
    for _, v in ipairs(startEffects) do
      table.insert(self.startEffects, {
        data = v,
        played = false,
        time = self.info.aosStartTime
      })
    end
  end
  local loopEffects = self.unityConfig:GetBaseEffectsByType(AllianceEffectType.Loop)
  if loopEffects then
    for _, v in ipairs(loopEffects) do
      table.insert(self.loopEffects, {data = v, played = false})
    end
  end
  local endEffects = self.unityConfig:GetBaseEffectsByType(AllianceEffectType.End)
  if endEffects then
    for _, v in ipairs(endEffects) do
      table.insert(self.endEffects, {
        data = v,
        played = false,
        time = self.info.aosEndTime
      })
    end
  end
  self.displayLv = DisplaySettings.GetCurrentDisplayLevel()
  if self.gameObject then
    self.gameObject:SetActive(true)
  end
  self:Init()
end

function AllianceBaseSkill:Update(theWorld)
  if self.error then
    self:ReleaseAll()
    return
  end
  self:OnTickSec(theWorld)
end

function AllianceBaseSkill:OnUpdatePoint()
  if self.error then
    self:ReleaseAll()
    return
  end
  local theWorld = CS.SceneManager.World
  if not theWorld then
    self.error = true
    Logger.Log("[AllianceSkill] ReInit Error World is Null uuid: " .. self.uuid .. "skillId: " .. self.skillId)
    return
  end
  if IsNull(self.info) and self.uuid ~= nil then
    self.info = CS.SceneManager.World:GetPointInfoByUuid(self.uuid)
    if not IsNull(self.info) then
      self.aosStartTime = toInt(self.info.aosStartTime)
      self.aosEndTime = toInt(self.info.aosEndTime)
    end
  end
  self:DoUpdatePoint(theWorld)
end

function AllianceBaseSkill:OnLodChange(lod)
  if self.error then
    self:ReleaseAll()
    return
  end
  self.theLod = toInt(lod)
  Logger.Log("[AllianceSkill] OnLodChange " .. self.theLod .. "===> " .. lod)
  self:LodChange()
end

function AllianceBaseSkill:OnDisplayLevelChange(displayLv)
  if self.displayLv ~= displayLv then
    self.displayLv = displayLv
  end
  if self.displayLv <= -1 and self:NeedDisplayMode() then
    self:ReleaseDisplayEff()
    self:DoDisplayMode()
  end
end

function AllianceBaseSkill:ReleaseAll()
  if self.releaseFinish then
    return
  end
  self:ReleaseGos()
  self:ReleaseSkillEff()
  self:ReleaseTimeActions()
  self:Clear()
  self.releaseFinish = true
end

function AllianceBaseSkill:NeedDisplayMode()
  return false
end

function AllianceBaseSkill:Init()
end

function AllianceBaseSkill:Clear()
end

function AllianceBaseSkill:DoEffects()
  local now = UITimeManager:GetInstance():GetServerTime()
  if table.count(self.startEffects) > 0 then
    for _, effect in pairs(self.startEffects) do
      local playTime = self.aosStartTime + effect.data.StartTime * 1000
      local overTime = playTime + effect.data.OverTime * 1000
      if now < overTime then
        local canPlay = not effect.played
        canPlay = canPlay and playTime >= effect.time and now > playTime
        effect.time = now
        if canPlay then
          local playSuccess = self:DoPlayEffect(effect.data)
          if playSuccess ~= nil or not IsNull(playSuccess) then
            effect.played = true
          end
        end
      end
    end
  end
  if 0 < table.count(self.loopEffects) then
    for _, effect in pairs(self.loopEffects) do
      if not effect.played then
        local playSuccess = self:DoPlayEffect(effect.data)
        if playSuccess ~= nil or not IsNull(playSuccess) then
          effect.played = true
        end
      end
    end
  end
  if 0 < table.count(self.endEffects) then
    for _, effect in pairs(self.endEffects) do
      if not effect.played then
        local playTime = self.aosEndTime + effect.data.StartTime * 1000
        local canPlay = playTime >= effect.time and now > playTime
        effect.time = now
        if canPlay then
          local playSuccess = self:DoPlayEffect(effect.data)
          if playSuccess ~= nil or not IsNull(playSuccess) then
            effect.played = true
          end
        end
      end
    end
  end
end

function AllianceBaseSkill:DoTimerAction()
  local now = UITimeManager:GetInstance():GetServerTime()
  if self.timeAction then
    for _, v in pairs(self.timeAction) do
      if now >= v.time and not v.finish then
        if v.action then
          v.action()
          Logger.Log("[AllianceSkill] TimeAction Finish name: " .. v.name .. "uuid: " .. self.uuid .. "skillId: " .. self.skillId)
        end
        v.finish = true
      end
    end
  end
end

function AllianceBaseSkill:Tick()
  if self.error then
    self:ReleaseAll()
    return
  end
  self:DoEffects()
  self:DoTimerAction()
  self:OnTick()
end

function AllianceBaseSkill:OnTick()
end

function AllianceBaseSkill:OnTickSec(theWorld)
end

function AllianceBaseSkill:DoUpdatePoint(theWorld)
end

function AllianceBaseSkill:LodChange()
end

function AllianceBaseSkill:DoPlayEffect(effect)
  local effectPath = effect.Path
  local duration = effect.Duration
  local loadType = effect.LoadType
  local now = UITimeManager:GetInstance():GetServerTime()
  if loadType == AllianceEffectLoadType.Find then
    if not self:CanPlayEffect(effect) then
      return
    end
    local actionEffect = self.gameObject.transform:Find(effectPath)
    if actionEffect then
      actionEffect.gameObject:SetActive(false)
      actionEffect.gameObject:SetActive(true)
      if self.goEffects then
        table.insert(self.goEffects, actionEffect.gameObject)
      end
      if 0 < duration then
        self:SetTimeAction(effect.Tags, now + duration * 1000, function()
          if not IsNull(actionEffect) then
            actionEffect.gameObject:SetActive(false)
          end
        end)
      end
    end
    return actionEffect
  elseif loadType == AllianceEffectLoadType.Load then
    return self:PlaySkillEffBySelfPoint(effectPath, duration, self.effectGo or self.gameObject.transform, true, true, nil, effect)
  end
end

function AllianceBaseSkill:SetTimeAction(name, time, action)
  self.timeAction = self.timeAction or {}
  table.insert(self.timeAction, {
    name = name,
    time = time,
    action = action,
    timer = nil,
    finish = false
  })
end

function AllianceBaseSkill:DoDisplayMode()
end

function AllianceBaseSkill:DoUpdateObject()
  local obj = CS.SceneManager.World:GetObjectByUuid(self.uuid)
  if not IsNull(obj) then
    obj:UpdateGameObject()
  end
end

function AllianceBaseSkill:PlaySkillEffBySelfPoint(prefab, time, parent, addRequest, addGo, callback, effect)
  return self:PlaySkillEff(self:GetPointId(), prefab, time, parent, addRequest, addGo, callback, effect)
end

function AllianceBaseSkill:PlaySkillEff(pointId, prefab, time, parent, addRequest, addGo, callback, effect)
  if self.destroyStatus then
    return
  end
  if not SceneUtils.GetIsInWorld() then
    return
  end
  if self.theLod and self.theLod > 2 then
    return
  end
  if not self:CanPlayEffect(effect) then
    return
  end
  if IsNull(parent) then
    parent = CS.SceneManager.World.DynamicObjNode
  end
  local pos = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World, LuaEntry.Player:GetCurServerId())
  local theWorld = CS.SceneManager.World
  if theWorld then
    local vfxId = theWorld:CreateVFX(prefab, pos, time, 0, function(go)
      if self.destroyStatus then
        go:SetActive(false)
        return
      end
      go.transform:SetParent(parent)
      go.transform:Set_localScale(1, 1, 1)
      if parent ~= CS.SceneManager.World.DynamicObjNode then
        go.transform:Set_localPosition(0, 0, 0)
      else
        go.transform.position = pos
      end
      if self.goEffects and addGo then
        table.insert(self.goEffects, go)
      end
      if callback then
        callback(go.transform)
      end
    end)
    if vfxId and addRequest then
      table.insert(self.skillRequest, vfxId)
    end
    if not effect.PlayOnDisplayMode then
      table.insert(self.displayEffects, vfxId)
    end
    return vfxId
  end
end

function AllianceBaseSkill:ReleaseSkillEff()
  local theWorld = CS.SceneManager.World
  if theWorld and self.skillRequest then
    for _, id in pairs(self.skillRequest) do
      theWorld:RemoveVFX(id)
    end
    table.clear(self.skillRequest)
  end
  table.clear(self.displayEffects)
end

function AllianceBaseSkill:ReleaseDisplayEff()
  local theWorld = CS.SceneManager.World
  if theWorld and self.displayEffects then
    for _, id in pairs(self.displayEffects) do
      theWorld:RemoveVFX(id)
    end
    table.clear(self.displayEffects)
  end
end

function AllianceBaseSkill:ReleaseSkillEffById(id)
  local theWorld = CS.SceneManager.World
  if theWorld then
    theWorld:RemoveVFX(id)
  end
end

function AllianceBaseSkill:ReleaseGos()
  if self.goEffects then
    for _, go in pairs(self.goEffects) do
      if not IsNull(go) then
        go:SetActive(false)
      end
    end
  end
end

function AllianceBaseSkill:PopGos()
  if self.goEffects then
    for _, go in pairs(self.goEffects) do
      if not IsNull(go) then
        go:SetActive(true)
      end
    end
  end
end

function AllianceBaseSkill:ReleaseTimeActions()
  if self.timeAction then
    self.timeAction = nil
  end
end

function AllianceBaseSkill:GetPointId()
  return self.info.mainIndex
end

function AllianceBaseSkill:UpdateFireTime(info)
  if info then
    self.aosStartTime = toInt(self.info.aosStartTime)
    self.aosEndTime = toInt(self.info.aosEndTime)
  end
end

function AllianceBaseSkill:CanPlayEffect(effect)
  if self:NeedDisplayMode() and self.displayLv <= DisplaySettings.LevelAdjustmentMin and not IsNull(effect) and not effect.PlayOnDisplayMode then
    return false
  end
  return true
end

return AllianceBaseSkill
