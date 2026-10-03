local UIHeroMilitaryRankView = BaseClass("UIHeroMilitaryRankView", UIBaseView)
local base = UIBaseView
local UIHeroMilitaryRankIcon = require("UI.UIHero2.UIHeroInfo.Component.UIHeroMilitaryRankIcon")
local UIHeroMilitarySkillIcon = require("UI.UIHero2.UIHeroMilitaryRank.Component.UIHeroMilitarySkillIcon")
local UIHeroCellSmall = require("UI.UIHero2.Common.UIHeroCellSmall")
local UIMedalCell = require("UI.UIHero2.UIHeroMedalExchange.Component.UIMedalCell")
local Localization = CS.GameEntry.Localization
local UnityOutline = typeof(CS.UnityEngine.UI.Outline)

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnOpen()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  local btn_back = self:AddComponent(UIButton, "Root/BtnBack")
  btn_back:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.nodeMedalExchange = self:AddComponent(UIMedalCell, "Root/NodeMedal")
  self.btnMedalExchange = self:AddComponent(UIButton, "Root/NodeMedal")
  self.btnMedalExchange:SetOnClick(BindCallback(self, self.OnBtnMedalExchangeClick))
  self.textMedalExchange = self:AddComponent(UIText, "Root/NodeMedal/TextMedalExchange")
  self.imgAlpha = self:AddComponent(UIImage, "Root/PageRoot/rightBg/ImgAlpha")
  self.layerNormal = self:AddComponent(UIBaseContainer, "Root/PageRoot/LayerNormal")
  self.alignAnimator = self:AddComponent(UIAnimator, "Root/PageRoot/LayerNormal/Align")
  self.effectNode1 = self:AddComponent(UIBaseContainer, "Root/PageRoot/LayerNormal/Align/MilitaryIcon1/EffectNode1")
  self.effectNode2 = self:AddComponent(UIBaseContainer, "Root/PageRoot/LayerNormal/NodeAttribute/ImgBgAttr1/ImagePower/EffectNode2")
  self.militaryIcon1 = self:AddComponent(UIHeroMilitaryRankIcon, "Root/PageRoot/LayerNormal/Align/MilitaryIcon1")
  self.militaryIcon2 = self:AddComponent(UIHeroMilitaryRankIcon, "Root/PageRoot/LayerNormal/Align/MilitaryIcon2")
  self.textCurPower = self:AddComponent(UIText, "Root/PageRoot/LayerNormal/NodeAttribute/ImgBgAttr1/TextCurPower")
  self.textNextPower = self:AddComponent(UIText, "Root/PageRoot/LayerNormal/NodeAttribute/ImgBgAttr1/TextNextPower")
  self.textTitleAttack = self:AddComponent(UIText, "Root/PageRoot/LayerNormal/NodeAttribute/ImgBgAttr2/TextTitleAttack")
  self.textCurAttack = self:AddComponent(UIText, "Root/PageRoot/LayerNormal/NodeAttribute/ImgBgAttr2/TextCurAttack")
  self.textNextAttack = self:AddComponent(UIText, "Root/PageRoot/LayerNormal/NodeAttribute/ImgBgAttr2/TextNextAttack")
  self.textTitleDefence = self:AddComponent(UIText, "Root/PageRoot/LayerNormal/NodeAttribute/ImgBgAttr3/TextTitleDefence")
  self.textCurDefence = self:AddComponent(UIText, "Root/PageRoot/LayerNormal/NodeAttribute/ImgBgAttr3/TextCurDefence")
  self.textNextDefence = self:AddComponent(UIText, "Root/PageRoot/LayerNormal/NodeAttribute/ImgBgAttr3/TextNextDefence")
  self.textTitleSolider = self:AddComponent(UIText, "Root/PageRoot/LayerNormal/NodeAttribute/ImgBgAttr4/TextTitleSolider")
  self.textCurSolider = self:AddComponent(UIText, "Root/PageRoot/LayerNormal/NodeAttribute/ImgBgAttr4/TextCurSolider")
  self.textNextSolider = self:AddComponent(UIText, "Root/PageRoot/LayerNormal/NodeAttribute/ImgBgAttr4/TextNextSolider")
  self.skillLayerSingle = self:AddComponent(UIBaseContainer, "Root/PageRoot/LayerNormal/NodeSkill/LayerSingle")
  self.skillLayerMulti = self:AddComponent(UIBaseContainer, "Root/PageRoot/LayerNormal/NodeSkill/LayerMulti")
  self.singleSkillIcon1 = self:AddComponent(UIHeroMilitarySkillIcon, "Root/PageRoot/LayerNormal/NodeSkill/LayerSingle/SingleSkillIcon1")
  self.singleSkillIcon2 = self:AddComponent(UIHeroMilitarySkillIcon, "Root/PageRoot/LayerNormal/NodeSkill/LayerSingle/SingleSkillIcon2")
  self.multiSkillIconList = {}
  for i = 1, HeroUtils.SKILL_CNT_MAX do
    local skillIcon = self:AddComponent(UIHeroMilitarySkillIcon, "Root/PageRoot/LayerNormal/NodeSkill/LayerMulti/HeroSkillIcon" .. i)
    table.insert(self.multiSkillIconList, skillIcon)
  end
  self.nodeRequire = self:AddComponent(UIBaseContainer, "Root/PageRoot/LayerNormal/NodeRequire")
  self.textTitleRequire = self:AddComponent(UIText, "Root/PageRoot/LayerNormal/NodeRequire/TextTitleRequire")
  self.requireHeroCell = self:AddComponent(UIHeroCellSmall, "Root/PageRoot/LayerNormal/NodeRequire/UIHeroCellSmall")
  self.textRequireTip = self:AddComponent(UIText, "Root/PageRoot/LayerNormal/NodeRequire/TextRequireTip")
  self.btnGoto = self:AddComponent(UIButton, "Root/PageRoot/LayerNormal/NodeRequire/BtnGoto")
  self.textBtnGoto = self:AddComponent(UIText, "Root/PageRoot/LayerNormal/NodeRequire/BtnGoto/TextBtnGoto")
  self.nodeCost = self:AddComponent(UIBaseContainer, "Root/PageRoot/LayerNormal/NodeCost")
  self.textTitleCost = self:AddComponent(UIText, "Root/PageRoot/LayerNormal/NodeCost/TextTitleCost")
  self.costMedal = self:AddComponent(UIMedalCell, "Root/PageRoot/LayerNormal/NodeCost/Align/NodeCostMedal")
  self.btnMedal = self:AddComponent(UIButton, "Root/PageRoot/LayerNormal/NodeCost/Align/NodeCostMedal/BtnMedal")
  self.textCostGold = self:AddComponent(UIText, "Root/PageRoot/LayerNormal/NodeCost/Align/NodeCostGold/TextCostGold")
  self.btnGold = self:AddComponent(UIButton, "Root/PageRoot/LayerNormal/NodeCost/Align/NodeCostGold")
  self.btnUpgrade = self:AddComponent(UIButton, "Root/PageRoot/LayerNormal/NodeCost/BtnUpgrade")
  self.textBtnUpgrade = self:AddComponent(UIText, "Root/PageRoot/LayerNormal/NodeCost/BtnUpgrade/TextBtnUpgrade")
  self.layerFinal = self:AddComponent(UIBaseContainer, "Root/PageRoot/LayerFinal")
  self.militaryIconFinal = self:AddComponent(UIHeroMilitaryRankIcon, "Root/PageRoot/LayerFinal/FinalMilitaryIcon")
  self.textFinalPower = self:AddComponent(UIText, "Root/PageRoot/LayerFinal/NodeAttribute/ImgBgAttr1/TextFinalPower")
  self.textTitleAttack2 = self:AddComponent(UIText, "Root/PageRoot/LayerFinal/NodeAttribute/ImgBgAttr2/TextTitleAttack2")
  self.textFinalAttack = self:AddComponent(UIText, "Root/PageRoot/LayerFinal/NodeAttribute/ImgBgAttr2/TextFinalAttack")
  self.textTitleDefence2 = self:AddComponent(UIText, "Root/PageRoot/LayerFinal/NodeAttribute/ImgBgAttr3/TextTitleDefence2")
  self.textFinalDefence = self:AddComponent(UIText, "Root/PageRoot/LayerFinal/NodeAttribute/ImgBgAttr3/TextFinalDefence")
  self.textTitleSolider2 = self:AddComponent(UIText, "Root/PageRoot/LayerFinal/NodeAttribute/ImgBgAttr4/TextTitleSolider2")
  self.textFinalSolider = self:AddComponent(UIText, "Root/PageRoot/LayerFinal/NodeAttribute/ImgBgAttr4/TextFinalSolider")
  self.textFinalTip = self:AddComponent(UIText, "Root/PageRoot/LayerFinal/TipBg/TextFinalTip")
  self.finalSkillIconList = {}
  for i = 1, HeroUtils.SKILL_CNT_MAX do
    local skillIcon = self:AddComponent(UIHeroMilitarySkillIcon, "Root/PageRoot/LayerFinal/NodeSkill/LayerFinal/FinalSkillIcon" .. i)
    table.insert(self.finalSkillIconList, skillIcon)
  end
  self.textMedalExchange:SetLocalText(150199)
  self.textTitleAttack:SetLocalText(100150)
  self.textTitleDefence:SetLocalText(130066)
  self.textTitleSolider:SetLocalText(140310)
  self.textTitleAttack2:SetLocalText(150101)
  self.textTitleDefence2:SetLocalText(150102)
  self.textTitleSolider2:SetLocalText(140310)
  self.textTitleRequire:SetLocalText(129113)
  self.textTitleCost:SetLocalText(100040)
  self.textFinalTip:SetLocalText(129122)
  self.textBtnUpgrade:SetLocalText(GameDialogDefine.UPGRADE)
  self.textBtnGoto:SetLocalText(GameDialogDefine.GOTO)
  self.btnMedal:SetOnClick(BindCallback(self, self.OnBtnCostMedalClick))
  self.btnGold:SetOnClick(BindCallback(self, self.OnBtnCostGoldClick))
  self.btnGoto:SetOnClick(BindCallback(self, self.OnBtnGotoClick))
  self.btnUpgrade:SetOnClick(BindCallback(self, self.OnBtnUpgradeClick))
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self.effectNode1:SetActive(false)
  self.effectNode2:SetActive(false)
  EventManager:GetInstance():Broadcast(EventId.ToggleHeroPreviewScene, false)
