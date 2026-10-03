local MiniMapContent = BaseClass("MiniMapContent", UIBaseContainer)
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
  self.bg:LoadSprite("Assets/Main/Sprites/LodIcon/UIditu_img_map.png")
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
    local maxV3 = {}
    maxV3.x = self.screenX
    maxV3.y = self.screenY
    maxV3.z = 0
    local maxPos = CS.SceneManager.World:ScreenPointToWorld(maxV3)
    local maxV2 = SceneUtils.WorldToTile(maxPos, ForceChangeScene.World)
    maxV2.x = Mathf.Clamp(maxV2.x, 0, TileCount)
    maxV2.y = Mathf.Clamp(maxV2.y, 0, TileCount)
    local minV3 = {}
    minV3.x = 0
    minV3.y = 0
    minV3.z = 0
    local minPos = CS.SceneManager.World:ScreenPointToWorld(minV3)
    local minV2 = SceneUtils.WorldToTile(minPos, ForceChangeScene.World)
    minV2.x = Mathf.Clamp(minV2.x, 0, TileCount)
    minV2.y = Mathf.Clamp(minV2.y, 0, TileCount)
    self.zoomXSize = (maxV2.x - minV2.x) * MapScale
    self.zoomYSize = (maxV2.y - minV2.y) * MapScale
    local v2 = {}
    v2.x = self.zoomXSize
    v2.y = self.zoomYSize
    self.area:SetSizeDelta(v2)
  end
  local targetV3 = CS.SceneManager.World.CurTarget
  local curV2 = SceneUtils.WorldToTile(targetV3, ForceChangeScene.World)
  local realV2 = {}
  local tempX = (curV2.x - MapDelta) * MapScale - self.zoomXSize / 2
  local tempY = (curV2.y - MapDelta) * MapScale - self.zoomYSize / 2
  local checkX = math.min(tempX, MapSize - self.zoomXSize)
  local checkY = math.min(tempY, MapSize - self.zoomYSize)
  local x = math.min(math.max(checkX, 0), MapSize)
  local y = math.min(math.max(checkY, 0), MapSize)
  realV2.x = x + deltaSize
  realV2.y = y + deltaSize
  if CommonUtil.IsArabicAutoMirrorOpen() then
    realV2.x = MapSize - realV2.x - self.area:GetSizeDelta().x
  end
  self.area:SetAnchoredPositionXY(realV2.x, realV2.y)
end

local function OnMapClick(self, param)
  local screenPos = CS.UnityEngine.Input.mousePosition
  local worldP = CS.GameEntry.UICamera:ScreenToWorldPoint(screenPos)
  local localP = self.click_jump.transform:InverseTransformPoint(worldP)
  if CommonUtil.IsArabicAutoMirrorOpen() then
    localP.x = -MapSize - localP.x
  end
  local x = localP.x / MapSize * TileCount + MapDelta
  local y = localP.y / MapSize * TileCount + MapDelta
  local target = Vector3.New(x * TileSize * CommonUtil.ArabicAutoMirrorFactor(), 0, y * TileSize)
  if BattleFieldUtil.InBattleField() then
    GoToUtil.GotoDragonPos(target, -1, LookAtFocusTime, function()
    end, LuaEntry.Player:GetCrossServerId(), LuaEntry.Player:GetCurWorldId())
  else
    GoToUtil.GotoPos(target, -1, LookAtFocusTime, nil, LuaEntry.Player:GetCurServerId())
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

MiniMapContent.OnCreate = OnCreate
MiniMapContent.OnDestroy = OnDestroy
MiniMapContent.OnAddListener = OnAddListener
MiniMapContent.OnRemoveListener = OnRemoveListener
MiniMapContent.ComponentDefine = ComponentDefine
MiniMapContent.ComponentDestroy = ComponentDestroy
MiniMapContent.DataDefine = DataDefine
MiniMapContent.DataDestroy = DataDestroy
MiniMapContent.SetData = SetData
MiniMapContent.SetZoomPosAndSize = SetZoomPosAndSize
MiniMapContent.OnMapClick = OnMapClick
MiniMapContent.ShowCityPoint = ShowCityPoint
MiniMapContent.OnUpdate = OnUpdate
MiniMapContent.ClearItemCell = ClearItemCell
MiniMapContent.GetPrefabPath = GetPrefabPath
MiniMapContent.RefreshCameraPoint = RefreshCameraPoint
return MiniMapContent
