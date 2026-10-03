local AlScienceDonateInfo = BaseClass("AlScienceDonateInfo", UIBaseContainer)
local base = UIBaseContainer
local AlScienceHitRatio = require("UI.UIAlliance.UIAllianceScienceInfo.Component.AlScienceHitRatio")
local Localization = CS.GameEntry.Localization
local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
local bg_path = ""
local techPoint_slider_path = "Slider"
local techPoint_slider_text_path = techPoint_slider_path .. "/Num"
local techPoint_slider_tip_path = techPoint_slider_path .. "/SliderTip"
local techPoint_Info_path = "TechPointInfoGo"
local techPoint_Info_des_path = techPoint_Info_path .. "/root/DesText"
local techPoint_Info_btn_path = "TechPointBtn"
local techPoint_Info_closeBtn_path = techPoint_Info_path .. "/CloseTPBtn"
local r4_btn_go_path = "R4BtnGo"
local recommend_btn_path = r4_btn_go_path .. "/RecommendBtn"
local cancel_recommend_btn_path = r4_btn_go_path .. "/CancelRecommendBtn"
local btnGo_path = "BtnGo"
local goldNum_path = "BtnGo/GoldBtn/GoldNumText"
local goldBtn_path = btnGo_path .. "/GoldBtn"
local goldBtn_topText_path = goldBtn_path .. "/TopText"
local goldBtn_bottomText_path = goldBtn_path .. "/BottomText"
local resNum_path = "BtnGo/ResBtn/OriginalTimeLayOut/OriginalTimeText"
local cd_path = "BtnGo/ResBtn/OriginalTimeLayOut/cdText"
local resBtn_path = "BtnGo/ResBtn"
local resBtnRed_path = "BtnGo/ResBtn/red"
local resBtn_topText_path = resBtn_path .. "/TopText1"
local resBtn_bottomText_path = resBtn_path .. "/BottomText1"
local resBtn_bottomIcon_path = resBtn_bottomText_path .. "/BottomIcon1"
local upBtn_path = "BtnGo/UpgradeBtn"
local upBtn_topText_path = upBtn_path .. "/TopText2"
local upgrade_tip_text_path = "BtnGo/UpgradeBtn/UpgradeTipText"
local maxLevelGo_path = "MaxLevelGo"
local MaxLevelText_path = maxLevelGo_path .. "/MaxLevelText"
local gold_hit_path = "GoldHit"
local hit_path = "Hit"
local hitItem_path = "HitItem"
local donate_reward_path = "donateReward"
local donate_tip_txt_path = "donateReward/donate_tip_txt"
local donate_txt_path = "donateReward/donate_txt"
local exp_txt_path = "donateReward/exp_txt"
local donate_img_path = "donateReward/donate_img"
local bubble_tips_content_path = "BubbleTipsContent"
local bubble_tips_btn_path = "BubbleTipsContent/BubbleTipsBtn"
local bubble_tips_text_path = "BubbleTipsContent/BubbleTipsBtn/BubbleTipsText"
local triggerLongPressTime = 0.5
local longPressInterval = 0.15
local longPressMinInterval = 0.05
local longPressIntervalAccTime = 0.5

