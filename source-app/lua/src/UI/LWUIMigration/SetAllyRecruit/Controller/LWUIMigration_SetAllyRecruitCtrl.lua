local LWUIMigration_SetAllyRecruitCtrl = BaseClass("LWUIMigration_SetAllyRecruitCtrl", UIBaseCtrl)

function LWUIMigration_SetAllyRecruitCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIMigrationSetAllyRecruit)
end

return LWUIMigration_SetAllyRecruitCtrl
