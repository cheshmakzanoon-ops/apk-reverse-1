local UIGolloesCards = BaseClass("UIGolloesCards", UIBaseView)
local base = UIBaseView
local UIGolloesCardsCell = require("UI.UIActivityCenterTable.Component.GolloesCards.UIGolloesCardsCell")
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local str = {
  [1] = 372332,
  [2] = 372333,
  [3] = 372334
}
local img_bg = {
  [1] = "UIgolo_img_card_blue",
  [2] = "UIgolo_img_card_pur",
  [3] = "UIgolo_img_card_org"
}
local img_quality = {
  [1] = "UIgolo_img_card_blue02",
  [2] = "UIgolo_img_card_pur02",
  [3] = "UIgolo_img_card_org02"
}

function UIGolloesCards:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIGolloesCards:OnDestroy()
  self:ClearDelayTime()
  self:DeleteTimer()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIGolloesCards:OnEnable()
  base.OnEnable(self)
end

function UIGolloesCards:OnDisable()
  base.OnDisable(self)
end

function UIGolloesCards:ComponentDefine()
  self._actName_txt = self:AddComponent(UIText, "Root/TitleBg/Txt_ActName")
  self._actName_txt:SetLocalText(372288)
  self._time_txt = self:AddComponent(UIText, "Root/TitleBg/NotStarted/Txt_Times")
  self._remaining_txt = self:AddComponent(UIText, "Root/TitleBg/Txt_Remaining")
  self._mask_rect = self:AddComponent(UIBaseContainer, "Root/Mask")
  self._oneGet_btn = self:AddComponent(UIButton, "Root/Mask/Btn_List/Btn_OneGet")
  self._oneGet_btn:SetOnClick(function()
    self:OneGetClick()
  end)
  self._oneGet_txt = self:AddComponent(UIText, "Root/Mask/Btn_List/Btn_OneGet/Rect_BtnGet/Txt_OneGet")
  self._costGet_txt = self:AddComponent(UIText, "Root/Mask/Btn_List/Btn_OneGet/Rect_BtnGet/Txt_CostGet")
  self._costGet_img = self:AddComponent(UIImage, "Root/Mask/Btn_List/Btn_OneGet/Rect_BtnGet/Txt_CostGet/Img_CostGet")
  self._oneGet_txt:SetLocalText(372291)
  self._refresh_btn = self:AddComponent(UIButton, "Root/Mask/Btn_List/Btn_Refresh")
  self._refresh_btn:SetOnClick(function()
    self:OnClickRefresh()
  end)
  self._refresh_txt = self:AddComponent(UIText, "Root/Mask/Btn_List/Btn_Refresh/Txt_Refresh")
  self._refresh_rect = self:AddComponent(UIText, "Root/Mask/Btn_List/Btn_Refresh/Rect_BtnRefresh")
  self._ontRefresh_txt = self:AddComponent(UIText, "Root/Mask/Btn_List/Btn_Refresh/Rect_BtnRefresh/Txt_OneRefresh")
  self._ontRefresh_txt:SetLocalText(110028)
  self._costRefresh_txt = self:AddComponent(UIText, "Root/Mask/Btn_List/Btn_Refresh/Rect_BtnRefresh/Txt_CostRefresh")
  self.cells = {}
  for i = 1, 9 do
    self.cells[i] = self:AddComponent(UIGolloesCardsCell, "Root/Mask/ScrollView/Content/UIGolloesCardsCell" .. i)
  end
  self._rewardPreview_btn = self:AddComponent(UIButton, "Root/Btn_RewardPreview")
  self._rewardPreview_txt = self:AddComponent(UIText, "Root/Btn_RewardPreview/Txt_RewardPreview")
  self._rewardPreview_txt:SetLocalText(372299)
  self._rewardPreview_btn:SetOnClick(function()
    self:OnClickPreview()
  end)
  self._preview_img = self:AddComponent(UIImage, "Root/Btn_RewardPreview/Img_Preview")
  self._layout = self:AddComponent(UIBaseContainer, "Root/Mask/layout")
  self._curfree_txt = self:AddComponent(UIText, "Root/Mask/Txt_freeTips")
  self._curConsume_txt = self:AddComponent(UIText, "Root/Mask/layout/Txt_CurConsume")
  self._consumeTips_txt = self:AddComponent(UIText, "Root/Mask/layout/Txt_ConsumeTips")
  self.intro_btn = self:AddComponent(UIButton, "Root/TitleBg/Txt_ActName/Intro")
  self.intro_btn:SetOnClick(function()
    self:OnIntroClick()
  end)
  self._shop_btn = self:AddComponent(UIButton, "Root/Btn_Shop")
  self._shopRed_rect = self:AddComponent(UIBaseContainer, "Root/Btn_Shop/RedDot")
  self._shopRed_txt = self:AddComponent(UIText, "Root/Btn_Shop/RedDot/Txt_Red")
  self._shop_txt = self:AddComponent(UIText, "Root/Btn_Shop/Txt_Shop")
  self._shop_txt:SetLocalText(372290)
  self._shop_btn:SetOnClick(function()
    self:OnClickShop()
  end)
  self._rank_btn = self:AddComponent(UIButton, "Root/Btn_Rank")
  self._rank_txt = self:AddComponent(UIText, "Root/Btn_Rank/Txt_Rank")
  self._rank_txt:SetLocalText(390040)
  self._rank_btn:SetOnClick(function()
    self:OnClickRank()
  end)
  self._curCardLv_txt = self:AddComponent(UIText, "Root/Mask/Txt_CurCardLv")
  self._resNum_txt = self:AddComponent(UIText, "Root/Res/resNum")
  self._content_anim = self:AddComponent(UIAnimator, "Root/Mask/ScrollView/Content")
  self.effect_rect = self:AddComponent(UIBaseContainer, "Root/Mask/Rect_Effect")