end

local function OnDisable(self)
  EventManager:GetInstance():Broadcast(EventId.ToggleHeroPreviewScene, true)
  base.OnDisable(self)
end

local function OnOpen(self)
  self.heroUuid = self:GetUserData()
  self.heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.heroUuid)
  self:UpdateData()
  self:UpdateMedalExchangeNode()
  self:UpdateLayerNormal()
  self:UpdateLayerFinal()
end

local function UpdateData(self)
  self.curRankId = self.heroData:GetCurMilitaryRankId()
  self.costMedalId = GetTableData(HeroUtils.GetHeroXmlName(), self.heroData.heroId, "skill_levelup_item")
  self.costMedalNum = GetTableData(TableName.HeroMilitaryRank, self.curRankId, "cost_medal")[self.heroData.rarity]
  self.costGoldNum = GetTableData(TableName.HeroMilitaryRank, self.curRankId, "cost_coin")[self.heroData.rarity]
end

local function UpdateMedalExchangeNode(self)
  local isS = self.heroData.rarity == HeroUtils.RarityType.S
  self.nodeMedalExchange:SetActive(not isS)
  if isS then
    return
  end
  local costMedalId = self.costMedalId
  local template = DataCenter.ItemTemplateManager:GetItemTemplate(costMedalId)
  local para1 = template and template.para1 or nil
  if para1 ~= nil and para1 ~= "" then
    local commonMedalData = DataCenter.ItemData:GetItemById(para1)
    local commonCount = commonMedalData and commonMedalData.count or 0
    self.nodeMedalExchange:SetData(para1, commonCount)
  end
