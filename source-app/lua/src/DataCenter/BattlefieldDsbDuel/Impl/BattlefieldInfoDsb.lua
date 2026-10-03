local BattlefieldInfoDsb = BaseClass("BattlefieldInfoDsb")
local LuaRole = require("DataCenter.BattlefieldDsbDuel.Impl.BattlefieldRoleDsb")
local LuaBuilding = require("DataCenter.BattlefieldDsbDuel.Impl.BattlefieldBuildingDsb")
local LuaResult = require("DataCenter.BattlefieldDsbDuel.Impl.BattlefieldRoleResultDsb")
local LuaSoldierData = require("DataCenter.BattlefieldDsbDuel.Impl.BattlefieldDsbSoldierData")

function BattlefieldInfoDsb:__init(battlefieldType)
  self.battlefieldType = battlefieldType
  self.info = nil
  self.buildings = nil
  self.players = nil
  self.roles = nil
  self.alliance2Role = nil
  self.myPlayer = nil
  self.rolesByRank = nil
  self.roles2Rank = nil
  self.gatherResourceId = nil
  self.allianceId2RoleId = nil
  self.roleId2AllianceId = nil
  self.selfPlayerInfo = nil
  self.battleResult = nil
  self.treatmentSoldierDic = nil
  self.accumulativeTreatmentSoldierNum = 0
  self.autoHealPool = 0
  self.timeStart = 0
  self.timeEnd = 0
  self.observer = nil
  self.effectList = nil
  self.buffList = nil
  self.totalEffectList = nil
  self.totalEffectDic = nil
  self.updateTimer = TimerManager:GetInstance():GetTimer(1, function()
    self:OnUpdateTime()
  end, self, false, false, false)
  self.updateTimer:Start()
end

function BattlefieldInfoDsb:__delete()
  self.rolesByRank = nil
  self.selfPlayerInfo = nil
  self.roles2Rank = nil
  self.gatherResourceId = nil
  self.allianceId2RoleId = nil
  self.roleId2AllianceId = nil
  self.battleResult = nil
  self.treatmentSoldierDic = nil
  self.accumulativeTreatmentSoldierNum = nil
  self.autoHealPool = nil
  self.observer = nil
  self.myRole = nil
  self.effectList = nil
  self.buffList = nil
  self.totalEffectList = nil
  self.totalEffectDic = nil
  if self.updateTimer ~= nil then
    self.updateTimer:Stop()
    self.updateTimer = nil
  end
  if self.info then
    self.info:Delete()
    self.info = nil
  end
  if self.buildings then
    for k, v in pairs(self.buildings) do
      v:Delete()
    end
    self.buildings = nil
  end
  if self.players then
    for k, v in pairs(self.players) do
      v:Delete()
    end
    self.players = nil
  end
  if self.roles then
    for k, v in pairs(self.roles) do
      v:Delete()
    end
    self.roles = nil
  end
  self.alliance2Role = nil
  self.myPlayer = nil
end

function BattlefieldInfoDsb:Enter()
  BattleFieldUtil.Log("\229\135\134\229\164\135\232\191\155\230\136\152\229\156\186%s\229\150\189", self.battlefieldType)
end

function BattlefieldInfoDsb:UpdateFromEnterMsg(msg, observer)
  self:OnUpdateRoles(msg.vsInfo)
  self:OnUpdateBuildings(msg.buildInfo)
  self:HandleEffects(msg)
  self:OnUpdateFromEnterMsg(msg, observer)
  BattleFieldUtil.Log("\230\136\152\229\156\186%s\230\142\165\229\136\176\228\186\134\232\191\155\229\133\165\230\182\136\230\129\175\239\188\140\230\155\180\230\150\176\229\174\140\230\175\149", self.battlefieldType)
end

function BattlefieldInfoDsb:CreateInfo(context, msg)
  return LuaInfo.New(context, msg)
end

function BattlefieldInfoDsb:CreateRole(context, msg)
  return LuaRole.New(context, msg)
end

function BattlefieldInfoDsb:CreateBuilding(context, msg)
  return LuaBuilding.New(context, msg)
end

