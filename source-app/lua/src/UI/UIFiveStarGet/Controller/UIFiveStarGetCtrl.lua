local UIFiveStarGetCtrl = BaseClass("UIFiveStarGetCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIFiveStarGet)
  EventManager:GetInstance():Broadcast(EventId.GF_five_star_finish)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UIFiveStarGetCtrl.CloseSelf = CloseSelf
UIFiveStarGetCtrl.Close = Close
return UIFiveStarGetCtrl
