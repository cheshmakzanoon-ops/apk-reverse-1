local UITCCardEquipCardPanelCtrl = BaseClass("UITCCardEquipCardPanelCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.TCCardEquip)
end

function UITCCardEquipCardPanelCtrl:GetShowCardDataList(slotType, curSlotEquipCardData)
  local cardDataList = TacticalCardUtil.GetAllIdleCardDataList(slotType)
  local curEquipCardDataList = DataCenter.TacticalCardDataManager:GetAllEquipCardDataByCardType(slotType)
  local allSameCardIdDic = {}
  local allSameCardGroupDic = {}
  for _, v in ipairs(curEquipCardDataList) do
    local cardData = v
    if not curSlotEquipCardData or cardData.uuid ~= curSlotEquipCardData.uuid then
      local cardId = cardData:GetCardId()
      local isExistCardTypeGroup, cardTypeGroup = cardData:GetCardTypeGroup()
      if isExistCardTypeGroup then
        allSameCardGroupDic[cardTypeGroup] = true
      end
      allSameCardIdDic[cardId] = true
      table.insert(cardDataList, v)
    end
  end
  
  local function IsExistSameCard(cardData)
    local cardId = cardData:GetCardId()
    if allSameCardIdDic[cardId] then
      return true
    end
    local isExistCardTypeGroup, cardTypeGroup = cardData:GetCardTypeGroup()
    if isExistCardTypeGroup and allSameCardGroupDic[cardTypeGroup] then
      return true
    end
    return false
  end
  
  table.sort(cardDataList, function(a, b)
    local aEquipState = a:IsEquip()
    local bEquipState = b:IsEquip()
    if aEquipState ~= bEquipState then
      return not aEquipState
    end
    local aIsExistSameCard = IsExistSameCard(a)
    local bIsExistSameCard = IsExistSameCard(b)
    if aIsExistSameCard ~= bIsExistSameCard then
      return not aIsExistSameCard
    end
    local curCoreDeck = TacticalCardUtil.GetEquipCoreDeck()
    local aDeck = a:GetDeck()
    local bDeck = b:GetDeck()
    if curCoreDeck ~= aDeck and curCoreDeck ~= bDeck then
      if aDeck ~= bDeck then
        if aDeck == 0 then
          return true
        elseif bDeck == 0 then
          return false
        end
      end
    elseif curCoreDeck == aDeck and curCoreDeck ~= bDeck then
      return true
    elseif curCoreDeck ~= aDeck and curCoreDeck == bDeck then
      return false
    end
    local aQuality = a:GetCardQuality()
    local bQuality = b:GetCardQuality()
    if aQuality ~= bQuality then
      return aQuality > bQuality
    end
    local aPower = a:GetPower()
    local bPower = b:GetPower()
    if aPower ~= bPower then
      return aPower > bPower
    end
    return a:GetCardId() < b:GetCardId()
  end)
  return cardDataList
end

function UITCCardEquipCardPanelCtrl:GetPrefabAndScriptName(cardData)
  local cardType = cardData.cardTmpData.type
  local prefabName = TacticalCardPrefabNameConfig[cardType]
  local cls = TacticalCardClsPathConfig[cardType]
  return prefabName, cls
end

function UITCCardEquipCardPanelCtrl:SendEquipCardMessage(params)
  SFSNetwork.SendMessage(MsgDefines.BattleCardPutOn, params, false)
end

function UITCCardEquipCardPanelCtrl:SendPutOffCardMessage(params)
  SFSNetwork.SendMessage(MsgDefines.BattleCardPutOff, params)
end

UITCCardEquipCardPanelCtrl.CloseSelf = CloseSelf
return UITCCardEquipCardPanelCtrl
