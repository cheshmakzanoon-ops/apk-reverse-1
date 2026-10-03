local LWUIOptionalWeekCardItemRender = BaseClass("LWUIOptionalWeekCardItemRender", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGiftPackagePoint = require("UI.UIGiftPackage.Component.UIGiftPackagePoint")
local LWUIOptionalWeekCardRewardItemRender = require("UI.UIActivityCenterTable.Component.LWUIOptionalWeekCard.LWUIOptionalWeekCardRewardItemRender")
local LWBtnBuyRefundRemind = require("UI.LWBtnBuyRefundRemind.LWBtnBuyRefundRemind")
local unfold_image_path = "RootContent/UnfoldImage"
local unfold_btn_path = "RootContent/UnfoldBtn"
local name_text_path = "RootContent/NameText"
local get_immediately_reward_tips_text_path = "RootContent/GetImmediatelyRewardTipsText"
local get_immediately_reward_content_path = "RootContent/GetImmediatelyRewardScrollView/Viewport/GetImmediatelyRewardContent"
local get_immediately_reward_item_render_path = "RootContent/GetImmediatelyRewardItemRender"
local optional_reward_tips_text_path = "RootContent/OptionalRewardTipsText"
local optional_reward_content_path = "RootContent/OptionalRewardScrollView/Viewport/OptionalRewardContent"
local optional_reward_item_render_path = "RootContent/OptionalRewardItemRender"
local time_text_path = "RootContent/TimeText"
local discount_text_path = "RootContent/DiscountInfo/Bg/DiscountText"
local buy_btn_path = "RootContent/BuyBtn"
local txt_price_path = "RootContent/BuyBtn/Txt_Price"
local ui_gift_package_point_path = "RootContent/BuyBtn/UIGiftPackagePoint"
local receive_reward_btn_path = "RootContent/ReceiveRewardBtn"
local receive_reward_btn_text_path = "RootContent/ReceiveRewardBtn/ReceiveRewardBtnText"
local receive_reward_red_point_path = "RootContent/ReceiveRewardBtn/ReceiveRewardRedPoint"
local receive_reward_red_point_text_path = "RootContent/ReceiveRewardBtn/ReceiveRewardRedPoint/ReceiveRewardRedPointText"
local already_receive_reward_tips_text_path = "RootContent/AlreadyReceiveRewardTipsText"
local unfold_arrow_path = "RootContent/UnfoldArrow"
local close_arrow_path = "RootContent/CloseArrow"
local unfold_content_path = "UnfoldContent"
local can_optional_reward_tips_text_path = "UnfoldContent/CanOptionalRewardTipsText"
local can_optional_reward_scroll_view_path = "UnfoldContent/CanOptionalRewardScrollView"
local can_optional_reward_content_path = "UnfoldContent/CanOptionalRewardScrollView/CanOptionalRewardContent"
local unfold_effect_path = "UnfoldContent/Eff_ui_zixuanzhouka_tishi"
local expired_tips_text_path = "RootContent/ExpiredTipsText"

function LWUIOptionalWeekCardItemRender:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function LWUIOptionalWeekCardItemRender:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIOptionalWeekCardItemRender:DataDefine()
  self.unfoldState = false
  self.listGO = {}
  self.canOptionalShowRewardList = {}
  self.isTimeEnd = false
end

function LWUIOptionalWeekCardItemRender:DataDestroy()
  self.unfoldState = nil
  self.listGO = nil
  self.canOptionalShowRewardList = nil
  self.isTimeEnd = nil
end

function LWUIOptionalWeekCardItemRender:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshOptionalWeekCardRewardSelect, self.OnRefreshSelectReward)
  self:AddUIListener(EventId.RefreshOptionalWeekCardReceiveReward, self.OnRefreshReceiveRewardState)
  self:AddUIListener(EventId.OptionalWeekCardInfoChange, self.OnRefreshAllView)
  self:AddUIListener(EventId.UpdateGiftPackData, self.OnUpdateGiftPackData)
end

function LWUIOptionalWeekCardItemRender:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshOptionalWeekCardRewardSelect, self.OnRefreshSelectReward)
  self:RemoveUIListener(EventId.RefreshOptionalWeekCardReceiveReward, self.OnRefreshReceiveRewardState)
  self:RemoveUIListener(EventId.OptionalWeekCardInfoChange, self.OnRefreshAllView)
  self:RemoveUIListener(EventId.UpdateGiftPackData, self.OnUpdateGiftPackData)
  base.OnRemoveListener(self)
