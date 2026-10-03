local UITCCardDetailPanelCtrl = BaseClass("UITCCardDetailPanelCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITCCardDetailPanel)
end

function UITCCardDetailPanelCtrl:CardLevelUpgrade(cardUuid)
  local cardData = DataCenter.TacticalCardDataManager:GetCardData(cardUuid)
  if not cardData then
    return false
  end
  if cardData:IsMaxLv() then
    return false
  end
  local itemId, itemCnt = cardData:GetLvUpgradeCost()
  if not itemId then
    return false
  end
  if itemCnt > DataCenter.ResourceItemDataManager:GetCountByItemId(itemId) then
    LWResourceLackUtil:GotoResourceItemLack(itemId, itemCnt)
    return false
  end
  SFSNetwork.SendMessage(MsgDefines.TacticalCardLevelUpgrade, cardUuid)
  return true
end

function UITCCardDetailPanelCtrl:GetCardShowDailyLimitBoxId(cardData)
  if not cardData then
    return nil
  end
  local card_reward = cardData.template.card_reward
  if #card_reward == 0 then
    return nil
  else
    local card_box_map = DataCenter.TacticalCardDataManager:GetAllBoxIdCurSeason()
    for i = 1, #card_reward do
      local card_reward_id = card_reward[i]
      if card_box_map[card_reward_id] then
        return card_reward_id
      end
    end
  end
  return nil
end

function UITCCardDetailPanelCtrl:SendDecomposeMessage(cardUuid)
  SFSNetwork.SendMessage(MsgDefines.BattleCardDecompose, {cardUuid})
end

UITCCardDetailPanelCtrl.CloseSelf = CloseSelf
return UITCCardDetailPanelCtrl
