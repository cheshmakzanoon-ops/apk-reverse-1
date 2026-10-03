local UILWArena3V3RecordsCtrl = BaseClass("LWMainUICtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UILWArena3V3Records)
end

UILWArena3V3RecordsCtrl.CloseSelf = CloseSelf
return UILWArena3V3RecordsCtrl
