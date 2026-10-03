local UITruckRewardInsuranceTipsView = BaseClass("UITruckRewardInsuranceTipsView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWBtnBuyRefundRemind = require("UI.LWBtnBuyRefundRemind.LWBtnBuyRefundRemind")

function UITruckRewardInsuranceTipsView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
end

function UITruckRewardInsuranceTipsView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UITruckRewardInsuranceTipsView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitleTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.btnMonthCardDetail = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnMonthCardDetail:SetOnClick(function()
    self:OnBtnMonthCardDetailClick()
  end)
  self.textBtnMonthCardDetailDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.compBuyButton = self.viewSkin:AddComponent(self, LWBtnBuyRefundRemind, 5)
  self.textExtendMonthCardTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textDesContent = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnPanel:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
end

function UITruckRewardInsuranceTipsView:ComponentDestroy()
  self.viewSkin = nil
  self.textTitleTxt = nil
  self.btnClose = nil
  self.btnMonthCardDetail = nil
  self.textBtnMonthCardDetailDesc = nil
  self.compBuyButton = nil
  self.textExtendMonthCardTips = nil
  self.textDesContent = nil
  self.btnPanel = nil
end

function UITruckRewardInsuranceTipsView:DataDefine()
  self.golloesMonthCard = DataCenter.MonthCardNewManager:GetGolloesMonthCard()
  self.btnMonthCardDetail:SetSafeClickMode(true)
  self.compBuyButton:SetSafeClickMode(true)
end

function UITruckRewardInsuranceTipsView:DataDestroy()
end

function UITruckRewardInsuranceTipsView:OnAddListener()
  base.OnAddListener(self)
end

function UITruckRewardInsuranceTipsView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UITruckRewardInsuranceTipsView:RefreshView()
  self.textTitleTxt:SetLocalText("")
  self.textDesContent:SetLocalText("month_card_desc_05")
  self.textBtnMonthCardDetailDesc:SetLocalText("month_card_title_06")
  self.compBuyButton:Init(self.golloesMonthCard.packageData)
  self.compBuyButton:SetBuyClickCallBack(function()
    self.ctrl:CloseSelf()
  end)
  self.compBuyButton:RefreshPoint()
  self.textExtendMonthCardTips:SetActive(self.golloesMonthCard:IsBought())
  self.textExtendMonthCardTips:SetLocalText("monthcard_extend")
end

function UITruckRewardInsuranceTipsView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UITruckRewardInsuranceTipsView:OnBtnMonthCardDetailClick()
  self.ctrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITruckRewardInsurance)
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWBuyDiamond, {anim = true}, WelfareTagType.MonthCard)
end

return UITruckRewardInsuranceTipsView
