local LWActivityArenaRecordsCtrl = BaseClass("LWActivityArenaRecordsCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWActivityArenaRecords)
end

LWActivityArenaRecordsCtrl.CloseSelf = CloseSelf
return LWActivityArenaRecordsCtrl
