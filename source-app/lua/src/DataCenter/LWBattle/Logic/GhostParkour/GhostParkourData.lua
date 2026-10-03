local GhostParkourData = BaseClass("GhostParkourData")
local Queue = require("DataCenter.LWBattle.Logic.Surfing.Queue")
local GhostParkourSceneInfo = require("DataCenter.LWBattle.Logic.GhostParkour.GhostParkourSceneInfo")
local SurfingScenePool = require("DataCenter.LWBattle.Logic.Surfing.SurfingScenePool")

function GhostParkourData:__init(logic, id, param)
  self.logic = logic
  self.scenePreZ = 0
  self.sceneIndex = -1
  self.curSceneIds = nil
  self.curSceneIndex = 0
  self.metersArr = nil
  self.speedZ = 0
  self.index = -1
  self.stageSceneId = nil
  self.scenePool = SurfingScenePool.New()
  self.preloadThreshold = 10
  self.isFinished = nil
  self:InitData(id, param)
end

function GhostParkourData:__delete()
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
  self.preloadList = nil
  self.isFinished = nil
  self.metersArr = nil
end

function GhostParkourData:InitData(id, param)
  if id == nil then
    Logger.LogError("GhostParkourData Error : metaId is nil")
    return
  end
  self.metaId = id
  self.meta = DataCenter.SurfingStageTemplateManager:GetTemplate(self.metaId)
  local ids
  local gm = false
  local pre_scene = self.meta.pre_scene or 1000
  if param then
    if param.enterType == PVEEnterType.GM or param.enterType == PVEEnterType.Guide then
      ids = self.meta.gm_ids
      gm = true
    else
      ids = param.message and param.message.ids
    end
  end
  self.gm = gm
  self.queue = Queue.new()
  self.queue:enqueue(pre_scene)
  if gm then
    self:InsertQueue(ids)
  else
    self:InitStageSceneIds(ids)
  end
  if self.meta then
    self.heroId = self.meta.default_hero
  end
  self.preloadQueue = Queue.new()
  self.preloadList = {}
  if gm and not string.IsNullOrEmpty(self.meta.gm_ids_guide) then
    self.guideIds = string.string2array_num(self.meta.gm_ids_guide, "|", ";")
  end
  self.moveSpeed = 0
  local startScene = self.meta.start_scene[1]
  if startScene then
    local stageSceneMeta = DataCenter.SurfingStageSceneTemplateManager:GetTemplate(startScene)
    if stageSceneMeta then
      self.moveSpeed = stageSceneMeta.speedZ
    end
  end
end

function GhostParkourData:InitStageSceneIds(ids)
  if table.IsNullOrEmpty(ids) then
    return self:InitStageSceneIdsConfig()
  end
  local maxMeters = 0
  local metersArr = {}
  if self.meta and self.queue then
    local queue = self.queue
    local stageSceneMeta
    local count = #ids
    for i, v in ipairs(ids) do
      queue:enqueue(v)
      if i == count then
        break
      end
      stageSceneMeta = DataCenter.SurfingStageSceneTemplateManager:GetTemplate(v)
      if stageSceneMeta then
        maxMeters = maxMeters + stageSceneMeta.max_meters
      end
      metersArr[i] = maxMeters
    end
    maxMeters = maxMeters + (self.meta.end_line or 0)
  end
  self.maxMeters = maxMeters
  self.metersArr = metersArr
end

