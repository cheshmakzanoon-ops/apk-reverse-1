local MonopolyCheerleaderManager = BaseClass("MonopolyCheerleaderManager", CEventable)
local Cheerleader = require("Scene.Monopoly.Cheerleader.MonopolyCheerleader")
local PosOffset = {
  {
    -1,
    0,
    -2
  },
  {
    1,
    0,
    -2
  },
  {
    -1,
    0,
    -3.7
  },
  {
    1,
    0,
    -3.7
  },
  {
    -1,
    0,
    -5.4
  },
  {
    1,
    0,
    -5.4
  },
  {
    -1,
    0,
    -7.1
  },
  {
    1,
    0,
    -7.1
  },
  {
    -1,
    0,
    -8.8
  },
  {
    1,
    0,
    -8.8
  },
  {
    -1,
    0,
    -10.5
  },
  {
    1,
    0,
    -10.5
  }
}

function MonopolyCheerleaderManager:__init()
  self.cheerleaders = nil
  self.inUpdate = false
  self.abTest = nil
  self:RegisterEvent(EventId.BeforeReleaseCity, self.OnBeforeReleaseCity)
  self:RegisterEvent(EventId.MonopolyPlayerCreated, self.OnPlayerCreated)
  self:RegisterEvent(EventId.MonopolyPlayerEnd, self.OnPlayerEnd)
  self:RegisterEvent(EventId.MonopolyPlayerWin, self.OnPlayerWin)
  self:RegisterEvent(EventId.MonopolyPlayerLose, self.OnPlayerLose)
  self:RegisterEvent(EventId.MonopolyCheerleaderFinish, self.OnCheerleaderFinish)
  self:RegisterEvent(EventId.MonopolyCheerleaderRandomIdle, self.OnRandomIdle)
  self:RegisterEvent(EventId.MonopolyPlayerBeforeMove, self.OnPlayerBeforeMove)
end

function MonopolyCheerleaderManager:__delete()
  self:Clear()
  self.abTest = nil
  self.openServerList = nil
  self.idleAnimPool = nil
  self.idlePlotList = nil
  self.idleEmojiList = nil
  self.winAnimPool = nil
  self.winPlotList = nil
  self.winEmojiList = nil
  self.loseAnimPool = nil
  self.losePlotList = nil
  self.loseEmojiList = nil
  self.landAnimPool = nil
  self.landPlotList = nil
  self.landEmojiList = nil
end

function MonopolyCheerleaderManager:Clear()
  self.visible = nil
  if self.cheerleaders then
    for _, v in ipairs(self.cheerleaders) do
      v:Delete()
    end
    self.cheerleaders = nil
  end
  if self.removeCheerleaders then
    for _, v in ipairs(self.removeCheerleaders) do
      v:Delete()
    end
    self.removeCheerleaders = nil
  end
  self:ClearUpdate()
end

function MonopolyCheerleaderManager:ClearUpdate()
  if self.inUpdate then
    self.inUpdate = false
    UpdateManager:GetInstance():RemoveUpdate(self.OnUpdate)
  end
end

function MonopolyCheerleaderManager:OnEnterGame()
  if DataCenter.MonopolyManager:HasPlayer() then
    self:CheckShow(true)
  end
end

function MonopolyCheerleaderManager.OnUpdate()
  local self = DataCenter.MonopolyCheerleaderManager
  if self.cheerleaders == nil then
    return
  end
  local deltaTime = Time.deltaTime
  for _, v in ipairs(self.cheerleaders) do
    v:OnUpdate(deltaTime)
  end
end

