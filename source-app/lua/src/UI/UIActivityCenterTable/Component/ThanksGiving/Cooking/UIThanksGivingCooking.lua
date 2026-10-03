local UIThanksGivingCooking = BaseClass("UIThanksGivingCooking", UIBaseView)
local base = UIBaseView
local CookingNeedItem = require("UI.UIActivityCenterTable.Component.ThanksGiving.Cooking.CookingNeedItem")
local CookingScoreDetail = require("UI.UIActivityCenterTable.Component.ThanksGiving.Cooking.CookingScoreDetail")
local UITopItem = require("UI.UIActivityCenterTable.Component.UILuckyRoll.UITopItem")
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray

function UIThanksGivingCooking:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIThanksGivingCooking:OnDestroy()
  self:DeleteTimer()
  self:ClearNeedItemScroll()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIThanksGivingCooking:OnEnable()
  base.OnEnable(self)
  self.cooking_slider:SetValue(0)
  self.cooking_content:SetActive(false)
  self.no_cooking_content:SetActive(true)
end

function UIThanksGivingCooking:OnDisable()
  base.OnDisable(self)
  if self.delayTime then
    self.delayTime:Stop()
    self.delayTime = nil
  end
  self:StopAnim()
end

function UIThanksGivingCooking:ComponentDefine()
  self._animator = self:AddComponent(UIAnimator, "")
  self._bg_img = self:AddComponent(UIImage, "Bg")
  self._bg_img_helper = self:AddComponent(UIImage, "BgScalerHelper")
  local scale = self._bg_img_helper.rectTransform.rect.height / 1114
  self._bg_img.transform:Set_localScale(scale, scale, scale)
  self._actName_txt = self:AddComponent(UIText, "RightView/Top/title")
  self._score_txt = self:AddComponent(UIText, "RightView/Top/ScoreText")
  self._time_txt = self:AddComponent(UIText, "RightView/Top/RemainTimeContent/RemainTimeText")
  self._actSubTitle_txt = self:AddComponent(UIText, "RightView/Top/subTitle")
  self._actSubTitle_txt:SetLocalText("thanksactivity_UI013")
  self.intro_btn = self:AddComponent(UIButton, "RightView/Top/InfoBtn")
  self.intro_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnIntroClick()
  end)
  self.toggle = self:AddComponent(UIToggle, "RightView/Rect_Bottom/ToggleText/SkipToggle")
  self.toggle:SetOnValueChanged(function(tf)
    self:ToggleControlBorS(tf)
  end)
  self._jumpAnim_txt = self:AddComponent(UIText, "RightView/Rect_Bottom/ToggleText")
  self.itemBar1 = self:AddComponent(UITopItem, "RightView/TopBar/ItemBar1")
  self.itemBar2 = self:AddComponent(UITopItem, "RightView/TopBar/ItemBar2")
  self.itemBar3 = self:AddComponent(UITopItem, "RightView/TopBar/ItemBar3")
  self._trade_btn = self:AddComponent(UIButton, "RightView/Top/TradeBtn")
  self._trade_btn_txt = self:AddComponent(UIText, "RightView/Top/TradeBtn/TradeBtnText")
  self._trade_btn_txt:SetLocalText("thanksactivity_UI057")
  self._trade_btn:SetOnClick(function()
    self:OnClickTrade()
  end)
  self._cook_btn = self:AddComponent(UIButton, "RightView/Rect_Bottom/NonCookingContent/CookBtn")
  self._cook_btn_txt = self:AddComponent(UIText, "RightView/Rect_Bottom/NonCookingContent/CookBtn/CookBtnText")
  self._cook_btn_txt:SetLocalText("thanksactivity_UI017")
  self._cook_btn:SetOnClick(function()
    self:OnClickCook()
  end)
  self._box_red_dot_rect = self:AddComponent(UIBaseContainer, "RightView/Top/ScoreBtn/RedPoint")
  self._free_reward_red_dot_rect = self:AddComponent(UIBaseContainer, "RightView/Top/TradeBtn/RedPoint (1)")
  self._cook_btn_red_dot_rect = self:AddComponent(UIBaseContainer, "RightView/Rect_Bottom/NonCookingContent/CookBtn/RedPoint (2)")
  self._score_detail_item = self:AddComponent(CookingScoreDetail, "RightView/ScoreDetailContent")
  self._score_detail_item:SetActive(false)
  self._score_btn = self:AddComponent(UIButton, "RightView/Top/ScoreBtn")
  self._score_btn_txt = self:AddComponent(UIText, "RightView/Top/ScoreBtn/ScoreBtnText")
  self._score_btn:SetOnClick(function()
    self:OnClickScore()
  end)
  self.inputGo = self:AddComponent(UIBaseContainer, "RightView/Rect_Bottom/NonCookingContent/InfoInput")
  self.inputSlider = self:AddComponent(UISlider, "RightView/Rect_Bottom/NonCookingContent/InfoInput/Slider")
  self.inputTxt = self:AddComponent(UIText, "RightView/Rect_Bottom/NonCookingContent/InfoInput/TextBg/CountText")
  self.inputAddBtn = self:AddComponent(UIButton, "RightView/Rect_Bottom/NonCookingContent/InfoInput/AddBtn")
  self.inputDecBtn = self:AddComponent(UIButton, "RightView/Rect_Bottom/NonCookingContent/InfoInput/DecBtn")
  self.inputSlider:SetOnValueChanged(function(value)
    self:OnInputSliderChanged(value)
  end)
  self.inputAddBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Common_ChangeNum, false)
    self:OnAddBtnClick()
  end)
  self.inputDecBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Common_ChangeNum, false)
    self:OnDecBtnClick()
  end)
  self.scroll_view = self:AddComponent(UIScrollView, "RightView/Rect_Bottom/NonCookingContent/ItemScrollView")
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.cooking_slider = self:AddComponent(UISlider, "RightView/Rect_Bottom/CookingContent/SliderAnim")
  self.cooking_tip_txt = self:AddComponent(UIText, "RightView/Rect_Bottom/CookingContent/CookingTips")
  self.cooking_tip_txt:SetLocalText("thanksactivity_UI020")
  self.cooking_content = self:AddComponent(UIBaseContainer, "RightView/Rect_Bottom/CookingContent")
  self.no_cooking_content = self:AddComponent(UIBaseContainer, "RightView/Rect_Bottom/NonCookingContent")
  self.top_effect = self:AddComponent(UIBaseContainer, "fengye")
  self.top_effect:SetActive(true)
