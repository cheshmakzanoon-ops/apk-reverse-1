local LWCivilizationSparkTimelineBehaviour = BaseClass("LWGuideFlowTimelineHandler")
local transitionTime = 0.5

function LWCivilizationSparkTimelineBehaviour:SetData(param)
  self.resPath = param.resPath
  self.positionX = param.positionX or 0
  self.positionY = param.positionY or 0
  self.positionZ = param.positionZ or 0
  self.syncCamera = param.syncCamera
  self.exitAtBegin = param.exitAtBegin
  self.blockerExpireTime = param.blockerExpireTime
  self.monopolyObstaclVisible = param.monopolyObstaclVisible
  self.hideBuildingType = param.hideBuildingType
  self.beforePlay = param.beforePlay
  self.stoppedPlay = param.stoppedPlay
  self:__Awake()
end

function LWCivilizationSparkTimelineBehaviour:__Awake()
  self.position = Vector3(self.positionX, self.positionY, self.positionZ)
  self.timelineSyncHandle = nil
  self.timeline = nil
  self.director = nil
  self.transitionTime = 0
  
  function self.OnTimelineLoaded(handle)
    if handle.isError then
      self:LogError("load res failed:" .. self.resPath)
      self.done = true
      return
    end
    local director = handle.gameObject:GetComponentInChildren(typeof(CS.UnityEngine.Playables.PlayableDirector))
    handle.gameObject.transform.position = self.position
    self.director = director
    if self.syncCamera then
      local camInTimeline = handle.gameObject:GetComponentInChildren(typeof(CS.UnityEngine.Camera))
      self.timelineSyncHandle = CS.SceneManager.World:EnterTimeline(camInTimeline, transitionTime)
      camInTimeline.enabled = false
      self.transitionTime = transitionTime
    end
    
    function self.directorStopCallback()
      self:End()
    end
    
    director:stopped("+", self.directorStopCallback)
    if not IsNull(director) then
      director:Play()
    end
  end
end

function LWCivilizationSparkTimelineBehaviour:Begin()
  self.__blockerHandleID = UIManager:GetInstance():EnableInteractionBlocker(2, self.blockerExpireTime)
  if self.beforePlay then
    self.beforePlay()
  end
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

function LWCivilizationSparkTimelineBehaviour:Clear()
  TimerManager:GetInstance():DelayInvoke(function()
    UIManager:GetInstance():DisableInteractionBlocker(self.__blockerHandleID)
    self.__blockerHandleID = nil
  end, self.transitionTime or 0)
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

function LWCivilizationSparkTimelineBehaviour:End()
  if self.timelineSyncHandle ~= nil and not IsNull(CS.SceneManager.World) then
    CS.SceneManager.World:ExitTimeline(self.timelineSyncHandle)
    self.timelineSyncHandle = nil
  end
  if self.monopolyObstablVisible ~= nil and self.monopolyObstablVisible == false then
    DataCenter.MonopolyManager:SetAllObstableRelatedAppearanceVisible(true)
    self.monopolyObstablVisible = nil
  end
  if self.hideBuildingType ~= nil and self.hideBuildingType >= 0 then
    local buildDataList = DataCenter.BuildManager:GetFunbuildListByItemID(self.hideBuildingType)
    local count = table.count(buildDataList)
    for i = 1, count do
      local buildData = buildDataList[i]
      CS.SceneManager.World:ShowObject(buildData.pointId)
    end
    self.hideBuildingType = nil
  end
  DataCenter.BuildBubbleManager:ShowBubbleNode()
  if self.stoppedPlay then
    self.stoppedPlay()
  end
  self:Clear()
end

function LWCivilizationSparkTimelineBehaviour:OnDestroy()
  self:Clear()
end

return LWCivilizationSparkTimelineBehaviour