function BattlefieldInfoDsb:UpdateFromBattleResult(msg)
  if msg.result then
    self.battleResult = {}
    self.myResult = nil
    local myAllianceId = LuaEntry.Player:GetAllianceUid()
    local max = {
      score = 0,
      occupiedScore = 0,
      resourceScore = 0,
      plunderScore = 0
    }
    for k, v in ipairs(msg.result) do
      local rst = LuaResult.New()
      rst:Update(v)
      rst.max = max
      max.score = rst.score > max.score and rst.score or max.score
      max.occupiedScore = rst.occupiedScore > max.occupiedScore and rst.occupiedScore or max.occupiedScore
      max.resourceScore = rst.resourceScore > max.resourceScore and rst.resourceScore or max.resourceScore
      max.plunderScore = rst.plunderScore > max.plunderScore and rst.plunderScore or max.plunderScore
      self.battleResult[rst.rank] = rst
      if not self.myResult and rst.allianceId == myAllianceId then
        self.myResult = rst
      end
    end
  end
  for rank = BattlefieldDsbConst.RoleType.MIN, BattlefieldDsbConst.RoleType.MAX do
    local rst = self.battleResult[rank]
    if not rst then
      rst = LuaResult.New()
      self.battleResult[rank] = rst
      rst:SetEmpty()
    end
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIBattlefieldDsbDuelBattleResultView, {anim = true})
end

function BattlefieldInfoDsb:GetResultByRank(rank)
  return self.battleResult and self.battleResult[rank]
end

function BattlefieldInfoDsb:GetMyResult()
  return self.myResult
end

function BattlefieldInfoDsb:IsObserver()
  return self.observer
end

function BattlefieldInfoDsb:OnUpdateFromEnterMsg(msg, observer)
  if msg then
    BattleFieldUtil.SetObserve(observer)
    if observer then
      if BattleFieldUtil.preWatchIdx and BattleFieldUtil.preWatchIdx ~= 0 then
        BattleFieldUtil.watchIdx = BattleFieldUtil.preWatchIdx
        BattleFieldUtil.preWatchIdx = 0
      end
    else
      BattleFieldUtil.preWatchIdx = 0
    end
    BattleFieldUtil.HandleEffects(msg, BattleFieldType.DsbDuel)
    self.timeStart = msg.battleStartTime
    self.timeEnd = msg.battleEndTime
    self.team = msg.team
  end
  self.observer = observer
  if not self.observer then
    self:SendDragonHospitalViewMsg()
    SFSNetwork.SendMessage(MsgDefines.DragonHospitalInfo)
  end
end

function BattlefieldInfoDsb:GetBattleStartTimeSec()
  return self.timeStart or 0
end

function BattlefieldInfoDsb:UpdateFromScoreUpdateMsg(msg)
  self:OnUpdateRoles(msg.data)
  EventManager:GetInstance():Broadcast(EventId.DsbDuelBattlefieldScoreUpdate)
end

function BattlefieldInfoDsb:UpdateFromBuildingHpChangeMsg(msg)
  self:UpdateSingleBuilding(msg)
end

function BattlefieldInfoDsb:OnUpdateRoles(teams)
  if teams then
    if not self.roles then
      self.roles = {}
      for k, v in ipairs(teams) do
        local team = self:CreateRole(self, v)
        if not team then
          BattleFieldUtil.LogError("\230\136\152\229\156\186 %s \229\136\155\229\187\186\230\136\152\229\156\186\233\152\159\228\188\141\229\164\177\232\180\165\239\188\129\239\188\129\239\188\129", self.battlefieldType)
          return
        end
        self.roles[team:GetRoleID()] = team
      end
    end
    self.alliance2Role = {}
    for k, v in ipairs(teams) do
      local team = self:GetRole(v.role)
      if team then
        team:UpdateTeam(v)
        self.alliance2Role[team.allianceId] = team
      end
    end
  end
  local myAllianceId = LuaEntry.Player:GetAllianceUid()
  if not self.allianceId2RoleId and self.roles then
    self.allianceId2RoleId = {}
    self.roleId2AllianceId = {}
    self.myRole = nil
    for k, v in pairs(self.roles) do
      self.allianceId2RoleId[v.allianceId] = v:GetRoleID()
      self.roleId2AllianceId[v:GetRoleID()] = v.allianceId
      if not self.myRole and v.allianceId == myAllianceId then
        self.myRole = v
      end
    end
  end
  self:RefreshRank()
end

