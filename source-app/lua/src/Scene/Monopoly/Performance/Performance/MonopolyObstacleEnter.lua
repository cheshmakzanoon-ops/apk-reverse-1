local base = require("Scene.Monopoly.Performance.Performance.MonopolyPerBase")
local MonopolyObstacleEnter = BaseClass("MonopolyObstacleEnter", base)
local transitionTime = 0.5

function MonopolyObstacleEnter:__init(mgr, id, lineData)
  self.director = nil
  self.directorStopCallback = nil
  self.syncCamera = lineData:getValue("sync_camera") == 1
  self.blockerExpireTime = self.syncCamera and 999 or 0
end

function MonopolyObstacleEnter:__delete()
end

function MonopolyObstacleEnter:OnDestroy()
  if self.timelineSyncHandle ~= nil and not IsNull(CS.SceneManager.World) then
    CS.SceneManager.World:ExitTimeline(self.timelineSyncHandle)
    self.timelineSyncHandle = nil
  end
  if self.director and self.directorStopCallback then
    self.director:stopped("-", self.directorStopCallback)
    self.director = nil
    self.directorStopCallback = nil
  end
  TimerManager:GetInstance():DelayInvoke(function()
    if self.__blockerHandleID then
      UIManager:GetInstance():DisableInteractionBlocker(self.__blockerHandleID)
      self.__blockerHandleID = nil
    end
  end, self.transitionTime or 0)
  self.landId = nil
  self.oldManTrans = nil
  self.modelTrigger = nil
  base.OnDestroy(self)
end

function MonopolyObstacleEnter:Begin()
  base.Begin(self)
  if self.blockerExpireTime > 0 then
    self.__blockerHandleID = UIManager:GetInstance():EnableInteractionBlocker(2, self.blockerExpireTime)
  end
end

function MonopolyObstacleEnter:OnResLoaded(handle)
  base.OnResLoaded(self, handle)
  local director = handle.gameObject:GetComponentInChildren(typeof(CS.UnityEngine.Playables.PlayableDirector))
  handle.gameObject.transform.position = Vector3.zero
  self.director = director
  if self.syncCamera then
    local camInTimeline = handle.gameObject:GetComponentInChildren(typeof(CS.UnityEngine.Camera))
    if camInTimeline then
      self.timelineSyncHandle = CS.SceneManager.World:EnterTimeline(camInTimeline, transitionTime)
      camInTimeline.enabled = false
      self.transitionTime = transitionTime
    end
  end
  
  function self.directorStopCallback()
    self.mgr:TryTriggerPerformanceEnd(self.id)
  end
  
  director:stopped("+", self.directorStopCallback)
end

function MonopolyObstacleEnter:End()
  base.End(self)
end

return MonopolyObstacleEnter
