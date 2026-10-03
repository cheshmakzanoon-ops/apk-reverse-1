local base = UIAsyncContainer
local BattlefieldMiniMap = BaseClass("BattlefieldMiniMap", base)
local ResourceManager = CS.GameEntry.Resource
local RectTransform = typeof(CS.UnityEngine.RectTransform)
local UnityImage = typeof(CS.UnityEngine.UI.Image)
local TypeSuperTextMesh = typeof(CS.SuperTextMesh)
local TypeSpriteRenderer = typeof(CS.UnityEngine.SpriteRenderer)
local area_path = "area"
local layout_path = "layout"
local layout1_path = "layout1"
local layout1_build_path = "layout1/build"
local click_jump_path = "click_jump"
local bg_path = "bg"
local jifen_path = "jifen"
local bg2_path = "bg2"
local left_tip_path = "bg2/LeftTip"
local time_txt_path = "bg2/TimeTxt"
local TemplateMgr = DataCenter.BattlefieldDsbDuelTemplateManager

function BattlefieldMiniMap:OnCreate()
  base.OnCreate(self)
  self.lastZoom = 1
  self.zoomXSize = 1
  self.zoomYSize = 1
  self.screenX = CS.UnityEngine.Screen.width
  self.screenY = CS.UnityEngine.Screen.height
  self.list = {}
  self.resPointList = {}
  self.stateList = {}
  self.resImg = {}
  local mgr = BattleFieldUtil.GetTemplateMgrActive()
  self.dropList = mgr and mgr:GetALLTime()
  self:ComponentDefine()
  self:ReInit()
end

function BattlefieldMiniMap:OnDestroy()
  self.area = nil
  self.list = {}
  self.nodeList = {}
  self.resPointList = {}
  self.stateList = {}
  self.resImg = {}
  self.dropList = nil
  self.theItem:GameObjectRecycleAll()
  self.theJifen:GameObjectRecycleAll()
  if self.BuildAnimRequest then
    for k, v in pairs(self.BuildAnimRequest) do
      v:Destroy()
    end
    self.BuildAnimRequest = nil
  end
  base.OnDestroy(self)
end

function BattlefieldMiniMap:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.WORLD_CAMERA_CHANGE_POINT, self.RefreshCameraPoint)
  self:AddUIListener(EventId.UPDATE_POINTS_DATA, self.ShowCityPoint)
  self:AddUIListener(EventId.DragonBuildingChange, self.OnDragonBuildingChange)
  self:AddUIListener(EventId.WinterStormEntityUpdate, self.OnBuildingChange)
  self:AddUIListener(EventId.DragonScoreExplode, self.OnDragonScoreExplode)
  self:AddUIListener(EventId.SingleMarchStateUpdate, self.OnSingleMarchStateUpdate)
end

function BattlefieldMiniMap:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.WORLD_CAMERA_CHANGE_POINT, self.RefreshCameraPoint)
  self:RemoveUIListener(EventId.UPDATE_POINTS_DATA, self.ShowCityPoint)
  self:RemoveUIListener(EventId.DragonBuildingChange, self.OnDragonBuildingChange)
  self:RemoveUIListener(EventId.WinterStormEntityUpdate, self.OnBuildingChange)
  self:RemoveUIListener(EventId.DragonScoreExplode, self.OnDragonScoreExplode)
  self:RemoveUIListener(EventId.SingleMarchStateUpdate, self.OnSingleMarchStateUpdate)
end

function BattlefieldMiniMap:ComponentDefine()
  self.area = self:AddComponent(UIBaseContainer, area_path)
  self.layout = self:AddComponent(UIBaseContainer, layout_path)
  self.layout1 = self:AddComponent(UIBaseContainer, layout1_path)
  self.bgBtn = self:AddComponent(UIButton, bg_path)
  self.bgBtn:SetOnClick(function()
    self:OnMapShowClick()
  end)
  self.click_jump = self:AddComponent(UIButton, click_jump_path)
  self.click_jump:SetOnClick(function()
    self:OnMapClick()
  end)
  self.theItem = self.transform:Find(layout1_build_path).gameObject
  self.theItem:GameObjectCreatePool()
  self.theJifen = self.transform:Find(jifen_path).gameObject
  self.theJifen:GameObjectCreatePool()
  self.air_drop_bg = self:AddComponent(UIBaseContainer, bg2_path)
  self.air_drop_text = self:AddComponent(UIText, time_txt_path)
  self.air_drop_img = self:AddComponent(UIImage, left_tip_path)
  self.layoutWidth = self.layout1:GetSizeDelta().x