function BattlefieldInfoDsb:OnUpdateBuildings(buildings)
  if not buildings then
    return
  end
  for k, v in ipairs(buildings) do
    self:UpdateSingleBuilding(v)
  end
end

function BattlefieldInfoDsb:UpdateSingleBuilding(msg)
  if not msg.buildUUID then
    return
  end
  local building = self:GetBuilding(msg.buildUUID)
  if not building then
    building = self:CreateBuilding(self, msg)
    if not building then
      BattleFieldUtil.LogError("\230\136\152\229\156\186 %s \229\136\155\229\187\186\229\187\186\231\173\145\229\164\177\232\180\165\239\188\129\239\188\129\239\188\129", self.battlefieldType)
    else
      self.buildings = self.buildings or {}
      self.buildings[msg.buildUUID] = building
    end
  end
  if building then
    building:Update(msg)
  end
end

local function _Sort(m1, m2)
  if m1.score ~= m2.score then
    return m1.score > m2.score
  end
  if m1.battleScore ~= m2.battleScore then
    return m1.battleScore > m2.battleScore
  end
  if m1.cooperationScore ~= m2.cooperationScore then
    return m1.cooperationScore > m2.cooperationScore
  end
  if m1.tacticsScore ~= m2.tacticsScore then
    return m1.tacticsScore > m2.tacticsScore
  end
  return m1.uid > m2.uid
end

function BattlefieldInfoDsb:OnHandleBattlePlayerInfo(msg)
  if not msg or not msg.userList then
    return
  end
  self.playerInfos = {}
  local myUid = LuaEntry.Player:GetUid()
  if msg.userList then
    table.sort(msg.userList, _Sort)
  end
  for k, v in ipairs(msg.userList) do
    local role = v.role
    local list = self.playerInfos[role]
    if not list then
      list = {}
      self.playerInfos[role] = list
    end
    local _info = {
      uid = v.uid,
      rank = v.rank,
      name = v.name,
      pic = v.pic,
      picVer = v.picVer,
      score = v.score or 0,
      battleScore = v.battleScore or 0,
      cooperationScore = v.cooperationScore or 0,
      tacticsScore = v.tacticsScore or 0,
      myDog = v.uid == myUid,
      rank = #list + 1
    }
    table.insert(list, _info)
    if v.uid == myUid then
      self.selfPlayerInfo = _info
    end
  end
  EventManager:GetInstance():Broadcast(EventId.DsbDuelBattlePlayerInfoChanged)
end

function BattlefieldInfoDsb:GetBattlePlayerInfos()
  return self.playerInfos or {}
end

function BattlefieldInfoDsb:GetSelfPlayerInfo()
  return self.selfPlayerInfo
end

local function _SortTeam(a, b)
  if a.score ~= b.score then
    return a.score > b.score
  end
  return a.speed > b.speed
end

function BattlefieldInfoDsb:RefreshRank()
  self.rolesByRank = {}
  for i = BattlefieldDsbConst.RoleType.MIN, BattlefieldDsbConst.RoleType.MAX do
    local team = self:GetRole(i)
    if team then
      table.insert(self.rolesByRank, team)
    end
  end
  table.sort(self.rolesByRank, _SortTeam)
  local emptyCount = BattlefieldDsbConst.RoleType.MAX - #self.rolesByRank
  if 0 < emptyCount then
    for i = 1, emptyCount do
      table.insert(self.rolesByRank, BattlefieldDsbConst.EmptyRole)
    end
  end
  self.roles2Rank = {}
  for k, v in ipairs(self.rolesByRank) do
    local role = v
    if role == BattlefieldDsbConst.EmptyRole then
      self.roles2Rank[BattlefieldDsbConst.RoleType.None] = k
    else
      self.roles2Rank[v:GetRoleID() or 0] = k
    end
  end
end

function BattlefieldInfoDsb:GetRoleByRank(rank)
  return self.rolesByRank and self.rolesByRank[rank] or BattlefieldDsbConst.EmptyRole
end

function BattlefieldInfoDsb:GetMyRole()
  return self.myRole
end

function BattlefieldInfoDsb:GetMyRank()
  if self.myRole then
    local myRoleId = self.myRole:GetRoleID()
    return self.roles2Rank[myRoleId] or 0
  end
  return 0
end

function BattlefieldInfoDsb:GetGatherResourceId()
  return
