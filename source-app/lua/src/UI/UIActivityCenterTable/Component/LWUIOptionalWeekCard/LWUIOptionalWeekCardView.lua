local LWUIOptionalWeekCardView = BaseClass("LWUIOptionalWeekCardView", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local LWUIOptionalWeekCardItemRender = require("UI.UIActivityCenterTable.Component.LWUIOptionalWeekCard.LWUIOptionalWeekCardItemRender")
local LWUIActivityRewardChangePreviewEntranceComponent = require("UI/LWUIActivityRewardChangePreview/AccuRecharge/Component/LWUIActivityRewardChangePreviewEntranceComponent")
local title_text_path = "Root/TopContent/TitleText"
local sub_title_text_path = "Root/TopContent/SubTitleText"
local info_btn_path = "Root/TopContent/InfoBtn"
local remain_time_text_path = "Root/TopContent/TimeContent/RemainTimeText"
local optional_week_card_content_path = "Root/OptionalWeekCardScrollView/Viewport/OptionalWeekCardContent"
local optional_weed_card_item_render_path = "Root/UILWOptionalWeedCardItemRender"
local reward_change_entrance_path = "Root/TopContent/RewardChangeBtn"

function LWUIOptionalWeekCardView:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function LWUIOptionalWeekCardView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIOptionalWeekCardView:DataDefine()
  self.optionalWeekCardItemRenderList = {}
  self.showMessageTips = false
end

function LWUIOptionalWeekCardView:DataDestroy()
  self.optionalWeekCardItemRenderList = nil
  self.showMessageTips = nil
end

function LWUIOptionalWeekCardView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshOptionalWeekCardUnfoldState, self.OnRefreshUnfoldState)
end

function LWUIOptionalWeekCardView:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshOptionalWeekCardUnfoldState, self.OnRefreshUnfoldState)
  base.OnRemoveListener(self)
end

function LWUIOptionalWeekCardView:OnRefreshUnfoldState(param)
  if not table.IsNullOrEmpty(self.optionalWeekCardItemRenderList) then
    for i = 1, #self.optionalWeekCardItemRenderList do
      local itemRender = self.optionalWeekCardItemRenderList[i]
      if itemRender.weekCardInfo then
        if itemRender.weekCardInfo.cardId == param.targetCardId then
          itemRender:SetUnfoldState(param.isUnfold)
          CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.optional_week_card_content.transform)
          if param.isUnfold then
            local targetSizeDelta = itemRender:GetSizeDelta()
            local posY = (i - 1) * targetSizeDelta.y
            self.optional_week_card_content:SetAnchoredPositionXY(self.optional_week_card_content:GetAnchoredPositionX(), posY)
          end
        else
          itemRender:SetUnfoldState(false)
        end
      end
    end
  end
end

function LWUIOptionalWeekCardView:ComponentDefine()
  self.title_text = self:AddComponent(UIText, title_text_path)
  self.sub_title_text = self:AddComponent(UIText, sub_title_text_path)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.info_btn:SetOnClick(function()
    self:InfoBtnClick()
  end)
  self.remain_time_text = self:AddComponent(UIText, remain_time_text_path)
  self.optional_week_card_content = self:AddComponent(UIBaseContainer, optional_week_card_content_path)
  self.optional_week_card_obj = self.transform:Find(optional_weed_card_item_render_path).gameObject
  self.optional_week_card_obj:GameObjectCreatePool()
  self.comp_reward_change_entrance = self:AddComponent(LWUIActivityRewardChangePreviewEntranceComponent, reward_change_entrance_path)
  self.optional_week_card_obj:SetActive(false)
end

function LWUIOptionalWeekCardView:ComponentDestroy()
  self:ClearScroll()
  self.title_text = nil
  self.sub_title_text = nil
  self.info_btn = nil
  self.remain_time_text = nil
  self.optional_week_card_content = nil
  self.optional_week_card_obj = nil
  self.comp_reward_change_entrance = nil
end

function LWUIOptionalWeekCardView:Update1000MS()
  self:RefreshTimerCountdown()
end

