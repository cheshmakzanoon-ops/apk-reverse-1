local base = UIBaseView
local UILWSeasonCityOccupyListBaseView = BaseClass("UILWSeasonCityOccupyListBaseView", base)
local UILWSeasonCityTabLogic = require("UI.LWSeasonShared.UILWSeasonCityOccupyList.UILWSeasonCityTabLogic")

function UILWSeasonCityOccupyListBaseView:OnCreate()
  base.OnCreate(self)
  self.tabLogic = UILWSeasonCityTabLogic.New()
  self.tab = self:AddComponent(UIBaseContainer, "Root/ScrollView/Tab")
  self.tabScroll = self:AddComponent(UIBaseContainer, "Root/ScrollView")
  local toggleGroup = self.tab.transform:GetComponent(typeof(CS.UnityEngine.UI.ToggleGroup))
  self.tabLogic:TryToAddTab(self.tabScroll, self.tab, toggleGroup, self)
end

function UILWSeasonCityOccupyListBaseView:OnDestroy()
  self.tabLogic:OnDestroy(self)
  self.tab = nil
  self.tabScroll = nil
  self.tabLogic = nil
  base.OnDestroy(self)
end

function UILWSeasonCityOccupyListBaseView:SelectTab(tabIndex)
  self.tabLogic:SelectTabLogic(self, tabIndex)
end

function UILWSeasonCityOccupyListBaseView:HideAllTabLogic()
  self.tabLogic:HideAllTabLogic(self)
end

function UILWSeasonCityOccupyListBaseView:IsVailTabIndex(tabIndex)
  return self.tabLogic:IsVailTabIndex(tabIndex)
end

return UILWSeasonCityOccupyListBaseView
