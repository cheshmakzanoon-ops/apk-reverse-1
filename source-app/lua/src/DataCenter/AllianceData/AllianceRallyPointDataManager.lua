local AllianceRallyPointDataManager = BaseClass("AllianceRallyPointDataManager")
local AllianceWorldMark = require("Scene.AllianceWorldMark.AllianceWorldMark")
local ResourceManager = CS.GameEntry.Resource
local TranslateManager = require("DataCenter.MailData.MailTranslateManager")

function AllianceRallyPointDataManager:__init()
  self.markDataDic = {}
  self.markViewDic = {}
  self.markReqDic = {}
  self.farawayMemberCount = {}
  self.enterCityCount = 0
  self.recommendType = MarkType.Alliance_rally
  self:AddListener()
end

function AllianceRallyPointDataManager:GetTranslator()
  if self.Translate == nil then
    self.Translate = TranslateManager.New()
  end
  return self.Translate
end

function AllianceRallyPointDataManager:ClearAll()
  for _, v in pairs(self.markViewDic) do
    v:Destroy()
  end
  self.markViewDic = {}
  for _, v in pairs(self.markReqDic) do
    v:Destroy()
  end
  self.markReqDic = {}
  for _, v in pairs(self.markDataDic) do
    v:Destroy()
  end
  self.markDataDic = {}
  self.farawayMemberCount = {}
  self.recommendType = MarkType.Alliance_rally
  self.enterCityCount = 0
end

function AllianceRallyPointDataManager:__delete()
  self:ClearAll()
  self.Translate = nil
  self.farawayMemberCount = nil
  self.enterCityCount = nil
  self:RemoveListener()
end

function AllianceRallyPointDataManager:InitData()
end

function AllianceRallyPointDataManager:AddListener()
  EventManager:GetInstance():AddListener(EventId.BeforeLeaveWorld, self.OnBeforeLeaveWorld)
  EventManager:GetInstance():AddListener(EventId.PveLevelExit, self.RefreshAllMarkView)
  EventManager:GetInstance():AddListener(EventId.OnEnterCrossServer, self.RefreshAllMarkView)
  EventManager:GetInstance():AddListener(EventId.OnQuitCrossServer, self.RefreshAllMarkView)
  EventManager:GetInstance():AddListener(EventId.OnEnterWorld, self.RefreshAllMarkView)
  EventManager:GetInstance():AddListener(EventId.ChangeCameraLod, self.OnLodChange)
  EventManager:GetInstance():AddListener(EventId.WorldAllianceMarkTranslateFinish, self.OnWorldTranslateFinish)
  EventManager:GetInstance():AddListener(EventId.OnCityDescAssetLoaded, self.OnEnterCity)
  EventManager:GetInstance():AddListener(EventId.UpdateSelfAllianceRallyPointBubble, self.OnUpdateSelfAllianceRallyPointBubble)
end

function AllianceRallyPointDataManager:RemoveListener()
  EventManager:GetInstance():RemoveListener(EventId.BeforeLeaveWorld, self.OnBeforeLeaveWorld)
  EventManager:GetInstance():RemoveListener(EventId.PveLevelExit, self.RefreshAllMarkView)
  EventManager:GetInstance():RemoveListener(EventId.OnEnterCrossServer, self.RefreshAllMarkView)
  EventManager:GetInstance():RemoveListener(EventId.OnQuitCrossServer, self.RefreshAllMarkView)
  EventManager:GetInstance():RemoveListener(EventId.OnEnterWorld, self.RefreshAllMarkView)
  EventManager:GetInstance():RemoveListener(EventId.ChangeCameraLod, self.OnLodChange)
  EventManager:GetInstance():RemoveListener(EventId.WorldAllianceMarkTranslateFinish, self.OnWorldTranslateFinish)
  EventManager:GetInstance():RemoveListener(EventId.OnCityDescAssetLoaded, self.OnEnterCity)
  EventManager:GetInstance():RemoveListener(EventId.UpdateSelfAllianceRallyPointBubble, self.OnUpdateSelfAllianceRallyPointBubble)
end

function AllianceRallyPointDataManager:TryAddRallyPoint(point, server, markType, name)
  SFSNetwork.SendMessage(MsgDefines.WorldAddAllianceMark, point, server, markType, name)
end

function AllianceRallyPointDataManager:TryDelRallyPoint(markType)
  SFSNetwork.SendMessage(MsgDefines.WorldDelAllianceMark, markType)
