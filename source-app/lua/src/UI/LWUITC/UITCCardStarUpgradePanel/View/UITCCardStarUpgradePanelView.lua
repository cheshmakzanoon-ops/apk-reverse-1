local UITCCardStarUpgradePanelView = BaseClass("UITCCardStarUpgradePanelView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local CardAttrLine = require("UI.LWUITC.UITCCardDetailPanel.Component.CardAttrLineAsync")
local CardAttrLinePrefabPath = "Assets/Main/Prefabs/UI/UILWTC/Component/CardAttrLine.prefab"
local CoreCardSkillItem = require("UI.LWUITC.UITCCardDetailPanel.Component.CoreCardSkillItem")
local CoreCardSkillItemPrefabPath = "Assets/Main/Prefabs/UI/UILWTC/Component/CoreCardSkillItem.prefab"
local StarListItem = require("UI.LWUITCCardMain.Component.TCStarListItemComponent")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  local cardUuid = self:GetUserData()
  local cardData = DataCenter.TacticalCardDataManager:GetCardData(cardUuid)
  self.cardData = cardData
  if not cardData then
    self.ctrl:CloseSelf()
  end
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  self:UpdateView(self.cardData)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.mask_btn = self:AddComponent(UIButton, "panel")
  self.mask_btn:SetOnClick(function()
    self:OnMask_btnClick()
  end)
  self.close_btn = self:AddComponent(UIButton, "PopUpTitle/CloseBtn")
  self.close_btn:SetOnClick(function()
    self:OnClose_btnClick()
  end)
  self.power_txt = self:AddComponent(UITextMeshProUGUIEx, "PopUpTitle/content/shared/PowerInfo/PowerNumberText")
  self.cardIcon_container = self:AddComponent(UIBaseContainer, "PopUpTitle/content/shared/card")
  self.cardName_txt = self:AddComponent(UITextMeshProUGUIEx, "PopUpTitle/content/shared/cardName_txt")
  self.cardType_txt = self:AddComponent(UITextMeshProUGUIEx, "PopUpTitle/content/shared/cardType_txt")
  self.attrs = self:AddComponent(UIBaseContainer, "PopUpTitle/content/core_card/areas/viewport/content/basic_attrs")
  self.skills = self:AddComponent(UIBaseContainer, "PopUpTitle/content/core_card/areas/viewport/content/skill_area")
  self.upgradeBtn = self:AddComponent(UIButton, "PopUpTitle/content/btns/starUpgrade_btn")
  self.upgradeBtn:SetOnClick(function()
    self:OnUpgradeBtnClick()
  end)
  self.costItem_icon = self:AddComponent(UIImage, "PopUpTitle/content/btns/starUpgrade_btn/cost/item_icon")
  self.costCnt_txt = self:AddComponent(UITextMeshProUGUIEx, "PopUpTitle/content/btns/starUpgrade_btn/cost/costCnt_txt")
  self.stars = self:AddComponent(StarListItem, "PopUpTitle/content/core_card/areas/viewport/content/star_area/star/stars")
end

local function ComponentDestroy(self)
  self.mask_btn = nil
  self.close_btn = nil
  self.power_txt = nil
  self.cardIcon_container = nil
  self.cardName_txt = nil
  self.cardType_txt = nil
  self.stars = nil
  self.attrs = nil
  self.skills = nil
  self.upgradeBtn = nil
  self.costItem_icon = nil
  self.costCnt_txt = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshResourceItem, self.UpdateUpgradeCost)
  self:AddUIListener(EventId.TacticalCardStarUpgrade, self.OnTacticalCardStarUpgrade)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshResourceItem, self.UpdateUpgradeCost)
  self:RemoveUIListener(EventId.TacticalCardStarUpgrade, self.OnTacticalCardStarUpgrade)
  base.OnRemoveListener(self)
end

local function OnMask_btnClick(self)
  self.ctrl:CloseSelf()
end

local function OnClose_btnClick(self)
  self.ctrl:CloseSelf()
end

function UITCCardStarUpgradePanelView:UpdateView(cardData)
  self:UpdateBaseInfo(cardData)
  self:UpdateStar(cardData)
  self:UpdateSkill(cardData)
  self:UpdateAttr(cardData)
  self:UpdateBtn(cardData)
end

local DISPLAY_CONFIG = {
  isDeluxeShow = true,
  isShowLv = false,
  isShowPower = false
}

function UITCCardStarUpgradePanelView:UpdateBaseInfo(cardData)
  self.cardName_txt:SetLocalText(cardData.template.name)
  self.cardType_txt:SetText(TacticalCardUtil.GetCardTypeNameStr(cardData.template.type))
  self.power_txt:SetText(cardData:GetPower())
  if self.cardItem then
    self.cardItem:SetData(cardData, DISPLAY_CONFIG)
  elseif not self.cardRequest then
    self.cardRequest = TacticalCardUtil.CreateOneCardItem(self, cardData.template.type, self.cardIcon_container, function(cardItem)
      cardItem:SetData(cardData, DISPLAY_CONFIG)
      cardItem:SetActive(true)
      self.cardItem = cardItem
    end)
  end
end

function UITCCardStarUpgradePanelView:UpdateStar(cardData)
  self.stars:ReInit(cardData:GetStar(), cardData:GetMaxStar())
end

