local NewPeakArenaRecordCtrl = BaseClass("LWMainUICtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.NewPeakArenaRecord)
end

NewPeakArenaRecordCtrl.CloseSelf = CloseSelf
return NewPeakArenaRecordCtrl
