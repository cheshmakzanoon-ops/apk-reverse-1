local UILuckyRoll = BaseClass("UILuckyRoll", UIBaseView)
local UILuckyRollItem = require("UI.UIActivityCenterTable.Component.UILuckyRoll.UILuckyRollItem")
local UILuckyRollBox = require("UI.UIActivityCenterTable.Component.UILuckyRoll.UILuckyRollBox")
local UITopItem = require("UI.UIActivityCenterTable.Component.UILuckyRoll.UITopItem")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local Screen = CS.UnityEngine.Screen
local LWUIActivityRewardChangePreviewEntranceComponent = require("UI/LWUIActivityRewardChangePreview/AccuRecharge/Component/LWUIActivityRewardChangePreviewEntranceComponent")

function UILuckyRoll:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.curChoicePos = 0
  self.choiceNum = 0
  self.isFree = 0
  self.needGoldOne = 0
  self.needGoldFive = 0
  self.timer = nil
  self.itemIndex = 0
  self.hasInitExtraBox = false
  self.rollItemCount = 12
  
  function self.timer_action(temp)
    self:RefreshTime(temp)
  end
  
  self.timer_anim = nil
  
  function self.timer_action_anim(temp)
    self:RefreshAnimTime(temp)
  end
  
  self.isEnd = true
end

function UILuckyRoll:OnClickGiftPack()
  if not (self.activityId and self.costId) or not self.actData then
    return
  end
  local canGotoPackShop = DataCenter.ActLuckyRollInfo:CanGotoPackShop(tonumber(self.activityId))
  if canGotoPackShop then
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILuckyRollShop, {anim = true}, self.activityId, self.actData.gfitPackGroupId, self.costId)
  else
    UIUtil.ShowTipsId(2000655)
  end
end

