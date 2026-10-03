local LWUITrailTowerMainCtrl = BaseClass("LWUITrailTowerMainCtrl", UIBaseCtrl)

function LWUITrailTowerMainCtrl:CloseSelf(useAnimation)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWTrailTowerMain, {anim = useAnimation})
end

function LWUITrailTowerMainCtrl:Close()
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

function LWUITrailTowerMainCtrl:SetPage(trailTowerTabType)
  self.trailTowerTabType = trailTowerTabType
end

function LWUITrailTowerMainCtrl:GetPage()
  return self.trailTowerTabType
end

return LWUITrailTowerMainCtrl