function AlScienceDonateInfo:OnCreate()
  base.OnCreate(self)
  self.bgImgN = self:AddComponent(UICanvasGroup, bg_path)
  self.techPoint_slider = self:AddComponent(UISlider, techPoint_slider_path)
  self.techPoint_slider_text = self:AddComponent(UIText, techPoint_slider_text_path)
  self.slider_tip_txt = self:AddComponent(UIText, techPoint_slider_tip_path)
  self.slider_tip_txt:SetLocalText(454104)
  self.techPoint_Info = self:AddComponent(UIBaseContainer, techPoint_Info_path)
  self.techPoint_Info:SetActive(false)
  self.techPoint_Info_des = self:AddComponent(UIText, techPoint_Info_des_path)
  self.techPoint_Info_des:SetLocalText(143503)
  self.techPoint_Info_btn = self:AddComponent(UIButton, techPoint_Info_btn_path)
  self.techPoint_Info_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnTechPointInfoBtnClick()
  end)
  self.techPoint_Info_closeBtn = self:AddComponent(UIButton, techPoint_Info_closeBtn_path)
  self.techPoint_Info_closeBtn:SetOnClick(function()
    self:OnTechPointInfoCloseBtnClick()
  end)
  self.r4_btn_go = self:AddComponent(UIBaseContainer, r4_btn_go_path)
  self.recommend_btn = self:AddComponent(UIButton, recommend_btn_path)
  self.recommend_btn:SetOnClick(function()
    if self.tabIndex == 3 and not SeasonUtil.IsInSeason() then
      UIUtil.ShowTipsId("season_tips147")
      return
    end
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnChanceRecommendStateClick(1)
  end)
  self.recommend_btn.btn_txt = self:AddComponent(UIText, recommend_btn_path .. "/recommend_text")
  self.recommend_btn.btn_txt:SetLocalText(454110)
  self.cancel_recommend_btn = self:AddComponent(UIButton, cancel_recommend_btn_path)
  self.cancel_recommend_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnChanceRecommendStateClick(0)
  end)
  self.cancel_recommend_btn_txt = self:AddComponent(UIText, cancel_recommend_btn_path .. "/cancel_recommend_text")
  self.cancel_recommend_btn_txt:SetLocalText(454111)
  self.btnGo = self:AddComponent(UIBaseContainer, btnGo_path)
  self.goldNum = self:AddComponent(UIText, goldNum_path)
  self.goldBtn = self:AddComponent(UIButton, goldBtn_path)
  self.goldBtn:SetOnClick(function()
    if self.tabIndex == 3 and not SeasonUtil.IsInSeason() then
      UIUtil.ShowTipsId("season_tips147")
      return
    end
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnGoldDonateClick()
  end)
  self.goldBtn_topText = self:AddComponent(UIText, goldBtn_topText_path)
  self.goldBtn_bottomText = self:AddComponent(UIText, goldBtn_bottomText_path)
  self.resNum = self:AddComponent(UIText, resNum_path)
  self.timeCd = self:AddComponent(UIText, cd_path)
  self.resBtn = self:AddComponent(UIEventTrigger, resBtn_path)
  self.resBtn:OnPointerDown(BindCallback(self, self.OnPointerDown))
  self.resBtn:OnPointerUp(BindCallback(self, self.OnPointerUp))
  self.resBtnRedN = self:AddComponent(UIBaseContainer, resBtnRed_path)
  self.resBtn_topText = self:AddComponent(UIText, resBtn_topText_path)
  self.resBtn_bottomText = self:AddComponent(UIText, resBtn_bottomText_path)
  self.resBtn_bottomIcon = self:AddComponent(UIImage, resBtn_bottomIcon_path)
  self.upBtn = self:AddComponent(UIButton, upBtn_path)
  self.upBtn:SetOnClick(function()
    if self.tabIndex == 3 and not SeasonUtil.IsInSeason() then
      UIUtil.ShowTipsId("season_tips147")
      return
    end
    if DataCenter.AllianceBaseDataManager:GetAllianceBaseData().autoScienceResearch then
      UIUtil.ShowTipsId("auto_science_tips1")
      return
    end
    local isR4orR5 = DataCenter.AllianceBaseDataManager:IsR4orR5()
    if isR4orR5 then
      DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
      self:OnUpClick()
    else
      UIUtil.ShowTipsId(393018)
    end
  end)
  self.upBtn_topText = self:AddComponent(UIText, upBtn_topText_path)
  self.upBtn_topText:SetLocalText(100094)
  self.upgrade_tip_text = self:AddComponent(UIText, upgrade_tip_text_path)
  self.upgrade_tip_text:SetLocalText(454112)
  self.maxLevelGo = self:AddComponent(UIBaseContainer, maxLevelGo_path)
  self.MaxLevelText = self:AddComponent(UIText, MaxLevelText_path)
  self.gold_hit = self:AddComponent(UIBaseContainer, gold_hit_path)
  self.hit = self:AddComponent(UIBaseContainer, hit_path)
  self.hitItem = self.transform:Find(hitItem_path).gameObject
  self.hitItem:GameObjectCreatePool()
  self.hitItemCount = 0
  self.isUpdateData = true
  self.autoUpdateNum = 0
  self.donate_reward = self:AddComponent(UIBaseContainer, donate_reward_path)
  self.donate_tip_txt = self:AddComponent(UIText, donate_tip_txt_path)
  self.donate_tip_txt:SetLocalText(454105)
  self.donate_txt = self:AddComponent(UIText, donate_txt_path)
  self.exp_txt = self:AddComponent(UIText, exp_txt_path)
  self.donate_img = self:AddComponent(UIButton, donate_img_path)
  self.donate_img:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnShowDonateTip()
  end)
  self.bubble_tips_content = self:AddComponent(UIBaseContainer, bubble_tips_content_path)
  self.bubble_tips_content:SetActive(false)
  self.bubble_tips_btn = self:AddComponent(UIButton, bubble_tips_btn_path)
  self.bubble_tips_btn:SetOnClick(function()
    self.bubble_tips_content:SetActive(false)
  end)
  self.bubble_tips_text = self:AddComponent(UITextMeshProUGUIEx, bubble_tips_text_path)
  local tipsKey = LuaEntry.DataConfig:TryGetStr("guild_plus_sep", "k15")
  self.bubble_tips_text:SetLocalText(tipsKey)
  self.lastTime = nil
  self.startPressTime = nil
  self.isLongPress = nil
  self.isClick = nil
  self.isUpgradeBtnGray = nil
  self.triggerBubbleTipsNum = LuaEntry.DataConfig:TryGetNum("guild_plus_sep", "k13")
  self.bubbleTipsShowTime = LuaEntry.DataConfig:TryGetNum("guild_plus_sep", "k14") * 1000
  self.curSingleClickDonateNum = 0
  self.bubbleTipsShowStartTime = 0
  self.isShowBubbleTips = false
  self.isAlreadyShowBubbleTips = false
