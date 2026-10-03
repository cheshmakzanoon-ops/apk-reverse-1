local UIMineCaveUnlockCtrl = BaseClass("UIMineCaveUnlockCtrl", UIBaseCtrl)

local function CloseSelf(self)
  if self.curScene ~= nil and self.curScene == CurScene.PVEScene then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIMineCaveUnlock)
  else
    UIManager.Instance:DestroyWindow(UIWindowNames.UIMineCaveUnlock)
  end
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UIMineCaveUnlockCtrl.CloseSelf = CloseSelf
UIMineCaveUnlockCtrl.Close = Close
return UIMineCaveUnlockCtrl
