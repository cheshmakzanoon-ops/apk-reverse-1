local UIJigsawAreaCtrl = BaseClass("UIJigsawAreaCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIJigsawArea)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UIJigsawAreaCtrl.CloseSelf = CloseSelf
UIJigsawAreaCtrl.Close = Close
return UIJigsawAreaCtrl