end

function BattlefieldInfoDsb:FillResPointData(detailInfo, template, data)
  data.id = template.special_effect_number
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
  end
end

function BattlefieldInfoDsb:GetBuildData(pointId)
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
  data.pointInfo = CS.SceneManager.World:GetPointInfo(pointId)
  if data.pointInfo ~= nil then
    local detailInfo = data.pointInfo.detail
    if detailInfo then
      data.detail = detailInfo
      data.role = detailInfo.Role
      data.uuid = detailInfo.Uuid
      local buildId = detailInfo.BuildId or detailInfo.ItemId
      local team = BattlefieldDsbDuelUtils.GetRole(data.role)
      data.buildId = buildId
      data.allianceId = team and team.allianceId
      data.abbr = team and team.allianceAbbr
      data.team = team
      data.marchUUID = detailInfo.MarchUUID
      data.gatherUUID = detailInfo.MarchUid
      data.startTime = detailInfo.StartTime
      data.openTime = detailInfo.OpenTime
      data.protectTime = detailInfo.ProtectTime
      data.occupyTime = detailInfo.OccupyTime
      data.state = detailInfo.State
      data.rewardCount = detailInfo.RewardCount
      data.score = detailInfo.Score or 0
      data.buffId = detailInfo.BuffId
      data.buffEndTime = detailInfo.BuffEndTime
      data.overflowScore = detailInfo.OverflowScore or 0
      local template = BattleFieldUtil.GetBattlefieldBuildTemplate(buildId)
      if template then
        data.size = template.size
        data.effectList = template.effectList
        data.name = template.name
        data.shareName = template.name
        data.iconPath = template:GetIconPath()
        data.template = template
        if template:IsRes() then
          self:FillResPointData(detailInfo, template, data)
        end
      end
    end
  end
  return data
end

function BattlefieldInfoDsb:BuildOpenCheck(buildInfo)
  local openTime = buildInfo.openTime
  local curSec = UITimeManager:GetInstance():GetServerSeconds()
  if curSec < (openTime or 0) then
    UIUtil.ShowTipsId(458279)
    return false
  end
  return true
end

function BattlefieldInfoDsb:GetDetail()
  if not self.buildInfo then
    return
  end
  local info = self.buildInfo ~= nil and CS.SceneManager.World:GetPointInfo(self.buildInfo.pointId) or nil
  local detailInfo = info ~= nil and info.detail or nil
  return detailInfo
end

function BattlefieldInfoDsb:CheckBattleStart()
  if not self.timeStart or self.timeStart <= 0 then
    return false
  end
  return UITimeManager:GetInstance():GetServerSeconds() > self.timeStart
end

function BattlefieldInfoDsb:FillBuildBtnList(pointData, btnList)
  if not pointData or not btnList then
    return
  end
  if self.observer then
    return
  end
  local buildTemp = pointData.template
  if not buildTemp then
    return
  end
  local hasOpen = true
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  hasOpen = curTime >= pointData.openTime
  if hasOpen and buildTemp:IsScoreBox() then
    table.insert(btnList, WorldPointBtnType.PickEpidemic)
    return
  end
  if not hasOpen then
    table.insert(btnList, WorldPointBtnType.StatusBattlefieldBuild)
    return
  end
  local info = CS.SceneManager.World:GetPointInfo(pointData.pointId)
  local detail = info and info.detail
  local role = detail ~= nil and detail.Role or BattlefieldDsbConst.RoleType.None
  local team = self:GetRole(role)
  if buildTemp:IsBuild() then
    table.insert(btnList, WorldPointBtnType.StatusBattlefieldBuild)
    if team then
      if team.allianceId == LuaEntry.Player:GetAllianceUid() then
        UIUtil.InsertAssistanceCityBtn(btnList, pointData.pointId, WorldPointBtnType.AssistanceEpidemic, DataCenter.BattlefieldDsbDuelManager:CanMultiAssistance())
      else
        table.insert(btnList, WorldPointBtnType.ScoutEpidemic)
        table.insert(btnList, WorldPointBtnType.RallyEpidemic)
        table.insert(btnList, WorldPointBtnType.AttackEpidemic)
      end
    else
      table.insert(btnList, WorldPointBtnType.ScoutEpidemic)
      table.insert(btnList, WorldPointBtnType.RallyEpidemic)
      table.insert(btnList, WorldPointBtnType.AttackEpidemic)
    end
  elseif team then
    if team.allianceId == LuaEntry.Player:GetAllianceUid() then
      if buildTemp:IsRes() then
      else
        UIUtil.InsertAssistanceCityBtn(btnList, pointData.pointId, WorldPointBtnType.AssistanceEpidemic, DataCenter.BattlefieldDsbDuelManager:CanMultiAssistance())
      end
    else
      table.insert(btnList, WorldPointBtnType.ScoutEpidemic)
      table.insert(btnList, WorldPointBtnType.AttackEpidemic)
    end
  else
    table.insert(btnList, WorldPointBtnType.ScoutEpidemic)
    table.insert(btnList, WorldPointBtnType.CollectEpidemic)
  end
