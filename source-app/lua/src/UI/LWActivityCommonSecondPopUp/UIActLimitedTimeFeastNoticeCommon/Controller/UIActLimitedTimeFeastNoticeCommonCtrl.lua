local UIActLimitedTimeFeastNoticeCommonCtrl = BaseClass("UIActLimitedTimeFeastNoticeCommonCtrl", UIBaseCtrl)

function UIActLimitedTimeFeastNoticeCommonCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActLimitedTimeFeastNoticeCommon)
end

return UIActLimitedTimeFeastNoticeCommonCtrl
