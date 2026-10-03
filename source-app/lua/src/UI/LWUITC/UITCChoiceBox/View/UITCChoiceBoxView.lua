local UITCChoiceBoxView = BaseClass("UITCChoiceBoxView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local StarListItem = require("UI.LWUITCCardMain.Component.TCStarListItemComponent")
local CardAttrLinePrefabPath = "Assets/Main/Prefabs/UI/UILWTC/Component/CardAttrLine3.prefab"
local CardAttrLine = require("UI.LWUITC.UITCCardViewPanel.Component.CardViewAttrLineAsync")
local CardInfoPanelWindowParam = require("UI.LWUITC.UITCCardInfoPanel.Ctrl.CardInfoPanelUtil")
local CARD_TYPE_SCALE = {
  [TacticalCardType.Core] = 0.7,
  [TacticalCardType.Battle] = 1,
  [TacticalCardType.Economy] = 1
}

function UITCChoiceBoxView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitUI()
end

function UITCChoiceBoxView:OnDestroy()
  self:ClearCardList()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UITCChoiceBoxView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.title_txt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.close_btn = self.viewSkin:AddComponent(self, UIButton, 2)
  self.close_btn:SetOnClick(function()
    self:OnClose_btnClick()
  end)
  self.cards_container = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
  self.cardName_txt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.stars_container = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
  self.info_btn = self.viewSkin:AddComponent(self, UIButton, 6)
  self.info_btn:SetOnClick(function()
    self:OnInfo_btnClick()
  end)
  self.upgradeNeed_txt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.use_btn = self.viewSkin:AddComponent(self, UIButton, 8)
  self.use_btn:SetOnClick(function()
    self:OnUse_btnClick()
  end)
  self.panel_btn = self.viewSkin:AddComponent(self, UIButton, 9)
  self.panel_btn:SetOnClick(function()
    self:OnPanel_btnClick()
  end)
  self.starsComp = self.viewSkin:AddComponent(self, UIBaseComponent, 10)
  self.bottomContent = self.viewSkin:AddComponent(self, UIBaseComponent, 11)
  self.star_txt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.starUpgradeNeed = self.viewSkin:AddComponent(self, UIBaseComponent, 13)
  self.coreCardContent = self.viewSkin:AddComponent(self, UIBaseContainer, 14)
  self.normalCardContent = self.viewSkin:AddComponent(self, UIBaseContainer, 15)
  self.normalCardName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 16)
  self.normalCardDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 17)
  self.normalCardInfoBtn = self.viewSkin:AddComponent(self, UIButton, 18)
  self.normalCardInfoBtn:SetOnClick(function()
    self:OnNormalCardInfoBtnClick()
  end)
  self.normalCardAttrContent = self.viewSkin:AddComponent(self, UIBaseContainer, 19)
  self.stars = self:AddComponent(StarListItem, "ContentArea/BottomContent/contentContainer/TacticalCardSelectContent/starContent/starLayout/stars")
  self.bottomContent:SetActive(true)
  self.curBottomPanel = {
    [GOODS_TYPE.GOODS_TYPE_179] = self.coreCardContent,
    [GOODS_TYPE.GOODS_TYPE_185] = self.normalCardContent
  }
  self.coreCardContent:SetActive(false)
  self.normalCardContent:SetActive(false)
end

function UITCChoiceBoxView:ComponentDestroy()
  self.loadAttributeItemCounts = nil
  self.randomAttrComps = nil
  self:ClearCardList()
  self.stars = nil
end

function UITCChoiceBoxView:DataDefine()
  local itemUuid, count, template = self:GetUserData()
  self.itemUuid = itemUuid
  self.count = count
  self.template = template
  self.selectedCardId = 0
  self.selectedIndex = 0
  self.cardList = {}
  self.cardCellList = {}
  self.cardRequests = {}
  self.loadAttributeItemCounts = 0
end

function UITCChoiceBoxView:DataDestroy()
end