end

function BattlefieldMiniMap:ReInit()
  local rectSize = self:GetSizeDelta()
  self.mapSize = rectSize.x
  local baseConfig = BattleFieldUtil.GetCurrentBaseConfig()
  self.renderScale = 0.85
  if baseConfig then
    self.tileCount = baseConfig.BattlefieldSize[1] * self.renderScale
    self.mapScale = self.mapSize / self.tileCount
    self.mapDelta = (1000 - self.tileCount) / 2
  else
    self.mapScale = 1
    self.mapDelta = 400
    self.tileCount = 200
  end
  self:SetZoomPosAndSize(true)
  self:ShowCityPoint(true)
end

function BattlefieldMiniMap:RefreshCameraPoint()
  self:SetZoomPosAndSize(true)
end

function BattlefieldMiniMap:Update1000MS()
  if CS.SceneManager.World == nil or not CS.SceneManager:IsInWorld() then
    return
  end
  if self.showCityPointDirty then
    self:ShowCityPoint(true)
    self.showCityPointDirty = false
  end
  local zoom = CS.SceneManager.World:GetLodDistance()
  if Mathf.Abs(self.lastZoom - zoom) > 10 then
    self:SetZoomPosAndSize(true)
    self.lastZoom = zoom
  end
  local LockBuilding = self.LockBuilding
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if LockBuilding ~= nil then
    local nodeList = self.nodeList or {}
    local tickCount = 0
    for mainIndex, openTime in pairs(LockBuilding) do
      if openTime <= curTime then
        local goItem = nodeList[mainIndex]
        if goItem ~= nil then
          self:PlayStateChangeAnim(goItem)
        end
      else
        tickCount = tickCount + 1
      end
    end
    if tickCount == 0 then
      self.LockBuilding = nil
    end
  end
  local tipTemplate
  local remainTime = 0
  local mgr = BattleFieldUtil.GetMgrActive()
  local sTime = mgr and mgr:GetBattleStartTimeSec() or 0
  if sTime ~= 0 then
    local curSec = UITimeManager:GetInstance():GetServerSeconds()
    local preTime = 2
    for _, v in ipairs(self.dropList) do
      local rTime = sTime + v.trigger_time
      local stTime = rTime - v.alert_time
      if curSec == stTime then
        EventManager:GetInstance():Broadcast(EventId.DragonNoticeShow, {config = v, actTime = preTime})
      elseif curSec >= stTime + preTime and curSec < rTime then
        tipTemplate = v
        remainTime = rTime - curSec
      end
    end
  end
  self.air_drop_bg:SetActive(tipTemplate ~= nil)
  if tipTemplate ~= nil then
    self.air_drop_text:SetText(remainTime)
    if self.curId ~= tipTemplate.id then
      self.curId = tipTemplate.id
      if not string.IsNullOrEmpty(tipTemplate.icon) then
        self.air_drop_img:SetActive(true)
        self.air_drop_img:LoadSpriteAsyncWithCallback(string.format(LoadPath.LWBattleFieldDsbDuelDetailPath, tipTemplate.icon), function()
          if self.air_drop_img then
            self.air_drop_img:SetNativeSize()
          end
        end)
      else
        self.air_drop_img:SetActive(false)
      end
    end
  end
end

function BattlefieldMiniMap:OnMapClick(param)
  local screenPos = CS.UnityEngine.Input.mousePosition
  local worldP = CS.GameEntry.UICamera:ScreenToWorldPoint(screenPos)
  local localP = self.click_jump.transform:InverseTransformPoint(worldP)
  local zoom = CS.SceneManager.World.Zoom
  local x = localP.x / self.mapSize * self.tileCount
  local y = localP.y / self.mapSize * self.tileCount
  local target = Vector3.New((x + 500) * TileSize + 1, 0, (y + 500) * TileSize + 1)
  local mgr = BattleFieldUtil.GetMgrActive()
  if mgr then
    target = mgr:GetClosestPos(target)
    GoToUtil.GotoDragonPos(target, zoom, LookAtFocusTime, nil, LuaEntry.Player:GetCrossServerId(), LuaEntry.Player:GetCurWorldId())
  end
end

