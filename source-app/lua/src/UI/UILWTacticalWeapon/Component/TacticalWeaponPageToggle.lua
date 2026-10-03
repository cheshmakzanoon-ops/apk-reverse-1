local TacticalWeaponPageToggle = BaseClass("TacticalWeaponPageToggle", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local ResourceManager = CS.GameEntry.Resource
local TacticalWeaponUtils = require("DataCenter.TacticalWeapon.TacticalWeaponManager.TacticalWeaponUtils")

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
  self.toggleSelectedBg = self:AddComponent(UIImage, "ToggleSelectedBg")
  self.redPoint = self:AddComponent(UIImage, "RedPoint")
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    if self.selected then
      return
    end
    self.holder:OnToggleClick(self.type)
  end)
  self.leftLine = self:AddComponent(UIImage, "LeftLine")
end

local function DataDefine(self)
end

local function ComponentDestroy(self)
  self.toggleSelectedBg = nil
  self.redPoint = nil
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

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshResourceItem, self.OnResItemUpdate)
  self:AddUIListener(EventId.PutonCommonEquip, self.OnEquipDataChange)
  self:AddUIListener(EventId.PutoffCommonEquip, self.OnEquipDataChange)
  self:AddUIListener(EventId.CommonEquipDataChanged, self.OnEquipDataChange)
  self:AddUIListener(EventId.TWSkillUpdate, self.OnChipDataChange)
  self:AddUIListener(EventId.RefreshItems, self.OnItemDataChange)
  self:AddUIListener(EventId.TWSkillChipStarUp, self.OnChipDataChange)
  self:AddUIListener(EventId.TWSkillChipUpgrade, self.OnChipDataChange)
  self:AddUIListener(EventId.TacticalWeaponLevelUp, self.OnResItemUpdate)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshResourceItem, self.OnResItemUpdate)
  self:RemoveUIListener(EventId.PutonCommonEquip, self.OnEquipDataChange)
  self:RemoveUIListener(EventId.PutoffCommonEquip, self.OnEquipDataChange)
  self:RemoveUIListener(EventId.CommonEquipDataChanged, self.OnEquipDataChange)
  self:RemoveUIListener(EventId.TWSkillUpdate, self.OnChipDataChange)
  self:RemoveUIListener(EventId.RefreshItems, self.OnItemDataChange)
  self:RemoveUIListener(EventId.TWSkillChipStarUp, self.OnChipDataChange)
  self:RemoveUIListener(EventId.TWSkillChipUpgrade, self.OnChipDataChange)
  self:RemoveUIListener(EventId.TacticalWeaponLevelUp, self.OnResItemUpdate)
end

local function SetType(self, type)
  self.type = type
  self:RefreshRedPoint()
end

local function SetSelected(self, selected)
  self.toggleSelectedBg:SetActive(selected)
  self.selected = selected
end

local function ShowLeftLine(self, show)
  self.leftLine:SetActive(show)
end

local function RefreshRedPoint(self)
  if not self.type then
    return
  end
  if self.type == TacticalWeaponPageType.Basic then
    self.redPoint:SetActive(DataCenter.TacticalWeaponManager:ShowRedPoint())
  elseif self.type == TacticalWeaponPageType.Equip then
    local hasUnlock = DataCenter.TacticalWeaponManager:IsEquipFunctionUnlock()
    if not hasUnlock then
      self.redPoint:SetActive(false)
      return
    end
    local hasRed = not table.IsNullOrEmpty(DataCenter.TacticalWeaponManager:IsSelfHasBetterEquip())
    hasRed = hasRed or DataCenter.TacticalWeaponManager:IsSelfCanUpgradeEquip()
    hasRed = hasRed or DataCenter.CommonEquipDataManager:ExistResearch()
    self.redPoint:SetActive(hasRed)
  elseif self.type == TacticalWeaponPageType.SkillChip then
    self.redPoint:SetActive(TacticalWeaponUtils.CheckChipMainSystemFunctionRedPoint())
  elseif self.type == TacticalWeaponPageType.ChipPlan then
    self.redPoint:SetActive(TacticalWeaponUtils.CheckChipPlanFunctionRedPoint())
  else
    self.redPoint:SetActive(false)
  end
end

local function OnResItemUpdate(self)
  if self.type ~= TacticalWeaponPageType.Basic then
    return
  end
  self:RefreshRedPoint()
end

local function OnEquipDataChange(self)
  if self.type ~= TacticalWeaponPageType.Equip then
    return
  end
  self:RefreshRedPoint()
end

local function OnChipDataChange(self)
  if self.type == TacticalWeaponPageType.SkillChip or self.type == TacticalWeaponPageType.ChipPlan then
    self:RefreshRedPoint()
  end
end

local function OnItemDataChange(self)
  if self.type ~= TacticalWeaponPageType.SkillChip then
    return
  end
  self:RefreshRedPoint()
end

TacticalWeaponPageToggle.OnCreate = OnCreate
TacticalWeaponPageToggle.OnDestroy = OnDestroy
TacticalWeaponPageToggle.OnEnable = OnEnable
TacticalWeaponPageToggle.OnDisable = OnDisable
TacticalWeaponPageToggle.OnAddListener = OnAddListener
TacticalWeaponPageToggle.OnRemoveListener = OnRemoveListener
TacticalWeaponPageToggle.ComponentDefine = ComponentDefine
TacticalWeaponPageToggle.DataDefine = DataDefine
TacticalWeaponPageToggle.ComponentDestroy = ComponentDestroy
TacticalWeaponPageToggle.DataDestroy = DataDestroy
TacticalWeaponPageToggle.SetType = SetType
TacticalWeaponPageToggle.SetSelected = SetSelected
TacticalWeaponPageToggle.RefreshRedPoint = RefreshRedPoint
TacticalWeaponPageToggle.OnResItemUpdate = OnResItemUpdate
TacticalWeaponPageToggle.OnEquipDataChange = OnEquipDataChange
TacticalWeaponPageToggle.ShowLeftLine = ShowLeftLine
TacticalWeaponPageToggle.OnChipDataChange = OnChipDataChange
TacticalWeaponPageToggle.OnItemDataChange = OnItemDataChange
return TacticalWeaponPageToggle
