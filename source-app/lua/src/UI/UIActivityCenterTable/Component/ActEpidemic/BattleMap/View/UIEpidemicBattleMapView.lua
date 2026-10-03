local UIEpidemicBattleMapView = BaseClass("UIEpidemicBattleMapView", UIBaseView)
local base = UIBaseView
local UnityImage = typeof(CS.UnityEngine.UI.Image)
local RectTransform = typeof(CS.UnityEngine.RectTransform)
local Localization = CS.GameEntry.Localization
local UIEpidemicBattleMapItem = require("UI.UIActivityCenterTable.Component.ActEpidemic.BattleMap.Component.UIEpidemicBattleMapItem")
local content_path = "SafeAreaDi/ScrollView/Viewport/Content"
local top_bar_path = "SafeArea/TopBar"
local btn_back_path = "SafeArea/BottomBar/BtnBack"
local txt1_path = "SafeArea/BottomBar/GameObject/cell1/txt1"
local txt2_path = "SafeArea/BottomBar/GameObject/cell2/txt2"
local txt3_path = "SafeArea/BottomBar/GameObject/cell3/txt3"
local txt4_path = "SafeArea/BottomBar/GameObject/cell4/txt4"
local SCALE = 4

function UIEpidemicBattleMapView:OnCreate()
  base.OnCreate(self)
  local param = self:GetUserData()
  self.param = param
  self.cityNodeList = {}
  self.resImg = {}
  self:ComponentDefine()
end

function UIEpidemicBattleMapView:OnDestroy()
  self.resImg = {}
  self.cityNodeList = {}
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIEpidemicBattleMapView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UPDATE_POINTS_DATA, self.ShowCityPoint)
end

function UIEpidemicBattleMapView:OnRemoveListener()
  self:RemoveUIListener(EventId.UPDATE_POINTS_DATA, self.ShowCityPoint)
  base.OnRemoveListener(self)
end

function UIEpidemicBattleMapView:OnMapClick()
  local screenPos = CS.UnityEngine.Input.mousePosition
  local worldP = CS.GameEntry.UICamera:ScreenToWorldPoint(screenPos)
  local localP = self.content.transform:InverseTransformPoint(worldP)
  local x = math.max(800, math.min(1202, (500 + localP.x / SCALE) * TileSize + 1))
  local y = math.max(800, math.min(1202, (500 + localP.y / SCALE) * TileSize + 1))
  local target = Vector3.New(x, 0, y)
  self.ctrl:CloseSelf()
  target = DataCenter.ActEpidemicZoneManager:GetClosestPos(target)
  GoToUtil.GotoDragonPos(target, -1, LookAtFocusTime, nil, LuaEntry.Player:GetCrossServerId(), LuaEntry.Player:GetCurWorldId())
end

function UIEpidemicBattleMapView:ComponentDefine()
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_back:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.content = self:AddComponent(UIButton, content_path)
  local cls = "UI.LWMainEpidemicZoneUI.Component.LWMainEpidemicZoneBattleInfo"
  local prefab = "Assets/Main/Prefabs/UI/BF_Epidemic/Battle/BattleInfo.prefab"
  self.top_bar = self:AddComponent(UIBaseComponent, top_bar_path)
  self.battle_info = self:LoadComponentAsync(cls, prefab, self.top_bar, function(_, go)
    go.transform:SetAsFirstSibling()
    go.name = "BattleInfo"
    local rectTF = go:GetComponent(typeof(CS.UnityEngine.RectTransform))
    if rectTF ~= nil then
      rectTF:Set_anchoredPosition(0, 25)
    end
  end)
  self.content:SetOnClick(function()
    self:OnMapClick()
  end)
  self.theItem = self.transform:Find("build").gameObject
  self.theItem:GameObjectCreatePool()
  self.theCity = self.transform:Find("city").gameObject
  self.theCity:GameObjectCreatePool()
  self:ShowCityPoint(true)
  local _, hc = self.content:GetSizeDeltaXY()
  local h = self.rectTransform.rect.height
  local scale = h / hc
  self.content:SetLocalScaleXYZ(scale, scale, scale)
  self.txt1 = self:AddComponent(UIText, txt1_path)
  self.txt2 = self:AddComponent(UIText, txt2_path)
  self.txt3 = self:AddComponent(UIText, txt3_path)
  self.txt4 = self:AddComponent(UIText, txt4_path)
  self.txt2:SetText(Localization:GetString("458027"))
  self.txt4:SetText(Localization:GetString("458028"))
  self.txt1:SetText(Localization:GetString("458029"))
  self.txt3:SetText(Localization:GetString("458030"))