function MonopolyCheerleaderManager:CheckShow(idle)
  if not CS.SceneManager:IsInCity() then
    return
  end
  local playerModel = DataCenter.MonopolyManager:GetPlayerModel()
  if playerModel == nil then
    return
  end
  local curData = playerModel.curData
  local nextData = playerModel.nextData
  if curData == nil or nextData == nil then
    return
  end
  local curId = curData.id
  local preId = DataCenter.LWCivilizationSparkExtend:MonopolyManager_getPreId(curId)
  local beforeData = DataCenter.MonopolyManager:GetPlacealityDataById(preId)
  if DataCenter.LWCivilizationSparkExtend:MonopolyManager_getCurFinishCount(curId) > 1 then
    if beforeData == nil then
      return
    end
    if beforeData.land_lock ~= curData.land_lock then
      return
    end
  end
  local curPos = curData:GetCenterWorldPos()
  local nexPos = nextData:GetCenterWorldPos()
  local q
  if DataCenter.LWCivilizationSparkExtend:MonopolyManager_getCurFinishCount(curId) > 1 then
    local thirdPos = beforeData:GetCenterWorldPos()
    local forward = curPos - thirdPos
    q = Quaternion.LookRotation(forward)
  else
    local forward = nexPos - curPos
    q = Quaternion.LookRotation(forward)
  end
  local soldierCount = curData.soldier_num
  soldierCount = math.min(soldierCount, #PosOffset)
  local workerMap = curData.soldier_lan_num
  local curLandLock = DataCenter.MonopolyManager:GetCurrentLandLock()
  local template = DataCenter.LandLockManager:GetTemplate(curLandLock)
  if template == nil then
    return
  end
  if self.cheerleaders == nil then
    self.cheerleaders = {}
  end
  self.curLandLock = curLandLock
  if idle then
    self:RandomIdlePlot()
    self:RandomIdleEmoji()
  end
  local posList = {}
  for i = 1, soldierCount do
    local offset = PosOffset[i]
    local pos = Vector3.New(offset[1], offset[2], offset[3])
    pos = curPos + q * pos
    table.insert(posList, pos)
  end
  local curCount = #self.cheerleaders
  local posCount = #posList
  if curCount == 0 and 0 < posCount then
    for i, pos in ipairs(posList) do
      local cheerleader = Cheerleader.New()
      cheerleader:ClearStatus()
      local worker = workerMap and workerMap[i]
      cheerleader:Show(pos.x, pos.z, i, false, pos.x, pos.z, false, worker)
      if self.visible then
        cheerleader:SetVisible(self.visible)
      end
      table.insert(self.cheerleaders, cheerleader)
    end
  end
  if #self.cheerleaders > 0 and not self.inUpdate then
    self.inUpdate = true
    UpdateManager:GetInstance():AddUpdate(self.OnUpdate)
  end
end

function MonopolyCheerleaderManager:OnBeforeReleaseCity()
  if self.cheerleaders then
    for _, v in ipairs(self.cheerleaders) do
      v:Delete()
    end
    self.cheerleaders = nil
  end
  self:ClearUpdate()
end

function MonopolyCheerleaderManager:OnPlayerCreated(idle)
  self:CheckShow(idle)
end

function MonopolyCheerleaderManager:OnPlayerBeforeMove()
  if not CS.SceneManager:IsInCity() then
    return
  end
  local playerModel = DataCenter.MonopolyManager:GetPlayerModel()
  if playerModel == nil then
    return
  end
  local curData = playerModel.curData
  local nextData = playerModel.nextData
  if curData == nil or nextData == nil then
    return
  end
  local curId = curData.id
  local preId = DataCenter.LWCivilizationSparkExtend:MonopolyManager_getPreId(curId)
  local thirdData = DataCenter.MonopolyManager:GetPlacealityDataById(preId)
  if thirdData == nil then
    return
  end
  local curPos = curData:GetCenterWorldPos()
  local thirdPos = thirdData:GetCenterWorldPos()
  local soldierCount = curData.soldier_num
  soldierCount = math.min(soldierCount, #PosOffset)
  local workerMap = curData.soldier_lan_num
  local beforeLand = thirdData.land_lock
  local moveToLand = curData.land_lock
  local beforeTemplate = DataCenter.LandLockManager:GetTemplate(beforeLand)
  local moveToTemplate = DataCenter.LandLockManager:GetTemplate(moveToLand)
  if beforeTemplate == nil or moveToTemplate == nil then
    return
  end
  if beforeLand ~= moveToLand then
    if self.removeCheerleaders == nil then
      self.removeCheerleaders = {}
    end
    if self.cheerleaders then
      for _, one in ipairs(self.cheerleaders) do
        table.insert(self.removeCheerleaders, one)
      end
      self.cheerleaders = nil
    end
    local build = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_ARMY_YARD)
    if build ~= nil then
      local targetPos = build:GetCenterVec()
      local showEventFinish = true
      local count = #self.removeCheerleaders
      for i = count, 1, -1 do
        local one = self.removeCheerleaders[i]
        local res = one:ToRemove(targetPos.x, targetPos.z, showEventFinish)
        if res then
          showEventFinish = false
        else
          one:Delete()
          table.remove(self.removeCheerleaders, i)
        end
      end
    else
      for _, one in ipairs(self.removeCheerleaders) do
        one:Delete()
      end
      self.removeCheerleaders = nil
    end
    return
  end
  if self.cheerleaders == nil then
    self.cheerleaders = {}
  end
  local forward = curPos - thirdPos
  local q = Quaternion.LookRotation(forward)
  local posEndList = {}
  for i = 1, soldierCount do
    local offset = PosOffset[i]
    local pos = Vector3.New(offset[1], offset[2], offset[3])
    pos = curPos + q * pos
    table.insert(posEndList, pos)
  end
  local count = #self.cheerleaders
  if 0 < count then
    for i, v in ipairs(self.cheerleaders) do
      local endPos = posEndList[i]
      if endPos then
        v:SetEndPos(endPos.x, endPos.z)
      end
      v:MoveToTarget()
    end
  end
  if soldierCount > count then
    if 2 < DataCenter.LWCivilizationSparkExtend:MonopolyManager_getCurFinishCount(curId) then
      local preId = DataCenter.LWCivilizationSparkExtend:MonopolyManager_getPreId(curId)
      preId = DataCenter.LWCivilizationSparkExtend:MonopolyManager_getPreId(preId)
      local lastData = DataCenter.MonopolyManager:GetPlacealityDataById(preId)
      if lastData == nil then
        return
      end
      local lastPos = lastData:GetCenterWorldPos()
      forward = thirdPos - lastPos
      q = Quaternion.LookRotation(forward)
    else
      forward = curPos - thirdPos
      q = Quaternion.LookRotation(forward)
    end
    local posList = {}
    for i = count + 1, soldierCount do
      local offset = PosOffset[i]
      local pos = Vector3.New(offset[1], offset[2], offset[3])
      pos = thirdPos + q * pos
      table.insert(posList, pos)
    end
    local posCount = #posList
    local randomIndex1 = math.random(1, posCount)
    local randomIndex2 = math.random(1, posCount)
    local index = 0
    for i = count + 1, soldierCount do
      index = index + 1
      local pos = posList[index]
      local endPos = posEndList[i] or pos
      local cheerleader = Cheerleader.New()
      cheerleader:SetPlotStatus(i == randomIndex1 or i == randomIndex2)
      local worker = workerMap and workerMap[i]
      cheerleader:Show(pos.x, pos.z, i, false, endPos.x, endPos.z, true, worker)
      if self.visible then
        cheerleader:SetVisible(self.visible)
      end
      table.insert(self.cheerleaders, cheerleader)
      cheerleader:MoveToTarget()
    end
    if #self.cheerleaders > 0 and not self.inUpdate then
      self.inUpdate = true
      UpdateManager:GetInstance():AddUpdate(self.OnUpdate)
    end
  end
end

function MonopolyCheerleaderManager:OnRandomIdle()
  if self.cheerleaders == nil then
    return
  end
  self:RandomIdlePlot()
  self:RandomIdleEmoji()
  local count = #self.cheerleaders
  local randomIndex1 = math.random(1, count)
  local randomIndex2 = math.random(1, count)
  for i, cheerleader in ipairs(self.cheerleaders) do
    cheerleader:SetPlotStatus(i == randomIndex1 or i == randomIndex2)
  end
end

function MonopolyCheerleaderManager:OnPlayerWin()
  self:RandomWinPlot()
  self:RandomWinEmoji()
  local curLandLock = DataCenter.MonopolyManager:GetCurrentLandLock()
  if self.curLandLock == nil or self.curLandLock == curLandLock then
    if self.cheerleaders then
      local count = #self.cheerleaders
      if 0 < count then
        local randomIndex1 = math.random(1, count)
        local remain = 4
        for i, v in ipairs(self.cheerleaders) do
          if i == randomIndex1 then
            v:SetPlotStatus()
          elseif 0 < remain then
            if remain < count - i then
              local random = math.random()
              if random < 0.5 then
                v:SetEmojiStatus()
                remain = remain - 1
              else
                v:ClearStatus()
              end
            else
              v:SetEmojiStatus()
              remain = remain - 1
            end
          else
            v:ClearStatus()
          end
          v:PlayWin()
        end
      end
    end
    return
  end
end

function MonopolyCheerleaderManager:OnPlayerLose()
  self:RandomLosePlot()
  self:RandomLoseEmoji()
  if self.cheerleaders then
    local count = #self.cheerleaders
    if 0 < count then
      local randomIndex1 = math.random(1, count)
      local remain = 4
      for i, v in ipairs(self.cheerleaders) do
        if i == randomIndex1 then
          v:SetPlotStatus()
        elseif 0 < remain then
          if remain < count - i then
            local random = math.random()
            if random < 0.5 then
              v:SetEmojiStatus()
              remain = remain - 1
            else
              v:ClearStatus()
            end
          else
            v:SetEmojiStatus()
            remain = remain - 1
          end
        else
          v:ClearStatus()
        end
        v:PlayLose()
      end
    end
  end
end

function MonopolyCheerleaderManager:OnPlayerEnd()
  if self.removeCheerleaders == nil then
    self.removeCheerleaders = {}
  end
  if self.cheerleaders then
    for _, one in ipairs(self.cheerleaders) do
      table.insert(self.removeCheerleaders, one)
    end
    self.cheerleaders = nil
  end
  local mainBuild = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_ARMY_YARD)
  if mainBuild ~= nil then
    local targetPos = mainBuild:GetCenterVec()
    local showEventFinish = true
    local count = #self.removeCheerleaders
    for i = count, 1, -1 do
      local one = self.removeCheerleaders[i]
      local res = one:ToRemove(targetPos.x, targetPos.z, showEventFinish)
      if res then
        showEventFinish = false
      else
        one:Delete()
        table.remove(self.removeCheerleaders, i)
      end
    end
  else
    for _, one in ipairs(self.removeCheerleaders) do
      one:Delete()
    end
    self.removeCheerleaders = nil
  end
