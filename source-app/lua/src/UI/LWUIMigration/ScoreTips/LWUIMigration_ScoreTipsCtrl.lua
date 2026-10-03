local LWUIMigration_ScoreTipsCtrl = BaseClass("LWUIMigration_ScoreTipsCtrl", UIBaseCtrl)

function LWUIMigration_ScoreTipsCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIMigrationScoreTips)
end

return LWUIMigration_ScoreTipsCtrl