end

function BattlefieldInfoDsb:GetRoleIDByAllianceID(allianceId)
  return self.allianceId2RoleId and self.allianceId2RoleId[allianceId]
end

function BattlefieldInfoDsb:GetAllianceIdByRoleId(roleId)
  return self.roleId2AllianceId and self.roleId2AllianceId[roleId]
end

function BattlefieldInfoDsb:GetBuildUpEffInfo()
  local eff = BattleFieldUtil.GetEffectById(EffectDefine.LW_DRAGON_PRODUCE_ADD_PERCENT)
  if not eff or eff == 0 then
    return false, 0
  end
  return true, eff
end

function BattlefieldInfoDsb:SendDragonHospitalViewMsg()
  SFSNetwork.SendMessage(MsgDefines.DsbBattleHospitalView)
end

function BattlefieldInfoDsb:SendDragonHospitalFinishMsg()
  SFSNetwork.SendMessage(MsgDefines.DsbBattleHospitalTake)
end

function BattlefieldInfoDsb:UpdateHospitalInfo(msg)
  self.treatmentSoldierDic = self.treatmentSoldierDic or {}
  if msg then
    local data = self.treatmentSoldierDic[msg.armyId]
    if not data then
      data = LuaSoldierData.New()
      self.treatmentSoldierDic[msg.armyId] = data
    end
    data:ParseData(msg)
  end
end

function BattlefieldInfoDsb:RefreshAutoHealPool()
  local last = self.autoHealPool
  self.autoHealPool = 0
  if self.treatmentSoldierDic then
    for k, v in pairs(self.treatmentSoldierDic) do
      self.autoHealPool = self.autoHealPool + v.needCureNum
    end
  end
  local changed = self.autoHealPool - last
  return changed
end

function BattlefieldInfoDsb:OnBattleHospitalView(message)
  if message.army then
    for i, v in ipairs(message.army) do
      self:UpdateHospitalInfo(v)
    end
  end
  if message.autoHealTotal then
    self.accumulativeTreatmentSoldierNum = message.autoHealTotal
  end
  self:RefreshAutoHealPool()
  EventManager:GetInstance():Broadcast(EventId.GetDesertBattleHospitalViewData)
end

function BattlefieldInfoDsb:OnBattleHospitalUpdate(message)
  if message.army then
    for i, v in ipairs(message.army) do
      self:UpdateHospitalInfo(v)
    end
  end
  if message.autoHealTotal then
    self.accumulativeTreatmentSoldierNum = message.autoHealTotal
  end
  local changed = self:RefreshAutoHealPool()
  if changed ~= 0 then
    EventManager:GetInstance():Broadcast(EventId.GetDesertBattleTreatmentSoldierNum, changed)
  end
end

function BattlefieldInfoDsb:OnBattleHospitalTake(message)
  if message.army then
    for i, v in ipairs(message.army) do
      self:UpdateHospitalInfo(v)
    end
  end
  if message.autoHealTotal then
    self.accumulativeTreatmentSoldierNum = message.autoHealTotal
  end
  local changed = self:RefreshAutoHealPool()
  if changed ~= 0 then
    EventManager:GetInstance():Broadcast(EventId.GetDesertBattleTreatmentSoldierNum, changed)
  end
end

function BattlefieldInfoDsb:GetAccumulativeTreatmentSoldierNum()
  return self.accumulativeTreatmentSoldierNum or 0
end

function BattlefieldInfoDsb:GetTreatmentFinishSoldierNum()
  return self.autoHealPool
