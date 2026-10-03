local UIMainMapPointToSelectView = BaseClass("UIMainMapPointToSelectView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local CollectPointContent = require("UI.UIMainMapPointToSelect.Component.CollectPointContent")
local MiniMapContent = require("UI.UIMainMapPointToSelect.Component.MiniMapContent")
local SelectPointArrowContent = require("UI.UIMainMapPointToSelect.Component.SelectPointArrowContent")
local SelectZoneContent = require("UI.UIMainMapPointToSelect.Component.SelectZoneContent")
local back_btn_path = "safeArea/selectPointContent/bottomContent/backBtn"
local select_point_content_path = "safeArea/selectPointContent/selectPointContent"
local select_point_path = "safeArea/selectPointContent/selectPointContent/selectPoint"
local top_right_path = "safeArea/selectPointContent/topRight"
local top_left_path = "safeArea/selectPointContent/topLeft"
local bottom_content_path = "safeArea/selectPointContent/bottomContent"
local city_select_content_path = "safeArea/selectPointContent/bottomContent/citySelectContent"
local server_item_text_path = "safeArea/selectPointContent/bottomContent/serverContent/serverItem/ServerItemText"
local alliance_item_text_path = "safeArea/selectPointContent/bottomContent/serverContent/allianceItem/AllianceItemText"

local function OnCreate(self)
  base.OnCreate(self)
  if BattleFieldUtil.InBattleField() then
    self.bigMapMode = false
  else
    local curServerId = LuaEntry.Player:GetCurServerId()
    local isBigMapMode, curSameGroup, srcSameGroup, loginSameGroup = SeasonUtil.InSeasonBigMapMode(curServerId)
    self.bigMapMode = isBigMapMode
    self.curSameGroup = curSameGroup
    self.srcSameGroup = srcSameGroup
    self.loginSameGroup = loginSameGroup
  end
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
  DataCenter.WorldPointSelectViewDataManager:SetTouchCameraZoomChangeBlock(true)
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  DataCenter.WorldPointSelectViewDataManager:SetTouchCameraZoomChangeBlock(false)
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.back_btn = self:AddComponent(UIButton, back_btn_path)
  self.back_btn:SetOnClick(function()
    self:OnBackBtnClick()
  end)
  self.select_point_content = self:AddComponent(UIEventTrigger, select_point_content_path)
  self.select_point_content_arrow = self:AddComponent(SelectPointArrowContent, select_point_content_path)
  self.select_point = self:AddComponent(UIBaseContainer, select_point_path)
  if self.bigMapMode then
    local WorldMiniMapCompS5 = require("UI.UIMainMapPointToSelect.Component.MiniMapContentS5")
    self.top_right = self:AddComponent(WorldMiniMapCompS5, top_right_path)
  else
    self.top_right = self:AddComponent(MiniMapContent, top_right_path)
  end
  self.top_left = self:AddComponent(CollectPointContent, top_left_path)
  self.bottom_content = self:AddComponent(UIBaseContainer, bottom_content_path)
  self.select_point_content:OnBeginDrag(function(eventData)
    self:OnContentBeginDrag(eventData)
  end)
  self.select_point_content:OnDrag(function(eventData)
    self:OnContentDraging(eventData)
  end)
  self.select_point_content:OnEndDrag(function(eventData)
    self:OnContentEndDrag(eventData)
  end)
  self.select_point_content:OnPointerClick(function(eventData)
    self:OnContentClick(eventData)
  end)
  self.select_point_content:OnPointerDown(function(eventData)
    self:OnContentPointDown(eventData)
  end)
  self.city_select_content = self:AddComponent(SelectZoneContent, city_select_content_path)
  self.server_item_text = self:AddComponent(UITextMeshProUGUIEx, server_item_text_path)
  self.alliance_item_text = self:AddComponent(UITextMeshProUGUIEx, alliance_item_text_path)
end

local function ComponentDestroy(self)
  self.back_btn = nil
  self.select_point_content = nil
  self.select_point_content_arrow = nil
  self.select_point = nil
  self.top_right = nil
  self.top_left = nil
  self.bottom_content = nil
  self.city_select_content = nil
  self.server_item_text = nil
  self.alliance_item_text = nil
end

local function DataDefine(self)
  self.dragPosStart = nil
  self.dragStartCamPos = nil
  self.touchCamera = nil
  self.cityTempData = nil
  self.cityTempLvDict = nil
  self.selectZoneId = nil
  self.selectZonePosId = nil
  self.selectZoneServerId = nil
end

local function DataDestroy(self)
  self.dragPosStart = nil
  self.dragStartCamPos = nil
  self.touchCamera = nil
  self.cityTempData = nil
  self.cityTempLvDict = nil
  self.selectZoneId = nil
  self.selectZonePosId = nil
  self.selectZoneServerId = nil
end

function UIMainMapPointToSelectView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnMiniMapClickJump, self.RefreshServerContent)
  self:AddUIListener(EventId.KingdomPresidentInfoUpdate, self.RefreshServerContent)
  self:AddUIListener(EventId.OnEnterCrossServer, self.RefreshServerContent)
  self:AddUIListener(EventId.RefreshKingInfo, self.RefreshServerContent)
