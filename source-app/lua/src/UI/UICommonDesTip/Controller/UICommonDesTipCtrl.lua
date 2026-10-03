local UICommonDesTipCtr = BaseClass("UICommonDesTipCtr", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UICommonDesTip)
end

UICommonDesTipCtr.CloseSelf = CloseSelf
return UICommonDesTipCtr
