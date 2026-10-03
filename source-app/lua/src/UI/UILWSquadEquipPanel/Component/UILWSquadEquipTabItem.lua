local UILWSquadEquipTabItem = BaseClass("UILWSquadEquipTabItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local this_path = ""
local name_path = "Layout/activityName"
local red_point_path = "RedPoint"
local select_img_path = "select"
local btn_path = "TypeButton"
local locked_icon_path = "Layout/LockIcon"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function ComponentDefine(self)
  self.canvasGroup = self:AddComponent(UICanvasGroup, this_path)
  self.name = self:AddComponent(UIText, name_path)
  self.redPoint = self:AddComponent(UIImage, red_point_path)
  self.select = self:AddComponent(UIImage, select_img_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    self:OnClick()
  end)
  self.lockedIcon = self:AddComponent(UIImage, locked_icon_path)
end

local function DataDefine(self)
  self.selected = false
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDestroy(self)
  self.canvasGroup = nil
  self.name = nil
  self.redPoint = nil
  self.select = nil
  self.btn = nil
  self.lockedIcon = nil
end

local function DataDestroy(self)
  self.index = nil
  self.tabData = nil
  self.selected = nil
  self.buildData = nil
end

local function Refresh(self, index, tabData)
  if not tabData then
    return
  end
  self.index = index
  self.tabData = tabData
  self.name:SetLocalText(self.tabData.name)
  if self.tabData.buildUuid then
    self.buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.tabData.buildUuid)
  end
  self.lockedIcon:SetActive(not self:BuildIsUnlock())
  self:RefreshRedPoint()
end

local function OnClick(self)
  if not self:BuildIsUnlock() then
    UIUtil.ShowTipsId(2000552)
    return
  end
  if self.index then
    self.view:OnToggleItemClick(self.index)
  end
end

local function SetSelected(self, state)
  self.select:SetActive(state)
  if state then
    self.name:SetColorRGBA(1, 1, 1, 1)
  else
    self.name:SetColorRGBA(0.753, 0.757, 0.773, 1)
  end
  self.selected = state
end

local function RefreshRedPoint(self)
  local hasRed = self:GetRedNum() > 0
  self.redPoint:SetActive(hasRed)
end

local function BuildIsUnlock(self)
  return self.buildData and self.buildData.level >= 1
end

local function GetRedNum(self)
  if self:BuildIsUnlock() then
    local hasRed = not table.IsNullOrEmpty(DataCenter.CommonEquipDataManager:IsHasBetterCommonEquip(CommonEquipType.SquadEquip, self.buildData.uuid))
    hasRed = hasRed or DataCenter.CommonEquipDataManager:IsCommonEquipCanUpgradeByOwner(CommonEquipType.SquadEquip, self.buildData.uuid)
    if hasRed then
      return 1
    end
    return 0
  else
    return 0
  end
end

UILWSquadEquipTabItem.OnCreate = OnCreate
UILWSquadEquipTabItem.OnDestroy = OnDestroy
UILWSquadEquipTabItem.ComponentDefine = ComponentDefine
UILWSquadEquipTabItem.ComponentDestroy = ComponentDestroy
UILWSquadEquipTabItem.DataDefine = DataDefine
UILWSquadEquipTabItem.DataDestroy = DataDestroy
UILWSquadEquipTabItem.Refresh = Refresh
UILWSquadEquipTabItem.OnClick = OnClick
UILWSquadEquipTabItem.SetSelected = SetSelected
UILWSquadEquipTabItem.RefreshRedPoint = RefreshRedPoint
UILWSquadEquipTabItem.GetRedNum = GetRedNum
UILWSquadEquipTabItem.BuildIsUnlock = BuildIsUnlock
return UILWSquadEquipTabItem
