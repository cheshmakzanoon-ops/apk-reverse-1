local TriggerPoint = require("Scene.PVEBattleLevel.TriggerPoint")
local Time = _ENV.Time
local Const = require("Scene.PVEBattleLevel.Const")
local VisibleChunkRange = 1
local MapTileSize = 100
local TileCountPerChunk = 6
local CreateCountPerFrame = 10
local MapChunkSize = MapTileSize / TileCountPerChunk
local TriggerPointManager = BaseClass("TriggerPointManager")

function TriggerPointManager:__init()
  self.battleLevel = nil
  self.lastViewIndex = -1
  self.triggerDict = {}
  self.triggerViewDict = {}
  self.cutUpdateDict = {}
  self.createList = {}
  self.chunks = {}
  self.pointIdDic = {}
  self.finishTriggers = {}
  self.triggerProgressTotal = 0
  self.triggerProgressCount = 0
  self.staticTriggerDict = {}
end

function TriggerPointManager:__delete()
  self:Destroy()
end

function TriggerPointManager:Init(battleLevel, triggerList)
  self.battleLevel = battleLevel
  self.lastViewIndex = -1
  self.chunks = {}
  self.createList = {}
  self.triggerViewDict = {}
  self.triggerDict = {}
  self.cutUpdateDict = {}
  self.pointIdDic = {}
  if triggerList ~= nil then
    for _, v in ipairs(triggerList) do
      local obj = TriggerPoint.New(self.battleLevel, self, v)
      if obj ~= nil then
        self.triggerDict[obj:GetTriggerId()] = obj
        if obj.pointId > 0 then
          self.battleLevel:AddObj(obj:GetObjId(), obj)
          self:AddOnePointDict(obj)
          local tilePos = SceneUtils.WorldToTile(obj:GetPosition())
          local chunkIndex = self:TilePosToChunkIndex(tilePos.x, tilePos.y)
          local list = self.chunks[chunkIndex]
          if list == nil then
            list = {}
            self.chunks[chunkIndex] = list
          end
          list[#list + 1] = obj
        end
      end
      if obj:IsTypeBombArea() then
        self.staticTriggerDict[v] = obj
      end
    end
  end
  self.lastViewIndex = -1
end

function TriggerPointManager:OnUpdate(viewX, viewY, deltaTime)
  self:UpdateView(viewX, viewY)
  for k, v in pairs(self.triggerViewDict) do
    v:OnUpdate(deltaTime)
  end
  for k, v in pairs(self.staticTriggerDict) do
    if self.triggerViewDict[k] == nil then
      v:OnUpdate(deltaTime)
    end
  end
end

function TriggerPointManager:UpdateView(viewX, viewY)
  local viewChunkIndex = self:TilePosToChunkIndex(viewX, viewY)
  local createList = self.createList
  local triggerViewDict = self.triggerViewDict
  if self.lastViewIndex ~= viewChunkIndex then
    self.lastViewIndex = viewChunkIndex
    local viewChunkX, viewChunkY = self:TilePosToChunkCoord(viewX, viewY)
    local minX = viewChunkX - VisibleChunkRange
    local maxX = viewChunkX + VisibleChunkRange
    local minY = viewChunkY - VisibleChunkRange
    local maxY = viewChunkY + VisibleChunkRange
    for k, o in pairs(triggerViewDict) do
      local objTilePos = o:GetTilePos()
      if objTilePos ~= nil then
        local chunkX, chunkY = self:TilePosToChunkCoord(objTilePos.x, objTilePos.y)
        if minX > chunkX or maxX < chunkX or minY > chunkY or maxY < chunkY then
          triggerViewDict[k] = nil
          self:RemoveOnePointDict(o)
          o:SetViewVisible(false)
        end
      end
    end
    for k, obj in pairs(createList) do
      local objTilePos = obj:GetTilePos()
      if objTilePos ~= nil then
        local chunkX, chunkY = self:TilePosToChunkCoord(objTilePos.x, objTilePos.y)
        if minX > chunkX or maxX < chunkX or minY > chunkY or maxY < chunkY then
          createList[k] = nil
        end
      end
    end
    for y = -VisibleChunkRange, VisibleChunkRange do
      for x = -VisibleChunkRange, VisibleChunkRange do
        local chunkX, chunkY = viewChunkX + x, viewChunkY + y
        local list = self:GetChunkObjList(chunkX, chunkY)
        if list then
          for _, obj in ipairs(list) do
            local id = obj:GetTriggerId()
            if triggerViewDict[id] == nil and createList[id] == nil then
              createList[id] = obj
            end
          end
        end
      end
    end
  end
  local count = 0
  for id, obj in pairs(createList) do
    createList[id] = nil
    if triggerViewDict[id] == nil then
      obj:SetViewVisible(true)
      triggerViewDict[id] = obj
      self:AddOnePointDict(obj)
      count = count + 1
      if count > CreateCountPerFrame then
        break
      end
    end
  end
end

function TriggerPointManager:Destroy()
  for _, i in pairs(self.triggerDict) do
    i:Destroy()
  end
  self.createList = {}
  self.triggerViewDict = {}
  self.triggerDict = {}
  self.chunks = {}
  self.cutUpdateDict = {}
  self.lastViewIndex = -1
end

function TriggerPointManager:GetTriggerByTriggerId(configId)
  return self.triggerDict[configId]
end

function TriggerPointManager:TilePosToChunkCoord(x, y)
  return math.floor(x / TileCountPerChunk), math.floor(y / TileCountPerChunk)
end

function TriggerPointManager:TilePosToChunkIndex(x, y)
  local chunkX, chunkY = math.floor(x / TileCountPerChunk), math.floor(y / TileCountPerChunk)
  return chunkY * MapChunkSize + chunkX + 1
end

function TriggerPointManager:GetChunkObjList(chunkX, chunkY)
  local chunkIndex = chunkY * MapChunkSize + chunkX + 1
  return self.chunks[chunkIndex]
end

function TriggerPointManager:RefreshCameraRotation(rotation)
  for k, v in pairs(self.triggerViewDict) do
    v:RefreshCameraRotation(rotation)
  end
end

function TriggerPointManager:AddOnePointDict(obj)
  if obj ~= nil then
    local pointId = obj.pointId
    if self.pointIdDic[pointId] == nil then
      self.pointIdDic[pointId] = {}
    end
    self.pointIdDic[pointId][obj:GetObjId()] = obj
  end
end

function TriggerPointManager:RemoveOnePointDict(obj)
  if obj ~= nil then
    local pointId = obj.pointId
    local id = obj:GetObjId()
    if self.pointIdDic[pointId] ~= nil and self.pointIdDic[pointId][id] ~= nil then
      self.pointIdDic[pointId][id] = nil
    end
  end
end

function TriggerPointManager:InitTrigger(progressType)
  if #self.finishTriggers > 0 then
    for _, t in ipairs(self.finishTriggers) do
      local trigger = self:GetTriggerByTriggerId(t)
      if trigger ~= nil then
        trigger:SetTriggerOK(true)
      end
    end
  end
  for _, t in pairs(self.triggerDict) do
    if not t:IsTriggerOK() then
      t:SetVisible(true)
      if t:IsTypeMonster() then
        t:SetMonsterLevelVisible(true)
      end
    end
  end
  if progressType ~= nil then
    self.triggerProgressTotal = 0
    for i, t in ipairs(self.triggerDict) do
      local trigger = self:GetTriggerByTriggerId(t)
      if trigger:GetTriggerType() == progressType then
        self.triggerProgressTotal = self.triggerProgressTotal + 1
      end
    end
    self.triggerProgressCount = 0
    for i, t in ipairs(self.finishTriggers) do
      local trigger = self:GetTriggerByTriggerId(t)
      if trigger and trigger:GetTriggerType() == progressType then
        self.triggerProgressCount = self.triggerProgressCount + 1
      end
    end
  end
end

function TriggerPointManager:GetLastFinishTriggers()
  local lastFinishTriggers = {}
  if #self.finishTriggers > 0 then
    for _, t in ipairs(self.finishTriggers) do
      local trigger = self:GetTriggerByTriggerId(t)
      if trigger ~= nil then
        local order = trigger.config.order
        if trigger:IsMainQuest() and 0 < order then
          lastFinishTriggers[order] = trigger
        end
      end
    end
  end
  return lastFinishTriggers
end

function TriggerPointManager:GetTriggers()
  return self.triggerDict
end

function TriggerPointManager:GetTriggerPointByRes(resType)
  for k, v in pairs(self.triggerViewDict) do
    if v:IsNeedResType(resType) then
      return v
    end
  end
end

function TriggerPointManager:GetTriggerByTriggerType(triggerType)
  for k, v in pairs(self.triggerDict) do
    if v.config.type == triggerType then
      return v
    end
  end
end

function TriggerPointManager:PveStaminaUpdateSignal()
  for k, v in pairs(self.triggerViewDict) do
    if v:IsPreTriggerOK() and not v:IsTriggerOK() then
      v:RefreshStamina()
    end
  end
end

function TriggerPointManager:RefreshResourceItemSignal()
  for k, v in pairs(self.triggerViewDict) do
    if v:IsPreTriggerOK() and not v:IsTriggerOK() then
      v:RefreshResourceItem()
    end
  end
end

function TriggerPointManager:UpdateItemSignal()
  for k, v in pairs(self.triggerViewDict) do
    if v:IsPreTriggerOK() and not v:IsTriggerOK() then
      v:RefreshGoods()
    end
  end
end

function TriggerPointManager:ResourceUpdatedSignal()
  for k, v in pairs(self.triggerViewDict) do
    if v:IsPreTriggerOK() and not v:IsTriggerOK() then
      v:RefreshResource()
    end
  end
end

function TriggerPointManager:FactoryItemSignal()
  for k, v in pairs(self.triggerViewDict) do
    if v:ISPVEFactory() then
      v:RefreshFactory()
    end
  end
end

function TriggerPointManager:GetLastFinishTrigger()
  return self.finishTriggers[#self.finishTriggers]
end

function TriggerPointManager:AddOneFinishTrigger(triggerId)
  self.finishTriggers[#self.finishTriggers + 1] = triggerId
end

function TriggerPointManager:SetFinishTrigger(message)
  local finishTriggers = {}
  local finishTrigger = message.finishTrigger
  if finishTrigger then
    local splits = string.split_ii_array(finishTrigger, ";")
    for i, t in ipairs(splits) do
      finishTriggers[#finishTriggers + 1] = t
    end
  end
  self.finishTriggers = finishTriggers
end

function TriggerPointManager:IsFinishTrigger(triggerId)
  if self.finishTriggers then
    for k, v in pairs(self.finishTriggers) do
      if v == triggerId then
        return true
      end
    end
  end
  return false
end

function TriggerPointManager:GetTriggersByTilePos(tilePos)
  local pointId = SceneUtils.TilePosToIndex(tilePos)
  return self.pointIdDic[pointId]
end

function TriggerPointManager:GetTriggersByPointId(pointId)
  local result = {}
  local list = self.pointIdDic[pointId]
  if list ~= nil then
    for k, v in pairs(list) do
      if v:IsPreTriggerOK() and not v:IsTriggerOK() and v:GetVisible() and self.battleLevel:IsPveStaminaEnough(v:GetNeedPveStamina()) then
        table.insert(result, v)
      end
    end
  end
  return result
end

function TriggerPointManager:OnPlayerMoveSignal(pos)
  for k, v in pairs(self.triggerViewDict) do
    if v:IsPreTriggerOK() and not v:IsTriggerOK() and v:GetVisible() then
      v:OnPlayerMoveSignal(pos)
    end
  end
  for k, v in pairs(self.staticTriggerDict) do
    if self.triggerViewDict[k] == nil then
      v:OnPlayerMoveSignal(pos)
    end
  end
end

function TriggerPointManager:GetTriggerProgressCount()
  return self.triggerProgressCount
end

function TriggerPointManager:GetTriggerProgressTotal()
  return self.triggerProgressTotal
end

function TriggerPointManager:AddTriggerProgressCount(num)
  self.triggerProgressCount = self.triggerProgressCount + num
end

function TriggerPointManager:OnSetHighView(isHighView)
  for _, v in pairs(self.triggerViewDict) do
    v:OnSetHighView(isHighView)
  end
end

return TriggerPointManager
