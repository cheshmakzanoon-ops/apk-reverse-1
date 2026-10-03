local LWUITrailTowerStageCtrl = BaseClass("LWUITrailTowerStageCtrl", UIBaseCtrl)

function LWUITrailTowerStageCtrl:CloseSelf(useAnimation)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWTrailTowerStage, {anim = useAnimation})
end

function LWUITrailTowerStageCtrl:Close()
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

return LWUITrailTowerStageCtrl
