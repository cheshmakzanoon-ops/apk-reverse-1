local Base = require("Scene.LWBattle.Skirmish.BattleTimeline.TimelineClips.BattleTimelineClip")
local RotateToTargetPosClip = BaseClassCache("RotateToTargetPosClip", Base)

function RotateToTargetPosClip:OnStart()
  self.unit = self.track:GetOwner()
  if IsNull(self.unit) then
    return
  end
  local para = self.clipInfo:GetPara()
  self.target = para.target
  local duration = self.clipInfo.m_clipDuration
  self.unit.transform:DOLookAt(self.target, duration)
  Base.OnStart(self)
end

return RotateToTargetPosClip
