local NewPeakArenaOtherCtrl = BaseClass("NewPeakArenaOtherCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.NewPeakArenaOther, {anim = false})
end

NewPeakArenaOtherCtrl.CloseSelf = CloseSelf
return NewPeakArenaOtherCtrl
