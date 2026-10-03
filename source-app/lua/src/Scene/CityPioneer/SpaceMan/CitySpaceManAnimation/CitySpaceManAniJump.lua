local base = require("Scene.CityPioneer.SpaceMan.CitySpaceManAnimation.CitySpaceManAniBase")
local CitySpaceManAniJump = BaseClass("CitySpaceManAniJump", base)
local WaitTime = 3

function CitySpaceManAniJump:__init(spaceman)
  base.__init(self, spaceman)
end

function CitySpaceManAniJump:OnEnter()
  base.OnEnter(self)
  self.timer = TimerManager:GetInstance():DelayInvoke(function()
    self.timer = nil
    self.m_citySpaceMan:LeaveJump()
  end, WaitTime)
end

function CitySpaceManAniJump:OnExit()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function CitySpaceManAniJump:OnUpdate()
end

return CitySpaceManAniJump
