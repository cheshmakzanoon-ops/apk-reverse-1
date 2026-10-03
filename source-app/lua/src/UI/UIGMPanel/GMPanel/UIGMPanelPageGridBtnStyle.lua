local base = UIAsyncContainer
local UIGMPanelPageGridBtnStyle = BaseClass("UIGMPanelPageGridBtnStyle", base)
local Localization = CS.GameEntry.Localization

function UIGMPanelPageGridBtnStyle:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIGMPanelPageGridBtnStyle:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIGMPanelPageGridBtnStyle:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compUIGMPanelPageGridBtn = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
  self.gridInfinityScrollViewContent = self.viewSkin:AddComponent(self, GridInfinityScrollView, 2)
  self:SetOffsetMinXY(0, 0)
  self:SetOffsetMaxXY(0, 0)
end

function UIGMPanelPageGridBtnStyle:ComponentDestroy()
  self.viewSkin = nil
  self.compUIGMPanelPageGridBtn = nil
  self.gridInfinityScrollViewContent = nil
end

function UIGMPanelPageGridBtnStyle:DataDefine()
end

function UIGMPanelPageGridBtnStyle:DataDestroy()
end

function UIGMPanelPageGridBtnStyle:OnAddListener()
  base.OnAddListener(self)
end

function UIGMPanelPageGridBtnStyle:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIGMPanelPageGridBtnStyle:Refresh(pageData)
end

return UIGMPanelPageGridBtnStyle
