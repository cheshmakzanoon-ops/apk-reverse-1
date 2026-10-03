local UIGiftBox = BaseClass("UIGiftBox", UIBaseView)
local base = UIBaseView
local GiftBoxCell = require("UI.UIActivityCenterTable.Component.GiftBox.GiftBoxCell")
local GiftBoxScoreDetailItem = require("UI.UIActivityCenterTable.Component.GiftBox.GiftBoxScoreDetailItem")
local UITopItem = require("UI.UIActivityCenterTable.Component.UILuckyRoll.UITopItem")
local Localization = CS.GameEntry.Localization

function UIGiftBox:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIGiftBox:OnDestroy()
  DataCenter.ActGiftBoxData:ClearNewGift()
  self:DeleteTimer()
  self:DeleteBossTimer()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIGiftBox:OnEnable()
  self._animator:SetActive(false)
  base.OnEnable(self)
end

function UIGiftBox:OnDisable()
  base.OnDisable(self)
  DataCenter.ActGiftBoxData:ClearNewGift()
  if self.delayTime then
    self.delayTime:Stop()
    self.delayTime = nil
  end
end

function UIGiftBox:ComponentDefine()
  self._animator = self:AddComponent(UIAnimator, "Root/Eff_ui_kongtou_xiangzi")
  self._animator:SetActive(false)
  self._actName_txt = self:AddComponent(UIText, "Root/NameText")
  self._tips_txt = self:AddComponent(UIText, "Root/TipsText")
  self._tips_txt:SetLocalText(2800038)
  self._tips_txt2 = self:AddComponent(UIText, "Root/TipsText2")
  self._score_txt = self:AddComponent(UIText, "Root/ScoreText")
  self._bg_img = self:AddComponent(UIImage, "Root/BG")
  self._bg_img_helper = self:AddComponent(UIImage, "Root/BGScalerHelper")
  local scale = self._bg_img_helper.rectTransform.rect.height / 1082
  self._bg_img.transform:Set_localScale(scale, scale, scale)
  self._time_txt = self:AddComponent(UIText, "Root/RemainTimeContent/RemainTimeText")
  self._actTime_txt = self:AddComponent(UIText, "Root/ActivityTimeText")
  self.intro_btn = self:AddComponent(UIButton, "Root/InfoBtn")
  self.intro_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnIntroClick()
  end)
  self.score_info_btn = self:AddComponent(UIButton, "Root/ScoreText/ScoreInfoBtn")
  self.score_info_btn:SetOnClick(function()
    self:ShowTip()
  end)
  self.tipContent = self:AddComponent(UIBaseContainer, "Root/ScoreText/ScoreInfoBtn/TipBg")
  self.tipContent:SetActive(false)
  self.tipContentText = self:AddComponent(UIText, "Root/ScoreText/ScoreInfoBtn/TipBg/TipText")
  self.tipBgBtn = self:AddComponent(UIButton, "Root/TipBgBtn")
  self.tipBgBtn:SetOnClick(function()
    self:HideTip()
  end)
  self:HideTip()
  self._preview_btn = self:AddComponent(UIButton, "Root/RewardBtn")
  self._preview_txt = self:AddComponent(UIText, "Root/RewardBtn/RewardBtnText")
  self._preview_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnRewardListClick()
  end)
  self._key_rect = self:AddComponent(UIBaseContainer, "Root/RemainKeyContent/Key/KeyImg")
  self._key_img = self:AddComponent(UIImage, "Root/RemainKeyContent/Key/KeyImg")
  self._keyNum_txt = self:AddComponent(UIText, "Root/RemainKeyContent/Key/RemainKeyText")
  self._keyAdd_btn_txt = self:AddComponent(UIText, "Root/GetKeyBtn/GetKeyBtnText")
  self._keyAdd_btn_txt:SetLocalText(2800051)
  self._remain_key_tip_txt = self:AddComponent(UIText, "Root/RemainKeyContent/RemainKeyTipText")
  self._remain_key_tip_txt:SetLocalText(2800052)
  self._keyAdd_btn = self:AddComponent(UIButton, "Root/GetKeyBtn")
  self._keyAdd_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickAddKeyBtn()
  end)
  self._key_red_dot_rect = self:AddComponent(UIBaseContainer, "Root/GetKeyBtn/KeyRedPoint")
  self.toggle = self:AddComponent(UIToggle, "Root/ToggleText/SkipToggle")
  self.toggle:SetOnValueChanged(function(tf)
    self:ToggleControlBorS(tf)
  end)
  self._jumpAnim_txt = self:AddComponent(UIText, "Root/ToggleText")
  self.diamondBar = self:AddComponent(UITopItem, "Root/TopBar/DiamondBar")
  
  local function gotoDiamond()
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWBuyDiamond, {anim = true}, WelfareTagType.DiamondShop)
  end
  
  self.diamondBar:SetData(nil, ResourceType.Gold, gotoDiamond)
  self.curGiftBox = self:AddComponent(UIImage, "Root/BG1/BGContent/xiangzi/BG1 (2)")
  self._one_btn = self:AddComponent(UIButton, "Root/BottomBar/SingleCostBuyBtn")
  self._freeRed_img = self:AddComponent(UIBaseContainer, "Root/BottomBar/SingleCostBuyBtn/FreeBuyGo")
  self._btnOne_txt = self:AddComponent(UIText, "Root/BottomBar/SingleCostBuyBtn/SingleCostBtnText")
  self._costOne_txt = self:AddComponent(UIText, "Root/BottomBar/SingleCostBuyBtn/SinglePriceBtnText")
  self._costOne_img = self:AddComponent(UIImage, "Root/BottomBar/SingleCostBuyBtn/SingleImg")
  self._costOneFree_txt = self:AddComponent(UIText, "Root/BottomBar/SingleCostBuyBtn/FreeBuyGo/FreeBtnText")
  self._one_btn:SetOnClick(function()
    self:OnClickOne(0)
  end)
  self._five_btn = self:AddComponent(UIButton, "Root/BottomBar/CostBuyBtn")
  self._btnFive_txt = self:AddComponent(UIText, "Root/BottomBar/CostBuyBtn/CostBtnText")
  self._costFive_txt = self:AddComponent(UIText, "Root/BottomBar/CostBuyBtn/PriceBtnText")
  self._costFive_img = self:AddComponent(UIImage, "Root/BottomBar/CostBuyBtn/Img")
  self._five_btn:SetOnClick(function()
    self:OnClickOne(1)
  end)
  self._box_rect = self:AddComponent(UIBaseContainer, "Root/Content")
  self._box_red_dot_rect = self:AddComponent(UIBaseContainer, "Root/ScoreBtn/RedPoint")
  self._rank_btn = self:AddComponent(UIButton, "Root/RankBtn")
  self._rank_txt = self:AddComponent(UIText, "Root/RankBtn/RankBtnText")
  self._rank_txt:SetLocalText(390040)
  self._rank_btn:SetOnClick(function()
    self:OnClickRank()
  end)
  self._score_detail_item = self:AddComponent(GiftBoxScoreDetailItem, "Root/ScoreDetailContent")
  self._score_detail_item:SetActive(false)
  self._score_btn = self:AddComponent(UIButton, "Root/ScoreBtn")
  self._score_btn_txt = self:AddComponent(UIText, "Root/ScoreBtn/ScoreBtnText")
  self._score_btn:SetOnClick(function()
    self:OnClickScore()
  end)