end

function UIMainMapPointToSelectView:OnRemoveListener()
  self:RemoveUIListener(EventId.OnMiniMapClickJump, self.RefreshServerContent)
  self:RemoveUIListener(EventId.KingdomPresidentInfoUpdate, self.RefreshServerContent)
  self:RemoveUIListener(EventId.OnEnterCrossServer, self.RefreshServerContent)
  self:RemoveUIListener(EventId.RefreshKingInfo, self.RefreshServerContent)
  base.OnRemoveListener(self)
end

local function ReInit(self)
  self:InitData()
  self:RefreshView()
end

local function OnBackBtnClick(self)
  self.ctrl:CloseSelf()
end

function UIMainMapPointToSelectView:InitData()
  local serverId = LuaEntry.Player:GetCurServerId()
  self.cityTempData = DataCenter.AllianceCityTemplateManager:GetAllTemplate(serverId)
  self.cityTempLvDict = {}
  for _, v in pairs(self.cityTempData) do
    local lv = v.level
    if self.cityTempLvDict[lv] == nil then
      self.cityTempLvDict[lv] = {}
    end
    table.insert(self.cityTempLvDict[lv], v)
  end
  self.selectZonePosId, self.selectZoneId, self.selectZoneServerId = DataCenter.WorldPointSelectViewDataManager:GetDefaultJumpPosAndZoneId()
end

function UIMainMapPointToSelectView:RefreshView()
  self.top_right:SetData()
  self.select_point_content_arrow:SetData()
  self.top_left:SetData()
  self.city_select_content:SetData(self.cityTempData, self.cityTempLvDict)
  self:RefreshServerContent()
end

function UIMainMapPointToSelectView:RefreshServerContent()
  local serverId = LuaEntry.Player:GetCurServerId()
  local serverTxt = ""
  if serverId and 0 < serverId then
    serverTxt = Localization:GetString("alliance_announcement_6", serverId)
  end
  self.server_item_text:SetText(serverTxt)
  local alTxt = ""
  local presidentInfo = DataCenter.GovernmentManager:GetCurPresident(serverId)
  if presidentInfo == nil or presidentInfo.uid == 0 or presidentInfo.uid == "" then
    alTxt = Localization:GetString("457017")
    SFSNetwork.SendMessage(MsgDefines.GetKingInfo, serverId)
  else
    alTxt = UIUtil.FormatAllianceAndName(presidentInfo.allianceAbbr, presidentInfo.name, presidentInfo.uid)
  end
  self.alliance_item_text:SetText(alTxt)
end

function UIMainMapPointToSelectView:Update()
end

function UIMainMapPointToSelectView:GetSelectZoneData()
  return self.selectZonePosId, self.selectZoneId, self.selectZoneServerId
end

function UIMainMapPointToSelectView:CloseBookMark()
  self.top_left:CloseBookMark()
end

function UIMainMapPointToSelectView:GetShareDataAndClose(share_param)
  if share_param then
    if (share_param.type == ShareType.Pos or share_param.type == nil) and not string.IsNullOrEmpty(share_param.pos) then
      local pos = SceneUtils.IndexToTilePos(share_param.pos, ForceChangeScene.World)
      share_param.pos = nil
      share_param.x = pos.x
      share_param.y = pos.y
    end
    if type(share_param) == "table" then
      if share_param.worldId == nil then
        share_param.worldId = LuaEntry.Player:GetCurWorldId()
        share_param.worldType = LuaEntry.Player:GetCurWorldType()
        if BattleFieldUtil.InBattleField(BattleFieldType.Desert) then
          share_param.allianceId = LuaEntry.Player.allianceId
          share_param.actDragonGroup = DataCenter.ActDragonManager:GetCurGroupIdx()
        end
      end
      if share_param.sid == nil then
        share_param.sid = LuaEntry.Player:GetCurServerId()
      end
    end
  end
  self.ctrl:CloseSelf(share_param)
