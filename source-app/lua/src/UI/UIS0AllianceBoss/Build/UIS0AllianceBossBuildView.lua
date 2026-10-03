local UIS0AllianceBossBuildView = BaseClass("UIS0AllianceBossBuildView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local AlScienceHitRatio = require("UI.UIAlliance.UIAllianceScienceInfo.Component.AlScienceHitRatio")
local UIMainResourceProgress = require("UI.LWMainUI.Component.UIMainTop.UIMainResourceProgress")
local triggerLongPressTime = 0.5
local longPressInterval = 0.15
local longPressMinInterval = 0.05
local longPressIntervalAccTime = 0.5
local COST_NUM = 1

function UIS0AllianceBossBuildView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.openFromWorld = self:GetUserData() or false
  self:InitView()
end

function UIS0AllianceBossBuildView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIS0AllianceBossBuildView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnEmpty = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnEmpty:SetOnClick(function()
    self:OnBtnEmptyClick()
  end)
  self.rawImgZsBanshou = self.viewSkin:AddComponent(self, UIRawImage, 2)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textTarget = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.imgBgQuality = self.viewSkin:AddComponent(self, UIImage, 5)
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 6)
  self.textNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.textDonationTask = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.textDonationReward = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.imgIconReward = self.viewSkin:AddComponent(self, UIImage, 10)
  self.textRewardNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.slider = self.viewSkin:AddComponent(self, UISlider, 12)
  self.textSliderTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 13)
  self.btnInfo = self.viewSkin:AddComponent(self, UIButton, 14)
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.textBonuDetail = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 15)
  self.textBuff = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 16)
  self.textBuffNextLevel = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 17)
  self.textMaxLevel = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 18)
  self.textCurrent = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 19)
  self.btnDonate = self.viewSkin:AddComponent(self, UIEventTrigger, 20)
  self.textConversion = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 21)
  self.textCostNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 22)
  self.imgBanshou = self.viewSkin:AddComponent(self, UIImage, 23)
  self.btnRecord = self.viewSkin:AddComponent(self, UIButton, 24)
  self.btnRecord:SetOnClick(function()
    self:OnBtnRecordClick()
  end)
  self.compHit = self.viewSkin:AddComponent(self, UIBaseContainer, 25)
  self.compHitItem = self.viewSkin:AddComponent(self, UIBaseContainer, 26)
  self.compBubbleTipsContent = self.viewSkin:AddComponent(self, UIBaseContainer, 27)
  self.btnBubbleTips = self.viewSkin:AddComponent(self, UIButton, 28)
  self.btnBubbleTips:SetOnClick(function()
    self:OnBtnBubbleTipsClick()
  end)
  self.textBubbleTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 29)
  self.compAlliancePointResourceCell = self.viewSkin:AddComponent(self, UIMainResourceProgress, 30)
  self.btnDonate:OnPointerDown(BindCallback(self, self.OnPointerDown))
  self.btnDonate:OnPointerUp(BindCallback(self, self.OnPointerUp))
  self.hitItem = self.compHitItem.gameObject
  self.hitItem:GameObjectCreatePool()
  self.compBubbleTipsContent:SetActive(false)
end

function UIS0AllianceBossBuildView:ComponentDestroy()
  self.viewSkin = nil
  self.btnEmpty = nil
  self.rawImgZsBanshou = nil
  self.btnClose = nil
  self.textTarget = nil
  self.imgBgQuality = nil
  self.imgIcon = nil
  self.textNum = nil
  self.textDonationTask = nil
  self.textDonationReward = nil
  self.imgIconReward = nil
  self.textRewardNum = nil
  self.slider = nil
  self.textSliderTip = nil
  self.btnInfo = nil
  self.textBonuDetail = nil
  self.textBuff = nil
  self.textBuffNextLevel = nil
  self.textMaxLevel = nil
  self.textCurrent = nil
  self.btnDonate = nil
  self.textConversion = nil
  self.textCostNum = nil
  self.imgBanshou = nil
  self.btnRecord = nil
  self.compHit = nil
  self.compHitItem = nil
  self.compBubbleTipsContent = nil
  self.btnBubbleTips = nil
  self.textBubbleTips = nil
  self.compAlliancePointResourceCell = nil
  self.hitItem:GameObjectRecycleAll()
  self.hitItem = nil
end