end

function LWUIOptionalWeekCardItemRender:ComponentDefine()
  self.unfold_image = self:AddComponent(UIImage, unfold_image_path)
  self.unfold_btn = self:AddComponent(UIButton, unfold_btn_path)
  self.unfold_btn:SetOnClick(function()
    self:UnfoldBtnClick()
  end)
  self.name_text = self:AddComponent(UIText, name_text_path)
  self.get_immediately_reward_tips_text = self:AddComponent(UIText, get_immediately_reward_tips_text_path)
  self.get_immediately_reward_tips_text:SetLocalText("activity_98600_desc1")
  self.get_immediately_reward_content = self:AddComponent(UIBaseContainer, get_immediately_reward_content_path)
  self.get_immediately_reward_obj = self.transform:Find(get_immediately_reward_item_render_path).gameObject
  self.get_immediately_reward_obj:GameObjectCreatePool()
  self.optional_reward_tips_text = self:AddComponent(UIText, optional_reward_tips_text_path)
  self.optional_reward_tips_text:SetLocalText("activity_98600_desc2")
  self.optional_reward_content = self:AddComponent(UIBaseContainer, optional_reward_content_path)
  self.optional_reward_obj = self.transform:Find(optional_reward_item_render_path).gameObject
  self.optional_reward_obj:GameObjectCreatePool()
  self.time_text = self:AddComponent(UIText, time_text_path)
  self.discount_text = self:AddComponent(UIText, discount_text_path)
  self.buy_btn = self:AddComponent(LWBtnBuyRefundRemind, buy_btn_path)
  self.buy_btn:SetSafeClickMode(true)
  self.buy_btn:SetBuyClickAction(function()
    self:BuyBtnClick()
  end)
  self.receive_reward_btn = self:AddComponent(UIButton, receive_reward_btn_path)
  self.receive_reward_btn:SetOnClick(function()
    self:ReceiveRewardBtnClick()
  end)
  self.receive_reward_btn_text = self:AddComponent(UIText, receive_reward_btn_text_path)
  self.receive_reward_btn_text:SetLocalText(170004)
  self.receive_reward_red_point = self:AddComponent(UIImage, receive_reward_red_point_path)
  self.receive_reward_red_point_text = self:AddComponent(UITextMeshProUGUIEx, receive_reward_red_point_text_path)
  self.already_receive_reward_tips_text = self:AddComponent(UIText, already_receive_reward_tips_text_path)
  self.already_receive_reward_tips_text:SetLocalText("activity_98600_desc8")
  self.unfold_arrow = self:AddComponent(UIImage, unfold_arrow_path)
  self.close_arrow = self:AddComponent(UIImage, close_arrow_path)
  self.unfold_content = self:AddComponent(UIBaseContainer, unfold_content_path)
  self.can_optional_reward_tips_text = self:AddComponent(UIText, can_optional_reward_tips_text_path)
  self.can_optional_reward_tips_text:SetLocalText("activity_98600_desc3")
  self.unfold_effectObj = self.transform:Find(unfold_effect_path).gameObject
  self.expired_tips_text = self:AddComponent(UIText, expired_tips_text_path)
  self.expired_tips_text:SetText("")
end

function LWUIOptionalWeekCardItemRender:ComponentDestroy()
  self:ClearScrollCell()
  self:ClearGetImmediatelyShowReward()
  self:ClearOptionalShowReward()
  self.unfold_image = nil
  self.unfold_btn = nil
  self.name_text = nil
  self.get_immediately_reward_tips_text = nil
  self.get_immediately_reward_content = nil
  self.get_immediately_reward_obj = nil
  self.optional_reward_tips_text = nil
  self.optional_reward_content = nil
  self.optional_reward_obj = nil
  self.time_text = nil
  self.discount_text = nil
  self.buy_btn = nil
  self.receive_reward_btn = nil
  self.receive_reward_btn_text = nil
  self.receive_reward_red_point = nil
  self.already_receive_reward_tips_text = nil
  self.unfold_arrow = nil
  self.close_arrow = nil
  self.unfold_content = nil
  self.can_optional_reward_tips_text = nil
  self.can_optional_reward_scroll_view = nil
  self.can_optional_reward_content = nil
  self.unfold_effectObj = nil
  self.expired_tips_text = nil
end

function LWUIOptionalWeekCardItemRender:OnRefreshSelectReward(param)
  if self.weekCardInfo ~= nil and self.weekCardInfo.cardId == param.cardId then
    self:ShowOptionalReward()
    if self.unfoldState and param.isDelete then
      self:RefreshUnfoldContent()
    end
  end
