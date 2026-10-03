local Base = require("Scene.LWBattle.Skirmish.BattleTimeline.TimelineClips.BattleTimelineClip")
local PlayAnimationClip = BaseClassCache("PlayAnimationClip", Base)

function PlayAnimationClip:OnStart()
  local unit = self.track:GetOwner()
  if not unit then
    return
  end
  local clipInfo = self.clipInfo
  local para = clipInfo:GetPara()
  local name = para.name
  local speed = para.speed
  unit:PlaySimpleAnim(name, speed)
  Base.OnStart(self)
end

return PlayAnimationClip
