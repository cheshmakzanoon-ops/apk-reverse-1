local base = UIBaseContainer
local UIBFDsbDuelActFinalTopThree = BaseClass("UIBFDsbDuelActFinalTopThree", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UIBFDsbDuelActFinalTopItem = require("UI.BFDsbDuel.BFDsbDuelFinal.Component.UIBFDsbDuelActFinalTopItem")

function UIBFDsbDuelActFinalTopThree:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIBFDsbDuelActFinalTopThree:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBFDsbDuelActFinalTopThree:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compFirst = self.viewSkin:AddComponent(self, UIBFDsbDuelActFinalTopItem, 1)
  self.compSecond = self.viewSkin:AddComponent(self, UIBFDsbDuelActFinalTopItem, 2)
  self.compThird = self.viewSkin:AddComponent(self, UIBFDsbDuelActFinalTopItem, 3)
end

function UIBFDsbDuelActFinalTopThree:ComponentDestroy()
  self.viewSkin = nil
  self.compFirst = nil
  self.compSecond = nil
  self.compThird = nil
end

function UIBFDsbDuelActFinalTopThree:DataDefine()
end

function UIBFDsbDuelActFinalTopThree:DataDestroy()
end

function UIBFDsbDuelActFinalTopThree:OnAddListener()
  base.OnAddListener(self)
end

function UIBFDsbDuelActFinalTopThree:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIBFDsbDuelActFinalTopThree:SetData(data)
  self:SetActive(0 < #data)
  self.compFirst:SetData(data[1])
  self.compSecond:SetData(data[2])
  self.compThird:SetData(data[3])
end

return UIBFDsbDuelActFinalTopThree
