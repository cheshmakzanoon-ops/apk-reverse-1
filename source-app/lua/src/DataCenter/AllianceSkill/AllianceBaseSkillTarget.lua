local AllianceBaseSkillTarget = BaseClass("AllianceBaseSkillTarget")

function AllianceBaseSkillTarget:OnCreate(go)
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

function AllianceBaseSkillTarget:OnDestroy()
  if not IsNull(self.gameObject) then
    self.gameObject:SetActive(false)
  end
  if self.updateTimer then
    self.updateTimer:Stop()
    self.updateTimer = nil
  end
  self.releaseFinish = nil
  self.destroyStatus = true
  self:ReleaseAll()
end

function AllianceBaseSkillTarget:ReInit(uuid, data, unityConfig)
  self.error = false
  self.uuid = uuid
  self.data = data
  self.skillId = self.data.id
  if self.unityConfig == nil then
    self.unityConfig = unityConfig
    if not self.unityConfig then
      self.error = true
      Logger.LogWarning("[AllianceSkill] ReInit Error unityConfig is Null uuid: " .. uuid .. "skillId: " .. self.skillId)
      return
    end
  end
  self.skillConfig = DataCenter.AllianceGovernmentSkillManager:GetTemplatesById(self.skillId)
  if not self.skillConfig then
    Logger.LogWarning("[AllianceSkill] ReInit Error SkillConfig is Null uuid: " .. uuid .. "skillId: " .. self.skillId)
    self.error = true
    return
  end
  self.senderPointId = self.data.senderPointId
  local theWorld = CS.SceneManager.World
  if not theWorld then
    self.error = true
    Logger.LogWarning("[AllianceSkill] ReInit Error World is Null uuid: " .. uuid .. "skillId: " .. self.skillId)
    return
  end
  self.overTime = toInt(self.data.overTime)
  self.activeTime = toInt(self.data.activeTime)
  self.skillRequest = {}
  self.displayEffects = {}
  self.goEffects = {}
  if self.gameObject then
    self.effectGo = self.gameObject.transform:Find("ModelGo/EffectGo")
  end
  self.serverId = self.data.serverId
  self.timeAction = {}
  self.tilePos = SceneUtils.IndexToTilePos(self:GetPointId(), ForceChangeScene.World)
  self.pointId1 = SceneUtils.TileXYToIndex(self.tilePos.x - self.data.radius, self.tilePos.y - self.data.radius, ForceChangeScene.World)
  self.pointId2 = SceneUtils.TileXYToIndex(self.tilePos.x + self.data.radius, self.tilePos.y - self.data.radius, ForceChangeScene.World)
  self.pointId3 = SceneUtils.TileXYToIndex(self.tilePos.x - self.data.radius, self.tilePos.y + self.data.radius, ForceChangeScene.World)
  self.pointId4 = SceneUtils.TileXYToIndex(self.tilePos.x + self.data.radius, self.tilePos.y + self.data.radius, ForceChangeScene.World)
  self.displayLv = DisplaySettings.GetCurrentDisplayLevel()
  if self.gameObject then
    self.gameObject:SetActive(true)
  end
  self:Init()
end

function AllianceBaseSkillTarget:Update(theWorld)
  if self.error then
    self:ReleaseAll()
    return
  end
  self:OnTickSec(theWorld)
end

function AllianceBaseSkillTarget:OnLodChange(lod)
  if self.error then
    self:ReleaseAll()
    return
  end
  self.theLod = toInt(lod)
  Logger.Log("[AllianceSkill] OnLodChange " .. self.theLod .. "===> " .. lod)
  self:LodChange()
end

function AllianceBaseSkillTarget:OnDisplayLevelChange(displayLv)
  if self.displayLv ~= displayLv then
    self.displayLv = displayLv
  end
  if self.displayLv <= -1 and self:NeedDisplayMode() then
    self:ReleaseDisplayEff()
    self:DoDisplayMode()
  end
end

function AllianceBaseSkillTarget:ReleaseAll()
  if self.releaseFinish then
    return
  end
  self:ReleaseGos()
  self:ReleaseSkillEff()
  self:ReleaseTimeActions()
  self:Clear()
  self.releaseFinish = true
end

function AllianceBaseSkillTarget:NeedDisplayMode()
  return false
end

function AllianceBaseSkillTarget:GetPointId()
  return self.data.pointId
end

function AllianceBaseSkillTarget:Init()
end

