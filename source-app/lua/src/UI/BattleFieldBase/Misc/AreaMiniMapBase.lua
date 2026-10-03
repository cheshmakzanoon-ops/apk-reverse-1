local AreaMiniMapBase = BaseClass("AreaMiniMapBase", UIAsyncContainer)
local base = UIAsyncContainer
local ResourceManager = CS.GameEntry.Resource
local RectTransform = typeof(CS.UnityEngine.RectTransform)
local UnityImage = typeof(CS.UnityEngine.UI.Image)
local TypeSA = typeof(CS.SimpleAnimation)
local typeofPS = typeof(CS.UnityEngine.ParticleSystem)
local TypeSuperTextMesh = typeof(CS.SuperTextMesh)
local TypeSpriteRenderer = typeof(CS.UnityEngine.SpriteRenderer)
local MyFAbs = Mathf.Abs
local MathSqrt = math.sqrt
local MiniZoom = 0.8
local HalfSize = WorldTileCount / 2
local area_path = "area"
local layout_path = "layout"
local layout_build_path = "layout/build"
local click_jump_path = "click_jump"
local jifen_path = "jifen"
local EFF_GROUND_DEF_ANIM_NAME = "Default"
local EFF_GROUND_PATH = "Assets/Main/Prefabs/Effect/BF_Epidemic/Eff_ui_MiniMap_occupied.prefab"
local BASE_PING_MARK_PATH = "Assets/Main/Prefabs/Effect/BattleField/%s.prefab"
local RES_TIP_PREFAB = "Assets/Main/Prefabs/World/BattleField/BattleFieldResTips.prefab"
local IMG_DI_HUI = "mjc_yibianjinqu_xiaoditu_bg0_hui.png"
local IMG_DI_HONG = "mjc_yibianjinqu_xiaoditu_bg0_hong.png"
local IMG_DI_LAN = "mjc_yibianjinqu_xiaoditu_bg0_lan.png"
local IMG_DI_LV = "mjc_yibianjinqu_xiaoditu_bg0_lv.png"

local function closestPointOnRectangle(tilePos, minX, maxX, minY, maxY)
  local closestX = tilePos.x
  local closestY = tilePos.y
  if minX > closestX then
    closestX = minX
  elseif maxX < closestX then
    closestX = maxX
  end
  if minY > closestY then
    closestY = minY
  elseif maxY < closestY then
    closestY = maxY
  end
  return closestX, closestY
end

local function Distance(x1, y1, x2, y2)
  local dx = x2 - x1
  local dy = y2 - y1
  return MathSqrt(dx * dx + dy * dy)
end

local function InRect(localP, pos, w, h)
  local px = pos.x * CommonUtil.ArabicAutoMirrorFactor()
  if localP.x > px - w and localP.x < px + w and localP.y > pos.y - h and localP.y < pos.y + h then
    return true
  end
  return false
end

function AreaMiniMapBase:OnCreate()
  base.OnCreate(self)
  self.lastZoom = 1
  self.alreadyInit = false
  self.resPointList = {}
  self.buildList = {}
  self.groundList = {}
  self.groupEffReqs = {}
  self.nodeList = {}
  self.resImg = {}
  self.stateList = {}
  self.pingReqs = {}
  local bfType = self:GetBfType()
  self.templateMgr = BattleFieldUtil.GetTemplateMgr(bfType)
  self.actMgr = BattleFieldUtil.GetMgr(bfType)
  self.triggerList = self.templateMgr:GetALLTime()
  local allArea = BattleFieldUtil.GetBattleFieldMiniMapArea(bfType)
  for id, v in pairs(allArea) do
    local mainIndex = v.mainIndex
    local name = string.format("ground/ground%d", id)
    if self.transform:Find(name) then
      local ground = self:AddComponent(UIImage, name)
      ground:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldPath, IMG_DI_HUI))
      self.groundList[mainIndex] = ground
      self.buildList[mainIndex] = v
    end
  end
  self:DoBaseGroundSpriteLoad()
  local keys = table.keys(self.groundList)
  table.sort(keys, function(a, b)
    return a < b
  end)
  self.groundKeys = keys
  self.area = self:AddComponent(UIBaseContainer, area_path)
  self.layout = self:AddComponent(UIBaseContainer, layout_path)
  self.click_jump = self:AddComponent(UIButton, click_jump_path)
  self.click_jump:SetOnClick(function()
    self:OnMapClick()
  end)
  self.theItem = self.transform:Find(layout_build_path).gameObject
  self.theItem:GameObjectCreatePool()
  local jifen = self.transform:Find(jifen_path)
  if jifen ~= nil then
    self.theJifen = jifen.gameObject
    self.theJifen:GameObjectCreatePool()
  end
  self:ComponentDefine()
  self:ReInit()
