local SkillChipSetToggle = BaseClass("SkillChipSetToggle", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local TacticalWeaponUtils = require("DataCenter.TacticalWeapon.TacticalWeaponManager.TacticalWeaponUtils")
local selected_path = "Selected"
local unselected_path = "Unselected"
local LockIcon = "Unselected/LockIcon"
local redPoint_path = "RedPoint"
local unselected_bg_path = "Unselected/UnselectedBg"
local selected_txt_path = "Selected/SelectedTxt"
local unselected_txt_path = "Unselected/UnselectedTxt"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.selected = self:AddComponent(UIImage, selected_path)
  self.unselected = self:AddComponent(UIImage, unselected_path)
  self.lockIcon = self:AddComponent(UIImage, LockIcon)
  self.lockIcon:SetActive(false)
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    self:OnClick()
  end)
  self.redPoint = self:AddComponent(UIImage, redPoint_path)
  self.unselectedBg = self:AddComponent(UIImage, unselected_bg_path)
  self.selectedTxt = self:AddComponent(UIText, selected_txt_path)
  self.unselectedTxt = self:AddComponent(UIText, unselected_txt_path)
end

local function ComponentDestroy(self)
  self.selected = nil
  self.unselected = nil
  self.lockIcon = nil
  self.btn = nil
  self.redPoint = nil
  self.unselectedBg = nil
  self.selectedTxt = nil
  self.unselectedTxt = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
end

local function SetData(self, param)
  if param == nil then
    return
  end
  self.lockIcon:SetActive(param.locked)
  self.selected:SetActive(param.selected)
  self.unselected:SetActive(not param.selected)
  self.param = param
  self.redPoint:SetActive(false)
  if not param.selected then
    if param.locked then
      self.unselectedBg:LoadSprite("Assets/Main/Sprites/UI/LWUITacticalWeapon/FX_WRJ_fangan03.png")
    else
      self.unselectedBg:LoadSprite("Assets/Main/Sprites/UI/LWUITacticalWeapon/FX_WRJ_fangan01.png")
    end
  end
  self.selectedTxt:SetText(string.format("No.%d", param.id))
  self.unselectedTxt:SetText(string.format("No.%d", param.id))
end

local function SetOnClick(self, func)
  self.onClick = func
end

local function OnClick(self)
  if self.onClick then
    self.onClick(self, self.param)
  end
end

local function RefreshRedPoint(self)
  if not self.param or self.param and self.param.locked then
    self.redPoint:SetActive(false)
    return
  end
  local showRedPoint = TacticalWeaponUtils.ChipSetShowRedPoint(self.param.id)
  self.redPoint:SetActive(showRedPoint)
end

SkillChipSetToggle.OnCreate = OnCreate
SkillChipSetToggle.OnDestroy = OnDestroy
SkillChipSetToggle.ComponentDefine = ComponentDefine
SkillChipSetToggle.ComponentDestroy = ComponentDestroy
SkillChipSetToggle.DataDefine = DataDefine
SkillChipSetToggle.DataDestroy = DataDestroy
SkillChipSetToggle.OnEnable = OnEnable
SkillChipSetToggle.OnDisable = OnDisable
SkillChipSetToggle.OnClick = OnClick
SkillChipSetToggle.SetData = SetData
SkillChipSetToggle.SetOnClick = SetOnClick
SkillChipSetToggle.RefreshRedPoint = RefreshRedPoint
return SkillChipSetToggle
