local UIMineCaveLogCtrl = BaseClass("UIMineCaveLogCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIMineCaveLog, {anim = true})
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UIMineCaveLogCtrl.CloseSelf = CloseSelf
UIMineCaveLogCtrl.Close = Close
return UIMineCaveLogCtrl