function UITCChoiceBoxView:OnAddListener()
  base.OnAddListener(self)
end

function UITCChoiceBoxView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UITCChoiceBoxView:OnClose_btnClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  self.ctrl:CloseSelf()
end

function UITCChoiceBoxView:OnInfo_btnClick()
  if self.selectedCardId == 0 then
    return
  end
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UITCCardViewPanel, {anim = true}, self.selectedCardId)
end

function UITCChoiceBoxView:OnUse_btnClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if self.selectedCardId == 0 then
    UIUtil.ShowTipsId("battle_card_exchange_ban_01")
    return
  end
  local cardTemplate = DataCenter.TacticalCardDataManager:GetTemplateData(self.selectedCardId)
  if not cardTemplate then
    return
  end
  UIUtil.ShowMessage(Localization:GetString("battle_card_box_choose_confirm", Localization:GetString(cardTemplate.name)), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
    self:ConfirmExchange()
  end)
end

function UITCChoiceBoxView:ConfirmExchange()
  if self.template and self.selectedIndex > 0 then
    self.ctrl:UseItemNew(self.template.id, 1, self.selectedIndex)
  end
end

function UITCChoiceBoxView:OnPanel_btnClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  self.ctrl:CloseSelf()
end

function UITCChoiceBoxView:InitUI()
  self.title_txt:SetLocalText(self.template.name)
  self:InitCardList()
  self:UpdateUseButton()
  self:UpdateCardInfo()
end

function UITCChoiceBoxView:InitCardList()
  self:ClearCardList()
  local cardInfos = {}
  if self.template.para1 then
    local cardPairs = string.split(self.template.para1, "|")
    for i = 1, #cardPairs do
      local cardPair = string.split(cardPairs[i], ",")
      if #cardPair == 2 then
        local cardId = tonumber(cardPair[1])
        local count = tonumber(cardPair[2])
        if cardId and count and 0 < count then
          local cardInfo = {cardId = cardId, count = count}
          table.insert(cardInfos, cardInfo)
          if not self.cardInfoMap then
            self.cardInfoMap = {}
          end
          self.cardInfoMap[cardInfo.cardId] = cardInfo
        end
      end
    end
  end
  if self.template.type == GOODS_TYPE.GOODS_TYPE_185 and self.template.para2 then
    local cardPairs = string.split(self.template.para2, "|")
    if #cardPairs ~= #cardInfos then
      Logger.LogError("\229\141\161\231\137\140\230\149\176\233\135\143\229\146\140\229\175\185\229\186\148\231\154\132\229\177\158\230\128\167\230\149\176\233\135\143\228\184\141\229\140\185\233\133\141\239\188\129  goods ID:" .. tostring(self.template))
      return
    end
    for i = 1, #cardPairs do
      local attrIdPairs = string.split(cardPairs[i], ",")
      local cardInfo = cardInfos[i]
      cardInfo.attributeList = {}
      for _, v in ipairs(attrIdPairs) do
        if not string.IsNullOrEmpty(v) then
          local attributeInfo = {}
          local attrId = tonumber(v)
          local detailTemplate = LocalController:instance():getLine("battle_card_random_attr_detail", attrId)
          if detailTemplate then
            local effectId = detailTemplate.effect_num
            local effectTemplate = DataCenter.TacticalCardDataManager:GetRandomAttributeShowTemplate(effectId)
            if effectTemplate then
              attributeInfo.id = effectId
              attributeInfo.effectName = effectTemplate.effect_name
              local min = detailTemplate.quality_range[1]
              local max = detailTemplate.quality_range[2]
              if min ~= max then
                Logger.LogError("\231\173\150\229\136\146\233\133\141\233\148\153\228\186\134 \229\141\154\232\175\173\232\175\180\232\191\153\231\167\141\230\131\133\229\134\181\228\184\138\228\184\139\233\153\144\231\154\132\229\128\188\229\186\148\232\175\165\228\184\128\230\160\183  \228\189\134\230\152\175\232\191\153\228\184\170\230\138\165\233\148\153\228\184\141\230\137\147\230\150\173\230\181\129\231\168\139")
              end
              attributeInfo.value = min
              attributeInfo.quality = effectTemplate:GetQuality(attributeInfo.value)
              table.insert(cardInfo.attributeList, attributeInfo)
            end
          end
        end
      end
      table.sort(cardInfo.attributeList, function(a, b)
        if a.quality ~= b.quality then
          return a.quality > b.quality
        end
        return a.id > b.id
      end)
    end
  end
  for i, cardInfo in ipairs(cardInfos) do
    self:CreateCardCell(cardInfo.cardId, i, cardInfo.count)
  end