end

function AllianceRallyPointDataManager.OnWorldTranslateFinish(markData)
  local self = DataCenter.AllianceRallyPointDataManager
  for i, go in pairs(self.markViewDic) do
    if go.markData.type == markData.type then
      go:OnTranslateFinish(markData)
      break
    end
  end
end

function AllianceRallyPointDataManager:OnInitRallyPointDic(message)
end

function AllianceRallyPointDataManager:OnAddRallyPoint(serverData)
  if not serverData then
    return
  end
  if serverData.allianceId ~= LuaEntry.Player:GetAllianceUid() then
    return
  end
  local markType = serverData.markType
  if not AllianceRallyType[markType] then
    return
  end
  self:DeleteOneRallyPoint(markType)
  local newData = AllianceMarkData.New()
  newData:ParseData(serverData)
  newData:SetTranslateHandler(self:GetTranslator())
  self.markDataDic[markType] = newData
  self:CreateRallyPointView(markType)
  EventManager:GetInstance():Broadcast(EventId.UpdateSelfAllianceRallyPoint)
end

function AllianceRallyPointDataManager:DeleteOneRallyPoint(markType)
  self:DeleteOneRallyPointView(markType)
  if self.markDataDic[markType] then
    self.markDataDic[markType]:Destroy()
    self.markDataDic[markType] = nil
  end
end

function AllianceRallyPointDataManager:OnAddRallyPointPush(msg)
  self:OnAddRallyPoint(msg)
end

function AllianceRallyPointDataManager:OnDelRallyPointPush(msg)
  self:DeleteOneRallyPoint(msg.markInfo.markType)
end

function AllianceRallyPointDataManager:ClearAllRallyPointsView()
  for _, v in pairs(self.markViewDic) do
    v:Destroy()
  end
  self.markViewDic = {}
  for _, v in pairs(self.markReqDic) do
    v:Destroy()
  end
  self.markReqDic = {}
end

function AllianceRallyPointDataManager:DeleteOneRallyPointView(markType)
  if self.markViewDic[markType] then
    self.markViewDic[markType]:Destroy()
    self.markViewDic[markType] = nil
  end
  if self.markReqDic[markType] then
    self.markReqDic[markType]:Destroy()
    self.markReqDic[markType] = nil
  end
end

function AllianceRallyPointDataManager:CreateRallyPointView(markType)
  self:DeleteOneRallyPointView(markType)
  if not CS.SceneManager:IsInWorld() then
    return
  end
  local markData = self.markDataDic[markType]
  if not markData then
    return
  end
  local curServerId = LuaEntry.Player:GetCurServerId()
  if markData.server ~= curServerId and (not SeasonUtil.InSeasonBigMapMode(curServerId) or not SeasonUtil.IsInSameGroup(curServerId)) then
    return
  end
  local request = ResourceManager:InstantiateAsync(markData:GetPrefabPath())
  self.markReqDic[markType] = request
  request:completed("+", function()
    if request.isError then
      return
    end
    request.gameObject:SetActive(true)
    request.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    request.gameObject.name = "RallyPoint_" .. markData.uid
    local newRallyPoint = AllianceWorldMark.New()
    newRallyPoint:OnCreate(request)
    self.markViewDic[markType] = newRallyPoint
    self.markViewDic[markType]:ShowMark(markData)
  end)
end

function AllianceRallyPointDataManager:CheckIfPointInUse(pos, serverId)
  if serverId then
    for i, v in pairs(self.markDataDic) do
      if v.pos == pos and v.server == serverId then
        return true
      end
    end
  else
    for i, v in pairs(self.markDataDic) do
      if v.pos == pos then
        return true
      end
    end
  end
  return false
end

function AllianceRallyPointDataManager:OnBeforeLeaveWorld()
  DataCenter.AllianceRallyPointDataManager:ClearAllRallyPointsView()
end

function AllianceRallyPointDataManager:CheckFreeMove()
  local lastOfflineTime = LuaEntry.Player.lastOffLineTime
  local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  local firstOnlineAfterAcceptInNewAlliance = allianceData and allianceData.joinTime > 0 and lastOfflineTime < allianceData.joinTime
  local firstJoinNewAllianceOnline = DataCenter.AllianceBaseDataManager.isFirstTimeJoin_NewbeeMoveCityOnline
  if firstOnlineAfterAcceptInNewAlliance or firstJoinNewAllianceOnline then
    if firstJoinNewAllianceOnline then
      DataCenter.AllianceBaseDataManager.isFirstTimeJoin_NewbeeMoveCityOnline = false
    end
    local isFree = UIUtil.IsFreeMoveCityInOpenServerTime()
    if isFree then
      UIUtil.OpenFreeMoveCityInOpenServerTimeConfirmPanel()
    end
  end
