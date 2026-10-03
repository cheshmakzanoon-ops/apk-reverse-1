local Base = require("Scene.LWBattle.Skirmish.BattleTimeline.TimelineClips.BattleTimelineClip")
local RotateToAngleClip = BaseClassCache("RotateToAngleClip", Base)

function RotateToAngleClip:OnStart()
  self.unit = self.track:GetOwner()
  if IsNull(self.unit) then
    return
  end
  local para = self.clipInfo:GetPara()
  self.angle = para.angle
  local duration = self.clipInfo.m_clipDuration
  self.unit.transform:DOLocalRotate(self.angle, duration)
  Base.OnStart(self)
end

return RotateToAngleClip
