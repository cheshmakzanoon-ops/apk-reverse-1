local UIMailMainPanelView = BaseClass("UIMailMainPanelView", UIBaseView)
local MailChannelItem = require("UI.UIMailNew.UIMailMainPanel.Component.MailChannelItem")
local MailListItem = require("UI.UIMailNew.UIMailMainPanel.Component.MailListItem")
local MailContentContainer = require("UI.UIMailNew.UIMailMainPanel.Component.MailContentContainer")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local _cp_btnClose = "CloseBtn"
local _cp_rightMailContent = "RightScrollView/Viewport/Content"
local _cp_txtNoMail = "txtNoMail"
local _cp_toggleTop = "Toggle_tittle_group/Toggle"
local _cp_btnAllRead = "btn_underneath/btnAllRead"
local _cp_AllReadRed = "btn_underneath/btnAllRead/AllReadRed"
local _cp_btnAllDelte = "btn_underneath/btnAllDelete"
local _cp_btnOneCollect = "btn_underneath/content/btnOneCollect"
local _cp_btnTranslate = "btn_underneath/content/btnTranslate"
local _cp_btnShare = "btn_underneath/content/btnShare"
local _cp_btnOneDelete = "btn_underneath/content/btnOneDelete"
local _cp_scrollMailList = "LeftScrollView"
local _cp_scrollMailListContent = "LeftScrollView/viewport/Content"
local _cp_rightScrollView = "RightScrollView"
local _cp_common_bg = "common_bg"
local _cp_to_bottom = "ToBottom"
local _cp_txt_to_bottom = "ToBottom/ToBottomText"
local _cp_btnRelay = "btn_underneath/content/btnRelay"
local tabBtnArray = {
  MailInternalGroup.MAIL_IN_report,
  MailInternalGroup.MAIL_IN_alliance,
  MailInternalGroup.MAIL_IN_system,
  MailInternalGroup.MAIL_IN_favor
}

function UIMailMainPanelView:ComponentDefine()
  self._btnClose = self:AddComponent(UIButton, _cp_btnClose)
  self._btnClose:SetOnClick(BindCallback(self, self.OnClickBtnClose))
  self._common_bg = self:AddComponent(UIBaseContainer, _cp_common_bg)
  self._rightMailContent = self:AddComponent(MailContentContainer, _cp_rightMailContent)
  self._txtNoMail = self:AddComponent(UIText, _cp_txtNoMail)
  self._btnAllRead = self:AddComponent(UIButton, _cp_btnAllRead)
  self._btnAllRead:SetOnClick(BindCallback(self, self.OnClickBtnAllRead))
  self._cp_readRed = self:AddComponent(UIBaseContainer, _cp_AllReadRed)
  self._btnAllDelete = self:AddComponent(UIButton, _cp_btnAllDelte)
  self._btnAllDelete:SetOnClick(BindCallback(self, self.OnClickBtnAllDelete))
  self._btnOneCollect = self:AddComponent(UIButton, _cp_btnOneCollect)
  self._btnOneCollect:SetOnClick(BindCallback(self, self.OnClickBtnOneCollect))
  self._btnTranslate = self:AddComponent(UIButton, _cp_btnTranslate)
  self._btnTranslate:SetOnClick(BindCallback(self, self.OnClickTranslateBtn))
  self._btnRelay = self:AddComponent(UIButton, _cp_btnRelay)
  self._btnRelay:SetOnClick(BindCallback(self, self.OnClickReplayBtn))
  self._btnShare = self:AddComponent(UIButton, _cp_btnShare)
  self._btnShare:SetOnClick(BindCallback(self, self.OnClickBtnShare))
  self._btnOneDelete = self:AddComponent(UIButton, _cp_btnOneDelete)
  self._btnOneDelete:SetOnClick(BindCallback(self, self.OnClickBtnOneDelete))
  self._rightScrollView = self:AddComponent(UIScrollRect, _cp_rightScrollView)
  self._scrollviewContent = self:AddComponent(UIBaseContainer, _cp_scrollMailListContent)
  self._scrollMailList = self:AddComponent(UILoopListView2, _cp_scrollMailList)
  self._scrollMailList:InitListView(0, function(listview, index)
    return self:GetScrollItem(listview, index)
  end)
  self._scrollMailList:SetOnDragingAction(function()
    self:OnDragingAction()
  end)
  self._scrollMailList:SetOnEndDragAction(function(...)
    self:OnEndDragAction()
  end)
  self._toggles = {}
  for i = 1, table.count(tabBtnArray) do
    local togglePath = _cp_toggleTop .. i
    local toggleBtn = self:AddComponent(MailChannelItem, togglePath)
    self._toggles[#self._toggles + 1] = toggleBtn
    toggleBtn:InitData(tabBtnArray[i], nil)
  end
  self._btnToBottom = self:AddComponent(UIButton, _cp_to_bottom)
  self._btnToBottom:SetOnClick(BindCallback(self, self.OnClickToBottomBtn))
  self._btnToBottom:SetActive(false)
  self._txtToBottom = self:AddComponent(UIText, _cp_txt_to_bottom)
  self._txtToBottom:SetLocalText(208213)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self._btnToBottom.rectTransform)
