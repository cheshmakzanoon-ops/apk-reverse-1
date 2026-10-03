local base = UIBaseContainer
local WorldMiniMapComp = BaseClass("WorldMiniMapComp", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local playerTypeSelf = CS.PlayerType.PlayerSelf
local playerTypeLeader = CS.PlayerType.PlayerAllianceLeader
local playerTypeOther = CS.PlayerType.PlayerAlliance
local funInstantiate = CS.UnityEngine.GameObject.Instantiate
local funDestroy = CS.UnityEngine.GameObject.Destroy
local CREATE_SPEED = 1

function WorldMiniMapComp:OnCreate()
  base.OnCreate(self)
  self.otherPointsCreated = {}
  self.otherPositions = {}
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshCityPoints()
  self:SetZoomPosAndSize(true)
  SceneUtils.WorldSendGetALPointsRequest()
end

function WorldMiniMapComp:OnDestroy()
  self:ClearDynamicCreated()
  self:DataDestroy()
  self:ComponentDestroy()
  self.otherPointsCreated = nil
  self.otherPositions = nil
  base.OnDestroy(self)
end

function WorldMiniMapComp:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compArea = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
  self.compLayout = self.viewSkin:AddComponent(self, UIBaseContainer, 2)
  self.btnClickJump = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnClickJump:SetOnClick(function()
    self:OnBtnClickJumpClick()
  end)
  self.compMemberPoint = self.viewSkin:AddComponent(self, UIBaseComponent, 4)
  self.compLeaderPoint = self.viewSkin:AddComponent(self, UIBaseComponent, 5)
  self.compSelfPoint = self.viewSkin:AddComponent(self, UIBaseComponent, 6)
  self.bg = self:AddComponent(UIImage, "")
  self.compSelfPoint:SetActive(true)
  self.compLeaderPoint:SetActive(true)
  self.compMemberPoint:SetActive(true)
  self:SetPointInvisible(self.compMemberPoint.rectTransform)
end

function WorldMiniMapComp:ComponentDestroy()
  self.viewSkin = nil
  self.compArea = nil
  self.compLayout = nil
  self.btnClickJump = nil
  self.compMemberPoint = nil
  self.compLeaderPoint = nil
  self.compSelfPoint = nil
end

function WorldMiniMapComp:DataDefine()
  self.bg:LoadSprite("Assets/Main/Sprites/LodIcon/UIditu_img_map.png")
  self.mapScale = 0.198
  self.deltaSize = 0
  self.mapDelta = 0
  self.mapSize = 198
  self.screenX = CS.UnityEngine.Screen.width
  self.screenY = CS.UnityEngine.Screen.height
  self.lastZoom = 0
  self.zoomXSize = 0
  self.zoomYSize = 0
  if not self.updateTimer then
    function self.updateTimer()
      self:OnUpdate()
    end
    
    UpdateManager:GetInstance():AddUpdate(self.updateTimer)
  end
end

function WorldMiniMapComp:DataDestroy()
  if self.updateTimer ~= nil then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.updateTimer = nil
  end
  self.mapScale = nil
  self.deltaSize = nil
  self.mapDelta = nil
  self.mapSize = nil
  self.screenX = nil
  self.screenY = nil
  self.lastZoom = nil
  self.zoomXSize = nil
  self.zoomYSize = nil
end

function WorldMiniMapComp:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UPDATE_POINTS_DATA, self.RefreshCityPoints)
  self:AddUIListener(EventId.WORLD_CAMERA_CHANGE_POINT, self.RefreshCameraPoint)
  self:AddUIListener(EventId.OnWorldAlliancePointsRefresh, self.RefreshCityPoints)
end

function WorldMiniMapComp:OnRemoveListener()
  self:RemoveUIListener(EventId.UPDATE_POINTS_DATA, self.RefreshCityPoints)
  self:RemoveUIListener(EventId.WORLD_CAMERA_CHANGE_POINT, self.RefreshCameraPoint)
  self:RemoveUIListener(EventId.OnWorldAlliancePointsRefresh, self.RefreshCityPoints)
  base.OnRemoveListener(self)
end

function WorldMiniMapComp:LegacyGetCityPointDataFast()
  local selfPos, leaderPos
  local list = CS.SceneManager.World:GetAllMainBaseListByType(CS.PlayerType.PlayerSelf, CS.PlayerType.PlayerAlliance, CS.PlayerType.PlayerAllianceLeader)
  if list ~= nil then
    WorldBattleUtil.StartRecordPointInfo(86)
    for k, v in pairs(list) do
      local pType = v:GetPlayerType()
      local mainIndex = v.mainIndex
      if pType == playerTypeSelf then
        selfPos = SceneUtils.IndexToTilePos(mainIndex, ForceChangeScene.World)
      elseif pType == playerTypeLeader then
        leaderPos = SceneUtils.IndexToTilePos(mainIndex, ForceChangeScene.World)
      elseif pType == playerTypeOther then
        local pos = SceneUtils.IndexToTilePos(mainIndex, ForceChangeScene.World)
        WorldBattleUtil.RecordPos(pos)
      end
    end
  end
  local otherPosList = {}
  WorldBattleUtil.GetRecordPosList(otherPosList)
  local legacyCount = self.otherPositions and #self.otherPositions or 0
  local otherChanged = legacyCount ~= #otherPosList
  if otherChanged then
    self.otherPositions = otherPosList
  end
  return selfPos, leaderPos, otherChanged
