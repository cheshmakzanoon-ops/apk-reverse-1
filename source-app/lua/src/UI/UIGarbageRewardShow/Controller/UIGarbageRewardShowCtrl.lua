local UIGarbageRewardShowCtrl = BaseClass("UIGarbageRewardShowCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIGarbageRewardShow, {anim = true})
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UIGarbageRewardShowCtrl.CloseSelf = CloseSelf
UIGarbageRewardShowCtrl.Close = Close
return UIGarbageRewardShowCtrl