end

function AlScienceDonateInfo:OnDestroy()
  self.techPoint_slider = nil
  self.techPoint_slider_text = nil
  self.techPoint_Info = nil
  self.techPoint_Info_des = nil
  self.techPoint_Info_btn = nil
  self.techPoint_Info_closeBtn = nil
  self.btnGo = nil
  self.goldNum = nil
  self.goldBtn = nil
  self.goldBtn_topText = nil
  self.goldBtn_bottomText = nil
  self.resNum = nil
  self.timeCd = nil
  self.resBtn = nil
  self.resBtn_topText = nil
  self.resBtn_bottomText = nil
  self.resBtn_bottomIcon = nil
  self.upBtn = nil
  self.upBtn_topText = nil
  self.maxLevelGo = nil
  self.MaxLevelText = nil
  self.gold_hit = nil
  self.hit = nil
  self.hitItem.gameObject:GameObjectRecycleAll()
  self.hitItem = nil
  self.hitItemCount = nil
  self.isUpdateData = nil
  self.autoUpdateNum = nil
  self.r4_btn_go = nil
  self.recommend_btn = nil
  self.recommend_btn_txt = nil
  self.cancel_recommend_btn_txt = nil
  self.cancel_recommend_btn = nil
  self.donate_reward = nil
  self.donate_tip_txt = nil
  self.donate_txt = nil
  self.exp_txt = nil
  self.donate_img = nil
  self.lastTime = nil
  self.startPressTime = nil
  self.isLongPress = nil
  self.isClick = nil
  self.isUpgradeBtnGray = nil
  self.triggerBubbleTipsNum = nil
  self.bubbleTipsShowTime = nil
  self.curSingleClickDonateNum = nil
  self.bubbleTipsShowStartTime = nil
  self.isShowBubbleTips = nil
  self.isAlreadyShowBubbleTips = nil
  self:ClearRecommendEffect()
  base.OnDestroy(self)
