local UITCCardStarUpgradePanelCtrl = BaseClass("UITCCardStarUpgradePanelCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITCCardStarUpgradePanel)
end

local function OnCardStarUpgrade(self, cardUuid)
  local cardData = DataCenter.TacticalCardDataManager:GetCardData(cardUuid)
  if not cardData then
    return false
  end
  if cardData:IsMaxStar() then
    return false
  end
  local cardId, itemCnt = cardData:GetStarUpgradeCost()
  if not cardId or not itemCnt then
    return false
  end
  local cards = DataCenter.TacticalCardDataManager:GetAllCanBeMaterialCards(cardData.uuid, cardId, itemCnt)
  if itemCnt > #cards then
    LWResourceLackUtil:GotoTacticalCardLack(cardId, itemCnt)
    return false
  end
  SFSNetwork.SendMessage(MsgDefines.TacticalCardStarUpgrade, cardUuid, cards)
  return true
end

UITCCardStarUpgradePanelCtrl.CloseSelf = CloseSelf
UITCCardStarUpgradePanelCtrl.OnCardStarUpgrade = OnCardStarUpgrade
return UITCCardStarUpgradePanelCtrl
