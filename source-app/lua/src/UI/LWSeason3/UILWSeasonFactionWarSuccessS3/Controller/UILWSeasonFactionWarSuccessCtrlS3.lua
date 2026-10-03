local UILWSeasonFactionWarSuccessCtrlS3 = BaseClass("UILWSeasonFactionWarSuccessCtrlS3", UIBaseCtrl)

function UILWSeasonFactionWarSuccessCtrlS3:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonFactionWarSuccessS3)
end

return UILWSeasonFactionWarSuccessCtrlS3