end

function AlScienceDonateInfo:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ShowAlScienceCriticalHitRatio, self.ShowHit)
  self:AddUIListener(EventId.OnAlScienceRecommendChange, self.OnUpdateRecommendId)
end

function AlScienceDonateInfo:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ShowAlScienceCriticalHitRatio, self.ShowHit)
  self:RemoveUIListener(EventId.OnAlScienceRecommendChange, self.OnUpdateRecommendId)
end

function AlScienceDonateInfo:RefreshData(data, tabIndex, showRecommendEffect)
  self.tabIndex = tabIndex
  self.scienceData = data
  if self.scienceData == nil then
    return
  end
  if tabIndex == nil or tabIndex == 0 then
    tabIndex = GetTableData(TableName.AlScienceTab, data.scienceId, "tab")
  end
  if self.scienceData.isLock then
    self.techPoint_slider:SetActive(false)
    local currentPro = self.scienceData.currentPro
    local needPro = self.scienceData.needPro
    if currentPro > needPro then
      currentPro = needPro
    end
    local pro = currentPro / needPro
    self.techPoint_slider:SetValue(math.min(1, pro))
    self.techPoint_slider_text:SetText(string.GetFormattedStr(currentPro) .. "/" .. string.GetFormattedStr(needPro))
    self.btnGo:SetActive(false)
    self.r4_btn_go:SetActive(false)
    self.techPoint_Info_btn:SetActive(true)
    self.maxLevelGo:SetActive(false)
    self.donate_reward:SetActive(false)
    return
  end
  if self.scienceData.maxLevel ~= self.scienceData.curLevel then
    self.bgImgN:SetAlpha(1)
    self.techPoint_slider:SetActive(true)
    self.btnGo:SetActive(true)
    self.techPoint_Info_btn:SetActive(true)
    self.maxLevelGo:SetActive(false)
    local currentPro = self.scienceData.currentPro
    local needPro = self.scienceData.needPro
    if currentPro > needPro then
      currentPro = needPro
    end
    local pro = currentPro / needPro
    self.techPoint_slider:SetValue(math.min(1, pro))
    self.techPoint_slider_text:SetText(string.GetFormattedStr(currentPro) .. "/" .. string.GetFormattedStr(needPro))
    self.goldNum:SetActive(pro < 1)
    self.goldNum:SetLocalText(454124)
    self.goldBtn:SetActive(pro < 1)
    self.goldBtn_topText:SetLocalText(390448)
    self.goldBtn_bottomText:SetText(self.scienceData.goldNum)
    self.resNum:SetActive(pro < 1)
    self.timeCd:SetActive(false)
    if pro < 1 then
      if self.scienceData.useNum == 0 then
        self.resBtnRedN:SetActive(false)
        self.isUpgradeBtnGray = true
        CS.UIGray.SetGray(self.resBtn.transform, true, false)
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local deltaTime = self.scienceData.timePoint + self.scienceData.refreshTimeBlock - curTime
        self.timeCd:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
        self.timeCd:SetActive(true)
        self.resNum:SetLocalText(454107)
      else
        self.isUpgradeBtnGray = false
        CS.UIGray.SetGray(self.resBtn.transform, false, true)
        self.resNum:SetLocalText(141114, self.scienceData.useNum .. "/" .. self.scienceData.maxNum)
        self.resBtnRedN:SetActive(self.scienceData.useNum >= self.scienceData.maxNum / 2)
      end
    end
    self.resBtn:SetActive(pro < 1)
    self.resBtn_topText:SetLocalText(390448)
    self.resBtn_bottomText:SetText(self.scienceData.resNum)
    self.resBtn_bottomIcon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(self.scienceData.res))
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local autoScienceResearch = DataCenter.AllianceBaseDataManager:GetAllianceBaseData().autoScienceResearch
    if curTime < self.scienceData.finishTime then
      self.upBtn:SetActive(false)
      self.upgrade_tip_text:SetActive(false)
      self.techPoint_slider:SetActive(false)
      self.techPoint_Info_btn:SetActive(false)
    else
      local showBtn = 1 <= pro
      self.upBtn:SetActive(showBtn)
      self.upgrade_tip_text:SetActive(showBtn)
      self.techPoint_slider:SetActive(true)
      self.techPoint_Info_btn:SetActive(true)
      if autoScienceResearch then
        CS.UIGray.SetGray(self.upBtn.transform, true, true)
      else
        CS.UIGray.SetGray(self.upBtn.transform, false, true)
      end
    end
    local isR4orR5 = DataCenter.AllianceBaseDataManager:IsR4orR5()
    self.r4_btn_go:SetActive(isR4orR5)
    if isR4orR5 then
      local isRecommend = self.scienceData.state == 1
      self.recommend_btn:SetActive(not isRecommend)
      self.cancel_recommend_btn:SetActive(isRecommend)
      if not autoScienceResearch then
        CS.UIGray.SetGray(self.upBtn.transform, false, true)
      end
    else
      CS.UIGray.SetGray(self.upBtn.transform, true, true)
    end
    if 1 <= pro then
      self.donate_reward:SetActive(false)
      self.recommend_btn:SetActive(false)
      self.cancel_recommend_btn:SetActive(false)
    else
      self.donate_reward:SetActive(true)
      local scienceData = self.view.ctrl:GetScienceDataById(self.scienceData.scienceId)
      self.donate_txt:SetText(scienceData.contribution)
      self.exp_txt:SetText(scienceData.expAdd)
    end
    if showRecommendEffect then
      self:ShowRecommendEffect()
    end
  else
    self.donate_reward:SetActive(false)
    self.techPoint_slider:SetActive(false)
    self.btnGo:SetActive(false)
    self.r4_btn_go:SetActive(false)
    self.techPoint_Info_btn:SetActive(false)
    self.maxLevelGo:SetActive(true)
    self.MaxLevelText:SetLocalText(GameDialogDefine.REACH_MAX_LEVEL)
  end
  self.isUpdateData = false