end

function MonopolyCheerleaderManager:OnLandUnlock()
  self:RandomLandPlot()
  self:RandomLandEmoji()
  if self.cheerleaders then
    local count = #self.cheerleaders
    if 0 < count then
      local randomIndex1 = math.random(1, count)
      local randomIndex2 = math.random(1, count)
      for i, v in ipairs(self.cheerleaders) do
        v:SetPlotStatus(i == randomIndex1 or i == randomIndex2)
        v:PlayLandUnlock()
      end
    end
  end
end

function MonopolyCheerleaderManager:OnCheerleaderFinish()
  self:Clear()
end

function MonopolyCheerleaderManager:GetIdleAnim()
  if self.idleAnimPool == nil then
    local str = LuaEntry.DataConfig:TryGetStr("cheerleader", "k1")
    self.idleAnimPool = StringPool.New(str, ";")
  end
  return self.idleAnimPool:GetRandom()
end

function MonopolyCheerleaderManager:GetIdlePlot(index)
  if self.idlePlotList == nil then
    self.idlePlotList = {}
    local str = LuaEntry.DataConfig:TryGetStr("cheerleader", "k2")
    if not string.IsNullOrEmpty(str) then
      local list = string.split(str, ";")
      for _, v in ipairs(list) do
        table.insert(self.idlePlotList, tonumber(v) or 0)
      end
    end
    self.idlePlotCount = #self.idlePlotList
  end
  if 0 < index and index <= self.idlePlotCount then
    return self.idlePlotList[index]
  end
  return 0