end

function BattlefieldInfoDsb:GetTreatmentSpeed()
  local eff = BattleFieldUtil.GetEffectById(EffectDefine.LW_DSB_DUEL_HOSPITAL_HEAL_ADD)
  local effVal = eff or 0
  return effVal / BattlefieldDsbConst.EFF_HOSPITAL_TIME
end

function BattlefieldInfoDsb:GetTreatmentSoldierDataList()
  local rst = {}
  for k, v in pairs(self.treatmentSoldierDic) do
    if v.deadTotal > 0 or 0 < v.needCureNum or 0 < v.finishNum then
      table.insert(rst, v)
    end
  end
  return rst
end

local function _MagDistance(x1, y1, x2, y2)
  local _x = x1 - x2
  local _y = y1 - y2
  return _x * _x + _y * _y
end

function BattlefieldInfoDsb:GetClosestPos(target)
  local list = CS.SceneManager.World:GetAllDragonPointList()
  local cityList = CS.SceneManager.World:GetAllMainBaseList()
  local resList = CS.SceneManager.World:GetAllDragonResourceList()
  local TileIndexToWorld = SceneUtils.TileIndexToWorld
  local minMagDistance = 1501
  local closePos
  local templateMgr = DataCenter.BattlefieldDsbDuelTemplateManager
  for k, v in pairs(list) do
    local detailInfo = v.detail
    if detailInfo ~= nil then
      local buildId = detailInfo.BuildId or detailInfo.ItemId
      local buildTemplate = templateMgr:GetBuildTemplate(buildId)
      if buildTemplate and buildTemplate:IsBuild() then
        local pos = TileIndexToWorld(v.mainIndex, ForceChangeScene.World)
        local magDistance = _MagDistance(pos.x, pos.z, target.x, target.z)
        if minMagDistance > magDistance then
          minMagDistance = magDistance
          closePos = pos
        end
      end
    end
  end
  for k, v in pairs(cityList) do
    local pos = TileIndexToWorld(v.mainIndex, ForceChangeScene.World)
    local magDistance = _MagDistance(pos.x, pos.z, target.x, target.z)
    if minMagDistance > magDistance then
      minMagDistance = magDistance
      closePos = pos
    end
  end
  if closePos then
    return closePos
  end
  return target
end

function BattlefieldInfoDsb:GetRole(id)
  if not id then
    return
  end
  return self.roles and self.roles[id]
end

function BattlefieldInfoDsb:GetRoleIdByAllianceId(allianceId)
  return self.alliance2Role and self.alliance2Role[allianceId]
end

function BattlefieldInfoDsb:GetBuilding(bUuid)
  if not bUuid then
    return
  end
  return self.buildings and self.buildings[bUuid]
end

function BattlefieldInfoDsb:TryLeaveBattlefield()
  SFSNetwork.SendMessage(MsgDefines.DsbBattleLeave, self.team)
end

function BattlefieldInfoDsb:GetTeam()
  return self.team
end

function BattlefieldInfoDsb:DealEffects(destDic, srcDic)
  if srcDic and destDic then
    for _, v in pairs(srcDic) do
      local id = tostring(v.lordEffectId)
      local newV = v.lordEffectVal
      local value = destDic[id] or 0
      destDic[id] = value + newV
    end
  end
end

function BattlefieldInfoDsb:HandleEffects(t)
  local bfType = BattleFieldType.DsbDuel
  local templateMgr = DataCenter.BattlefieldDsbDuelTemplateManager
  if t.teamEffect then
    self.effectList = {}
    local id, value, curNum
    for k, v in pairs(t.teamEffect) do
      id = tostring(k)
      value = toInt(v)
      local template = templateMgr:GetEffectInfo(id)
      table.insert(self.effectList, {
        id = id,
        value = value,
        bfType = bfType,
        template = template
      })
    end
  end
  if t.buff then
    self.buffList = {}
    for _, v in pairs(t.buff) do
      local template = templateMgr:GetBuffTemplate(v.id)
      table.insert(self.buffList, {
        id = v.id,
        expireTime = v.expireTime,
        bfType = bfType,
        template = template
      })
    end
  end
  self.totalEffectDic = {}
  self.totalEffectList = {}
  if self.effectList then
    for k, v in ipairs(self.effectList) do
      table.insert(self.totalEffectList, v)
      self.totalEffectDic[v.id] = v.value
    end
  end
  if self.buffList then
    local curTime = UITimeManager:GetInstance():GetServerSeconds()
    for k, v in ipairs(self.buffList) do
      if curTime < v.expireTime then
        table.insert(self.totalEffectList, v)
      end
    end
  end
  return self.totalEffectList, self.totalEffectDic
