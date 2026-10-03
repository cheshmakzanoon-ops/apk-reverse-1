local UITCChoiceBoxRewardGetView = BaseClass("UITCChoiceBoxRewardGetView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local ITEM_SPACING = {
  [TacticalCardType.Core] = {40, 30},
  [TacticalCardType.Battle] = {0, 0},
  [TacticalCardType.Economy] = {0, 0}
}

function UITCChoiceBoxRewardGetView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UITCChoiceBoxRewardGetView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UITCChoiceBoxRewardGetView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textClickTp = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnSkipAnim = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnSkipAnim:SetOnClick(function()
    self:OnBtnSkipAnimClick()
  end)
  self.rewardNode = self.viewSkin:AddComponent(self, UIGridLayoutGroup, 4)
  self.textTitle:SetLocalText("battle_card_choose_get")
end

function UITCChoiceBoxRewardGetView:ComponentDestroy()
  self.viewSkin = nil
  self.textTitle = nil
  self.textClickTp = nil
  self.btnSkipAnim = nil
  self.rewardNode = nil
end

function UITCChoiceBoxRewardGetView:DataDefine()
  self.itemIndex = 0
  self.cardRequests = {}
end

function UITCChoiceBoxRewardGetView:DataDestroy()
  self.itemIndex = nil
  self.rewardNode:RemoveAllComponentes()
  if self.cardRequests then
    for i, v in ipairs(self.cardRequests) do
      if v then
        v:Destroy()
      end
    end
    self.cardRequests = nil
  end
end

function UITCChoiceBoxRewardGetView:OnAddListener()
  base.OnAddListener(self)
end

function UITCChoiceBoxRewardGetView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UITCChoiceBoxRewardGetView:ReInit()
  self.userBattleCards = self:GetUserData()
  if self.userBattleCards then
    for i, v in ipairs(self.userBattleCards) do
      if v and v.uuid then
        local cardData = DataCenter.TacticalCardDataManager:GetCardData(v.uuid)
        if cardData then
          local req = self:CreateCardCell(cardData)
          table.insert(self.cardRequests, req)
        end
      end
    end
  end
end

function UITCChoiceBoxRewardGetView:CreateCardCell(cardData)
  self:SetLayoutStyle(cardData)
  local cardType = cardData:GetCardType()
  local request = TacticalCardUtil.CreateOneCardItem(self, cardType, self.rewardNode, function(cardItem)
    local displayConfig = {}
    displayConfig.isDeluxeShow = true
    displayConfig.isShowLv = false
    displayConfig.showBg = false
    displayConfig.isShowStar = false
    displayConfig.isShowDeck = true
    cardItem:SetConfigData(cardData.cardId, 0, 0, displayConfig)
    cardItem:SetClickFunc(function()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UITCCardViewPanel, {anim = true}, cardData.cardId, true)
    end)
    cardItem:SetSelectObjState(false)
  end)
  return request
end

function UITCChoiceBoxRewardGetView:SetLayoutStyle(cardData)
  if self.initLayoutStyle then
    return
  end
  local cardType = cardData:GetCardType()
  local spacing = ITEM_SPACING[cardType]
  self.rewardNode:SetCellSpacing(spacing[1], spacing[2])
  self.initLayoutStyle = true
end

function UITCChoiceBoxRewardGetView:OnBtnSkipAnimClick()
  self.ctrl:CloseSelf()
end

return UITCChoiceBoxRewardGetView
