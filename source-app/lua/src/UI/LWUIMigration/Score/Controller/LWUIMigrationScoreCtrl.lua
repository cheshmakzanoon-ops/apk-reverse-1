local LWUIMigrationScoreCtrl = BaseClass("LWUIMigrationScoreCtrl", UIBaseCtrl)

function LWUIMigrationScoreCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIMigrationScore)
end

return LWUIMigrationScoreCtrl
