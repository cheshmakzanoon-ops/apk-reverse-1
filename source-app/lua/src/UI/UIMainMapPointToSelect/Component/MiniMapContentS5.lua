local MiniMapContentS5 = BaseClass("MiniMapContentS5", UIBaseContainer)
local MainMiniMapDesItem = require("UI.UIMainMapPointToSelect.Component.MainMiniMapDesItem")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local area_path = "Image/area"
local layout_path = "Image/layout"
local layout1_path = "Image/layout1"
local des1_path = "desObj/des1"
local des2_path = "desObj/des2"
local des3_path = "desObj/des3"
local des_obj_path = "desObj"
local click_jump_path = "Image/click_jump"
local MapScale = 0.198
local deltaSize = 0
local MapDelta = 0
local MapSize = 198
local TileCount = WorldTileCount

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.area = self:AddComponent(UIBaseContainer, area_path)
  self.layout = self:AddComponent(UIBaseContainer, layout_path)
  self.layout1 = self:AddComponent(UIBaseContainer, layout1_path)
  self.des1 = self:AddComponent(MainMiniMapDesItem, des1_path)
  self.des1:SetText(Localization:GetString("302337"))
  self.des2 = self:AddComponent(MainMiniMapDesItem, des2_path)
  self.des2:SetText(Localization:GetString("302338"))
  self.des3 = self:AddComponent(MainMiniMapDesItem, des3_path)
  self.des3:SetText(Localization:GetString("302336"))
  self.click_jump = self:AddComponent(UIButton, click_jump_path)
  self.click_jump:SetOnClick(function()
    self:OnMapClick()
  end)
  self.desRoot = self:AddComponent(UIBaseContainer, des_obj_path)
  self.layout1:SetActive(false)
  self.bg = self:AddComponent(UIImage, "Image")
  self.bg:LoadSprite("Assets/Main/SeasonRes/S5/Sprites/MiniMap/v2/lrb_S5ditu_map_v2.png")
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.WORLD_CAMERA_CHANGE_POINT, self.RefreshCameraPoint)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.WORLD_CAMERA_CHANGE_POINT, self.RefreshCameraPoint)
end

local function ComponentDestroy(self)
  self:ClearItemCell()
  self.area = nil
  self.layout = nil
  self.layout1 = nil
  self.des1 = nil
  self.des2 = nil
  self.des3 = nil
  self.click_jump = nil
  self.desRoot = nil
end

local function DataDefine(self)
  self.list = {}
  self.lastZoom = 0
  self.zoomXSize = 0
  self.zoomYSize = 0
  self.screenX = CS.UnityEngine.Screen.width
  self.screenY = CS.UnityEngine.Screen.height
  self.mapScale = 0.198
  self.mapDelta = 0
  self.mapSize = 198
end

local function DataDestroy(self)
  self.list = nil
  self.lastZoom = nil
  self.zoomXSize = nil
  self.zoomYSize = nil
  self.screenX = nil
  self.screenY = nil
end

local function SetData(self)
  self:ShowCityPoint()
  self:SetZoomPosAndSize(true)
end

local function SetZoomPosAndSize(self, needChangeSize)
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
    self.area:SetSizeDeltaXY(self.zoomXSize, self.zoomYSize)
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
  self.area:SetAnchoredPositionXY(realV2.x, realV2.y)
end

local function OnMapClick(self, param)
  local screenPos = CS.UnityEngine.Input.mousePosition
  local worldP = CS.GameEntry.UICamera:ScreenToWorldPoint(screenPos)
  local localP = self.click_jump.transform:InverseTransformPoint(worldP)
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
    EventManager:GetInstance():Broadcast(EventId.OnMiniMapClickJump, 1)
    GoToUtil.GotoPos(worldPos, -1, LookAtFocusTime, function()
      EventManager:GetInstance():Broadcast(EventId.OnMiniMapClickJump, 2)
    end, serverId)
  else
    GoToUtil.GotoPos(Vector3.one, -1, LookAtFocusTime)
  end
end

local function ShowCityPoint(self, obj)
  if LuaEntry.Player:GetCurWorldId() > 0 then
    return
  end
  local data = self.view.ctrl:GetCityPointData(#self.list)
  if data.isNew then
    self:ClearItemCell()
    local list = data.list
    self.list = list
    if list ~= nil then
      for i = 1, #list do
        self.itemList[i] = self:GameObjectInstantiateAsync(self:GetPrefabPath(list[i].pType), function(request)
          if request.isError then
            return
          end
          local go = request.gameObject
          go.transform:SetParent(self.layout.transform)
          go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
          local tfx = go:GetComponent(typeof(CS.UnityEngine.RectTransform))
          local tempX = list[i].pos.x
          if CommonUtil.IsArabicAutoMirrorOpen() then
            tempX = MapSize / MapScale - tempX
          end
          tfx:Set_anchoredPosition(tempX * MapScale * CommonUtil.ArabicAutoMirrorFactor(), list[i].pos.y * MapScale)
          go.gameObject:SetActive(true)
        end)
      end
    end
  end
end

local function OnUpdate(self)
end

local function ClearItemCell(self)
  if self.itemList ~= nil then
    for k, v in pairs(self.itemList) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.itemList = {}
end

local function GetPrefabPath(self, state)
  local path = ""
  if state == CS.PlayerType.PlayerSelf then
    path = "Assets/Main/Prefabs/UI/UIMain/selfPoint.prefab"
  elseif state == CS.PlayerType.PlayerAlliance then
    path = "Assets/Main/Prefabs/UI/UIMain/memberPoint.prefab"
  elseif state == CS.PlayerType.PlayerAllianceLeader then
    path = "Assets/Main/Prefabs/UI/UIMain/leaderPoint.prefab"
  end
  return path
end

local function RefreshCameraPoint(self)
  self:SetZoomPosAndSize(true)
end

MiniMapContentS5.OnCreate = OnCreate
MiniMapContentS5.OnDestroy = OnDestroy
MiniMapContentS5.OnAddListener = OnAddListener
MiniMapContentS5.OnRemoveListener = OnRemoveListener
MiniMapContentS5.ComponentDefine = ComponentDefine
MiniMapContentS5.ComponentDestroy = ComponentDestroy
MiniMapContentS5.DataDefine = DataDefine
MiniMapContentS5.DataDestroy = DataDestroy
MiniMapContentS5.SetData = SetData
MiniMapContentS5.SetZoomPosAndSize = SetZoomPosAndSize
MiniMapContentS5.OnMapClick = OnMapClick
MiniMapContentS5.ShowCityPoint = ShowCityPoint
MiniMapContentS5.OnUpdate = OnUpdate
MiniMapContentS5.ClearItemCell = ClearItemCell
MiniMapContentS5.GetPrefabPath = GetPrefabPath
MiniMapContentS5.RefreshCameraPoint = RefreshCameraPoint
return MiniMapContentS5