end

function UIGiftBox:DataDefine()
  self.timer = nil
  
  function self.timer_action(temp)
    self:RefreshTime(temp)
  end
  
  function self.timer_actionBoss(temp)
    self:RefreshBossTime(temp)
  end
  
  if self.passDayTimer then
    self.passDayTimer:Stop()
    self.passDayTimer = nil
  end
  self.keyID = nil
  self.isFree = 0
  self.needGoldOne = 0
  self.needGoldFive = 0
end

function UIGiftBox:DataDestroy()
  if self.delayTime then
    self.delayTime:Stop()
    self.delayTime = nil
  end
  if self.passDayTimer then
    self.passDayTimer:Stop()
    self.passDayTimer = nil
  end
  self:SetAllCellDestroy()
end

function UIGiftBox:OnFreeRewardReceive()
  self:ShowKey()
  self:RefreshKey()
  self:RefreshRedPoint()
end

function UIGiftBox:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActGiftBoxLottery, self.BoxAnim)
  self:AddUIListener(EventId.ActGiftBoxGetInfo, self.OnRefresh)
  self:AddUIListener(EventId.ActGiftBoxOpen, self.ActGiftBoxChangeHandle)
  self:AddUIListener(EventId.ActGiftBoxDel, self.ActGiftBoxChangeHandle)
  self:AddUIListener(EventId.UpdateGold, self.ShowNeedRes)
  self:AddUIListener(EventId.PaySuccess, self.RefreshKey)
  self:AddUIListener(EventId.OnRewardGetPanelClose, self.RewardPanelClose)
  self:AddUIListener(EventId.UseItemSuccess, self.ShowKey)
  self:AddUIListener(EventId.BuyItemAndRes, self.ShowKey)
  self:AddUIListener(EventId.ActGiftFreeRewardReceive, self.OnFreeRewardReceive)
  self:AddUIListener(EventId.ActGiftBoxScoreUpdate, self.OnRefreshScore)
  self:AddUIListener(EventId.ActGiftBoxCloseScoreDetail, self.OnCloseScoreDetail)
  self:AddUIListener(EventId.ActGiftBoxScoreRewardReceive, self.RefreshRedPoint)
