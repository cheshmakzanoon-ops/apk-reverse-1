local UIPlaceRoadCtrl = BaseClass("UIPlaceRoadCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPlaceRoad, {
    anim = true,
    UIMainAnim = UIMainAnimType.ChangeAllShow
  })
  GoToUtil.GotoPos(CS.SceneManager.World.CurTarget, CS.SceneManager.World.InitZoom, LookAtFocusTime)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UIPlaceRoadCtrl.CloseSelf = CloseSelf
UIPlaceRoadCtrl.Close = Close
return UIPlaceRoadCtrl