end

function UIEpidemicBattleMapView:CanRefresh(forceRefresh)
  local lastTime = self.lastRefreshTime or 0
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local canRefresh = forceRefresh or 1000 < curTime - lastTime
  if canRefresh then
    self.lastRefreshTime = curTime
  end
  return canRefresh
end

function UIEpidemicBattleMapView:ShowCityPoint(forceRefresh)
  if not self:CanRefresh(forceRefresh) then
    self.showCityPointDirty = true
    return
  end
  self.showCityPointDirty = false
  local nodeList = self.nodeList or {}
  local cityNodeList = {}
  local goItem, itemNode
  local allPoints = {}
  local list = CS.SceneManager.World:GetAllDragonPointList()
  if list ~= nil then
    for k, v in pairs(list) do
      local detailInfo = v.detail
      if detailInfo ~= nil then
        local buildId = detailInfo.BuildId
        if DataCenter.EpidemicBuildTemplateMgr:IsBuild(buildId) then
          local config = DataCenter.EpidemicBuildTemplateMgr:GetTemplate(buildId)
          local pos = SceneUtils.IndexToTilePos(v.mainIndex, ForceChangeScene.World)
          local nodeKey = tostring(v.mainIndex)
          itemNode = nodeList[nodeKey]
          if itemNode == nil then
            goItem = self.theItem:GameObjectSpawn(self.content.transform)
            goItem.name = nodeKey
            goItem:SetActive(true)
            goItem:GetComponent(RectTransform):Set_localPosition((tonumber(pos.x) - 500) * SCALE, (tonumber(pos.y) - 500) * SCALE, 0)
            itemNode = self.content:AddComponent(UIEpidemicBattleMapItem, nodeKey)
            nodeList[nodeKey] = itemNode
          end
          allPoints[nodeKey] = 1
          cityNodeList[nodeKey] = itemNode
          itemNode:SetActive(true)
          itemNode:ReInit(config, v)
        end
      end
    end
  end
  local cityList = CS.SceneManager.World:GetAllMainBaseList()
  if cityList ~= nil then
    local unity_image, rt
    for _, v in pairs(cityList) do
      local state = v:GetPlayerType()
      local mainIndex = v.mainIndex
      if state == CS.PlayerType.PlayerSelf or state == CS.PlayerType.PlayerAlliance or state == CS.PlayerType.PlayerAllianceLeader then
        local pos = SceneUtils.IndexToTilePos(v.mainIndex, ForceChangeScene.World)
        local nodeKey = tostring(v.mainIndex)
        goItem = nodeList[nodeKey]
        if goItem == nil then
          goItem = self.theCity:GameObjectSpawn(self.content.transform)
          goItem.name = nodeKey
          nodeList[nodeKey] = goItem
        end
        allPoints[nodeKey] = 1
        if not IsNull(goItem) then
          goItem:SetActive(true)
          rt = goItem:GetComponent(RectTransform)
          if rt then
            rt:Set_localPosition((tonumber(pos.x) - 500) * SCALE, (tonumber(pos.y) - 500) * SCALE, 0)
          end
          unity_image = goItem:GetComponent(UnityImage)
          if unity_image then
            local sprite_path = "zyf_xiaoditu_mengyouzhuchengweizhi"
            if state == CS.PlayerType.PlayerSelf then
              sprite_path = "zyf_xiaoditu_zhucheng_1"
            end
            local currentPath = self.resImg[mainIndex] or ""
            if currentPath ~= sprite_path then
              self.resImg[mainIndex] = sprite_path
              local img = unity_image
              img:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldPath, sprite_path), function()
                if IsNotNull(img) then
                  img:SetNativeSize()
                end
              end)
            end
          end
        end
      end
    end
  end
  self.nodeList = nodeList
  self.cityNodeList = cityNodeList
  for nodeKey, node in pairs(nodeList) do
    if allPoints[nodeKey] == nil and node then
      node:SetActive(false)
    end
  end
end

function UIEpidemicBattleMapView:ComponentDestroy()
  self.theItem:GameObjectRecycleAll()
  self.theCity:GameObjectRecycleAll()
  for _, v in ipairs(self.content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.nodeList = nil
end

function UIEpidemicBattleMapView:UpdateData()
end

function UIEpidemicBattleMapView:Update1000MS()
  if self.showCityPointDirty then
    self:ShowCityPoint(true)
  end
  if self.cityNodeList then
    for _, itemNode in pairs(self.cityNodeList) do
      if itemNode then
        itemNode:UpdateTime()
      end
    end
  end
end

return UIEpidemicBattleMapView
