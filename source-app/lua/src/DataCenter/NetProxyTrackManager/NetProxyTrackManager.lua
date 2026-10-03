local NetProxyTrackManager = BaseClass("NetProxyTrackManager")
local Network = CS.GameEntry.Network

function NetProxyTrackManager:__init()
  function self.timerAction()
    self:OnTimer()
  end
end

function NetProxyTrackManager:__delete()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  self.timerAction = nil
end

function NetProxyTrackManager:Startup()
end

function NetProxyTrackManager:OnTimer()
end

return NetProxyTrackManager
