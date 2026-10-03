local UITreasureHuntNewHistoryCtrl = BaseClass("UITreasureHuntNewHistoryCtrl", UIBaseCtrl)

function UITreasureHuntNewHistoryCtrl:CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UITreasureHuntNewHistory, {anim = true})
end

return UITreasureHuntNewHistoryCtrl