function UITCCardStarUpgradePanelView:UpdateSkill(cardData)
  local skillList = self.cardData:GetNextStarSkillList()
  if self.cardData:IsUseNewSkillDesc() and skillList and 1 < #skillList then
    skillList = {
      skillList[1]
    }
  end
  local curSkillCount = 0
  if self.skillComps then
    curSkillCount = #self.skillComps
  end
  local toChange = #skillList - curSkillCount
  if 0 < toChange then
    for i = 1, toChange do
      local skillComp = self.skills:LoadComponentAsync(CoreCardSkillItem, CoreCardSkillItemPrefabPath, self.skills)
      if not self.skillComps then
        self.skillComps = {}
      end
      table.insert(self.skillComps, skillComp)
    end
  elseif toChange < 0 and self.skillComps then
    for i, v in ipairs(self.skillComps) do
      if v then
        v:SetActive(false)
      end
    end
  end
  for i = 1, #skillList do
    self.skillComps[i]:SetActive(true)
    self.skillComps[i]:UpdateSkill(skillList[i].id, skillList[i].nextId, true, cardData)
  end
end

function UITCCardStarUpgradePanelView:UpdateAttr(cardData)
  local isMaxStar = cardData:IsMaxStar()
  if not isMaxStar then
    local starCardId = TacticalCardUtil.GetCardStarRealId(cardData.cardId, cardData:GetStar() + 1)
    local starTemplate = DataCenter.TacticalCardDataManager:GetStarTemplateData(starCardId)
    if not starTemplate or table.IsNullOrEmpty(starTemplate.attr) then
      self.attrs:SetActive(false)
      return
    end
  end
  self.attrs:SetActive(true)
  local baseAttrs = cardData:GetNextStarBaseAttrs()
  local toChange = 0
  local curAttrCount = 0
  if self.attrComps then
    curAttrCount = #self.attrComps
  end
  toChange = #baseAttrs - curAttrCount
  if 0 < toChange then
    for i = 1, toChange do
      local attrComp = self.attrs:LoadComponentAsync(CardAttrLine, CardAttrLinePrefabPath, self.attrs)
      if not self.attrComps then
        self.attrComps = {}
      end
      table.insert(self.attrComps, attrComp)
    end
  elseif toChange < 0 and self.attrComps then
    for i, v in ipairs(self.attrComps) do
      if v then
        v:SetActive(false)
      end
    end
  end
  for i = 1, #baseAttrs do
    self.attrComps[i]:SetActive(true)
    self.attrComps[i]:UpdateAttr(baseAttrs[i].id, baseAttrs[i].value, baseAttrs[i].nextValue)
  end
end

function UITCCardStarUpgradePanelView:UpdateBtn(cardData)
  local isMaxStar = cardData:IsMaxStar()
  self.upgradeBtn:SetActive(not isMaxStar)
  if not isMaxStar then
    self:UpdateUpgradeCost()
  end
end

function UITCCardStarUpgradePanelView:UpdateUpgradeCost()
  if not self.upgradeBtn:GetActive() then
    return
  end
  local cardId, itemCnt = self.cardData:GetStarUpgradeCost()
  if not cardId then
    self.costCnt_txt:SetText("")
    return
  end
  if not self.iconCardId or self.iconCardId ~= cardId then
    self.iconCardId = cardId
    local cardTemplate = DataCenter.TacticalCardDataManager:GetTemplateData(cardId)
    if not cardTemplate then
      return
    end
    self.costItem_icon:LoadSprite(cardTemplate.icon)
  end
  local curHaveCnt = DataCenter.TacticalCardDataManager:GetCoreFeedNumByCardId(cardId)
  local colorStr = itemCnt <= curHaveCnt and "<color=#FFFFFF>" or "<color=#FF0000>"
  self.costCnt_txt:SetText(string.format("%s%s</color>/%s", colorStr, string.GetFormattedStr(curHaveCnt), string.GetFormattedStr(itemCnt)))
end

function UITCCardStarUpgradePanelView:OnTacticalCardStarUpgrade(cardUuid)
  if self.cardData.uuid ~= cardUuid then
    return
  end
  self:CheckIntactStarUpgrade()
  self:StopWaitForMsg()
  self:UpdateView(self.cardData)
end

function UITCCardStarUpgradePanelView:OnUpgradeBtnClick()
  if not self.view.ctrl then
    return
  end
  if not self.cardData then
    return
  end
  if self._waitForMsg then
    return
  end
  if self.view.ctrl:OnCardStarUpgrade(self.cardData.uuid) then
    self:StartWaitForMsg()
  end
end

function UITCCardStarUpgradePanelView:StartWaitForMsg()
  self._waitForMsg = true
  if self.waitForMsgTimer then
    self.waitForMsgTimer:Stop()
    self.waitForMsgTimer = nil
  end
  self.waitForMsgTimer = TimerManager:GetInstance():DelayInvoke(function()
    self._waitForMsg = false
  end, 2)
end

function UITCCardStarUpgradePanelView:StopWaitForMsg()
  self._waitForMsg = false
  if self.waitForMsgTimer then
    self.waitForMsgTimer:Stop()
    self.waitForMsgTimer = nil
  end
end

function UITCCardStarUpgradePanelView:CheckIntactStarUpgrade()
end

UITCCardStarUpgradePanelView.OnCreate = OnCreate
UITCCardStarUpgradePanelView.OnDestroy = OnDestroy
UITCCardStarUpgradePanelView.OnEnable = OnEnable
UITCCardStarUpgradePanelView.OnDisable = OnDisable
UITCCardStarUpgradePanelView.ComponentDefine = ComponentDefine
UITCCardStarUpgradePanelView.ComponentDestroy = ComponentDestroy
UITCCardStarUpgradePanelView.DataDefine = DataDefine
UITCCardStarUpgradePanelView.DataDestroy = DataDestroy
UITCCardStarUpgradePanelView.OnAddListener = OnAddListener
UITCCardStarUpgradePanelView.OnRemoveListener = OnRemoveListener
UITCCardStarUpgradePanelView.OnMask_btnClick = OnMask_btnClick
UITCCardStarUpgradePanelView.OnClose_btnClick = OnClose_btnClick
return UITCCardStarUpgradePanelView
