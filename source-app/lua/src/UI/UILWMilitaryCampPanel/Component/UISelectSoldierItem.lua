local UISoldierItem = require("UI/UIBuildDispatching/Component/UISoldierItem")
local UISelectSoldierItem = BaseClass("UISelectSoldierItem", UISoldierItem)
local base = UISoldierItem
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local UIGray = CS.UIGray

local function OnCreate(self)
  base.OnCreate(self)
end

local function OnDestroy(self)
  base.OnDestroy(self)
end

local function DataDefine(self)
  base.DataDefine(self)
  self.selected = false
end

local function DataDestroy(self)
  base.DataDestroy(self)
  self.clickCallBack = nil
end

local function ComponentDefine(self)
  base.ComponentDefine(self)
  self.selectedIcon = self:AddComponent(UIImage, "SelectedIcon")
  self.lockMask = self:AddComponent(UIImage, "LockMask")
  self.upImage = self:AddComponent(UIImage, "upImage")
end

local function ComponentDestroy(self)
  base.ComponentDestroy(self)
  self.selectedIcon = nil
end

local function SetData(self, soldierData, clickCallBack)
  base.SetData(self, soldierData, clickCallBack)
  if soldierData == nil then
    self:SetActive(false)
    return
  end
  self:SetActive(true)
  if soldierData.unlocked then
    self.lockMask:SetActive(false)
  else
    self.lockMask:SetActive(true)
  end
  self.upImage:SetActive(soldierData.isUp)
  self.selectedIcon:SetActive(self.selected)
end

local function SetSelected(self, selected)
  self.selectedIcon:SetActive(selected)
  if selected then
    self.countText:SetColorRGBA(0.9921568627450981, 0.7843137254901961, 0.2235294117647059, 1)
  else
    self.countText:SetColorRGBA(1, 1, 1, 1)
  end
  self.selected = selected
end

UISelectSoldierItem.OnCreate = OnCreate
UISelectSoldierItem.OnDestroy = OnDestroy
UISelectSoldierItem.DataDefine = DataDefine
UISelectSoldierItem.DataDestroy = DataDestroy
UISelectSoldierItem.ComponentDefine = ComponentDefine
UISelectSoldierItem.ComponentDestroy = ComponentDestroy
UISelectSoldierItem.SetData = SetData
UISelectSoldierItem.SetSelected = SetSelected
return UISelectSoldierItem
