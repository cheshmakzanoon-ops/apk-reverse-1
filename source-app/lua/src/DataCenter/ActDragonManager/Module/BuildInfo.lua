local _CLASS = {}

function _CLASS:GetBuildData(pointId)
  local data = {}
  data.resId = ResourceType.DragonItem
  data.allianceId = ""
  data.buildId = 0
  data.size = 1
  data.pointId = pointId
  data.uuid = ""
  data.ownerUid = ""
  data.serverId = LuaEntry.Player:GetCurServerId()
  data.startTime = 0
  data.protectTime = 0
  data.occupyTime = 0
  data.openTime = 0
  data.state = 0
  data.rewardCount = 0
  data.alliancePoint = 0
  data.abbr = ""
  data.iconPath = ""
  data.effectList = {}
  local info = CS.SceneManager.World:GetPointInfo(pointId)
  if info ~= nil then
    local detailInfo = info.detail
    if detailInfo then
      data.uuid = detailInfo.Uuid
      local buildId = detailInfo.BuildId or detailInfo.ItemId
      data.buildId = buildId
      data.allianceId = detailInfo.AllianceId
      data.abbr = detailInfo.AlAbbr
      local template = DataCenter.DragonBuildTemplateManager:GetTemplate(buildId)
      if template then
        data.size = template.size
        data.effectList = template.effectList
        data.name = template.name
        data.shareName = template.name
        data.iconPath = template:GetIconPath()
      end
      data.startTime = detailInfo.StartTime
      data.openTime = detailInfo.OpenTime
      data.protectTime = detailInfo.ProtectTime
      data.occupyTime = detailInfo.OccupyTime
      data.state = detailInfo.State
      data.rewardCount = detailInfo.RewardCount
      data.score = detailInfo.Score or 0
      data.overflowScore = detailInfo.OverflowScore or 0
    end
  end
  return data
end

function _CLASS:FillBuildBtnList(pointData, btnList)
  if not pointData or not btnList then
    return
  end
  if not BattleFieldUtil.isObserve then
    local state = pointData.state
    if 10110 == pointData.buildId then
      table.insert(btnList, WorldPointBtnType.PickDragonBuild)
    else
      if self:IsSelfCommander() then
        table.insert(btnList, WorldPointBtnType.DragonCommandOrder)
      end
      table.insert(btnList, WorldPointBtnType.StatusDragonBuild)
      local hasOpen = true
      if state == 0 then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        hasOpen = curTime >= pointData.openTime
      end
      if pointData.allianceId ~= "" and pointData.allianceId == LuaEntry.Player.allianceId then
        if hasOpen then
          UIUtil.InsertAssistanceCityBtn(btnList, pointData.pointId, WorldPointBtnType.AssistanceDragonBuild)
        end
      elseif hasOpen then
        table.insert(btnList, WorldPointBtnType.ScoutDragonBuild)
        table.insert(btnList, WorldPointBtnType.RallyDragonBuild)
        table.insert(btnList, WorldPointBtnType.AttackDragonBuild)
      end
    end
  end
end

function _CLASS:BuildOpenCheck(pointData)
  if 10110 == pointData.buildId then
    return true
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime < pointData.openTime then
    UIUtil.ShowTipsId(458279)
    return false
  end
  local flag = self:InDragonBattleTime()
  if not flag then
    UIUtil.ShowTipsId(458279)
    return false
  end
  return true
end

function _CLASS:HandleBuildingHpChange(msg)
  local uuid = msg.uuid
  local march = msg.march
  if march then
    local info = self.buildTopMarch[uuid] or {}
    info.uuid = uuid
    info.hp = msg.hp
    info.maxHp = msg.maxHp
    info.march = march
    self.buildTopMarch[uuid] = info
  else
    self.buildTopMarch[uuid] = nil
  end
  EventManager:GetInstance():Broadcast(EventId.DragonBuildingTopChange, uuid)
end

function _CLASS:GetBuildBestMarch(buildUUID)
  local topInfo = self.buildTopMarch[buildUUID]
  local marchUuid = topInfo ~= nil and topInfo.march or nil
  local bestMarch = marchUuid ~= nil and DataCenter.WorldMarchDataManager:GetMarch(marchUuid) or nil
  return bestMarch, topInfo
end

function _CLASS:GetAttackInfo(pointId, allianceId)
  return self:BaseGetAttackInfo(pointId, allianceId)
end

return _CLASS
