local TCCardBagCtrl = BaseClass("TCCardBagCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.TCCardBag)
end

function TCCardBagCtrl:GetCardDataListByCardType(cardType)
  local ret = {}
  if cardType == TacticalCardType.Core then
    ret = TacticalCardUtil.GetAllCoreMainCardList()
  else
    local allCardDic = DataCenter.TacticalCardDataManager.allCardDataDic
    for _, v in pairs(allCardDic) do
      if v.cardType == cardType then
        table.insert(ret, v)
      end
    end
  end
  table.sort(ret, function(a, b)
    local qualityA = a:GetCardQuality()
    local qualityB = b:GetCardQuality()
    if qualityA ~= qualityB then
      return qualityA > qualityB
    end
    local deckA = a:GetDeck()
    local deckB = b:GetDeck()
    if deckA ~= deckB then
      return deckA < deckB
    end
    if a.cardId ~= b.cardId then
      return a.cardId < b.cardId
    end
    local powerA = a:GetPower()
    local powerB = b:GetPower()
    if powerA ~= powerB then
      return powerA > powerB
    end
    return a.uuid > b.uuid
  end)
  return ret
end

TCCardBagCtrl.CloseSelf = CloseSelf
return TCCardBagCtrl