end

function UIGolloesCards:ComponentDestroy()
  self._actName_txt = nil
  self._time_txt = nil
  self._remaining_txt = nil
  self._oneGet_btn = nil
end

function UIGolloesCards:DataDefine()
  self.timer = nil
  
  function self.timer_action(temp)
    self:RefreshTime(temp)
  end
  
  self.previewRw = 0
end

function UIGolloesCards:DataDestroy()
  self.timer_action = nil
  self.previewRw = nil
end

function UIGolloesCards:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActGolloesCard, self.OnRefresh)
  self:AddUIListener(EventId.ActGolloesCardFlip, self.ActGolloesCardFlip)
  self:AddUIListener(EventId.ActGolloesCardRefresh, self.ActCardRefresh)
  self:AddUIListener(EventId.ActGolloesCardRed, self.RefreshShopRed)
  self:AddUIListener(EventId.UpdateGold, self.RefreshShopRed)
  self:AddUIListener(EventId.ActGolloesCardFlipAll, self.ActCardFlipAllRefresh)
  self:AddUIListener(EventId.ActGolloesCardRewardShow, self.DelayShowReward)
end

function UIGolloesCards:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ActGolloesCard, self.OnRefresh)
  self:RemoveUIListener(EventId.ActGolloesCardFlip, self.ActGolloesCardFlip)
  self:RemoveUIListener(EventId.ActGolloesCardRefresh, self.ActCardRefresh)
  self:RemoveUIListener(EventId.ActGolloesCardRed, self.RefreshShopRed)
  self:RemoveUIListener(EventId.UpdateGold, self.RefreshShopRed)
  self:RemoveUIListener(EventId.ActGolloesCardFlipAll, self.ActCardFlipAllRefresh)
  self:RemoveUIListener(EventId.ActGolloesCardRewardShow, self.DelayShowReward)
end

function UIGolloesCards:SetData(activityId, actId)
  self.activityId = activityId
  DataCenter.ActivityListDataManager:SetActivityVisitedEndTime(actId)
  SFSNetwork.SendMessage(MsgDefines.GetGolloesCardInfo, activityId)
  self.effect_rect:SetActive(false)
  self._mask_rect:SetActive(true)