end

function WorldMiniMapComp:NewGetCityPointDataFast()
  local selfPos, leaderPos
  if SceneUtils.GetIsInWorld() then
    local scene = CS.SceneManager.World
    if not scene then
      return
    end
    local mainIndex = LuaEntry.Player:GetMainWorldPos()
    local myServer = LuaEntry.Player:GetSelfServerId()
    if LuaEntry.Player:IsInSelfServer() then
      selfPos = SceneUtils.IndexToTilePos(mainIndex, ForceChangeScene.World)
    end
    local _serverID, _pos = 0, 0
    local leader, members = scene:GetALMemberPoints()
    if 0 < leader and not DataCenter.AllianceBaseDataManager:IsSelfLeader() then
      _serverID, _pos = SceneUtils.DecodeWorldPos(leader)
      leaderPos = SceneUtils.IndexToTilePos(_pos, ForceChangeScene.World)
    end
    WorldBattleUtil.StartRecordPointInfo(86)
    if members then
      local memberCount = members.Count
      if 0 < memberCount then
        for i = 0, memberCount - 1 do
          local mb = members[i]
          if mb ~= leader then
            _serverID, _pos = SceneUtils.DecodeWorldPos(mb)
            if _serverID ~= myServer or _pos ~= mainIndex then
              local pos = SceneUtils.IndexToTilePos(_pos, ForceChangeScene.World)
              WorldBattleUtil.RecordPos(pos)
            end
          end
        end
      end
    end
  end
  local otherPosList = {}
  WorldBattleUtil.GetRecordPosList(otherPosList)
  local legacyCount = self.otherPositions and #self.otherPositions or 0
  local otherChanged = legacyCount ~= #otherPosList
  if otherChanged then
    self.otherPositions = otherPosList
  end
  return selfPos, leaderPos, otherChanged
end

function WorldMiniMapComp:CreateOtherPoint()
  if not self.compMemberPoint or not self.compLayout then
    return
  end
  local rect = funInstantiate(self.compMemberPoint.rectTransform, self.compLayout.transform)
  rect.transform.localScale = ResetScale
  rect.gameObject:SetActive(true)
  table.insert(self.otherPointsCreated, rect)
  return rect
end

function WorldMiniMapComp:SetPointPos(rectTransform, worldPos)
  local tempX = worldPos.x
  if CommonUtil.IsArabicAutoMirrorOpen() then
    tempX = self.mapSize / self.mapScale - tempX
  end
  rectTransform:Set_anchoredPosition(tempX * self.mapScale * CommonUtil.ArabicAutoMirrorFactor(), worldPos.y * self.mapScale)
end

function WorldMiniMapComp:SetPointInvisible(rectTransform)
  rectTransform:Set_anchoredPosition(99999, 99999)
end