end

function AllianceRallyPointDataManager:OnEnterCity()
  local self = DataCenter.AllianceRallyPointDataManager
  if self.enterCityCount == 0 then
    self:CheckFreeMove()
  end
  self.enterCityCount = self.enterCityCount + 1
end

function AllianceRallyPointDataManager:RefreshAllMarkView()
  local self = DataCenter.AllianceRallyPointDataManager
  for _, v in pairs(self.markDataDic) do
    self:CreateRallyPointView(v.type)
  end
end

function AllianceRallyPointDataManager:OnInitSelfRallyPoint(serverData)
  self:OnAddRallyPoint(serverData)
  if DataCenter.AllianceBaseDataManager.isFirstTimeJoin_NewbeeMoveCityOnline then
    self:CheckFreeMove()
  end
end

function AllianceRallyPointDataManager:OnInitOtherServerRallyPoint(serverData)
  self:OnAddRallyPoint(serverData)
  SFSNetwork.SendMessage(MsgDefines.GetAllianceRecommendRallyPoint)
end

function AllianceRallyPointDataManager:GetMyAllianceRallyPoint(markType)
  markType = markType or MarkType.Alliance_rally
  return self.markDataDic[markType]
end

function AllianceRallyPointDataManager:GetRecommendRallyPoint()
  local markType = self:GetRecommendType()
  return self.markDataDic[markType]
end

function AllianceRallyPointDataManager:GetRecommendType()
  return self.recommendType or MarkType.Alliance_rally
end

function AllianceRallyPointDataManager:GetAllAllianceRallyPoints()
  return self.markDataDic
end

function AllianceRallyPointDataManager:OnLodChange()
  local lod = self
  local self = DataCenter.AllianceRallyPointDataManager
  if not self.markViewDic then
    return
  end
  for k, v in pairs(self.markViewDic) do
    local data = self.markDataDic[k]
    if AllianceRallyType[data.type] then
      v:RefreshBubbleRoot()
    end
  end
end

function AllianceRallyPointDataManager:TrySendGetLongDistanceMemberNumMsg(markType)
  local selfIsLeader = DataCenter.AllianceBaseDataManager:IsSelfLeader()
  if selfIsLeader then
    markType = markType or self:GetRecommendType()
    SFSNetwork.SendMessage(MsgDefines.GetLongDistanceMemberNum, markType)
  end
end

function AllianceRallyPointDataManager:SetFarAwayMemberCount(num, type)
  self.farawayMemberCount[type] = num
  EventManager:GetInstance():Broadcast(EventId.UpdateLongDistanceMemberNum)
end

function AllianceRallyPointDataManager:GetFarAwayMemberCount(type)
  return self.farawayMemberCount[type] or 0
end

function AllianceRallyPointDataManager:CalcSelfPosAndRallyPointPosDisAndAngle(markType)
  markType = markType or MarkType.Alliance_rally
  local distance, angleInRadians = 0, 0
  local markData = self.markDataDic[markType]
  if markData then
    local markTilePos = SceneUtils.BigIndexToTilePos(markData.pos, ForceChangeScene.World)
    local selfTilePos = SceneUtils.IndexToTilePos(LuaEntry.Player:GetMainWorldPos(), ForceChangeScene.World)
    distance = math.ceil(SceneUtils.TileDistance(markTilePos, selfTilePos, markData.server, LuaEntry.Player:GetSelfServerId()))
    local markWorldPos = SceneUtils.TileToWorld(markTilePos, ForceChangeScene.World, markData.server)
    local selfWorldPos = SceneUtils.TileToWorld(selfTilePos, ForceChangeScene.World, LuaEntry.Player:GetSelfServerId())
    angleInRadians = Mathf.Atan2(selfWorldPos.z - markWorldPos.z, selfWorldPos.x - markWorldPos.x)
  end
  return distance, angleInRadians
end