function AllianceBaseSkillTarget:Clear()
end

function AllianceBaseSkillTarget:Tick()
  if self.error then
    self:ReleaseAll()
    return
  end
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
  self:OnTick()
end

function AllianceBaseSkillTarget:OnTick()
end

function AllianceBaseSkillTarget:OnTickSec(theWorld)
end

function AllianceBaseSkillTarget:LodChange()
end

function AllianceBaseSkillTarget:TickAoi(theWorld)
  if self.request == nil or theWorld == nil or theWorld.IsOutOfLWAoi == nil then
    self:Clear()
    return false
  end
  if theWorld ~= nil and self.data ~= nil and self.uuid ~= nil and self.tilePos ~= nil and self.data.radius then
    local tilePos = SceneUtils.WorldToTile(theWorld.CurTarget)
    if (math.abs(tilePos.x - self.tilePos.x) > self.data.radius or math.abs(tilePos.y - self.tilePos.y) > self.data.radius) and theWorld:IsOutOfLWAoi(self.pointId1, self.serverId) and theWorld:IsOutOfLWAoi(self.pointId2, self.serverId) and theWorld:IsOutOfLWAoi(self.pointId3, self.serverId) and theWorld:IsOutOfLWAoi(self.pointId4, self.serverId) then
      self:Clear()
      DataCenter.AllianceSkillManager:RemoveOneWarEffect(self.uuid)
      return false
    end
  end
  return true
end

function AllianceBaseSkillTarget:DoDisplayMode()
end

function AllianceBaseSkillTarget:SetTimeAction(name, time, action)
  self.timeAction = self.timeAction or {}
  table.insert(self.timeAction, {
    name = name,
    time = time,
    action = action,
    timer = nil,
    finish = false
  })
end

function AllianceBaseSkillTarget:DoUpdateObject()
  local obj = CS.SceneManager.World:GetObjectByUuid(self.uuid)
  if not IsNull(obj) then
    obj:UpdateGameObject()
  end
end

function AllianceBaseSkillTarget:PlaySkillEffBySelfPoint(prefab, time, parent, addRequest, addGo, callback, effect)
  return self:PlaySkillEff(self:GetPointId(), prefab, time, parent, addRequest, addGo, callback, effect)
end

function AllianceBaseSkillTarget:PlaySkillEff(pointId, prefab, time, parent, addRequest, addGo, callback, effect)
  if self.destroyStatus then
    return
  end
  if not SceneUtils.GetIsInWorld() then
    return
  end
  if not self:CanPlayEffect(effect) then
    return
  end
  if self.theLod and self.theLod > 2 then
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

function AllianceBaseSkillTarget:ReleaseSkillEff()
  local theWorld = CS.SceneManager.World
  if theWorld and self.skillRequest then
    for _, id in pairs(self.skillRequest) do
      theWorld:RemoveVFX(id)
    end
    table.clear(self.skillRequest)
  end
  table.clear(self.displayEffects)
end

function AllianceBaseSkillTarget:ReleaseSkillEffById(id)
  local theWorld = CS.SceneManager.World
  if theWorld then
    theWorld:RemoveVFX(id)
  end
end

function AllianceBaseSkillTarget:ReleaseDisplayEff()
  local theWorld = CS.SceneManager.World
  if theWorld and self.displayEffects then
    for _, id in pairs(self.displayEffects) do
      theWorld:RemoveVFX(id)
    end
    table.clear(self.displayEffects)
  end
end

function AllianceBaseSkillTarget:ReleaseGos()
  if self.goEffects then
    for _, go in pairs(self.goEffects) do
      if not IsNull(go) then
        go:SetActive(false)
      end
    end
  end
end

function AllianceBaseSkillTarget:PopGos()
  if self.goEffects then
    for _, go in pairs(self.goEffects) do
      if not IsNull(go) then
        go:SetActive(true)
      end
    end
  end
end

function AllianceBaseSkillTarget:ReleaseTimeActions()
  if self.timeAction then
    for i, v in pairs(self.timeAction) do
      if v.timer then
        v.timer:Stop()
      end
    end
    self.timeAction = nil
  end
end

function AllianceBaseSkillTarget:CanPlayEffect(effect)
  if self:NeedDisplayMode() and self.displayLv <= DisplaySettings.LevelAdjustmentMin and not IsNull(effect) and not effect.PlayOnDisplayMode then
    return false
  end
  return true
end

return AllianceBaseSkillTarget
