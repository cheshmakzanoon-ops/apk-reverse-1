local LWEffectOverviewHeroDetailView = BaseClass("LWEffectOverviewHeroDetailView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWEffectOverviewHeroDetailItem = require("UI.LWEffectOverviewHeroDetail.Component.LWEffectOverviewHeroDetailItem")
local Screen = CS.UnityEngine.Screen
local Direction = {LEFT = 1, RIGHT = 2}
local ParamData = {
  title = "",
  content = "",
  position = Vector2.zero,
  deltaX = 0,
  deltaY = 0,
  closeCallBack = nil,
  data = nil
}
local ParamDataClass = DataClass("ParamDataClass", ParamData)

local function OnCreate(self)
  base.OnCreate(self)
  self.param = nil
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self.param = nil
  self:ClearScroll()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self.param = self:GetUserData()
  local contentDeltaX = 248
  local contentDeltaY = 34
  local contentDeltaY2 = 320
  local arrowMidPosX = 80
  local arrowMidPosY = 80
  local arrowX = self.param.position.x
  local arrowY = self.param.position.y
  self.imgArrow:SetPositionXYZ(arrowX, arrowY, 0)
  local anchoredPosition = self.imgArrow:GetAnchoredPosition()
  local contentPosX = anchoredPosition.x - contentDeltaX
  local contentPosY = 0
  if anchoredPosition.y > -100 then
    self.imgArrow:SetEulerAnglesXYZ(0, 0, 0)
    self.imgArrow:SetPositionXYZ(arrowX, arrowY - self.param.deltaY, 0)
    anchoredPosition = self.imgArrow:GetAnchoredPosition()
    contentPosY = anchoredPosition.y - self.param.deltaY + contentDeltaY
  else
    self.imgArrow:SetEulerAnglesXYZ(0, 0, 180)
    self.imgArrow:SetPositionXYZ(arrowX, arrowY + self.param.deltaY, 0)
    anchoredPosition = self.imgArrow:GetAnchoredPosition()
    contentPosY = anchoredPosition.y + self.param.deltaY + contentDeltaY2
  end
  self.content:SetAnchoredPositionXY(contentPosX, contentPosY)
  self.textTitle:SetLocalText(110295)
  self:RefreshHeroListView()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  local btnPanel = self:AddComponent(UIButton, "Panel")
  btnPanel:SetOnClick(function()
    if self.param ~= nil and self.param.closeCallBack ~= nil then
      self.param.closeCallBack()
    end
    self.ctrl.CloseSelf(self.ctrl)
  end)
  self.imgArrow = self:AddComponent(UIBaseContainer, "ImgArrow")
  self.content = self:AddComponent(UIBaseContainer, "content")
  self.textTitle = self:AddComponent(UIText, "content/TitleTextContent")
  self.heroList = self:AddComponent(GridInfinityScrollView, "content/heroListScroll/Content")
  self.heroListScroll = self:AddComponent(UIBaseContainer, "content/heroListScroll")
end

local function ComponentDestroy(self)
  self.imgArrow = nil
  self.content = nil
  self.textTitle = nil
  self.heroList = nil
  self.heroListScroll = nil
end

local function DataDefine(self)
  self.hasInitHeroScroll = false
  self.listGO = {}
  self.curCondition = -1
end

local function DataDestroy(self)
  self.showDataList = nil
  self.listGO = nil
  self.curCondition = -1
end

function LWEffectOverviewHeroDetailView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.EffectOverviewDataDirty, self.RefreshHeroListView)
end

function LWEffectOverviewHeroDetailView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.EffectOverviewDataDirty, self.RefreshHeroListView)
end

local function RefreshHeroListView(self)
  self.heroList:SetAnchoredPositionXY(0, 0)
  self:ShowCells()
end

local function ClearScroll(self)
  self.heroListScroll:RemoveComponents(LWEffectOverviewHeroDetailItem)
  self.heroList:DestroyChildNode()
end

local function OnInitScroll(self, go, index)
  local item = self.heroListScroll:AddComponent(LWEffectOverviewHeroDetailItem, go)
  self.listGO[go] = item
end

