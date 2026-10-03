local UITCNormalCardDetail = BaseClass("UITCNormalCardDetail", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local CardAttrLine = require("UI.LWUITC.UITCCardDetailPanel.Component.CardAttrLineAsync")
local CardAttrLinePrefabPath = "Assets/Main/Prefabs/UI/UILWTC/Component/CardAttrLine.prefab"
local PassiveSkillLine = require("UI.LWUITC.UITCCardDetailPanel.Component.PassiveSkillLineAsync")
local PassiveSkillLinePrefabPath = "Assets/Main/Prefabs/UI/UILWTC/Component/PassiveSkillLine.prefab"

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
  if self.cardData then
    self:UpdateView(self.cardData)
  end
  self.needShowDailyLimitTips = false
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.close_btn = self:AddComponent(UIButton, "CloseBtn")
  self.close_btn:SetOnClick(function()
    self:OnClose_btnClick()
  end)
  self.cardName_txt = self:AddComponent(UITextMeshProUGUIEx, "content/shared/cardName_txt")
  self.cardType_txt = self:AddComponent(UITextMeshProUGUIEx, "content/shared/cardType_txt")
  self.power_txt = self:AddComponent(UITextMeshProUGUIEx, "content/shared/PowerInfo/PowerNumberText")
  self.passiveSkills = self:AddComponent(UIBaseContainer, "content/common_card/attrs/viewport/content/basic_attrs/passive_conatiner")
  self.randomAttrs = self:AddComponent(UIBaseContainer, "content/common_card/attrs/viewport/content/random_attrs")
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
  self.cardIcon_container = self:AddComponent(UIBaseContainer, "content/shared/card")
  self.basicAttrs = self:AddComponent(UIBaseContainer, "content/common_card/attrs/viewport/content/basic_attrs/attr_container")
  self.share_btn = self:AddComponent(UIButton, "share_btn")
  self.share_btn:SetOnClick(function()
    self:OnShare_btnClick()
  end)
  self.lv_txt = self:AddComponent(UITextMeshProUGUIEx, "content/shared/cardLv_txt")
  self.basic_info_btn = self:AddComponent(UIButton, "content/common_card/attrs/viewport/content/basic_attrs/title/info_btn")
  self.basic_info_btn:SetOnClick(function()
    self:OnBasicInfo_btnClick()
  end)
  self.decompose_btn = self:AddComponent(UIButton, "content/btns/decompose_btn")
  self.decompose_btn:SetOnClick(function()
    self:OnDecompose_btnClick()
  end)
end

local function ComponentDestroy(self)
  self:RemoveCardItem()
  self.close_btn = nil
  self.cardName_txt = nil
  self.cardType_txt = nil
  self.power_txt = nil
  self.passiveSkills = nil
  self.randomAttrs = nil
  self.replace_btn = nil
  self.lvUpgrade_btn = nil
  self.upgradeCost = nil
  self.upgradeItem_icon = nil
  self.upgradeCost_txt = nil
  self.cardIcon_container = nil
  self.basicAttrs = nil
  self.share_btn = nil
  self.vfx_saoguang = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.cardData = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshResourceItem, self.UpdateLvUpgradeCost)
  self:AddUIListener(EventId.TacticalCardLvUpgrade, self.OnTacticalCardLvUpgrade)
  self:AddUIListener(EventId.TacticalCardDailyLimitChanged, self.OnDailyLimitUpdate)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshResourceItem, self.UpdateLvUpgradeCost)
  self:RemoveUIListener(EventId.TacticalCardLvUpgrade, self.OnTacticalCardLvUpgrade)
  self:RemoveUIListener(EventId.TacticalCardDailyLimitChanged, self.OnDailyLimitUpdate)
  base.OnRemoveListener(self)
end

function UITCNormalCardDetail:RemoveCardItem()
  if self.cardRequest then
    self.cardIcon_container:RemoveAllComponentes()
    self.cardRequest:Destroy()
    self.cardRequest = nil
  end
end

function UITCNormalCardDetail:SetVisitModeState(isVisitMode)
  self.isVisitMode = isVisitMode
end

function UITCNormalCardDetail:UpdateView(cardData)
  local prevCardData = self.cardData
  self.cardData = cardData
  self:UpdateBaseInfo(cardData)
  self:UpdateAttrs(cardData)
  self:UpdateBtn(cardData)
  if not prevCardData then
    local show_box_id = self.view.ctrl:GetCardShowDailyLimitBoxId(self.cardData)
    if show_box_id then
      DataCenter.TacticalCardDataManager:TryReqDailyLimit()
    end
  end
end

local DISPLAY_CONFIG = {
  isDeluxeShow = true,
  isShowLv = false,
  isShowStar = false
}

