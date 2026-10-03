local UISoldierDetailsView = BaseClass("UISoldierDetailsView", UIBaseView)
local TotalsoldierComponent = require("UI/UISoldierDetails/Component/TotalsoldierComponent")
local SoldierContent = require("UI/UISoldierDetails/Component/SoldierContent")
local UISoldierInfoTip = require("UI.UILWMilitaryCampPanel.Component.UISoldierInfoTip")
local base = UIBaseView

function UISoldierDetailsView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:ReInit()
end

function UISoldierDetailsView:OnDestroy()
  DataCenter.HeroEntrustManager:CheckShowReward()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UISoldierDetailsView:ComponentDefine()
  self.titleText = self:AddComponent(UIText, "panel/Common_bg_orange/text_title")
  self.closeBtn = self:AddComponent(UIButton, "panel/Common_bg_orange/closeBtn")
  self.totalsoldier = self:AddComponent(TotalsoldierComponent, "panel/Common_bg_orange/totalsoldiers")
  self.citySoldierContent = self:AddComponent(SoldierContent, "panel/Common_bg_orange/inCityContent")
  self.outsideSoldierContent = self:AddComponent(SoldierContent, "panel/Common_bg_orange/outsideContent")
  self.soldierInfoTip = self:AddComponent(UISoldierInfoTip, "soldierInfoTip")
  self.panelBtn = self:AddComponent(UIButton, "panel")
  self.closeBtn:SetOnClick(function()
    self:Close()
  end)
  self.panelBtn:SetOnClick(function()
    self:Close()
  end)
end

function UISoldierDetailsView:Close()
  self.ctrl:CloseSelf()
end

function UISoldierDetailsView:ComponentDestroy()
  self.titleText = nil
  self.closeBtn = nil
  self.totalsoldier = nil
  self.citySoldierContent = nil
  self.outsideSoldierContent = nil
  self.panelBtn = nil
end

function UISoldierDetailsView:ReInit()
  local param1 = self.ctrl:GetCitySoldiersInfo()
  local param2 = self.ctrl:GetOutsideSoldiersInfo()
  self.citySoldierContent:ReInit(param1, function(soldierData, pos)
    self:OnSoldierItemClick(soldierData, pos)
  end)
  self.titleText:SetLocalText(135114)
  self.outsideSoldierContent:ReInit(param2, function(soldierData, pos)
    self:OnSoldierItemClick(soldierData, pos)
  end)
  self.totalsoldier:ReInit(self:GetUserData())
end

function UISoldierDetailsView:OnSoldierItemClick(soldierData, pos)
  self.soldierInfoTip:SetActive(true)
  self.soldierInfoTip:Refresh(DataCenter.SoldierDataManager:GetTemplate(soldierData.id), pos, true)
end

return UISoldierDetailsView
