local UILWAlMailCtrl = BaseClass("UILWAlMailCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWAlMail_v2)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UILWAlMailCtrl.CloseSelf = CloseSelf
UILWAlMailCtrl.Close = Close
return UILWAlMailCtrl