function UILuckyRoll:ComponentDefine()
  self.box_rectTab = {}
  for i = 1, 12 do
    local rectpath = "RightView/Rect_ShowReward/UICommonResItem" .. i
    self.box_rectTab[i] = self:AddComponent(UILuckyRollItem, rectpath)
  end
  self.boxAnim = self:AddComponent(UIAnimator, "RightView/Rect_ShowReward/Rect_deng_zhongjian_aim")
  self._actName_txt = self:AddComponent(UIText, "RightView/Txt_ActName")
  self._one_btn = self:AddComponent(UIButton, "RightView/layout/Btn_One")
  self._freeRed_img = self:AddComponent(UIButton, "RightView/layout/Btn_One/Img_FreeRed")
  self._btnOne_txt = self:AddComponent(UIText, "RightView/layout/Btn_One/Rect_BtnOne/Txt_BtnOne")
  self._costOne_txt = self:AddComponent(UIText, "RightView/layout/Btn_One/Rect_BtnOne/Txt_CostOne")
  self._btnOne_txt_shadow = self:AddComponent(UIShadow, "RightView/layout/Btn_One/Rect_BtnOne/Txt_BtnOne")
  self._costOne_txt_shadow = self:AddComponent(UIShadow, "RightView/layout/Btn_One/Rect_BtnOne/Txt_CostOne")
  self._costOne_img = self:AddComponent(UIImage, "RightView/layout/Btn_One/Rect_BtnOne/Txt_CostOne/Img_CostOne")
  self._one_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Lucky_Roll_Click, false)
    self:OnClickOne(0)
  end)
  self._notice_btn = self:AddComponent(UIButton, "RightView/rateBtn")
  self._notice_btn:SetOnClick(function()
    self:OnClickNotice()
  end)
  self._rect_discountBgOne = self:AddComponent(UIBaseContainer, "RightView/layout/Btn_One/discountBgOne")
  self._txt_discountOne = self:AddComponent(UIText, "RightView/layout/Btn_One/discountBgOne/txtDiscountOne")
  self._rect_discountBgFive = self:AddComponent(UIBaseContainer, "RightView/layout/Btn_Five/discountBgFive")
  self._txt_discountFive = self:AddComponent(UIText, "RightView/layout/Btn_Five/discountBgFive/txtDiscountFive")
  self._five_btn = self:AddComponent(UIButton, "RightView/layout/Btn_Five")
  self._btnFive_txt = self:AddComponent(UIText, "RightView/layout/Btn_Five/Rect_BtnFive/Txt_BtnFive")
  self._costFive_txt = self:AddComponent(UIText, "RightView/layout/Btn_Five/Rect_BtnFive/Txt_CostFive")
  self._costFive_img = self:AddComponent(UIImage, "RightView/layout/Btn_Five/Rect_BtnFive/Txt_CostFive/Img_CostFive")
  self._five_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Lucky_Roll_Click, false)
    self:OnClickOne(1)
  end)
  self._extraBox_anim = self:AddComponent(UIAnimator, "RightView/Btn_ExtraBox")
  self._extraBox_vfx = self:AddComponent(UIBaseContainer, "RightView/Btn_ExtraBox/VFX_Box")
  self._mask_btn = self:AddComponent(UIButton, "RightView/Mask")
  self._mask_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickMask()
  end)
  self._extra_rect = self:AddComponent(UIBaseContainer, "RightView/Rect_Extra")
  self._extraName_txt = self:AddComponent(UIText, "RightView/Rect_Extra/Txt_ExtraName")
  self._extraName_txt:SetLocalText(2000347)
  self.toggle = self:AddComponent(UIToggle, "RightView/redSwitch")
  self.toggle:SetIsOn(true)
  self.toggle:SetOnValueChanged(function(tf)
    self:ToggleControlBorS(tf)
  end)
  self._jumpAnim_txt = self:AddComponent(UIText, "RightView/redSwitch/redSwitchTxt")
  self._jumpAnim_txt:SetLocalText(2000346)
  self._time_txt = self:AddComponent(UIText, "RightView/Txt_ActEndTime")
  self._surplus_txt = self:AddComponent(UIText, "RightView/surplusTxt")
  self._extra_stage_txt = self:AddComponent(UIText, "RightView/Rect_Extra/ProgressText")
  self._extra_stage_sliderBg = self:AddComponent(UIImage, "RightView/Rect_Extra/StagesScroll/Viewport/Content/Background")
  self._extra_stage_slider = self:AddComponent(UISlider, "RightView/Rect_Extra/StagesScroll/Viewport/Content/Background/Slider")
  self._extra_box_temp = self:AddComponent(UIBaseContainer, "RightView/Rect_Extra/Box")
  self._extra_box_container = self:AddComponent(UIBaseContainer, "RightView/Rect_Extra/StagesScroll/Viewport/Content/Boxes")
  self._extra_box_temp.gameObject:GameObjectCreatePool()
  self._diamond_topBar = self:AddComponent(UITopItem, "RightView/topRes/DiamondBar")
  self._item_topBar = self:AddComponent(UITopItem, "RightView/topRes/ItemBar")
  self._gift_pack_btn = self:AddComponent(UIButton, "RightView/GiftPackBtn")
  self.onClickGiftPack = BindCallback(self, self.OnClickGiftPack)
  self._gift_pack_btn:SetOnClick(self.onClickGiftPack)
  self._gift_pack_redPoint = self:AddComponent(UIBaseContainer, "RightView/GiftPackBtn/RedPoint")
  self._hero_info_btn = self:AddComponent(UIButton, "RightView/content/Btn_HeroInfo")
  self._hero_info_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    if self.actData then
      local heroWindow = UIManager:GetInstance():GetWindow(UIWindowNames.UIHeroDetailPanel)
      if not heroWindow then
        local heroId = self.actData.heroShowId
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, heroId, {heroId})
      end
    end
  end)
  self.rewardChangeBtn = self:AddComponent(LWUIActivityRewardChangePreviewEntranceComponent, "RightView/content/rewardChangeBtn")
end

function UILuckyRoll:OnDestroy()
  self._extra_box_container:RemoveComponents(UILuckyRollBox)
  self._extra_box_temp.gameObject:GameObjectRecycleAll()
  self:ComponentDestroy()
  self.model = nil
  self.eventInfo = nil
  self.lastChangeTextDeltaTime = 0
  self:DeleteTimer()
  self:DeleteAnimTimer()
  if self.delayTime ~= nil then
    self.delayTime:Stop()
    self.delayTime = nil
  end
  self.isEnd = nil
  base.OnDestroy(self)
end

