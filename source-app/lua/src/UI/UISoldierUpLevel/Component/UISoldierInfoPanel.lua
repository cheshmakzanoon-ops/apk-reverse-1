local UISoldierInfoTip = require("UI.UILWMilitaryCampPanel.Component.UISoldierInfoTip")
local UISoldierInfoPanel = BaseClass("UISoldierInfoPanel", UIBaseContainer)
local base = UIBaseContainer
local UISoldierItem = require("UI/UIBuildDispatching/Component/UISoldierItem")
local Localization = CS.GameEntry.Localization

function UISoldierInfoPanel:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UISoldierInfoPanel:ComponentDefine()
  self.soldierTip = self:AddComponent(UISoldierInfoTip, "tipPanle")
  self.soldierItem = self:AddComponent(UISoldierItem, "UISoldierItem")
end

function UISoldierInfoPanel:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UISoldierInfoPanel:ComponentDestroy()
  self.soldierTip = nil
  self.soldierItem = nil
end

function UISoldierInfoPanel:ReInit(soldierData)
  self.soldierTip:Refresh(DataCenter.SoldierDataManager:GetTemplate(soldierData.id))
  local elevenData = T11Util.GetSelfCurSoldierData()
  self.soldierItem:SetData(soldierData, elevenData)
  local count = soldierData and soldierData.count or 0
  self.soldierItem:SetCountText(Localization:GetString(130128, string.GetFormattedStr(count)))
end

return UISoldierInfoPanel