function UIS0AllianceBossBuildView:DataDefine()
  self.goodsId = nil
  self.donateGotNum = nil
  self.mgr = DataCenter.S0AllianceBossDataManager
  local curDifficulty = self.mgr.curDifficulty
  local bossDifficultyIds = DataCenter.AllianceBossS0TemplateManager:GetBossDifficultyIds()
  local bossId = bossDifficultyIds[curDifficulty]
  self.curDifficulty = curDifficulty
  if bossId then
    local bossTemp = DataCenter.AllianceBossS0TemplateManager:GetTemplate(bossId)
    if bossTemp then
      self.donateMaxLevel = bossTemp:GetDonateMaxLevel()
    end
    self.bossTemp = bossTemp
  end
  self.curDonateLevel = nil
  self.isClick = nil
  self.lastTime = nil
  self.hitItemCount = 0
  self.recordList = self.mgr:GetRecordList()
  self.curSingleClickDonateNum = 0
  self.triggerBubbleTipsNum = DataCenter.S0AllianceBossDataManager:GetDonateHintClickNum()
  self.bubbleTipsShowTime = DataCenter.S0AllianceBossDataManager:GetDonateHintShowTime()
  self.isShowBubbleTips = false
  self.isAlreadyShowBubbleTips = false
  self.alliancePointResourceCellParam = {
    resourceType = ResourceType.AlliancePoint,
    iconName = DataCenter.ResourceManager:GetResourceIconByType(ResourceType.AlliancePoint, nil, nil, true)
  }
  self.donateDisable = false
end

function UIS0AllianceBossBuildView:DataDestroy()
  self.goodsId = nil
  self.donateGotNum = nil
  self.mgr = nil
  self.curDifficulty = nil
  self.bossTemp = nil
  self.donateMaxLevel = nil
  self.curDonateLevel = nil
  self.isClick = nil
  self.lastTime = nil
  self.hitItemCount = nil
  self.recordList = nil
  self.curSingleClickDonateNum = nil
  self.triggerBubbleTipsNum = nil
  self.bubbleTipsShowTime = nil
  self.isShowBubbleTips = nil
  self.isAlreadyShowBubbleTips = nil
  self.alliancePointResourceCellParam = nil
  self.openFromWorld = nil
  self.donateDisable = nil
end

function UIS0AllianceBossBuildView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnS0AllianceBossDonateSuccess, self.OnDonateSuccess)
  self:AddUIListener(EventId.OnS0AllianceBossDonateInfoUpdated, self.RefreshView)
  self:AddUIListener(EventId.OnS0AllianceBossBattleStart, self.OnBattleStart)
end

function UIS0AllianceBossBuildView:OnRemoveListener()
  self:RemoveUIListener(EventId.OnS0AllianceBossDonateSuccess, self.OnDonateSuccess)
  self:RemoveUIListener(EventId.OnS0AllianceBossDonateInfoUpdated, self.RefreshView)
  self:RemoveUIListener(EventId.OnS0AllianceBossBattleStart, self.OnBattleStart)
  base.OnRemoveListener(self)
end

function UIS0AllianceBossBuildView:InitView()
  self.textTarget:SetLocalText("s0_alliance_boss_build_trap")
  self.goodsId = DataCenter.S0AllianceBossDataManager:GetDonateGoodsId()
  local template = DataCenter.ItemTemplateManager:GetItemTemplate(self.goodsId)
  if template then
    self.imgBgQuality:LoadSpriteAuto(UIUtil.GetItemQualityBg(template.quality))
    local goodIcon = string.format(LoadPath.ItemPath, template.icon)
    self.imgIcon:LoadSpriteAuto(goodIcon)
    self.imgBanshou:LoadSpriteAuto(goodIcon)
  end
  self.textDonationTask:SetLocalText("s0_alliance_boss_donation_bonus")
  self.textDonationReward:SetLocalText("s0_alliance_boss_donation_reward")
  self.donateGotNum = DataCenter.S0AllianceBossDataManager:GetDonateGetNum()
  self.textRewardNum:SetText(self.donateGotNum)
  self.textBonuDetail:SetLocalText("s0_alliance_boss_bonus_detail")
  self.textMaxLevel:SetLocalText("s0_alliance_boss_max_level")
  self.textCurrent:SetLocalText("s0_alliance_boss_donation_now_limit")
  self.textConversion:SetLocalText("s0_alliance_boss_donate_action")
  self.textBubbleTips:SetLocalText("alliance_science_longpress_tips_01")
  DataCenter.S0AllianceBossDataManager:ReqAllianceBossS0GetDonateInfo()
  self:RefreshView()
  self:RefreshAlliancePointView(false)
end

