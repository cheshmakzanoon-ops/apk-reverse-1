local txt_name_path = "txt_Name"
local go_select_path = "go_Select"
local go_red_path = "go_red"
local condition_path = "go_Select/Condition"
local base = UIAsyncContainer
local UISeasonCommonTabItem = BaseClass("UISeasonCommonTabItem", base)

function UISeasonCommonTabItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UISeasonCommonTabItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UISeasonCommonTabItem:ComponentDefine()
  self.txt_name = self:AddComponent(UITextMeshProUGUIEx, txt_name_path)
  self.go_select = self:AddComponent(UIImage, go_select_path)
  self.go_red = self:AddComponent(UIImage, go_red_path)
  self.tab_toggle = self:AddComponent(UIToggle, "")
  self.condition = self:AddComponent(UITextMeshProUGUIEx, condition_path)
  self.tab_toggle:SetOnValueChanged(function(tf)
    if tf then
      if not self.tab_toggle.selecting then
        DataCenter.LWSoundManager:PlaySound(6100022, false)
      end
      self.holder:SelectTab(self.index, true)
    end
    self.tab_toggle.selecting = false
  end)
end

function UISeasonCommonTabItem:ComponentDestroy()
  self.txt_name = nil
  self.go_select = nil
  self.condition = nil
  self.go_red = nil
end

function UISeasonCommonTabItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshSeasonCityTitleRed, self.RefreshRed)
end

function UISeasonCommonTabItem:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshSeasonCityTitleRed, self.RefreshRed)
  base.OnRemoveListener(self)
end

function UISeasonCommonTabItem:SetData(param)
  self.param = param
end

function UISeasonCommonTabItem:ReInit(group, view)
  self.tab_toggle:SetGroup(group)
  self.view = view
  self.index = self.param.tabType
  self.txt_name:SetLocalText(self.param.tabInfo.name)
  self.condition:SetLocalText(self.param.tabInfo.name)
  if view.activeTabIndex == self.index then
    self:SetOpenToggle()
  end
  self:RefreshRed()
end

function UISeasonCommonTabItem:SetOpenToggle()
  self.tab_toggle:SetIsOn(true)
end

function UISeasonCommonTabItem:SetToggleClose()
  self.tab_toggle:SetIsOn(false)
end

function UISeasonCommonTabItem:RefreshRed()
  if self.param == nil then
    return
  end
  if self.param.tabInfo.redHandle ~= nil then
    self.go_red:SetActive(self.view.activeTabIndex ~= self.index and self.param.tabInfo.redHandle())
  else
    self.go_red:SetActive(false)
  end
end

return UISeasonCommonTabItem