end

function UITCChoiceBoxView:CreateCardCell(cardId, index, count)
  local cardTemplate = DataCenter.TacticalCardDataManager:GetTemplateData(cardId)
  if not cardTemplate then
    return
  end
  local cardType = cardTemplate.type
  local request = TacticalCardUtil.CreateOneCardItem(self, cardType, self.cards_container, function(cardItem)
    local displayConfig = {}
    displayConfig.isDeluxeShow = true
    displayConfig.isShowLv = false
    displayConfig.showBg = true
    if cardType ~= TacticalCardSlotType.Core then
      displayConfig.isShowSelectStatusChildIcon = false
      displayConfig.selectBorderResPath = "Assets/Main/TextureEx/UILWTCTex/FX_zhanshukapai_xuanzhong5.png"
    end
    cardItem:SetConfigData(cardId, count, 0, displayConfig)
    cardItem:SetClickFunc(function()
      self:OnCardSelected(cardId, index, cardItem)
    end)
    cardItem:SetSelectObjState(false)
    self.cardCellList[index] = cardItem
    local scale = CARD_TYPE_SCALE[cardType]
    cardItem:SetLocalScaleXYZ(scale, scale, scale)
  end)
  self.cardRequests[index] = request
  table.insert(self.cardList, {
    cardId = cardId,
    index = index,
    count = count
  })
end

function UITCChoiceBoxView:OnCardSelected(cardId, index, cardItem)
  self.selectedCardId = cardId
  self.selectedIndex = index
  for i, cell in pairs(self.cardCellList) do
    if cell and cell.SetSelectObjState then
      cell:SetSelectObjState(i == index)
    end
  end
  self:UpdateCardInfo()
  self:UpdateUseButton()
end

function UITCChoiceBoxView:UpdateCardInfo()
  if not self.template then
    return
  end
  if self.template.type == GOODS_TYPE.GOODS_TYPE_179 then
    self:UpdateCoreCardInfo()
  else
    self:UpdateNormalCardInfo()
  end
end

function UITCChoiceBoxView:UpdateCoreCardInfo()
  if self.selectedCardId == 0 then
    self.cardName_txt:SetText("")
    self.stars:ReInit(0, 0)
    self.upgradeNeed_txt:SetText("")
    return
  end
  local cardTemplate = DataCenter.TacticalCardDataManager:GetTemplateData(self.selectedCardId)
  if not cardTemplate then
    return
  end
  self.cardName_txt:SetLocalText(cardTemplate.name)
  local coreMainCard = DataCenter.TacticalCardDataManager:GetCoreMainByCardId(self.selectedCardId)
  if coreMainCard then
    self.stars:SetActive(true)
    self.starUpgradeNeed:SetActive(true)
    self.star_txt:SetLocalText("battle_card_star_now")
    local currentStar = coreMainCard:GetStar()
    local maxStar = coreMainCard:GetMaxStar()
    self.stars:ClearLightCount()
    self.stars:ReInit(currentStar, maxStar)
    if not coreMainCard:IsMaxStar() then
      local cardId, needCount = coreMainCard:GetStarUpgradeCost()
      if cardId and needCount then
        local feedCount = DataCenter.TacticalCardDataManager:GetCoreFeedNumByCardId(self.selectedCardId)
        self.upgradeNeed_txt:SetText(Localization:GetString("battle_card_upgrade_need", feedCount, needCount))
      end
    else
      self.upgradeNeed_txt:SetText(Localization:GetString("battle_card_upgrade_need_max"))
    end
  else
    self.stars:SetActive(false)
    self.starUpgradeNeed:SetActive(false)
    self.star_txt:SetLocalText("battle_card_star_now_none")
  end