function UIS0AllianceBossBuildView:RefreshView()
  local mgr = self.mgr
  if mgr then
    self.donateMulti = mgr.donateMulti
    self.curDonateLevel = mgr.curDonateLevel
    if self.bossTemp then
      local curDonateNum = mgr.curDonateExp
      local maxFull = false
      local curDonateMaxNum = 0
      if self.donateMaxLevel == self.curDonateLevel then
        maxFull = true
      else
        curDonateMaxNum = self.bossTemp:GetDonateLevelExp(self.curDonateLevel + 1)
        if curDonateNum > curDonateMaxNum then
          curDonateNum = curDonateMaxNum
        end
      end
      if maxFull then
        self.textSliderTip:SetLocalText("s0_alliance_boss_max_level")
        self.slider:SetValue(1)
      else
        self.textSliderTip:SetText(curDonateNum .. "/" .. curDonateMaxNum)
        local progress = Mathf.Clamp(curDonateNum / curDonateMaxNum, 0, 1)
        self.slider:SetValue(progress)
      end
    end
    if self.curDonateLevel == self.donateMaxLevel then
      self.textMaxLevel:SetActive(true)
      self.textBuffNextLevel:SetActive(false)
      local curDmgAddition = self.bossTemp:GetDonateDmgAddition(self.curDonateLevel) or 0
      local curAdditionPer = math.modf(curDmgAddition * 100)
      self.textBuff:SetLocalText("s0_alliance_boss_damage_bonus", self.curDonateLevel, curAdditionPer)
    else
      self.textMaxLevel:SetActive(false)
      self.textBuffNextLevel:SetActive(true)
      if self.bossTemp then
        if self.curDonateLevel == 0 then
          self.textBuff:SetLocalText("s0_alliance_boss_damage_bonus_lv0")
        else
          local curDmgAddition = self.bossTemp:GetDonateDmgAddition(self.curDonateLevel) or 0
          local curAdditionPer = math.modf(curDmgAddition * 100)
          self.textBuff:SetLocalText("s0_alliance_boss_damage_bonus", self.curDonateLevel, curAdditionPer)
        end
        local nextDmgAddition = self.bossTemp:GetDonateDmgAddition(self.curDonateLevel + 1)
        local nextAdditionPer = math.modf(nextDmgAddition * 100)
        self.textBuffNextLevel:SetLocalText("s0_alliance_boss_damage_bonus_next", self.curDonateLevel + 1, nextAdditionPer)
      end
    end
  end
  if self.bossTemp and self.goodsId then
    local have = DataCenter.ItemData:GetItemCount(self.goodsId)
    self.textNum:SetText(have)
    self.textCostNum:SetText(have .. "/" .. COST_NUM)
    if have < COST_NUM then
      self.donateDisable = true
      self.textCostNum:SetColorHex("#F97077")
    else
      self.donateDisable = false
      self.textCostNum:SetColorHex("#FFFFFF")
    end
  end
end

function UIS0AllianceBossBuildView:OnDonateSuccess()
  self:RefreshView()
  self:ShowUIEffect()
  self:RefreshAlliancePointView(true)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function UIS0AllianceBossBuildView:OnBattleStart(actStatus)
  if actStatus == AllianceBossS0ActStatus.InCombat and self.ctrl then
    self.ctrl:CloseSelf()
  end
end

function UIS0AllianceBossBuildView:RefreshAlliancePointView(isUpdate)
  if self.compAlliancePointResourceCell then
    if isUpdate then
      self.compAlliancePointResourceCell:ChangeParam(self.alliancePointResourceCellParam)
    else
      if self.openFromWorld then
        self.compAlliancePointResourceCell:SetAnchoredPositionXY(-257, -84)
      elseif CommonUtil.IsArabic() and CommonUtil.ArabicAutoMirrorFactor() == 1 then
        self.compAlliancePointResourceCell:SetAnchoredPositionXY(-690, -40)
      else
        self.compAlliancePointResourceCell:SetAnchoredPositionXY(-88, -40)
      end
      self.compAlliancePointResourceCell:ReInit(self.alliancePointResourceCellParam)
    end
  end
end

function UIS0AllianceBossBuildView:OnPointerDown()
  self.isClick = true
  self.lastTime = Time.time
end

function UIS0AllianceBossBuildView:OnPointerUp()
  if self.isClick then
    self:OnResDonateClick()
  end
  self:BreakLongPress()
end

