local UILWHeroHOFPanelView = BaseClass("UILWHeroHOFPanelView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local UIHeroHonorCellBig = require("UI.UILWHeroHOF.Component.UIHeroHonorCellBig")
local UILWHeroHOFToggle = require("UI.UILWHeroHOF.Component.UILWHeroHOFToggle")
local tankHeroToggle_path = "Root/Top/Toggles/TankHeroToggle"
local aircraftHeroToggle_path = "Root/Top/Toggles/AircraftHeroToggle"
local missileHeroToggle_path = "Root/Top/Toggles/MissileHeroToggle"
local backBtn_path = "Root/BtnBack"
local heroGridScroll_path = "Root/Center/HeroGridScroll"
local heroGridScrollContainer_path = "Root/Center/HeroGridScroll/Viewport/HeroGridContent"
local emptyContainer_path = "Root/Center/EmptyContainer"
local emptyGotoBtn_path = "Root/Center/EmptyContainer/EmptyGotoBtn"

local function OnItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.heroGridScroll:AddComponent(UIHeroHonorCellBig, itemObj)
  cellItem:SetActive(true)
  if self.heroesList[index] then
    cellItem:SetData(self.heroesList[index], self.clickHeroCallBack)
    cellItem:EnableRedPoint()
    cellItem:ShowEffectTipText()
  end
end

local function OnItemMoveOut(self, itemObj, index)
  self.heroGridScroll:RemoveComponent(itemObj.name, UIHeroHonorCellBig)
end

local function ClearScroll(self)
  self.heroGridScroll:RemoveComponents(UIHeroHonorCellBig)
  self.heroGridScroll:ClearCells()
end

local function ComponentDefine(self)
  self.tankHeroToggle = self:AddComponent(UILWHeroHOFToggle, tankHeroToggle_path)
  self.tankHeroToggle:SetData(HeroType.Tank, self.clickToggleCallBack)
  self.aircraftHeroToggle = self:AddComponent(UILWHeroHOFToggle, aircraftHeroToggle_path)
  self.aircraftHeroToggle:SetData(HeroType.Aircraft, self.clickToggleCallBack)
  self.missileHeroToggle = self:AddComponent(UILWHeroHOFToggle, missileHeroToggle_path)
  self.missileHeroToggle:SetData(HeroType.Missile, self.clickToggleCallBack)
  self.heroToggles = {
    [HeroType.Tank] = self.tankHeroToggle,
    [HeroType.Missile] = self.missileHeroToggle,
    [HeroType.Aircraft] = self.aircraftHeroToggle
  }
  self.backBtn = self:AddComponent(UIButton, backBtn_path)
  self.backBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.heroGridScroll = self:AddComponent(UIScrollView, heroGridScroll_path)
  self.heroGridScroll:SetOnItemMoveIn(function(itemObj, index)
    OnItemMoveIn(self, itemObj, index)
  end)
  self.heroGridScroll:SetOnItemMoveOut(function(itemObj, index)
    OnItemMoveOut(self, itemObj, index)
  end)
  self.heroGridScrollContainer = self:AddComponent(UIBaseContainer, heroGridScrollContainer_path)
  self.emptyContainer = self:AddComponent(UIBaseContainer, emptyContainer_path)
  self.emptyGotoBtn = self:AddComponent(UIButton, emptyGotoBtn_path)
  self.emptyGotoBtn:SetOnClick(function()
    if self.selectedType then
      GoToUtil.GotoOpenView(UIWindowNames.UIHeroListPanel, {
        anim = false,
        UIMainAnim = UIMainAnimType.AllHide
      }, nil, nil, self.selectedType)
    end
  end)
  self.emptyContainer:SetActive(false)
end

local function ComponentDestroy(self)
  self.tankHeroToggle = nil
  self.tankHeroToggleRedPoint = nil
  self.aircraftHeroToggle = nil
  self.aircraftHeroToggleRedPoint = nil
  self.missileHeroToggle = nil
  self.missileHeroToggleRedPoint = nil
  self.heroToggles = nil
  self.backBtn = nil
  self.heroGridScroll = nil
  self.heroGridScrollContainer = nil
end

local function OnClickToggle(self, type)
  if not type then
    return
  end
  if self.typeBuildings and self.typeBuildings[type] then
    local typeBuilding = self.typeBuildings[type]
    if typeBuilding and typeBuilding.level >= self.functionUnlockLevel then
      self:OnSelectType(type)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHeroHOFBulidingTip, {anim = true}, HeroTypeBuilding[type], self.functionUnlockLevel)
    end
  end
end

local function DataDefine(self)
  self.selectedType = nil
  
  function self.clickHeroCallBack(transform, heroUuid)
    if heroUuid then
      local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
      if heroData then
        if heroData:IsUnlockHonorWall() then
          UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHeroHonorLevelUpgrade, {anim = true}, heroUuid)
        else
          local arrowData = {
            arrowType = HeroDetailGuideArrowType.Rank
          }
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, heroUuid, {heroUuid}, nil, arrowData)
        end
      end
    end
  end
  
  self.clickToggleCallBack = BindCallback(self, OnClickToggle)
  self.functionUnlockLevel = LuaEntry.DataConfig:TryGetNum("honor_wall_unlock", "k1", 1)