function UITCNormalCardDetail:UpdateBaseInfo(cardData)
  self.cardName_txt:SetLocalText(cardData.template.name)
  self.cardType_txt:SetText(TacticalCardUtil.GetCardTypeNameStr(cardData.template.type))
  self.power_txt:SetText(cardData:GetPower())
  self.lv_txt:SetText(TacticalCardUtil.GetLevelStr(cardData))
  if self.cardItem then
    self.cardItem:SetData(cardData, DISPLAY_CONFIG)
  elseif not self.cardRequest then
    self.cardRequest = TacticalCardUtil.CreateOneCardItem(self, cardData.template.type, self.cardIcon_container, function(cardItem)
      cardItem:SetData(cardData, DISPLAY_CONFIG)
      cardItem:SetActive(true)
      self.cardItem = cardItem
      cardItem:SetLocalScaleXYZ(1.26, 1.26, 1.26)
    end)
  end
  local show_box_id = self.view.ctrl:GetCardShowDailyLimitBoxId(cardData)
  if show_box_id then
    self.basic_info_btn:SetActive(true)
  else
    self.basic_info_btn:SetActive(false)
  end
end

function UITCNormalCardDetail:UpdateBasicAttrs(cardData)
  local baseAttrs = cardData:GetNextLvBaseAttrs()
  local toChange = 0
  local curAttrCount = 0
  if self.attrComps then
    curAttrCount = #self.attrComps
  end
  if #baseAttrs == 0 then
    self.basicAttrs:SetActive(false)
    return
  end
  self.basicAttrs:SetActive(true)
  toChange = #baseAttrs - curAttrCount
  if 0 < toChange then
    for i = 1, toChange do
      local attrComp = self.basicAttrs:LoadComponentAsync(CardAttrLine, CardAttrLinePrefabPath, self.basicAttrs)
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

function UITCNormalCardDetail:UpdatePassiveSkills(cardData)
  local passiveSkills = cardData:GetPassiveSkillList(true)
  if not passiveSkills or #passiveSkills == 0 then
    self.passiveSkills:SetActive(false)
    return
  end
  self.passiveSkills:SetActive(true)
  local curPassiveSkillCount = 0
  if self.passiveSkillComps then
    curPassiveSkillCount = #self.passiveSkillComps
  end
  local toChange = #passiveSkills - curPassiveSkillCount
  if 0 < toChange then
    for i = 1, toChange do
      local passiveSkillComp = self.passiveSkills:LoadComponentAsync(PassiveSkillLine, PassiveSkillLinePrefabPath, self.passiveSkills)
      if not self.passiveSkillComps then
        self.passiveSkillComps = {}
      end
      table.insert(self.passiveSkillComps, passiveSkillComp)
    end
  elseif toChange < 0 and self.passiveSkillComps then
    for i, v in ipairs(self.passiveSkillComps) do
      if v then
        v:SetActive(false)
      end
    end
  end
  for i = 1, #passiveSkills do
    self.passiveSkillComps[i]:SetActive(true)
    self.passiveSkillComps[i]:UpdateSkill(passiveSkills[i].desc, passiveSkills[i].val, passiveSkills[i].nextVal, cardData, true)
  end
end

function UITCNormalCardDetail:UpdateRandomAttrs(cardData)
  local randomAttrsArr = cardData:GetRandomAttrsSorted()
  local toChange = 0
  local curAttrCount = 0
  if self.randomAttrComps then
    curAttrCount = #self.randomAttrComps
  end
  toChange = #randomAttrsArr - curAttrCount
  if 0 < toChange then
    for i = 1, toChange do
      local attrComp = self.randomAttrs:LoadComponentAsync(CardAttrLine, CardAttrLinePrefabPath, self.randomAttrs)
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
    self.randomAttrComps[i]:UpdateAttr(randomAttrsArr[i].id, randomAttrsArr[i].value, randomAttrsArr[i].nextValue, randomAttrsArr[i].effectName, randomAttrsArr[i].quality)
  end
  if #randomAttrsArr == 0 then
    self.randomAttrs:SetActive(false)
  else
    self.randomAttrs:SetActive(true)
  end
end

function UITCNormalCardDetail:UpdateAttrs(cardData)
  if cardData:IsUseNewSkillDesc() then
    self.basicAttrs:SetActive(false)
  else
    self.basicAttrs:SetActive(true)
    self:UpdateBasicAttrs(cardData)
  end
  self:UpdatePassiveSkills(cardData)
  self:UpdateRandomAttrs(cardData)
end

