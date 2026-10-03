local UITCCardViewPanelCtrl = BaseClass("UITCCardViewPanelCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITCCardViewPanel)
end

local function GetCardData(self, cId, initState)
  local cardData
  local cardTemplate = DataCenter.TacticalCardDataManager:GetTemplateData(cId)
  if not cardTemplate then
    return
  end
  if cardTemplate.type == TacticalCardType.Core then
    if initState then
      local fakeCardData = TacticalCardUtil.CreateFakeCardData(cId, 1, 0, {})
      cardData = fakeCardData
    else
      local mainCardData = DataCenter.TacticalCardDataManager:GetCoreMainByCardId(cId)
      if mainCardData then
        cardData = mainCardData
      else
        local maxStar = cardTemplate.max_star
        local maxLevel = cardTemplate.max_lv
        local fakeCardData = TacticalCardUtil.CreateFakeCardData(cId, maxLevel, maxStar, {})
        cardData = fakeCardData
      end
    end
  else
    local fakeCardData = TacticalCardUtil.CreateFakeCardData(cId, 1, 0, {})
    cardData = fakeCardData
  end
  return cardData
end

UITCCardViewPanelCtrl.CloseSelf = CloseSelf
UITCCardViewPanelCtrl.GetCardData = GetCardData
return UITCCardViewPanelCtrl
