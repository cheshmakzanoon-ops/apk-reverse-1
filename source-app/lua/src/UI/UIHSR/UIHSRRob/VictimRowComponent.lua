local base = UIBaseContainer
local VictimRowComponent = BaseClass("VictimRowComponent", UIBaseContainer)
local HSRRobVictimComponent = require("UI.UIHSR.UIHSRRob.HSRRobVictimComponent")
local Localization = CS.GameEntry.Localization

function VictimRowComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function VictimRowComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function VictimRowComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compHSRRobVictim1 = self.viewSkin:AddComponent(self, HSRRobVictimComponent, 1)
  self.compHSRRobVictim2 = self.viewSkin:AddComponent(self, HSRRobVictimComponent, 2)
  self.compHSRRobVictim3 = self.viewSkin:AddComponent(self, HSRRobVictimComponent, 3)
end

function VictimRowComponent:ComponentDestroy()
  self.viewSkin = nil
  self.compHSRRobVictim1 = nil
  self.compHSRRobVictim2 = nil
  self.compHSRRobVictim3 = nil
end

function VictimRowComponent:DataDefine()
end

function VictimRowComponent:DataDestroy()
end

function VictimRowComponent:OnAddListener()
  base.OnAddListener(self)
end

function VictimRowComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function VictimRowComponent:SetData(data)
  self.compHSRRobVictim1:SetData(data)
  self.compHSRRobVictim2:SetData(data)
  self.compHSRRobVictim3:SetData(data)
end

return VictimRowComponent