end

function UIGolloesCards:OnRefresh()
  self.actData = DataCenter.ActGolloesCardData:GetInfoByActId(tonumber(self.activityId))
  local actListData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if actListData then
    self:RefreshTime(actListData)
    self:AddTimer(actListData)
    self:RefreshBottom()
    self:RefreshCard()
    self:RefreshShopRed()
    self:ShowNeedRes()
    if self:CheckDelayTime() then
      self.isAllowClick = true
    end
  end
end

function UIGolloesCards:AddTimer(actListData)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, actListData, false, false, false)
  end
  self.timer:Start()
end

function UIGolloesCards:RefreshTime(actListData)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime > actListData.endTime then
    self:DeleteTimer()
    self.actEnd = true
  else
    self._time_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(actListData.endTime - curTime))
    self.actEnd = false
  end
end

function UIGolloesCards:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function UIGolloesCards:RefreshCard()
  local actListData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  local reward = DataCenter.RewardManager:StrRewardToNumHandle(actListData.reward_goods, self.actData.cardInfo.group)
  local goods = DataCenter.ItemTemplateManager:GetItemTemplate(reward[1].itemId)
  if goods ~= nil then
    self.previewRw = reward[1].itemId
  end
  self._curCardLv_txt:SetLocalText(str[self.actData.cardInfo.group])
  for i = 1, 9 do
    self.cells[i]:RefreshData(i, self.previewRw, function(tempIndex, img)
      self:FlipCard(tempIndex, img)
    end)
    self.cells[i]:RefreshState(true)
    self.cells[i]:LoadBg(img_bg[self.actData.cardInfo.group], img_quality[self.actData.cardInfo.group])
    if self.isFree then
      self.cells[i]:FreePlayEffect()
    end
  end
  for i = 1, #self.actData.flipCards do
    self.cells[self.actData.flipCards[i].index]:RefreshReward(self.actData.flipCards[i].reward[1])
  end
end

