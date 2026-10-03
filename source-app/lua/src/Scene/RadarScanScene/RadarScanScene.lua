local RadarScanScene = BaseClass("RadarScanScene")
local AnimName = "Default"

function RadarScanScene:OnCreate(go)
  if go ~= nil then
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:ComponentDefine()
  self:DataDefine()
end

function RadarScanScene:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
end

function RadarScanScene:ComponentDefine()
  self.anim = self.transform:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
end

function RadarScanScene:ComponentDestroy()
  self.anim = nil
  self.gameObject = nil
  self.transform = nil
end

function RadarScanScene:DataDefine()
  self.param = nil
  self.timer = nil
  
  function self.timer_action(temp)
    self:TimeCallBack()
  end
end

function RadarScanScene:DataDestroy()
  self.param = nil
  self:DeleteTimer()
end

function RadarScanScene:ReInit(param)
  self.param = param
  self.transform.position = self.param.pos
  local time = self.anim:GetClipLength(AnimName)
  if time ~= nil and 0 < time then
    self:AddTimer(time)
  else
    self:TimeCallBack()
  end
end

function RadarScanScene:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function RadarScanScene:AddTimer(time)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(time, self.timer_action, self, true, false, false)
  end
  self.timer:Start()
end

function RadarScanScene:TimeCallBack()
  self:DeleteTimer()
  DataCenter.GuideCityAnimManager:RemoveRadarScanScene()
end

return RadarScanScene
