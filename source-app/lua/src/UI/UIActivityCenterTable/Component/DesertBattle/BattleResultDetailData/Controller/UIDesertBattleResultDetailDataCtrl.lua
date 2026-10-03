local UIDesertBattleResultDetailDataCtrl = BaseClass("UIDesertBattleResultDetailDataCtrl", UIBaseCtrl)

function UIDesertBattleResultDetailDataCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDesertBattleResultDetailData)
end

return UIDesertBattleResultDetailDataCtrl