end

function LWUIOptionalWeekCardItemRender:OnRefreshReceiveRewardState(cardId)
  if self.weekCardInfo ~= nil and self.weekCardInfo.cardId == cardId then
    self:RefreshBuyState()
  end
end

function LWUIOptionalWeekCardItemRender:OnRefreshAllView()
  if self.weekCardInfo ~= nil then
    self:RefreshView()
  end
end

function LWUIOptionalWeekCardItemRender:OnUpdateGiftPackData()
  if self.weekCardInfo ~= nil then
    self.packageInfo = GiftPackManager.get(self.weekCardInfo.exchangeId)
    if not self.packageInfo then
      Logger.LogError(string.format("%s,\230\178\161\230\156\137\232\142\183\229\143\150\229\136\176\231\164\188\229\140\133\230\149\176\230\141\174", self.weekCardInfo.exchangeId))
      self.buy_btn:SetActive(false)
      return
    end
    self:RefreshBuyState()
  end
end

function LWUIOptionalWeekCardItemRender:ReInit(activityId, weekCardInfo)
  self.activityId = activityId
  self.weekCardInfo = weekCardInfo
  self:RefreshView()
end

function LWUIOptionalWeekCardItemRender:RefreshView()
  if self.weekCardInfo ~= nil then
    self.packageInfo = GiftPackManager.get(self.weekCardInfo.exchangeId)
    if not self.packageInfo then
      self:SetActive(false)
      Logger.LogError(string.format("%s,\230\178\161\230\156\137\232\142\183\229\143\150\229\136\176\231\164\188\229\140\133\230\149\176\230\141\174", self.weekCardInfo.exchangeId))
      return
    end
    self:SetActive(true)
    self.name_text:SetLocalText(self.weekCardInfo.name)
    self.discount_text:SetText(tostring(self.weekCardInfo.percent))
    self:RefreshWeekCardTime()
    self:RefreshBuyState()
    self:ShowGetImmediatelyReward()
    self:ShowOptionalReward()
    self:RefreshUnfoldContent()
  end
end

function LWUIOptionalWeekCardItemRender:Update1000MS()
  if self.weekCardInfo ~= nil and self.weekCardInfo.alreadyBuy and not self.isTimeEnd then
    self:RefreshTimerCountdown()
  end
end

function LWUIOptionalWeekCardItemRender:RefreshWeekCardTime()
  if self.weekCardInfo ~= nil then
    if not self.weekCardInfo.alreadyBuy then
      self.time_text:SetLocalText("activity_98600_desc7", self.weekCardInfo.validDays)
    else
      self.expired_tips_text:SetText("")
      self:RefreshTimerCountdown()
    end
  end
end

function LWUIOptionalWeekCardItemRender:RefreshTimerCountdown()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.weekCardInfo ~= nil then
    local surplusTime = self.weekCardInfo.endTime - curTime
    if surplusTime <= 0 then
      self.refreshTime = false
      self.isTimeEnd = true
      if self.time_text then
        self.time_text:SetText()
      end
      self.receive_reward_btn:SetActive(false)
      self.already_receive_reward_tips_text:SetActive(false)
      self.expired_tips_text:SetLocalText("120077")
    elseif self.refreshTime then
      local nextDayTime = UITimeManager:GetInstance():GetNextDayMs()
      local nowTime = UITimeManager:GetInstance():GetServerTime()
      local countDown = nextDayTime - nowTime
      if surplusTime < nextDayTime then
        self.time_text:SetLocalText("activity_98600_desc13", UITimeManager:GetInstance():MilliSecondToFmtString(countDown))
      else
        self.time_text:SetText("")
        self.refreshTime = false
      end
    end
  end
end