end

function UIGiftBox:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ActGiftBoxLottery, self.BoxAnim)
  self:RemoveUIListener(EventId.ActGiftBoxGetInfo, self.OnRefresh)
  self:RemoveUIListener(EventId.ActGiftBoxOpen, self.ActGiftBoxChangeHandle)
  self:RemoveUIListener(EventId.ActGiftBoxDel, self.ActGiftBoxChangeHandle)
  self:RemoveUIListener(EventId.UpdateGold, self.ShowNeedRes)
  self:RemoveUIListener(EventId.PaySuccess, self.RefreshKey)
  self:RemoveUIListener(EventId.OnRewardGetPanelClose, self.RewardPanelClose)
  self:RemoveUIListener(EventId.UseItemSuccess, self.ShowKey)
  self:RemoveUIListener(EventId.BuyItemAndRes, self.ShowKey)
  self:RemoveUIListener(EventId.ActGiftFreeRewardReceive, self.OnFreeRewardReceive)
  self:RemoveUIListener(EventId.ActGiftBoxScoreUpdate, self.OnRefreshScore)
  self:RemoveUIListener(EventId.ActGiftBoxCloseScoreDetail, self.OnCloseScoreDetail)
  self:RemoveUIListener(EventId.ActGiftBoxScoreRewardReceive, self.RefreshRedPoint)
end

local function StartPassDayTimer(self)
  if self.passDayTimer then
    self.passDayTimer:Stop()
  end
  local remainTimeS = UITimeManager:GetInstance():GetResSecondsTo24()
  local delayS = remainTimeS + 1
  self.passDayTimer = TimerManager:GetInstance():DelayInvoke(function()
    if self.gameObject == nil then
      return
    end
    self:OnPassDay()
  end, delayS)
end

function UIGiftBox:SetData(activityId)
  DataCenter.ActivityListDataManager:SetActivityVisitedEndTime(activityId)
  self.activityId = activityId
  SFSNetwork.SendMessage(MsgDefines.GetActivityGiftBoxInfo, activityId)
  self:SetConstTxt()
  self.curGiftBox:SetActive(false)
  StartPassDayTimer(self)
end

function UIGiftBox:OnRefresh()
  self.actData = DataCenter.ActGiftBoxData:GetInfoByActId(tonumber(self.activityId))
  self.animState = false
  local state = Setting:GetBool(SettingKeys.ACT_GIFT_BOX_JUMP_ANIM .. LuaEntry.Player.uid, false)
  self.toggle:SetIsOn(state)
  local actListData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if actListData then
    self.actListData = actListData
    self:RefreshTime(actListData)
    self:AddTimer(actListData)
    self:RefreshTitle(actListData)
    self:ShowKey()
    self:ShowScore()
    self:RefreshBottom()
    self:RefreshGiftBox()
    self:RefreshRedPoint()
  end
  self:ShowNeedRes()
end

function UIGiftBox:OnRefreshScore()
  self:ShowScore()
end

