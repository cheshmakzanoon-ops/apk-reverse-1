local UITreasureChestCtrl = BaseClass("UITreasureChestCtrl", UIBaseCtrl)

function UITreasureChestCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITreasureChest)
end

return UITreasureChestCtrl