function UIGolloesCards:RefreshBottom()
  self._remaining_txt:SetText(Localization:GetString("372293") .. " " .. self.actData.times - self.actData.cardInfo.flipCount)
  local num = self.actData.cardInfo.flipCount
  num = num + 1
  local count = num
  if self.actData.cost_1[count] == nil then
    count = table.count(self.actData.cost_1)
  end
  if self.actData.cost_1[count] == "0" then
    self.isFree = true
    self._curfree_txt:SetLocalText(372294)
    self._layout:SetActive(false)
    self._curfree_txt:SetActive(true)
  else
    self.isFree = false
    self._consumeTips_txt:SetLocalText(372295)
    self._layout:SetActive(true)
    self._curfree_txt:SetActive(false)
    self._curConsume_txt:SetText(self.actData.cost_1[count])
  end
  if self.actData.cardInfo.flipAllCount < self.actData.free_all and #self.actData.flipCards < 9 then
    self._oneGet_btn:LoadSprite(string.format(LoadPath.CommonNewPath, "Common_btn_green101"))
    self._costGet_txt:SetLocalText(130126)
    self.oneGet = true
    UIGray.SetGray(self._oneGet_btn.transform, false, true)
  else
    local extraCount = 0
    if self.actData.cost_1[count] == "0" then
      extraCount = 1
    end
    local allPrice = self.actData.cost_all * (9 - extraCount - #self.actData.flipCards)
    if allPrice == self.actData.cost_all then
      allPrice = tonumber(self.actData.cost_1[count])
    end
    if allPrice == 0 then
      UIGray.SetGray(self._oneGet_btn.transform, true, false)
      self.oneGet = true
    else
      UIGray.SetGray(self._oneGet_btn.transform, false, true)
      self._oneGet_btn:LoadSprite(string.format(LoadPath.CommonNewPath, "Common_btn_yellow101"))
      self.oneGet = false
    end
    self._costGet_txt:SetText(allPrice == 0 and tonumber(self.actData.cost_1[count]) or allPrice)
  end
  if #self.actData.flipCards >= 5 then
    self._refresh_rect:SetActive(false)
    self._refresh_btn:LoadSprite(string.format(LoadPath.CommonNewPath, "Common_btn_green101"))
    self._refresh_txt:SetActive(true)
    self._refresh_txt:SetLocalText(372292)
    return
  end
  local refreshCount = self.actData.cardInfo.refreshCount
  if refreshCount == 0 then
    refreshCount = 1
  end
  if self.actData.refresh_cost[refreshCount] then
    local price = self.actData.refresh_cost[refreshCount]
    if tonumber(price) == 0 then
      self._refresh_rect:SetActive(false)
      self._refresh_btn:LoadSprite(string.format(LoadPath.CommonNewPath, "Common_btn_green101"))
      self._refresh_txt:SetActive(true)
      self._refresh_txt:SetLocalText(372292)
    else
      self._refresh_btn:LoadSprite(string.format(LoadPath.CommonNewPath, "Common_btn_yellow101"))
      self._refresh_txt:SetActive(false)
      self._refresh_rect:SetActive(true)
      self._costRefresh_txt:SetText(price)
    end
  else
    self._refresh_btn:LoadSprite(string.format(LoadPath.CommonNewPath, "Common_btn_yellow101"))
    self._refresh_txt:SetActive(false)
    self._refresh_rect:SetActive(true)
    local cost = table.count(self.actData.refresh_cost)
    self._costRefresh_txt:SetText(self.actData.refresh_cost[cost])
  end
end

function UIGolloesCards:RefreshShopRed()
  local count = DataCenter.ActGolloesCardData:GetActRed(tonumber(self.activityId))
  self._shopRed_rect:SetActive(0 < count)
  self._shopRed_txt:SetActive(0 < count)
  self._shopRed_txt:SetText(count)
  self:ShowNeedRes()
end

function UIGolloesCards:ShowNeedRes()
  local tempCount = LuaEntry.Player.gold
  self._resNum_txt:SetText(string.GetFormattedSeperatorNum(tempCount))
end

function UIGolloesCards:ActGolloesCardFlip()
  self.actData = DataCenter.ActGolloesCardData:GetInfoByActId(tonumber(self.activityId))
  self:RefreshBottom()
  for i = 1, #self.actData.flipCards do
    self.cells[self.actData.flipCards[i].index]:RefreshReward(self.actData.flipCards[i].reward[1], nil, true)
  end
  self:RefreshShopRed()
  self:ShowNeedRes()
  if self:CheckDelayTime() then
    self.isAllowClick = true
  end
end

function UIGolloesCards:ActCardRefresh(lastActData, type)
  self.actData = DataCenter.ActGolloesCardData:GetInfoByActId(tonumber(self.activityId))
  local flipCard = self.actData.flipCards
  if lastActData then
    if next(lastActData) then
      flipCard = lastActData
    end
    if type == 1 then
      self.actData:ClearLastFlipCards()
    end
  end
  local playAnim = {}
  for i = 1, 9 do
    playAnim[i] = i
  end
  for i = 1, #flipCard do
    table.removebyvalue(playAnim, flipCard[i].index, true)
  end
  if type and type == 1 then
    playAnim = {}
  elseif type == nil then
    playAnim = {}
  end
  if type then
    local showArr = self.actData:GetShowArr()
    for i = 1, #playAnim do
      self.cells[playAnim[i]]:PlayAnim(showArr[i][1], self.previewRw)
    end
  end
  if type and type == 2 then
    return
  end
  if next(playAnim) then
    self.delayAnimTime = TimerManager:GetInstance():DelayInvoke(function()
      if self.delayAnimTime then
        self.delayAnimTime:Stop()
        self.delayAnimTime = nil
      end
      for i = 1, 9 do
        self.cells[i]:RefreshState()
        self.cells[i]:PlayRefreshAnim()
      end
      self.delayAnimTime1 = TimerManager:GetInstance():DelayInvoke(function()
        if self.delayAnimTime1 then
          self.delayAnimTime1:Stop()
          self.delayAnimTime1 = nil
        end
        for i = 1, 9 do
          self.cells[i]:PlayEffectRefresh()
          self.cells[i]:LoadBg(img_bg[self.actData.cardInfo.group], img_quality[self.actData.cardInfo.group])
        end
        if self.actData.cardInfo.group == 3 then
          self.effect_rect:SetActive(true)
        end
      end, 0.5)
      local actListData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
      local reward = DataCenter.RewardManager:StrRewardToNumHandle(actListData.reward_goods, self.actData.cardInfo.group)
      local goods = DataCenter.ItemTemplateManager:GetItemTemplate(reward[1].itemId)
      if goods ~= nil then
        self.previewRw = reward[1].itemId
      end
      local nextShowArr = self.actData:GetNextShowArr(reward[1].itemId)
      self.delayAnimTime2 = TimerManager:GetInstance():DelayInvoke(function()
        if self.delayAnimTime2 then
          self.delayAnimTime2:Stop()
          self.delayAnimTime2 = nil
        end
        for i = 1, 9 do
          self.cells[i]:RefreshReward(nextShowArr[i][1], nil, true, true)
          self.cells[i]:PlayAnim(nextShowArr[i][1], reward[1].itemId)
        end
      end, 1.5)
      self.delayAnimTime3 = TimerManager:GetInstance():DelayInvoke(function()
        if self.delayAnimTime3 then
          self.delayAnimTime3:Stop()
          self.delayAnimTime3 = nil
        end
        self.effect_rect:SetActive(false)
        for i = 1, 9 do
          self.cells[i]:RefreshState()
          self.cells[i]:PlayRefreshAnim()
        end
      end, 3)
      self.delayAnimTime4 = TimerManager:GetInstance():DelayInvoke(function()
        if self.delayAnimTime4 then
          self.delayAnimTime4:Stop()
          self.delayAnimTime4 = nil
        end
        self._content_anim:Play("V_ui_golloescards_xipai", 0, 0)
        DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Golloes_Sort_Card, false)
      end, 4)
      self.delayAnimTime5 = TimerManager:GetInstance():DelayInvoke(function()
        if self.delayAnimTime5 then
          self.delayAnimTime5:Stop()
          self.delayAnimTime5 = nil
        end
        self._content_anim:Play("V_ui_golloescards_default", 0, 0)
        for i = 1, 9 do
          self.cells[i]:PlayDefaultAnim()
        end
        self.isAllowClick = true
      end, 5)
    end, 2)
  else
    local nextTime = 0
    if type then
      nextTime = 1
      for i = 1, 9 do
        self.cells[i]:RefreshState()
        self.cells[i]:PlayRefreshAnim()
      end
    else
      for i = 1, 9 do
        self.cells[i]:RefreshState()
        if flipCard[i] then
          nextTime = 1
          self.cells[flipCard[i].index]:PlayRefreshAnim()
        end
      end
    end
    self.delayAnimTime1 = TimerManager:GetInstance():DelayInvoke(function()
      if self.delayAnimTime1 then
        self.delayAnimTime1:Stop()
        self.delayAnimTime1 = nil
      end
      for i = 1, 9 do
        self.cells[i]:PlayEffectRefresh()
        self.cells[i]:LoadBg(img_bg[self.actData.cardInfo.group], img_quality[self.actData.cardInfo.group])
      end
      if self.actData.cardInfo.group == 3 then
        self.effect_rect:SetActive(true)
      end
    end, nextTime)
    local actListData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
    local reward = DataCenter.RewardManager:StrRewardToNumHandle(actListData.reward_goods, self.actData.cardInfo.group)
    local goods = DataCenter.ItemTemplateManager:GetItemTemplate(reward[1].itemId)
    if goods ~= nil then
      self.previewRw = reward[1].itemId
    end
    local nextShowArr = self.actData:GetNextShowArr(reward[1].itemId)
    self.delayAnimTime2 = TimerManager:GetInstance():DelayInvoke(function()
      if self.delayAnimTime2 then
        self.delayAnimTime2:Stop()
        self.delayAnimTime2 = nil
      end
      for i = 1, 9 do
        self.cells[i]:RefreshReward(nextShowArr[i][1], nil, true, true)
        self.cells[i]:PlayAnim(nextShowArr[i][1], reward[1].itemId)
      end
    end, nextTime + 1)
    self.delayAnimTime3 = TimerManager:GetInstance():DelayInvoke(function()
      if self.delayAnimTime3 then
        self.delayAnimTime3:Stop()
        self.delayAnimTime3 = nil
      end
      self.effect_rect:SetActive(false)
      for i = 1, 9 do
        self.cells[i]:RefreshState()
        self.cells[i]:PlayRefreshAnim()
      end
    end, nextTime + 3)
    self.delayAnimTime4 = TimerManager:GetInstance():DelayInvoke(function()
      if self.delayAnimTime4 then
        self.delayAnimTime4:Stop()
        self.delayAnimTime4 = nil
      end
      self._content_anim:Play("V_ui_golloescards_xipai", 0, 0)
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Golloes_Sort_Card, false)
    end, nextTime + 3.5)
    self.delayAnimTime5 = TimerManager:GetInstance():DelayInvoke(function()
      if self.delayAnimTime5 then
        self.delayAnimTime5:Stop()
        self.delayAnimTime5 = nil
      end
      self._content_anim:Play("V_ui_golloescards_default", 0, 0)
      for i = 1, 9 do
        self.cells[i]:PlayDefaultAnim()
      end
      self.isAllowClick = true
    end, nextTime + 4.5)
  end
  self.actData:ClearFlipCards()
  self:RefreshBottom()
  self._curCardLv_txt:SetLocalText(str[self.actData.cardInfo.group])
  self:ShowNeedRes()