end

local function UpdateLayerNormal(self, showAni)
  local reachMax = self.heroData:IsReachMaxMilitaryRank()
  self.layerNormal:SetActive(not reachMax)
  if reachMax then
    return
  end
  local config = self.heroData.config
  local rarity = self.heroData.rarity
  local curRankId = self.heroData:GetCurMilitaryRankId()
  self.militaryIcon1:SetData(curRankId, false)
  self.militaryIcon2:SetData(curRankId + 1, true)
  local k1 = LuaEntry.DataConfig:TryGetNum("power_setting", "k1")
  local beyondTimes = HeroUtils.GetBeyondTimesByLevel(self.heroData.curMaxLevel)
  local curAtk, curDef = HeroUtils.GetHeroAttr(self.heroData.heroId, self.heroData.quality, self.heroData.level, beyondTimes, curRankId)
  local nextAtk, nextDef = HeroUtils.GetHeroAttr(self.heroData.heroId, self.heroData.quality, self.heroData.level, beyondTimes, curRankId + 1)
  local curPower = Mathf.Round((curAtk + curDef) * k1)
  local nextPower = Mathf.Round((nextAtk + nextDef) * k1)
  local curSolider = HeroUtils.GetArmyLimit(self.heroData.level, curRankId, rarity, config.id, self.heroData.quality)
  local nextSolider = HeroUtils.GetArmyLimit(self.heroData.level, curRankId + 1, rarity, config.id, self.heroData.quality)
  if not showAni then
    self.textCurPower:SetText(curPower)
    self.textCurAttack:SetText(Mathf.Round(curAtk))
    self.textCurDefence:SetText(Mathf.Round(curDef))
    self.textCurSolider:SetText(curSolider)
    self.textNextPower:SetText(nextPower)
    self.textNextAttack:SetText(Mathf.Round(nextAtk))
    self.textNextDefence:SetText(Mathf.Round(nextDef))
    self.textNextSolider:SetText(nextSolider)
  else
    local lastCurPower = tonumber(self.textCurPower:GetText())
    local lastCurAttack = tonumber(self.textCurAttack:GetText())
    local lastCurDefence = tonumber(self.textCurDefence:GetText())
    local lastCurSolider = tonumber(self.textCurSolider:GetText())
    local lastNextPower = tonumber(self.textNextPower:GetText())
    local lastNextAttack = tonumber(self.textNextAttack:GetText())
    local lastNextDefence = tonumber(self.textNextDefence:GetText())
    local lastNextSolider = tonumber(self.textNextSolider:GetText())
    self:RollNum(self.textCurPower, lastCurPower, curPower)
    self:RollNum(self.textCurAttack, lastCurAttack, Mathf.Round(curAtk))
    self:RollNum(self.textCurDefence, lastCurDefence, Mathf.Round(curDef))
    self:RollNum(self.textCurSolider, lastCurSolider, curSolider)
    self:RollNum(self.textNextPower, lastNextPower, nextPower)
    self:RollNum(self.textNextAttack, lastNextAttack, Mathf.Round(nextAtk))
    self:RollNum(self.textNextDefence, lastNextDefence, Mathf.Round(nextDef))
    self:RollNum(self.textNextSolider, lastNextSolider, nextSolider)
  end
  local skillIdxStr = GetTableData(TableName.HeroMilitaryRank, curRankId, "skill")[self.heroData.rarity] or ""
  local upSkillIdxList = string.split(skillIdxStr, ";")
  table.removebyvalue(upSkillIdxList, "0")
  local skillCnt = #upSkillIdxList
  self.skillLayerSingle:SetActive(skillCnt == 1)
  self.skillLayerMulti:SetActive(1 < skillCnt)
  if skillCnt == 1 then
    local skillId = config.skill[tonumber(upSkillIdxList[1])]
    local skillLv = self.heroData:GetSkillLevel(skillId)
    self.singleSkillIcon1:SetData(skillId, skillLv, false, 0.8)
    self.singleSkillIcon2:SetData(skillId, skillLv + 1, false, 0.88)
  elseif 1 < skillCnt then
    for i, skillIcon in pairs(self.multiSkillIconList) do
      local skillId = config.skill[tonumber(upSkillIdxList[i])]
      local skillLv = self.heroData:GetSkillLevel(skillId)
      skillIcon:SetData(skillId, skillLv, true, 0.8 + i * 0.032)
    end
  end
  local requireQuality = GetTableData(TableName.HeroMilitaryRank, curRankId, "require")[self.heroData.rarity]
  self.nodeRequire:SetActive(requireQuality > self.heroData.quality)
  self.nodeCost:SetActive(requireQuality <= self.heroData.quality)
  if requireQuality > self.heroData.quality then
    self.requireHeroCell:InitWithConfigId(self.heroData.heroId, requireQuality, self.heroData.level)
    self.textRequireTip:SetLocalText(129121, string.format("<color='%s'>%s</color>", HeroUtils.GetQualityColorStr(requireQuality), HeroUtils.GetQualityName(requireQuality)))
  else
    self:UpdateConsume()
  end