end

function UIMailMainPanelView:InitOriginState()
end

function UIMailMainPanelView:OnEnable()
  base.OnEnable(self)
  local selectTab = MailInternalGroup.MAIL_IN_report
  if self.selectTab ~= nil then
    selectTab = self.selectTab
    self.selectTab = nil
  end
  for i = 1, table.count(tabBtnArray) do
    if tabBtnArray[i] == selectTab then
      self._toggles[i]:SetSelected()
    end
  end
  self._cp_readRed:SetActive(false)
end

function UIMailMainPanelView:OnClickBtnClose()
  local childCnt = self._rightMailContent.transform.childCount
  for i = 0, childCnt - 1 do
    local child = self._rightMailContent.transform:GetChild(i)
    child.gameObject:SetActive(false)
  end
  self.ctrl:CloseSelf()
end

function UIMailMainPanelView:OnClickBtnAllRead()
  if self.ctrl.currentTab == MailInternalGroup.MAIL_IN_system or self.ctrl.currentTab == MailInternalGroup.MAIL_IN_report or self.ctrl.currentTab == MailInternalGroup.MAIL_IN_alliance then
    DataCenter.MailDataManager:SetAllAndOne(true)
  end
  self.ctrl:ReadMailByGroup()
  if not self.isAllRed then
    UIUtil.ShowTipsId(312080)
  end
end

function UIMailMainPanelView:OnClickBtnAllDelete()
  UIUtil.ShowMessage(Localization:GetString("311040"), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
    self.ctrl:DeleteMailByGroup()
  end, function()
  end)
end

function UIMailMainPanelView:OnClickBtnShare()
  local maildata = self.ctrl:GetCurrentMail()
  MailShowHelper.TryShareMail(maildata)
end

function UIMailMainPanelView:OnClickBtnOneCollect()
  self.ctrl:AddMailToFavor()
  self:CheckIsGetMore()
end

function UIMailMainPanelView:OnClickTranslateBtn()
  local showTranslated = self.ctrl:GetShowTranslated()
  local tempShow = not showTranslated
  self.ctrl:SetShowTranslated(tempShow)
  if tempShow then
    self:SetButtonTxt(self._btnTranslate, "text", "100163")
  else
    self:SetButtonTxt(self._btnTranslate, "text", "290042")
  end
  local mailInfo = self.ctrl:GetCurrentMail()
  if not mailInfo then
    return
  end
  if tempShow then
    local tempLang = Localization:GetLanguageName()
    tempLang = DataCenter.MailTranslateManager:GetLangString(tempLang)
    if not mailInfo.translateMsg or mailInfo.translatedLang ~= tempLang then
      DataCenter.MailTranslateManager:TranslateMail(mailInfo)
    else
      EventManager:GetInstance():Broadcast(EventId.ChangeShowTranslatedStatus, mailInfo)
    end
  else
    EventManager:GetInstance():Broadcast(EventId.ChangeShowTranslatedStatus, mailInfo)
  end
end

function UIMailMainPanelView:OnClickBtnOneDelete()
  local mailInfo = self.ctrl:GetCurrentMail()
  if mailInfo == nil then
    return
  end
  if mailInfo.rewardStatus == 0 then
    return
  end
  UIUtil.ShowMessage(Localization:GetString("310020"), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
    self.ctrl:DeleteCurrentMail()
  end, function()
  end)
end

function UIMailMainPanelView:OnClickToBottomBtn()
  local y = self._rightMailContent.rectTransform.sizeDelta.y - self._rightScrollView.rectTransform.sizeDelta.y
  self._rightMailContent.rectTransform.anchoredPosition = Vector2.New(0, y)
  self._btnToBottom:SetActive(false)
end

