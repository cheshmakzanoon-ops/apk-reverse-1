local LWNewbieEventPopCtrl = BaseClass("LWNewbieEventPopCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWNewbieEventPopView)
end

LWNewbieEventPopCtrl.CloseSelf = CloseSelf
return LWNewbieEventPopCtrl