function UIGiftBox:ToggleControlBorS(isJumpPlay)
  if isJumpPlay then
    PostEventLog.Track(PostEventLog.Defines.OpenGiftBoxJumpAnimToggle, {})
  end
  Setting:SetBool(SettingKeys.ACT_GIFT_BOX_JUMP_ANIM .. LuaEntry.Player.uid, isJumpPlay)
end

function UIGiftBox:AddTimer(actListData)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, actListData, false, false, false)
  end
  self.timer:Start()
end

function UIGiftBox:RefreshTime(actListData)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime > actListData.endTime and not self.actEnd then
    self:DeleteTimer()
    self.actEnd = true
    UIUtil.ShowMessage(Localization:GetString("370100"), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      EventManager:GetInstance():Broadcast(EventId.ActGiftBoxTimeEnd)
    end, nil, function()
      EventManager:GetInstance():Broadcast(EventId.ActGiftBoxTimeEnd)
    end)
  else
    if actListData:CheckIfIsToEnd() then
      self._time_txt:SetColorRGBA(0.91, 0.26, 0.26, 1)
    else
      self._time_txt:SetColor(WhiteColor)
    end
    self._time_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(actListData.endTime - curTime))
    self.actEnd = false
  end
end

function UIGiftBox:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function UIGiftBox:SetConstTxt()
  self._preview_txt:SetLocalText(302181)
  self._jumpAnim_txt:SetLocalText(372228)
  local template = DataCenter.ActGiftBoxData:GetActTemplateByActId(tonumber(self.activityId))
  self.tipContentText:SetLocalText(2800082, template.add_score, template.consume_item_score)
end

function UIGiftBox:RefreshTitle(actListData)
  self._actName_txt:SetLocalText(actListData.name)
  local startT = UITimeManager:GetInstance():TimeStampToDayForLocal(actListData.startTime)
  local endT = UITimeManager:GetInstance():TimeStampToDayForLocal(actListData.endTime)
  self._actTime_txt:SetText(startT .. "-" .. endT)
end

function UIGiftBox:ShowNeedRes()
  if self.diamondBar then
    self.diamondBar:RefreshData()
  end
  self:ShowKey()
end

function UIGiftBox:RefreshKey()
  for i = 1, self.boxNum do
    self.boxList[i]:ReInit(self.actData.giftBoxs[i], tonumber(self.activityId), self.keyID, i)
  end
end

function UIGiftBox:ShowKey()
  self.keyID = DataCenter.ActGiftBoxData:GetActKeyById(tonumber(self.activityId))
  if self.keyID then
    local count = DataCenter.ItemData:GetItemCount(self.keyID)
    local goods = DataCenter.ItemTemplateManager:GetItemTemplate(self.keyID)
    self._keyNum_txt:SetText(count)
    self._key_img:LoadSprite(string.format(LoadPath.ItemPath, goods.icon))
  end
end

function UIGiftBox:ShowScore()
  local score = DataCenter.ActGiftBoxData:GetActScoreById(tonumber(self.activityId))
  local nextTargetScore = DataCenter.ActGiftBoxData:GetActNextTargetScoreById(tonumber(self.activityId))
  if score then
    self._score_txt:SetLocalText(2800049, score)
    if nextTargetScore then
      self._score_btn_txt:SetText(score .. "/" .. nextTargetScore)
    else
      self._score_btn_txt:SetText(score)
    end
    self._score_detail_item:ReInit(self.activityId)
  end
end

function UIGiftBox:RefreshBottom()
  local template = DataCenter.ActGiftBoxData:GetActTemplateByActId(tonumber(self.activityId))
  self:RefreshCostOne(template)
  self:RefreshCostFive(template)
  local curNum = DataCenter.ActGiftBoxData:GetActCurAllNum(tonumber(self.activityId))
  self._tips_txt2:SetLocalText(2800039, template.draw_max_daily - curNum)
end