end

local function DataDestroy(self)
  self.selectedType = nil
  self.clickHeroCallBack = nil
  self.clickToggleCallBack = nil
end

local function RefreshToggleState(self)
  self.tankBuilding = DataCenter.BuildManager:GetFunbuildByItemID(HeroTypeBuilding[HeroType.Tank])
  self.missileBuilding = DataCenter.BuildManager:GetFunbuildByItemID(HeroTypeBuilding[HeroType.Missile])
  self.aircraftBuilding = DataCenter.BuildManager:GetFunbuildByItemID(HeroTypeBuilding[HeroType.Aircraft])
  self.typeBuildings = {
    [HeroType.Tank] = self.tankBuilding,
    [HeroType.Missile] = self.missileBuilding,
    [HeroType.Aircraft] = self.aircraftBuilding
  }
  for i, v in pairs(self.heroToggles) do
    local typeBuilding = self.typeBuildings[i]
    if typeBuilding and typeBuilding.level >= self.functionUnlockLevel then
      v:SetLocked(false)
    else
      v:SetLocked(true)
    end
  end
end

local function RefreshToggleRedPoint(self)
  for i, v in pairs(self.heroToggles) do
    local typeBuilding = self.typeBuildings[i]
    if typeBuilding and typeBuilding.level >= self.functionUnlockLevel then
      v:SetRedPointShow(HeroRedPointManager:HasHeroCanUpgradeHonorLevel(i))
    end
  end
end

local function OnCreate(self)
  base.OnCreate(self)
  DataDefine(self)
  ComponentDefine(self)
  self.gotoType, self.gotoHeroId = self:GetUserData()
  if self.gotoType == nil then
    self.gotoType = HeroType.Tank
  end
  RefreshToggleState(self)
  RefreshToggleRedPoint(self)
  self:OnSelectType(self.gotoType)
  if self.gotoHeroId then
    local cellIndex
    for i, v in pairs(self.heroesList) do
      if v == self.gotoHeroId then
        cellIndex = i
        break
      end
    end
    if cellIndex then
      self.heroGridScroll:ScrollToCell(cellIndex - 1, 0)
    end
    self.clickHeroCallBack(nil, self.gotoHeroId)
  end
end

local function OnDestroy(self)
  ClearScroll(self)
  DataDestroy(self)
  ComponentDestroy(self)
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function RefreshType(self, scrollToTop)
  self.heroesList = self.ctrl:GetHeroesByType(self.selectedType)
  local count = #self.heroesList
  self.heroGridScroll:SetActive(0 < count)
  self.emptyContainer:SetActive(count <= 0)
  if 0 < count then
    self.emptyContainer:SetActive(false)
    self.heroGridScroll:SetTotalCount(count)
    if scrollToTop then
      self.heroGridScroll:RefillCells()
    else
      self.heroGridScroll:RefreshCells()
    end
  end
end

local function OnSelectType(self, type)
  if self.selectedType == type then
    return
  end
  self.selectedType = type
  for i, v in pairs(self.heroToggles) do
    v:SetSelected(i == type)
  end
  self:RefreshType(true)
end

local function OnHeroDataUpdate(self)
  RefreshToggleRedPoint(self)
  self:RefreshType()
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.HeroHonorLevelUpgrade, self.OnHeroDataUpdate)
  self:AddUIListener(EventId.HeroLvUpSuccess, self.OnHeroDataUpdate)
  self:AddUIListener(EventId.HeroFragmentItemUpdate, self.OnHeroDataUpdate)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.HeroHonorLevelUpgrade, self.OnHeroDataUpdate)
  self:RemoveUIListener(EventId.HeroLvUpSuccess, self.OnHeroDataUpdate)
  self:RemoveUIListener(EventId.HeroFragmentItemUpdate, self.OnHeroDataUpdate)
end

UILWHeroHOFPanelView.OnCreate = OnCreate
UILWHeroHOFPanelView.OnDestroy = OnDestroy
UILWHeroHOFPanelView.OnEnable = OnEnable
UILWHeroHOFPanelView.OnDisable = OnDisable
UILWHeroHOFPanelView.ComponentDefine = ComponentDefine
UILWHeroHOFPanelView.ComponentDestroy = ComponentDestroy
UILWHeroHOFPanelView.DataDefine = DataDefine
UILWHeroHOFPanelView.DataDestroy = DataDestroy
UILWHeroHOFPanelView.OnSelectType = OnSelectType
UILWHeroHOFPanelView.RefreshType = RefreshType
UILWHeroHOFPanelView.OnHeroDataUpdate = OnHeroDataUpdate
UILWHeroHOFPanelView.OnAddListener = OnAddListener
UILWHeroHOFPanelView.OnRemoveListener = OnRemoveListener
return UILWHeroHOFPanelView
