local base = UIBaseContainer
local WorldMiniMapCompS5 = BaseClass("WorldMiniMapCompS5", UIBaseContainer)
local UnityRectTransform = typeof(CS.UnityEngine.RectTransform)
local area_path = "area"
local layout_path = "layout"
local click_jump_path = "click_jump"
local self_point_path = "layout/selfPoint"
local member_point_path = "layout/memberPoint"
local leader_point_path = "layout/leaderPoint"

function WorldMiniMapCompS5:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshCityPoints()
  self:SetZoomPosAndSize(true)
end

function WorldMiniMapCompS5:OnDestroy()
  self:ClearItemCell()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function WorldMiniMapCompS5:ComponentDefine()
  self.bg = self:AddComponent(UIImage, "")
  self.compArea = self:AddComponent(UIImage, area_path)
  self.compLayout = self:AddComponent(UIBaseContainer, layout_path)
  self.btnClickJump = self:AddComponent(UIButton, click_jump_path)
  self.btnClickJump:SetOnClick(function()
    self:OnBtnClickJumpClick()
  end)
  self.self_point = self:TryAddComponent(UIImage, self_point_path)
  self.member_point = self:TryAddComponent(UIImage, member_point_path)
  self.leader_point = self:TryAddComponent(UIImage, leader_point_path)
  if self.self_point then
    self.self_point:SetActive(false)
  end
  if self.member_point then
    self.member_point:SetActive(false)
    self.member_point.gameObject:GameObjectCreatePool()
  end
  if self.leader_point then
    self.leader_point:SetActive(false)
  end
  SceneUtils.WorldSendGetALPointsRequest()
end

function WorldMiniMapCompS5:ComponentDestroy()
  if self.member_point then
    self.member_point.gameObject:GameObjectRecycleAll()
  end
  self.compArea = nil
  self.compLayout = nil
  self.btnClickJump = nil
  self.self_point = nil
  self.member_point = nil
  self.leader_point = nil
end

function WorldMiniMapCompS5:DataDefine()
  local info = SeasonUtil.GetSeasonInfo(LuaEntry.Player:GetCurServerId())
  if info ~= nil then
    local skin = info:GetSkinTemplate()
    if skin and skin.mini_map ~= nil and skin.mini_map ~= "" then
      self.bg:LoadSpriteAuto(skin.mini_map)
    else
      local seasonType = info:GetServerSubdivisionType(false)
      if seasonType == SeasonMapType.NineNationRainforest then
        self.bg:LoadSpriteAuto("Assets/Main/SeasonRes/S5/Sprites/MiniMap/v3/ljq_s6ditu_map.png")
      else
        self.bg:LoadSpriteAuto("Assets/Main/SeasonRes/S5/Sprites/MiniMap/v2/lrb_S5ditu_map_v2.png")
      end
    end
  else
    self.bg:LoadSpriteAuto("Assets/Main/SeasonRes/S5/Sprites/MiniMap/v2/lrb_S5ditu_map_v2.png")
  end
  self.itemList = {}
  self.mapScale = 0.198
  self.mapDelta = 0
  self.mapSize = 198
  self.screenX = CS.UnityEngine.Screen.width
  self.screenY = CS.UnityEngine.Screen.height
  self.lastZoom = 0
  self.zoomXSize = 0
  self.zoomYSize = 0
end

function WorldMiniMapCompS5:DataDestroy()
  self.itemList = {}
  self.dataCityPoint = nil
  self.mapScale = nil
  self.mapDelta = nil
  self.mapSize = nil
  self.screenX = nil
  self.screenY = nil
  self.lastZoom = nil
  self.zoomXSize = nil
  self.zoomYSize = nil
end

function WorldMiniMapCompS5:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UPDATE_POINTS_DATA, self.RefreshCityPoints)
  self:AddUIListener(EventId.WORLD_CAMERA_CHANGE_POINT, self.RefreshCameraPoint)
  self:AddUIListener(EventId.OnWorldAlliancePointsRefresh, self.RefreshCityPoints)
end

function WorldMiniMapCompS5:OnRemoveListener()
  self:RemoveUIListener(EventId.UPDATE_POINTS_DATA, self.RefreshCityPoints)
  self:RemoveUIListener(EventId.WORLD_CAMERA_CHANGE_POINT, self.RefreshCameraPoint)
  self:RemoveUIListener(EventId.OnWorldAlliancePointsRefresh, self.RefreshCityPoints)
  base.OnRemoveListener(self)