end

function AlScienceDonateInfo:OnEnable()
  base.OnEnable(self)
end

function AlScienceDonateInfo:OnDisable()
  base.OnDisable(self)
end

function AlScienceDonateInfo:OnTechPointInfoBtnClick()
  self.techPoint_Info:SetActive(true)
end

function AlScienceDonateInfo:OnTechPointInfoCloseBtnClick()
  self.techPoint_Info:SetActive(false)
end

function AlScienceDonateInfo:OnPointerDown()
  self.isClick = true
  self.lastTime = Time.time
end

function AlScienceDonateInfo:OnPointerUp()
  if self.isClick then
    self:OnResDonateClick()
  end
  self:BreakLongPress()
end

function AlScienceDonateInfo:Update100MS()
  self:CheckPressInterval()
end

local function CheckPressInterval(self)
  if self.lastTime == nil or self.isUpgradeBtnGray or self.scienceData and self.scienceData.currentPro >= self.scienceData.needPro then
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

function AlScienceDonateInfo:BreakLongPress()
  self.isLongPress = false
  self.lastTime = nil
  self.startPressTime = nil
end

function AlScienceDonateInfo:OnResDonateClick()
  if self.tabIndex == 3 and not SeasonUtil.IsInSeason() then
    UIUtil.ShowTipsId("season_tips147")
    self:BreakLongPress()
    return
  end
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  local canDonate = DataCenter.AllianceScienceDataManager:GetCanDonate()
  if not canDonate then
    UIUtil.ShowTipsId(120471)
    return
  end
  local btnPos = self.resBtn.transform.position
  local techPointPos = self.techPoint_Info_btn.transform.position
  local sendMsg = self.view.ctrl:OnResDonateClick(self.scienceData.scienceId, self.scienceData.res, self.scienceData.resNum, btnPos, techPointPos)
  if not sendMsg then
    self:BreakLongPress()
  end
  if self.isClick then
    if self.isUpgradeBtnGray then
      self.curSingleClickDonateNum = 0
    end
    if not self.isAlreadyShowBubbleTips and not self.isUpgradeBtnGray then
      self.curSingleClickDonateNum = self.curSingleClickDonateNum + 1
      if self.curSingleClickDonateNum >= self.triggerBubbleTipsNum then
        self.bubble_tips_content:SetActive(true)
        self.isShowBubbleTips = true
        self.isAlreadyShowBubbleTips = true
        self.bubbleTipsShowStartTime = UITimeManager:GetInstance():GetServerTime()
      end
    end
  end
  if self.isLongPress then
    self.curSingleClickDonateNum = 0
    if self.bubble_tips_content.activeSelf then
      self.bubble_tips_content:SetActive(false)
    end
  end
