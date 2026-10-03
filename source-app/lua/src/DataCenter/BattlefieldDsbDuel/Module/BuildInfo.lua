local _CLASS = {}

function _CLASS:GetBuildData(pointId)
  local battleInfo = BattlefieldDsbDuelUtils.BattleInfo
  if battleInfo then
    return battleInfo:GetBuildData(pointId)
  end
  return nil
end

function _CLASS:FillBuildBtnList(pointData, btnList)
  local battleInfo = BattlefieldDsbDuelUtils.BattleInfo
  if battleInfo then
    return battleInfo:FillBuildBtnList(pointData, btnList)
  end
end

function _CLASS:BuildOpenCheck(pointData)
  local battleInfo = BattlefieldDsbDuelUtils.BattleInfo
  if battleInfo then
    return battleInfo:BuildOpenCheck(pointData)
  end
end

function _CLASS:HandleBuildingHpChange(msg)
  local battleInfo = BattlefieldDsbDuelUtils.BattleInfo
  if battleInfo then
    battleInfo:UpdateFromBuildingHpChangeMsg(msg)
  end
end

function _CLASS:GetBuildBestMarch(buildUUID)
  local battleInfo = BattlefieldDsbDuelUtils.BattleInfo
  if not battleInfo then
    return
  end
  local topInfo = battleInfo:GetBuilding(buildUUID)
  local marchUuid = topInfo ~= nil and topInfo.marchUUID or nil
  local bestMarch = marchUuid ~= nil and DataCenter.WorldMarchDataManager:GetMarch(marchUuid) or nil
  return bestMarch, topInfo
end

function _CLASS:GetAttackInfo(pointId, allianceId)
  return self:BaseGetAttackInfo(pointId, allianceId)
end

return _CLASS
