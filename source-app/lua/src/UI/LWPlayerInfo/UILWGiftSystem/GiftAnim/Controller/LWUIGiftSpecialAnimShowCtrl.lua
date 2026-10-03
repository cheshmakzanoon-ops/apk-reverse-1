local LWUIGiftSpecialAnimShowCtrl = BaseClass("LWUIGiftSpecialAnimShowCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIGiftSpecialAnimShow)
end

local function OnCustomKeyCodeEscape(self)
  local window = UIManager:GetInstance():GetWindow(UIWindowNames.LWUIGiftSpecialAnimShow)
  if window and window.View then
    window.View:ExecuteCallBack()
  end
  self:CloseSelf()
end

LWUIGiftSpecialAnimShowCtrl.CloseSelf = CloseSelf
LWUIGiftSpecialAnimShowCtrl.OnCustomKeyCodeEscape = OnCustomKeyCodeEscape
return LWUIGiftSpecialAnimShowCtrl
