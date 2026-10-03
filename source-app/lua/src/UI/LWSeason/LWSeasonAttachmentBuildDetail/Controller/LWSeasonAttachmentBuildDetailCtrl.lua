local LWSeasonAttachmentBuildDetailCtrl = BaseClass("LWSeasonAttachmentBuildDetailCtrl", UIBaseCtrl)

function LWSeasonAttachmentBuildDetailCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonAttachmentBuildDetail)
end

return LWSeasonAttachmentBuildDetailCtrl
