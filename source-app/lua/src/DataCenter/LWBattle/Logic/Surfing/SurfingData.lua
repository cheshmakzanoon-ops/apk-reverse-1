local SurfingData = BaseClass("SurfingData")
local Queue = require("DataCenter.LWBattle.Logic.Surfing.Queue")
local SurfingSceneInfo = require("DataCenter.LWBattle.Logic.Surfing.SurfingSceneInfo")
local SurfingScenePool = require("DataCenter.LWBattle.Logic.Surfing.SurfingScenePool")

function SurfingData:__init(logic, id, ids, param, speedChangeTime)
  self.logic = logic
  self.scenePreZ = 0
  self.sceneIndex = -1
  self.curSceneIds = nil
  self.curSceneIndex = 0
  self.speedZ = 0
  self.index = -1
  self.baseTime = 0
  self.baseDistance = 0
  self.startSpeed = 0
  self.endSpeed = 0
  self.cacheDistance = 0
  self.cacheTime = 0
  self.infiniteMark = nil
  self.stageSceneId = nil
  self.speedChangeTime = speedChangeTime
  self.surfingSceneCache = {}
  self.scenePool = SurfingScenePool.New()
  self.preloadThreshold = 10
  self:InitData(id, ids, param)
end

function SurfingData:__delete()
  if self.scenePool then
    self.scenePool:OnDestroy()
    self.scenePool = nil
  end
  if self.queue then
    self.queue:compact()
    self.queue = nil
  end
  if self.preloadQueue then
    self.preloadQueue:compact()
    self.preloadQueue = nil
  end
  if self.mIdQueue then
    self.mIdQueue:compact()
    self.mIdQueue = nil
  end
  self.preloadList = nil
end

function SurfingData:InitData(id, ids, param)
  if id == nil then
    Logger.LogError("SurfingData Error : metaId is nil")
    return
  end
  self.metaId = id
  self.meta = DataCenter.SurfingStageTemplateManager:GetTemplate(self.metaId)
  local gm = false
  local isPlayback = false
  local pre_scene = self.meta.pre_scene or 1000
  if param then
    if param.enterType == PVEEnterType.GM or param.enterType == PVEEnterType.Guide then
      ids = self.meta.gm_ids
      self.ids = ids
      gm = true
    elseif param.enterType == PVEEnterType.SurfingPlayback then
      isPlayback = true
    end
  end
  self.gm = gm
  self.isPlayback = isPlayback
  self.totalIndex = ids and #ids or 0
  self.constLength = self.totalIndex
  self.queue = Queue.new()
  self.queue:enqueue(pre_scene)
  self:InsertQueue(ids)
  if self.meta then
    self.heroId = self.meta.default_hero
    self.infiniteIndex = self.meta.sceneFlag
  end
  self.preloadQueue = Queue.new()
  self.preloadList = {}
  if gm and not string.IsNullOrEmpty(self.meta.gm_ids_guide) then
    self.guideIds = string.string2array_num(self.meta.gm_ids_guide, "|", ";")
  end
end

function SurfingData:InsertQueue(ids)
  if self.queue == nil then
    Logger.LogInfo("surfing -- [InsertQueue] self.queue is nil")
    return
  end
  if table.IsNullOrEmpty(ids) then
    Logger.LogInfo("surfing -- [InsertQueue] ids is nil or empty")
    return
  end
  local queue = self.queue
  for _, v in ipairs(ids) do
    queue:enqueue(v)
  end
end

function SurfingData:GetSceneExt()
  return self.meta.sceneExt
end

function SurfingData:PreloadScenes(callback)
  if self.queue == nil then
    Logger.LogInfo("surfing -- [PreloadScenes] self.queue is nil")
    return
  end
  if self.preloadQueue == nil then
    self.preloadQueue = Queue.new()
  end
  local sceneIds = self:GetPreloadScenes()
  if sceneIds then
    self.scenePool:PreloadScenes(sceneIds, callback)
  end
end

function SurfingData:GetPreloadScenes()
  local result
  if self:CheckThreshold() then
    local config
    if self.preloadList == nil then
      self.preloadList = {}
    elseif #self.preloadList > 0 then
      table.clear(self.preloadList)
    end
    for _ = 1, self.preloadThreshold do
      config = self:GetSceneConfig()
      if config ~= nil then
        self.preloadQueue:enqueue(config)
        table.insert(self.preloadList, config.sceneId)
      end
    end
    result = self.preloadList
  end
  return result
end

function SurfingData:GetSceneConfigs(count)
  local res = {}
  if self.preloadQueue == nil then
    self:PreloadScenes()
  end
  local result = self:GetPreloadScenes()
  if result ~= nil then
    self.scenePool:PreloadScenes(result)
  end
  if self.preloadQueue == nil or self.preloadQueue:size() <= 0 then
    Logger.LogInfo("surfing -- [GetSceneConfigs] self.preloadQueue is nil or empty")
    return
  end
  local config
  for i = 1, count do
    config = self.preloadQueue:dequeue()
    if config ~= nil then
      table.insert(res, config)
    end
  end
  return res
end

