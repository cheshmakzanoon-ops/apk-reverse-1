local UILWInfoPopCtrl = BaseClass("UILWInfoPopCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWInfoPop)
end

UILWInfoPopCtrl.CloseSelf = CloseSelf
return UILWInfoPopCtrl