local function CheckPressInterval(self)
  if self.lastTime == nil or self.donateDisable then
    return
  end
  local checkIntervalTime = Time.time - self.lastTime
  if not self.isLongPress then
    if checkIntervalTime < triggerLongPressTime then
      return
    end
    self.lastTime = Time.time
    self.startPressTime = Time.time
    self.isLongPress = true
    self.curSingleClickDonateNum = 0
    self.isClick = false
  end
  local curPressTime = Time.time - self.startPressTime
  local DynamicCheckInterval = Mathf.Lerp(longPressInterval, longPressMinInterval, Mathf.Clamp01(curPressTime / longPressIntervalAccTime))
  if checkIntervalTime < DynamicCheckInterval then
    return
  end
  self.lastTime = Time.time
  self:OnResDonateClick()
end

function UIS0AllianceBossBuildView:Update100MS()
  CheckPressInterval(self)
end

function UIS0AllianceBossBuildView:BreakLongPress()
  self.isLongPress = false
  self.lastTime = nil
  self.startPressTime = nil
end

function UIS0AllianceBossBuildView:OnResDonateClick()
  if self.donateDisable then
    UIUtil.ShowTipsId("s0_alliance_boss_donation_null_tips")
    return
  elseif self.mgr then
    self.mgr:ReqAllianceBossS0Donate()
  else
    DataCenter.S0AllianceBossDataManager:ReqAllianceBossS0Donate()
  end
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if self.isClick then
    if self.isUpgradeBtnGray then
      self.curSingleClickDonateNum = 0
    end
    if not self.isAlreadyShowBubbleTips and not self.isUpgradeBtnGray then
      self.curSingleClickDonateNum = self.curSingleClickDonateNum + 1
      if self.curSingleClickDonateNum >= self.triggerBubbleTipsNum then
        self.compBubbleTipsContent:SetActive(true)
        self.isShowBubbleTips = true
        self.isAlreadyShowBubbleTips = true
        self.bubbleTipsShowStartTime = UITimeManager:GetInstance():GetServerTime()
      end
    end
  end
  if self.isLongPress and self.isShowBubbleTips then
    self.isShowBubbleTips = false
    self.curSingleClickDonateNum = 0
    self.compBubbleTipsContent:SetActive(false)
  end
end

function UIS0AllianceBossBuildView:ShowUIEffect()
  if self.donateMulti and self.donateMulti > 1 then
    self:ShowHit()
  end
  local iconPath = DataCenter.ItemTemplateManager:GetAllianceItemIconPath(RewardType.ALLIANCE_DONATE)
  if self.flyFromPos == nil or self.flyToPos == nil then
    self.flyFromPos = self.btnDonate.transform.position
    self.flyToPos = self.imgIconReward.transform.position
    if self.compAlliancePointResourceCell then
      self.flyToPos = self.compAlliancePointResourceCell:GetResourcePos()
    end
  end
  UIUtil.DoFly(RewardType.GOODS, 3, iconPath, self.flyFromPos, self.flyToPos, nil, nil, nil, nil, nil, nil, nil, isOnlyDisperse)
end

function UIS0AllianceBossBuildView:ShowHit()
  CheckPressInterval(self)
  local item = self.hitItem:GameObjectSpawn(self.compHit.transform)
  local hit = self.compHit:GetComponent(item.name, AlScienceHitRatio)
  if hit == nil then
    item.name = "item_hit" .. self.hitItemCount
    self.hitItemCount = self.hitItemCount + 1
    hit = self.compHit:AddComponent(AlScienceHitRatio, item)
  end
  hit:Show(self.donateMulti, self.compHit)
end

function UIS0AllianceBossBuildView:Update1000MS()
  if self.isShowBubbleTips then
    local curTs = UITimeManager:GetInstance():GetServerTime()
    local tempTime = curTs - self.bubbleTipsShowStartTime
    if tempTime >= self.bubbleTipsShowTime then
      self.compBubbleTipsContent:SetActive(false)
      self.isShowBubbleTips = false
    end
  end
end

function UIS0AllianceBossBuildView:OnBtnEmptyClick()
  self:OnBtnCloseClick()
end

function UIS0AllianceBossBuildView:OnBtnCloseClick()
  if self.ctrl then
    self.ctrl:CloseSelf()
  end
end

function UIS0AllianceBossBuildView:OnBtnInfoClick()
  local context = Localization:GetString("s0_alliance_boss_damage_bonus_lv0")
  UIUtil.ShowBubbleTipsAuto(context, self.btnInfo.transform.position, 0, 30, 25, nil, nil, {reversal = true})
end

function UIS0AllianceBossBuildView:OnBtnRecordClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIS0AllianceBossBuildRecord)
end

function UIS0AllianceBossBuildView:OnBtnBubbleTipsClick()
  self.compBubbleTipsContent:SetActive(false)
end

return UIS0AllianceBossBuildView