end

function UIGolloesCards:ActCardFlipAllRefresh(type)
  self:RefreshShopRed()
  local lastActData = self.actData:GetLastFlipCards()
  if type == 2 then
    self:ActCardRefresh(lastActData, type)
    return
  end
  if type == 1 and lastActData then
    self:ActCardRefresh(lastActData, type)
  end
end

function UIGolloesCards:DelayShowReward(message)
  self.delayAnimTime6 = TimerManager:GetInstance():DelayInvoke(function()
    DataCenter.RewardManager:ShowCommonReward(message)
  end, message.delayTime)
end

function UIGolloesCards:CheckDelayTime()
  self.isAllowClick = true
  if self.delayAnimTime then
    self.isAllowClick = false
  end
  if self.delayAnimTime1 then
    self.isAllowClick = false
  end
  if self.delayAnimTime2 then
    self.isAllowClick = false
  end
  if self.delayAnimTime3 then
    self.isAllowClick = false
  end
  if self.delayAnimTime4 then
    self.isAllowClick = false
  end
  if self.delayAnimTime5 then
    self.isAllowClick = false
  end
  return self.isAllowClick
end

function UIGolloesCards:ClearDelayTime()
  if self.delayAnimTime then
    self.delayAnimTime:Stop()
    self.delayAnimTime = nil
  end
  if self.delayAnimTime1 then
    self.delayAnimTime1:Stop()
    self.delayAnimTime1 = nil
  end
  if self.delayAnimTime2 then
    self.delayAnimTime2:Stop()
    self.delayAnimTime2 = nil
  end
  if self.delayAnimTime3 then
    self.delayAnimTime3:Stop()
    self.delayAnimTime3 = nil
  end
  if self.delayAnimTime4 then
    self.delayAnimTime4:Stop()
    self.delayAnimTime4 = nil
  end
  if self.delayAnimTime5 then
    self.delayAnimTime5:Stop()
    self.delayAnimTime5 = nil
  end
  if self.delayAnimTime6 then
    self.delayAnimTime6:Stop()
    self.delayAnimTime6 = nil
  end
  if self.delayAnimTime7 then
    self.delayAnimTime7:Stop()
    self.delayAnimTime7 = nil
  end