function LWUIOptionalWeekCardItemRender:RefreshBuyState()
  if self.weekCardInfo ~= nil then
    self.refreshTime = false
    if not self.weekCardInfo.alreadyBuy then
      self.buy_btn:SetActive(true)
      self.buy_btn:Init(self.packageInfo)
      self.receive_reward_btn:SetActive(false)
      self.already_receive_reward_tips_text:SetActive(false)
      self.buy_btn:RefreshPoint()
    else
      self.buy_btn:SetActive(false)
      local canReceiveReward = self.weekCardInfo:GetCanReceiveReward()
      local showRewardBtn = canReceiveReward and not self.isTimeEnd
      self.receive_reward_btn:SetActive(showRewardBtn)
      if showRewardBtn then
        local canReceiveRewardCount = self.weekCardInfo:GetCanReceiveCount()
        if 0 < canReceiveRewardCount then
          self.receive_reward_red_point_text:SetText(tostring(canReceiveRewardCount))
          self.receive_reward_red_point_text:SetActive(true)
        end
      end
      if not canReceiveReward then
        self.refreshTime = false
        if self.isTimeEnd then
          self.already_receive_reward_tips_text:SetActive(false)
          self.time_text:SetText("")
        else
          self.already_receive_reward_tips_text:SetActive(true)
          if self.weekCardInfo.alreadyReward < self.weekCardInfo.totalReward then
            self.refreshTime = true
            self:RefreshTimerCountdown()
          end
        end
      else
        self.already_receive_reward_tips_text:SetActive(false)
        self.time_text:SetText("")
      end
    end
  end
end

function LWUIOptionalWeekCardItemRender:AsyncCreateImmediatelyReward()
  if not self.asyncImmediatelyRewards or #self.asyncImmediatelyRewards <= 0 then
    self:RemoveImmediatelyRewardsTimer()
    return
  end
  local reward = table.remove(self.asyncImmediatelyRewards)
  if reward then
    local goItem = self.get_immediately_reward_obj:GameObjectSpawn(self.get_immediately_reward_content.transform)
    goItem.name = reward.name
    goItem:SetActive(true)
    local itemRender = self.get_immediately_reward_content:AddComponent(LWUIOptionalWeekCardRewardItemRender, reward.name)
    itemRender:ReInit(self.activityId, reward.index, self.weekCardInfo.cardId, reward.data, reward.isChoose, reward.isShowDelete, reward.isOperate, reward.addBtnAction)
  end
end

function LWUIOptionalWeekCardItemRender:RemoveImmediatelyRewardsTimer()
  if self.timerImmediatelyRewards ~= nil then
    self.timerImmediatelyRewards:Stop()
    self.timerImmediatelyRewards = nil
  end
  self.asyncImmediatelyRewards = nil
end

function LWUIOptionalWeekCardItemRender:ShowGetImmediatelyReward()
  self:ClearGetImmediatelyShowReward()
  local rewards = self.packageInfo:getItems(true)
  if not table.IsNullOrEmpty(rewards) then
    self.asyncImmediatelyRewards = {}
    for i = #rewards, 1, -1 do
      table.insert(self.asyncImmediatelyRewards, {
        index = i,
        name = "item_" .. i,
        data = rewards[i],
        isChoose = false,
        isShowDelete = false,
        isOperate = false
      })
    end
    if #self.asyncImmediatelyRewards > 0 then
      self.timerImmediatelyRewards = TimerManager:GetInstance():GetTimer(1, self.AsyncCreateImmediatelyReward, self, false, true, true)
      self.timerImmediatelyRewards:Start()
    end
  end
end

function LWUIOptionalWeekCardItemRender:ClearGetImmediatelyShowReward()
  self:RemoveImmediatelyRewardsTimer()
  self.get_immediately_reward_content:RemoveComponents(LWUIOptionalWeekCardRewardItemRender)
  self.get_immediately_reward_obj:GameObjectRecycleAll()
end

function LWUIOptionalWeekCardItemRender:AsyncCreateOptionalReward()
  if not self.asyncOptionalRewards or #self.asyncOptionalRewards <= 0 then
    self:RemoveOptionalRewardsTimer()
    return
  end
  local reward = table.remove(self.asyncOptionalRewards)
  if reward then
    local goItem = self.optional_reward_obj:GameObjectSpawn(self.optional_reward_content.transform)
    goItem.name = reward.name
    goItem:SetActive(true)
    local itemRender = self.optional_reward_content:AddComponent(LWUIOptionalWeekCardRewardItemRender, reward.name)
    itemRender:ReInit(self.activityId, reward.index, self.weekCardInfo.cardId, reward.data, reward.isChoose, reward.isShowDelete, reward.isOperate, reward.addBtnAction)
  end
end

function LWUIOptionalWeekCardItemRender:RemoveOptionalRewardsTimer()
  if self.timerOptionalRewards ~= nil then
    self.timerOptionalRewards:Stop()
    self.timerOptionalRewards = nil
  end
  self.asyncOptionalRewards = nil
end