end

function AreaMiniMapBase:OnDestroy()
  self.theItem:GameObjectRecycleAll()
  if self.theJifen ~= nil then
    self.theJifen:GameObjectRecycleAll()
  end
  if self.buildAnimRequest ~= nil then
    for _, v in pairs(self.buildAnimRequest) do
      v:Destroy()
    end
    self.buildAnimRequest = nil
  end
  if self.groupEffReqs then
    for _, v in pairs(self.groupEffReqs) do
      if v ~= nil then
        if v.timer then
          v.timer:Stop()
        end
        if v.request then
          v.request:Destroy()
        end
      end
    end
  end
  self.groupEffReqs = nil
  if self.pingReqs then
    for _, v in pairs(self.pingReqs) do
      if v ~= nil then
        v:Destroy()
      end
    end
  end
  self.pingReqs = nil
  self.nodeList = nil
  self.buildList = nil
  self.groundList = nil
  self.resImg = nil
  self.stateList = nil
  self.triggerList = nil
  self.resPointList = nil
  self.alreadyInit = false
  self.lastZoom = 1
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function AreaMiniMapBase:GetDiName(state)
  if state == 1 then
    return IMG_DI_LAN
  elseif state == -1 then
    return IMG_DI_HONG
  end
  return IMG_DI_LV
end

function AreaMiniMapBase:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.WORLD_CAMERA_CHANGE_POINT, self.RefreshCameraPoint)
  self:AddUIListener(EventId.UPDATE_POINTS_DATA, self.ShowCityPoint)
  self:AddUIListener(EventId.WinterStormEntityUpdate, self.OnBuildingChange)
  self:AddUIListener(EventId.DragonScoreExplode, self.OnDragonScoreExplode)
  self:AddUIListener(EventId.SingleMarchStateUpdate, self.OnSingleMarchStateUpdate)
  self:AddUIListener(EventId.BattleFieldPingAdd, self.OnPingAdd)
end

function AreaMiniMapBase:OnRemoveListener()
  self:RemoveUIListener(EventId.WORLD_CAMERA_CHANGE_POINT, self.RefreshCameraPoint)
  self:RemoveUIListener(EventId.UPDATE_POINTS_DATA, self.ShowCityPoint)
  self:RemoveUIListener(EventId.WinterStormEntityUpdate, self.OnBuildingChange)
  self:RemoveUIListener(EventId.DragonScoreExplode, self.OnDragonScoreExplode)
  self:RemoveUIListener(EventId.SingleMarchStateUpdate, self.OnSingleMarchStateUpdate)
  self:RemoveUIListener(EventId.BattleFieldPingAdd, self.OnPingAdd)
  base.OnRemoveListener(self)
end

function AreaMiniMapBase:SetMain()
  self.soundCheckTime = self.actMgr:PrepareBGM(true)
end

function AreaMiniMapBase:Update1000MS()
  if self:PreUpdate() then
    return
  end
  if CS.SceneManager.World == nil or not CS.SceneManager:IsInWorld() then
    return
  end
  if self.showCityPointDirty then
    self:ShowCityPoint(true)
    self.showCityPointDirty = false
  end
  local zoom = CS.SceneManager.World:GetLodDistance()
  if MyFAbs(self.lastZoom - zoom) > 10 then
    self:SetZoomPosAndSize()
    self.lastZoom = zoom
  end
  local curSec = UITimeManager:GetInstance():GetServerSeconds()
  local soundCheckTime = self.soundCheckTime or -1
  if 0 <= soundCheckTime and curSec >= soundCheckTime then
    self.actMgr:PrepareBGM(true, true)
    self.soundCheckTime = -1
  end
  self:AfterUpdate()
end

function AreaMiniMapBase:ReInit()
  self:SetZoomPosAndSize()
  self:ShowCityPoint(true)
end

