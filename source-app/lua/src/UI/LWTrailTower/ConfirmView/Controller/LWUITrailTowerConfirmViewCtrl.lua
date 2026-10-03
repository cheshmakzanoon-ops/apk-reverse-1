local LWUITrailTowerConfirmViewCtrl = BaseClass("LWUITrailTowerConfirmViewCtrl", UIBaseCtrl)

function LWUITrailTowerConfirmViewCtrl:CloseSelf(useAnimation)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWTrailTowerConfirmView, {anim = useAnimation})
end

function LWUITrailTowerConfirmViewCtrl:Close()
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

return LWUITrailTowerConfirmViewCtrl
