local AllianceWarPlayerSoliderItem = BaseClass("AllianceWarPlayerSoliderItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local icon_path = "Icon"
local lv_path = "Icon/lv"
local count_path = "count"
local info_path = "Btn_Info"

local function OnCreate(self)
  base.OnCreate(self)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.lv = self:AddComponent(UIText, lv_path)
  self.count = self:AddComponent(UIText, count_path)
  self._info_btn = self:AddComponent(UIButton, info_path)
  self._info_btn:SetOnClick(function()
  end)
  self.data = nil
end

local function OnDestroy(self)
  self.icon = nil
  self.count = nil
  self.data = nil
  base.OnDestroy(self)
end

local function SetData(self, data, count)
  self.data = data
  self.icon:LoadSprite(string.format(LoadPath.SoldierIcons, data.icon))
  self.count:SetText("x " .. string.GetFormattedSeperatorNum(count))
  self.lv:SetText(self.data.level)
end

local function OnShowClick(self)
  if self.data then
    self.view:SetSoliderInfo(self.transform, self.data.name)
  end
end

AllianceWarPlayerSoliderItem.OnCreate = OnCreate
AllianceWarPlayerSoliderItem.OnDestroy = OnDestroy
AllianceWarPlayerSoliderItem.SetData = SetData
AllianceWarPlayerSoliderItem.OnShowClick = OnShowClick
return AllianceWarPlayerSoliderItem