end

function UIThanksGivingCooking:DataDefine()
  self.timer = nil
  
  function self.timer_action(temp)
    self:RefreshTime(temp)
  end
  
  if self.passDayTimer then
    self.passDayTimer:Stop()
    self.passDayTimer = nil
  end
  self.canSliderChange = true
end

function UIThanksGivingCooking:DataDestroy()
  if self.delayTime then
    self.delayTime:Stop()
    self.delayTime = nil
  end
  if self.passDayTimer then
    self.passDayTimer:Stop()
    self.passDayTimer = nil
  end
  self:SetAllCellDestroy()
  self.canSliderChange = nil
end

function UIThanksGivingCooking:OnFreeRewardReceive()
  self:RefreshNeedItems()
  self:RefreshRedPoint()
  self:ShowNeedRes()
end

function UIThanksGivingCooking:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateGold, self.ShowNeedRes)
  self:AddUIListener(EventId.PaySuccess, self.OnRefresh)
  self:AddUIListener(EventId.UseItemSuccess, self.OnRefresh)
  self:AddUIListener(EventId.BuyItemAndRes, self.OnRefresh)
  self:AddUIListener(EventId.GetActCookingDetailInfo, self.OnRefresh)
  self:AddUIListener(EventId.ActFreeRewardReceive, self.OnFreeRewardReceive)
  self:AddUIListener(EventId.ActCookingCloseScoreDetail, self.OnCloseScoreDetail)
  self:AddUIListener(EventId.ActCookingFinished, self.OnCookingFinished)
  self:AddUIListener(EventId.ActCookingScoreRewardReceive, self.OnRefreshScore)
end

