local WorldMarchDataProxy = BaseClass("WorldMarchDataProxy")
local MarchDataMgr = CS.SceneManager.MarchDataMgr

function WorldMarchDataProxy:__init()
end

function WorldMarchDataProxy:__delete()
end

function WorldMarchDataProxy:WorldGetMarchInfos()
  MarchDataMgr:WorldGetMarchInfos()
end

function WorldMarchDataProxy:CleanDragonWar()
  MarchDataMgr:CleanDragonWar()
end

function WorldMarchDataProxy:GetMarchesTargetForMine(onlyDesertBattle)
  return MarchDataMgr:GetMarchesTargetForMine(onlyDesertBattle)
end

function WorldMarchDataProxy:GetMarchesTargetForMineLite()
  return MarchDataMgr:GetMarchesTargetForMineLite()
end

function WorldMarchDataProxy:GetInimicalMarchesTargetForMine()
  return MarchDataMgr:GetInimicalMarchesTargetForMine()
end

function WorldMarchDataProxy:CheckUuidIsMarchTarget(uuid, pointIndex)
  return MarchDataMgr:CheckIsOtherTarget(uuid, pointIndex)
end

function WorldMarchDataProxy:GetMarch(uuid)
  return MarchDataMgr:GetMarch(uuid)
end

function WorldMarchDataProxy:GetAllMarches()
  return MarchDataMgr:GetAllMarchesByCS()
end

function WorldMarchDataProxy:GetOwnerMarches(ownerUid, allianceUid)
  return MarchDataMgr:GetOwnerMarches(ownerUid, allianceUid)
end

function WorldMarchDataProxy:GetAllianceMarchesInTeam(allianceUid, teamUuid)
  return MarchDataMgr:GetAllianceMarchesInTeam(allianceUid, teamUuid)
end

function WorldMarchDataProxy:GetOwnerFormationMarch(ownerUid, formationUuid, allianceUid)
  if not formationUuid then
    return nil
  end
  return MarchDataMgr:GetOwnerFormationMarch(ownerUid, formationUuid, allianceUid)
end

function WorldMarchDataProxy:IsHaveMarchInWorld()
  return MarchDataMgr:IsHaveMarchInWorld()
end

function WorldMarchDataProxy:GetBestMarch(pointId, allianceId, worldId)
  return MarchDataMgr:GetBestMarch(pointId, allianceId, worldId)
end

function WorldMarchDataProxy:GetMarchByTargetPos(targetPos)
  return MarchDataMgr:GetMarchByTargetPos(targetPos)
end

function WorldMarchDataProxy:GetMarchCountToTargetGroupByOwnerUid(targetPos, uid)
  return MarchDataMgr:GetMarchCountToTargetGroupByOwnerUid(targetPos, uid)
end

function WorldMarchDataProxy:GetMyDisguiseMarches()
  return MarchDataMgr:GetMyDisguiseMarches()
end

function WorldMarchDataProxy:GetFirstMyAssistanceMarchUuid(pointId)
  return MarchDataMgr:GetFirstMyAssistanceMarchUuid(pointId)
end

function WorldMarchDataProxy:CacheAllianceMembersHomePos()
  return MarchDataMgr:CacheAllianceMembersHomePos()
end

function WorldMarchDataProxy:CleanAllianceMembersHomePos()
  return MarchDataMgr:CleanAllianceMembersHomePos()
end

function WorldMarchDataProxy:GetTargetMinAlarm(onlyDesertBattle)
  local dic = self:GetMarchesTargetForMine(onlyDesertBattle)
  local isOn = DataCenter.DefenceWallDataManager:GetScoutAlarmIsOn()
  local list = {}
  local beAssistedList = {}
  if not dic or table.csCount(dic) == 0 then
    return list
  end
  local mainWorldPos = LuaEntry.Player:GetMainWorldPos()
  for _, march in pairs(dic) do
    local target = march:GetMarchTargetType()
    if not AlarmType[target] or not isOn and (target == MarchTargetType.SCOUT_CITY or target == MarchTargetType.SCOUT_WINTER_STORM_CITY or target == MarchTargetType.SCOUT_EPIDEMIC_CITY) then
    elseif march.targetPos == mainWorldPos then
      if (target == MarchTargetType.ASSISTANCE_CITY or target == MarchTargetType.ASSISTANCE_WINTER_STORM_CITY or target == MarchTargetType.ASSISTANCE_EPIDEMIC_CITY) and march:GetMarchStatus() == MarchStatus.ASSISTANCE then
        table.insert(beAssistedList, march)
      else
        table.insert(list, march)
      end
    end
  end
  table.sort(list, function(a, b)
    if a.endTime < b.endTime then
      return true
    end
  end)
  for i, v in pairs(beAssistedList) do
    table.insert(list, v)
  end
  return list
end

return WorldMarchDataProxy