end

function WorldMiniMapCompS5:RefreshCityPoints()
  if IsNull(self.compLayout) then
    return
  end
  ProfilerUtil.BeginSample("WorldMiniMapCompS5:ShowCityPoint")
  local data = self:GetCityPointData(self.dataCityPoint)
  if data and data.isNew then
    self.dataCityPoint = data
    self:ClearItemCell()
    local autoMirrorOpen = CommonUtil.IsArabicAutoMirrorOpen()
    local autoMirror = autoMirrorOpen and -1 or 1
    local posDict = {}
    local index = 0
    local curServerId = LuaEntry.Player:GetCurServerId()
    local seasonInfo = SeasonUtil.GetSeasonInfo(curServerId)
    local seasonType = SeasonMapType.NineNation
    if seasonInfo ~= nil then
      seasonType = seasonInfo:GetServerType(false)
    end
    if data.members ~= nil then
      for _, v in pairs(data.members) do
        index = self:AddCityPointData(1, seasonInfo, seasonType, index, autoMirrorOpen, autoMirror, v, posDict, "Assets/Main/Prefabs/UI/UIMain/memberPoint.prefab")
      end
    end
    if data.myLeader then
      index = self:AddCityPointData(2, seasonInfo, seasonType, index, autoMirrorOpen, autoMirror, data.myLeader, posDict, "Assets/Main/Prefabs/UI/UIMain/leaderPoint.prefab")
    end
    if data.myPos then
      index = self:AddCityPointData(3, seasonInfo, seasonType, index, autoMirrorOpen, autoMirror, data.myPos, posDict, "Assets/Main/Prefabs/UI/UIMain/selfPoint.prefab")
    end
  end
  ProfilerUtil.EndSample()
end

function WorldMiniMapCompS5:AddCityPointData(priority, seasonInfo, seasonType, index, autoMirrorOpen, autoMirror, theUser, posDict, PrefabPath)
  if seasonInfo ~= nil then
    if seasonType == SeasonMapType.NineNation then
      if not seasonInfo:IsInBattleServerGroupInt(theUser.serverId) then
        return index
      end
    elseif seasonInfo.serverId ~= theUser.serverId then
      return index
    end
  end
  local pos = SceneUtils.IndexToTilePos(theUser.pos, ForceChangeScene.World)
  local x, y, z = SceneUtils.GetNinePalacesOffset(theUser.serverId)
  local tempX = pos.x + x / 2
  local tempY = pos.y + z / 2
  if autoMirrorOpen then
    tempX = 3000 - tempX
  end
  tempX = tempX * 0.066 * autoMirror
  tempY = tempY * 0.066
  local goodPoint = true
  if priority == 1 then
    for k1, v1 in ipairs(posDict) do
      if math.abs(v1.x - tempX) < 1.28 and math.abs(v1.y - tempY) < 1.28 then
        goodPoint = false
        break
      end
    end
  end
  if priority == 2 and self.leader_point ~= nil then
    self.leader_point:SetActive(true)
    self.leader_point:SetAnchoredPositionXY(tempX, tempY, true)
    self.leader_point:SetAsLastSibling()
  elseif priority == 3 and self.self_point ~= nil then
    self.self_point:SetActive(true)
    self.self_point:SetAnchoredPositionXY(tempX, tempY, true)
    self.self_point:SetAsLastSibling()
  elseif goodPoint then
    table.insert(posDict, {x = tempX, y = tempY})
    if self.member_point ~= nil then
      local goItem = self.member_point.gameObject:GameObjectSpawn(self.compLayout.transform)
      local tfx = goItem:GetComponent(UnityRectTransform)
      tfx:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      tfx:Set_anchoredPosition(tempX, tempY)
      goItem:SetActive(true)
      return index
    end
    index = index + 1
    self.itemList[index] = self:GameObjectInstantiateAsync(PrefabPath, function(request)
      if request.isError then
        return
      end
      ProfilerUtil.BeginSample("UIMainMiniMapView:ShowCityPointAsync")
      local go = request.gameObject
      local tfx = go:GetComponent(UnityRectTransform)
      tfx:SetParent(self.compLayout.transform)
      tfx:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      tfx:Set_anchoredPosition(tempX, tempY)
      go.gameObject:SetActive(true)
      ProfilerUtil.EndSample()
    end)
  end
  return index
