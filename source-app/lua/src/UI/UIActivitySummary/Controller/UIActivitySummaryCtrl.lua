local UIActivitySummaryCtrl = BaseClass("UIActivitySummaryCtrl", UIBaseCtrl)

local function CloseSelf(self)
  DataCenter.ThemeActivityManager:SetAllSubActivityOld(EnumActivity.ActivitySummary.Type)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIActivitySummary, {anim = true})
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Background, false)
end

UIActivitySummaryCtrl.CloseSelf = CloseSelf
UIActivitySummaryCtrl.Close = Close
return UIActivitySummaryCtrl