end

function UIMainMapPointToSelectView:ChangeSelectZone(zoneId, posId, serverId)
  self.selectZoneId = zoneId
  self.selectZonePosId = posId
  self.selectZoneServerId = serverId
  self.select_point_content_arrow:SetData()
  self.city_select_content:ChangeSelectZone()
  local zoomMax = DataCenter.WorldPointSelectViewDataManager:GetZoomMax()
  GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(posId, ForceChangeScene.World), zoomMax, nil, nil, serverId)
end

function UIMainMapPointToSelectView:OnContentBeginDrag(eventData)
  self.isContentDrag = true
  local pos = eventData.position
  if self.touchCamera == nil then
    self.touchCamera = DataCenter.WorldPointSelectViewDataManager:GetTouchCamera()
  end
  if self.touchCamera == nil then
    return
  end
  if self.dragPosStart == nil then
    self.dragPosStart = pos
  end
  if self.dragStartCamPos == nil then
    self.dragStartCamPos = self.touchCamera:GetCameraPos()
  end
end

function UIMainMapPointToSelectView:OnContentDraging(eventData)
  self.isContentDrag = true
  local pos = eventData.position
  if self.touchCamera == nil or self.dragPosStart == nil or self.dragStartCamPos == nil then
    return
  end
  local ray1 = self.touchCamera:ScreenPointToRay(Vector3.New(self.dragPosStart.x, self.dragPosStart.y, 0))
  local ray2 = self.touchCamera:ScreenPointToRay(Vector3.New(pos.x, pos.y, 0))
  local intersectionDragStart = self.touchCamera:GetIntersectionPoint(ray1)
  local intersectionDragCurrent = self.touchCamera:GetIntersectionPoint(ray2)
  local dragVector = intersectionDragCurrent - intersectionDragStart
  local posNewClamped = self.dragStartCamPos - dragVector
  self.touchCamera:SetCameraPos(posNewClamped)
end

function UIMainMapPointToSelectView:OnContentEndDrag(eventData)
  local pos = eventData.position
  self.dragPosStart = nil
  self.dragStartCamPos = nil
  self.touchCamera = nil
end

function UIMainMapPointToSelectView:OnContentClick(eventData)
  if self.isContentDrag ~= false then
    return
  end
  if self.touchCamera == nil then
    self.touchCamera = DataCenter.WorldPointSelectViewDataManager:GetTouchCamera()
  end
  if self.touchCamera == nil then
    return
  end
  local world = CS.SceneManager.World
  local pos = eventData.position
  local ray = self.touchCamera:ScreenPointToRay(Vector3.New(pos.x, pos.y, 0))
  local intersectionDragCurrent = self.touchCamera:GetIntersectionPoint(ray)
  local serverId = LuaEntry.Player:GetCurServerId()
  if self.bigMapMode then
    serverId = DataCenter.SeasonDataManager:GetNinePalacesServerByWorldPos(intersectionDragCurrent, ServerEnum.View)
  end
  local pointId = world:TilePosToIndex(world:WorldToTile(intersectionDragCurrent))
  local zone = SceneUtils.GetZoneIdByPosId(pointId, serverId)
  if zone == 0 then
    return
  end
  local cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(zone, serverId)
  if cityMeta == nil then
    return
  end
  local pointId = cityMeta:GetPointId()
  self:ChangeSelectZone(zone, pointId, serverId)
end

function UIMainMapPointToSelectView:OnContentPointDown(eventData)
  self.isContentDrag = false
end

UIMainMapPointToSelectView.OnCreate = OnCreate
UIMainMapPointToSelectView.OnDestroy = OnDestroy
UIMainMapPointToSelectView.ComponentDefine = ComponentDefine
UIMainMapPointToSelectView.ComponentDestroy = ComponentDestroy
UIMainMapPointToSelectView.DataDefine = DataDefine
UIMainMapPointToSelectView.DataDestroy = DataDestroy
UIMainMapPointToSelectView.ReInit = ReInit
UIMainMapPointToSelectView.OnBackBtnClick = OnBackBtnClick
return UIMainMapPointToSelectView