function UILuckyRoll:ComponentDestroy()
  self._actName_txt = nil
  self._one_btn = nil
  self._btnOne_txt = nil
  self._costOne_txt = nil
  self._btnOne_txt_shadow = nil
  self._costOne_txt_shadow = nil
  self._costOne_img = nil
  self._five_btn = nil
  self._btnFive_txt = nil
  self._costFive_txt = nil
  self._costFive_img = nil
  self._extraBox_anim = nil
  self._extraBox_vfx = nil
  self._mask_btn = nil
  self._extra_rect = nil
  self._extraName_txt = nil
  self.toggle = nil
  self._jumpAnim_txt = nil
  self._time_txt = nil
  self._surplus_txt = nil
  self._extra_stage_txt = nil
  self._extra_stage_sliderBg = nil
  self._extra_stage_slider = nil
  self._extra_box_temp = nil
  self._extra_box_container = nil
  self._diamond_topBar = nil
  self._item_topBar = nil
  self._gift_pack_btn = nil
  self._gift_pack_redPoint = nil
  self.onClickGiftPack = nil
end

function UILuckyRoll:OnEnable()
  base.OnEnable(self)
end

function UILuckyRoll:OnDisable()
  base.OnDisable(self)
  self.isEnd = true
  self:DeleteAnimTimer()
  if self.delayAnimTime ~= nil then
    self.delayAnimTime:Stop()
    self.delayAnimTime = nil
  end
  self:SetBtnGray(false)
end

function UILuckyRoll:SetData(activityId, actId)
  self.activityId = activityId
  SFSNetwork.SendMessage(MsgDefines.GetLuckyRollInfo, toInt(self.activityId))
  DataCenter.ActivityListDataManager:SetActivityVisitedEndTime(self.activityId)
  local actListData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  self._notice_btn:SetActive(actListData and actListData.dropInfoDetail and actListData.dropInfoDetail > 0)
  self.rewardChangeBtn:ReInit(actListData, nil, true)
end

function UILuckyRoll:OnRefresh(state)
  self.boxAnim:Play("V_ui_rectdeng_zhong_daiji", 0, 0)
  self.choiceNum = 0
  self.actData = DataCenter.ActLuckyRollInfo:GetInfoByActId(tonumber(self.activityId))
  if self.actData == nil then
    return
  end
  self._hero_info_btn:SetActive(0 < self.actData.heroShowId)
  self.rollItemCount = #self.actData.rollItemArr or 12
  local actListData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if self.actData and self.actData.cost_item then
    local type, id = string.match(self.actData.cost_item, "(%d+);(%d+)")
    if type and id then
      self.costType = tonumber(type)
      self.costId = tonumber(id)
      self._costOne_img:LoadSprite(CommonUtil.GetResOrItemIcon(self.costId))
      self._costFive_img:LoadSprite(CommonUtil.GetResOrItemIcon(self.costId))
      
      local function gotoDiamond()
        UIManager:GetInstance():OpenWindow(UIWindowNames.LWBuyDiamond, {anim = true}, WelfareTagType.DiamondShop)
      end
      
      self._diamond_topBar:SetData(nil, ResourceType.Gold, gotoDiamond)
      self._item_topBar:SetData(self.costId, nil, self.onClickGiftPack)
    end
  end
  self._gift_pack_redPoint:SetActive(false)
  self.curStage = DataCenter.ActLuckyRollInfo:GetCurStage(tonumber(self.activityId))
  if self.curStage then
    local lotteryCount = self.actData.rollInfo.totalLotteryCount
    if not table.IsNullOrEmpty(self.actData.stageArr) then
      local lastStage = self.actData.stageArr[#self.actData.stageArr]
      lotteryCount = math.min(lotteryCount, lastStage.needLotteryNum)
    end
    local str = string.format("<size=48>%d</size>/%d", lotteryCount, self.actData.stageArr[self.curStage].needLotteryNum)
    self._extra_stage_txt:SetText(str)
  end
  for i = 1, self.rollItemCount do
    local function callback(position)
      self:ClickItemArrIndex(position)
    end
    
    self.box_rectTab[i]:RefreshData(self.actData.rollItemArr[i], callback, actListData.subViewType)
    if self.actData.rollItemArr[i].type ~= 0 and self.actData.rollItemArr[i].chooseIndex ~= 0 then
      self.choiceNum = self.choiceNum + 1
    end
  end
  if state then
    self.toggle:SetIsOn(state)
  else
    local isJumpPlay = Setting:GetBool(SettingKeys.ActLuckyRollJumpAnim .. LuaEntry.Player.uid, false)
    self.toggle:SetIsOn(isJumpPlay)
  end
  self:RefreshOneInfo()
  self:RefreshFiveInfo()
  self:RefreshCostTextColor()
  self:RefreshExtraBoxInfo()
  self:RefreshSliderInfo()
  self:RefreshTime(actListData)
  self:AddTimer(actListData)
  local num = self.actData.drawMax - (self.actData.rollInfo.oneLotteryCount + self.actData.rollInfo.fiveLotteryCount * 10)
  if 0 < num then
    self._surplus_txt:SetLocalText(2000344, num)
  else
    self._surplus_txt:SetLocalText(372304)
  end
  if actListData then
    self._actName_txt:SetLocalText(actListData.name)
  end
end

function UILuckyRoll:OnLuckyRollStart()
  self.isEnd = false
end

function UILuckyRoll:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActLuckyRollUpdate, self.OnRefresh)
  self:AddUIListener(EventId.ActLuckyRollChoiceItem, self.ChoiceItem)
  self:AddUIListener(EventId.ActLuckyRollGetReward, self.GetRewardRefresh)
  self:AddUIListener(EventId.UpdateGold, self.RefreshGold)
  self:AddUIListener(EventId.RefreshItems, self.RefreshGoods)
  self:AddUIListener(EventId.LuckyRollStart, self.OnLuckyRollStart)
