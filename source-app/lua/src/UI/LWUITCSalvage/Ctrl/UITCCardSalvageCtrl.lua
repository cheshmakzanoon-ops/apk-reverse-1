local UITCCardSalvageCtrl = BaseClass("UITCCardSalvageCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.TCCardSalvage)
end

function UITCCardSalvageCtrl:GetAllCanSalvageCardDataList(qualityFilter)
  local ret = TacticalCardUtil.GetAllIdleCardDataList(TacticalCardType.Battle, qualityFilter)
  local allIdleEconomyCard = TacticalCardUtil.GetAllIdleCardDataList(TacticalCardType.Economy, qualityFilter)
  for _, v in ipairs(allIdleEconomyCard) do
    table.insert(ret, v)
  end
  local temp1 = {}
  local temp2 = {}
  
  local function GetQuality(cardData)
    if not temp1[cardData.cardId] then
      temp1[cardData.cardId] = cardData:GetCardQuality()
    end
    return temp1[cardData.cardId]
  end
  
  local function GetPower(cardData)
    if not temp2[cardData.cardId] then
      temp2[cardData.cardId] = cardData:GetPower()
    end
    return temp2[cardData.cardId]
  end
  
  table.sort(ret, function(a, b)
    local qa = GetQuality(a)
    local qb = GetQuality(b)
    if qa ~= qb then
      return qa < qb
    end
    local pa = GetPower(a)
    local pb = GetPower(b)
    if pa ~= pb then
      return pa < pb
    end
    local ida = a.cardId
    local idb = b.cardId
    if ida ~= idb then
      return ida < idb
    end
    local uuida = tonumber(a.uuid)
    local uuidb = tonumber(b.uuid)
    return uuida < uuidb
  end)
  return ret
end

function UITCCardSalvageCtrl:GetPrefabAndScriptName(cardData)
  local cardType = cardData.cardTmpData.type
  local prefabName = TacticalCardPrefabNameConfig[cardType]
  local cls = TacticalCardClsPathConfig[cardType]
  return prefabName, cls
end

function UITCCardSalvageCtrl:SendSalvageMessage(uuids)
  SFSNetwork.SendMessage(MsgDefines.BattleCardDecompose, uuids)
end

function UITCCardSalvageCtrl:GetSalvageMatInfo(uuidsDic)
  if not uuidsDic then
    return nil
  end
  local ret = {}
  for uuid, v in pairs(uuidsDic) do
    local cardData = DataCenter.TacticalCardDataManager.allCardDataDic[uuid]
    local cardType = cardData:GetCardType()
    local quality = cardData:GetCardQuality()
    local cardLv = cardData:GetLevel()
    local lvGroup = cardData:GetLvGroup()
    local lvUpgradeValue = cardData:GetRandomEffectValue(TacticalCardUtil.Effect_Card_Upgrade)
    if lvUpgradeValue then
      cardLv = cardLv - math.floor(lvUpgradeValue + 0.5)
    end
    local itemId, count = TacticalCardUtil.GetCardSalvageMat(cardType, quality, cardLv, lvGroup)
    if itemId and count then
      if not ret[itemId] then
        ret[itemId] = 0
      end
      ret[itemId] = ret[itemId] + count
    end
  end
  return ret
end

local QUICK_SELECT_QUALITY_FILTER = 3

function UITCCardSalvageCtrl:GetCanQuickSelectCardDataList(cardDataList, selectCardUuidDict)
  local ret = {}
  for _, v in ipairs(cardDataList) do
    if v:GetCardQuality() <= QUICK_SELECT_QUALITY_FILTER and not selectCardUuidDict[v.uuid] then
      table.insert(ret, v)
    end
  end
  return ret
end

UITCCardSalvageCtrl.CloseSelf = CloseSelf
return UITCCardSalvageCtrl
