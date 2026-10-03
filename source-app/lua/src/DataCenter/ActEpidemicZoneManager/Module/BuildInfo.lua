local _CLASS = {}

function _CLASS:GetBuildData(pointId)
  local data = {}
  local ebTemplateMgr = DataCenter.EpidemicBuildTemplateMgr
  data.resId = ebTemplateMgr:GetGatherResourceType()
  data.pointId = pointId
  local info = CS.SceneManager.World:GetPointInfo(pointId)
  local detail = info ~= nil and info.detail or nil
  if detail ~= nil then
    data.uuid = detail.Uuid
    data.buildId = detail.BuildId
    data.openTime = detail.OpenTime
    data.role = detail.Role
    data.state = detail.State
    data.score = detail.Score
    data.buffId = detail.BuffId
    data.buffEndTime = detail.BuffEndTime
    data.marchUUID = detail.MarchUUID
    data.gatherUUID = detail.MarchUid
    local template = ebTemplateMgr:GetTemplate(data.buildId)
    data.template = template
    data.name = template ~= nil and template.name or ""
    data.shareName = template ~= nil and template.name or ""
    if ebTemplateMgr:IsRes(data.buildId) then
      data.id = ebTemplateMgr:GetGatherResourceId()
      local resTemplate = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(data.resId)
      if resTemplate ~= nil then
        data.icon = resTemplate:GetIconPath()
      end
      if data.marchUUID ~= 0 then
        local marchInfo = CS.SceneManager.World:GetMarch(data.marchUUID)
        if marchInfo ~= nil then
          data.gatherMarchUuid = data.marchUUID
          data.formationUuid = marchInfo.ownerFormationUuid
          data.ownerUid = marchInfo.ownerUid
          local ownerName = UIUtil.FormatAllianceAndName(marchInfo.allianceAbbr, marchInfo.ownerName, marchInfo.ownerUid)
          data.resourceName = CS.GameEntry.Localization:GetString("104291", ownerName)
          data.shareName = data.name
          data.isSelf = 1
          data.plunderRes = 0
          if marchInfo.plunderRes then
            local num = 0
            local stringNum = string.split(marchInfo.plunderRes, ";")
            table.walk(stringNum, function(k, v)
              local pos = string.find(v, ",")
              if pos ~= nil then
                num = tonumber(string.sub(v, pos + 1, -1)) + num
              end
            end)
            data.plunderRes = num
          end
          data.armyWeight = marchInfo.armyWeight - data.plunderRes
          data.collectSpd = marchInfo.collectSpd
          data.startTime = marchInfo.startTime
          data.endTime = marchInfo.endTime
          local gathering = template.gather_point_per_second
          data.collectAddition = math.floor(3600 * (marchInfo.collectSpd - gathering))
          data.baseCollectSpd = math.floor(3600 * gathering) .. "/h"
        end
        data.pointId = pointId
      end
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
    if DataCenter.ActEpidemicZoneManager:IsSelfCommander() then
      table.insert(btnList, WorldPointBtnType.BFCommandOrder)
    end
    if DataCenter.EpidemicBuildTemplateMgr:IsScoreBox(pointData.buildId) then
      table.insert(btnList, WorldPointBtnType.PickEpidemic)
    else
      local bRes = DataCenter.EpidemicBuildTemplateMgr:IsRes(pointData.buildId)
      if bRes then
        if pointData.role == EpidemicZoneRole.Default then
          table.insert(btnList, WorldPointBtnType.CollectEpidemic)
        elseif pointData.gatherUUID == LuaEntry.Player:GetUid() then
          table.insert(btnList, WorldPointBtnType.CallBack)
          table.insert(btnList, WorldPointBtnType.Detail)
        elseif BattleFieldUtil.IsBattleFieldEnemy(pointData.role, BattleFieldType.EpidemicZone) then
          table.insert(btnList, WorldPointBtnType.ScoutEpidemic)
          table.insert(btnList, WorldPointBtnType.AttackEpidemic)
        end
      else
        local hasOpen = true
        if state == 0 then
          local curTime = UITimeManager:GetInstance():GetServerTime()
          hasOpen = curTime >= pointData.openTime
        end
        if hasOpen then
          local bEnemy = BattleFieldUtil.IsBattleFieldEnemy(pointData.role, BattleFieldType.EpidemicZone)
          if bEnemy then
            table.insert(btnList, WorldPointBtnType.ScoutEpidemic)
            if not bRes then
              table.insert(btnList, WorldPointBtnType.RallyEpidemic)
            end
            table.insert(btnList, WorldPointBtnType.AttackEpidemic)
          elseif self:CanMultiAssistance() then
            local assistanceCount = CS.SceneManager.World:GetMyAssistanceCount(pointData.pointId)
            if 0 < assistanceCount then
              table.insert(btnList, WorldPointBtnType.CallBack)
            end
            table.insert(btnList, WorldPointBtnType.AssistanceEpidemic)
          else
            UIUtil.InsertAssistanceCityBtn(btnList, pointData.pointId, WorldPointBtnType.AssistanceEpidemic)
          end
        end
      end
    end
  end
end

function _CLASS:BuildOpenCheck(pointData)
  if pointData == nil then
    return false
  end
  return self:BuildOpenCheckWithTime(pointData.openTime)
end

function _CLASS:HandleBuildingHpChange(msg)
  self.battleInfo:ParseBuildInfo(msg)
  local world = CS.SceneManager.World
  local pointInfo = world ~= nil and world:GetPointInfoByUuid(msg.buildUUID) or nil
  if pointInfo ~= nil then
    local pointIndex = pointInfo.pointIndex
    EventManager:GetInstance():Broadcast(EventId.EpidemicBattleBuildHpChange, pointIndex)
    local damage = msg.damage or 0
    if 0 < damage then
      EventManager:GetInstance():Broadcast(EventId.EpidemicBattleDamagePush, {
        pointIndex = pointIndex,
        damage = -damage
      })
    end
  end
end

function _CLASS:CanMultiAssistance()
  return self:GetCurRole() == EpidemicZoneRole.Lord and BattleFieldUtil.CanMultiAssistance(BattleFieldType.EpidemicZone)
end

function _CLASS:GetBuildBestMarch(buildUUID)
  local topInfo = self:GetBuildInfo(buildUUID)
  local marchUuid = topInfo ~= nil and topInfo.marchUUID or nil
  local bestMarch = marchUuid ~= nil and DataCenter.WorldMarchDataManager:GetMarch(marchUuid) or nil
  return bestMarch, topInfo
end

function _CLASS:GetAttackInfo(pointId, role)
  local groupInfo = self:GetCurGroup()
  local alUIDs = {}
  for _, v in ipairs(groupInfo.roles) do
    if v.role == role then
      table.insert(alUIDs, v.allianceId)
    end
  end
  return self:BaseGetAttackInfo(pointId, alUIDs)
end

return _CLASS
