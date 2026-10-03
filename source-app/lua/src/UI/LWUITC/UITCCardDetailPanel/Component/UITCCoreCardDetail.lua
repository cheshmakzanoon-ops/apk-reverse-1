local UITCCoreCardDetail = BaseClass("UITCCoreCardDetail", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local TCStarItemComponent = require("UI.LWUITCCardMain.Component.TCStarItemComponent")
local CardAttrLine = require("UI.LWUITC.UITCCardDetailPanel.Component.CardAttrLineAsync")
local CardAttrLinePrefabPath = "Assets/Main/Prefabs/UI/UILWTC/Component/CardAttrLine.prefab"
local CoreCardSkillItem = require("UI.LWUITC.UITCCardDetailPanel.Component.CoreCardSkillItem")
local CoreCardSkillItemPrefabPath = "Assets/Main/Prefabs/UI/UILWTC/Component/CoreCardSkillItem.prefab"
local CostItemAsync = require("UI.LWUITC.UITCCardDetailPanel.Component.CostItemAsync")
local CostItemAsyncPrefabPath = "Assets/Main/Prefabs/UI/UILWTC/Component/CostItem.prefab"
local StarListItem = require("UI.LWUITCCardMain.Component.TCStarListItemComponent")
local UIGray = CS.UIGray

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:StopWaitForMsg()
  if self.cardData then
    self:UpdateView(self.cardData)
  end
end

local function OnDisable(self)
  base.OnDisable(self)
  self:StopWaitForMsg()
end

local function ComponentDefine(self)
  self.close_btn = self:AddComponent(UIButton, "CloseBtn")
  self.close_btn:SetOnClick(function()
    self:OnClose_btnClick()
  end)
  self.cardIcon_container = self:AddComponent(UIBaseContainer, "content/shared/card")
  self.cardName_txt = self:AddComponent(UITextMeshProUGUIEx, "content/shared/cardName_txt")
  self.cardType_txt = self:AddComponent(UITextMeshProUGUIEx, "content/shared/cardType_txt")
  self.starUpgrade_btn = self:AddComponent(UIButton, "content/core_card/areas/viewport/content/star_area/star/starUpgrade_btn")
  self.starUpgrade_btn:SetOnClick(function()
    self:OnStarUpgrade_btnClick()
  end)
  self.attrs = self:AddComponent(UIBaseContainer, "content/core_card/areas/viewport/content/basic_attrs")
  self.replace_btn = self:AddComponent(UIButton, "content/btns/replace_btn")
  self.replace_btn:SetOnClick(function()
    self:OnReplace_btnClick()
  end)
  self.lvUpgrade_btn = self:AddComponent(UIButton, "content/btns/lvUpgrade_btn")
  self.lvUpgrade_btn:SetOnClick(function()
    self:OnLvUpgrade_btnClick()
  end)
  self.upgradeCost = self:AddComponent(UIBaseContainer, "content/btns/lvUpgrade_btn/cost")
  self.upgradeItem_icon = self:AddComponent(UIImage, "content/btns/lvUpgrade_btn/cost/item_icon")
  self.upgradeCost_txt = self:AddComponent(UITextMeshProUGUIEx, "content/btns/lvUpgrade_btn/cost/costCnt_txt")
  self.skills = self:AddComponent(UIBaseContainer, "content/core_card/areas/viewport/content/skill_area")
  self.power_txt = self:AddComponent(UITextMeshProUGUIEx, "content/shared/PowerInfo/PowerNumberText")
  self.compStarUpgradeRedDot = self:AddComponent(UIBaseContainer, "content/core_card/areas/viewport/content/star_area/star/starUpgrade_btn/starUpgradeRedDot")
  self.starUpgradeCost_container = self:AddComponent(UIBaseContainer, "content/core_card/areas/viewport/content/star_area/star/starUpgradeCost")
  self.share_btn = self:AddComponent(UIButton, "share_btn")
  self.share_btn:SetOnClick(function()
    self:OnShare_btnClick()
  end)
  self.use_btn = self:AddComponent(UIButton, "content/btns/use_btn")
  self.use_btn:SetOnClick(function()
    self:OnUse_btnClick()
  end)
  self.use_btn_txt = self:AddComponent(UITextMeshProUGUIEx, "content/btns/use_btn/btn_txt_layout/use_btn_txt")
  self.cardLv_txt = self:AddComponent(UITextMeshProUGUIEx, "content/shared/cardLv_txt")
  self.stars = self:AddComponent(StarListItem, "content/core_card/areas/viewport/content/star_area/star/stars")
  self.use_num_txt = self:AddComponent(UITextMeshProUGUIEx, "content/btns/use_btn/btn_txt_layout/use_num_txt")
  self.use_btn:SetSafeClickMode(true)
  self.btn_layout = self:AddComponent(UIHorizontalOrVerticalLayoutGroup, "content/btns")
end

local function ComponentDestroy(self)
  self:RemoveCardItem()
  self.close_btn = nil
  self.cardIcon_container = nil
  self.cardName_txt = nil
  self.cardType_txt = nil
  self.starUpgrade_btn = nil
  self.attrs = nil
  self.replace_btn = nil
  self.lvUpgrade_btn = nil
  self.upgradeCost = nil
  self.upgradeItem_icon = nil
  self.upgradeCost_txt = nil
  self.skills = nil
  self.power_txt = nil
  self.compStarUpgradeRedDot = nil
  self.starUpgradeCost_container = nil
  self.share_btn = nil
  self.use_btn = nil
  self.use_btn_txt = nil
  self.cardLv_txt = nil
  self.stars = nil
end

local function DataDefine(self)
  self._waitForMsg = false
end

local function DataDestroy(self)
  self._waitForMsg = false
  self.cardData = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshResourceItem, self.UpdateLvUpgradeCost)
  self:AddUIListener(EventId.TacticalCardLvUpgrade, self.OnTacticalCardLvUpgrade)
  self:AddUIListener(EventId.TacticalCardStarUpgrade, self.OnTacticalCardStarUpgrade)
  self:AddUIListener(EventId.TacticalCardOpenBox, self.OnTacticalCardOpenBox)
  self:AddUIListener(EventId.TacticalCardDataChanged, self.OnTacticalCardDataChanged)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshResourceItem, self.UpdateLvUpgradeCost)
  self:RemoveUIListener(EventId.TacticalCardLvUpgrade, self.OnTacticalCardLvUpgrade)
  self:RemoveUIListener(EventId.TacticalCardStarUpgrade, self.OnTacticalCardStarUpgrade)
  self:RemoveUIListener(EventId.TacticalCardOpenBox, self.OnTacticalCardOpenBox)
  self:RemoveUIListener(EventId.TacticalCardDataChanged, self.OnTacticalCardDataChanged)
  base.OnRemoveListener(self)