local function GetSceneData(self, farmMonster, infiniteMark)
  if self.curSceneIds == nil then
    Logger.LogInfo("surfing -- [GetSceneData] self.curSceneIds is nil")
    return
  end
  self.sceneIndex = self.sceneIndex + 1
  self.curSceneIndex = self.curSceneIndex + 1
  local id = self.curSceneIds[self.curSceneIndex]
  if self.curSceneIndex >= #self.curSceneIds then
    self.curSceneIds = nil
  end
  if id then
    local sceneMeta = DataCenter.LWSceneTemplateManager:GetTemplate(id)
    local size = sceneMeta.scene_size
    local data = SurfingSceneInfo.New()
    if self.index == 0 then
      self.scenePreZ = -size
    elseif 0 > self.scenePreZ then
      self.scenePreZ = 0
    end
    data:SetData(self.logic, id, sceneMeta.asset, size, self.sceneIndex, self.scenePreZ, self.speedZ, farmMonster, infiniteMark, self.index, self.stageSceneId, self.baseTime, self.baseDistance, self.startSpeed, self.endSpeed)
    if self.index > 0 then
      self.scenePreZ = self.scenePreZ + size
    end
    return data
  end
end

function SurfingData:GetSceneConfig()
  if self.queue == nil or self.queue:size() <= 0 then
    if self.gm then
      self:InsertIds(self.ids)
    else
      Logger.LogInfo("surfing -- [GetSceneConfig] self.queue is nil or empty")
      return
    end
  end
  local farmMonster
  if self.curSceneIds == nil then
    self.index = self.index + 1
    local infiniteMark
    if not self.infiniteMark and self.index == self.infiniteIndex then
      infiniteMark = true
      self.infiniteMark = true
    end
    self.logic:CheckSceneData(self.index)
    local id = self.queue:dequeue()
    self.stageSceneId = id
    if 0 < self.index and self.logic then
      self.logic:LogSceneIds(id)
    end
    local stageSceneMeta = DataCenter.SurfingStageSceneTemplateManager:GetTemplate(id)
    if stageSceneMeta then
      local sceneIds = stageSceneMeta.sceneIds
      if sceneIds then
        self.curSceneIds = sceneIds
        local sceneSpeedZ = stageSceneMeta.speedZ
        if 0 < self.index then
          if self.speedZ == 0 then
            self.baseTime = 0
            self.baseDistance = self:GetBirthPos().z
            self.startSpeed = sceneSpeedZ
            self.endSpeed = sceneSpeedZ
            self.cacheDistance = stageSceneMeta.max_meters
            local time = self.cacheDistance / sceneSpeedZ
            self.cacheTime = Mathf.Ceil(time * 100000.0) / 100000.0
          else
            self.baseTime = self.baseTime + self.cacheTime
            self.baseDistance = self.baseDistance + self.cacheDistance
            self.cacheDistance = stageSceneMeta.max_meters
            if sceneSpeedZ ~= self.speedZ then
              self.startSpeed = self.speedZ
              self.endSpeed = sceneSpeedZ
              local changeDistance = (self.startSpeed + self.endSpeed) * 0.5 * self.speedChangeTime
              local time = (self.cacheDistance - changeDistance) / sceneSpeedZ
              self.cacheTime = self.speedChangeTime + Mathf.Ceil(time * 100000.0) / 100000.0
            else
              self.startSpeed = sceneSpeedZ
              self.endSpeed = sceneSpeedZ
              local time = self.cacheDistance / sceneSpeedZ
              self.cacheTime = Mathf.Ceil(time * 100000.0) / 100000.0
            end
          end
          self.speedZ = sceneSpeedZ
        else
          self.speedZ = 0
          self.baseTime = 0
          self.baseDistance = 0
          self.startSpeed = 0
          self.endSpeed = 0
          self.cacheDistance = 0
          self.cacheTime = 0
        end
        self.curSceneIndex = 0
      end
      farmMonster = stageSceneMeta.farmMonster
      return GetSceneData(self, farmMonster, infiniteMark)
    end
  end
  return GetSceneData(self, farmMonster)
end

function SurfingData:GetBirthPos()
  local birth_point = self.meta.birth_point
  if not string.IsNullOrEmpty(birth_point) then
    return Vector3.New(birth_point[1], 0, 0)
  end
  return Vector3.New(36, 0, 0)
end

function SurfingData:GetHeroId()
  return self.heroId
end

function SurfingData:InsertIds(ids)
  if ids then
    self.totalIndex = self.totalIndex + #ids
    self:InsertQueue(ids)
  end
end

function SurfingData:GetSwitchMonsterId()
  return self.meta and self.meta.switch_item
end

function SurfingData:GetSkyScoreData()
  if self.meta then
    local ids = self.meta.sky_score
    local index = math.random(1, #ids)
    local id = ids[index]
    local meta = DataCenter.SurfingStageSceneTemplateManager:GetTemplate(id)
    if meta then
      return meta.farmMonster
    end
  end
end

function SurfingData:GetCurTotalIndex()
  return self.totalIndex
end

function SurfingData:CheckIds(curIndex)
  if self.totalIndex - curIndex < self.constLength then
    if self.gm then
      self:InsertIds(self.ids)
      return false
    end
    if self.isPlayback then
      return false
    end
    return true
  end
end

function SurfingData:CheckThreshold()
  if self.preloadQueue:size() < self.preloadThreshold then
    return true
  end
  return false
end

function SurfingData:InsertMonsterIds(objInfo)
  if table.IsNullOrEmpty(objInfo) then
    return
  end
  if self.mIdQueue == nil then
    self.mIdQueue = Queue.new()
  end
  for _, v in ipairs(objInfo) do
    self.mIdQueue:enqueue(v)
  end
end

function SurfingData:GetNextMonsterId()
  if self.mIdQueue == nil or self.mIdQueue:size() == 0 then
    Logger.LogWarning("mIdQueue is empty")
    return
  end
  return self.mIdQueue:dequeue()
end

return SurfingData