function BattlefieldMiniMap:SetZoomPosAndSize(needChangeSize)
  if self.area == nil or IsNull(self.area.rectTransform) or CS.SceneManager.World == nil or not CS.SceneManager:IsInWorld() then
    return
  end
  if needChangeSize then
    local maxV3 = {}
    maxV3.x = self.screenX
    maxV3.y = self.screenY
    maxV3.z = 0
    local maxPos = CS.SceneManager.World:ScreenPointToWorld(maxV3)
    local maxV2 = SceneUtils.WorldToTile(maxPos, ForceChangeScene.World)
    maxV2.x = Mathf.Clamp(maxV2.x - self.mapDelta, 0, self.tileCount)
    maxV2.y = Mathf.Clamp(maxV2.y - self.mapDelta, 0, self.tileCount)
    local minV3 = {}
    minV3.x = 0
    minV3.y = 0
    minV3.z = 0
    local minPos = CS.SceneManager.World:ScreenPointToWorld(minV3)
    local minV2 = SceneUtils.WorldToTile(minPos, ForceChangeScene.World)
    minV2.x = Mathf.Clamp(minV2.x - self.mapDelta, 0, self.tileCount)
    minV2.y = Mathf.Clamp(minV2.y - self.mapDelta, 0, self.tileCount)
    self.zoomXSize = (maxV2.x - minV2.x) * self.mapScale
    self.zoomYSize = (maxV2.y - minV2.y) * self.mapScale
    self.zoomXSize = math.max(16, math.min(self.zoomXSize, 25))
    self.zoomYSize = math.max(30, math.min(self.zoomYSize, 40))
    local v2 = {}
    v2.x = self.zoomXSize
    v2.y = self.zoomYSize
    self.area:SetSizeDelta(v2)
  end
  local targetV3 = CS.SceneManager.World.CurTarget
  local curV2 = SceneUtils.WorldToTile(targetV3, ForceChangeScene.World)
  local realV2 = {}
  local tempX = (curV2.x - self.mapDelta) * self.mapScale - self.zoomXSize / 2
  local tempY = (curV2.y - self.mapDelta) * self.mapScale - self.zoomYSize / 2
  local deltaSize = 0
  local checkX = math.min(tempX, self.mapSize - self.zoomXSize)
  local checkY = math.min(tempY, self.mapSize - self.zoomYSize)
  local x = math.min(math.max(checkX, 0), self.mapSize)
  local y = math.min(math.max(checkY, 0), self.mapSize)
  realV2.x = x + deltaSize
  realV2.y = y + deltaSize
  if CommonUtil.IsArabicAutoMirrorOpen() then
    realV2.x = self:GetSizeDelta().x - realV2.x - self.area:GetSizeDelta().x
  end
  self.area:SetAnchoredPositionXY(realV2.x, realV2.y)
end

function BattlefieldMiniMap:OnDragonScoreExplode(data)
  if data == nil or data.mainPoint == nil then
    return
  end
  local nodeList = self.nodeList or {}
  local goItem = nodeList[data.mainPoint]
  if goItem ~= nil and data.mainPoint ~= nil and data.scorePoints ~= nil then
    local posFrom = SceneUtils.IndexToTilePos(data.mainPoint, ForceChangeScene.World)
    for i, mainIndex in ipairs(data.scorePoints) do
      local posTo = SceneUtils.IndexToTilePos(mainIndex, ForceChangeScene.World)
      local effectItem = self.theJifen:GameObjectSpawn(self.layout1.transform)
      local jifen_particle = effectItem.transform:GetComponent(typeof(CS.UnityEngine.ParticleSystem))
      if jifen_particle ~= nil then
        effectItem.name = tostring(mainIndex)
        effectItem:SetActive(true)
        effectItem.transform:Set_localPosition((posFrom.x - 500) * self.mapScale, (posFrom.y - 500) * self.mapScale, 0)
        jifen_particle.gameObject:SetActive(true)
        jifen_particle:Play()
        local sequence = CS.DG.Tweening.DOTween.Sequence()
        sequence:Join(effectItem.transform:DOLocalMove(Vector3.New((posTo.x - 500) * self.mapScale, (posTo.y - 500) * self.mapScale, 0), 0.5):SetEase(CS.DG.Tweening.Ease.OutCirc))
        sequence:AppendCallback(function()
          effectItem:GameObjectRecycle()
        end)
      else
        effectItem:GameObjectRecycle()
      end
    end
  end
end