end

function UILuckyRoll:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ActLuckyRollUpdate, self.OnRefresh)
  self:RemoveUIListener(EventId.ActLuckyRollChoiceItem, self.ChoiceItem)
  self:RemoveUIListener(EventId.ActLuckyRollGetReward, self.GetRewardRefresh)
  self:RemoveUIListener(EventId.UpdateGold, self.RefreshGold)
  self:RemoveUIListener(EventId.RefreshItems, self.RefreshGoods)
  self:RemoveUIListener(EventId.LuckyRollStart, self.OnLuckyRollStart)
end

function UILuckyRoll:RefreshGold()
  if self._diamond_topBar then
    self._diamond_topBar:RefreshData()
  end
end

function UILuckyRoll:RefreshCostTextColor()
  if not self.needGoldOne or not self.needGoldFive then
    return
  end
  local have = 0
  local need = 0
  if self.costId and (self.costType == 1 or self.costType == 2) then
    have = CommonUtil.GetResOrItemCount(self.costId)
  end
  if self._costOne_txt then
    if have >= self.needGoldOne then
      self._costOne_txt:SetColor(WhiteColor)
    else
      self._costOne_txt:SetColor(LackResourceRedColor)
    end
  end
  if self._costFive_txt then
    if have >= self.needGoldFive then
      self._costFive_txt:SetColor(WhiteColor)
    else
      self._costFive_txt:SetColor(LackResourceRedColor)
    end
  end
end

function UILuckyRoll:RefreshGoods()
  if self._item_topBar then
    self._item_topBar:RefreshData()
    self:RefreshCostTextColor()
  end
end

function UILuckyRoll:ClickItemArrIndex(position)
  self.curChoicePos = position
end

function UILuckyRoll:ChoiceItem(index)
  if self.curChoicePos ~= 0 then
    SFSNetwork.SendMessage(MsgDefines.LuckyRollChooseItem, toInt(self.activityId), self.actData.rollItemArr[self.curChoicePos].itemId, index)
    self.box_rectTab[self.curChoicePos]:SelectUpdateItem(index)
    self.curChoicePos = 0
    if self.choiceNum == 3 then
      return
    end
    self.choiceNum = self.choiceNum + 1
  end
end

