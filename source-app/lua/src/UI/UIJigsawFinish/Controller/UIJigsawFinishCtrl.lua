local UIJigsawFinish = BaseClass("UIJigsawFinish", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIJigsawFinish)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UIJigsawFinish.CloseSelf = CloseSelf
UIJigsawFinish.Close = Close
return UIJigsawFinish
