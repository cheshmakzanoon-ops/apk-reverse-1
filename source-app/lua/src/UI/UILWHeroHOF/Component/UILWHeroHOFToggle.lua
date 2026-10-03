local UILWHeroHOFToggle = BaseClass("UILWHeroHOFToggle", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local redPoint_path = "RedPoint"
local lockIcon_path = "LockIcon"
local selected_path = "Selected"
local unselected_path = "Unselected"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.redPoint = self:AddComponent(UIImage, redPoint_path)
  self.lockIcon = self:AddComponent(UIImage, lockIcon_path)
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    if self.clickCallBack then
      self.clickCallBack(self.type)
    end
  end)
  self.selected = self:AddComponent(UIBaseContainer, selected_path)
  self.unselected = self:AddComponent(UIBaseContainer, unselected_path)
end

local function ComponentDestroy(self)
  self.redPoint = nil
  self.lockIcon = nil
  self.btn = nil
  self.selected = nil
  self.unselected = nil
end

local function DataDefine(self)
  self.type = nil
end

local function DataDestroy(self)
  self.type = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function SetData(self, type, clickCallBack)
  self.type = type
  self.clickCallBack = clickCallBack
end

local function SetSelected(self, selected)
  self.selectedState = selected
  self.selected:SetActive(selected)
  self.unselected:SetActive(not selected)
end

local function SetLocked(self, locked)
  self.lockIcon:SetActive(locked)
  UIGray.SetGray(self.transform, locked, true)
  if locked then
    self.redPoint:SetActive(false)
  end
end

local function SetRedPointShow(self, show)
  self.redPoint:SetActive(show)
end

UILWHeroHOFToggle.OnCreate = OnCreate
UILWHeroHOFToggle.OnDestroy = OnDestroy
UILWHeroHOFToggle.OnEnable = OnEnable
UILWHeroHOFToggle.OnDisable = OnDisable
UILWHeroHOFToggle.ComponentDefine = ComponentDefine
UILWHeroHOFToggle.ComponentDestroy = ComponentDestroy
UILWHeroHOFToggle.DataDefine = DataDefine
UILWHeroHOFToggle.DataDestroy = DataDestroy
UILWHeroHOFToggle.SetData = SetData
UILWHeroHOFToggle.SetSelected = SetSelected
UILWHeroHOFToggle.SetLocked = SetLocked
UILWHeroHOFToggle.SetRedPointShow = SetRedPointShow
return UILWHeroHOFToggle