function AreaMiniMapBase:RefreshCameraPoint()
  self:SetZoomPosAndSize()
end

function AreaMiniMapBase:SetZoomPosAndSize()
  if CS.SceneManager.World == nil or not CS.SceneManager:IsInWorld() then
    return
  end
  if self.area == nil or IsNull(self.area.rectTransform) then
    return
  end
  local tilePos = SceneUtils.WorldToTile(CS.SceneManager.World.CurTarget)
  local mainIndex = self:GetMiniMapFixPos(tilePos)
  if 0 < mainIndex then
    local ground = self.groundList[mainIndex]
    if ground ~= nil then
      self.area:SetSizeDeltaXY(ground:GetSizeDeltaXY())
      local pos = ground:GetAnchoredPosition()
      self.area:SetAnchoredPosition(pos)
    end
  end
end

function AreaMiniMapBase:BaseMapClick()
  local screenPos = CS.UnityEngine.Input.mousePosition
  local worldP = CS.GameEntry.UICamera:ScreenToWorldPoint(screenPos)
  local localP = self.click_jump.transform:InverseTransformPoint(worldP)
  local target
  for _, mainIndex in pairs(self.groundKeys) do
    target = self:CheckGround(mainIndex, localP)
    if target ~= nil then
      break
    end
  end
  if target ~= nil then
    GoToUtil.GotoDragonPos(target, CS.SceneManager.World.Zoom, LookAtFocusTime, nil, LuaEntry.Player:GetCrossServerId(), LuaEntry.Player:GetCurWorldId())
  else
    ActEpidemicUtils.Tips("\231\130\185\229\135\187\229\156\176\229\155\190\228\189\134\230\152\175\230\137\190\228\184\141\229\136\176\229\143\175\228\187\165\232\183\179\232\189\172\231\154\132\231\155\174\230\160\135\229\147\135")
  end
end

function AreaMiniMapBase:GetMiniMapFixPos(tilePos)
  local mainIndex, dis = 0, 9999
  local xMin, xMax, yMin, yMax
  for key, template in pairs(self.buildList) do
    xMin = template.x - template.w
    xMax = template.x + template.w
    yMin = template.y - template.h
    yMax = template.y + template.h
    if xMin <= tilePos.x and xMax >= tilePos.x and yMin <= tilePos.y and yMax >= tilePos.y then
      mainIndex = key
      break
    end
    local cX, cY = closestPointOnRectangle(tilePos, xMin, xMax, yMin, yMax)
    local tmpDis = Distance(tilePos.x, tilePos.y, cX, cY)
    if dis > tmpDis then
      dis = tmpDis
      mainIndex = key
    end
  end
  return mainIndex
end

function AreaMiniMapBase:CheckGround(mainIndex, localP)
  local v = self.groundList[mainIndex]
  if v == nil then
    return
  end
  local percent = 0.5
  local pos = v:GetAnchoredPosition()
  local rect = v.rectTransform.rect
  local partW = rect.width * percent
  local partH = rect.height * percent
  if not InRect(localP, pos, partW, partH) then
    return
  end
  local target
  local go = self.nodeList[mainIndex]
  if go ~= nil then
    local rt = go:GetComponent_RectTransform()
    local w, h = rt:Get_sizeDelta()
    local sX, sY = go.transform:Get_localScale()
    if InRect(localP, pos, w * sX, h * sY) then
      target = SceneUtils.TileIndexToWorld(mainIndex, ForceChangeScene.World)
      return target
    end
  end
  local spCheck = self:GetIdxToSpValue(mainIndex)
  if spCheck == nil then
    percent = 0.3
    partW = rect.width * percent
    partH = rect.height * percent
  end
  local template = self.buildList[mainIndex]
  if InRect(localP, pos, partW, partH) then
    target = SceneUtils.TileToWorld({
      x = template.x,
      y = template.y
    })
    return target
  elseif spCheck ~= nil then
    return
  end
  local px = pos.x * CommonUtil.ArabicAutoMirrorFactor()
  local ww = localP.x - px
  local hh = localP.y - pos.y
  local tileX = template.x + ww / partW * template.w
  local tileY = template.y + hh / partH * template.h
  target = Vector3.New(tileX * TileSize, 0, tileY * TileSize)
  target = self.actMgr:GetClosestPos(target, true)
  return target
