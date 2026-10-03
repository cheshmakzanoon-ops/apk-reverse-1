local base = UIBaseContainer
local ActCalendarPropsItem = BaseClass("ActCalendarPropsItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function ActCalendarPropsItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function ActCalendarPropsItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ActCalendarPropsItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compResItem = self.viewSkin:AddComponent(self, UICommonResItem, 1)
  self.compFrame = self.viewSkin:AddComponent(self, UIBaseContainer, 2)
end

function ActCalendarPropsItem:ComponentDestroy()
  self.viewSkin = nil
  self.compResItem = nil
  self.compFrame = nil
end

function ActCalendarPropsItem:DataDefine()
end

function ActCalendarPropsItem:DataDestroy()
  self.clickHandler = nil
end

function ActCalendarPropsItem:SetData(param)
  self.param = param
  
  function param.clickCallBack(props)
    self:_onItemClick(props)
  end
  
  self.compResItem:ReInit(param)
  self.compResItem:SetItemCountActive(false)
end

function ActCalendarPropsItem:SetClickHandler(clickHandler)
  self.clickHandler = clickHandler
end

function ActCalendarPropsItem:SetSelectFrameVisible(visible)
  self.compFrame:SetActive(visible)
end

function ActCalendarPropsItem:_onItemClick(props)
  if self.clickHandler then
    self.clickHandler(self, props)
  end
end

return ActCalendarPropsItem