function UIMailMainPanelView:InitDialog()
  self:SetButtonTxt(self._btnAllDelete, "text", "310103")
  self:SetButtonTxt(self._btnAllRead, "text", "310104")
  self:SetButtonTxt(self._btnOneDelete, "text", "100190")
  self:SetButtonTxt(self._btnOneCollect, "text", "310102")
  self:SetButtonTxt(self._btnShare, "text", "110073")
  self:SetButtonTxt(self._btnTranslate, "text", "290042")
  self:SetButtonTxt(self._btnRelay, "text", "372265")
end

function UIMailMainPanelView:SetButtonTxt(button, txtPath, dialogId)
  local txtBtn = button.transform:Find(txtPath):GetComponent(typeof(CS.UnityEngine.UI.Text))
  txtBtn.text = Localization:GetString(dialogId)
end

function UIMailMainPanelView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.CLICK_MAIL_ITEM, self.OnRecvMailItemClick)
  self:AddUIListener(EventId.Mail_DeleteMailDone, self.OnMailDeleteDone)
  self:AddUIListener(EventId.Mail_DeleteBatchMailDone, self.OnMailBatchDeleteDone)
  self:AddUIListener(EventId.Mail_Select_Channel, self.OnSelectChannel)
  self:AddUIListener(EventId.MailPush, self.RefreshAllRed)
end

function UIMailMainPanelView:OnRemoveListener()
  self:RemoveUIListener(EventId.CLICK_MAIL_ITEM, self.OnRecvMailItemClick)
  self:RemoveUIListener(EventId.Mail_DeleteMailDone, self.OnMailDeleteDone)
  self:RemoveUIListener(EventId.Mail_DeleteBatchMailDone, self.OnMailBatchDeleteDone)
  self:RemoveUIListener(EventId.Mail_Select_Channel, self.OnSelectChannel)
  self:RemoveUIListener(EventId.MailPush, self.RefreshAllRed)
  base.OnRemoveListener(self)
end

function UIMailMainPanelView:OnSelectChannel(mailChannelType)
  if self.ctrl.currentTab == mailChannelType then
    return
  end
  local forceMoveToTop = self.ctrl.currentTab ~= -1
  if self.ctrl.currentTab ~= -1 then
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Common_SelectTab, false)
  end
  self.ctrl.currentTab = mailChannelType
  self.ctrl:GetCurrentMailListByType(mailChannelType)
  local selectIndex = -1
  if self.selectUid ~= nil then
    for i, v in pairs(self.ctrl.mailList) do
      if v.uid == self.selectUid then
        selectIndex = i
      end
    end
  end
  if selectIndex ~= -1 then
    self.ctrl:SetCurrentMailId(self.selectUid)
  else
    self.ctrl:SetCurrentMailId()
  end
  self:ShowMailContentView()
  self:ShowMailItemList(forceMoveToTop, selectIndex)
  self._btnToBottom:SetActive(false)
  self:RefreshAllRed()
end

function UIMailMainPanelView:RefreshAllRed()
  self.isAllRed = false
  if self.ctrl.currentTab then
    local list = DataCenter.MailDataManager:GetGroupMailList(self.ctrl.currentTab)
    for k = 1, #list do
      if list[k].rewardStatus == 0 and list[k].type ~= MailType.MAIL_UPDATE then
        self._cp_readRed:SetActive(true)
        self.isAllRed = true
        return
      end
    end
  end
  return self._cp_readRed:SetActive(false)
end