end

function AreaMiniMapBase:ConvertMapPosToMiniPos(goItem, mainIndex, bRes)
  local value = BattleFieldUtil.GetBlockRangeValue(mainIndex, self:GetBfType())
  local transIdx = self:GetSpValueTransIdx(value)
  local template
  if transIdx then
    template = self.buildList[transIdx]
  end
  local x, y
  if template == nil then
    local tilePos = SceneUtils.IndexToTilePos(mainIndex, ForceChangeScene.World)
    local dis = math.huge
    local xMin, xMax, yMin, yMax
    x, y = tilePos.x, tilePos.y
    for index, v in pairs(self.buildList) do
      if not self:CheckSpIndex(index, bRes) then
        xMin = v.x - v.w
        xMax = v.x + v.w
        yMin = v.y - v.h
        yMax = v.y + v.h
        if xMin <= tilePos.x and xMax >= tilePos.x and yMin <= tilePos.y and yMax >= tilePos.y then
          template = v
          x = tilePos.x
          y = tilePos.y
          break
        end
        local cX, cY = closestPointOnRectangle(tilePos, xMin, xMax, yMin, yMax)
        local tmpDis = Distance(tilePos.x, tilePos.y, cX, cY)
        if dis > tmpDis then
          dis = tmpDis
          template = v
          x = cX
          y = cY
        end
      end
    end
  else
    local tilePos = SceneUtils.IndexToTilePos(mainIndex, ForceChangeScene.World)
    x = tilePos.x
    y = tilePos.y
  end
  if template == nil then
    local mapScale = self:GetMapScale()
    goItem:GetComponent(RectTransform):Set_localPosition((x - HalfSize) * mapScale, (y - HalfSize) * mapScale, 0)
  else
    local ground = self.groundList[template.mainIndex]
    if ground then
      local rect = ground.rectTransform.rect
      local pos = ground:GetAnchoredPosition()
      local percent = 0.5
      local partW = rect.width * percent
      local partH = rect.height * percent
      local startX = pos.x * CommonUtil.ArabicAutoMirrorFactor() - partW
      local ww = template.w * 2
      local startY = pos.y - partH
      local hh = template.h * 2
      local w = x - (template.x - template.w)
      local h = y - (template.y - template.h)
      local miniX = startX + w / ww * rect.width
      local miniY = startY + h / hh * rect.height
      goItem:GetComponent(RectTransform):Set_localPosition(miniX, miniY, 0)
    end
  end
end

function AreaMiniMapBase:CanRefresh(forceRefresh)
  local lastTime = self.lastRefreshTime or 0
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local canRefresh = forceRefresh or 1000 < curTime - lastTime
  if canRefresh then
    self.lastRefreshTime = curTime
  end
  return canRefresh
end

function AreaMiniMapBase:ShowCityPoint(forceRefresh)
  if not BattleFieldUtil.InBattleField() then
    return
  end
  local theWorld = CS.SceneManager.World
  if theWorld == nil then
    return
  end
  if not self:CanRefresh(forceRefresh) then
    self.showCityPointDirty = true
    return
  end
  self.showCityPointDirty = false
  if self.alreadyInit then
    self:UpdatePlayerCity()
    return
  end
  local list = theWorld:GetAllDragonPointList()
  if list ~= nil then
    for _, v in pairs(list) do
      self:RefreshMiniMap(v, true)
    end
  end
  self:UpdatePlayerCity()
  if not self.alreadyInit then
    self.alreadyInit = table.length(self.nodeList) > 0
  end
end

