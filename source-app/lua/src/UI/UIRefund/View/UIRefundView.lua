local UIRefundView = BaseClass("UIRefundView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local detailInfoBtn_path = "Bg1/DetailInfoBtn"
local text1_path = "Bg1/Text1"
local customServiceBtn_path = "CustomServiceBtn"
local rechargeBtn_path = "RechargeBtn"

local function OnCreate(self)
  base.OnCreate(self)
  self.detailInfoBtn = self:AddComponent(UIButton, detailInfoBtn_path)
  self.detailInfoBtn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIRefundTip, {anim = true})
  end)
  self.text1 = self:AddComponent(UIText, text1_path)
  self.customServiceBtn = self:AddComponent(UIButton, customServiceBtn_path)
  self.customServiceBtn:SetOnClick(function()
    CS.AIHelp.AIHelpProxy.Show("E003", Localization:GetString("2700006"))
    PostEventLog.Track(PostEventLog.Defines.RefundClickCustomerService)
  end)
  self.rechargeBtn = self:AddComponent(UIButton, rechargeBtn_path)
  self.rechargeBtn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuyCredit, {anim = false}, nil, nil, RechargeEntryType.CreditShop)
    PostEventLog.Track(PostEventLog.Defines.RefundClickRecharge)
  end)
  self:RefreshView()
  PostEventLog.Track(PostEventLog.Defines.OpenRefundWindow, {
    curCredit = DataCenter.CreditManager:GetCreditValue()
  })
end

local function OnDestroy(self)
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function RefreshView(self)
  self.text1:SetLocalText("credit_popup_content_01", DataCenter.CreditManager:GetCreditValue())
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateCreditValue, self.RefreshView)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.UpdateCreditValue, self.RefreshView)
end

UIRefundView.OnCreate = OnCreate
UIRefundView.OnDestroy = OnDestroy
UIRefundView.OnEnable = OnEnable
UIRefundView.OnDisable = OnDisable
UIRefundView.RefreshView = RefreshView
UIRefundView.OnAddListener = OnAddListener
UIRefundView.OnRemoveListener = OnRemoveListener
return UIRefundView
