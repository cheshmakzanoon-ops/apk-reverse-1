local UIActEasterLimitedTimeFeastNoticeCtrl = BaseClass("UIActEasterLimitedTimeFeastNoticeCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActEasterLimitedTimeFeastNotice)
end

UIActEasterLimitedTimeFeastNoticeCtrl.CloseSelf = CloseSelf
return UIActEasterLimitedTimeFeastNoticeCtrl
