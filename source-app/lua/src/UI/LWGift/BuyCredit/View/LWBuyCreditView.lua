local LWBuyCreditView = BaseClass("LWBuyCreditView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local CreditShopPage = require("UI.LWGift.BuyCredit.Component.CreditShop.CreditShopPage")

function LWBuyCreditView:DataDefine()
end

function LWBuyCreditView:DataDestroy()
end

function LWBuyCreditView:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self.creditShop:RefreshView()
end

function LWBuyCreditView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWBuyCreditView:OnAddListener()
  base.OnAddListener(self)
end

function LWBuyCreditView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWBuyCreditView:ComponentDefine()
  self.title = self:AddComponent(UIText, "Root/TopBar/TextTitle")
  self.closeBtn = self:AddComponent(UIButton, "Root/BottomBar/BtnBack")
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.creditShop = self:AddComponent(CreditShopPage, "Root/CreditShopPage")
end

function LWBuyCreditView:ComponentDestroy()
  self.title = nil
  self.closeBtn = nil
end

return LWBuyCreditView
