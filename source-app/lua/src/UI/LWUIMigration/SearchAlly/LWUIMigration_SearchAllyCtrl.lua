local LWUIMigration_SearchAllyCtrl = BaseClass("LWUIMigration_SearchAllyCtrl", UIBaseCtrl)

function LWUIMigration_SearchAllyCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIMigrationSearchAlly)
end

return LWUIMigration_SearchAllyCtrl