function AreaMiniMapBase:RefreshMiniMap(pointInfo, bInit)
  local detailInfo = pointInfo ~= nil and pointInfo.detail or nil
  if detailInfo == nil then
    return nil
  end
  local mainIndex = pointInfo.mainIndex
  local config = BattleFieldUtil.GetBuildTemplate(detailInfo.BuildId, self:GetBfType())
  if config == nil then
    return
  end
  self:PreRefreshCheck(bInit, mainIndex, config)
  local goItem = self.nodeList[mainIndex]
  local ground = self.groundList[mainIndex]
  local bBuild = config:IsBuild()
  local bRes = config:IsRes()
  if IsNull(goItem) then
    local parent = bBuild and ground ~= nil and ground or self.layout
    goItem = self.theItem:GameObjectSpawn(parent.transform)
    goItem.name = mainIndex
    local zoom = bRes and 0.5 or MiniZoom
    goItem.transform:Set_localScale(zoom, zoom, zoom)
    self.nodeList[mainIndex] = goItem
    if not bBuild then
      self:ConvertMapPosToMiniPos(goItem, mainIndex, true)
    end
  end
  local sprite_path, state = BattleFieldUtil.GetMiniMapSpritePath(detailInfo, self:GetBfType())
  local unity_image
  if IsNotNull(goItem) and IsNotNull(goItem.transform) then
    goItem:SetActive(true)
    unity_image = goItem:GetComponent(UnityImage)
  end
  if bRes then
    sprite_path = string.format(LoadPath.LWBattleFieldPath, "zyf_xiaoditu_youjing_1")
  end
  if unity_image and self.resImg[mainIndex] ~= sprite_path then
    unity_image:LoadSpriteAuto(sprite_path, function()
      if IsNotNull(unity_image) then
        unity_image:Set_color(1, 1, 1, bRes and 0.3 or 1)
        unity_image:SetNativeSize()
      end
    end)
    self.resImg[mainIndex] = sprite_path
  end
  if ground and bBuild then
    goItem.transform:SetParent(ground.transform)
    goItem.transform:Set_anchoredPosition(0, 0)
    if self.stateList[mainIndex] ~= state and (state == BattleFieldMiniState.Occupied_Red or state == BattleFieldMiniState.Occupied_Blue) then
      local fileIdx = state == BattleFieldMiniState.Occupied_Red and -1 or 1
      ground:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldPath, self:GetDiName(fileIdx)))
    end
  elseif config:IsScoreBox() then
    local old = self.resPointList[mainIndex]
    local isMine = old and old.isMine or false
    self.resPointList[mainIndex] = {
      score = math.floor(detailInfo.Score or 0),
      isMine = isMine
    }
  end
  if self.stateList[mainIndex] == state then
    return nil
  end
  self.stateList[mainIndex] = state
  return goItem
end

function AreaMiniMapBase:UpdatePlayerCity()
  local selfMainCity = BattleFieldUtil.GetSelfMainCity()
  if selfMainCity == nil then
    return
  end
  local uuid = selfMainCity.uuid
  local mainIndex = selfMainCity.mainIndex
  if LuaEntry.Player:GetBattleFieldPos() ~= mainIndex then
    LuaEntry.Player:SetBattleFieldPointId(mainIndex)
    GoToUtil.GotoDragonBuildPos()
  end
  local goItem = self.nodeList[uuid]
  if IsNull(goItem) then
    goItem = self.theItem:GameObjectSpawn(self.layout.transform)
    goItem.name = uuid
    goItem.transform:Set_localScale(MiniZoom, MiniZoom, MiniZoom)
    self.nodeList[uuid] = goItem
    goItem:SetActive(true)
    local unity_image = goItem:GetComponent(UnityImage)
    unity_image:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldPath, "zyf_xiaoditu_zhucheng_1"), function()
      if IsNotNull(unity_image) then
        unity_image:Set_color(1, 1, 1, 1)
        unity_image:SetNativeSize()
      end
    end)
  end
  if IsNotNull(goItem) and goItem.transform then
    self:ConvertMapPosToMiniPos(goItem, mainIndex)
  end
end

function AreaMiniMapBase:OnBuildingChange(pointIndex)
  if not BattleFieldUtil.InBattleField() then
    return
  end
  local theWorld = CS.SceneManager.World
  if theWorld == nil then
    return
  end
  local pointInfo = theWorld:GetPointInfo(pointIndex)
  if pointInfo ~= nil then
    local goItem = self:RefreshMiniMap(pointInfo, false)
    if IsNotNull(goItem) then
      self:PlayStateChangeAnim(pointIndex, goItem)
    end
  else
    self:TryRecycleItem(pointIndex)
  end
  self:DoBuildingChangeEx(pointIndex)
end

function AreaMiniMapBase:TryRecycleItem(pointIndex)
  local goItem = self.nodeList[pointIndex]
  if IsNotNull(goItem) then
    goItem:GameObjectRecycle()
  end
  self.nodeList[pointIndex] = nil
  self.stateList[pointIndex] = nil
  self.resImg[pointIndex] = nil
  local info = self.resPointList[pointIndex]
  if info ~= nil and info.score ~= 0 then
    self:playResAnim(pointIndex, info.score, info.isMine)
    self.resPointList[pointIndex] = nil
  end
  self:DoRecycleItemEx(pointIndex)
