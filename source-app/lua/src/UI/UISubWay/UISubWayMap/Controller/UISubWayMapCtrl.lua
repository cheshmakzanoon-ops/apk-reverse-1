local UISubWayMapCtrl = BaseClass("UISubWayMapCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

function UISubWayMapCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISubWayMap)
end

function UISubWayMapCtrl:Close()
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

return UISubWayMapCtrl
