local UILWGetGiftViewCtrl = BaseClass("UILWGetGiftViewCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UILWGetGiftView)
end

UILWGetGiftViewCtrl.CloseSelf = CloseSelf
return UILWGetGiftViewCtrl
