local base = require("UI.UILWTacticalWeapon.Component.SkillChipPage.SkillChipCommonItem")
local SkillChipManageSmallItem = BaseClass("SkillChipManageSmallItem", base)
local Localization = CS.GameEntry.Localization
local masterBg_path = "skillChipCommon/masterBg"
local master_txt_path = "skillChipCommon/masterBg/masterTxt"
local count_txt_path = "skillChipCommon/countTxt"
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
  self.masterBg = self:AddComponent(UIImage, masterBg_path)
  self.masterTxt = self:AddComponent(UIText, master_txt_path)
  self.countTxt = self:AddComponent(UIText, count_txt_path)
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
  self:SetCount(0)
  self:SetMaster(0)
end

local function ComponentDestroy(self)
  base.ComponentDestroy(self)
  self.masterBg = nil
  self.masterTxt = nil
  self.countTxt = nil
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
  if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UILWTWSkillChipDetail) then
    if self.chipInfo then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTWSkillChipDetail, {anim = true}, self.chipInfo)
    elseif self.chipId then
      if not self.chipTemplate then
        self.chipTemplate = TWSkillChipInfo.New()
      end
      self.chipTemplate:CreateFromTemplate(self.chipId, self.level, self.star)
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTWSkillChipDetail, {anim = true}, self.chipTemplate)
    end
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

local function SetMaster(self, masterIndex)
  if not masterIndex or masterIndex <= 0 then
    self.masterBg:SetActive(false)
    return
  end
  self.masterBg:SetActive(true)
  self.masterTxt:SetText(masterIndex)
end

local function SetCount(self, count)
  if count and 1 < count then
    self.countTxt:SetText(string.format("x%s", count))
    self.countTxt:SetActive(true)
  else
    self.countTxt:SetActive(false)
  end
end

SkillChipManageSmallItem.OnCreate = OnCreate
SkillChipManageSmallItem.OnDestroy = OnDestroy
SkillChipManageSmallItem.ComponentDefine = ComponentDefine
SkillChipManageSmallItem.ComponentDestroy = ComponentDestroy
SkillChipManageSmallItem.DataDefine = DataDefine
SkillChipManageSmallItem.DataDestroy = DataDestroy
SkillChipManageSmallItem.OnEnable = OnEnable
SkillChipManageSmallItem.OnDisable = OnDisable
SkillChipManageSmallItem.OnClick = OnClick
SkillChipManageSmallItem.SetSelected = SetSelected
SkillChipManageSmallItem.SetOnLongPress = SetOnLongPress
SkillChipManageSmallItem.SetOnBeginDrag = SetOnBeginDrag
SkillChipManageSmallItem.SetOnEndDrag = SetOnEndDrag
SkillChipManageSmallItem.SetOnDrag = SetOnDrag
SkillChipManageSmallItem.SetMaster = SetMaster
SkillChipManageSmallItem.SetCount = SetCount
return SkillChipManageSmallItem