function UIGiftBox:RefreshCostOne(template)
  self.isFree = 0
  self._btnOne_txt:SetLocalText(2800080)
  if template then
    if self.actData.useFreeTimes < template.cost_1_free then
      self._costOne_txt:SetActive(false)
      self._costOneFree_txt:SetActive(true)
      self._freeRed_img:SetActive(true)
      self._costOneFree_txt:SetLocalText(110134, template.cost_1_free - self.actData.useFreeTimes)
      self.isFree = 1
    else
      self._costOne_txt:SetActive(true)
      self._costOneFree_txt:SetActive(false)
      self._freeRed_img:SetActive(false)
      self._costOne_txt:SetText(template.cost_1)
      self.needGoldOne = template.cost_1
    end
  end
end

function UIGiftBox:RefreshCostFive(template)
  if template then
    self._costFive_txt:SetText(template.cost_5)
    self.needGoldFive = template.cost_5
    self._btnFive_txt:SetLocalText(2800081)
  end
end

function UIGiftBox:ActGiftBoxChangeHandle()
  self.actData = DataCenter.ActGiftBoxData:GetInfoByActId(tonumber(self.activityId))
  self:ShowKey()
  for i = 1, self.boxNum do
    self.boxList[i]:ReInit(self.actData.giftBoxs[i], tonumber(self.activityId), self.keyID, i)
  end
end

function UIGiftBox:RefreshBossTime(actListData)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime > actListData.refreshTime then
    self:DeleteBossTimer()
    self._timeBoss_txt:SetActive(false)
    self._bossPos_txt:SetActive(false)
    self._desc1_txt:SetActive(true)
  else
    self._desc1_txt:SetActive(false)
    self._timeBoss_txt:SetActive(true)
    self._timeBoss_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(actListData.refreshTime - curTime))
  end
end

function UIGiftBox:DeleteBossTimer()
  if self.timerBoss ~= nil then
    self.timerBoss:Stop()
    self.timerBoss = nil
  end
end

function UIGiftBox:RefreshGiftBox()
  self:SetAllCellDestroy()
  self.model = {}
  self.boxList = {}
  self.boxNum = DataCenter.ActGiftBoxData:GetActMaxBoxById(tonumber(self.activityId))
  if self.boxNum > 0 then
    for i = 1, self.boxNum do
      self.model[i] = self:GameObjectInstantiateAsync(UIAssets.GiftBoxCell, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self._box_rect.transform)
        go.transform:Set_localScale(1, 1, 1)
        go.name = "giftBox" .. i
        local cell = self._box_rect:AddComponent(GiftBoxCell, go.name)
        cell:ReInit(self.actData.giftBoxs[i], tonumber(self.activityId), self.keyID, i)
        self.boxList[i] = cell
      end)
    end
  end
end

function UIGiftBox:SetAllCellDestroy()
  self._box_rect:RemoveComponents(GiftBoxCell)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
end

