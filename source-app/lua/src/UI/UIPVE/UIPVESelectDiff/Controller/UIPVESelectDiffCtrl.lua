local UIPVESelectDiffCtrl = BaseClass("UIPVESelectDiffCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPVESelectDiff)
end

UIPVESelectDiffCtrl.CloseSelf = CloseSelf
return UIPVESelectDiffCtrl
