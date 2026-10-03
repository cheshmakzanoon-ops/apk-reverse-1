local ThanksLetterCtrl = BaseClass("ThanksLetterCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.ThanksLetter)
end

ThanksLetterCtrl.CloseSelf = CloseSelf
return ThanksLetterCtrl
