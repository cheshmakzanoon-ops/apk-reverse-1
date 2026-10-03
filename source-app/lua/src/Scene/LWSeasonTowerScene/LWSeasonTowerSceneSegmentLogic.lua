local Resource = CS.GameEntry.Resource
local LWSeasonTowerSceneSegmentLogic = BaseClass("LWSeasonTowerSceneSegmentLogic")
local PVEScenePath = "Assets/Main/Prefabs/UI/LWUISeasonTower/Scene/Prefab/%s.prefab"
local DEFAULT_SEGMENT_LENGTH = 44
local DEFAULT_PREFAB_PATH = "Assets/Main/Prefabs/UI/LWUISeasonTower/SeasonTowerScene.prefab"
local LWSeasonTowerUtil = require("DataCenter.LWSeasonTowerManager.LWSeasonTowerUtil")

function LWSeasonTowerSceneSegmentLogic:__init()
  self.active = false
  self.sceneId = nil
  self.sceneLoaded = false
  self.scenes = {}
  self.sceneCount = 0
  self.curScene = nil
  self.sceneLoadRequests = {}
  self.onCreateScene = nil
  self.onDestroyScene = nil
  self.onFirstSceneLoaded = nil
  self.sceneNameMap = {}
end

function LWSeasonTowerSceneSegmentLogic:__delete()
  self:Shutdown()
end

function LWSeasonTowerSceneSegmentLogic:Init(param)
  param = param or {}
  self.active = true
  self.sceneId = param.sceneId
  self.onCreateScene = param.onCreateScene
  self.onDestroyScene = param.onDestroyScene
  self.onFirstSceneLoaded = param.onFirstSceneLoaded
  self.sceneLoaded = false
  self.scenes = {}
  self.sceneCount = 0
  self.curScene = nil
  self.sceneLoadRequests = {}
  self:LoadSceneByCount(3)
end

function LWSeasonTowerSceneSegmentLogic:Shutdown()
  self.active = false
  if self.sceneLoadRequests then
    for _, req in pairs(self.sceneLoadRequests) do
      req:Destroy()
    end
  end
  self.sceneLoadRequests = {}
  self.sceneLoaded = false
  self.scenes = nil
  self.sceneCount = 0
  self.curScene = nil
  self.onCreateScene = nil
  self.onDestroyScene = nil
  self.onFirstSceneLoaded = nil
  self.sceneNameMap = {}
end

function LWSeasonTowerSceneSegmentLogic:CheckLoadingState()
  return self.sceneLoaded
end

function LWSeasonTowerSceneSegmentLogic:AddSceneLoadRequest(req)
  table.insert(self.sceneLoadRequests, req)
end

function LWSeasonTowerSceneSegmentLogic:RemoveSceneLoadRequest(req)
  for i = #self.sceneLoadRequests, 1, -1 do
    if self.sceneLoadRequests[i] == req then
      table.remove(self.sceneLoadRequests, i)
      return
    end
  end
end

function LWSeasonTowerSceneSegmentLogic:LoadSceneByCount(loadCount)
  if self.curScene and self.curScene.sceneData.index < self.sceneCount - 3 then
    return
  end
  for _ = 1, loadCount or 1 do
    local sceneIndex = self.sceneCount + 1
    local startZ = (sceneIndex - 1) * DEFAULT_SEGMENT_LENGTH
    local sceneData = {
      index = sceneIndex,
      startZ = startZ,
      endZ = startZ + DEFAULT_SEGMENT_LENGTH,
      sceneName = self:GetSceneName()
    }
    self:LoadOneScene(sceneData)
    self.sceneCount = self.sceneCount + 1
  end
end

function LWSeasonTowerSceneSegmentLogic:LoadOneScene(sceneData)
  if self.onCreateScene then
    self.onCreateScene(sceneData.index)
  end
  self:InstantiateScene(sceneData, function(request)
    table.insert(self.scenes, {
      sceneData = sceneData,
      root = request.gameObject.transform,
      request = request
    })
  end)
end

function LWSeasonTowerSceneSegmentLogic:InstantiateScene(sceneData, onComplete)
  local prefabPath = string.format(PVEScenePath, sceneData.sceneName)
  local req = Resource:InstantiateAsync(prefabPath, ObjectPoolTag.Normal)
  self:AddSceneLoadRequest(req)
  req:completed("+", function(request)
    if not self.active then
      request:Destroy()
      return
    end
    if request.isError then
      return
    end
    local segmentObj = request.gameObject
    segmentObj.name = sceneData.sceneName .. "_" .. sceneData.index
    local segmentRoot = segmentObj.transform
    segmentRoot:Set_position(0, 0, sceneData.startZ)
    if onComplete then
      onComplete(request)
    end
    if not self.sceneLoaded and sceneData.index == 1 then
      self.sceneLoaded = true
      if self.onFirstSceneLoaded then
        self.onFirstSceneLoaded()
      end
    end
  end)
end