function GhostParkourData:InitStageSceneIdsConfig()
  local maxMeters = 0
  local metersArr = {}
  if self.meta and self.queue then
    local queue = self.queue
    local start_scene = self.meta.start_scene
    local stageSceneMeta
    if start_scene then
      for _, v in ipairs(start_scene) do
        queue:enqueue(v)
        stageSceneMeta = DataCenter.SurfingStageSceneTemplateManager:GetTemplate(v)
        if stageSceneMeta then
          maxMeters = maxMeters + stageSceneMeta.max_meters
        end
        metersArr[#metersArr + 1] = maxMeters
      end
    end
    local surfingScene = self.meta:GetSurfingScene()
    if surfingScene then
      local id
      for _, v in ipairs(surfingScene) do
        local num = v[1]
        local id_arr = v[2]
        if id_arr then
          local count = #id_arr
          if count == 1 then
            for _ = 1, num do
              id = id_arr[1]
              queue:enqueue(id)
              stageSceneMeta = DataCenter.SurfingStageSceneTemplateManager:GetTemplate(id)
              if stageSceneMeta then
                maxMeters = maxMeters + stageSceneMeta.max_meters
              end
              metersArr[#metersArr + 1] = maxMeters
            end
          else
            for _ = 1, num do
              local r = math.random(1, count)
              id = id_arr[r]
              queue:enqueue(id)
              stageSceneMeta = DataCenter.SurfingStageSceneTemplateManager:GetTemplate(id)
              if stageSceneMeta then
                maxMeters = maxMeters + stageSceneMeta.max_meters
              end
              metersArr[#metersArr + 1] = maxMeters
            end
          end
        end
      end
    end
    local end_scene = self.meta.end_scene
    if end_scene and end_scene ~= 0 then
      queue:enqueue(end_scene)
      maxMeters = maxMeters + (self.meta.end_line or 0)
    end
  end
  self.maxMeters = maxMeters
  self.metersArr = metersArr
end

function GhostParkourData:InsertQueue(ids)
  if self.queue == nil then
    Logger.LogInfo("GhostParkour -- [InsertQueue] self.queue is nil")
    return
  end
  if table.IsNullOrEmpty(ids) then
    Logger.LogInfo("GhostParkour -- [InsertQueue] ids is nil or empty")
    return
  end
  local maxMeters = 0
  local stageSceneMeta
  local queue = self.queue
  for _, v in ipairs(ids) do
    queue:enqueue(v)
    stageSceneMeta = DataCenter.SurfingStageSceneTemplateManager:GetTemplate(v)
    if stageSceneMeta then
      maxMeters = maxMeters + stageSceneMeta.max_meters
    end
  end
  local end_scene = self.meta.end_scene
  if end_scene and end_scene ~= 0 then
    queue:enqueue(end_scene)
    maxMeters = maxMeters + (self.meta.end_line or 0)
  end
  self.maxMeters = maxMeters
end

function GhostParkourData:GetSceneExt()
  return self.meta.sceneExt
end

function GhostParkourData:PreloadScenes(callback)
  if self.queue == nil then
    Logger.LogInfo("GhostParkour -- [PreloadScenes] self.queue is nil")
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

function GhostParkourData:GetPreloadScenes()
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

function GhostParkourData:GetSceneConfigs(count)
  local res = {}
  if self.preloadQueue == nil then
    self:PreloadScenes()
  end
  local result = self:GetPreloadScenes()
  if result ~= nil then
    self.scenePool:PreloadScenes(result)
  end
  if self.preloadQueue == nil or self.preloadQueue:size() <= 0 then
    Logger.LogInfo("GhostParkour -- [GetSceneConfigs] self.preloadQueue is nil or empty")
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

local function GetSceneData(self, farmMonster, endSceneFlag)
  if self.curSceneIds == nil then
    Logger.LogInfo("GhostParkour -- [GetSceneData] self.curSceneIds is nil")
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
    local data = GhostParkourSceneInfo.New()
    if self.index == 0 then
      self.scenePreZ = -size
    elseif 0 > self.scenePreZ then
      self.scenePreZ = 0
    end
    data:SetData(id, sceneMeta.asset, size, self.sceneIndex, self.scenePreZ, self.speedZ, farmMonster, self.index, self.stageSceneId)
    if endSceneFlag then
      data.endLine = self.meta.end_line
    end
    if self.index > 0 then
      self.scenePreZ = self.scenePreZ + size
    end
    return data
  end
end

function GhostParkourData:GetSceneConfig()
  local farmMonster
  if self.curSceneIds == nil then
    if self.isFinished then
      return
    end
    if self.queue == nil or self.queue:size() <= 0 then
      Logger.LogError("GhostParkour -- [GetSceneConfig] queue is nil or empty")
      return
    end
    local id = self.queue:dequeue()
    local endSceneFlag
    if self.queue:size() <= 0 then
      if not id or id == 0 then
        Logger.LogError("GhostParkour -- [GetSceneConfig] end_scene id is nil")
        return
      end
      endSceneFlag = true
      self.isFinished = true
    end
    self.index = self.index + 1
    self.stageSceneId = id
    local stageSceneMeta = DataCenter.SurfingStageSceneTemplateManager:GetTemplate(id)
    if stageSceneMeta then
      local sceneIds = stageSceneMeta.sceneIds
      if sceneIds then
        self.curSceneIds = sceneIds
        self.curSceneIndex = 0
      end
      farmMonster = stageSceneMeta.farmMonster
      return GetSceneData(self, farmMonster, endSceneFlag)
    end
  end
  return GetSceneData(self, farmMonster)
end

function GhostParkourData:GetBirthPos()
  if self.birthPoint == nil then
    local birth_point = self.meta.birth_point
    if not string.IsNullOrEmpty(birth_point) then
      self.birthPoint = Vector3.New(birth_point[1], 0, 0)
    else
      self.birthPoint = Vector3.New(36, 0, 0)
    end
  end
  return self.birthPoint
end

function GhostParkourData:GetMoveSpeed()
  return self.moveSpeed
end

function GhostParkourData:GetHeroId()
  return self.heroId
end

function GhostParkourData:CheckThreshold()
  if self.preloadQueue:size() < self.preloadThreshold then
    return true
  end
  return false
end

function GhostParkourData:GetSwitchMonsterId()
  return self.meta and self.meta.switch_item
end

function GhostParkourData:GetMaxMeters()
  return self.maxMeters or 0
end

function GhostParkourData:GetCurStageSceneLen(index)
  if self.metersArr == nil or index == nil or index == 0 then
    Logger.LogError("GhostParkour -- [GetCurStageSceneLen] get error")
    return 0
  end
  return self.metersArr[index] or 0
end

return GhostParkourData