function UILuckyRoll:RefreshOneInfo()
  self._btnOne_txt:SetLocalText(2000345, 1)
  self._freeRed_img:SetActive(false)
  if self.actData.cost_1[self.actData.rollInfo.oneLotteryCount + 1] then
    if self.actData.cost_1[self.actData.rollInfo.oneLotteryCount + 1] == 0 then
      self._one_btn:LoadSprite(string.format(LoadPath.LWCommonPath, "cfm_tongyong_anniu_2"))
      self._costOne_txt:SetLocalText(130126)
      self.isFree = 1
      self._freeRed_img:SetActive(true)
      self._rect_discountBgOne:SetActive(false)
    else
      self._one_btn:LoadSprite(string.format(LoadPath.LWCommonPath, "cfm_tongyong_anniu_4"))
      local count = table.count(self.actData.cost_1)
      local price = self.actData.cost_1[self.actData.rollInfo.oneLotteryCount + 1]
      if self.actData.rollInfo.oneLotteryCount + 1 == count then
        self._rect_discountBgOne:SetActive(false)
      else
        self._rect_discountBgOne:SetActive(true)
        local value = 1 - price / self.actData.cost_1[count]
        local value1 = Mathf.Ceil(100 * value)
        self._txt_discountOne:SetText("-" .. value1 .. "%")
      end
      self._costOne_txt:SetText(price)
      self.isFree = 0
      self.needGoldOne = price
    end
  else
    self._rect_discountBgOne:SetActive(false)
    local count = table.count(self.actData.cost_1)
    self._costOne_txt:SetText(self.actData.cost_1[count])
    self.needGoldOne = self.actData.cost_1[count]
    self.isFree = 0
  end
end

function UILuckyRoll:RefreshFiveInfo()
  self._btnFive_txt:SetLocalText(2000345, 10)
  if self.actData.cost_5[self.actData.rollInfo.fiveLotteryCount + 1] then
    local price = self.actData.cost_5[self.actData.rollInfo.fiveLotteryCount + 1]
    self._costFive_txt:SetText(price)
    self.needGoldFive = price
    local count = table.count(self.actData.cost_5)
    if self.actData.rollInfo.fiveLotteryCount + 1 == count then
      self._rect_discountBgFive:SetActive(false)
    else
      local value = 1 - price / self.actData.cost_5[count]
      self._rect_discountBgFive:SetActive(true)
      local value1 = Mathf.Ceil(100 * value)
      self._txt_discountFive:SetText("-" .. value1 .. "%")
    end
  else
    local count = table.count(self.actData.cost_5)
    self._costFive_txt:SetText(self.actData.cost_5[count])
    self.needGoldFive = self.actData.cost_5[count]
    self._rect_discountBgFive:SetActive(false)
  end
end

local cellSize = 125
local partAPercent = 0.64
local partBPercent = 0.36

function UILuckyRoll:RefreshSliderInfo()
  local segmentCount = #self.actData.stageArr
  local step = 1 / (segmentCount - partBPercent)
  local progress = 0
  local totalLotteryCount = self.actData.rollInfo.totalLotteryCount
  for i = 1, segmentCount do
    local realStep = step
    if i == 1 then
      realStep = step * partAPercent
    end
    if totalLotteryCount < self.actData.stageArr[i].needLotteryNum then
      local lastValue = 0
      if 1 < i then
        lastValue = self.actData.stageArr[i - 1].needLotteryNum
      end
      progress = progress + (totalLotteryCount - lastValue) / (self.actData.stageArr[i].needLotteryNum - lastValue) * realStep
      break
    else
      progress = progress + realStep
    end
  end
  self._extra_stage_slider:SetValue(progress)
end

function UILuckyRoll:RefreshExtraBoxInfo()
  if not self.hasInitExtraBox then
    self.hasInitExtraBox = true
    local count = #self.actData.stageArr
    self.listBox = {}
    for i = 1, count do
      local item = self._extra_box_temp.gameObject:GameObjectSpawn(self._extra_box_container.transform)
      item.name = "item" .. i
      local obj = self._extra_box_container:AddComponent(UILuckyRollBox, item.name)
      obj:SetActive(true)
      obj:RefreshData(self.actData.stageArr[i], self.actData.rollInfo.totalLotteryCount, toInt(self.activityId), i ~= count)
      self.listBox[i] = obj
    end
    local width = cellSize * count - cellSize * partBPercent + 10
    self._extra_stage_sliderBg.transform:Set_sizeDelta(width, 25)
  else
    local count = #self.actData.stageArr
    for i = 1, count do
      self.listBox[i]:RefreshData(self.actData.stageArr[i], self.actData.rollInfo.totalLotteryCount, toInt(self.activityId), i ~= count)
    end
  end
  for i = 1, #self.actData.stageArr do
    if self.actData.stageArr[i].state == 0 and self.actData.rollInfo.totalLotteryCount >= self.actData.stageArr[i].needLotteryNum then
      self._extraBox_anim:Play("V_ui_extrabox_", 0, 0)
      self._extraBox_vfx:SetActive(true)
      return
    end
  end
  self._extraBox_anim:Play("V_ui_extrabox_default", 0, 0)
  self._extraBox_vfx:SetActive(false)
