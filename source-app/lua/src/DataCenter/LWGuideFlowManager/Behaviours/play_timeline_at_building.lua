local base = require("DataCenter.LWGuideFlowManager.Behaviours.BehaviourBase")
local metatbl = {__index = base}
local behaviour = setmetatable({}, metatbl)
behaviour.params = {
  {"string", "resPath"},
  {"number", "buildingId"}
}
behaviour.optionalParams = {
  {
    "bool",
    "syncCamera",
    true
  },
  {
    "bool",
    "exitAtBegin",
    false
  },
  {
    "number",
    "blockerExpireTime",
    999
  },
  {
    "number",
    "positionX",
    0
  },
  {
    "number",
    "positionY",
    0
  },
  {
    "number",
    "positionZ",
    0
  }
}

local function __GetBuildingPosition(self)
  local buildingData = DataCenter.BuildManager:GetBuildingDatasByBuildingId(self.buildingId)[1]
  if not buildingData then
    return Vector3.zero
  end
  if not CS.SceneManager.World then
    return Vector3.zero
  end
  local targetBuilding = CS.SceneManager.World:GetBuildingByPoint(buildingData.pointId)
  if IsNull(targetBuilding) then
    return Vector3.zero
  end
  return Vector3.New(targetBuilding.transform.position.x + self.positionX, targetBuilding.transform.position.y + self.positionY, targetBuilding.transform.position.z + self.positionZ)
end

function behaviour:__Awake()
  self.timelineSyncHandle = nil
  self.timeline = nil
  self.director = nil
  DataCenter.LWGuideFlowTimelineHandler:TimelineAwake(self.flowId)
  
  function self.OnTimelineLoaded(handle)
    if handle.isError then
      self:LogError("load res failed:" .. self.resPath)
      self.done = true
      return
    end
    DataCenter.LWGuideFlowTimelineHandler:TimelineLoaded(self.flowId)
    local director = handle.gameObject:GetComponentInChildren(typeof(CS.UnityEngine.Playables.PlayableDirector))
    handle.gameObject.transform.position = __GetBuildingPosition(self)
    self.director = director
    if self.syncCamera then
      local camInTimeline = handle.gameObject:GetComponentInChildren(typeof(CS.UnityEngine.Camera))
      self.timelineSyncHandle = CS.SceneManager.World:EnterTimeline(camInTimeline, 0.5)
      camInTimeline.enabled = false
    end
    
    function self.directorStopCallback()
      handle:RealDestroy()
      if self.timelineSyncHandle ~= nil and not IsNull(CS.SceneManager.World) then
        CS.SceneManager.World:ExitTimeline(self.timelineSyncHandle)
        self.timelineSyncHandle = nil
      end
      if not self.exitAtBegin then
        self.done = true
      end
      DataCenter.LWGuideFlowTimelineHandler:TimelineStoped(self.flowId)
    end
    
    director:stopped("+", self.directorStopCallback)
    if not IsNull(director) then
      director:Play()
    end
    if self.exitAtBegin then
      self.done = true
    end
    EventManager:GetInstance():Broadcast(EventId.GF_play_timeline_loaded, {
      self.resPath,
      handle.gameObject,
      buildingId = self.buildingId
    })
  end
end

function behaviour:Begin()
  self.__blockerHandleID = UIManager:GetInstance():EnableInteractionBlocker(2, self.blockerExpireTime)
  local timeline = CS.GameEntry.Resource:InstantiateAsync(self.resPath)
  timeline:completed("+", self.OnTimelineLoaded)
  self.timeline = timeline
  DataCenter.BuildBubbleManager:HideBubbleNode()
end

function behaviour:End()
  UIManager:GetInstance():DisableInteractionBlocker(self.__blockerHandleID)
  self.__blockerHandleID = nil
  DataCenter.BuildBubbleManager:ShowBubbleNode()
  self.timeline = nil
  self.director = nil
  self.directorStopCallback = nil
end

function behaviour:OnDestroy()
  if self.director and self.directorStopCallback then
    self.director:stopped("-", self.directorStopCallback)
  end
  self.director = nil
  self.directorStopCallback = nil
  if self.timeline then
    self.timeline:RealDestroy()
    self.timeline = nil
  end
end

return behaviour