end

function MonopolyCheerleaderManager:RandomIdlePlot()
  if self.idlePlotList and self.idlePlotCount > 1 then
    local last = self.idlePlotList[self.idlePlotCount]
    local random = math.random(1, self.idlePlotCount - 1)
    local cur = self.idlePlotList[random]
    self.idlePlotList[self.idlePlotCount] = cur
    self.idlePlotList[random] = last
  end
end

function MonopolyCheerleaderManager:GetIdleEmoji(index)
  if self.idleEmojiList == nil then
    self.idleEmojiList = {}
    local str = LuaEntry.DataConfig:TryGetStr("cheerleader", "k10")
    if not string.IsNullOrEmpty(str) then
      local list = string.split(str, ";")
      for _, v in ipairs(list) do
        table.insert(self.idleEmojiList, tonumber(v) or 0)
      end
    end
    self.idleEmojiCount = #self.idleEmojiList
  end
  if 0 < index and index <= self.idleEmojiCount then
    return self.idleEmojiList[index]
  end
  return 0
end

function MonopolyCheerleaderManager:RandomIdleEmoji()
  if self.idleEmojiList and self.idleEmojiCount > 1 then
    local last = self.idleEmojiList[self.idleEmojiCount]
    local random = math.random(1, self.idleEmojiCount - 1)
    local cur = self.idleEmojiList[random]
    self.idleEmojiList[self.idleEmojiCount] = cur
    self.idleEmojiList[random] = last
  end
