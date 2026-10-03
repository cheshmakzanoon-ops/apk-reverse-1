local UIRefundCtrl = BaseClass("UIRefundCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UICommonMessageBar, {anim = true, playEffect = false})
end

local function OnCustomKeyCodeEscape(self)
  local creditValue = DataCenter.CreditManager:GetCreditValue()
  if 0 < creditValue then
    self:CloseSelf()
  end
end

UIRefundCtrl.CloseSelf = CloseSelf
UIRefundCtrl.OnCustomKeyCodeEscape = OnCustomKeyCodeEscape
return UIRefundCtrl