function UIThanksGivingCooking:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.UpdateGold, self.ShowNeedRes)
  self:RemoveUIListener(EventId.PaySuccess, self.OnRefresh)
  self:RemoveUIListener(EventId.UseItemSuccess, self.OnRefresh)
  self:RemoveUIListener(EventId.BuyItemAndRes, self.OnRefresh)
  self:RemoveUIListener(EventId.GetActCookingDetailInfo, self.OnRefresh)
  self:RemoveUIListener(EventId.ActFreeRewardReceive, self.OnFreeRewardReceive)
  self:RemoveUIListener(EventId.ActCookingCloseScoreDetail, self.OnCloseScoreDetail)
  self:RemoveUIListener(EventId.ActCookingFinished, self.OnCookingFinished)
  self:RemoveUIListener(EventId.ActCookingScoreRewardReceive, self.OnRefreshScore)
end

local function StartPassDayTimer(self)
  if self.passDayTimer then
    self.passDayTimer:Stop()
  end
  local remainTimeS = UITimeManager:GetInstance():GetResSecondsTo24()
  local delayS = remainTimeS + 1
  self.passDayTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:OnPassDay()
  end, delayS)
end

function UIThanksGivingCooking:SetData(activityId)
  DataCenter.ActivityListDataManager:SetActivityVisitedEndTime(activityId)
  self.activityId = activityId
  self.actListData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  self.actCookingTemplate = DataCenter.ActivityMakeFoodTemplateManager:GetActCookingTemplate(self.actListData.subType)
  self.minItemCount = self.actCookingTemplate.canSelectMin
  self.maxItemCount = self.actCookingTemplate.canSelectMax
  self.curItemCount = self.actCookingTemplate.selectDefault
  self:SetTopItem()
  self:CheckNeedItemMeet()
  self:SetInputText(self.curItemCount)
  SFSNetwork.SendMessage(MsgDefines.ActivityMakeFoodInfo, tonumber(activityId))
  self:SetConstTxt()
  StartPassDayTimer(self)
  self._animator:Play("Eff_ui_ganenjie_huoji_idle", 0, 0)
end

function UIThanksGivingCooking:SetTopItem()
  local itemDic = self.actCookingTemplate.costItemDic
  local count = table.count(itemDic)
  for k, v in ipairs(itemDic) do
    if k <= 3 then
      local varName = "itemBar" .. k
      self[varName]:SetData(v.itemId)
    end
  end
  self.itemBar1:SetActive(0 < count)
  self.itemBar2:SetActive(1 < count)
  self.itemBar3:SetActive(2 < count)
end

function UIThanksGivingCooking:OnRefresh()
  self.cookingId = DataCenter.ActCookingData.actMakeFoodId
  self.animState = false
  local state = Setting:GetBool(SettingKeys.ACT_THANKS_GIVING_JUMP_ANIM .. LuaEntry.Player.uid, false)
  self.toggle:SetIsOn(state)
  if self.actListData then
    self:RefreshTime(self.actListData)
    self:AddTimer(self.actListData)
    self:RefreshTitle(self.actListData)
    self:OnRefreshScore()
    self:RefreshBottom()
    self:RefreshNeedItems()
    self:RefreshRedPoint()
    self:SetInputText(self.curItemCount)
  end
  self:ShowNeedRes()
end

function UIThanksGivingCooking:OnRefreshScore()
  self:ShowScore()
  self:RefreshRedPoint()
  self:ShowNeedRes()
end

function UIThanksGivingCooking:ToggleControlBorS(isJumpPlay)
  Setting:SetBool(SettingKeys.ACT_THANKS_GIVING_JUMP_ANIM .. LuaEntry.Player.uid, isJumpPlay)
end

function UIThanksGivingCooking:AddTimer(actListData)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, actListData, false, false, false)
  end
  self.timer:Start()
end