end

function MonopolyCheerleaderManager:GetWinAnim()
  if self.winAnimPool == nil then
    local str = LuaEntry.DataConfig:TryGetStr("cheerleader", "k3")
    self.winAnimPool = StringPool.New(str, ";")
  end
  return self.winAnimPool:GetRandom()
end

function MonopolyCheerleaderManager:GetWinPlot(index)
  if self.winPlotList == nil then
    self.winPlotList = {}
    local str = LuaEntry.DataConfig:TryGetStr("cheerleader", "k4")
    if not string.IsNullOrEmpty(str) then
      local list = string.split(str, ";")
      for _, v in ipairs(list) do
        table.insert(self.winPlotList, tonumber(v) or 0)
      end
    end
    self.winPlotCount = #self.winPlotList
  end
  if 0 < index and index <= self.winPlotCount then
    return self.winPlotList[index]
  end
  return 0
end

function MonopolyCheerleaderManager:RandomWinPlot()
  if self.winPlotList and self.winPlotCount > 1 then
    local last = self.winPlotList[self.winPlotCount]
    local random = math.random(1, self.winPlotCount - 1)
    local cur = self.winPlotList[random]
    self.winPlotList[self.winPlotCount] = cur
    self.winPlotList[random] = last
  end
end

function MonopolyCheerleaderManager:GetWinEmoji(index)
  if self.winEmojiList == nil then
    self.winEmojiList = {}
    local str = LuaEntry.DataConfig:TryGetStr("cheerleader", "k11")
    if not string.IsNullOrEmpty(str) then
      local list = string.split(str, ";")
      for _, v in ipairs(list) do
        table.insert(self.winEmojiList, tonumber(v) or 0)
      end
    end
    self.winEmojiCount = #self.winEmojiList
  end
  if 0 < index and index <= self.winEmojiCount then
    return self.winEmojiList[index]
  end
  return 0
end

function MonopolyCheerleaderManager:RandomWinEmoji()
  if self.winEmojiList and self.winEmojiCount > 1 then
    local last = self.winEmojiList[self.winEmojiCount]
    local random = math.random(1, self.winEmojiCount - 1)
    local cur = self.winEmojiList[random]
    self.winEmojiList[self.winEmojiCount] = cur
    self.winEmojiList[random] = last
  end
end

function MonopolyCheerleaderManager:GetLoseAnim()
  if self.loseAnimPool == nil then
    local str = LuaEntry.DataConfig:TryGetStr("cheerleader", "k5")
    self.loseAnimPool = StringPool.New(str, ";")
  end
  return self.loseAnimPool:GetRandom()
end

function MonopolyCheerleaderManager:GetLosePlot(index)
  if self.losePlotList == nil then
    self.losePlotList = {}
    local str = LuaEntry.DataConfig:TryGetStr("cheerleader", "k6")
    if not string.IsNullOrEmpty(str) then
      local list = string.split(str, ";")
      for _, v in ipairs(list) do
        table.insert(self.losePlotList, tonumber(v) or 0)
      end
    end
    self.losePlotCount = #self.losePlotList
  end
  if 0 < index and index <= self.losePlotCount then
    return self.losePlotList[index]
  end
  return 0
