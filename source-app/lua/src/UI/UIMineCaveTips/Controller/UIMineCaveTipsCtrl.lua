local UIMineCaveTipsCtrl = BaseClass("UIMineCaveTipsCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIMineCaveTips, {anim = true})
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UIMineCaveTipsCtrl.CloseSelf = CloseSelf
UIMineCaveTipsCtrl.Close = Close
return UIMineCaveTipsCtrl