end

function UILuckyRoll:ToggleControlBorS(isJumpPlay)
  Setting:SetBool(SettingKeys.ActLuckyRollJumpAnim .. LuaEntry.Player.uid, isJumpPlay)
end

function UILuckyRoll:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function UILuckyRoll:AddTimer(actListData)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, actListData, false, false, false)
  end
  self.timer:Start()
end

function UILuckyRoll:RefreshTime(actListData)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime > actListData.endTime then
    self:DeleteTimer()
    self._time_txt:SetLocalText(2000409)
  else
    self._time_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(actListData.endTime - curTime))
  end
end

function UILuckyRoll:SetBtnGray(state)
  CS.UIGray.SetGray(self._one_btn.transform, state, true)
  CS.UIGray.SetGray(self._five_btn.transform, state, true)
end

function UILuckyRoll:GetRewardRefresh(message)
  self.ring = 0
  self.titleRing = 0
  self.boxRing = 0
  self.signRefresh = false
  local state = Setting:GetBool(SettingKeys.ActLuckyRollJumpAnim .. LuaEntry.Player.uid, true)
  self:OnRefresh(state)
  if state then
    self:SetBtnGray(false)
    self:DeleteAnimTimer()
    self.boxAnim:Play("V_ui_rectdeng_zhong_shanshuo", 0, 0)
    local curRewardIndex = DataCenter.ActLuckyRollInfo:GetCurRewardIndex()
    local itemCount = self.rollItemCount
    for i = 1, #curRewardIndex do
      curRewardIndex[i] = curRewardIndex[i] % itemCount
      if curRewardIndex[i] == 0 then
        curRewardIndex[i] = itemCount
      end
    end
    if message.reward == 1 then
      local rewardIndex = curRewardIndex[1]
      if rewardIndex then
        self.box_rectTab[rewardIndex]:PlayOneAnim(rewardIndex, true)
      end
    else
      for i = 1, #curRewardIndex do
        local rewardIndex = curRewardIndex[i]
        if rewardIndex then
          self.box_rectTab[rewardIndex]:PlayOneAnim(rewardIndex, true)
        end
      end
    end
    DataCenter.RewardManager:ShowCommonReward(message)
    self.isEnd = true
    self.boxAnim:Play("V_ui_rectdeng_zhong_daiji", 0, 0)
    self:SetBtnGray(false)
  else
    self:SetBtnGray(true)
    local curRewardIndex = DataCenter.ActLuckyRollInfo:GetCurRewardIndex()
    local itemCount = self.rollItemCount
    for i = 1, #curRewardIndex do
      curRewardIndex[i] = curRewardIndex[i] % itemCount
      if curRewardIndex[i] == 0 then
        curRewardIndex[i] = itemCount
      end
    end
    self.fiveIndex = 1
    self.tab = {}
    self:AddAnimTimer(curRewardIndex, message)
    self.boxAnim:Play("V_ui_rectdeng_zhong_shanshuo", 0, 0)
  end
end

function UILuckyRoll:AddAnimTimer(curRewardIndex, message)
  if self.timer_anim == nil then
    self.timer_anim = TimerManager:GetInstance():GetTimer(0.1, self.timer_action_anim, {curRewardIndex = curRewardIndex, message = message}, false, false, false)
  end
  self.timer_anim:Start()
end

