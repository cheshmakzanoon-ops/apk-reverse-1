local UIDispathTreasureExchangeLogCtrl = BaseClass("UIDispathTreasureExchangeLogCtrl", UIBaseCtrl)

local function CloseSelf(self)
  local redPointStr = DataCenter.SplinterExchangeManager:GetLogRedPointStrByType(SplinterExchangeType.DispatchTreasure.Id)
  if not string.IsNullOrEmpty(redPointStr) then
    DataCenter.SplinterExchangeManager:SetShowExchangeRedPoint({
      [redPointStr] = 0
    })
  end
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDispathTreasureExchangeLog)
  DataCenter.ActDispatchTreasureManager:ClearRecordData()
end

UIDispathTreasureExchangeLogCtrl.CloseSelf = CloseSelf
return UIDispathTreasureExchangeLogCtrl