function UITCNormalCardDetail:UpdateBtn(cardData)
  local isMaxLv = cardData:IsMaxLv()
  self.lvUpgrade_btn:SetActive(not isMaxLv)
  if not isMaxLv then
    self:UpdateLvUpgradeCost()
  end
  local isEquip = cardData:IsEquip()
  self.replace_btn:SetActive(isEquip and not self.isVisitMode)
  self.decompose_btn:SetActive(not isEquip and not self.isVisitMode)
end

function UITCNormalCardDetail:UpdateLvUpgradeCost()
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

function UITCNormalCardDetail:OnTacticalCardLvUpgrade(cardUuid)
  if self.cardData.uuid ~= cardUuid then
    return
  end
  self:StopWaitForMsg()
  self:UpdateView(self.cardData)
end

function UITCNormalCardDetail:OnLvUpgrade_btnClick()
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

function UITCNormalCardDetail:StartWaitForMsg()
  self._waitForMsg = true
  if self.waitForMsgTimer then
    self.waitForMsgTimer:Stop()
    self.waitForMsgTimer = nil
  end
  self.waitForMsgTimer = TimerManager:GetInstance():DelayInvoke(function()
    self._waitForMsg = false
  end, 2)
end

function UITCNormalCardDetail:StopWaitForMsg()
  self._waitForMsg = false
  if self.waitForMsgTimer then
    self.waitForMsgTimer:Stop()
    self.waitForMsgTimer = nil
  end
end

function UITCNormalCardDetail:OnClose_btnClick()
  self.view.ctrl:CloseSelf()
end

function UITCNormalCardDetail:OnReplace_btnClick()
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

function UITCNormalCardDetail:OnShare_btnClick()
  local share_param = {}
  share_param.postType = PostType.TacticalCard
  share_param.cardUuid = self.cardData.uuid
  local chatData = {}
  chatData.post = share_param.postType
  chatData.postType = share_param.postType
  chatData.param = share_param
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, chatData)
end

function UITCNormalCardDetail:OnBasicInfo_btnClick()
  local show_box_id = self.view.ctrl:GetCardShowDailyLimitBoxId(self.cardData)
  if show_box_id then
    local cur, max = DataCenter.TacticalCardDataManager:GetDailyLimit(show_box_id)
    if max == 0 then
      self.needShowDailyLimitTips = true
    end
    DataCenter.TacticalCardDataManager:TryReqDailyLimit()
    self:ShowDailyLimitTips(show_box_id)
  end
end

function UITCNormalCardDetail:OnDailyLimitUpdate()
  if self.needShowDailyLimitTips and self.cardData then
    local show_box_id = self.view.ctrl:GetCardShowDailyLimitBoxId(self.cardData)
    self:ShowDailyLimitTips(show_box_id)
  end
  self.needShowDailyLimitTips = false
end

function UITCNormalCardDetail:ShowDailyLimitTips(show_box_id)
  if not show_box_id then
    return
  end
  local cur, max = DataCenter.TacticalCardDataManager:GetDailyLimit(show_box_id)
  if max == 0 then
    return
  end
  local param = DataCenter.ArrowTipParamManager:Get(ArrowTipEnumtype.Type.HeroSimpleTip)
  param.content = Localization:GetString("battle_box_get_tips", cur, max)
  param.alignObject = self.basic_info_btn.transform
  param.yPosFix = -10
  param.width = 400
  param.showArrow = true
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroSimpleTip, {anim = true}, param)
end

function UITCNormalCardDetail:OnDecompose_btnClick()
  if not self.cardData then
    return
  end
  local itemId, itemCnt = TacticalCardUtil.GetCardDecomposeMat(self.cardData)
  if not itemId then
    return
  end
  local cardName = Localization:GetString(self.cardData.template.name)
  local param = {
    contentText = Localization:GetString("battle_card_break_bag", cardName, itemCnt),
    btnNum = 2,
    confirmBtnParam = {
      action = function()
        self.view.ctrl:SendDecomposeMessage(self.cardData.uuid)
        self.view.ctrl:CloseSelf()
      end
    }
  }
  UIUtil.TryShowConfirmNew(TodayNoSecondConfirmType.BattleCardDecomposeConfirm, param)
end

UITCNormalCardDetail.OnCreate = OnCreate
UITCNormalCardDetail.OnDestroy = OnDestroy
UITCNormalCardDetail.OnEnable = OnEnable
UITCNormalCardDetail.OnDisable = OnDisable
UITCNormalCardDetail.ComponentDefine = ComponentDefine
UITCNormalCardDetail.ComponentDestroy = ComponentDestroy
UITCNormalCardDetail.DataDefine = DataDefine
UITCNormalCardDetail.DataDestroy = DataDestroy
UITCNormalCardDetail.OnAddListener = OnAddListener
UITCNormalCardDetail.OnRemoveListener = OnRemoveListener
return UITCNormalCardDetail