end

function AreaMiniMapBase:PlayStateChangeAnim(pointId, goItem)
  local ground = self.groundList[pointId]
  if ground == nil then
    self:PlayTishiAnim(goItem.transform:Find("tishi"), 2)
    return
  end
  self:_PlayGroundEff(pointId)
end

function AreaMiniMapBase:_PlayGroundEff(pointId)
  local ground = self.groundList[pointId]
  if ground == nil then
    return
  end
  local info = self.groupEffReqs[pointId]
  local request = info ~= nil and info.request or nil
  if request ~= nil then
    local saGo = request.gameObject
    if request.isDone and IsNotNull(saGo) then
      local sa = saGo:GetComponent(TypeSA)
      if sa ~= nil then
        if info.timer then
          info.timer:Stop()
        end
        saGo:SetActive(true)
        local time = sa:GetClipLength(EFF_GROUND_DEF_ANIM_NAME)
        if sa:IsPlaying(EFF_GROUND_DEF_ANIM_NAME) then
          sa:Rewind(EFF_GROUND_DEF_ANIM_NAME)
        else
          sa:Play(EFF_GROUND_DEF_ANIM_NAME)
        end
        info.timer = TimerManager:GetInstance():DelayInvoke(function()
          saGo:SetActive(false)
        end, time)
      end
    end
    return
  end
  info = {}
  self.groupEffReqs[pointId] = info
  info.request = self:GameObjectInstantiateAsync(EFF_GROUND_PATH, function(req)
    local go = req.gameObject
    if req.isError or IsNull(go) then
      return
    end
    go.name = "Eff"
    local tf = go.transform
    tf:SetParent(ground.transform)
    tf.localPosition = Vector3.zero
    tf.localScale = ResetScale
    local rtf = go:GetComponent_RectTransform()
    if rtf then
      rtf:Set_offsetMax(0, 0)
      rtf:Set_offsetMin(0, 0)
    end
    go:SetActive(true)
    self:PlayStateChangeAnim(pointId)
  end)
end

function AreaMiniMapBase:PlayTishiAnim(transform, duration, cb)
  if IsNull(transform) then
    if cb then
      cb()
    end
    return
  end
  transform.gameObject:SetActive(true)
  local effect_particle = transform:GetComponent(typeofPS)
  if effect_particle ~= nil then
    effect_particle.gameObject:SetActive(true)
    effect_particle:Play()
    local once = 1
    local sequence = CS.DG.Tweening.DOTween.Sequence()
    local times = math.ceil(duration / once)
    for _ = 1, times do
      sequence:AppendCallback(function()
        effect_particle:Stop()
        effect_particle:Play()
      end)
      sequence:AppendInterval(once)
    end
    sequence:AppendCallback(function()
      effect_particle.gameObject:SetActive(false)
      if cb then
        cb(effect_particle)
      end
    end)
  end
end

function AreaMiniMapBase:playResAnim(mainIndex, pointCount, isMine)
  if CS.SceneManager.World == nil or not CS.SceneManager:IsInWorld() then
    return
  end
  local thePoint = toInt(pointCount)
  if thePoint <= 0 or self.buildAnimRequest and self.buildAnimRequest[mainIndex] ~= nil then
    return
  end
  local request = ResourceManager:InstantiateAsync(RES_TIP_PREFAB)
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
        point_flag.color = Color(1, 1, 1, alpha)
      end, 0.8, 2.0):SetEase(CS.DG.Tweening.Ease.InExpo))
      sequence:AppendCallback(function()
        if self.buildAnimRequest ~= nil then
          local req = self.buildAnimRequest[mainIndex]
          if req ~= nil then
            self.buildAnimRequest[mainIndex] = nil
            req:Destroy()
          end
        end
      end)
    else
      goItem:SetActive(false)
    end
  end)
  if self.buildAnimRequest == nil then
    self.buildAnimRequest = {}
  end
  self.buildAnimRequest[mainIndex] = request
end