function UIMailMainPanelView:ShowMailItemList(forceMoveToTop, toIndex)
  forceMoveToTop = forceMoveToTop or false
  local _maillist = self.ctrl.mailList
  if toIndex ~= nil and toIndex ~= -1 then
    self._scrollMailList:SetListItemCount(#_maillist, false, false)
    self._scrollMailList:RefreshAllShownItem()
    self._scrollMailList:MovePanelToItemIndex(toIndex, 104)
    self._scrollMailList.unity_looplistview2:ForceUpdate()
  else
    self._scrollMailList:SetListItemCount(#_maillist, forceMoveToTop, true)
    self._scrollMailList:RefreshAllShownItem()
  end
end

function UIMailMainPanelView:OnMailDeleteDone()
  self.ctrl:GetCurrentMailListByType(self.ctrl.currentTab)
  local toShowMailId = ""
  if self.ctrl._nextShowMailId ~= "" then
    toShowMailId = self.ctrl._nextShowMailId
  end
  self.ctrl:SetCurrentMailId(toShowMailId)
  self:ShowMailContentView()
  self:ShowMailItemList()
  self:CheckIsGetMore()
end

function UIMailMainPanelView:OnMailBatchDeleteDone()
  self.ctrl:GetCurrentMailListByType(self.ctrl.currentTab)
  self.ctrl:SetCurrentMailId("")
  self:ShowMailContentView()
  self:ShowMailItemList()
end

function UIMailMainPanelView:CheckIsGetMore()
  local _maillist = self.ctrl.mailList
  if #_maillist < 10 then
    self:GetMoreMail()
  end
end

function UIMailMainPanelView:OnCreate()
  base.OnCreate(self)
  local selectTab, selectUid = self:GetUserData()
  self.selectTab = selectTab
  self.selectUid = selectUid
  self.ctrl:InitData()
  self._cellList = {}
  self:ComponentDefine()
  self:InitDialog()
end

function UIMailMainPanelView:OnDestroy()
  self.ctrl.currentTab = -1
  self.ctrl.currentMail = ""
  self._rightMailContent:OnDestroy()
  self._scrollviewContent:RemoveComponents(MailListItem)
  self._scrollMailList:ClearAllItems()
  base.OnDestroy(self)
end

function UIMailMainPanelView:OnRecvMailItemClick(mailid)
  self.ctrl:SetCurrentMailId(mailid)
  self:ShowMailContentView()
end

function UIMailMainPanelView:ShowMailContentView()
  local currentMail = self.ctrl:GetCurrentMail()
  self.ctrl:SetShowTranslated(false)
  self:SetButtonTxt(self._btnTranslate, "text", "290042")
  self._btnRelay:SetActive(false)
  if currentMail == nil then
    self._txtNoMail:SetActive(true)
    self._txtNoMail:SetLocalText(311043)
    self._common_bg:SetActive(false)
  else
    if currentMail.type == MailType.NEW_FIGHT or currentMail.type == MailType.ELITE_FIGHT_MAIL then
      local version = currentMail:GetMailExt():GetVersion()
      if version == nil or version <= 0 then
        UIUtil.ShowTipsId(390843)
        return
      end
    end
    self._common_bg:SetActive(true)
    self._txtNoMail:SetActive(false)
  end
  self._rightScrollView.unity_uiscrollRect.verticalNormalizedPosition = 1
  local result = self._rightMailContent:ShowData(currentMail)
  if not result and currentMail ~= nil then
    self._txtNoMail:SetActive(true)
    self._txtNoMail:SetText("\232\175\165\233\130\174\228\187\182\231\177\187\229\158\139\230\154\130\230\151\182\228\184\141\230\148\175\230\140\129 type:" .. tostring(currentMail.type))
  end
  if self.ctrl.currentTab == MailInternalGroup.MAIL_IN_favor then
    self._btnAllRead:SetActive(false)
    self._btnOneCollect:SetActive(false)
    self._btnTranslate:SetActive(false)
  else
    if currentMail ~= nil and (currentMail.type == MailType.NEW_COLLECT_MAIL or currentMail.type == MailType.RESOURCE_HELP_FROM or currentMail.type == MailType.RESOURCE_HELP_TO or currentMail.type == MailType.MONSTER_COLLECT_REWARD) then
      self._btnOneCollect:SetActive(false)
    else
      self._btnOneCollect:SetActive(true)
    end
    if currentMail and currentMail.type == MailType.MAIL_ALLIANCE_ALL then
      self._btnTranslate:SetActive(true)
    else
      self._btnTranslate:SetActive(false)
    end
    self._btnAllRead:SetActive(true)
  end
  if currentMail ~= nil then
    local mailType = currentMail.type
    local canShare = mailType == MailType.NEW_FIGHT or mailType == MailType.MAIL_SCOUT_RESULT or mailType == MailType.ELITE_FIGHT_MAIL or mailType == MailType.LW_SEASON_SCOUT_MAIL or mailType == MailType.ROB_BANK_MAIL
    self._btnShare:SetActive(canShare)
    if currentMail.type == MailType.NEW_FIGHT then
      local showReplay = currentMail:GetMailExt():GetCanRePlay()
      self._btnRelay:SetActive(showReplay)
    end
  end
  if currentMail ~= nil and currentMail.status ~= 1 then
    self.ctrl:ReadOneMail(currentMail.uid)
  end
  if currentMail ~= nil then
    if currentMail.type == MailType.NEW_COLLECT_MAIL or currentMail.type == MailType.MONSTER_COLLECT_REWARD then
      self._rightScrollView:SetEnable(false)
    else
      self._rightScrollView:SetEnable(true)
    end
  end
end

function UIMailMainPanelView:GetScrollItem(listview, index)
  local _maillist = self.ctrl.mailList
  index = index + 1
  if index < 1 or index > #_maillist then
    return nil
  end
  local item = listview:NewListViewItem("UImail_list_item")
  if self._cellList[item] == nil then
    NameCount = NameCount + 1
    local nameStr = tostring(NameCount)
    item.gameObject.name = nameStr
    local mailItem = self._scrollviewContent:AddComponent(MailListItem, nameStr)
    self._cellList[item] = mailItem
  end
  self._cellList[item]:SetItemShow(self.ctrl.mailList[index])
  return item
end

function UIMailMainPanelView:OnDragingAction()
  local _totalCnt = #self.ctrl.mailList
  if self._loadingMail == true then
    return
  end
  local _lastItem = self._scrollMailList:GetShownItemByItemIndex(_totalCnt - 1)
  if _lastItem == nil then
    return
  end
  local _lastItemY = self._scrollMailList:GetItemCornerPosInViewPort(_lastItem).y
  local _viewPortSize = self._scrollMailList.unity_looplistview2.ViewPortSize
  if 50 <= _lastItemY + _viewPortSize then
    self._toLoadMore = true
  end
end

function UIMailMainPanelView:OnEndDragAction()
  if self._toLoadMore == true then
    self._loadingMail = false
    self._toLoadMore = false
    self:GetMoreMail()
  end
end

function UIMailMainPanelView:GetMoreMail()
  DataCenter.MailDataManager:ReqMore(self.ctrl.currentTab, function()
    self.ctrl:GetCurrentMailListByType(self.ctrl.currentTab)
    self:ShowMailItemList()
  end)
end

function UIMailMainPanelView:RefreshToBottomBtn(btnGetReward)
  local showToBottom = false
  self.btnGetReward = btnGetReward
  if self.ctrl.currentTab == MailInternalGroup.MAIL_IN_system and btnGetReward ~= nil and btnGetReward:GetActive() then
    local standardScale = GetStandardScale()
    local posY = btnGetReward.transform.position.y + btnGetReward.rectTransform.sizeDelta.y / 2 * standardScale
    local bottom = self._rightScrollView.transform.position.y - self._rightScrollView.rectTransform.sizeDelta.y / 2 * standardScale
    if posY < bottom then
      showToBottom = true
    end
  end
  self._btnToBottom:SetActive(showToBottom)
end

function UIMailMainPanelView:Update()
  if self.btnGetReward ~= nil and self.btnGetReward:GetActive() and self._btnToBottom:GetActive() then
    local standardScale = GetStandardScale()
    local posY = self.btnGetReward.transform.position.y + self.btnGetReward.rectTransform.sizeDelta.y / 2 * standardScale
    local bottom = self._rightScrollView.transform.position.y - self._rightScrollView.rectTransform.sizeDelta.y / 2 * standardScale
    if posY >= bottom then
      self._btnToBottom:SetActive(false)
    end
  end
end

function UIMailMainPanelView:OnClickReplayBtn()
  local currentMail = self.ctrl:GetCurrentMail()
  if currentMail == nil or currentMail.type ~= MailType.NEW_FIGHT then
    return
  end
  local count = currentMail:GetMailExt():GetTotalRoundCnt()
  if count == 1 then
    local pveTemplate = DataCenter.PveLevelTemplateManager:GetTemplate(BattlePlayBackLevelId)
    if pveTemplate ~= nil then
      local param = {}
      local _showData = currentMail:GetMailExt():GetShowRoundListDataByIndex(1)
      if _showData == nil then
        return
      end
      local roundFight = currentMail:GetMailExt():GetFightReportByRoundIndex(1)
      if roundFight == nil then
        return
      end
      local bigRoundIndex = _showData._roundIndex
      local bigRoundUuid = _showData.roundUuid
      local selfHealth = roundFight:GetTroopHealth(true)
      local otherHealth = roundFight:GetTroopHealth(false)
      local leftUuid = _showData.leftUuid
      local rightUuid = _showData.rightUuid
      local leftFightData = _showData.leftData
      local rightFightData = _showData.rightData
      local leftBattleEffect = currentMail:GetMailExt():GetMySideBattleEffect(leftUuid)
      local rightBattleEffect = currentMail:GetMailExt():GetOtherSideBattleEffect(rightUuid)
      local leftHero = {}
      local rightHero = {}
      local leftSoliderList = {}
      local rightSoliderList = {}
      local leftPower = 0
      local rightPower = 0
      local rightMonsterId = 0
      
      local function GetHeroInfo(heroData)
        local oneData = {}
        local power = 0
        local level = heroData.heroLevel
        local heroId = heroData.heroId
        local rankLv = heroData.rankLv or 0
        local stage = heroData.stage or 0
        local quality = heroData.heroQuality or 0
        local curMilitaryRankId = HeroUtils.GetRankIdByLvAndStage(heroId, rankLv, stage)
        local k1 = LuaEntry.DataConfig:TryGetNum("power_setting", "k1")
        local beyondTimes = HeroUtils.GetBeyondTimesByLevel(level)
        local curAtk, curDef = HeroUtils.GetHeroAttr(heroId, quality, level, beyondTimes, curMilitaryRankId)
        power = Mathf.Round((curAtk + curDef) * k1)
        local skillData = heroData.skillInfos
        local firstSkillId = HeroUtils.GetHeroFirstSkillId(heroId)
        local skillLv = 0
        for a, b in pairs(skillData) do
          local id = b.skillId
          local skillLevel = b.skillLv
          if id == firstSkillId then
            skillLv = skillLevel
          end
          local powerStr = GetTableData(TableName.SkillTab, id, "power")
          local strArr = string.split(powerStr, "|")
          if skillLevel <= #strArr then
            power = power + tonumber(strArr[skillLevel])
          end
        end
        oneData.heroId = tostring(heroId)
        oneData.heroLv = level
        oneData.heroQuality = quality
        oneData.index = heroData.index
        oneData.power = power
        oneData.damage = HeroUtils.GetHeroSkillDamage(firstSkillId, skillLv)
        return oneData
      end
      
      local function GetEffectNum(battleEffect, effectId)
        if battleEffect ~= nil then
          return battleEffect:GetValue(effectId)
        end
        return 0
      end
      
      if leftFightData.unitData ~= nil then
        local attr = leftFightData.unitAttrInfo
        if attr == nil then
          return
        end
        local heroes = leftFightData.unitData:GetPlayerHeroes()
        if table.count(heroes) == 0 then
          return
        end
        local heroList = table.values(heroes)
        table.sort(heroList, function(heroA, heroB)
          return heroA.index < heroB.index
        end)
        local heroKey = {}
        local sumSkillDamage = 0
        for i = 1, #heroList do
          local heroData = heroList[i]
          local oneData = GetHeroInfo(heroData)
          sumSkillDamage = sumSkillDamage + oneData.damage
          table.insert(heroKey, oneData.heroId)
          table.insert(leftHero, oneData)
        end
        local heroAtk = attr:GetAtkAttrByType(AtkDefReason.HERO)
        local heroDef = attr:GetDefAttrByType(AtkDefReason.HERO)
        local campAtkAdd = 0
        local campData = MarchUtil.GetCampParamByHeroIdList(heroKey)
        if 0 < #campData then
          for i = 1, #campData do
            campAtkAdd = campAtkAdd + campData[i].addEffectNum
          end
        end
        local soldierBasicAtk = 0
        local soldierBasicDef = 0
        local soldierBasicHealth = 0
        local soldierTotalNum = 0
        local soliderList = leftFightData.unitData:GetSoldiers()
        local totalFormationAtkAdd = GetEffectNum(leftBattleEffect, EffectDefine.APS_BATTLE_TROOP_TOTAL_ATK_INCR_PERCENT)
        local totalFormationDefAdd = GetEffectNum(leftBattleEffect, EffectDefine.APS_BATTLE_TROOP_TOTAL_DEF_INCR_PERCENT)
        local baseAtkEffectNum = GetEffectNum(leftBattleEffect, GetTableData("effect", EffectCoupleType.BASE_ATTACK, "arm_all"))
        local baseDefEffectNum = GetEffectNum(leftBattleEffect, GetTableData("effect", EffectCoupleType.BASE_DEFEND, "arm_all"))
        local baseHealthEffectNum = GetEffectNum(leftBattleEffect, GetTableData("effect", EffectCoupleType.BASE_HEALTH_PERCENT, "arm_all"))
        for k, v in pairs(soliderList) do
          local armId = k
          local num = v[eMailSoldierAttr.Total] - v[eMailSoldierAttr.Lost]
          local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(k)
          if template ~= nil then
            local atk = template.attack
            local def = template.defence
            local health = template.health
            local typeStr = template:GetAddValueEffectName()
            local typeAtkEffectNum = GetEffectNum(leftBattleEffect, GetTableData("effect", EffectCoupleType.BASE_ATTACK, typeStr))
            local typeDefEffectNum = GetEffectNum(leftBattleEffect, GetTableData("effect", EffectCoupleType.BASE_DEFEND, typeStr))
            local typeHealthEffectNum = GetEffectNum(leftBattleEffect, GetTableData("effect", EffectCoupleType.BASE_HEALTH_PERCENT, typeStr))
            soldierBasicAtk = soldierBasicAtk + atk * (1 + (totalFormationAtkAdd + baseAtkEffectNum + typeAtkEffectNum) / 100) * num
            soldierBasicDef = soldierBasicDef + def * (1 + (totalFormationDefAdd + baseDefEffectNum + typeDefEffectNum) / 100) * num
            soldierBasicHealth = soldierBasicHealth + health * (1 + (baseHealthEffectNum + typeHealthEffectNum) / 100) * num
            soldierTotalNum = soldierTotalNum + num
            leftSoliderList[armId] = num
          end
        end
        if 0 < soldierTotalNum then
          local k1 = LuaEntry.DataConfig:TryGetNum("new_battle_config", "k1")
          local k2 = LuaEntry.DataConfig:TryGetNum("new_battle_config", "k2")
          local k3 = LuaEntry.DataConfig:TryGetNum("new_battle_config", "k3")
          local k15 = LuaEntry.DataConfig:TryGetNum("new_battle_config", "k15")
          local k16 = LuaEntry.DataConfig:TryGetNum("new_battle_config", "k16")
          local k18 = LuaEntry.DataConfig:TryGetNum("new_battle_config", "k18")
          local totalPower = Mathf.Pow(soldierTotalNum * k1, k2) * (soldierBasicAtk / soldierTotalNum) * (soldierBasicDef / soldierTotalNum) * (soldierBasicHealth / soldierTotalNum) * Mathf.Pow(heroAtk, k3) * Mathf.Pow(heroDef, k3) * (1 + campAtkAdd / 100) * (1 + sumSkillDamage / 10) * soldierTotalNum / math.max(1, k15)
          leftPower = Mathf.Pow(totalPower, k18)
        end
      end
      if rightFightData.unitData ~= nil then
        local attr = rightFightData.unitAttrInfo
        if attr == nil then
          return
        end
        local heroes = rightFightData.unitData:GetPlayerHeroes()
        if table.count(heroes) == 0 then
          return
        end
        local heroList = table.values(heroes)
        table.sort(heroList, function(heroA, heroB)
          return heroA.index < heroB.index
        end)
        local heroKey = {}
        local sumSkillDamage = 0
        for i = 1, #heroList do
          local heroData = heroList[i]
          local oneData = GetHeroInfo(heroData)
          sumSkillDamage = sumSkillDamage + oneData.damage
          table.insert(heroKey, oneData.heroId)
          table.insert(rightHero, oneData)
        end
        local heroAtk = attr:GetAtkAttrByType(AtkDefReason.HERO)
        local heroDef = attr:GetDefAttrByType(AtkDefReason.HERO)
        local campAtkAdd = 0
        local campData = MarchUtil.GetCampParamByHeroIdList(heroKey)
        if 0 < #campData then
          for i = 1, #campData do
            campAtkAdd = campAtkAdd + campData[i].addEffectNum
          end
        end
        local soldierBasicAtk = 0
        local soldierBasicDef = 0
        local soldierBasicHealth = 0
        local soldierTotalNum = 0
        local soliderList = rightFightData.unitData:GetSoldiers()
        local totalFormationAtkAdd = GetEffectNum(rightBattleEffect, EffectDefine.APS_BATTLE_TROOP_TOTAL_ATK_INCR_PERCENT)
        local totalFormationDefAdd = GetEffectNum(rightBattleEffect, EffectDefine.APS_BATTLE_TROOP_TOTAL_DEF_INCR_PERCENT)
        local baseAtkEffectNum = GetEffectNum(rightBattleEffect, GetTableData("effect", EffectCoupleType.BASE_ATTACK, "arm_all"))
        local baseDefEffectNum = GetEffectNum(rightBattleEffect, GetTableData("effect", EffectCoupleType.BASE_DEFEND, "arm_all"))
        local baseHealthEffectNum = GetEffectNum(rightBattleEffect, GetTableData("effect", EffectCoupleType.BASE_HEALTH_PERCENT, "arm_all"))
        for k, v in pairs(soliderList) do
          local armId = k
          local num = v[eMailSoldierAttr.Total] - v[eMailSoldierAttr.Lost]
          local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(k)
          if template ~= nil then
            local atk = template.attack
            local def = template.defence
            local health = template.health
            local typeStr = template:GetAddValueEffectName()
            local typeAtkEffectNum = GetEffectNum(rightBattleEffect, GetTableData("effect", EffectCoupleType.BASE_ATTACK, typeStr))
            local typeDefEffectNum = GetEffectNum(rightBattleEffect, GetTableData("effect", EffectCoupleType.BASE_DEFEND, typeStr))
            local typeHealthEffectNum = GetEffectNum(rightBattleEffect, GetTableData("effect", EffectCoupleType.BASE_HEALTH_PERCENT, typeStr))
            soldierBasicAtk = soldierBasicAtk + atk * (1 + (totalFormationAtkAdd + baseAtkEffectNum + typeAtkEffectNum) / 100) * num
            soldierBasicDef = soldierBasicDef + def * (1 + (totalFormationDefAdd + baseDefEffectNum + typeDefEffectNum) / 100) * num
            soldierBasicHealth = soldierBasicHealth + health * (1 + (baseHealthEffectNum + typeHealthEffectNum) / 100) * num
            soldierTotalNum = soldierTotalNum + num
            rightSoliderList[armId] = num
          end
        end
        if 0 < soldierTotalNum then
          local k1 = LuaEntry.DataConfig:TryGetNum("new_battle_config", "k1")
          local k2 = LuaEntry.DataConfig:TryGetNum("new_battle_config", "k2")
          local k3 = LuaEntry.DataConfig:TryGetNum("new_battle_config", "k3")
          local k15 = LuaEntry.DataConfig:TryGetNum("new_battle_config", "k15")
          local k16 = LuaEntry.DataConfig:TryGetNum("new_battle_config", "k16")
          local k18 = LuaEntry.DataConfig:TryGetNum("new_battle_config", "k18")
          local totalPower = Mathf.Pow(soldierTotalNum * k1, k2) * (soldierBasicAtk / soldierTotalNum) * (soldierBasicDef / soldierTotalNum) * (soldierBasicHealth / soldierTotalNum) * Mathf.Pow(heroAtk, k3) * Mathf.Pow(heroDef, k3) * (1 + campAtkAdd / 100) * (1 + sumSkillDamage / 10) * soldierTotalNum / math.max(1, k15)
          rightPower = Mathf.Pow(totalPower, k18)
        end
      end
      param.leftPower = leftPower
      param.rightPower = rightPower
      param.leftHero = leftHero
      param.rightHero = rightHero
      param.leftSoliderList = leftSoliderList
      param.rightSoliderList = rightSoliderList
      param.rightMonsterId = rightMonsterId
      param.selfHealth = selfHealth
      param.otherHealth = otherHealth
      param.bigRoundUuid = bigRoundUuid
      param.bigRoundIndex = bigRoundIndex
      param.pveEntrance = PveEntrance.BattlePlayBack
      param.levelId = BattlePlayBackLevelId
      param.mailId = currentMail.uid
      param.battleResult = currentMail:GetMailExt():GetBattleWinInPve()
      param.jumpType = PlayBackEndJumpType.Mail
      param.leftHeadParam = {}
      if leftFightData.unitData ~= nil then
        param.leftHeadParam.uid = leftFightData.unitData:GetUserId()
        param.leftHeadParam.pic = leftFightData.unitData.pic
        param.leftHeadParam.picVer = leftFightData.unitData.picVer
      end
      param.rightHeadParam = {}
      if rightFightData.battleType == BattleType.Monster then
        param.rightHeadParam.monsterPic = "Assets/Main/Sprites/HeroIconsSmall/UIPVEorder_img_guai.png"
      elseif rightFightData.unitData ~= nil then
        param.rightHeadParam.uid = rightFightData.unitData:GetUserId()
        param.rightHeadParam.pic = rightFightData.unitData.pic
        param.rightHeadParam.picVer = rightFightData.unitData.picVer
      end
      DataCenter.BattleLevel:Enter(param)
    end
  end
end

return UIMailMainPanelView