function UIThanksGivingCooking:RefreshTime(actListData)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime > actListData.endTime and not self.actEnd then
    self:DeleteTimer()
    self.actEnd = true
    UIUtil.ShowMessage(Localization:GetString("370100"), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      EventManager:GetInstance():Broadcast(EventId.ActThanksGivingTimeEnd)
    end, nil, function()
      EventManager:GetInstance():Broadcast(EventId.ActThanksGivingTimeEnd)
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

function UIThanksGivingCooking:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function UIThanksGivingCooking:SetConstTxt()
  self._jumpAnim_txt:SetLocalText(372228)
end

function UIThanksGivingCooking:RefreshTitle(actListData)
  self._actName_txt:SetLocalText(actListData.name)
end

function UIThanksGivingCooking:ShowNeedRes()
  self.itemBar1:RefreshData()
  self.itemBar2:RefreshData()
  self.itemBar3:RefreshData()
end

function UIThanksGivingCooking:ShowScore()
  local score = DataCenter.ActCookingData:GetActScore()
  local nextTargetScore = DataCenter.ActCookingData:GetActNextTargetScore()
  if score then
    self._score_txt:SetLocalText("thanksactivity_UI014", score)
    if nextTargetScore then
      self._score_btn_txt:SetText(score .. "/" .. nextTargetScore)
    else
      self._score_btn_txt:SetText(score)
    end
    self._score_detail_item:ReInit(self.activityId, score)
  end
end

function UIThanksGivingCooking:RefreshBottom()
end

function UIThanksGivingCooking:SetAllCellDestroy()
end

function UIThanksGivingCooking:CookingAnim(message)
  self:RefreshBottom()
  local state = Setting:GetBool(SettingKeys.ACT_THANKS_GIVING_JUMP_ANIM .. LuaEntry.Player.uid, false)
  if state then
    DataCenter.RewardManager:ShowCookingReward(message)
  else
    self.cooking_content:SetActive(true)
    self.no_cooking_content:SetActive(false)
    self.cooking_slider:SetValue(0)
    self._animator:Play("Eff_ui_ganenjie_huoji", 0, 0)
    self:StopAnim()
    self.sequence = CS.DG.Tweening.DOTween.Sequence()
    self.sequence:AppendInterval(2.9)
    self.sequence:Append(self.cooking_slider:DOValue(1, 2))
    self.sequence:AppendCallback(function()
    end)
    self.sequence:AppendInterval(0.5)
    self.sequence:AppendCallback(function()
      DataCenter.RewardManager:ShowCookingReward(message)
      self.cooking_content:SetActive(false)
      self.no_cooking_content:SetActive(true)
    end)
  end
end

function UIThanksGivingCooking:StopAnim()
  if self.sequence then
    self.sequence:Kill()
    self.sequence = nil
  end
end

function UIThanksGivingCooking:OnIntroClick()
  UIUtil.ShowIntro(Localization:GetString("302027"), Localization:GetString("2800015"), Localization:GetString(self.actListData.story))
end

function UIThanksGivingCooking:OnClickRank()
  if self.actData then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIThanksGivingCookingRank, toInt(self.activityId), serverStr)
  end
end

function UIThanksGivingCooking:OnClickScore()
  self._score_detail_item:SetActive(true)
end

function UIThanksGivingCooking:OnClickTrade()
  local canGotoPackShop = DataCenter.ActCookingData:CanGotoPackShop(tonumber(self.activityId))
  if canGotoPackShop then
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    local needItemStr = self.actListData.para_5
    if not string.IsNullOrEmpty(needItemStr) then
      local strs = string.split(needItemStr, "|")
      if 3 <= #strs then
        local itemIdList = {
          tonumber(strs[1]),
          tonumber(strs[2]),
          tonumber(strs[3])
        }
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILuckyRollShop, {anim = true}, self.activityId, DataCenter.ActCookingData:GetGiftPackId(), itemIdList)
      end
    end
  else
    UIUtil.ShowTipsId(320346)
  end
end

function UIThanksGivingCooking:OnClickCook()
  local canMakeMaxCount, lackItemId = self:CheckNeedItemMeet()
  if 0 < canMakeMaxCount and 0 < self.curItemCount then
    local param = {}
    param.activityId = self.activityId
    param.id = self.cookingId
    param.num = self.curItemCount
    SFSNetwork.SendMessage(MsgDefines.ActivityMakeFoodCooking, param)
  else
    if lackItemId then
      LWResourceLackUtil:GotoGoodsItemLack(lackItemId, 1)
    end
    UIUtil.ShowTips(Localization:GetString("thanksactivity_UI018"))
  end
end

function UIThanksGivingCooking:OnCloseScoreDetail()
  self._score_detail_item:SetActive(false)
end

function UIThanksGivingCooking:OnCookingFinished(message)
  self:CookingAnim(message)
  self:OnRefreshScore()
  self:RefreshNeedItems()
  self:ShowNeedRes()
  self.curItemCount = math.max(math.min(self.curItemCount, self.maxItemCount), self.minItemCount)
  self:SetInputText(self.curItemCount)
end