end

function MonopolyCheerleaderManager:RandomLosePlot()
  if self.losePlotList and self.losePlotCount > 1 then
    local last = self.losePlotList[self.losePlotCount]
    local random = math.random(1, self.losePlotCount - 1)
    local cur = self.losePlotList[random]
    self.losePlotList[self.losePlotCount] = cur
    self.losePlotList[random] = last
  end
end

function MonopolyCheerleaderManager:GetLoseEmoji(index)
  if self.loseEmojiList == nil then
    self.loseEmojiList = {}
    local str = LuaEntry.DataConfig:TryGetStr("cheerleader", "k11")
    if not string.IsNullOrEmpty(str) then
      local list = string.split(str, ";")
      for _, v in ipairs(list) do
        table.insert(self.loseEmojiList, tonumber(v) or 0)
      end
    end
    self.loseEmojiCount = #self.loseEmojiList
  end
  if 0 < index and index <= self.loseEmojiCount then
    return self.loseEmojiList[index]
  end
  return 0
end

function MonopolyCheerleaderManager:RandomLoseEmoji()
  if self.loseEmojiList and self.loseEmojiCount > 1 then
    local last = self.loseEmojiList[self.loseEmojiCount]
    local random = math.random(1, self.loseEmojiCount - 1)
    local cur = self.loseEmojiList[random]
    self.loseEmojiList[self.loseEmojiCount] = cur
    self.loseEmojiList[random] = last
  end
end

function MonopolyCheerleaderManager:GetLandAnim()
  if self.landAnimPool == nil then
    local str = LuaEntry.DataConfig:TryGetStr("cheerleader", "k7")
    self.landAnimPool = StringPool.New(str, ";")
  end
  return self.landAnimPool:GetRandom()
end

function MonopolyCheerleaderManager:GetLandPlot(index)
  if self.landPlotList == nil then
    self.landPlotList = {}
    local str = LuaEntry.DataConfig:TryGetStr("cheerleader", "k8")
    if not string.IsNullOrEmpty(str) then
      local list = string.split(str, ";")
      for _, v in ipairs(list) do
        table.insert(self.landPlotList, tonumber(v) or 0)
      end
    end
    self.landPlotCount = #self.landPlotList
  end
  if 0 < index and index <= self.landPlotCount then
    return self.landPlotList[index]
  end
  return 0
end

function MonopolyCheerleaderManager:RandomLandPlot()
  if self.landPlotList and self.landPlotCount > 1 then
    local last = self.landPlotList[self.landPlotCount]
    local random = math.random(1, self.landPlotCount - 1)
    local cur = self.landPlotList[random]
    self.landPlotList[self.landPlotCount] = cur
    self.landPlotList[random] = last
  end
end

function MonopolyCheerleaderManager:GetLandEmoji(index)
  if self.landEmojiList == nil then
    self.landEmojiList = {}
    local str = LuaEntry.DataConfig:TryGetStr("cheerleader", "k11")
    if not string.IsNullOrEmpty(str) then
      local list = string.split(str, ";")
      for _, v in ipairs(list) do
        table.insert(self.landEmojiList, tonumber(v) or 0)
      end
    end
    self.landEmojiCount = #self.landEmojiList
  end
  if 0 < index and index <= self.landEmojiCount then
    return self.landEmojiList[index]
  end
  return 0
end

function MonopolyCheerleaderManager:RandomLandEmoji()
  if self.landEmojiList and self.landEmojiCount > 1 then
    local last = self.landEmojiList[self.landEmojiCount]
    local random = math.random(1, self.landEmojiCount - 1)
    local cur = self.landEmojiList[random]
    self.landEmojiList[self.landEmojiCount] = cur
    self.landEmojiList[random] = last
  end
end

function MonopolyCheerleaderManager:SetCheerleadersVisible(visible)
  self.visible = visible
  if self.cheerleaders then
    for _, v in ipairs(self.cheerleaders) do
      v:SetVisible(visible)
    end
  end
end

return MonopolyCheerleaderManager