end

function UITCCoreCardDetail:RemoveCardItem()
  if self.cardRequest then
    self.cardIcon_container:RemoveAllComponentes()
    self.cardRequest:Destroy()
    self.cardRequest = nil
  end
end

function UITCCoreCardDetail:SetVisitModeState(isVisitMode)
  self.isVisitMode = isVisitMode
end

function UITCCoreCardDetail:UpdateView(cardData)
  self.cardData = cardData
  self:UpdateBaseInfo(cardData)
  self:UpdateStar(cardData)
  self:UpdateSkill(cardData)
  self:UpdateAttr(cardData)
  self:UpdateBtn(cardData)
  self:UpdateStarUpgradeRedDot()
end

local DISPLAY_CONFIG = {
  isDeluxeShow = true,
  isShowLv = false,
  isShowStar = false
}

function UITCCoreCardDetail:UpdateBaseInfo(cardData)
  self.cardName_txt:SetLocalText(cardData.template.name)
  self.cardType_txt:SetText(TacticalCardUtil.GetCardTypeNameStr(cardData.template.type))
  self.power_txt:SetText(cardData:GetPower())
  self.cardLv_txt:SetText(TacticalCardUtil.GetLevelStr(cardData))
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

function UITCCoreCardDetail:UpdateStar(cardData)
  self.stars:ReInit(cardData:GetStar(), cardData:GetMaxStar())
end

function UITCCoreCardDetail:UpdateSkill(cardData)
  local skillList = self.cardData:GetSkillList()
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
    self.skillComps[i]:UpdateSkill(skillList[i], nil, true, cardData)
  end
end

function UITCCoreCardDetail:UpdateAttr(cardData)
  local baseAttrs = cardData:GetNextLvBaseAttrs()
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

