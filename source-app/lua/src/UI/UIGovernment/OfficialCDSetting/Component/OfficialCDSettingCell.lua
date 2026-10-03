local OfficialCDSettingCell = BaseClass("OfficialCDSettingCell", UIBaseContainer)
local base = UIBaseContainer

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
  self.textCd = self:AddComponent(UIText, "CdText")
  self.compSelected = self:AddComponent(UIBaseContainer, "Bg/Selected")
  self.Click = self:AddComponent(UIButton, "Click")
  self.Click:SetOnClick(BindCallback(self, self.OnItemClick))
end

local function ComponentDestroy(self)
  self.textCd = nil
  self.compSelected = nil
  self.Click = nil
end

local function DataDefine(self)
  self.isExcludeSelf = false
  self.index = 0
end

local function DataDestroy(self)
  self.isExcludeSelf = nil
  self.index = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.OfficialCdSelectTogChanged, self.OnSelectChanged)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.OfficialCdSelectTogChanged, self.OnSelectChanged)
  base.OnRemoveListener(self)
end

local function OnItemClick(self)
  self:SetSelected(true)
  self.isExcludeSelf = true
  EventManager:GetInstance():Broadcast(EventId.OfficialCdSelectTogChanged, self.index)
end

local function SetData(self, param)
  if param == nil then
    return
  end
  self.index = param.index
  local time = param.time or ""
  self.textCd:SetText(time)
  self:SetSelected(param.isSelected)
end

local function SetSelected(self, selected)
  self.isSelected = selected
  self.compSelected:SetActive(selected)
end

local function OnSelectChanged(self, index)
  if self.isExcludeSelf then
    self.isExcludeSelf = false
    return
  end
  self:SetSelected(self.index == index)
end

OfficialCDSettingCell.OnCreate = OnCreate
OfficialCDSettingCell.OnDestroy = OnDestroy
OfficialCDSettingCell.OnEnable = OnEnable
OfficialCDSettingCell.OnDisable = OnDisable
OfficialCDSettingCell.ComponentDefine = ComponentDefine
OfficialCDSettingCell.ComponentDestroy = ComponentDestroy
OfficialCDSettingCell.DataDefine = DataDefine
OfficialCDSettingCell.DataDestroy = DataDestroy
OfficialCDSettingCell.OnAddListener = OnAddListener
OfficialCDSettingCell.OnRemoveListener = OnRemoveListener
OfficialCDSettingCell.OnItemClick = OnItemClick
OfficialCDSettingCell.SetData = SetData
OfficialCDSettingCell.SetSelected = SetSelected
OfficialCDSettingCell.OnSelectChanged = OnSelectChanged
return OfficialCDSettingCell
