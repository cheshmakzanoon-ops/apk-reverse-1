local RadarWorldScanScene = BaseClass("RadarWorldScanScene")
local CloseTime = 4.1

function RadarWorldScanScene:OnCreate(go)
  if go ~= nil then
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:ComponentDefine()
  self:DataDefine()
end

function RadarWorldScanScene:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
end

function RadarWorldScanScene:ComponentDefine()
end

function RadarWorldScanScene:ComponentDestroy()
  self.gameObject = nil
  self.transform = nil
end

function RadarWorldScanScene:DataDefine()
  self.param = nil
  self.timer = nil
  
  function self.timer_action(temp)
    self:TimeCallBack()
  end
end

function RadarWorldScanScene:DataDestroy()
  self.param = nil
  self:DeleteTimer()
end

function RadarWorldScanScene:ReInit(param)
  self.param = param
  self.transform.position = self.param.pos
  self:AddTimer()
end

function RadarWorldScanScene:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function RadarWorldScanScene:AddTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(CloseTime, self.timer_action, self, true, false, false)
  end
  self.timer:Start()
end

function RadarWorldScanScene:TimeCallBack()
  self:DeleteTimer()
  DataCenter.GuideCityAnimManager:RemoveRadarWorldScanScene()
end

return RadarWorldScanScene