function BattlefieldMiniMap:OnBuildingChange(pointIndex)
  local theWorld = CS.SceneManager.World
  if theWorld == nil or not BattleFieldUtil.InBattleField() then
    return
  end
  local nodeList = self.nodeList or {}
  local pointInfo = theWorld:GetPointInfo(pointIndex)
  if pointInfo ~= nil then
    local goItem = nodeList[pointIndex]
    local curState = self.stateList[pointIndex]
    if IsNotNull(goItem) and curState ~= nil then
      local _, state = TemplateMgr:GetMiniMapSpritePathByBuildId(pointInfo.detail)
      if curState ~= state then
        self:PlayStateChangeAnim(goItem)
        self.stateList[pointIndex] = state
      end
    end
  end
end

function BattlefieldMiniMap:OnDragonBuildingChange(data)
  if data == nil or data.pointId == nil then
    return
  end
  local nodeList = self.nodeList or {}
  local goItem = nodeList[data.pointId]
  if goItem ~= nil and data.newAllianceId ~= nil and data.newAllianceId ~= "" then
    self:PlayStateChangeAnim(goItem)
  end
end

function BattlefieldMiniMap:PlayStateChangeAnim(goItem)
  local effect_particle = goItem.transform:Find("tishi"):GetComponent(typeof(CS.UnityEngine.ParticleSystem))
  if effect_particle ~= nil then
    effect_particle.gameObject:SetActive(true)
    effect_particle:Play()
    local sequence = CS.DG.Tweening.DOTween.Sequence()
    sequence:AppendInterval(0.7)
    sequence:AppendCallback(function()
      effect_particle:Stop()
      effect_particle:Play()
    end)
    sequence:AppendInterval(1.0)
    sequence:AppendCallback(function()
      if effect_particle ~= nil and effect_particle.gameObject ~= nil and not IsNull(effect_particle.gameObject) then
        effect_particle.gameObject:SetActive(false)
      end
    end)
  end
end

function BattlefieldMiniMap:CanRefresh(forceRefresh)
  local lastTime = self.lastRefreshTime or 0
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local canRefresh = forceRefresh or 1000 < curTime - lastTime
  if canRefresh then
    self.lastRefreshTime = curTime
  end
  return canRefresh
end

function BattlefieldMiniMap:ConvertMiniMapPos(x, y)
  local safe = 8
  local _x = (x - self.mapDelta) * self.mapScale
  local _y = (y - self.mapDelta) * self.mapScale
  _x = Mathf.Clamp(_x, safe, self.mapSize - safe)
  _y = Mathf.Clamp(_y, safe, self.mapSize - safe)
  _x = _x - self.mapSize * (CommonUtil.IsArabicAutoMirrorOpen() and 1 or 0)
  return _x, _y, 0
end

