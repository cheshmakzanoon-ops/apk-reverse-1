local ClipInfoUtils = {}
local BattleTimelineEnum = require("Scene.LWBattle.Skirmish.BattleTimeline.BattleTimelineEnum")
local BattleTimelineClipInfo = require("Scene.LWBattle.Skirmish.BattleTimeline.TimelineClipInfo.BattleTimelineClipInfo")
local BattleTimelineClipType = BattleTimelineEnum.BattleTimelineClipType

function ClipInfoUtils.SetClipInfoPara(clipInfo, ...)
  local arg = {
    ...
  }
  if clipInfo and 0 < #arg then
    local para = clipInfo:GetPara()
    local type = clipInfo.m_clipType
    if type == BattleTimelineClipType.PlayAnimation then
      para.name = arg[1] or ""
      para.speed = arg[2] or 1
      if arg[3] == nil then
        para.fallbackToIdle = true
      else
        para.fallbackToIdle = arg[3]
      end
    elseif type == BattleTimelineClipType.CrossFadeAnimation then
      para.name = arg[1] or ""
      para.speed = arg[2] or 1
      para.fadeTime = arg[3] or 0
      if arg[4] == nil then
        para.fallbackToIdle = true
      else
        para.fallbackToIdle = arg[4]
      end
    elseif type == BattleTimelineClipType.Move then
      para.isWorld = arg[1]
      para.target = arg[2]
    elseif type == BattleTimelineClipType.RewindAndPlayAnimation then
      para.name = arg[1] or ""
      para.speed = arg[2] or 1
      if arg[3] == nil then
        para.fallbackToIdle = true
      else
        para.fallbackToIdle = arg[3]
      end
    elseif type == BattleTimelineClipType.RotateToTarget then
      para.target = arg[1]
    elseif type == BattleTimelineClipType.RotateToTargetPos then
      para.target = arg[1]
    elseif type == BattleTimelineClipType.RotateToTargetAndCast then
      para.skill = arg[1]
      para.target = arg[2]
    elseif type == BattleTimelineClipType.RotateToAngle then
      para.angle = arg[1]
    end
  end
end

local objPoolIns = ObjectPool:GetInstance()

function ClipInfoUtils.GetClipInfo(type, duration, startOffset, infinite, priority, ...)
  local clipInfo = objPoolIns:Load(BattleTimelineClipInfo)
  clipInfo:Init(type, duration, startOffset, infinite, priority)
  ClipInfoUtils.SetClipInfoPara(clipInfo, ...)
  return clipInfo
end

return ClipInfoUtils