function WorldMiniMapComp:RefreshOtherPosition(startIndex)
  local max = Mathf.Max(#self.otherPositions, #self.otherPointsCreated)
  local dirty = false
  for i = startIndex, max do
    local pos = self.otherPositions[i]
    local rectTransform = self.otherPointsCreated[i]
    if not pos then
      if rectTransform then
        self:SetPointInvisible(rectTransform)
      end
    elseif not rectTransform then
      return
    else
      self:SetPointPos(rectTransform, pos)
    end
    dirty = true
  end
  if dirty then
    self.compLeaderPoint.transform:SetAsLastSibling()
    self.compSelfPoint.transform:SetAsLastSibling()
  end
end

function WorldMiniMapComp:RefreshCityPoints()
  if LuaEntry.Player:GetCurWorldId() > 0 then
    return
  end
  local selfPos, leaderPos, otherChanged = 0, 0, false
  if SceneUtils.CheckNewAllianceMemberSwitch() then
    selfPos, leaderPos, otherChanged = self:NewGetCityPointDataFast()
  else
    selfPos, leaderPos, otherChanged = self:LegacyGetCityPointDataFast()
  end
  if leaderPos then
    self:SetPointPos(self.compLeaderPoint.rectTransform, leaderPos)
  else
    self:SetPointInvisible(self.compLeaderPoint.rectTransform)
  end
  if selfPos then
    self:SetPointPos(self.compSelfPoint.rectTransform, selfPos)
  else
    self:SetPointInvisible(self.compSelfPoint.rectTransform)
  end
  if otherChanged then
    self:RefreshOtherPosition(1)
  end
end

function WorldMiniMapComp:OnBtnClickJumpClick()
  local screenPos = CS.UnityEngine.Input.mousePosition
  local worldP = CS.GameEntry.UICamera:ScreenToWorldPoint(screenPos)
  local localP = self.btnClickJump.transform:InverseTransformPoint(worldP)
  if CommonUtil.IsArabicAutoMirrorOpen() then
    localP.x = -self.mapSize - localP.x
  end
  local x = localP.x / self.mapSize * WorldTileCount + self.mapDelta
  local y = localP.y / self.mapSize * WorldTileCount + self.mapDelta
  local target = Vector3.New(x * TileSize * CommonUtil.ArabicAutoMirrorFactor(), 0, y * TileSize)
  if BattleFieldUtil.InBattleField() then
    GoToUtil.GotoDragonPos(target, -1, LookAtFocusTime, function()
    end, LuaEntry.Player:GetCrossServerId(), LuaEntry.Player:GetCurWorldId())
  else
    GoToUtil.GotoPos(target, -1, LookAtFocusTime, nil, LuaEntry.Player:GetCurServerId())
  end
end

function WorldMiniMapComp:RefreshCameraPoint()
  self:SetZoomPosAndSize(true)
end

function WorldMiniMapComp:SetZoomPosAndSize(needChangeSize)
  if needChangeSize then
    local maxV3 = {}
    maxV3.x = self.screenX
    maxV3.y = self.screenY
    maxV3.z = 0
    local maxPos = CS.SceneManager.World:ScreenPointToWorld(maxV3)
    local maxV2
    if SeasonUtil.GetSeasonType() == SeasonMapType.NineNation then
      maxV2 = SceneUtils.WorldToUniqueTile(maxPos)
      maxV2.x = Mathf.Clamp(maxV2.x, 0, 3000)
      maxV2.y = Mathf.Clamp(maxV2.y, 0, 3000)
    else
      maxV2 = SceneUtils.WorldToTile(maxPos, ForceChangeScene.World)
      maxV2.x = Mathf.Clamp(maxV2.x, 0, WorldTileCount)
      maxV2.y = Mathf.Clamp(maxV2.y, 0, WorldTileCount)
    end
    local minV3 = {}
    minV3.x = 0
    minV3.y = 0
    minV3.z = 0
    local minPos = CS.SceneManager.World:ScreenPointToWorld(minV3)
    local minV2 = SceneUtils.WorldToTile(minPos, ForceChangeScene.World)
    if SeasonUtil.GetSeasonType() == SeasonMapType.NineNation then
      minV2 = SceneUtils.WorldToUniqueTile(minPos)
      minV2.x = Mathf.Clamp(minV2.x, 0, 3000)
      minV2.y = Mathf.Clamp(minV2.y, 0, 3000)
    else
      minV2 = SceneUtils.WorldToTile(minPos, ForceChangeScene.World)
      minV2.x = Mathf.Clamp(minV2.x, 0, WorldTileCount)
      minV2.y = Mathf.Clamp(minV2.y, 0, WorldTileCount)
    end
    self.zoomXSize = (maxV2.x - minV2.x) * self.mapScale
    self.zoomYSize = (maxV2.y - minV2.y) * self.mapScale
    local v2 = {}
    v2.x = self.zoomXSize
    v2.y = self.zoomYSize
    self.compArea:SetSizeDelta(v2)
  end
  local targetV3 = CS.SceneManager.World.CurTarget
  local curV2 = SceneUtils.WorldToTile(targetV3, ForceChangeScene.World)
  local realV2 = {}
  local tempX = (curV2.x - self.mapDelta) * self.mapScale - self.zoomXSize / 2
  local tempY = (curV2.y - self.mapDelta) * self.mapScale - self.zoomYSize / 2
  local checkX = math.min(tempX, self.mapSize - self.zoomXSize)
  local checkY = math.min(tempY, self.mapSize - self.zoomYSize)
  local x = math.min(math.max(checkX, 0), self.mapSize)
  local y = math.min(math.max(checkY, 0), self.mapSize)
  realV2.x = x + self.deltaSize
  realV2.y = y + self.deltaSize
  if CommonUtil.IsArabicAutoMirrorOpen() then
    realV2.x = self.mapSize - realV2.x - self.compArea:GetSizeDelta().x
  end
  self.compArea:SetAnchoredPositionXY(realV2.x, realV2.y)
end

function WorldMiniMapComp:OnUpdate()
  local theWorld = CS.SceneManager.World
  if theWorld == nil then
    return
  end
  local zoom = theWorld:GetLodDistance()
  if Mathf.Abs(self.lastZoom - zoom) > 10 then
    self:SetZoomPosAndSize(true)
    self.lastZoom = zoom
  end
  local posCount = #self.otherPositions
  local instCount = #self.otherPointsCreated
  if posCount > instCount then
    local createCount = Mathf.Min(posCount - instCount, CREATE_SPEED)
    for i = 1, createCount do
      self:CreateOtherPoint()
    end
    self:RefreshOtherPosition(instCount)
  end
end

function WorldMiniMapComp:ClearDynamicCreated()
  local ct = #self.otherPointsCreated
  if 0 < ct then
    for k, v in ipairs(self.otherPointsCreated) do
      funDestroy(v.gameObject)
    end
  end
  self.otherPointsCreated = nil
end

return WorldMiniMapComp
