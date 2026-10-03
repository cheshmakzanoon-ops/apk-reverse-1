local UITCCardResetPanelCtrl = BaseClass("UITCCardResetPanelCtrl", UIBaseCtrl)

function UITCCardResetPanelCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITCCardResetPanel)
end

function UITCCardResetPanelCtrl:GetAllCanResetCoreCardList()
  local ret = {}
  local cards = TacticalCardUtil.GetAllIdleCardDataList(TacticalCardType.Core)
  for _, cardData in ipairs(cards) do
    if cardData:GetLevel() > 1 then
      table.insert(ret, cardData)
    end
  end
  table.sort(ret, function(a, b)
    local levelA = a:GetLevel()
    local levelB = b:GetLevel()
    if levelA ~= levelB then
      return levelA > levelB
    end
    return a.cardId < b.cardId
  end)
  return ret
end

function UITCCardResetPanelCtrl:GetResetCostInfo()
  local itemId = LuaEntry.DataConfig:TryGetNum("battle_card_param", "k12", 0)
  if not itemId then
    return nil
  end
  return {itemId = itemId, count = 1}
end

function UITCCardResetPanelCtrl:ShowCostItemShortageDialog(itemId)
  LWResourceLackUtil:GotoGoodsItemLack(itemId, 1)
end

function UITCCardResetPanelCtrl:SendResetMessage(cardUuid)
  if not cardUuid then
    return
  end
  local costInfo = self:GetResetCostInfo()
  local ownCount = DataCenter.ItemData:GetItemCount(costInfo.itemId)
  if ownCount < costInfo.count then
    self:ShowCostItemShortageDialog(costInfo.itemId)
    return
  end
  SFSNetwork.SendMessage(MsgDefines.BattleCardReset, cardUuid)
  self:CloseSelf()
end

function UITCCardResetPanelCtrl:GetResetReturnMaterials(cardData)
  if not cardData then
    return {}
  end
  local totalMaterials = {}
  local currentLevel = cardData:GetLevel()
  local cardType = cardData:GetCardType()
  local cardQuality = cardData:GetCardQuality()
  local lvGroup = cardData:GetLvGroup()
  for lv = 2, currentLevel do
    local itemId, itemCnt = TacticalCardUtil.GetCardUpgradeCost(cardType, cardQuality, lv - 1, lvGroup)
    if itemId and itemCnt then
      if not totalMaterials[itemId] then
        totalMaterials[itemId] = 0
      end
      totalMaterials[itemId] = totalMaterials[itemId] + itemCnt
    end
  end
  return totalMaterials
end

function UITCCardResetPanelCtrl:GetPrefabAndScriptName(cardData)
  local cardType = cardData.cardTmpData.type
  local prefabName = TacticalCardPrefabNameConfig[cardType]
  local cls = TacticalCardClsPathConfig[cardType]
  return prefabName, cls
end

return UITCCardResetPanelCtrl
