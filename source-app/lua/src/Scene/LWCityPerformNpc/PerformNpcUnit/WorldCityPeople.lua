local WorldCityPeople = BaseClass("WorldCityPeople")
local bubbleAnchor = Vector3.New(0, 3, 0)

function WorldCityPeople:__delete()
  self:RemovePlot()
  if not IsNull(self.modelTrigger) then
    self.modelTrigger.onPointerClick = nil
  end
  self.gameObject = nil
  self.transform = nil
end

function WorldCityPeople:OnCreate(obj, realIndex)
  if IsNull(obj) then
    return
  end
  self.realIndex = realIndex
  self.gameObject = obj
  self.transform = obj.transform
  self.modelTrigger = self.gameObject:GetComponent(typeof(CS.TouchObjectEventTrigger))
  if self.modelTrigger then
    function self.modelTrigger.onPointerClick()
      self:OnTriggerClick()
    end
  end
end

function WorldCityPeople:OnTriggerClick()
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.CitySoldierClick, false)
  self:RemovePlot()
  local plot = DataCenter.LWCityPerformNpcManager:GetRandomPlot()
  if 0 < plot then
    local bubbleParams = {}
    bubbleParams.plotId = plot
    bubbleParams.anchor = bubbleAnchor
    bubbleParams.mode = "3DFollow"
    bubbleParams.followTarget = self.transform
    self.curPlotId = plot
    EventManager:GetInstance():Broadcast(EventId.PlayPlotBubbleOnlyId, bubbleParams)
  end
  local anim = DataCenter.LWCityPerformNpcManager:GetRandomAnim()
  local animLenght = CS.SceneManager.World:PausePeopleAndPlayAnim(self.realIndex, anim)
  if 0 < animLenght then
    if self.pauseTimer then
      self.pauseTimer.delay = animLenght
      self.pauseTimer:Reset()
    else
      self.pauseTimer = TimerManager:GetInstance():DelayInvoke(function()
        self:OnAnimEnd()
      end, self.animLenght)
    end
  end
end

function WorldCityPeople:OnHide()
  self:RemovePlot()
end

function WorldCityPeople:RemovePlot()
  local cur = self.curPlotId or 0
  if 0 < cur then
    EventManager:GetInstance():Broadcast(EventId.RemovePlotBubbleById, cur)
    self.curPlotId = 0
  end
end

function WorldCityPeople:OnAnimEnd()
  self:RemovePauseTimer()
  CS.SceneManager.World:ResumePeople(self.realIndex)
end

function WorldCityPeople:RemovePauseTimer()
  if self.pauseTimer then
    self.pauseTimer:Stop()
    self.pauseTimer = nil
  end
end

return WorldCityPeople