function LWUIOptionalWeekCardItemRender:ShowOptionalReward()
  if self.weekCardInfo ~= nil then
    self:ClearOptionalShowReward()
    self.asyncOptionalRewards = {}
    local regularRewards = self.weekCardInfo:GetRegularReward()
    local regularRewardsCount = table.length(regularRewards)
    if 0 < regularRewardsCount then
      for i = regularRewardsCount, 1, -1 do
        table.insert(self.asyncOptionalRewards, {
          index = i,
          name = "regularItem_" .. i,
          data = regularRewards[i],
          isChoose = false,
          isShowDelete = false,
          isOperate = false
        })
      end
    end
    if 0 < self.weekCardInfo.optionalNum then
      local alreadyChooseRewards = self.weekCardInfo:GetAlreadyChooseReward()
      for i = self.weekCardInfo.optionalNum, 1, -1 do
        local reward = alreadyChooseRewards[i]
        local addBtnAction
        local isShowDelete = false
        if reward == nil then
          function addBtnAction()
            self:UnfoldBtnClick()
          end
        elseif not self.weekCardInfo.alreadyBuy then
          isShowDelete = true
        end
        table.insert(self.asyncOptionalRewards, {
          index = i,
          name = "optionalItem_" .. i,
          data = reward,
          isChoose = false,
          isShowDelete = isShowDelete,
          isOperate = false,
          addBtnAction = addBtnAction
        })
      end
    end
    if #self.asyncOptionalRewards > 0 then
      self.timerOptionalRewards = TimerManager:GetInstance():GetTimer(1, self.AsyncCreateOptionalReward, self, false, true, true)
      self.timerOptionalRewards:Start()
    end
  end
end

function LWUIOptionalWeekCardItemRender:ClearOptionalShowReward()
  self:RemoveOptionalRewardsTimer()
  self.optional_reward_content:RemoveComponents(LWUIOptionalWeekCardRewardItemRender)
  self.optional_reward_obj:GameObjectRecycleAll()
end

function LWUIOptionalWeekCardItemRender:SetUnfoldState(state)
  self.unfoldState = state
  self:RefreshUnfoldContent()
end

function LWUIOptionalWeekCardItemRender:InitUnfoldRewardContent(maxCount)
  if self.can_optional_reward_content then
    return
  end
  self.can_optional_reward_scroll_view = self:AddComponent(UIScrollRect, can_optional_reward_scroll_view_path)
  self.can_optional_reward_content = self:AddComponent(GridInfinityScrollView, can_optional_reward_content_path)
  local bindFunc1 = BindCallback(self, self.OnInitScroll)
  local bindFunc2 = BindCallback(self, self.OnUpdateScroll)
  local bindFunc3 = BindCallback(self, self.OnDestroyScrollItem)
  self.can_optional_reward_content:SetMaxCount(maxCount)
  self.can_optional_reward_content:Init(bindFunc1, bindFunc2, bindFunc3)
end

function LWUIOptionalWeekCardItemRender:RefreshUnfoldContent()
  self.unfold_content:SetActive(self.unfoldState)
  self.unfold_arrow:SetActive(self.unfoldState)
  self.close_arrow:SetActive(not self.unfoldState)
  self.unfold_image:SetActive(self.unfoldState)
  if self.unfoldState and self.weekCardInfo ~= nil then
    self.unfold_effectObj:SetActive(not self.weekCardInfo.alreadyBuy)
    self.canOptionalShowRewardList = self.weekCardInfo:GetOptionalShowReward()
    local rewardCount = #self.canOptionalShowRewardList
    if 0 < rewardCount then
      if not self.can_optional_reward_content then
        self:InitUnfoldRewardContent(rewardCount)
      end
      self.can_optional_reward_content:SetItemCount(rewardCount)
    end
    PostEventLog.Track(PostEventLog.Defines.OpenWeekCardSpecialRewardList, {
      actId = tostring(self.activityId),
      weekCardId = tostring(self.weekCardInfo.cardId)
    })
  else
    self.unfold_effectObj:SetActive(false)
  end
end

function LWUIOptionalWeekCardItemRender:OnInitScroll(go, index)
  local item = self.can_optional_reward_scroll_view:AddComponent(LWUIOptionalWeekCardRewardItemRender, go)
  item:SetActive(false)
  self.listGO[go] = item
end

