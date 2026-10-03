local Base = require("Scene.LWBattle.Skirmish.BattleTimeline.TimelineClips.BattleTimelineClip")
local CrossFadeAnimationClip = BaseClassCache("CrossFadeAnimationClip", Base)

function CrossFadeAnimationClip:OnStart()
  local unit = self.track:GetOwner()
  if not unit then
    return
  end
  local clipInfo = self.clipInfo
  local para = clipInfo:GetPara()
  local name = para.name
  local speed = para.speed
  local fadeTime = para.fadeTime
  unit:CrossFadeSimpleAnim(name, speed, fadeTime)
  Base.OnStart(self)
end

return CrossFadeAnimationClip