end

function WorldMiniMapCompS5:OnBtnClickJumpClick()
  local screenPos = CS.UnityEngine.Input.mousePosition
  local worldP = CS.GameEntry.UICamera:ScreenToWorldPoint(screenPos)
  local localP = self.btnClickJump.transform:InverseTransformPoint(worldP)
  if CommonUtil.IsArabicAutoMirrorOpen() then
    localP.x = -self.mapSize - localP.x
  end
  local x = localP.x / self.mapSize * WorldTileCount
  local y = localP.y / self.mapSize * WorldTileCount
  local curServerId = LuaEntry.Player:GetCurServerId()
  x = localP.x / self.mapSize * 3000 * TileSize * CommonUtil.ArabicAutoMirrorFactor()
  y = localP.y / self.mapSize * 3000 * TileSize
  local seasonInfo = SeasonUtil.GetSeasonInfo(curServerId)
  if seasonInfo then
    local worldPos = Vector3.New(x, 0, y)
    local mapIndex = seasonInfo:GetNinePalacesIndexByWorldPos(worldPos)
    local serverId = seasonInfo:GetNinePalacesServer(mapIndex)
    LuaEntry.Player:SendGetOtherServerInfo(serverId)
    EventManager:GetInstance():Broadcast(EventId.OnMiniMapClickJump, 1)
    GoToUtil.GotoPos(worldPos, -1, LookAtFocusTime, function()
      EventManager:GetInstance():Broadcast(EventId.OnMiniMapClickJump, 2)
    end, serverId)
  else
    GoToUtil.GotoPos(Vector3.one, -1, LookAtFocusTime)
  end
end

function WorldMiniMapCompS5:ClearItemCell()
  if self.itemList ~= nil then
    for k, v in pairs(self.itemList) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  if self.self_point then
    self.self_point:SetActive(false)
  end
  if self.member_point then
    self.member_point:SetActive(false)
  end
  if self.leader_point then
    self.leader_point:SetActive(false)
  end
  self.itemList = {}
end

function WorldMiniMapCompS5:RefreshCameraPoint()
  self:SetZoomPosAndSize(true)
end

function WorldMiniMapCompS5:SetZoomPosAndSize(needChangeSize)
  if needChangeSize then
    local maxV3 = {
      x = self.screenX,
      y = self.screenY,
      z = 0
    }
    local maxPos = CS.SceneManager.World:ScreenPointToWorld(maxV3)
    local minV3 = {
      x = 0,
      y = 0,
      z = 0
    }
    local minPos = CS.SceneManager.World:ScreenPointToWorld(minV3)
    self.zoomXSize = math.max((math.min(maxPos.x, 6000) - math.max(minPos.x, 0)) * 0.033, 12)
    self.zoomYSize = math.max((math.min(maxPos.z, 6000) - math.max(minPos.z, 0)) * 0.033, 12)
    self.compArea:SetSizeDeltaXY(self.zoomXSize, self.zoomYSize)
  end
  local targetV3 = CS.SceneManager.World.CurTarget
  local realV2 = {}
  local tempX = Mathf.Clamp(targetV3.x, 0, 6000) * 0.033 - self.zoomXSize / 2
  local tempY = Mathf.Clamp(targetV3.z, 0, 6000) * 0.033 - self.zoomYSize / 2
  local checkX = math.min(tempX, self.mapSize - self.zoomXSize)
  local checkY = math.min(tempY, self.mapSize - self.zoomYSize)
  realV2.x = Mathf.Clamp(checkX, 0, self.mapSize)
  realV2.y = Mathf.Clamp(checkY, 0, self.mapSize)
  if CommonUtil.IsArabicAutoMirrorOpen() then
    realV2.x = self.mapSize - realV2.x - self.zoomXSize
  end
  self.compArea:SetAnchoredPositionXY(realV2.x, realV2.y)
end

function WorldMiniMapCompS5:Update100MS()
  local theWorld = CS.SceneManager.World
  if theWorld == nil then
    return
  end
  local zoom = theWorld:GetLodDistance()
  if Mathf.Abs(self.lastZoom - zoom) > 10 then
    self:SetZoomPosAndSize(true)
    self.lastZoom = zoom
  end
end