end

function UIGolloesCards:FlipCard(index, img)
  if not self.isAllowClick then
    return
  end
  local flipCard = self.actData.flipCards
  for i = 1, #flipCard do
    if flipCard[i].index == index then
      local param = {}
      param.itemId = flipCard[i].reward[1].itemId
      param.alignObject = img
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
      return
    end
  end
  if self.actEnd then
    return UIUtil.ShowTipsId(300708)
  end
  local remain = self.actData.times - self.actData.cardInfo.flipCount
  if remain <= 0 then
    UIUtil.ShowTipsId(372304)
    return
  end
  local num = self.actData.cardInfo.flipCount
  if num == 0 then
    num = 1
  end
  local count = num
  if self.actData.cost_1[num] == nil then
    count = table.count(self.actData.cost_1)
  end
  local price = self.actData.cost_1[count]
  if tonumber(price) > LuaEntry.Player.gold then
    GoToUtil.GotoPayTips(tonumber(price))
    return
  end
  self.isAllowClick = false
  self.cells[index]:PlayAnimClick()
  local actId = toInt(self.activityId)
  SFSNetwork.SendMessage(MsgDefines.FlipGolloesCard, actId, index)
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Golloes_Show_One_Card, false)
end

function UIGolloesCards:OneGetClick()
  if not self.isAllowClick then
    return
  end
  if self.actEnd then
    return UIUtil.ShowTipsId(300708)
  end
  local remain = self.actData.times - self.actData.cardInfo.flipCount
  if remain < 9 then
    UIUtil.ShowTipsId(372304)
    return
  end
  local price = self.actData.cost_all * (9 - #self.actData.flipCards)
  if not self.oneGet and tonumber(price) > LuaEntry.Player.gold then
    GoToUtil.GotoPayTips(tonumber(price))
    return
  end
  self.actData:SetLastFlipCards()
  self.isAllowClick = false
  local flipCard = self.actData.flipCards
  if #flipCard == 9 then
    SFSNetwork.SendMessage(MsgDefines.RefreshGolloesCard, toInt(self.activityId))
  else
    SFSNetwork.SendMessage(MsgDefines.FlipAllGolloesCard, toInt(self.activityId))
  end
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Golloes_Show_All_Card, false)
end

