local _CLASS = {}

function _CLASS:GetBuildData(pointId)
  local data = {}
  data.pointId = pointId
  data.serverId = LuaEntry.Player:GetCurServerId()
  data.cType = 0
  data.baseSide = 0
  data.size = 1
  data.effectList = {}
  data.name = ""
  data.shareName = ""
  data.iconPath = ""
  data.uuid = 0
  data.buildId = 0
  data.closeTime = 0
  data.openTime = 0
  data.occupyingStartTime = 0
  data.side = 0
  data.eventStartTime = 0
  data.eventFinishTime = 0
  data.findAimTime = 0
  data.aimDeadTime = 0
  data.targetEnemyUUID = nil
  data.state = 0
  data.ownerUid = ""
  local info = CS.SceneManager.World:GetPointInfo(pointId)
  if info ~= nil then
    data.targetEnemyUUID = info.targetEnemyUUID
    local detailInfo = info.detail
    if detailInfo then
      data.uuid = detailInfo.Uuid
      local buildId = detailInfo.BuildId
      data.buildId = buildId
      local template = DataCenter.WinterStormTemplateManager:GetTemplate(buildId)
      if template ~= nil then
        data.cType = template.type
        data.size = template.size
        data.effectList = template.effectList
        data.name = template.name
        data.shareName = template.name
        data.iconPath = template:GetIconPath()
      end
      data.template = template
      data.openTime = detailInfo.OpenTime
      data.state = detailInfo.State
      data.score = detailInfo.Score or 0
      data.overflowScore = detailInfo.OverflowScore or 0
      data.closeTime = detailInfo.CloseTime
      data.startTime = detailInfo.StartTime
      data.occupyingStartTime = detailInfo.OccupyingStartTime
      data.side = detailInfo.Side
      data.eventStartTime = detailInfo.EventStartTime
      data.eventFinishTime = detailInfo.EventFinishTime
      data.findAimTime = detailInfo.FindAimTime
      data.aimDeadTime = detailInfo.aimDeadTime
      data.ownerUid = detailInfo.OwnerUid
    end
  end
  return data
end

function _CLASS:FillBuildBtnList(pointData, btnList)
  if not pointData or not btnList then
    return
  end
  local mySide = self:GetMySide()
  local bSelf = mySide == pointData.side
  local template = DataCenter.WinterStormTemplateManager:GetTemplate(pointData.buildId)
  local bScore = false
  if template ~= nil and template:IsScoreBox() then
    bScore = true
  end
  if bScore then
    table.insert(btnList, WorldPointBtnType.StealWinterEntity)
  else
    table.insert(btnList, WorldPointBtnType.BFCommandOrder)
    if not bSelf then
      table.insert(btnList, WorldPointBtnType.ScoutWinterEntity)
      table.insert(btnList, WorldPointBtnType.AttackWinterEntity)
    else
      local assistanceCount = CS.SceneManager.World:GetMyAssistanceCount(pointData.pointId)
      if BattleFieldUtil.CanMultiAssistance(BattleFieldType.WinterStorm) then
        if 0 < assistanceCount then
          table.insert(btnList, WorldPointBtnType.CallBack)
        end
        table.insert(btnList, WorldPointBtnType.AssistanceWinterEntity)
      elseif assistanceCount == 0 then
        table.insert(btnList, WorldPointBtnType.AssistanceWinterEntity)
      elseif assistanceCount == 1 then
        table.insert(btnList, WorldPointBtnType.CallBack)
      else
        table.insert(btnList, WorldPointBtnType.AssistanceWinterEntity)
      end
    end
  end
end

function _CLASS:BuildOpenCheck(pointData)
  if pointData.state == WinterEntityState.Fixing then
    UIUtil.ShowTipsId(458279)
    return false
  end
  return DataCenter.ActWinterStormManager:BattleOpenCheck(true)
end

function _CLASS:HandleBuildingHpChange(msg)
  if msg == nil then
    return
  end
  local buildUUID = msg.buildUUID
  local info = self:GetBuildBestMarch(buildUUID)
  if info == nil then
    info = {}
    info.buildUUID = buildUUID
  end
  info.uid = msg.uid
  info.currentHp = msg.currentHp
  info.totalHp = msg.totalHp
  local buildScore = msg.buildingScore
  if buildScore then
    info.buildScore = buildScore
  end
  if self.buildPlayerInfos == nil then
    self.buildPlayerInfos = {}
  end
  self.buildPlayerInfos[buildUUID] = info
  local world = CS.SceneManager.World
  local pointInfo = world ~= nil and world:GetPointInfoByUuid(buildUUID) or nil
  if pointInfo ~= nil then
    local pointIndex = pointInfo.pointIndex
    info.pointIndex = pointIndex
    EventManager:GetInstance():Broadcast(EventId.WinterStormBuildHpChange, pointIndex)
    EventManager:GetInstance():Broadcast(EventId.WinterStormEntityUpdate, pointIndex)
    local damage = msg.damage or 0
    if 0 < damage then
      EventManager:GetInstance():Broadcast(EventId.WinterStormDamagePush, {
        pointIndex = pointIndex,
        damage = -damage
      })
    end
  end
end

function _CLASS:GetBuildBestMarch(buildUUID)
  return self.buildPlayerInfos ~= nil and self.buildPlayerInfos[buildUUID] or nil
end

return _CLASS