end

function BattlefieldInfoDsb:OnUpdateTime()
  if self.totalEffectList and #self.totalEffectList > 0 then
    local changed = false
    local curTime = UITimeManager:GetInstance():GetServerSeconds()
    for i = #self.totalEffectList, 1, -1 do
      local v = self.totalEffectList[i]
      if v.expireTime and curTime > v.expireTime then
        changed = true
        table.remove(self.totalEffectList, i)
      end
    end
    if changed then
      self.totalEffectDic = {}
      for k, v in ipairs(self.totalEffectList) do
        self.totalEffectDic[v.id] = v.value
      end
      BattleFieldUtil.TryUpdateBattleEffects(BattleFieldType.DsbDuel, self.totalEffectList, self.totalEffectDic)
    end
  end
end

function BattlefieldInfoDsb:GetBattleEndTime()
  return self.timeEnd or 0
end

function BattlefieldInfoDsb:Description()
  local sb = StringBuilder.New()
  sb:AppendFormatLine("\230\136\152\229\156\186\231\177\187\229\158\139:%s", self.battlefieldType)
  sb:AppendFormatLine([[
info:
%s]], self.info and self.info:Description() or "\231\169\186")
  sb:AppendFormatLine("")
  sb:AppendFormatLine("buildings:%s", self.buildings and table.count(self.buildings) or 0)
  if self.buildings then
    for k, v in pairs(self.buildings) do
      sb:AppendFormatLine(v:Description())
    end
  end
  sb:AppendFormatLine("")
  sb:AppendFormatLine("teams:%s", self.roles and table.count(self.roles) or 0)
  if self.roles then
    for k, v in pairs(self.roles) do
      sb:AppendFormatLine(v:Description())
    end
  end
  sb:AppendFormatLine("")
  sb:AppendFormatLine("players:%s", self.players and table.count(self.players) or 0)
  if self.players then
    for k, v in pairs(self.players) do
      sb:AppendFormatLine(v:Description())
    end
  end
  sb:AppendFormatLine("")
  sb:AppendFormatLine([[
myPlayer:
%s]], self.myPlayer and self.myPlayer:Description() or "\231\169\186")
  sb:AppendFormatLine("myRank:%s", self:GetMyRank())
  sb:AppendLineFormat("observer:%s", self.observer)
  sb:AppendLineFormat("team:%s", self.team)
  sb:AppendLineFormat("timeStart:%s", UITimeManager:GetInstance():ConvertServerTimeToLocalTime(self.timeStart * 1000))
  sb:AppendLineFormat("timeEnd:%s", UITimeManager:GetInstance():ConvertServerTimeToLocalTime(self.timeEnd * 1000))
  sb:AppendLineFormat("treatmentSoldierDic:%s", table.count(self.treatmentSoldierDic))
  sb:AppendLineFormat("accumulativeTreatmentSoldierNum:%s", self.accumulativeTreatmentSoldierNum)
  if self.treatmentSoldierDic then
    for k, v in pairs(self.treatmentSoldierDic) do
      sb:AppendLineFormat("id:%s,heal:%s,dead:%s,autoHeal:%s", v.armyId, v.finishNum, v.deadTotal, v.needCureNum)
    end
  end
  if BattleFieldUtil.effectList then
    sb:AppendLineFormat("effects:")
    for k, v in ipairs(BattleFieldUtil.effectList) do
      sb:AppendLineFormat("[%s] %s = %s", v.bfType, v.id, v.value)
    end
  end
  if self.totalEffectList then
    sb:AppendFormatLine("totalEffectList:%s", #self.totalEffectList)
    for k, v in ipairs(self.totalEffectList) do
      sb:AppendLineFormat("[%s]%s", v.id, v.expireTime and UITimeManager:GetInstance():ConvertServerTimeToLocalTime(v.expireTime * 1000) or "")
    end
  end
  return sb:ToString()
end

return BattlefieldInfoDsb
