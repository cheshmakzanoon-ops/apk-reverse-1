local UIMainBLBtnBase = require("UI.LWMainUI.Component.UIMainBottom.LeftLayoutBtns.UIMainBLBtnBase")
local UIMainBLBtnBuild = BaseClass("UIMainBLBtnBuild", UIMainBLBtnBase)
local base = UIMainBLBtnBase

local function OnAddMainBtnListener(self)
  base.OnAddMainBtnListener(self)
  self:AddUIListener(EventId.LUA_BUILD_INIT_END, self.Refresh)
  self:AddUIListener(EventId.BuildLevelUp, self.Refresh)
  self:AddUIListener(EventId.UPDATE_BUILD_DATA, self.Refresh)
  self:AddUIListener(EventId.LWSeasonWeekCardInfo, self.Refresh)
  self:AddUIListener(EventId.LWSeasonWeekCardInfoUpdate, self.Refresh)
  self:AddUIListener(EventId.LWSeasonTrendsRewardRedPoint, self.Refresh)
  self:AddUIListener(EventId.UPDATE_SCIENCE_DATA, self.Refresh)
  self:AddUIListener(EventId.RefreshCommonRedPoint, self.Refresh)
end

local function OnRemoveMainBtnListener(self)
  base.OnRemoveMainBtnListener(self)
  self:RemoveUIListener(EventId.LUA_BUILD_INIT_END, self.Refresh)
  self:RemoveUIListener(EventId.BuildLevelUp, self.Refresh)
  self:RemoveUIListener(EventId.UPDATE_BUILD_DATA, self.Refresh)
  self:RemoveUIListener(EventId.LWSeasonWeekCardInfo, self.Refresh)
  self:RemoveUIListener(EventId.LWSeasonWeekCardInfoUpdate, self.Refresh)
  self:RemoveUIListener(EventId.LWSeasonTrendsRewardRedPoint, self.Refresh)
  self:RemoveUIListener(EventId.UPDATE_SCIENCE_DATA, self.Refresh)
  self:RemoveUIListener(EventId.RefreshCommonRedPoint, self.Refresh)
end

local function OnClick(self)
  self.view.ctrl:OnFunctionClick(self.type)
end

local function CheckEnable(self)
  local unlock = self:CheckUnlock()
  local canShow = CS.SceneManager:IsInCity()
  return unlock and canShow
end

UIMainBLBtnBuild.OnClick = OnClick
UIMainBLBtnBuild.OnAddMainBtnListener = OnAddMainBtnListener
UIMainBLBtnBuild.OnRemoveMainBtnListener = OnRemoveMainBtnListener
UIMainBLBtnBuild.CheckEnable = CheckEnable
return UIMainBLBtnBuild
