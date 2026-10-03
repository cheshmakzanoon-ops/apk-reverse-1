local BattleTimelineEnum = {}
BattleTimelineEnum.ClipState = {
  None = 0,
  NotStart = 1,
  Running = 2,
  Finished = 3
}
BattleTimelineEnum.BattleTimelineClipType = {
  Base = 1,
  PlayAnimation = 2,
  CrossFadeAnimation = 3,
  Move = 4,
  RewindAndPlayAnimation = 5,
  RotateToTarget = 6,
  RotateToTargetPos = 7,
  RotateToTargetAndCast = 8,
  RotateToAngle = 9
}
BattleTimelineEnum.BattleTimelineClipCls = {
  [BattleTimelineEnum.BattleTimelineClipType.Base] = "Scene.LWBattle.Skirmish.BattleTimeline.TimelineClips.BattleTimelineClip",
  [BattleTimelineEnum.BattleTimelineClipType.PlayAnimation] = "Scene.LWBattle.Skirmish.BattleTimeline.TimelineClips.PlayAnimationClip",
  [BattleTimelineEnum.BattleTimelineClipType.CrossFadeAnimation] = "Scene.LWBattle.Skirmish.BattleTimeline.TimelineClips.CrossFadeAnimationClip",
  [BattleTimelineEnum.BattleTimelineClipType.Move] = "Scene.LWBattle.Skirmish.BattleTimeline.TimelineClips.PositionDoTweenTimelineClip",
  [BattleTimelineEnum.BattleTimelineClipType.RewindAndPlayAnimation] = "Scene.LWBattle.Skirmish.BattleTimeline.TimelineClips.RewindPlayAnimationClip",
  [BattleTimelineEnum.BattleTimelineClipType.RotateToTarget] = "Scene.LWBattle.Skirmish.BattleTimeline.TimelineClips.RotateToTargetClip",
  [BattleTimelineEnum.BattleTimelineClipType.RotateToTargetPos] = "Scene.LWBattle.Skirmish.BattleTimeline.TimelineClips.RotateToTargetPosClip",
  [BattleTimelineEnum.BattleTimelineClipType.RotateToTargetAndCast] = "Scene.LWBattle.Skirmish.BattleTimeline.TimelineClips.RotateToTargetAndCastClip",
  [BattleTimelineEnum.BattleTimelineClipType.RotateToAngle] = "Scene.LWBattle.Skirmish.BattleTimeline.TimelineClips.RotateToAngleClip"
}
BattleTimelineEnum.BattleTimelineTrackType = {
  Animation = 1,
  Move = 2,
  Rotate = 3
}
BattleTimelineEnum.BattleTimelineTrackState = {
  Waiting = 1,
  Running = 2,
  Finished = 3
}
BattleTimelineEnum.ClipToTrackType = {
  [BattleTimelineEnum.BattleTimelineClipType.PlayAnimation] = BattleTimelineEnum.BattleTimelineTrackType.Animation,
  [BattleTimelineEnum.BattleTimelineClipType.CrossFadeAnimation] = BattleTimelineEnum.BattleTimelineTrackType.Animation,
  [BattleTimelineEnum.BattleTimelineClipType.Move] = BattleTimelineEnum.BattleTimelineTrackType.Move,
  [BattleTimelineEnum.BattleTimelineClipType.RewindAndPlayAnimation] = BattleTimelineEnum.BattleTimelineTrackType.Animation,
  [BattleTimelineEnum.BattleTimelineClipType.RotateToTarget] = BattleTimelineEnum.BattleTimelineTrackType.Rotate,
  [BattleTimelineEnum.BattleTimelineClipType.RotateToTargetPos] = BattleTimelineEnum.BattleTimelineTrackType.Rotate,
  [BattleTimelineEnum.BattleTimelineClipType.RotateToTargetAndCast] = BattleTimelineEnum.BattleTimelineTrackType.Rotate,
  [BattleTimelineEnum.BattleTimelineClipType.RotateToAngle] = BattleTimelineEnum.BattleTimelineTrackType.Rotate
}
return BattleTimelineEnum