end

local function RollNum(self, hostText, srcValue, dstValue)
  local function Getter()
    return srcValue
  end
  
  local function Setter(value)
    local v = math.floor(value + 0.5)
    hostText:SetText(v)
  end
  
  local function Complete()
    hostText:SetText(dstValue)
    hostText.transform:Set_localScale(1, 1, 1)
  end
  
  hostText.transform:Set_localScale(1, 1, 1)
  hostText.transform:DOScale(Vector3.New(1.1, 1.1, 1), 0.15):OnComplete(function()
    DOTween.To(Getter, Setter, dstValue, 0.7):OnComplete(Complete)
  end)
end

local function UpdateLayerFinal(self)
  local reachMax = self.heroData:IsReachMaxMilitaryRank()
  self.layerFinal:SetActive(reachMax)
  if not reachMax then
    return
  end
  local maxRankId = self.heroData:GetMaxMilitaryRankId()
  self.militaryIconFinal:SetData(maxRankId)
  local k1 = LuaEntry.DataConfig:TryGetNum("power_setting", "k1")
  local beyondTimes = HeroUtils.GetBeyondTimesByLevel(self.heroData.curMaxLevel)
  local curAtk, curDef = HeroUtils.GetHeroAttr(self.heroData.heroId, self.heroData.quality, self.heroData.level, beyondTimes, maxRankId)
  local curPower = Mathf.Round((curAtk + curDef) * k1)
  self.textFinalPower:SetText(curPower)
  self.textFinalAttack:SetText(self.heroData.atk)
  self.textFinalDefence:SetText(self.heroData.def)
  self.textFinalSolider:SetText(HeroUtils.GetArmyLimit(self.heroData.level, maxRankId, self.heroData.rarity, self.heroData.heroId, self.heroData.quality))
  local skillIds = self.heroData.config.skill
  for k, skillIcon in pairs(self.finalSkillIconList) do
    skillIcon:SetActive(k <= #skillIds)
    if k <= #skillIds then
      local skillId = skillIds[k]
      local skillLevel = self.heroData:GetSkillLevel(skillId)
      skillIcon:SetData(skillId, skillLevel, false, 0.8 + k * 0.032)
    end
  end
end

local function UpdateConsume(self)
  local item = DataCenter.ItemData:GetItemById(self.costMedalId)
  local medalHave = item and item.count or 0
  self.costMedal:SetData(self.costMedalId, self.costMedalNum)
  self.costMedal:SetNumDisplay(medalHave .. "/" .. self.costMedalNum)
  self.textCostGold:SetText(string.GetFormattedSeperatorNum(self.costGoldNum))
  local redColor = Color32.New(0.9098039215686274, 0.25882352941176473, 0.25882352941176473, 1)
  local goldHave = LuaEntry.Resource:GetCntByResType(ResourceType.Food)
  self.costMedal:SetNumColor(medalHave < self.costMedalNum and redColor or Color32.white)
  self.textCostGold:SetColor(goldHave < self.costGoldNum and redColor or Color32.white)
  self.costMedal:ToggleNumOutline(medalHave >= self.costMedalNum)
  local outlines = self.textCostGold.gameObject:GetComponents(UnityOutline)
  for i = 0, outlines.Length - 1 do
    outlines[i].enabled = goldHave >= self.costGoldNum
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.HeroRankUpSuccess, self.OnHandleRankUpSuccess)
  self:AddUIListener(EventId.HeroMedalExchanged, self.OnMedalExchanged)
  self:AddUIListener(EventId.ResourceUpdated, self.OnRefreshItems)
  self:AddUIListener(EventId.RefreshItems, self.OnRefreshItems)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.HeroRankUpSuccess, self.OnHandleRankUpSuccess)
  self:RemoveUIListener(EventId.HeroMedalExchanged, self.OnMedalExchanged)
  self:RemoveUIListener(EventId.ResourceUpdated, self.OnRefreshItems)
  self:RemoveUIListener(EventId.RefreshItems, self.OnRefreshItems)
  base.OnRemoveListener(self)
