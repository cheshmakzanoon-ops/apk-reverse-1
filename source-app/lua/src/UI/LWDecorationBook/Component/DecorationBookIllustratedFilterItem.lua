local DecorationBookIllustratedFilterItem = BaseClass("DecorationBookIllustratedFilterItem", UIBaseContainer)
local base = UIBaseContainer

function DecorationBookIllustratedFilterItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function DecorationBookIllustratedFilterItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function DecorationBookIllustratedFilterItem:ComponentDefine()
  self.toggleGroupContent = self:AddComponent(UIBaseContainer, "ToggleGroup")
  self.toggleGroup = self.toggleGroupContent.transform:GetComponent(typeof(CS.UnityEngine.UI.ToggleGroup))
  self.filter_toggle1 = self:AddComponent(UIToggle, "ToggleGroup/Toggle1/FilterToggle1")
  self.filter_toggle2 = self:AddComponent(UIToggle, "ToggleGroup/Toggle2/FilterToggle2")
  self.filter_toggle3 = self:AddComponent(UIToggle, "ToggleGroup/Toggle3/FilterToggle3")
  self.filter_toggle1:SetIsOn(true)
  self.filter_toggle2:SetIsOn(false)
  self.filter_toggle3:SetIsOn(false)
  self.filter_toggle1:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS(DecorationBookFilterType.All)
    end
  end)
  self.filter_toggle2:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS(DecorationBookFilterType.Have)
    end
  end)
  self.filter_toggle3:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS(DecorationBookFilterType.NotHave)
    end
  end)
  self.close_btn = self:AddComponent(UIButton, "panel")
  self.close_btn:SetOnClick(function()
    self:DoClosePanel()
  end)
end

function DecorationBookIllustratedFilterItem:ComponentDestroy()
end

function DecorationBookIllustratedFilterItem:DoClosePanel()
  EventManager:GetInstance():Broadcast(EventId.CloseDecorateBookFilter)
end

function DecorationBookIllustratedFilterItem:ToggleControlBorS(type)
  EventManager:GetInstance():Broadcast(EventId.DecorateBookFilter, type)
end

return DecorationBookIllustratedFilterItem