function UITCCoreCardDetail:UpdateBtn(cardData)
  local showBtnCnt = 0
  local isMaxStar = cardData:IsMaxStar()
  self.starUpgrade_btn:SetActive(not isMaxStar)
  if not isMaxStar then
    if not self.starUpgradeCost then
      self.starUpgradeCost = self.starUpgradeCost_container:LoadComponentAsync(CostItemAsync, CostItemAsyncPrefabPath, self.starUpgradeCost_container)
    end
    self.starUpgradeCost:SetActive(true)
    local cardId, itemCnt = cardData:GetStarUpgradeCost()
    self.starUpgradeCost:SetData(cardId, itemCnt, true)
  elseif self.starUpgradeCost then
    self.starUpgradeCost:SetActive(false)
  end
  local isMaxLv = cardData:IsMaxLv()
  self.lvUpgrade_btn:SetActive(not isMaxLv)
  if not isMaxLv then
    showBtnCnt = showBtnCnt + 1
    self:UpdateLvUpgradeCost()
  end
  local isEquip = cardData:IsEquip()
  self.activeSkillData = nil
  self.curSkillState = nil
  self.curSkillCdEndTime = nil
  self.replace_btn:SetActive(isEquip and not self.isVisitMode)
  if isEquip and not self.isVisitMode then
    showBtnCnt = showBtnCnt + 1
  end
  local showUseBtn = isEquip
  if showUseBtn then
    local skillDataList = self.cardData:GetAllSkillDataList(TacticalCardSkillType.Active)
    if skillDataList and #skillDataList == 1 then
      for _, skillData in ipairs(skillDataList) do
        self.activeSkillData = skillData
        break
      end
    end
    showUseBtn = self.activeSkillData ~= nil
  end
  self.use_btn:SetActive(showUseBtn)
  if showUseBtn then
    self.curSkillState = self.activeSkillData:GetCastSkillState({
      usePos = MasterySkillUsePosType.Building
    })
    if self.curSkillState == TCCardSkillState.CD then
      self.curSkillCdEndTime = self.activeSkillData:GetSkillCdOverTime()
    end
    self:UpdateUseBtnText()
    self:RefreshLearnStateView()
    showBtnCnt = showBtnCnt + 1
  end
  if showBtnCnt == 2 then
    self.btn_layout:SetSpacing(164)
  elseif showBtnCnt == 3 then
    self.btn_layout:SetSpacing(34)
  end
end

function UITCCoreCardDetail:UpdateUseBtnText()
  if self.curSkillState and self.curSkillState == TCCardSkillState.CD then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local newState = self.curSkillState
    if curTime < self.curSkillCdEndTime then
      newState = TCCardSkillState.CD
      local leftTime = self.curSkillCdEndTime - curTime
      if leftTime < 0 then
        leftTime = 0
      end
      local countDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
      self.use_num_txt:SetText(countDownTimeStr)
    else
      newState = TCCardSkillState.Normal
    end
    if newState ~= self.curSkillState then
      self.curSkillState = newState
      self:RefreshLearnStateView()
    end
  end
end

function UITCCoreCardDetail:RefreshLearnStateView()
  if not self.curSkillState then
    return
  end
  if self.curSkillState == TCCardSkillState.Normal then
    UIGray.SetGray(self.use_btn.transform, false, true)
    self.use_num_txt:SetActive(true)
    if self.activeSkillData and self.activeSkillData:GetChargeData() then
      local cur, max = self.activeSkillData:GetChargeData():GetCurAndMaxCount()
      if 1 < max then
        self.use_num_txt:SetText(string.format("%s/%s", cur, max))
      else
        self.use_num_txt:SetText("1/1")
      end
    else
      self.use_num_txt:SetText("1/1")
    end
  elseif self.curSkillState == TCCardSkillState.CD then
    UIGray.SetGray(self.use_btn.transform, true, true)
    self.use_num_txt:SetActive(true)
  elseif self.curSkillState == TCCardSkillState.NotUseInBattleField or self.curSkillState == TCCardSkillState.NotUseInCurPos then
    self.use_num_txt:SetLocalText("season_mastery_167")
    UIGray.SetGray(self.use_btn.transform, true, true)
    self.use_num_txt:SetActive(false)
  else
    self.use_num_txt:SetLocalText("season_mastery_167")
    UIGray.SetGray(self.use_btn.transform, true, true)
    self.use_num_txt:SetActive(false)
  end
end

function UITCCoreCardDetail:Update1000MS()
  if self.activeSkillData then
    self:UpdateUseBtnText()
  end
end

function UITCCoreCardDetail:UpdateLvUpgradeCost()
  if not self.lvUpgrade_btn:GetActive() then
    return
  end
  local itemId, itemCnt = self.cardData:GetLvUpgradeCost()
  if not itemId then
    self.upgradeCost_txt:SetText("")
    return
  end
  if not self.itemIconId or self.itemIconId ~= itemId then
    self.itemIconId = itemId
    local itemIconPath = DataCenter.ResourceItemDataManager:GetIconPath(itemId)
    self.upgradeItem_icon:LoadSprite(itemIconPath)
  end
  local curHaveCnt = DataCenter.ResourceItemDataManager:GetCountByItemId(itemId)
  local colorStr = itemCnt <= curHaveCnt and "<color=#FFFFFF>" or "<color=#FF0000>"
  self.upgradeCost_txt:SetText(string.format("%s%s</color>/%s", colorStr, string.GetFormattedStr(curHaveCnt), string.GetFormattedStr(itemCnt)))
