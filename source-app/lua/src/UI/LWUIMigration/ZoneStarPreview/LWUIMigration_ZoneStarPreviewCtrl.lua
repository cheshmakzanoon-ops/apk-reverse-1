local LWUIMigration_ZoneStarPreviewCtrl = BaseClass("LWUIMigration_ZoneStarPreviewCtrl", UIBaseCtrl)

function LWUIMigration_ZoneStarPreviewCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIMigrationZoneStarPreview)
end

return LWUIMigration_ZoneStarPreviewCtrl