function UIGiftBox:OnClickOne(type)
  if self.animState then
    return
  end
  if self.isFree == 0 or type == 1 then
    local template = DataCenter.ActGiftBoxData:GetActTemplateByActId(tonumber(self.activityId))
    if template then
      local curNum = DataCenter.ActGiftBoxData:GetActCurAllNum(tonumber(self.activityId))
      local addCountThisTime = type == 0 and 1 or 5
      if curNum and (curNum >= template.draw_max_daily or curNum + addCountThisTime > template.draw_max_daily) then
        return UIUtil.ShowTipsId(372304)
      end
    end
  end
  local gold = LuaEntry.Player.gold
  if self.isFree == 0 and type == 0 and gold < self.needGoldOne then
    GoToUtil.GotoPayTips(self.needGoldOne)
    return
  end
  if type == 1 and gold < self.needGoldFive then
    GoToUtil.GotoPayTips(self.needGoldFive)
    return
  end
  local isFree = 0
  if type == 0 then
    isFree = self.isFree
  end
  if self.actData and table.count(self.actData.giftBoxs) >= self.boxNum then
    local needShow = DataCenter.SecondConfirmManager:GetTodayCanShowSecondConfirm(TodayNoSecondConfirmType.GiftBoxTip)
    if needShow then
      UIUtil.ShowSecondMessage("", Localization:GetString("2800078"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        self.animState = true
        SFSNetwork.SendMessage(MsgDefines.ActivityGiftBoxLottery, toInt(self.activityId), type, isFree)
      end, function(needSellConfirm)
        DataCenter.SecondConfirmManager:SetTodayNoShowSecondConfirm(TodayNoSecondConfirmType.GiftBoxTip, needSellConfirm)
      end, nil, function()
      end, nil, Localization:GetString(GameDialogDefine.TODAY_NO_SHOW), nil, nil, nil)
      return
    end
  end
  self.animState = true
  SFSNetwork.SendMessage(MsgDefines.ActivityGiftBoxLottery, toInt(self.activityId), type, isFree)
end

function UIGiftBox:BoxAnim()
  self.actData = DataCenter.ActGiftBoxData:GetInfoByActId(tonumber(self.activityId))
  self:ShowKey()
  self:RefreshBottom()
  local state = Setting:GetBool(SettingKeys.ACT_GIFT_BOX_JUMP_ANIM .. LuaEntry.Player.uid, false)
  if state then
    local rewardList = DataCenter.ActGiftBoxData:GetLottery()
    DataCenter.ActGiftBoxData:ClearLottery()
    rewardList.reward = {}
    DataCenter.RewardManager:ShowCommonReward(rewardList, nil, nil, nil, nil, true)
    DataCenter.ActGiftBoxData:ClearNewGift()
    for i = 1, self.boxNum do
      if self.boxList[i] ~= nil and self.actData.giftBoxs[i] ~= nil then
        self.boxList[i]:ReInit(self.actData.giftBoxs[i], tonumber(self.activityId), self.keyID, i, true)
      end
    end
    self.animState = false
  else
    local gift = DataCenter.ActGiftBoxData:GetIsNewGift()
    if gift and next(gift) then
      local highestQualityGift = DataCenter.ActGiftBoxData:GetActBoxInfoByItemId(gift[1])
      table.walk(gift, function(k, v)
        local temp = DataCenter.ActGiftBoxData:GetActBoxInfoByItemId(v)
        if highestQualityGift.quality < temp.quality then
          highestQualityGift = temp
        end
      end)
      self.curGiftBox:LoadSprite(string.format(LoadPath.UImystery, highestQualityGift.reward_icon))
    else
      self.curGiftBox:LoadSprite(string.format(LoadPath.UImystery, "zyf_kongtouzhaohuan_xiangzi4"))
    end
    self.animState = true
    self._animator:SetActive(true)
    self._animator:Play("Eff_ui_binfenlihe_kaixiang", 0, 0)
    self.curGiftBox:SetActive(true)
    local rewardList = DataCenter.ActGiftBoxData:GetLottery()
    DataCenter.ActGiftBoxData:ClearLottery()
    rewardList.reward = {}
    self.delayTime = TimerManager:GetInstance():DelayInvoke(function()
      if self.gameObject == nil then
        return
      end
      self.animState = false
      DataCenter.RewardManager:ShowCommonReward(rewardList, nil, nil, nil, nil, true)
      if self.delayTime then
        self.delayTime:Stop()
        self.delayTime = nil
      end
    end, 2.8)
  end
end

function UIGiftBox:RewardPanelClose()
  local gift = DataCenter.ActGiftBoxData:GetIsNewGift()
  DataCenter.ActGiftBoxData:ClearNewGift()
  if gift and next(gift) then
    local curMax = table.count(self.actData.giftBoxs) - table.count(gift)
    local giftEffect = {}
    for i = 1, table.count(gift) do
      local template = DataCenter.ActGiftBoxData:GetActBoxInfoByItemId(gift[i])
      local pic = string.format(LoadPath.UImystery, template.reward_icon)
      local curPos = self.curGiftBox.transform.position
      local emptyPosIndex = self:FindNextEmptyPosition()
      local flyPos = self.model[emptyPosIndex == nil and curMax + 1 or emptyPosIndex].gameObject.transform.position
      table.insert(giftEffect, curMax + 1)
      curMax = curMax + 1
      if 4 < curMax then
        curMax = 4
      end
      DataCenter.FlyController.DoFly(RewardType.ActGiftBox, 1, pic, curPos, flyPos, 100, 100, nil, nil, 0.8)
    end
    self.delayBoxTime = TimerManager:GetInstance():DelayInvoke(function()
      if self.gameObject == nil then
        return
      end
      for i = 1, self.boxNum do
        if not table.IsNullOrEmpty(self.boxList) then
          self.boxList[i]:ReInit(self.actData.giftBoxs[i], tonumber(self.activityId), self.keyID, i, true)
        end
      end
      if self.delayBoxTime then
        self.delayBoxTime:Stop()
        self.delayBoxTime = nil
      end
    end, 1)
  end
  local state = Setting:GetBool(SettingKeys.ACT_GIFT_BOX_JUMP_ANIM .. LuaEntry.Player.uid, false)
  if not state then
    self._animator:SetActive(false)
  end
  self.curGiftBox:SetActive(false)
  self:RefreshRedPoint()
end

function UIGiftBox:FindNextEmptyPosition()
  for i = 1, 4 do
    if self.actData.giftBoxs[i] and self.actData.giftBoxs[i].newBox == true then
      self.actData.giftBoxs[i].newBox = false
      return i
    end
  end
end

function UIGiftBox:OnIntroClick()
  UIUtil.ShowIntro(Localization:GetString("302027"), Localization:GetString("2800015"), Localization:GetString(self.actListData.story))
end

function UIGiftBox:OnRewardListClick()
  if self.activityId then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActGiftBoxReward, tonumber(self.activityId))
  end