function LWUIOptionalWeekCardView:SetData(activityId)
  self.activityId = activityId
  PostEventLog.Track(PostEventLog.Defines.OpenWeekCardSpecial, {
    actId = tostring(self.activityId)
  })
  self:UpdateView()
end

function LWUIOptionalWeekCardView:UpdateView()
  self.activityData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if self.activityData ~= nil then
    self.title_text:SetLocalText(self.activityData.name)
    self.sub_title_text:SetLocalText(self.activityData.desc_info)
    self:RefreshTimerCountdown()
    self:CreateWeekCardItem()
  end
  self.comp_reward_change_entrance:ReInit(self.activityData, function(data)
    self:OnRewardChangeClose(data)
  end, true)
end

function LWUIOptionalWeekCardView:RefreshTimerCountdown()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.activityData ~= nil then
    local surplusTime = self.activityData.endTime - curTime
    if 0 < surplusTime and self.remain_time_text then
      self.remain_time_text:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(surplusTime))
    end
    if surplusTime <= 0 and not self.showMessageTips then
      if self.remain_time_text then
        self.remain_time_text:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(0))
      end
      self.showMessageTips = true
      
      local function closeSelf()
        self.view.ctrl:CloseSelf()
      end
      
      UIUtil.ShowMessage(Localization:GetString("370100"), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, closeSelf, closeSelf, closeSelf, "2900005")
    end
  end
end

function LWUIOptionalWeekCardView:AsyncCreateItems()
  if not self.asyncItems or #self.asyncItems <= 0 then
    self:RemoveItemsTimer()
    return
  end
  local item = table.remove(self.asyncItems)
  if item then
    local goItem = self.optional_week_card_obj:GameObjectSpawn(self.optional_week_card_content.transform)
    goItem.name = item.name, goItem:SetActive(true)
    local itemRender = self.optional_week_card_content:AddComponent(LWUIOptionalWeekCardItemRender, item.name)
    itemRender:ReInit(tonumber(self.activityId), item.data)
    table.insert(self.optionalWeekCardItemRenderList, itemRender)
  end
end

function LWUIOptionalWeekCardView:RemoveItemsTimer()
  if self.timerItemsCreator ~= nil then
    self.timerItemsCreator:Stop()
    self.timerItemsCreator = nil
  end
  self.asyncItems = nil
end

function LWUIOptionalWeekCardView:CreateWeekCardItem()
  self:ClearScroll()
  self.optionalWeekCardItemRenderList = {}
  local weekCardData = DataCenter.LWOptionalWeekCardManager:GetWeekCardData(tonumber(self.activityId))
  if weekCardData and 0 < #weekCardData then
    self.asyncItems = {}
    for i = #weekCardData, 1, -1 do
      table.insert(self.asyncItems, {
        index = i,
        name = "item_" .. i,
        data = weekCardData[i]
      })
    end
    if 0 < #self.asyncItems then
      self.timerItemsCreator = TimerManager:GetInstance():GetTimer(1, self.AsyncCreateItems, self, false, true, true)
      self.timerItemsCreator:Start()
    end
  end
end

function LWUIOptionalWeekCardView:ClearScroll()
  self:RemoveItemsTimer()
  self.optional_week_card_content:RemoveComponents(LWUIOptionalWeekCardItemRender)
  self.optional_week_card_obj:GameObjectRecycleAll()
end

function LWUIOptionalWeekCardView:InfoBtnClick()
  if self.activityData ~= nil then
    local param = {}
    param.activityRulesStr = Localization:GetString(self.activityData.story)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end
end

function LWUIOptionalWeekCardView:OnRewardChangeClose(data)
  if not data or not self.optional_week_card_content then
    return
  end
  local items = self.optional_week_card_content:GetComponents(LWUIOptionalWeekCardItemRender)
  if items then
    for i, item in pairs(items) do
      if item.weekCardInfo and item.TriggerRewardChangeEffect then
        if item.weekCardInfo.order == 1 then
          item:TriggerRewardChangeEffect(data.normalMustData, data.normalSelectData)
        elseif item.weekCardInfo.order == 2 then
          item:TriggerRewardChangeEffect(data.advanceMustData, data.advanceSelectData)
        end
      end
    end
  end
end

return LWUIOptionalWeekCardView