end

local function OnRefreshItems(self)
  self:UpdateConsume()
end

local function OnBtnMedalExchangeClick(self)
  local template = DataCenter.ItemTemplateManager:GetItemTemplate(self.costMedalId)
  local para1 = template and template.para1
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroMedalExchange, para1, self.costMedalId, self.heroData.heroId, self.costMedalNum)
end

local function OnBtnGotoClick(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroMilitaryRank)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroInfo)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroAdvance, {anim = true, hideTop = true})
end

local function OnBtnUpgradeClick(self)
  if not self.heroData.isMaster then
    return
  end
  local item = DataCenter.ItemData:GetItemById(self.costMedalId)
  local have = item and item.count or 0
  if have < self.costMedalNum then
    UIUtil.ShowTipsId(120021)
    return
  end
  local gold = LuaEntry.Resource:GetCntByResType(ResourceType.Food)
  if gold < self.costGoldNum then
    local lackTab = {}
    local param = {}
    param.type = ResLackType.Res
    param.resType = ResourceType.Food
    param.targetNum = self.costGoldNum
    table.insert(lackTab, param)
    GoToResLack.GoToItemResLackList(lackTab)
    return
  end
  SFSNetwork.SendMessage(MsgDefines.HeroRankUpgrade, self.heroUuid)