function LWUIOptionalWeekCardItemRender:OnUpdateScroll(go, index)
  local cellItem = self.listGO[go]
  if cellItem then
    local theIndex = index + 1
    cellItem:SetActive(true)
    local isChoose = false
    local isOperate = false
    if not self.weekCardInfo.alreadyBuy then
      isChoose = self.weekCardInfo:IsSelectReward(theIndex)
      isOperate = true
    end
    cellItem:ReInit(self.activityId, theIndex, self.weekCardInfo.cardId, self.canOptionalShowRewardList[theIndex], isChoose, false, isOperate)
  end
end

function LWUIOptionalWeekCardItemRender:OnDestroyScrollItem(go, index)
end

function LWUIOptionalWeekCardItemRender:ClearScrollCell()
  if not self.can_optional_reward_content then
    return
  end
  self.can_optional_reward_scroll_view:RemoveComponents(LWUIOptionalWeekCardRewardItemRender)
  self.can_optional_reward_content:DestroyChildNode()
end

function LWUIOptionalWeekCardItemRender:UnfoldBtnClick()
  local param = {}
  param.targetCardId = self.weekCardInfo.cardId
  param.isUnfold = not self.unfoldState
  EventManager:GetInstance():Broadcast(EventId.RefreshOptionalWeekCardUnfoldState, param)
end

function LWUIOptionalWeekCardItemRender:BuyBtnClick()
  local activityData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if activityData ~= nil then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local surplusTime = activityData.endTime - curTime
    if surplusTime <= 0 then
      UIUtil.ShowTipsId("370100")
      return
    end
  end
  if self.weekCardInfo ~= nil then
    if 0 < self.weekCardInfo.forwardBuy then
      local preWeekCardInfo = DataCenter.LWOptionalWeekCardManager:GetWeekCardDataById(self.activityId, self.weekCardInfo.forwardBuy)
      if preWeekCardInfo == nil or not preWeekCardInfo.alreadyBuy then
        UIUtil.ShowTipsId("activity_98600_desc4")
        return
      end
    end
    local optionalRewardCount = self.weekCardInfo:GetAlreadyChooseRewardCount()
    if optionalRewardCount < self.weekCardInfo.optionalNum then
      UIUtil.ShowTipsId("activity_98600_desc11")
      return
    end
    UIUtil.ShowMessage(Localization:GetString("activity_98600_desc5"), 2, "", "", function()
      SFSNetwork.SendMessage(MsgDefines.WeekCardSpecialChoose, self.activityId, self.weekCardInfo.cardId, self.weekCardInfo:GetSelectRewardIndexArray())
      self.view.ctrl:BuyGift(self.packageInfo)
    end, nil, nil, 129052)
  end
end

function LWUIOptionalWeekCardItemRender:ReceiveRewardBtnClick()
  SFSNetwork.SendMessage(MsgDefines.WeekCardSpecialReward, self.activityId, self.weekCardInfo.cardId)
end

function LWUIOptionalWeekCardItemRender:TriggerRewardChangeEffect(mustData, selectData)
  if mustData ~= nil then
    local cells = self.get_immediately_reward_content:GetComponents(LWUIOptionalWeekCardRewardItemRender)
    if cells then
      for _, cell in pairs(cells) do
        local itemId = cell:GetItemId()
        if not table.IsNullOrEmpty(mustData.updateData) then
          for i, rewardData in ipairs(mustData.updateData) do
            if itemId and tonumber(itemId) == rewardData.newReward.itemId then
              cell:PlayUpdateEffect()
            end
          end
        end
        if not table.IsNullOrEmpty(mustData.newData) then
          for i, rewardData in ipairs(mustData.newData) do
            if itemId and tonumber(itemId) == rewardData.itemId then
              cell:PlayNewEffect()
            end
          end
        end
      end
    end
  end
  if selectData and (selectData.updateData ~= nil or selectData.newData ~= nil) then
    if self.unfoldState == false then
      self:UnfoldBtnClick()
    end
    local cells = self.can_optional_reward_scroll_view:GetComponents(LWUIOptionalWeekCardRewardItemRender)
    if cells then
      for _, cell in pairs(cells) do
        local itemId = cell:GetItemId()
        if not table.IsNullOrEmpty(selectData.updateData) then
          for i, rewardData in ipairs(selectData.updateData) do
            if itemId and tonumber(itemId) == rewardData.newReward.itemId then
              cell:PlayUpdateEffect()
            end
          end
        end
        if not table.IsNullOrEmpty(selectData.newData) then
          for i, rewardData in ipairs(selectData.newData) do
            if itemId and tonumber(itemId) == rewardData.itemId then
              cell:PlayNewEffect()
            end
          end
        end
      end
    end
  end
end

return LWUIOptionalWeekCardItemRender
