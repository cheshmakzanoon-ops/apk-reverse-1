local base = UIAsyncContainer
local CylinderItemComponent = BaseClass("CylinderItemComponent", UIAsyncContainer)
local Localization = CS.GameEntry.Localization

function CylinderItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function CylinderItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function CylinderItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgCylinder = self.viewSkin:AddComponent(self, UIImage, 1)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
end

function CylinderItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.imgCylinder = nil
  self.textTitle = nil
  self.textNum = nil
end

function CylinderItemComponent:DataDefine()
end

function CylinderItemComponent:DataDestroy()
  self.time = nil
  self.lengthX = nil
  self.count = nil
end

function CylinderItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function CylinderItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function CylinderItemComponent:SetData(time, length, count)
  self.time = time
  self.lengthX = length
  self.count = count
end

function CylinderItemComponent:UpdateData()
  self.textTitle:SetText(self.time)
  self.textNum:SetText(self.count)
  self.imgCylinder:SetSizeDeltaX(self.lengthX)
end

return CylinderItemComponent
