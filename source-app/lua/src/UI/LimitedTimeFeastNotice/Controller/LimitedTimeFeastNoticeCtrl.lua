local LimitedTimeFeastNoticeCtrl = BaseClass("LimitedTimeFeastNoticeCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LimitedTimeFeastNotice)
end

LimitedTimeFeastNoticeCtrl.CloseSelf = CloseSelf
return LimitedTimeFeastNoticeCtrl