end

function UITCChoiceBoxView:UpdateNormalCardInfo()
  if self.selectedCardId == 0 then
    return
  end
  local cardTemplate = DataCenter.TacticalCardDataManager:GetTemplateData(self.selectedCardId)
  if not cardTemplate then
    return
  end
  self.normalCardName:SetLocalText(cardTemplate.name)
  self.normalCardDesc:SetLocalText("battle_card_normal_choose")
  if self.cardInfoMap and self.cardInfoMap[self.selectedCardId] then
    self:UpdateNormalCardRandomAttribute(self.cardInfoMap[self.selectedCardId])
  end
end

function UITCChoiceBoxView:UpdateNormalCardRandomAttribute(cardInfo)
  local randomAttrsArr = cardInfo.attributeList
  local toChange = 0
  local curAttrCount = 0
  if self.randomAttrComps then
    curAttrCount = #self.randomAttrComps
  end
  toChange = #randomAttrsArr - curAttrCount
  if 0 < toChange then
    for i = 1, toChange do
      local attrComp = self.normalCardAttrContent:LoadComponentAsync(CardAttrLine, CardAttrLinePrefabPath, self.normalCardAttrContent, function()
        if self.loadAttributeItemCounts ~= nil then
          self.loadAttributeItemCounts = self.loadAttributeItemCounts + 1
        end
        if self.loadAttributeItemCounts == #randomAttrsArr then
          CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.normalCardContent.transform)
        end
      end)
      if not self.randomAttrComps then
        self.randomAttrComps = {}
      end
      table.insert(self.randomAttrComps, attrComp)
    end
  elseif toChange < 0 and self.randomAttrComps then
    for i, v in ipairs(self.randomAttrComps) do
      if v then
        v:SetActive(false)
      end
    end
  end
  for i = 1, #randomAttrsArr do
    self.randomAttrComps[i]:SetActive(true)
    self.randomAttrComps[i]:UpdateAttr(randomAttrsArr[i].id, randomAttrsArr[i].value, nil, randomAttrsArr[i].effectName, randomAttrsArr[i].quality)
  end
end

function UITCChoiceBoxView:OnNormalCardInfoBtnClick()
  if not self.selectedCardId or self.selectedCardId == 0 then
    return
  end
  local cardInfo = self.cardInfoMap[self.selectedCardId]
  local baseLv = 1
  for i, v in ipairs(cardInfo.attributeList) do
    if v.id == TacticalCardUtil.Effect_Card_Upgrade then
      baseLv = baseLv + 1
    end
  end
  local windowParam = CardInfoPanelWindowParam.New()
  windowParam.id = self.selectedCardId
  windowParam.level = baseLv
  windowParam.star = 0
  windowParam.randomAttr = cardInfo.attributeList
  UIManager:GetInstance():OpenWindow(UIWindowNames.UITCCardInfoPanel, {anim = true}, windowParam)
end

function UITCChoiceBoxView:UpdateUseButton()
  local canUse = self.selectedCardId > 0
  CS.UIGray.SetGray(self.use_btn.transform, not canUse, true)
  if self.template then
    self.curBottomPanel[self.template.type]:SetActive(canUse)
  end
end

function UITCChoiceBoxView:ClearCardList()
  for _, request in pairs(self.cardRequests) do
    if request and request.Destroy then
      request:Destroy()
    end
  end
  self.cards_container:RemoveAllComponentes()
  self.cardCellList = {}
  self.cardList = {}
  self.cardRequests = {}
end

return UITCChoiceBoxView
