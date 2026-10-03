local UIActivitySummaryPreviewCtrl = BaseClass("UIActivitySummaryPreviewCtrl", UIBaseCtrl)

local function CloseSelf(self)
  EventManager:GetInstance():Broadcast(EventId.UpdateThemeActNoticeRewardInfo)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIActivitySummaryPreview, {anim = true})
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Background, false)
end

UIActivitySummaryPreviewCtrl.CloseSelf = CloseSelf
UIActivitySummaryPreviewCtrl.Close = Close
return UIActivitySummaryPreviewCtrl
