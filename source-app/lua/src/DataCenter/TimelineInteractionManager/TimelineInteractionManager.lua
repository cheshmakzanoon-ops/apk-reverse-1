local TimelineInteractionManager = BaseClass("TimelineInteractionManager", CEventable)

function TimelineInteractionManager:__init()
  self:RegisterEvent(EventId.GF_plot_group_done, self.OnPlotDone)
  self:RegisterEvent(EventId.PlotViewClosedAbnormally, self.OnPlotDone)
  self.curPlotId = nil
end

function TimelineInteractionManager:OnEnterGame()
  local timelineExtOpen = LuaEntry.DataConfig:CheckSwitch("timeline_ext")
  CS.CSUtils.SetTimelineExtOpen(timelineExtOpen)
end

function TimelineInteractionManager:TryTimelineInteractionShowQTE1(duration)
  local isOpen = UIManager.Instance:IsWindowOpen(UIWindowNames.LWUITimelineQTE)
  if isOpen then
    return false
  end
  if self.curPlotId then
    return false
  end
  self.showQte1 = true
  UIManager.Instance:OpenWindow(UIWindowNames.LWUITimelineQTE, {anim = true}, {qte1 = true, duration = duration})
  self:AddTimer()
  return true
end

function TimelineInteractionManager:TimelineInteractionCloseQTE1()
  self.showQte1 = nil
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUITimelineQTE)
  self:RemoveTimer()
end

function TimelineInteractionManager:OnQTE1Done()
  if self.showQte1 then
    self.showQte1 = nil
    self:RemoveTimer()
    CS.CSUtils.OnTimelineInteractionQTE1Done()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUITimelineQTE)
  end
end

function TimelineInteractionManager:TryTimelineInteractionShowPlot(plotId)
  local plotPlaying = DataCenter.LWPlotManager:IsPlotPlaying()
  if plotPlaying then
    return false
  end
  if self.curPlotId then
    return false
  end
  if self.showQte1 then
    return false
  end
  local isOpen = UIManager.Instance:IsWindowOpen(UIWindowNames.LWUITimelinePlotBridge)
  if isOpen then
    return false
  end
  self.curPlotId = plotId
  EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {plotGroupId = plotId, hideMainUI = false})
  UIManager.Instance:OpenWindow(UIWindowNames.LWUITimelinePlotBridge, {anim = true}, {plotId = plotId})
  self.waitPlotBridgeTimer = 3
  self:AddTimer()
  return true
end

function TimelineInteractionManager:TimelineInteractionClosePlot()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUITimelinePlotBridge)
  self.waitPlotBridgeTimer = nil
  self.curPlotId = nil
end

function TimelineInteractionManager:AddTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.OnTimer, self, false, false, true)
    self.timer:Start()
  end
end

function TimelineInteractionManager:OnTimer()
  if self.curPlotId then
    local plotPlaying = DataCenter.LWPlotManager:IsPlotPlaying(self.curPlotId)
    if not plotPlaying then
      EventManager:GetInstance():Broadcast(EventId.PlotGroupDone, self.curPlotId)
      return
    end
    local isOpen = UIManager.Instance:IsWindowOpen(UIWindowNames.LWUITimelinePlotBridge)
    if not isOpen then
      EventManager:GetInstance():Broadcast(EventId.PlotGroupDone, self.curPlotId)
      return
    end
    self.waitPlotBridgeTimer = self.waitPlotBridgeTimer - 1
    if self.waitPlotBridgeTimer < -20 then
      EventManager:GetInstance():Broadcast(EventId.PlotGroupDone, self.curPlotId)
      return
    end
    if self.waitPlotBridgeTimer < 0 then
      local window = UIManager.Instance:GetWindow(UIWindowNames.LWUITimelinePlotBridge)
      if window == nil then
        EventManager:GetInstance():Broadcast(EventId.PlotGroupDone, self.curPlotId)
        return
      end
      local view = window.View
      if view == nil then
        EventManager:GetInstance():Broadcast(EventId.PlotGroupDone, self.curPlotId)
        return
      end
      if IsNull(view.gameObject) then
        EventManager:GetInstance():Broadcast(EventId.PlotGroupDone, self.curPlotId)
        return
      end
      if view.timelinePlotId == nil or view.timelinePlotId ~= self.curPlotId then
        EventManager:GetInstance():Broadcast(EventId.PlotGroupDone, self.curPlotId)
        return
      end
    end
  elseif self.showQte1 then
    local isOpen = UIManager.Instance:IsWindowOpen(UIWindowNames.LWUITimelineQTE)
    if not isOpen then
      self:OnQTE1Done()
    end
  else
    self:RemoveTimer()
  end
end

function TimelineInteractionManager:RemoveTimer()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

function TimelineInteractionManager:OnPlotDone(plotId)
  if plotId == self.curPlotId then
    self.curPlotId = nil
    self:RemoveTimer()
    self.waitPlotBridgeTimer = nil
    UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUITimelinePlotBridge)
    CS.CSUtils.OnTimelineInteractionPlotDone(plotId)
  end
end

function TimelineInteractionManager:__delete()
  self:RemoveTimer()
  self:TimelineInteractionCloseQTE1()
  self:TimelineInteractionClosePlot()
end

return TimelineInteractionManager