function AllianceRallyPointDataManager:CheckPointIsFarRallyPoint(pointId, serverId)
  local markData = self:GetRecommendRallyPoint()
  if markData == nil then
    return false
  end
  if SeasonUtil.InSeasonBigMapMode(LuaEntry.Player:GetSourceServerId()) then
    if not SeasonUtil.IsInSameGroup(serverId) then
      return true
    end
  elseif serverId ~= markData.server then
    return true
  end
  local markTilePos = SceneUtils.BigIndexToTilePos(markData.pos, ForceChangeScene.World)
  local checkTilePos = SceneUtils.IndexToTilePos(pointId, ForceChangeScene.World)
  local distance = math.ceil(SceneUtils.TileDistance(markTilePos, checkTilePos, markData.server, serverId))
  local rangeRadius = LuaEntry.DataConfig:TryGetNum("free_teleport_time", "k2")
  return distance > rangeRadius
end

function AllianceRallyPointDataManager:CheckMyBaseFarFromAnyRallyPoint()
  if LuaEntry.Player:GetMainWorldPos() <= 0 then
    return false
  end
  for _, v in pairs(self.markDataDic) do
    if v.server == LuaEntry.Player:GetSelfServerId() then
      local distance, angleInRadians = self:CalcSelfPosAndRallyPointPosDisAndAngle(v.type)
      local rangeRadius = LuaEntry.DataConfig:TryGetNum("free_teleport_time", "k2")
      return distance > rangeRadius
    end
  end
  return false
end

function AllianceRallyPointDataManager:GetAllianceGatherRedPoint()
  local redPointCount = 0
  local selfFarAwayRedPoint, farAwayMemberRedPoint = false, false
  if 0 >= LuaEntry.Player:GetMainWorldPos() then
    return redPointCount, selfFarAwayRedPoint, farAwayMemberRedPoint
  end
  for _, v in pairs(self.markDataDic) do
    if v.server == LuaEntry.Player:GetSelfServerId() then
      local distance, angleInRadians = self:CalcSelfPosAndRallyPointPosDisAndAngle(v.type)
      local rangeRadius = LuaEntry.DataConfig:TryGetNum("free_teleport_time", "k2")
      if distance > rangeRadius then
        redPointCount = 1
        selfFarAwayRedPoint = true
      end
      local selfIsLeader = DataCenter.AllianceBaseDataManager:IsSelfLeader()
      if selfIsLeader then
        local farawayMemberMaxCount = LuaEntry.DataConfig:TryGetNum("free_teleport_time", "k3")
        local markType = self:GetRecommendType()
        if self.farawayMemberCount[markType] and farawayMemberMaxCount <= self.farawayMemberCount[markType] then
          redPointCount = redPointCount + 1
          farAwayMemberRedPoint = true
        end
      end
    end
  end
  return redPointCount, selfFarAwayRedPoint, farAwayMemberRedPoint
end

function AllianceRallyPointDataManager:CanAllianceMoveCity()
  return not BattleFieldUtil.InBattleField()
end

function AllianceRallyPointDataManager:TrySetRecommendRallyPoint(markType)
  local markData = self.markDataDic[markType]
  if self.recommendType == markType or markData == nil then
    return
  end
  if DataCenter.AllianceBaseDataManager:IsR4orR5() then
    local v2 = SceneUtils.IndexToTilePos(markData:GetPointIndex(), ForceChangeScene.World)
    local pos = UIUtil.FormatServerPosition(markData.server, v2.x, v2.y)
    UIUtil.ShowConfirmNew({
      contentText = CS.GameEntry.Localization:GetString("s5_cross_ui07", pos),
      btnNum = 2,
      showToggle = false,
      confirmBtnParam = {
        action = function()
          SFSNetwork.SendMessage(MsgDefines.SetAllianceRecommendRallyPoint, markType)
        end
      }
    })
  else
    UIUtil.ShowTipsId(803040)
  end
end

function AllianceRallyPointDataManager:HandleSetRecommendRallyPoint(msg)
  if LuaEntry.Player:GetAllianceUid() == msg.allianceId then
    if msg.markType == nil or msg.markType <= 0 then
      self.recommendType = MarkType.Alliance_rally
    else
      self.recommendType = msg.markType
    end
    EventManager:GetInstance():Broadcast(EventId.RefreshRecommendRallyPoint)
  end
end

function AllianceRallyPointDataManager:OnUpdateSelfAllianceRallyPointBubble()
  local self = DataCenter.AllianceRallyPointDataManager
  if self.markViewDic then
    for i, v in pairs(self.markViewDic) do
      v:RefreshBubbleRoot()
    end
  end
end

return AllianceRallyPointDataManager
