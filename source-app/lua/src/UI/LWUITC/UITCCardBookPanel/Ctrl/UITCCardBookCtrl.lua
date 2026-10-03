local UITCCardBookCtrl = BaseClass("UITCCardBookCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITCCardBook)
end

function UITCCardBookCtrl:GetCardDataListByCardType(cardType)
  return TacticalCardUtil.GetSeasonCards(cardType)
end

function UITCCardBookCtrl:ResetShowData()
  self.showDataList = {}
end

function UITCCardBookCtrl:GetShowData(cardType)
  if self.showDataList and self.showDataList[cardType] then
    return self.showDataList[cardType]
  end
  local curShowCardDataList = self:GetCardDataListByCardType(cardType)
  local tmp1 = {}
  local tmp2 = {}
  local tmp3 = {}
  for _, cardId in ipairs(curShowCardDataList) do
    local cardTemplate = DataCenter.TacticalCardDataManager:GetTemplateData(cardId)
    tmp1[cardId] = cardTemplate.color
    if cardType == TacticalCardType.Core then
      local mainCardData = DataCenter.TacticalCardDataManager:GetCoreMainByCardId(cardId)
      if mainCardData then
        tmp3[cardId] = mainCardData.star
      end
    end
    tmp2[cardId] = DataCenter.TacticalCardDataManager:IsCardActivated(cardType, cardId)
  end
  table.sort(curShowCardDataList, function(a, b)
    local a_quality = tmp1[a] or 0
    local b_quality = tmp1[b] or 0
    if a_quality ~= b_quality then
      return a_quality > b_quality
    end
    local a_isOwned = false
    local b_isOwned = false
    if tmp2[a] then
      a_isOwned = true
    end
    if tmp2[b] then
      b_isOwned = true
    end
    if a_isOwned ~= b_isOwned then
      return a_isOwned
    end
    local a_star = tmp3[a] or 0
    local b_star = tmp3[b] or 0
    if a_star ~= b_star then
      return a_star > b_star
    end
    return a < b
  end)
  if not self.showDataList then
    self.showDataList = {}
  end
  self.showDataList[cardType] = curShowCardDataList
  return curShowCardDataList
end

UITCCardBookCtrl.CloseSelf = CloseSelf
return UITCCardBookCtrl