end

function AlScienceDonateInfo:OnGoldDonateClick()
  local btnPos = self.goldBtn.transform.position
  local techPointPos = self.techPoint_Info_btn.transform.position
  self.view.ctrl:OnGoldDonateClick(self.scienceData.scienceId, self.scienceData.goldNum, btnPos, techPointPos)
end

function AlScienceDonateInfo:ShowHit(data)
  self:CheckPressInterval()
  if data == nil or data.ratio <= 1 then
    return
  end
  local item
  if data.type == 1 then
    item = self.hitItem:GameObjectSpawn(self.gold_hit.transform)
  else
    item = self.hitItem:GameObjectSpawn(self.hit.transform)
  end
  local hit = self.hit:GetComponent(item.name, AlScienceHitRatio)
  if hit == nil then
    item.name = "item_hit" .. self.hitItemCount
    self.hitItemCount = self.hitItemCount + 1
    hit = self.hit:AddComponent(AlScienceHitRatio, item)
  end
  hit:Show(data.ratio, self.hit)
end

function AlScienceDonateInfo:OnUpClick()
  if not DataCenter.AllianceBaseDataManager:IsR4orR5() then
    UIUtil.ShowTipsId(143598)
    return
  end
  local scienceName = Localization:GetString(self.scienceData.name)
  local strTip = Localization:GetString("391089", scienceName)
  UIUtil.ShowMessage(strTip, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
    local consumeNum = self.scienceData.research_consume
    local effectNum = LuaEntry.Effect:GetGameEffect(EffectDefine.ALLIANCE_SCIENCE_RESEARCH_CONSUME)
    consumeNum = math.floor(consumeNum * (1 - effectNum / 100) + 0.5)
    local ownNum = DataCenter.AllianceStorageManager:GetResCountByRewardType(RewardType.SAPPHIRE)
    if consumeNum > ownNum then
      local strLack = Localization:GetString("391090")
      UIUtil.ShowMessage(strLack, 2, GameDialogDefine.CONFIRM, "110088", function()
      end, function()
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceCity, 2)
      end)
    else
      self.view.ctrl:OnResearchClick(self.scienceData.scienceId)
    end
  end, function()
  end)
end

