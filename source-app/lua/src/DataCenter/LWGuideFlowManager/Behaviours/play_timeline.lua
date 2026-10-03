local base = require("DataCenter.LWGuideFlowManager.Behaviours.BehaviourBase")
local metatbl = {__index = base}
local behaviour = setmetatable({}, metatbl)
behaviour.params = {
  {"string", "resPath"},
  {"number", "positionX"},
  {"number", "positionY"},
  {"number", "positionZ"}
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
    "bool",
    "monopolyObstablVisible",
    true
  },
  {
    "number",
    "hideBuildingType",
    -1
  }
}

function behaviour:__Awake()
  self.position = Vector3(self.positionX, self.positionY, self.positionZ)
  self.timelineSyncHandle = nil
  self.timeline = nil
  self.director = nil
  DataCenter.LWGuideFlowTimelineHandler:TimelineAwake(self.flowId)
  local jpResPath = DataCenter.LWArmedUpgradeManager:TryGetJPMonicaTimelineResPath(self.resPath)
  self.resPath = jpResPath
  
  function self.OnTimelineLoaded(handle)
    if handle.isError then
      self:LogError("load res failed:" .. self.resPath)
      self.done = true
      return
    end
    DataCenter.LWGuideFlowTimelineHandler:TimelineLoaded(self.flowId)
    local director = handle.gameObject:GetComponentInChildren(typeof(CS.UnityEngine.Playables.PlayableDirector))
    handle.gameObject.transform.position = self.position
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
      handle.gameObject
    })
  end
end

function behaviour:Begin()
  self.__blockerHandleID = UIManager:GetInstance():EnableInteractionBlocker(2, self.blockerExpireTime)
  local timeline = CS.GameEntry.Resource:InstantiateAsync(self.resPath)
  timeline:completed("+", self.OnTimelineLoaded)
  self.timeline = timeline
  if self.monopolyObstablVisible ~= nil and self.monopolyObstablVisible == false then
    DataCenter.MonopolyManager:SetAllObstableRelatedAppearanceVisible(false)
  end
  if self.hideBuildingType ~= nil and self.hideBuildingType >= 0 then
    local buildDataList = DataCenter.BuildManager:GetFunbuildListByItemID(self.hideBuildingType)
    local count = table.count(buildDataList)
    for i = 1, count do
      local buildData = buildDataList[i]
      CS.SceneManager.World:HideObject(buildData.pointId)
    end
  end
  DataCenter.BuildBubbleManager:HideBubbleNode()
end

function behaviour:End()
  UIManager:GetInstance():DisableInteractionBlocker(self.__blockerHandleID)
  self.__blockerHandleID = nil
  if self.monopolyObstablVisible ~= nil and self.monopolyObstablVisible == false then
    DataCenter.MonopolyManager:SetAllObstableRelatedAppearanceVisible(true)
  end
  if self.hideBuildingType ~= nil and self.hideBuildingType >= 0 then
    local buildDataList = DataCenter.BuildManager:GetFunbuildListByItemID(self.hideBuildingType)
    local count = table.count(buildDataList)
    for i = 1, count do
      local buildData = buildDataList[i]
      CS.SceneManager.World:ShowObject(buildData.pointId)
    end
  end
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