function BattlefieldMiniMap:ShowCityPoint(forceRefresh)
  if CS.SceneManager.World == nil or not CS.SceneManager:IsInWorld() then
    return
  end
  if not BattleFieldUtil.InBattleField() then
    return
  end
  if not self:CanRefresh(forceRefresh) then
    self.showCityPointDirty = true
    return
  end
  self.showCityPointDirty = false
  ProfilerUtil.BeginSample("BattlefieldMiniMap.ShowCityPoint")
  local theWorld = CS.SceneManager.World
  local nodeList = self.nodeList or {}
  local zoom = 1
  local myAllianceId = LuaEntry.Player.allianceId
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local list = theWorld:GetAllDragonPointList()
  BattleFieldUtil.StartRecordPointInfo(15)
  local resConfig, goItem, unity_image
  local updateKey = {}
  self.LockBuilding = nil
  if list ~= nil then
    for k, v in pairs(list) do
      zoom = 1.15
      local detailInfo = v.detail
      if detailInfo ~= nil then
        local buildId = detailInfo.BuildId or detailInfo.ItemId
        local config = BattleFieldUtil.GetBattlefieldBuildTemplate(buildId)
        if config:IsRes() then
          resConfig = config
          BattleFieldUtil.RecordPointInfo(v)
        else
          local pos = SceneUtils.IndexToTilePos(v.mainIndex, ForceChangeScene.World)
          local nodeKey = v.mainIndex
          goItem = nodeList[nodeKey]
          if goItem == nil then
            self.resImg[nodeKey] = nil
            goItem = self.theItem:GameObjectSpawn(self.layout1.transform)
            goItem.name = nodeKey
            nodeList[nodeKey] = goItem
          end
          if config:IsScoreBox() then
            zoom = 0.5
          end
          if not IsNull(goItem) and goItem.transform then
            updateKey[nodeKey] = 1
            goItem:SetActive(true)
            goItem.transform:Set_localScale(zoom, zoom, zoom)
            goItem:GetComponent(RectTransform):Set_localPosition(self:ConvertMiniMapPos(pos.x, pos.y))
            unity_image = goItem:GetComponent(UnityImage)
          end
          if unity_image then
            if config:IsScoreBox() and detailInfo.Score ~= nil then
              local old = self.resPointList[nodeKey]
              self.resPointList[nodeKey] = {
                score = math.floor(detailInfo.Score or 0),
                isMine = false
              }
              if old then
                self.resPointList[nodeKey].isMine = old.isMine
              end
            end
            if detailInfo.State == 0 and curTime < detailInfo.OpenTime then
              if self.LockBuilding == nil then
                self.LockBuilding = {}
              end
              self.LockBuilding[v.mainIndex] = detailInfo.OpenTime
            end
            local sprite_path, state = TemplateMgr:GetMiniMapSpritePathByBuildId(detailInfo)
            if not string.IsNullOrEmpty(sprite_path) and self.resImg[nodeKey] ~= sprite_path then
              local img = unity_image
              img:LoadSpriteAuto(sprite_path, function()
                if IsNotNull(img) then
                  img:Set_color(1, 1, 1, 1)
                  img:SetNativeSize()
                end
              end)
              self.resImg[nodeKey] = sprite_path
              self.stateList[nodeKey] = state
            end
          end
        end
      end
    end
  end
  if resConfig then
    local resPoints = {}
    zoom = 0.5
    BattleFieldUtil.GetRecordPointInfos(resPoints)
    if 0 < #resPoints then
      for k, info in ipairs(resPoints) do
        local v = info.pointInfo
        local pos = info.pos
        local nodeKey = v.mainIndex
        goItem = nodeList[nodeKey]
        if goItem == nil then
          self.resImg[nodeKey] = nil
          goItem = self.theItem:GameObjectSpawn(self.layout1.transform)
          goItem.name = nodeKey
          nodeList[nodeKey] = goItem
        end
        if not IsNull(goItem) and goItem.transform then
          updateKey[nodeKey] = 1
          goItem:SetActive(true)
          goItem.transform:Set_localScale(zoom, zoom, zoom)
          goItem:GetComponent(RectTransform):Set_localPosition(self:ConvertMiniMapPos(pos.x, pos.y))
          unity_image = goItem:GetComponent(UnityImage)
        end
        if unity_image then
          local detailInfo = v.detail
          if detailInfo.State == 0 and curTime < detailInfo.OpenTime then
            if self.LockBuilding == nil then
              self.LockBuilding = {}
            end
            self.LockBuilding[v.mainIndex] = detailInfo.OpenTime
          end
          local sprite_path = TemplateMgr:GetMiniMapSpritePathByBuildId(detailInfo)
          if not string.IsNullOrEmpty(sprite_path) and self.resImg[nodeKey] ~= sprite_path then
            local img = unity_image
            img:LoadSpriteAuto(sprite_path, function()
              if IsNotNull(img) then
                img:Set_color(1, 1, 1, 1)
                img:SetNativeSize()
              end
            end)
            self.resImg[nodeKey] = sprite_path
          end
        end
      end
    end
  end
  local cityList = theWorld:GetAllMainBaseList()
  if cityList ~= nil then
    zoom = 0.6
    for k, v in pairs(cityList) do
      local state = v:GetPlayerType()
      if state == CS.PlayerType.PlayerSelf then
        local mainIndex = LuaEntry.Player:GetBattleFieldPos()
        if mainIndex ~= v.mainIndex then
          LuaEntry.Player:SetBattleFieldPointId(v.mainIndex)
          GoToUtil.GotoDragonBuildPos()
        end
        zoom = 0.8
        local pos = SceneUtils.IndexToTilePos(v.mainIndex, ForceChangeScene.World)
        local nodeKey = v.uuid
        goItem = nodeList[nodeKey]
        if goItem == nil then
          goItem = self.theItem:GameObjectSpawn(self.layout1.transform)
          goItem.name = nodeKey
          local img = goItem:GetComponent(UnityImage)
          img:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldPath, "zyf_xiaoditu_zhucheng_1"), function()
            if IsNotNull(img) then
              img:Set_color(1, 1, 1, 1)
              img:SetNativeSize()
            end
          end)
          nodeList[nodeKey] = goItem
        end
        if not IsNull(goItem) and goItem.transform then
          updateKey[nodeKey] = 1
          goItem:SetActive(true)
          goItem.transform:Set_localScale(zoom, zoom, zoom)
          goItem:GetComponent(RectTransform):Set_localPosition(self:ConvertMiniMapPos(pos.x, pos.y))
        end
      end
    end
  end
  self.nodeList = nodeList
  local dirtyList = {}
  for nodeKey, _ in pairs(nodeList) do
    if updateKey[nodeKey] ~= 1 then
      table.insert(dirtyList, nodeKey)
      local info = self.resPointList[nodeKey]
      if info ~= nil and info.score ~= 0 then
        self:playResAnim(nodeKey, info.score, info.isMine)
        self.resPointList[nodeKey] = nil
        self.resImg[nodeKey] = nil
      end
    end
  end
  for _, nodeKey in ipairs(dirtyList) do
    goItem = nodeList[nodeKey]
    if goItem ~= nil and not IsNull(goItem) then
      goItem:GameObjectRecycle()
    end
    nodeList[nodeKey] = nil
    self.resImg[nodeKey] = nil
  end
  ProfilerUtil.EndSample()
