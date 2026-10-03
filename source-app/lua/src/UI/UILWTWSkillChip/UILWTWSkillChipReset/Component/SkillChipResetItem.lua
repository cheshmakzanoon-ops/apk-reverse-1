local base = require("UI.UILWTacticalWeapon.Component.SkillChipPage.SkillChipCommonItem")
local SkillChipResetItem = BaseClass("SkillChipResetItem", base)
local Localization = CS.GameEntry.Localization
local skillChipCommon_path = "skillChipCommon"
local selected_path = "skillChipCommon/Selected"

local function OnCreate(self)
  base.OnCreate(self)
end

local function OnDestroy(self)
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  base.ComponentDefine(self)
  self.selected = self:AddComponent(UIImage, selected_path)
  self.selected:SetActive(false)
  self.eventTrigger = self:AddComponent(UIEventTrigger, skillChipCommon_path)
  self.eventTrigger:onLongPress(function()
    if self.longPressCallback then
      self.longPressCallback(self, self.skillChipInfo)
    end
  end)
  self.eventTrigger:OnPointerUp(function()
    if self.pointerUpCallback then
      self.pointerUpCallback(self, self.skillChipInfo)
    end
  end)
  self.eventTrigger:OnBeginDrag(function(eventData)
    if self.beginDragCallback then
      self.beginDragCallback(eventData)
    end
  end)
  self.eventTrigger:OnEndDrag(function(eventData)
    if self.endDragCallback then
      self.endDragCallback(eventData)
    end
  end)
  self.eventTrigger:OnDrag(function(eventData)
    if self.dragCallback then
      self.dragCallback(eventData)
    end
  end)
end

local function ComponentDestroy(self)
  base.ComponentDestroy(self)
  self.selected = nil
  self.eventTrigger = nil
end

local function DataDefine(self)
  base.DataDefine(self)
end

local function DataDestroy(self)
  base.DataDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnClick(self)
  if self.onClick then
    self.onClick(self, self.chipInfo, self.index)
    return
  end
end

local function SetSelected(self, selected)
  self.selected:SetActive(selected)
end

local function SetOnLongPress(self, callback)
  self.longPressCallback = callback
end

local function SetOnBeginDrag(self, callback)
  self.beginDragCallback = callback
end

local function SetOnEndDrag(self, callback)
  self.endDragCallback = callback
end

local function SetOnDrag(self, callback)
  self.dragCallback = callback
end

SkillChipResetItem.OnCreate = OnCreate
SkillChipResetItem.OnDestroy = OnDestroy
SkillChipResetItem.ComponentDefine = ComponentDefine
SkillChipResetItem.ComponentDestroy = ComponentDestroy
SkillChipResetItem.DataDefine = DataDefine
SkillChipResetItem.DataDestroy = DataDestroy
SkillChipResetItem.OnEnable = OnEnable
SkillChipResetItem.OnDisable = OnDisable
SkillChipResetItem.OnClick = OnClick
SkillChipResetItem.SetSelected = SetSelected
SkillChipResetItem.SetOnLongPress = SetOnLongPress
SkillChipResetItem.SetOnBeginDrag = SetOnBeginDrag
SkillChipResetItem.SetOnEndDrag = SetOnEndDrag
SkillChipResetItem.SetOnDrag = SetOnDrag
return SkillChipResetItem