end

function UIGiftBox:OnClickRank()
  if self.actData then
    local serverStr
    local template = DataCenter.ActGiftBoxData:GetActTemplateByActId(tonumber(self.activityId))
    local para1 = template.rank
    if para1 and para1 ~= "" then
      local stage = string.split(para1, "|")
      for i = 1, table.count(stage) do
        local str = string.split(stage[i], ",")
        if string.find(str[2], ";") and string.find(str[2], "-") then
          local strServer = string.split(str[2], ";")
          for k = 1, table.count(strServer) do
            local server = string.split(strServer[k], "-")
            if tonumber(server[1]) <= LuaEntry.Player:GetSelfServerId() and LuaEntry.Player:GetSelfServerId() <= tonumber(server[2]) then
              local subStr = string.gsub(str[2], ";", ",")
              serverStr = subStr
              break
            end
          end
        elseif string.find(str[2], "-") then
          local server = string.split(str[2], "-")
          if tonumber(server[1]) <= LuaEntry.Player:GetSelfServerId() and LuaEntry.Player:GetSelfServerId() <= tonumber(server[2]) then
            serverStr = str[2]
            break
          end
        elseif string.find(str[2], ";") then
          local server = string.split(str[2], ";")
          if tonumber(server[1]) == LuaEntry.Player:GetSelfServerId() or LuaEntry.Player:GetSelfServerId() == tonumber(server[2]) then
            serverStr = server[1] .. "," .. server[2]
            break
          end
        end
      end
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGiftBoxRank, toInt(self.activityId), serverStr)
  end
end

function UIGiftBox:OnClickScore()
  self._score_detail_item:SetActive(true)
end

function UIGiftBox:OnCloseScoreDetail()
  self._score_detail_item:SetActive(false)
end

function UIGiftBox:OnClickAddKeyBtn()
  local canGotoPackShop = DataCenter.ActGiftBoxData:CanGotoPackShop(tonumber(self.activityId))
  if canGotoPackShop then
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILuckyRollShop, {anim = true}, self.activityId, DataCenter.ActGiftBoxData:GetKeyGiftPackId(tonumber(self.activityId)), DataCenter.ActGiftBoxData:GetActKeyById(tonumber(self.activityId)))
  else
    UIUtil.ShowTipsId(320346)
  end
end

function UIGiftBox:RefreshRedPoint()
  self._box_red_dot_rect:SetActive(DataCenter.ActGiftBoxData:GetActBoxRed(tonumber(self.activityId)) > 0)
  self._key_red_dot_rect:SetActive(DataCenter.ActGiftBoxData:CanGetFreePack(tonumber(self.activityId)))
end

function UIGiftBox:OnPassDay()
  SFSNetwork.SendMessage(MsgDefines.GetActivityGiftBoxInfo, self.activityId)
end

function UIGiftBox:ShowTip()
  self.tipContent:SetActive(true)
  self.tipBgBtn:SetActive(true)
end

function UIGiftBox:HideTip()
  self.tipContent:SetActive(false)
  self.tipBgBtn:SetActive(false)
end

return UIGiftBox