local function ShowCells(self)
  local totalData = DataCenter.LWEffectOverviewManager:GetShowData()
  local overViewMetaId = self.param.data
  local showHeroListData = totalData[overViewMetaId].heroSkillEffect.data
  local showData = {}
  for k, v in pairs(showHeroListData) do
    local itemData = {}
    itemData.effectId = totalData[overViewMetaId].cfg.effectId
    itemData.metaId = v.id
    itemData.isHave = v.isHave
    itemData.isInCity = v.isInCity
    itemData.value = v.value
    local heroConfig = DataCenter.HeroTemplateManager:GetTemplate(itemData.metaId)
    itemData.heroConfig = heroConfig
    if itemData.isHave then
      local heroData = DataCenter.HeroDataManager:GetHeroByHeroId(itemData.metaId)
      itemData.heroData = heroData
    end
    table.insert(showData, itemData)
  end
  table.sort(showData, function(a, b)
    if a.isInCity ~= b.isInCity then
      if a.isInCity then
        return true
      else
        return false
      end
    end
    if a.isHave ~= b.isHave then
      if a.isHave then
        return true
      else
        return false
      end
    end
    if a.heroConfig.quality ~= b.heroConfig.quality then
      return a.heroConfig.quality > b.heroConfig.quality
    end
    return a.metaId < b.metaId
  end)
  self.showDataList = showData
  local dataCount = table.count(self.showDataList)
  if 0 < dataCount then
    self.heroListScroll:SetActive(true)
    if not self.hasInitHeroScroll then
      local bindFunc1 = BindCallback(self, self.OnInitScroll)
      local bindFunc2 = BindCallback(self, self.OnUpdateScroll)
      local bindFunc3 = BindCallback(self, self.OnDestroyScrollItem)
      self.heroList:Init(bindFunc1, bindFunc2, bindFunc3)
    end
    self.hasInitHeroScroll = true
    self.heroList:SetItemCount(dataCount)
    self.heroList:ForceUpdate()
  else
    self.heroListScroll:SetActive(false)
  end
end

local function OnInitScroll(self, go, index)
  local item = self.heroListScroll:AddComponent(LWEffectOverviewHeroDetailItem, go)
  self.listGO[go] = item
end

local function OnUpdateScroll(self, go, index)
  local item = self.listGO[go]
  local itemData = self.showDataList[index + 1]
  item:SetActive(itemData ~= nil)
  if itemData ~= nil then
    item:SetData(itemData, BindCallback(self, self.OnHeroCellClick))
  end
end

local function OnDestroyScrollItem(self, go, index)
end

local function OnHeroCellClick(self, data)
  if data.isInCity then
    local id = data.heroData.uuid
    local arrowData = {
      arrowType = HeroDetailGuideArrowType.Rank,
      heroUid = id
    }
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, id, {id}, nil, arrowData)
  elseif data.isHave then
    local info = DataCenter.CityCarbarnManager:GetVacancyPos()
    if info ~= nil then
      local squad_data = DataCenter.ArmyFormationDataManager:GetFormationByType(EnterHeroSquadPanelWay.ParkingLotBuilding, info.teamIndex)
      if squad_data == nil then
        return
      end
      squad_data:SetLocalHero(info.index, data.heroData.uuid)
      local cur_heroes = squad_data:GenerateServerHeroArray()
      SFSNetwork.SendMessage(MsgDefines.FormationSave, squad_data.index, cur_heroes, 1)
    else
      local point = BuildingUtils.GetPointByBuildCanPut(BuildingTypes.LW_BUILD_HERO, SceneUtils.WorldToTileIndex(CS.SceneManager.World.CurTarget))
      if point == nil then
        UIUtil.ShowTipsId(800356)
        return
      end
      local hero_id = data.metaId
      local param = {}
      param.buildingId = BuildingTypes.LW_BUILD_HERO
      param.pointId = point
      param.itemUuid = ""
      param.pathTime = 0
      param.robotUuid = 0
      param.heroId = hero_id
      param.targetServerId = LuaEntry.Player:GetCurServerId()
      SFSNetwork.SendMessage(MsgDefines.FreeBuildingPlaceNew, param, false)
    end
  else
    local id = data.metaId
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, id, {id}, nil, nil)
  end
end

LWEffectOverviewHeroDetailView.ParamDataClass = ParamDataClass
LWEffectOverviewHeroDetailView.Direction = Direction
LWEffectOverviewHeroDetailView.OnCreate = OnCreate
LWEffectOverviewHeroDetailView.OnDestroy = OnDestroy
LWEffectOverviewHeroDetailView.OnEnable = OnEnable
LWEffectOverviewHeroDetailView.OnDisable = OnDisable
LWEffectOverviewHeroDetailView.ComponentDefine = ComponentDefine
LWEffectOverviewHeroDetailView.ComponentDestroy = ComponentDestroy
LWEffectOverviewHeroDetailView.DataDefine = DataDefine
LWEffectOverviewHeroDetailView.DataDestroy = DataDestroy
LWEffectOverviewHeroDetailView.RefreshHeroListView = RefreshHeroListView
LWEffectOverviewHeroDetailView.ClearScroll = ClearScroll
LWEffectOverviewHeroDetailView.OnInitScroll = OnInitScroll
LWEffectOverviewHeroDetailView.ShowCells = ShowCells
LWEffectOverviewHeroDetailView.OnInitScroll = OnInitScroll
LWEffectOverviewHeroDetailView.OnUpdateScroll = OnUpdateScroll
LWEffectOverviewHeroDetailView.OnDestroyScrollItem = OnDestroyScrollItem
LWEffectOverviewHeroDetailView.OnHeroCellClick = OnHeroCellClick
return LWEffectOverviewHeroDetailView