function AlScienceDonateInfo:Update1000MS()
  if self.isShowBubbleTips then
    local tempTime = UITimeManager:GetInstance():GetServerTime() - self.bubbleTipsShowStartTime
    if tempTime >= self.bubbleTipsShowTime then
      self.bubble_tips_content:SetActive(false)
      self.isShowBubbleTips = false
    end
  end
  if self.isUpdateData then
    return
  end
  if self.scienceData ~= nil then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local deltaTime = self.scienceData.timePoint + self.scienceData.refreshTimeBlock - curTime
    local money = LuaEntry.Resource:GetCntByResType(self.scienceData.res)
    if self.scienceData.useNum == 0 then
      if self.scienceData.currentPro < self.scienceData.needPro then
        self.timeCd:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
      end
      if deltaTime < 0 and 0 < self.scienceData.maxNum then
        self.isUpdateData = true
        self.autoUpdateNum = self.autoUpdateNum + 1
        if self.autoUpdateNum < 3 then
          SFSNetwork.SendMessage(MsgDefines.AlScienceNumFresh, self.scienceData.scienceId)
        end
      end
    elseif 0 < self.scienceData.maxNum and self.scienceData.useNum < self.scienceData.maxNum and (curTime - self.scienceData.timePoint) / self.scienceData.refreshTimeBlock >= 1 then
      self.isUpdateData = true
      self.autoUpdateNum = self.autoUpdateNum + 1
      if self.autoUpdateNum < 3 then
        SFSNetwork.SendMessage(MsgDefines.AlScienceNumFresh, self.scienceData.scienceId)
      end
    end
    if money < self.scienceData.resNum then
      self.resBtn_bottomText:SetColor(Color.New(0.91, 0.26, 0.26, 1))
    else
      self.resBtn_bottomText:SetColor(WhiteColor)
    end
    local gold = LuaEntry.Player.gold
    if gold < self.scienceData.goldNum then
      self.goldBtn_bottomText:SetColor(Color.New(0.91, 0.26, 0.26, 1))
      CS.UIGray.SetGray(self.goldBtn.transform, true, false)
    else
      self.goldBtn_bottomText:SetColor(WhiteColor)
      CS.UIGray.SetGray(self.goldBtn.transform, false, true)
    end
  end
end

function AlScienceDonateInfo:OnUpdateRecommendId(scienceId)
  local showCancelComBtn = scienceId and self.scienceData.scienceId == scienceId
  self.recommend_btn:SetActive(not showCancelComBtn)
  self.cancel_recommend_btn:SetActive(showCancelComBtn)
end

function AlScienceDonateInfo:OnChanceRecommendStateClick(state)
  if self.scienceData.state ~= state then
    self.view.ctrl:ChanceRecommendState(self.scienceData.scienceId, 0 < state)
  end
end

function AlScienceDonateInfo:OnShowDonateTip()
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local position = self.donate_img.transform.position + Vector3.New(-20, 0, 0) * scaleFactor
  local strTitle
  local strContent = Localization:GetString("391084")
  local param = UIHeroTipView.Param.New()
  param.title = strTitle
  param.content = strContent
  param.dir = UIHeroTipView.Direction.LEFT
  param.defWidth = 240
  param.pivot = 0.5
  param.position = position
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

function AlScienceDonateInfo:ShowRecommendEffect()
  self:ClearRecommendEffect()
  self.delay = TimerManager:GetInstance():DelayInvoke(function()
    DataCenter.ArrowManager:RemoveArrow()
    local param = {}
    param.position = self.recommend_btn:GetPosition()
    param.arrowType = ArrowType.Building
    param.positionType = PositionType.Screen
    param.isPanel = false
    param.isAutoClose = 2
    if not DataCenter.GuideManager:InGuide() and param.position ~= nil then
      DataCenter.ArrowManager:ShowArrow(param)
    end
  end, 0.5)
end

function AlScienceDonateInfo:ClearRecommendEffect()
  if self.delay then
    self.delay:Stop()
    self.delay = nil
  end
end

AlScienceDonateInfo.CheckPressInterval = CheckPressInterval
return AlScienceDonateInfo
