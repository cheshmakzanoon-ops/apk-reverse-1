local LWOpeningStageDirtyWorks = {}
local LWCivilizationSparkTimelineCtrl = require("DataCenter.LWCivilizationSpark.LWCivilizationSparkTimelineCtrl")

function LWOpeningStageDirtyWorks:Clear()
  self.flyingStarTasks = 0
  DataCenter.LWOpeningStageManager.utils.ClearAllFingers()
  for i = 1, table.count(self.reqs) do
    if self.reqs[i] then
      self.reqs[i]:Destroy()
    end
  end
  self.reqs = {}
  for i = 1, table.count(self.tweens) do
    if self.tweens[i] then
      self.tweens[i]:Kill()
    end
  end
  self.tweens = {}
  self:ClearAllDelayTimers()
  LWCivilizationSparkTimelineCtrl:Clear()
end

function LWOpeningStageDirtyWorks:Do(enterGame)
  if self.reqs == nil then
    self.reqs = {}
  end
  if self.tweens == nil then
    self.tweens = {}
  end
  local mgr = DataCenter.LWOpeningStageManager
  if #mgr.closeStages == 0 then
    return
  end
  local currStageId = mgr.closeStages[1].id
  if currStageId <= 1 then
    if enterGame then
      LWOpeningStageDirtyWorks.ShowNextStageFingerDelay()
    end
  elseif currStageId == 2 then
    LWOpeningStageDirtyWorks.ShowNextStageFingerDelay()
  elseif currStageId == 3 then
    if enterGame then
      LWOpeningStageDirtyWorks.ShowNextStageFingerDelay()
    else
      LWCivilizationSparkTimelineCtrl:PlayTimeline(CiSparkTimelineType.RecueMonica, function()
        LWOpeningStageDirtyWorks.ShowNextStageFingerDelay()
      end)
    end
  elseif currStageId == 4 then
    DataCenter.XiaoFanManager:HideBadOneWall()
  end
end

function LWOpeningStageDirtyWorks.LoadFingerBubble(pos, stageId)
  local utils = DataCenter.LWOpeningStageManager.utils
  local currStageId = DataCenter.LWOpeningStageManager:GetCurStageId()
  if currStageId and currStageId == stageId then
    utils.ShowFingerClick(pos, nil, 2)
  end
end

function LWOpeningStageDirtyWorks:CreateDelayTimer(callback, delay, timerName)
  if self.delayTimers == nil then
    self.delayTimers = {}
  end
  timerName = timerName or "timer_" .. tostring(#self.delayTimers + 1)
  local timer = TimerManager:GetInstance():DelayInvoke(function()
    if self.delayTimers[timerName] then
      self.delayTimers[timerName] = nil
    end
    callback()
  end, delay)
  self.delayTimers[timerName] = timer
  return timer
end

function LWOpeningStageDirtyWorks:ClearAllDelayTimers()
  if self.delayTimers then
    for name, timer in pairs(self.delayTimers) do
      if timer then
        timer:Stop()
      end
    end
    self.delayTimers = {}
  end
end

function LWOpeningStageDirtyWorks.ShowNextStageFingerDelay()
  DataCenter.LWOpeningStageManager.utils.ClearAllFingers()
  local self = DataCenter.LWOpeningStageManager.dirtyWorks
  self:CreateDelayTimer(function()
    LWOpeningStageDirtyWorks.ShowNextStageFinger()
  end, 2)
end

function LWOpeningStageDirtyWorks.ShowNextStageFinger()
  local utils = DataCenter.LWOpeningStageManager.utils
  local lineData = DataCenter.LWOpeningStageManager.openStages[1]
  if lineData then
    utils.ShowFingerClick(utils.GetStagePosArr(lineData)[1] + Vector3(0, 7, 0), nil, 2)
  end
end

function LWOpeningStageDirtyWorks.PlayTimeline(timelineType)
  LWCivilizationSparkTimelineCtrl:PlayTimeline(timelineType)
end

local function LoggerUseOldApi()
  Logger.LogError("[LWOpeningStageDirtyWorks_v2] someone is using old api, please check the stack and fix it")
end

function LWOpeningStageDirtyWorks:HeroDebut(mgr)
  LoggerUseOldApi()
end

function LWOpeningStageDirtyWorks:MoveToNextStageWaitingPos(callback)
  LoggerUseOldApi()
end

function LWOpeningStageDirtyWorks:HeroMoveTo(targetPos, callback)
  LoggerUseOldApi()
end

function LWOpeningStageDirtyWorks:GateFixed()
  LoggerUseOldApi()
end

function LWOpeningStageDirtyWorks:PlotGroupDone(plotGroupId)
  LoggerUseOldApi()
end

function LWOpeningStageDirtyWorks:ThrowAllWorkers()
  LoggerUseOldApi()
end

function LWOpeningStageDirtyWorks:FakeGetGump()
  LoggerUseOldApi()
end

function LWOpeningStageDirtyWorks:CheckFakeNewHero(levelId)
end

function LWOpeningStageDirtyWorks:ShowFakeHero(nextLevel, index, newHero)
end

local function LoadHammerBuildingBubble()
  LoggerUseOldApi()
end

function LWOpeningStageDirtyWorks.OnUIWindowClose(windowName)
  LoggerUseOldApi()
end

function LWOpeningStageDirtyWorks.LoadFingerBubbleByBuildingBubble(buildingParam)
  LoggerUseOldApi()
end

function LWOpeningStageDirtyWorks.OnWelcomeNewFellowFinish()
  LoggerUseOldApi()
end

function LWOpeningStageDirtyWorks:TryOnBuildTimeEnd(buildData)
  LoggerUseOldApi()
end

function LWOpeningStageDirtyWorks:TryOnBuildUpgradeFinish(buildPointId)
  LoggerUseOldApi()
end

function LWOpeningStageDirtyWorks:CheckShowStage4Finger(targetPointId)
  LoggerUseOldApi()
end

function LWOpeningStageDirtyWorks:CheckShowStage5Finger(targetPointId)
  LoggerUseOldApi()
end

function LWOpeningStageDirtyWorks:AbsorbStars(count, buildingId, pointId)
  LoggerUseOldApi()
end

function LWOpeningStageDirtyWorks:KeepAbsorbStars()
  LoggerUseOldApi()
end

function LWOpeningStageDirtyWorks.OnTimelineLoaded(params)
end

function LWOpeningStageDirtyWorks.PlayAirTimelineBubbles(flowId)
end

return LWOpeningStageDirtyWorks
