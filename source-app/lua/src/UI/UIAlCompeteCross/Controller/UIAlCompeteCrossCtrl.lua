local UIAlCompeteCrossCtrl = BaseClass("UIAlCompeteCrossCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAlCompeteCross)
  EventManager:GetInstance():Broadcast(EventId.ShowCrossEffect)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UIAlCompeteCrossCtrl.CloseSelf = CloseSelf
UIAlCompeteCrossCtrl.Close = Close
return UIAlCompeteCrossCtrl
