local UIMainBLBtnBase = require("UI.LWMainUI.Component.UIMainBottom.LeftLayoutBtns.UIMainBLBtnBase")
local UIMainBLBtnSearch = BaseClass("UIMainBLBtnSearch", UIMainBLBtnBase)
local base = UIMainBLBtnBase

local function OnAddMainBtnListener(self)
  base.OnAddMainBtnListener(self)
  self:AddUIListener(EventId.OnEnterCity, self.Refresh)
  self:AddUIListener(EventId.OnEnterWorld, self.Refresh)
end

local function OnRemoveMainBtnListener(self)
  base.OnRemoveMainBtnListener(self)
  self:RemoveUIListener(EventId.OnEnterCity, self.Refresh)
  self:RemoveUIListener(EventId.OnEnterWorld, self.Refresh)
end

local function OnClick(self)
  self.commonRedPoint:SetViewed()
  self.view.ctrl:OnClickSearchBtn()
end

local function CheckEnable(self)
  local inWorld = SceneUtils.GetIsInWorld()
  local unlock = self:CheckUnlock()
  return unlock and inWorld
end

UIMainBLBtnSearch.OnClick = OnClick
UIMainBLBtnSearch.OnAddMainBtnListener = OnAddMainBtnListener
UIMainBLBtnSearch.OnRemoveMainBtnListener = OnRemoveMainBtnListener
UIMainBLBtnSearch.CheckEnable = CheckEnable
return UIMainBLBtnSearch