function UILuckyRoll:RefreshAnimTime(tab)
  self.ring = self.ring + 1
  self.tab = tab
  if #tab.message.reward == 1 then
    if not self.signRefresh and self.ring == self.rollItemCount + 1 then
      self.ring = 1
      self.signRefresh = true
    end
    self.box_rectTab[self.ring]:PlayOneAnim(tab.curRewardIndex[1], self.signRefresh)
    if self.signRefresh and self.ring == tab.curRewardIndex[1] then
      self.signRefresh = false
      self:DeleteAnimTimer()
      self.delayAnimTime = TimerManager:GetInstance():DelayInvoke(function()
        if self.delayAnimTime then
          self.delayAnimTime:Stop()
          self.delayAnimTime = nil
        end
        DataCenter.RewardManager:ShowCommonReward(tab.message)
        self.isEnd = true
        self.boxAnim:Play("V_ui_rectdeng_zhong_daiji", 0, 0)
        self:SetBtnGray(false)
      end, 2)
    end
  else
    if self.ring == self.rollItemCount + 1 then
      self.ring = 1
      self.signRefresh = true
    end
    self.box_rectTab[self.ring]:PlayFiveAnim(self.tab.curRewardIndex[self.fiveIndex], self.signRefresh)
    if self.signRefresh then
      if self.tab.curRewardIndex[self.fiveIndex] then
        if self.tab.curRewardIndex[self.fiveIndex] == self.ring then
          table.remove(self.tab.curRewardIndex, self.fiveIndex)
          self:DeleteAnimTimer()
          self.delayAnimTime = TimerManager:GetInstance():DelayInvoke(function()
            if self.delayAnimTime then
              self.delayAnimTime:Stop()
              self.delayAnimTime = nil
            end
            if next(self.tab.curRewardIndex) then
              self:AddAnimTimer(self.tab.curRewardIndex, tab.message)
            else
              DataCenter.RewardManager:ShowCommonReward(tab.message)
              self.isEnd = true
              self.boxAnim:Play("V_ui_rectdeng_zhong_daiji", 0, 0)
              self:SetBtnGray(false)
            end
          end, 0.5)
        end
      else
        self:DeleteAnimTimer()
        self.delayAnimTime = TimerManager:GetInstance():DelayInvoke(function()
          if self.delayAnimTime then
            self.delayAnimTime:Stop()
            self.delayAnimTime = nil
          end
          DataCenter.RewardManager:ShowCommonReward(tab.message)
          self.isEnd = true
          self.boxAnim:Play("V_ui_rectdeng_zhong_daiji", 0, 0)
          self:SetBtnGray(false)
        end, 2)
      end
    end
  end
end

function UILuckyRoll:DeleteAnimTimer()
  if self.timer_anim ~= nil then
    self.timer_anim:Stop()
    self.timer_anim = nil
  end
end

function UILuckyRoll:OnClickOne(type)
  if not self.isEnd then
    return
  end
  local num = self.actData.drawMax - (self.actData.rollInfo.oneLotteryCount + self.actData.rollInfo.fiveLotteryCount * 10)
  if type == 1 then
    self.isFree = 0
    if num < 10 then
      UIUtil.ShowTipsId(372304)
      return
    end
  elseif type == 0 and num <= 0 then
    UIUtil.ShowTipsId(372304)
    return
  end
  if self.isFree == 0 then
    local have = 0
    local need = 0
    if self.costId and (self.costType == 1 or self.costType == 2) then
      have = CommonUtil.GetResOrItemCount(self.costId)
    end
    if type == 0 then
      need = self.needGoldOne
    elseif type == 1 then
      need = self.needGoldFive
    end
    if have < need then
      DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
      if self.actData then
        local buyCount = need - have
        local toggleState = DataCenter.SecondConfirmManager:GetTodayCanShowSecondConfirm(TodayNoSecondConfirmType.BuyLuckyRollTip)
        if toggleState then
          UIManager:GetInstance():OpenWindow(UIWindowNames.UILuckyRollBuy, {anim = true}, self.costId, self.actData.gfitPackGroupId, buyCount, self.activityId, type)
        else
          local itemTempalte = DataCenter.ItemTemplateManager:GetItemTemplate(self.costId)
          if itemTempalte then
            local itemPrice = itemTempalte.price
            local cost = itemPrice * buyCount
            local haveDiamond = CommonUtil.GetResOrItemCount(ResourceType.Gold)
            if cost <= haveDiamond then
              SFSNetwork.SendMessage(MsgDefines.LuckyRollBuyAndUse, self.costId, buyCount, toInt(self.activityId), type)
              self.isEnd = false
            else
              GoToUtil.GotoPayTips(cost)
            end
          end
        end
      end
      return
    end
  end
  self.isEnd = false
  SFSNetwork.SendMessage(MsgDefines.LuckyRollLottery, toInt(self.activityId), type, self.isFree)
end

function UILuckyRoll:OnClickExtraBox()
  self._extra_rect:SetActive(true)
  self._mask_btn:SetActive(true)
end

function UILuckyRoll:OnClickMask()
  self._mask_btn:SetActive(false)
  self._extra_rect:SetActive(false)
end

function UILuckyRoll:OnClickNotice()
  local actListData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIProbabilityNotice, {anim = true}, actListData.dropInfoDetail)
end

return UILuckyRoll