function UIThanksGivingCooking:RefreshRedPoint()
  self._box_red_dot_rect:SetActive(DataCenter.ActCookingData:GetCanGetScoreBoxCount() > 0)
  self._free_reward_red_dot_rect:SetActive(DataCenter.ActCookingData:CanGetFreePack())
  local canMakeMaxCount = self:CheckNeedItemMeet()
  self._cook_btn_red_dot_rect:SetActive(0 < canMakeMaxCount)
end

function UIThanksGivingCooking:OnPassDay()
  SFSNetwork.SendMessage(MsgDefines.ActivityMakeFoodInfo, self.activityId)
end

function UIThanksGivingCooking:ShowTip()
  self.tipContent:SetActive(true)
  self.tipBgBtn:SetActive(true)
end

function UIThanksGivingCooking:HideTip()
  self.tipContent:SetActive(false)
  self.tipBgBtn:SetActive(false)
end

function UIThanksGivingCooking:OnInputSliderChanged(value)
  if self.canSliderChange then
    local percent = math.floor(value * self.maxItemCount)
    percent = math.max(self.minItemCount, percent)
    percent = math.min(self.maxItemCount, percent)
    self:SetInputText(percent)
  end
end

function UIThanksGivingCooking:SetInputText(value)
  self.curItemCount = value
  self.inputTxt:SetText(value)
  self:RefreshNeedItems()
  self:SetAddAndDecBtnState()
end

function UIThanksGivingCooking:SetAddAndDecBtnState()
  local can_dec = self.curItemCount > self.minItemCount
  local can_add = self.curItemCount < self.maxItemCount
  if can_dec then
    UIGray.SetGray(self.inputDecBtn.transform, false, true)
  else
    UIGray.SetGray(self.inputDecBtn.transform, true, false)
  end
  if can_add then
    UIGray.SetGray(self.inputAddBtn.transform, false, true)
  else
    UIGray.SetGray(self.inputAddBtn.transform, true, false)
  end
  self.inputSlider:SetValue(self.curItemCount / self.maxItemCount)
end

function UIThanksGivingCooking:OnAddBtnClick()
  self.canSliderChange = false
  if self.curItemCount + 1 <= self.maxItemCount then
    self:SetInputText(self.curItemCount + 1)
  end
  self.canSliderChange = true
end

function UIThanksGivingCooking:OnDecBtnClick()
  self.canSliderChange = false
  if self.curItemCount > self.minItemCount then
    self:SetInputText(self.curItemCount - 1)
  end
  self.canSliderChange = true
end

function UIThanksGivingCooking:RefreshNeedItems()
  local itemDic = self.actCookingTemplate.costItemDic
  if itemDic and 0 < #itemDic then
    self.scroll_view:SetTotalCount(#itemDic)
    self.scroll_view:RefillCells()
    self.scroll_view:SetActive(true)
  else
    self.scroll_view:SetActive(false)
  end
end

function UIThanksGivingCooking:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scroll_view:AddComponent(CookingNeedItem, itemObj)
  local itemDic = self.actCookingTemplate.costItemDic
  local oneData = {
    itemId = itemDic[index].itemId,
    costNum = itemDic[index].costNum * self.curItemCount
  }
  cellItem:ReInit(oneData, self.activityId)
end

function UIThanksGivingCooking:OnItemMoveOut(itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, CookingNeedItem)
end

function UIThanksGivingCooking:CheckNeedItemMeet()
  local canMakeCount = self.actCookingTemplate.canSelectMax
  local lackItemId = 0
  local itemDic = self.actCookingTemplate.costItemDic
  for k, v in pairs(itemDic) do
    local itemId = v.itemId
    local costNum = v.costNum
    local haveCount = DataCenter.ItemData:GetItemCount(itemId)
    local canMakeItem = haveCount // costNum
    canMakeCount = math.min(canMakeCount, canMakeItem)
    if costNum > haveCount and lackItemId == 0 then
      lackItemId = itemId
    end
  end
  self.maxItemCount = math.max(math.min(canMakeCount, self.actCookingTemplate.canSelectMax), self.minItemCount)
  self.curItemCount = math.max(math.min(self.curItemCount, self.maxItemCount), self.minItemCount)
  return canMakeCount, lackItemId
end

function UIThanksGivingCooking:ClearNeedItemScroll()
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(CookingNeedItem)
end

return UIThanksGivingCooking
