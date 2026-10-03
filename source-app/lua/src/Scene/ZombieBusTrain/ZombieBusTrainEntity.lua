local ZombieBusTrainEntity = BaseClass("ZombieBusTrainEntity")

function ZombieBusTrainEntity:__init(marchInfo, busList, transform)
  self.marchInfo = marchInfo
  self.uuid = self.marchInfo and self.marchInfo.uuid or 0
  self.transform = transform
  self.busList = busList
  self:InitAppearance(transform)
end

function ZombieBusTrainEntity:__delete()
  self:ClearStyleTimer()
  if self.appearance then
    self.appearance:Delete()
    self.appearance = nil
  end
  self.busList = nil
  self.marchInfo = nil
  self.uuid = nil
end

function ZombieBusTrainEntity:InitAppearance(transform)
  if self.appearance then
    self.appearance:Delete()
    self.appearance = nil
  end
  local appearanceLogic = require("Scene.ZombieBusTrain.ZombieBusTrainAppearanceNormal")
  if appearanceLogic then
    self.appearance = appearanceLogic.New(self, transform)
    self:RestDoStyleTimer()
  end
end

function ZombieBusTrainEntity:Refresh(marchInfo, busList)
  self.marchInfo = marchInfo
  self.uuid = self.marchInfo and self.marchInfo.uuid or 0
  self.busList = busList
  if self.appearance then
    self.appearance:RefreshView()
    self:RestDoStyleTimer()
  end
end

function ZombieBusTrainEntity:ClearStyleTimer()
  if self.doStyleTimer then
    self.doStyleTimer:Stop()
    self.doStyleTimer = nil
  end
end

function ZombieBusTrainEntity:RestDoStyleTimer()
  self:ClearStyleTimer()
  if not self.appearance then
    return
  end
  local nextTimeToStyle = math.random(10, 20)
  self.doStyleTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:PlayHeadStyleAnim()
    self:RestDoStyleTimer()
  end, nextTimeToStyle)
end

function ZombieBusTrainEntity:PlayAnim(animName)
  if self.appearance then
    self.appearance:PlayAnim(animName)
  end
end

function ZombieBusTrainEntity:PlayHeadStyleAnim()
  if self.appearance then
    self.appearance:PlayHeadStyleAnim()
  end
end

function ZombieBusTrainEntity:DoDelayDead()
  if self.appearance then
    return self.appearance:DoDelayDead()
  end
  return 0
end

return ZombieBusTrainEntity