function UIGolloesCards:OnClickRefresh()
  if self.actEnd then
    return UIUtil.ShowTipsId(300708)
  end
  if not self.isAllowClick then
    return
  end
  if #self.actData.flipCards < 5 then
    local price = self._costRefresh_txt:GetText()
    if price ~= "" and tonumber(price) > LuaEntry.Player.gold then
      GoToUtil.GotoPayTips(tonumber(price))
      return
    end
  end
  local actId = toInt(self.activityId)
  if self.actData.cardInfo.group == 3 and #self.actData.flipCards ~= 9 then
    UIUtil.ShowMessage(Localization:GetString("372303"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      SFSNetwork.SendMessage(MsgDefines.RefreshGolloesCard, actId)
    end)
    return
  end
  self.isAllowClick = false
  SFSNetwork.SendMessage(MsgDefines.RefreshGolloesCard, actId)
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Golloes_Refresh_Card, false)
end

function UIGolloesCards:OnIntroClick()
  UIUtil.ShowIntro(Localization:GetString("372288"), Localization:GetString("100239"), Localization:GetString("372289"))
end

function UIGolloesCards:OnClickPreview()
  if self.actData then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGolloesCardsRP, self.activityId, self.actData.cardInfo.group)
  end
end

function UIGolloesCards:OnClickShop()
  if self.actData then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGolloesCardsExShop, self.activityId)
  end
end

function UIGolloesCards:OnClickRank()
  if self.actData then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGolloesCardsRank, toInt(self.activityId))
  end
end

return UIGolloesCards