end

function BattlefieldMiniMap:OnSingleMarchStateUpdate(marchUuid)
  if self.resPointList ~= nil then
    local march = DataCenter.WorldMarchDataManager:GetMarch(marchUuid)
    if march ~= nil and march:GetMarchTargetType() == MarchTargetType.PIC_EPIDEMIC_SCORE then
      local info = self.resPointList[march.targetPos]
      if info ~= nil and info.score ~= 0 then
        info.isMine = march.allianceUid == LuaEntry.Player.allianceId
      end
    end
  end
end

function BattlefieldMiniMap:playResAnim(mainIndex, pointCount, isMine)
  if CS.SceneManager.World == nil or not CS.SceneManager:IsInWorld() then
    return
  end
  local thePoint = toInt(pointCount)
  if thePoint <= 0 or self.BuildAnimRequest and self.BuildAnimRequest[mainIndex] ~= nil then
    return
  end
  local request = ResourceManager:InstantiateAsync("Assets/Main/Prefabs/World/BattleField/BattleFieldResTips.prefab")
  local position = SceneUtils.TileIndexToWorld(mainIndex)
  position.x = position.x + 0.4
  position.y = 0.5
  request:completed("+", function()
    if request.isError then
      return
    end
    local goItem = request.gameObject
    goItem:SetActive(true)
    goItem.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
    goItem.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    goItem.transform.position = position
    local point_flag = goItem.transform:Find("flag"):GetComponent(TypeSpriteRenderer)
    local point_text = goItem.transform:Find("txt"):GetComponent(TypeSuperTextMesh)
    if point_text ~= nil then
      goItem:SetActive(true)
      point_text.text = "+" .. tostring(thePoint)
      if isMine then
        point_text.color32 = Color32.New(21, 170, 223, 255)
      else
        point_text.color32 = Color32.New(245, 60, 61, 255)
      end
      local sequence = CS.DG.Tweening.DOTween.Sequence()
      sequence:Append(goItem.transform:DOLocalMoveY(4, 2))
      sequence:Join(CS.DG.Tweening.DOTween.To(function()
        return 1
      end, function(alpha)
        point_text:SetColorAlpha(alpha)
        point_flag.color = Color.New(1, 1, 1, alpha)
      end, 0.8, 2.0):SetEase(CS.DG.Tweening.Ease.InExpo))
      sequence:AppendCallback(function()
        if self.BuildAnimRequest then
          local req = self.BuildAnimRequest[mainIndex]
          if req ~= nil then
            self.BuildAnimRequest[mainIndex] = nil
            req:Destroy()
          end
        end
      end)
    else
      goItem:SetActive(false)
    end
  end)
  if self.BuildAnimRequest == nil then
    self.BuildAnimRequest = {}
  end
  self.BuildAnimRequest[mainIndex] = request
end

function BattlefieldMiniMap:GetBattlefieldType()
end

function BattlefieldMiniMap:GetMgr()
end

function BattlefieldMiniMap:GetAllBuildTemplates()
end

function BattlefieldMiniMap:OnMapShowClick()
end

function BattlefieldMiniMap:GetDetailPath()
  return ""
end

return BattlefieldMiniMap
