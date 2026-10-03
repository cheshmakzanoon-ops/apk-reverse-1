local UIBFDsbDuelActRewardViewToggleItemRenderer = BaseClass("UIBFDsbDuelActRewardViewToggleItemRenderer", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

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

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.compActive = self:AddComponent(UIBaseContainer, "Active")
  self.compInactive = self:AddComponent(UIBaseContainer, "Inactive")
  self.btnSelf = self:AddComponent(UIButton, "")
  self.btnSelf:SetOnClick(function()
    self:OnBtnSelfClick()
  end)
  self.tmpActiveName = self:AddComponent(UITextMeshProUGUIEx, "Inactive/TmpInactiveName")
  self.tmpInActiveName = self:AddComponent(UITextMeshProUGUIEx, "Active/TmpActiveName")
  self.index = 0
  self:SetSelection(-1)
end

local function ComponentDestroy(self)
  self.compActive = nil
  self.compInactive = nil
  self.btnSelf = nil
  self.tmpActiveName = nil
  self.tmpInActiveName = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnBtnSelfClick(self)
  if self.view then
    self.view:OnToggleClicked(self.index)
  end
end

function UIBFDsbDuelActRewardViewToggleItemRenderer:SetData(index, data, view)
  self.index = index
  self.tmpActiveName:SetLocalText(data.name)
  self.tmpInActiveName:SetLocalText(data.name)
  self.view = view
end

function UIBFDsbDuelActRewardViewToggleItemRenderer:SetSelection(selection)
  self.compActive:SetActive(selection == self.index)
  self.compInactive:SetActive(selection ~= self.index)
end

UIBFDsbDuelActRewardViewToggleItemRenderer.OnCreate = OnCreate
UIBFDsbDuelActRewardViewToggleItemRenderer.OnDestroy = OnDestroy
UIBFDsbDuelActRewardViewToggleItemRenderer.OnEnable = OnEnable
UIBFDsbDuelActRewardViewToggleItemRenderer.OnDisable = OnDisable
UIBFDsbDuelActRewardViewToggleItemRenderer.ComponentDefine = ComponentDefine
UIBFDsbDuelActRewardViewToggleItemRenderer.ComponentDestroy = ComponentDestroy
UIBFDsbDuelActRewardViewToggleItemRenderer.DataDefine = DataDefine
UIBFDsbDuelActRewardViewToggleItemRenderer.DataDestroy = DataDestroy
UIBFDsbDuelActRewardViewToggleItemRenderer.OnAddListener = OnAddListener
UIBFDsbDuelActRewardViewToggleItemRenderer.OnRemoveListener = OnRemoveListener
UIBFDsbDuelActRewardViewToggleItemRenderer.OnBtnSelfClick = OnBtnSelfClick
return UIBFDsbDuelActRewardViewToggleItemRenderer
