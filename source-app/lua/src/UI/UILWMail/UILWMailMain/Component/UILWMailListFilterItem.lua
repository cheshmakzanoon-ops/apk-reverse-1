local UILWMailListFilterItem = BaseClass("UILWMailListFilterItem", UIBaseContainer)
local base = UIBaseContainer
local filter_name_path = "FilterName"
local toggle_path = "Toggle"

function UILWMailListFilterItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWMailListFilterItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWMailListFilterItem:ComponentDefine()
  self.filter_name = self:AddComponent(UITextMeshProUGUIEx, filter_name_path)
  self.toggle = self:AddComponent(UIToggle, toggle_path)
  self.toggle:SetOnValueChanged(function(isOn)
    self.selectedList[self.index] = isOn
    if self.onItemSelect then
      self.onItemSelect(self, self.index)
    end
  end)
end

function UILWMailListFilterItem:ComponentDestroy()
  self.filter_name = nil
  self.toggle = nil
end

function UILWMailListFilterItem:DataDefine()
end

function UILWMailListFilterItem:DataDestroy()
end

function UILWMailListFilterItem:OnEnable()
  base.OnEnable(self)
end

function UILWMailListFilterItem:OnDisable()
  base.OnDisable(self)
end

function UILWMailListFilterItem:OnAddListener()
end

function UILWMailListFilterItem:OnRemoveListener()
end

function UILWMailListFilterItem:RefreshView(index, data, selectedList, onItemSelect)
  self.index = index
  self.selectedList = selectedList
  self.onItemSelect = onItemSelect
  self.filter_name:SetLocalText(data.name)
  self:UpdateToggle(index)
end

function UILWMailListFilterItem:UpdateToggle(index)
  index = index or self.index
  self.toggle:SetIsOnWithoutNotify(self.selectedList[index] == true)
end

return UILWMailListFilterItem
