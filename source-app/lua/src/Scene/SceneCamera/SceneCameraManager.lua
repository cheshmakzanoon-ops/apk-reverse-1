local SceneCameraManager = BaseClass("SceneCameraManager")
local cityFar = 500
local worldFar = 7000
local pveFar = 500
local lastWorldFar = 7000
local bigWorldFar = 10000

function SceneCameraManager:AddListeners()
  EventManager:GetInstance():AddListener(EventId.LOAD_COMPLETE, self.OnLoadCompLete)
  EventManager:GetInstance():AddListener(EventId.OnEnterWorld, self.OnEnterWorld)
  EventManager:GetInstance():AddListener(EventId.OnEnterCity, self.OnEnterCity)
  EventManager:GetInstance():AddListener(EventId.PveLevelEnter, self.OnEnterPve)
end

function SceneCameraManager:__init()
  self.camera = CS.UnityEngine.Camera.main
  self.inWorld = nil
  self.inCity = nil
  self.worldCameraMinX = nil
  self.worldCameraMinY = nil
  self.worldCameraMaxX = nil
  self.worldCameraMaxY = nil
  self:AddListeners()
end

function SceneCameraManager:__delete()
  self.camera = nil
  self.inWorld = nil
  self.inCity = nil
  self.worldCameraMinX = nil
  self.worldCameraMinY = nil
  self.worldCameraMaxX = nil
  self.worldCameraMaxY = nil
  self:RemoveListener(self)
end

function SceneCameraManager:Startup()
end

function SceneCameraManager:RemoveListener()
  EventManager:GetInstance():RemoveListener(EventId.LOAD_COMPLETE, self.OnLoadCompLete)
  EventManager:GetInstance():RemoveListener(EventId.OnEnterWorld, self.OnEnterWorld)
  EventManager:GetInstance():RemoveListener(EventId.OnEnterCity, self.OnEnterCity)
  EventManager:GetInstance():RemoveListener(EventId.PveLevelEnter, self.OnEnterPve)
end

function SceneCameraManager.OnLoadCompLete()
  local self = DataCenter.SceneCameraManager
  if IsNull(self.camera) then
    return
  end
  if SceneUtils.GetIsInCity() then
    self.camera.farClipPlane = cityFar
    lastWorldFar = worldFar
  elseif SceneUtils.GetIsInWorld() then
    local curServerId = LuaEntry.Player:GetCurServerId()
    local seasonInfo = SeasonUtil.GetSeasonInfo(curServerId)
    if seasonInfo == nil then
      local config = DataCenter.SeasonTemplateManager:GetConfigDataByServerId(curServerId)
      if config ~= nil and config.server_type == SeasonMapType.NineNation then
        self.camera.farClipPlane = bigWorldFar
        lastWorldFar = bigWorldFar
      else
        self.camera.farClipPlane = math.max(lastWorldFar, worldFar)
      end
    elseif seasonInfo:GetServerType(false) == SeasonMapType.NineNation then
      self.camera.farClipPlane = bigWorldFar
      lastWorldFar = bigWorldFar
    else
      self.camera.farClipPlane = math.max(lastWorldFar, worldFar)
    end
  elseif SceneUtils.GetIsInPve() then
    self.camera.farClipPlane = pveFar
  end
end

function SceneCameraManager.SwitchWorldClipPlane(seasonType)
  if seasonType ~= nil and SceneUtils.GetIsInWorld() then
    local self = DataCenter.SceneCameraManager
    if IsNull(self.camera) then
      return
    end
    if seasonType == SeasonMapType.NineNation then
      self.camera.farClipPlane = bigWorldFar
      lastWorldFar = bigWorldFar
    else
      self.camera.farClipPlane = math.max(lastWorldFar, worldFar)
    end
  end
end

function SceneCameraManager.OnEnterWorld()
  SceneCameraManager.OnLoadCompLete()
  local self = DataCenter.SceneCameraManager
  self.inWorld = true
  self.inCity = false
end

function SceneCameraManager.OnEnterCity()
  SceneCameraManager.OnLoadCompLete()
  local self = DataCenter.SceneCameraManager
  self.inWorld = false
  self.inCity = true
  self.worldCameraMinX = nil
  self.worldCameraMinY = nil
  self.worldCameraMaxX = nil
  self.worldCameraMaxY = nil
end

function SceneCameraManager.OnEnterPve()
  SceneCameraManager.OnLoadCompLete()
  local self = DataCenter.SceneCameraManager
  self.inWorld = false
  self.inCity = false
  self.worldCameraMinX = nil
  self.worldCameraMinY = nil
  self.worldCameraMaxX = nil
  self.worldCameraMaxY = nil
end

function SceneCameraManager:UpdateWorldCameraView(minX, minY, maxX, maxY)
  if minX ~= self.worldCameraMinX or minY ~= self.worldCameraMinY or maxX ~= self.worldCameraMaxX or maxY ~= self.worldCameraMaxY then
    self.worldCameraMinX = minX
    self.worldCameraMinY = minY
    self.worldCameraMaxX = maxX
    self.worldCameraMaxY = maxY
    EventManager:GetInstance():Broadcast(EventId.WorldCameraViewChanged, {
      minX,
      minY,
      maxX,
      maxY
    })
  end
end

function SceneCameraManager:Description()
  local sb = StringBuilder.New()
  sb:AppendFormatLine("SceneCameraManager:")
  sb:AppendFormatLine("InWorld:%s, InCity:%s", self.inWorld, self.inCity)
  sb:AppendFormatLine("WorldView: min:(%s, %s), max:(%s, %s)", self.worldCameraMinX or "?", self.worldCameraMinY or "?", self.worldCameraMaxX or "?", self.worldCameraMaxY or "?")
  return sb:ToString()
end

return SceneCameraManager