end

function UITCCoreCardDetail:OnTacticalCardLvUpgrade(cardUuid)
  if self.cardData.uuid ~= cardUuid then
    return
  end
  self:StopWaitForMsg()
  self:UpdateView(self.cardData)
end

function UITCCoreCardDetail:OnLvUpgrade_btnClick()
  if not self.view.ctrl then
    return
  end
  if not self.cardData then
    return
  end
  if self._waitForMsg then
    return
  end
  if self.view.ctrl:CardLevelUpgrade(self.cardData.uuid) then
    self:StartWaitForMsg()
  end
end

function UITCCoreCardDetail:OnTacticalCardOpenBox()
  self:UpdateStarUpgradeRedDot()
end

function UITCCoreCardDetail:OnTacticalCardStarUpgrade(cardUuid)
  if not self.cardData or self.cardData.uuid ~= cardUuid then
    return
  end
  self:UpdateView(self.cardData)
end

function UITCCoreCardDetail:StartWaitForMsg()
  self._waitForMsg = true
  if self.waitForMsgTimer then
    self.waitForMsgTimer:Stop()
    self.waitForMsgTimer = nil
  end
  self.waitForMsgTimer = TimerManager:GetInstance():DelayInvoke(function()
    self._waitForMsg = false
  end, 2)
end

function UITCCoreCardDetail:StopWaitForMsg()
  self._waitForMsg = false
  if self.waitForMsgTimer then
    self.waitForMsgTimer:Stop()
    self.waitForMsgTimer = nil
  end
end

function UITCCoreCardDetail:OnClose_btnClick()
  self.view.ctrl:CloseSelf()
end

function UITCCoreCardDetail:OnStarUpgrade_btnClick()
  if not self.cardData then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UITCCardStarUpgradePanel, {anim = true}, self.cardData.uuid)
end

function UITCCoreCardDetail:OnReplace_btnClick()
  if not self.cardData then
    return
  end
  local slotId = self.cardData.slotId
  local slotData = TacticalCardUtil.QuickGetSlotDataById(slotId)
  if not slotData then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.TCCardEquip, {anim = true}, slotData)
end

function UITCCoreCardDetail:UpdateStarUpgradeRedDot()
  if not self.cardData then
    return
  end
  local hasRedDot = DataCenter.TacticalCardDataManager:CheckCoreStarUpgrade(self.cardData.cardId)
  self.compStarUpgradeRedDot:SetActive(hasRedDot)
end

function UITCCoreCardDetail:OnShare_btnClick()
  local share_param = {}
  share_param.postType = PostType.TacticalCard
  share_param.cardUuid = self.cardData.uuid
  local chatData = {}
  chatData.post = share_param.postType
  chatData.postType = share_param.postType
  chatData.param = share_param
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, chatData)
end

function UITCCoreCardDetail:OnTacticalCardDataChanged()
  if not self.cardData then
    return
  end
  self:UpdateBtn(self.cardData)
end

function UITCCoreCardDetail:OnUse_btnClick()
  if not self.activeSkillData then
    return
  end
  if self.curSkillState ~= TCCardSkillState.Normal then
    if self.curSkillState == TCCardSkillState.NotUseInCurPos or self.curSkillState == TCCardSkillState.NotUseInBattleField then
      UIUtil.ShowTips(Localization:GetString("battle_card_use_tips_01"))
    elseif self.curSkillState == TCCardSkillState.CD then
      UIUtil.ShowTips(Localization:GetString("battle_card_use_tips_02"))
    end
    return
  end
  TacticalCardUtil.GotoWorldCastSkill(self.activeSkillData)
end

UITCCoreCardDetail.OnCreate = OnCreate
UITCCoreCardDetail.OnDestroy = OnDestroy
UITCCoreCardDetail.OnEnable = OnEnable
UITCCoreCardDetail.OnDisable = OnDisable
UITCCoreCardDetail.ComponentDefine = ComponentDefine
UITCCoreCardDetail.ComponentDestroy = ComponentDestroy
UITCCoreCardDetail.DataDefine = DataDefine
UITCCoreCardDetail.DataDestroy = DataDestroy
UITCCoreCardDetail.OnAddListener = OnAddListener
UITCCoreCardDetail.OnRemoveListener = OnRemoveListener
return UITCCoreCardDetail