end

local function OnMedalExchanged(self)
  self:UpdateConsume()
  self:UpdateMedalExchangeNode()
end

local function OnHandleRankUpSuccess(self)
  self.alignAnimator:SetTrigger("up")
  self.effectNode1:SetActive(false)
  self.effectNode2:SetActive(false)
  self.effectNode1:SetActive(true)
  self.effectNode2:SetActive(true)
  self:UpdateData()
  self:UpdateLayerNormal(true)
  self:UpdateLayerFinal()
end

local function OnBtnCostMedalClick(self)
  local param = {}
  param.itemId = self.costMedalId
  param.alignObject = self.btnMedal
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
end

local function OnBtnCostGoldClick(self)
  local param = {}
  param.itemId = ResourceType.Food
  param.alignObject = self.textCostGold
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
end

UIHeroMilitaryRankView.OnCreate = OnCreate
UIHeroMilitaryRankView.OnDestroy = OnDestroy
UIHeroMilitaryRankView.OnEnable = OnEnable
UIHeroMilitaryRankView.OnDisable = OnDisable
UIHeroMilitaryRankView.OnAddListener = OnAddListener
UIHeroMilitaryRankView.OnRemoveListener = OnRemoveListener
UIHeroMilitaryRankView.ComponentDefine = ComponentDefine
UIHeroMilitaryRankView.ComponentDestroy = ComponentDestroy
UIHeroMilitaryRankView.DataDefine = DataDefine
UIHeroMilitaryRankView.DataDestroy = DataDestroy
UIHeroMilitaryRankView.OnOpen = OnOpen
UIHeroMilitaryRankView.UpdateData = UpdateData
UIHeroMilitaryRankView.UpdateMedalExchangeNode = UpdateMedalExchangeNode
UIHeroMilitaryRankView.UpdateLayerNormal = UpdateLayerNormal
UIHeroMilitaryRankView.UpdateLayerFinal = UpdateLayerFinal
UIHeroMilitaryRankView.UpdateConsume = UpdateConsume
UIHeroMilitaryRankView.OnBtnMedalExchangeClick = OnBtnMedalExchangeClick
UIHeroMilitaryRankView.OnBtnGotoClick = OnBtnGotoClick
UIHeroMilitaryRankView.OnBtnUpgradeClick = OnBtnUpgradeClick
UIHeroMilitaryRankView.OnRefreshItems = OnRefreshItems
UIHeroMilitaryRankView.OnMedalExchanged = OnMedalExchanged
UIHeroMilitaryRankView.OnHandleRankUpSuccess = OnHandleRankUpSuccess
UIHeroMilitaryRankView.RollNum = RollNum
UIHeroMilitaryRankView.OnBtnCostMedalClick = OnBtnCostMedalClick
UIHeroMilitaryRankView.OnBtnCostGoldClick = OnBtnCostGoldClick
return UIHeroMilitaryRankView
