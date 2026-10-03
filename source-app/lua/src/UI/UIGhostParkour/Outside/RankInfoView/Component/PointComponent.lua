local base = UIBaseContainer
local PointComponent = BaseClass("PointComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function PointComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function PointComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function PointComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgPointUnSelect = self.viewSkin:AddComponent(self, UIImage, 1)
  self.imgPointSelect = self.viewSkin:AddComponent(self, UIImage, 2)
end

function PointComponent:ComponentDestroy()
  self.viewSkin = nil
  self.imgPointUnSelect = nil
  self.imgPointSelect = nil
end

function PointComponent:DataDefine()
end

function PointComponent:DataDestroy()
end

function PointComponent:OnAddListener()
  base.OnAddListener(self)
end

function PointComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function PointComponent:ReInit(value)
  self.imgPointSelect:SetActive(value)
  self.imgPointUnSelect:SetActive(not value)
end

return PointComponent
