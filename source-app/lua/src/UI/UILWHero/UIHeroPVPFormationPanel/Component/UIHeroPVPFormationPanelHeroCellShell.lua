local UIHeroPVPFormationPanelHeroCellShell = BaseClass("UIHeroPVPFormationPanelHeroCellShell", UIBaseContainer)
local M = UIHeroPVPFormationPanelHeroCellShell
local base = UIBaseContainer
local UIHeroPVPFormationPanelHeroCell = require("UI.UILWHero.UIHeroPVPFormationPanel.Component.UIHeroPVPFormationPanelHeroCell")

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.root = self:AddComponent(UIBaseContainer, "")
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
  self.cellGoLoadReq = nil
  self.cellScript = nil
  self.selected = nil
  self.canvasGroupAlphaState = nil
  self.isShowGuide = nil
end

local function DataDestroy(self)
  if self.cellGoLoadReq ~= nil then
    self:GameObjectDestroy(self.cellGoLoadReq)
    self.cellGoLoadReq = nil
  end
  self.cellScript = nil
  self.selected = nil
  self.canvasGroupAlphaState = nil
  self.isShowGuide = nil
end

local function SetData(self, heroDisplayData, showFormation, index)
  self.heroDisplayData = heroDisplayData
  self.showFormation = showFormation
  if self.cellScript then
    self.cellScript:SetData(self.heroDisplayData, self.showFormation)
  elseif self.cellGoLoadReq == nil then
    self.cellGoLoadReq = self:GameObjectInstantiateAsync(UIAssets.UIHeroPVPFormationPanelHeroCell, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.name = "UIHeroPVPFormationPanelHeroCell" .. index
      go.transform:SetParent(self.root.transform)
      self.cellScript = self.root:AddComponent(UIHeroPVPFormationPanelHeroCell, go.name)
      self.cellScript:SetAnchoredPositionXY(0, 0)
      self.cellScript:SetLocalScaleXYZ(1, 1, 1)
      self.cellScript:SetData(self.heroDisplayData, self.showFormation)
      self.cellScript:SetSelected(self.selected)
      self.cellScript:SetCanvasGroupAlpha(self.canvasGroupAlphaState)
      if self.isShowGuide and self.view then
        self.view:ShowGuide(self.cellScript.heroCell)
      end
    end)
  end
end

local function SetSelected(self, selected)
  self.selected = selected
  if self.cellScript then
    self.cellScript:SetSelected(self.selected)
  end
end

local function SetCanvasGroupAlpha(self, state)
  self.canvasGroupAlphaState = state
  if self.cellScript then
    self.cellScript:SetCanvasGroupAlpha(self.canvasGroupAlphaState)
  end
end

local function ShowGuide(self)
  self.isShowGuide = true
end

M.OnCreate = OnCreate
M.OnDestroy = OnDestroy
M.OnEnable = OnEnable
M.OnDisable = OnDisable
M.ComponentDefine = ComponentDefine
M.ComponentDestroy = ComponentDestroy
M.DataDefine = DataDefine
M.DataDestroy = DataDestroy
M.SetData = SetData
M.SetSelected = SetSelected
M.SetCanvasGroupAlpha = SetCanvasGroupAlpha
M.ShowGuide = ShowGuide
return M
