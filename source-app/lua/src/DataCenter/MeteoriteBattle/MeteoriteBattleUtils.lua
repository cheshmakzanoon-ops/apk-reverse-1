local MeteoriteBattleUtils = {}
MeteoriteBattleUtils.NoticeItemRenderLuaPath = "UI.UIMainMiniMap.Component.MainMiniMapMeteoriteNoticeItem"
MeteoriteBattleUtils.MetoriteNewsLuaPath = "UI.UIMainMiniMap.Component.MainMiniMapMeteoriteNewsItem"

function MeteoriteBattleUtils.IsInHighAreaServer(serverId, pointId)
  local mgr = DataCenter.ActMeteoriteBattleManager
  if not mgr then
    return false
  end
  local h, l = mgr:CheckServerPointIndexInActArea(serverId, pointId)
  return h
end

function MeteoriteBattleUtils.IsInHighArea(pointId)
  local mgr = DataCenter.ActMeteoriteBattleManager
  if not mgr then
    return false
  end
  local h, l = mgr:CheckPointIndexInActArea(pointId)
  return h
end

function MeteoriteBattleUtils.CheckChangeServerIsForMeteoriteBattle(serverId)
  if not serverId then
    return false
  end
  local mgr = DataCenter.ActMeteoriteBattleManager
  if not mgr then
    return false
  end
  local actInfo = mgr:GetActInfo()
  local stageId = actInfo and actInfo.stage or -1
  if stageId == MeteoriteState.PREVIEW or stageId == MeteoriteState.GRAB or stageId == MeteoriteState.REST then
    return mgr:IsInMeteoriteBattleServerGroup() and mgr:CheckServerInGroup(serverId)
  else
    return false
  end
end

function MeteoriteBattleUtils.GetCurrentStage()
  local mgr = DataCenter.ActMeteoriteBattleManager
  if not mgr then
    return -1
  end
  local actInfo = mgr:GetActInfo()
  local stageId = actInfo and actInfo.stage or -1
  return stageId
end

function MeteoriteBattleUtils.IsInBattleState()
  local mgr = DataCenter.ActMeteoriteBattleManager
  if not mgr then
    return false
  end
  local actInfo = mgr:GetActInfo()
  local stageId = actInfo and actInfo.stage or -1
  if stageId ~= MeteoriteState.GRAB then
    return false
  end
  local battleInfo = mgr:GetBattleWorldInfo()
  if not battleInfo then
    return false
  end
  return battleInfo.serverId == LuaEntry.Player:GetCurServerId()
end

local _t

function MeteoriteBattleUtils.GetFreeMoveCdTime()
  if not MeteoriteBattleUtils.IsInBattleState() then
    return -1
  end
  return DataCenter.ActMeteoriteBattleManager:GetMoveCityFreeTime()
end

function MeteoriteBattleUtils.IsInPreviewState()
  local mgr = DataCenter.ActMeteoriteBattleManager
  if not mgr then
    return false
  end
  local actInfo = mgr:GetActInfo()
  local stageId = actInfo and actInfo.stage or -1
  return stageId == MeteoriteState.PREVIEW
end

function MeteoriteBattleUtils.IsInRestState()
  local mgr = DataCenter.ActMeteoriteBattleManager
  if not mgr then
    return false
  end
  local actInfo = mgr:GetActInfo()
  local stageId = actInfo and actInfo.stage or -1
  return stageId == MeteoriteState.REST
end

function MeteoriteBattleUtils.Log(format, ...)
  if not CommonUtil.IsDebug() then
    return
  end
  local msg = string.format(format, ...)
  local t = string.format("[meteorite]%s", msg)
  Logger.Log(t)
end

return ConstClass("MeteoriteBattleUtils", MeteoriteBattleUtils)