local function GetCityPointDataFast(allMembers, oneData)
  ProfilerUtil.BeginSample("UIMainMiniMapView:ShowCityPoint.GetAllMainBaseList")
  local list = CS.SceneManager.World:GetAllMainBaseListByType(CS.PlayerType.PlayerAlliance, CS.PlayerType.PlayerAllianceLeader)
  ProfilerUtil.EndSample()
  if list ~= nil then
    ProfilerUtil.BeginSample("UIMainMiniMapView:ShowCityPoint UpdateList")
    local playerUid = LuaEntry.Player.uid
    for k, v in pairs(list) do
      local ownerUid = v.ownerUid
      local data = allMembers[ownerUid]
      if ownerUid ~= playerUid and (data == nil or v.mainIndex ~= data.pointId) then
        if data ~= nil then
          data.pointId = v.mainIndex
        end
        if v:GetPlayerType() == CS.PlayerType.PlayerAllianceLeader then
          oneData.myLeader = {
            uid = ownerUid,
            serverId = v.serverId,
            pos = v.mainIndex
          }
        else
          oneData.members[ownerUid] = {
            serverId = v.serverId,
            pos = v.mainIndex
          }
        end
        oneData.isNew = true
      end
    end
    ProfilerUtil.EndSample()
  end
end

function WorldMiniMapCompS5:LegacyGetMembersData(dataCityPoint)
  local oneData = {}
  local playerUid = LuaEntry.Player.uid
  local mainIndex = LuaEntry.Player:GetMainWorldPos()
  local selfAllianceId = LuaEntry.Player.allianceId
  local selfData = {
    serverId = LuaEntry.Player.serverId,
    pos = mainIndex
  }
  oneData.members = {}
  oneData.isNew = dataCityPoint == nil or dataCityPoint.myPos == nil or dataCityPoint.myPos.pos ~= mainIndex
  oneData.myPos = selfData
  if selfAllianceId == nil or selfAllianceId == "" then
    return oneData
  end
  local allMembers = DataCenter.AllianceMemberDataManager:GetAllMember()
  if allMembers ~= nil then
    for _, v in pairs(allMembers) do
      if v.uid == playerUid then
      elseif v.pointId > 0 then
        if v.rank == 5 then
          oneData.myLeader = {
            uid = v.uid,
            serverId = v.curServerId or v.serverId,
            pos = v.pointId
          }
          if not oneData.isNew and (dataCityPoint.myLeader == nil or dataCityPoint.myLeader.uid ~= v.uid or dataCityPoint.myLeader.pos ~= v.pointId) then
            oneData.isNew = true
          end
        else
          oneData.members[v.uid] = {
            serverId = v.curServerId or v.serverId,
            pos = v.pointId
          }
        end
      end
    end
  end
  GetCityPointDataFast(allMembers, oneData)
  return oneData
end

function WorldMiniMapCompS5:GetMembersData()
  local oneData = {}
  if SceneUtils.GetIsInWorld() then
    local scene = CS.SceneManager.World
    if not scene then
      return oneData
    end
    ProfilerUtil.BeginSample("UIMainMiniMapView:GetMembersData")
    local mainIndex = LuaEntry.Player:GetMainWorldPos()
    local myServer = LuaEntry.Player.serverId
    oneData.myPos = {serverId = myServer, pos = mainIndex}
    local _serverID, _pos = 0, 0
    local leader, members = scene:GetALMemberPoints()
    if 0 < leader and not DataCenter.AllianceBaseDataManager:IsSelfLeader() then
      _serverID, _pos = SceneUtils.DecodeWorldPos(leader)
      oneData.myLeader = {serverId = _serverID, pos = _pos}
    end
    if members then
      local memberCount = members.Count
      oneData.members = {}
      if 0 < memberCount then
        for i = 0, memberCount - 1 do
          local mb = members[i]
          if mb ~= leader then
            _serverID, _pos = SceneUtils.DecodeWorldPos(mb)
            if _serverID ~= myServer or _pos ~= mainIndex then
              table.insert(oneData.members, {serverId = _serverID, pos = _pos})
            end
          end
        end
      end
    end
    ProfilerUtil.EndSample()
    oneData.isNew = true
  end
  return oneData
end

function WorldMiniMapCompS5:GetCityPointData(dataCityPoint)
  local theWorld = CS.SceneManager.World
  if theWorld == nil then
    return nil
  end
  if SceneUtils.CheckNewAllianceMemberSwitch() then
    return self:GetMembersData()
  end
  return self:LegacyGetMembersData(dataCityPoint)
end

return WorldMiniMapCompS5
