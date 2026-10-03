local ActivityDecorationGachaRulesCtrl = BaseClass("ActivityDecorationGachaRulesCtrl", UIBaseCtrl)

function ActivityDecorationGachaRulesCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActivityDecorationGachaRules)
end

function ActivityDecorationGachaRulesCtrl:GetAllDecorationItemDataInQualityOrder()
  local allItemData = DataCenter.ActivityDecorationGachaManager:GetAllItemDataInOrder()
  local res = {}
  if not table.IsNullOrEmpty(allItemData) then
    for i, v in pairs(allItemData) do
      if v:GetItemType() == DataCenter.ActivityDecorationGachaManager.ItemType.Decoration then
        table.insert(res, v)
      end
    end
  end
  table.sort(res, function(a, b)
    local decorationQualityA = a:GetDecorationQuality()
    local decorationQualityB = b:GetDecorationQuality()
    return decorationQualityA > decorationQualityB
  end)
  return res
end

function ActivityDecorationGachaRulesCtrl:GetAllDecorationItemDataInQualityOrder()
  local allItemData = DataCenter.ActivityDecorationGachaManager:GetAllItemDataInOrder()
  local res = {}
  if not table.IsNullOrEmpty(allItemData) then
    for i, v in pairs(allItemData) do
      if v:GetItemType() == DataCenter.ActivityDecorationGachaManager.ItemType.Goods then
        table.insert(res, v)
      end
    end
  end
  table.sort(res, function(a, b)
    local qualityA = a:GetGoodsQuality()
    local qualityB = b:GetGoodsQuality()
    return qualityA > qualityB
  end)
  return res
end

return ActivityDecorationGachaRulesCtrl