function LWSeasonTowerSceneSegmentLogic:IsSceneContainsZ(scene, z)
  if scene == nil or scene.sceneData == nil then
    return false
  end
  local startZ = scene.sceneData.startZ
  local endZ = scene.sceneData.endZ
  return z >= startZ and z < endZ
end

function LWSeasonTowerSceneSegmentLogic:GetPreviousSceneNeedDestroy(curScene)
  if curScene == nil or curScene.sceneData == nil or self.scenes == nil then
    return nil
  end
  local targetIndex = curScene.sceneData.index - 1
  for _, scene in pairs(self.scenes) do
    if scene.sceneData and scene.sceneData.index == targetIndex then
      return scene
    end
  end
  return nil
end

function LWSeasonTowerSceneSegmentLogic:DestroyScene(scene, notify)
  if scene == nil or self.scenes == nil then
    return
  end
  if scene.request then
    scene.request:Destroy()
    self:RemoveSceneLoadRequest(scene.request)
  end
  for i = #self.scenes, 1, -1 do
    if self.scenes[i] == scene then
      table.remove(self.scenes, i)
      if notify and self.onDestroyScene and scene.sceneData then
        self.onDestroyScene(scene.sceneData.index)
      end
      return
    end
  end
end

function LWSeasonTowerSceneSegmentLogic:UpdateCurScene(targetPos)
  if self.scenes == nil or targetPos == nil then
    return
  end
  local curZ = targetPos.z
  local newScene
  local maxEndZ = 0
  for _, scene in pairs(self.scenes) do
    if scene.sceneData then
      local sceneEndZ = scene.sceneData.endZ
      if maxEndZ < sceneEndZ then
        maxEndZ = sceneEndZ
      end
    end
  end
  for _, scene in pairs(self.scenes) do
    if self:IsSceneContainsZ(scene, curZ) then
      newScene = scene
    end
  end
  if curZ >= maxEndZ - DEFAULT_SEGMENT_LENGTH * 2 then
    self:LoadSceneByCount(1)
  end
  if newScene ~= self.curScene then
    local preScene = self:GetPreviousSceneNeedDestroy(self.curScene)
    if preScene then
      self:DestroyScene(preScene, true)
    end
    self.curScene = newScene
  end
end

function LWSeasonTowerSceneSegmentLogic:SetShowSceneList(showLevelList, currentFloor)
  if table.IsNullOrEmpty(showLevelList) then
    return
  end
  local stageData = DataCenter.LWSeasonTowerManager:GetSelectStage()
  if stageData == nil then
    return
  end
  local floor = currentFloor
  local list = {}
  local nextFloor = floor
  for _, v in ipairs(showLevelList) do
    nextFloor = nextFloor + SeasonTowerConfig.LevelToFloor[v]
    local difficultyTemplate = LWSeasonTowerUtil.GetDifficulty(stageData.stageId, nextFloor)
    if difficultyTemplate ~= nil then
      if self.sceneId == difficultyTemplate.show then
        local name = self:GetSceneNameById(difficultyTemplate.show)
        if name then
          table.insert(list, name)
        end
      else
        local name1 = self:GetSceneNameById(self.sceneId)
        local name2 = self:GetSceneNameById(difficultyTemplate.show)
        if name1 and name2 then
          table.insert(list, name1 .. "_" .. name2)
        end
        self.sceneId = difficultyTemplate.show
      end
    end
  end
  Logger.Log(table.concat(list, " , "))
  self.showSceneNameList = list
  if self.curScene then
    for _, scene in ipairs(self.scenes) do
      if scene.sceneData.index > self.curScene.sceneData.index then
        local sceneName = table.remove(self.showSceneNameList, 1)
        if sceneName then
          self:ReloadScene(scene.sceneData.index, sceneName)
        end
      end
    end
  end
end

function LWSeasonTowerSceneSegmentLogic:ReloadScene(sceneIndex, sceneName)
  local target
  for _, scene in pairs(self.scenes) do
    if scene.sceneData and scene.sceneData.index == sceneIndex then
      target = scene
      break
    end
  end
  if target == nil or target.request == nil then
    return
  end
  if target.request.gameObject.name == sceneName .. "_" .. target.sceneData.index then
    return
  end
  target.sceneData.sceneName = sceneName
  self:RemoveSceneLoadRequest(target.request)
  self:InstantiateScene(target.sceneData, function(request)
    target.root = request.gameObject.transform
    target.request:Destroy()
    target.request = request
  end)
end

function LWSeasonTowerSceneSegmentLogic:GetSceneName()
  if not table.IsNullOrEmpty(self.showSceneNameList) then
    return table.remove(self.showSceneNameList, 1)
  else
    local name = self:GetSceneNameById(self.sceneId)
    return name
  end
end

function LWSeasonTowerSceneSegmentLogic:GetSceneNameById(sceneId)
  if self.sceneNameMap[sceneId] then
    return self.sceneNameMap[sceneId]
  end
  local sceneMeta = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_Scene), sceneId)
  if sceneMeta == nil then
    return
  end
  self.sceneNameMap[sceneId] = sceneMeta.asset
  return self.sceneNameMap[sceneId]
end

return LWSeasonTowerSceneSegmentLogic
