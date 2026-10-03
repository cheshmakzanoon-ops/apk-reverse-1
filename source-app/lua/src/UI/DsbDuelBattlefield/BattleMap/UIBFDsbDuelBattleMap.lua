local UIBFDsbDuelBattleMap = BaseClass("UIBFDsbDuelBattleMap", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local UnityImage = typeof(CS.UnityEngine.UI.Image)
local RectTransform = typeof(CS.UnityEngine.RectTransform)
local Localization = CS.GameEntry.Localization
local UIBFDsbDuelBattleMapItem = require("UI.DsbDuelBattlefield.BattleMap.UIBFDsbDuelBattleMapItem")
local content_path = "SafeAreaDi/ScrollView/Viewport/Content"
local top_bar_path = "SafeArea/TopBar"
local btn_back_path = "SafeArea/BottomBar/BtnBack"

function UIBFDsbDuelBattleMap:OnCreate()
  base.OnCreate(self)
  local param = self:GetUserData()
  self.param = param
  self.cityNodeList = {}
  self.resImg = {}
  self:ComponentDefine()
end

function UIBFDsbDuelBattleMap:OnDestroy()
  self.cityNodeList = {}
  self.resImg = {}
  self.tempResPoints = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBFDsbDuelBattleMap:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UPDATE_POINTS_DATA, self.ShowCityPoint)
end

function UIBFDsbDuelBattleMap:OnRemoveListener()
  self:RemoveUIListener(EventId.UPDATE_POINTS_DATA, self.ShowCityPoint)
  base.OnRemoveListener(self)
end

function UIBFDsbDuelBattleMap:OnMapClick()
  local screenPos = CS.UnityEngine.Input.mousePosition
  local worldP = CS.GameEntry.UICamera:ScreenToWorldPoint(screenPos)
  local localP = self.content.transform:InverseTransformPoint(worldP)
  local x = math.max(800, math.min(1202, (500 + localP.x / 5) * TileSize + 1))
  local y = math.max(800, math.min(1202, (500 + localP.y / 5) * TileSize + 1))
  local target = Vector3.New(x, 0, y)
  self.ctrl:CloseSelf()
  local mgr = BattleFieldUtil.GetMgrActive()
  target = mgr:GetClosestPos(target)
  GoToUtil.GotoDragonPos(target, -1, LookAtFocusTime, nil, LuaEntry.Player:GetCrossServerId(), LuaEntry.Player:GetCurWorldId())
end

function UIBFDsbDuelBattleMap:ComponentDefine()
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_back:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.content = self:AddComponent(UIButton, content_path)
  self.top_bar = self:AddComponent(UIBaseContainer, top_bar_path)
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
end

function UIBFDsbDuelBattleMap:CanRefresh(forceRefresh)
  local lastTime = self.lastRefreshTime or 0
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local canRefresh = forceRefresh or 1000 < curTime - lastTime
  if canRefresh then
    self.lastRefreshTime = curTime
  end
  return canRefresh
end

function UIBFDsbDuelBattleMap:TryCreateResPoint(pointInfo, pos)
  self.tempResPoints = self.tempResPoints or {}
end

local function _MagDistance(pos1, pos2)
  local _x = pos1.x - pos2.x
  local _y = pos1.y - pos2.y
  return _x * _x + _y * _y
end

function UIBFDsbDuelBattleMap:ShowCityPoint(forceRefresh)
  if not self:CanRefresh(forceRefresh) then
    self.showCityPointDirty = true
    return
  end
  self.showCityPointDirty = false
  ProfilerUtil.BeginSample("UIBFDsbDuelBattleMap:ShowCityPoint")
  local nodeList = self.nodeList or {}
  local cityNodeList = {}
  local goItem, itemNode
  local allPoints = {}
  local list = CS.SceneManager.World:GetAllDragonPointList()
  BattleFieldUtil.StartRecordPointInfo(50)
  local resConfig
  if list ~= nil then
    for k, v in pairs(list) do
      local detailInfo = v.detail
      if detailInfo ~= nil then
        local buildId = detailInfo.BuildId or detailInfo.ItemId
        local config = BattleFieldUtil.GetBattlefieldBuildTemplate(buildId)
        if config:IsRes() then
          BattleFieldUtil.RecordPointInfo(v)
          resConfig = config
        else
          local pos = SceneUtils.IndexToTilePos(v.mainIndex, ForceChangeScene.World)
          local nodeKey = tostring(v.mainIndex)
          itemNode = nodeList[nodeKey]
          if itemNode == nil then
            goItem = self.theItem:GameObjectSpawn(self.content.transform)
            goItem.name = nodeKey
            goItem:SetActive(true)
            goItem:GetComponent(RectTransform):Set_localPosition((tonumber(pos.x) - 500) * 5, (tonumber(pos.y) - 500) * 5, 0)
            itemNode = self.content:AddComponent(UIBFDsbDuelBattleMapItem, nodeKey)
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
  if resConfig then
    local resPoints = {}
    BattleFieldUtil.GetRecordPointInfos(resPoints)
    if 0 < #resPoints then
      for k, info in ipairs(resPoints) do
        local pos = info.pos
        local v = info.pointInfo
        local nodeKey = tostring(v.mainIndex)
        itemNode = nodeList[nodeKey]
        if itemNode == nil then
          goItem = self.theItem:GameObjectSpawn(self.content.transform)
          goItem.name = nodeKey
          goItem:SetActive(true)
          goItem:GetComponent(RectTransform):Set_localPosition((tonumber(pos.x) - 500) * 5, (tonumber(pos.y) - 500) * 5, 0)
          itemNode = self.content:AddComponent(UIBFDsbDuelBattleMapItem, nodeKey)
          nodeList[nodeKey] = itemNode
        end
        allPoints[nodeKey] = 1
        cityNodeList[nodeKey] = itemNode
        itemNode:SetActive(true)
        itemNode:ReInit(resConfig, v)
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
        local pos = SceneUtils.IndexToTilePos(mainIndex, ForceChangeScene.World)
        local nodeKey = tostring(mainIndex)
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
            rt:Set_localPosition((tonumber(pos.x) - 500) * 5, (tonumber(pos.y) - 500) * 5, 0)
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
              unity_image:LoadSpriteAsync(string.format(LoadPath.LWBattleFieldPath, sprite_path), function()
                if IsNotNull(unity_image) then
                  unity_image:SetNativeSize()
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
  ProfilerUtil.EndSample()
end

function UIBFDsbDuelBattleMap:ComponentDestroy()
  self.theItem:GameObjectRecycleAll()
  self.theCity:GameObjectRecycleAll()
  for _, v in ipairs(self.content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self.nodeList = nil
end

function UIBFDsbDuelBattleMap:UpdateData()
end

function UIBFDsbDuelBattleMap:Update1000MS()
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

return UIBFDsbDuelBattleMap