function AreaMiniMapBase:OnDragonScoreExplode(data)
  if data == nil or data.mainPoint == nil or data.scorePoints == nil or self.nodeList == nil or self.theJifen == nil then
    return
  end
  local goItem = self.nodeList[data.mainPoint]
  if IsNull(goItem) then
    return
  end
  local posFrom = SceneUtils.IndexToTilePos(data.mainPoint, ForceChangeScene.World)
  for i, mainIndex in ipairs(data.scorePoints) do
    local posTo = SceneUtils.IndexToTilePos(mainIndex, ForceChangeScene.World)
    local effectItem = self.theJifen:GameObjectSpawn(self.layout.transform)
    local jifen_particle = effectItem.transform:GetComponent(typeof(CS.UnityEngine.ParticleSystem))
    if jifen_particle ~= nil then
      local mapScale = self:GetMapScale()
      effectItem.name = tostring(mainIndex)
      effectItem:SetActive(true)
      effectItem.transform:Set_localPosition((posFrom.x - HalfSize) * mapScale, (posFrom.y - HalfSize) * mapScale, 0)
      jifen_particle.gameObject:SetActive(true)
      jifen_particle:Play()
      local sequence = CS.DG.Tweening.DOTween.Sequence()
      sequence:Join(effectItem.transform:DOLocalMove(Vector3.New((posTo.x - HalfSize) * mapScale, (posTo.y - HalfSize) * mapScale, 0), 0.5):SetEase(CS.DG.Tweening.Ease.OutCirc))
      sequence:AppendCallback(function()
        effectItem:GameObjectRecycle()
      end)
    else
      effectItem:GameObjectRecycle()
    end
  end
end

function AreaMiniMapBase:OnSingleMarchStateUpdate(marchUuid)
  if self.resPointList ~= nil then
    local march = DataCenter.WorldMarchDataManager:GetMarch(marchUuid)
    if march ~= nil and march:GetMarchTargetType() == MarchTargetType.PIC_EPIDEMIC_SCORE then
      local info = self.resPointList[march.targetPos]
      if info ~= nil and info.score ~= 0 then
        local bEnemy = BattleFieldUtil.IsBattleFieldEnemy(march.allianceUid, BattleFieldType.EpidemicZone)
        info.isMine = not bEnemy
      end
    end
  end
end

function AreaMiniMapBase:OnPingAdd(pingData)
  local key = pingData.uuid
  local pid = pingData.pid
  local cfg = pingData.cfg
  if cfg == nil then
    return
  end
  local duration = cfg.map_duration
  local req = ResourceManager:InstantiateAsync(string.format(BASE_PING_MARK_PATH, cfg.map_res))
  self.pingReqs[key] = req
  req:completed("+", function(request)
    local goItem = request.gameObject
    if request.isError or goItem == nil then
      if self.pingReqs and self.pingReqs[key] then
        self.pingReqs[key]:Destroy()
        self.pingReqs[key] = nil
      end
      return
    end
    goItem.transform.parent = self.layout.transform
    goItem.name = "Ping_" .. key
    self:ConvertMapPosToMiniPos(goItem, pid)
    self:PlayTishiAnim(goItem.transform, duration, function()
      if self.pingReqs and self.pingReqs[key] then
        self.pingReqs[key]:Destroy()
        self.pingReqs[key] = nil
      end
    end)
  end)
end

function AreaMiniMapBase:GetBfType()
  return BattleFieldType.Default
end

function AreaMiniMapBase:GetMapScale()
  return 1
end

function AreaMiniMapBase:ComponentDefine()
end

function AreaMiniMapBase:ComponentDestroy()
end

function AreaMiniMapBase:DoBaseGroundSpriteLoad()
end

function AreaMiniMapBase:OnMapClick()
  self:BaseMapClick()
end

function AreaMiniMapBase:DoRecycleItemEx(pointIndex)
end

function AreaMiniMapBase:DoBuildingChangeEx(pointIndex)
end

function AreaMiniMapBase:GetSpValueTransIdx(value)
end

function AreaMiniMapBase:GetIdxToSpValue(mainIndex)
end

function AreaMiniMapBase:CheckSpIndex(index, bRes)
end

function AreaMiniMapBase:PreRefreshCheck()
end

function AreaMiniMapBase:PreUpdate()
end

function AreaMiniMapBase:AfterUpdate()
end

return AreaMiniMapBase
