local HeroMonthCardItem = BaseClass("HeroMonthCardItem", UIBaseContainer)
local base = UIBaseContainer
local day_text_path = "day_text"
local item_bg_path = "itemBg"
local lock_icon_path = "lock_icon"
local reward_get_icon_path = "reward_get_icon"
local icon_path = "ItemIcon"
local icon_bg_path = "ItemIconBg"
local num_text_path = "NumText"
local reward_effect_path = "reward_effect"
local btn_path = "btn"
local cover_path = "cover"
local itemCover_path = "ItemCover"
local line_img_path = "LineImg"
local UICommonResItem_path = "UICommonResItem"
local hotContent_path = "hotContent"
local lockcolor = Color.New(0.7450980392156863, 0.7450980392156863, 0.7450980392156863, 1.0)

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.day_text = self:AddComponent(UIText, day_text_path)
  self.itemBg = self:AddComponent(UIImage, item_bg_path)
  self.lock_icon = self:AddComponent(UIImage, lock_icon_path)
  self.reward_get_icon = self:AddComponent(UIImage, reward_get_icon_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.icon_bg = self:AddComponent(UIImage, icon_bg_path)
  self.num_text = self:AddComponent(UIText, num_text_path)
  self.reward_effect = self:AddComponent(UIBaseContainer, reward_effect_path)
  self.cover = self:AddComponent(UIImage, cover_path)
  self.Itemcover = self:AddComponent(UIImage, itemCover_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.line_img = self:AddComponent(UIImage, line_img_path)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnRewardClick()
  end)
  self.uiCommonResItem = self:AddComponent(UICommonResItem, UICommonResItem_path)
  self.hotContent = self:AddComponent(UIBaseContainer, hotContent_path)
end

local function ComponentDestroy(self)
  self.day_text = nil
  self.lock_icon = nil
  self.reward_get_icon = nil
  self.icon = nil
  self.reward = nil
  self.reward_effect = nil
  self.num_text = nil
  self.cover = nil
  self.uiCommonResItem = nil
  self.hotContent = nil
end

local function DataDefine(self)
  self.day = 1
end

local function DataDestroy(self)
  self.day = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshHeroMonthCardSingle, self.DoWhenDayDataChange)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshHeroMonthCardSingle, self.DoWhenDayDataChange)
  base.OnRemoveListener(self)
end

local function SetItem(self, activityId, day, showLine)
  self.activityId = activityId
  self.day = day
  self.showLine = showLine
  self:RefreshUI()
end

local function RefreshUI(self)
  local rewardData = DataCenter.HeroMonthCardManager:GetHeroMonthCardReward(self.activityId, self.day)
  self.showUnlockTip = false
  if rewardData ~= nil then
    self.day_text:SetLocalText(320360, self.day)
    local rewardState = DataCenter.HeroMonthCardManager:GetRewardState(self.activityId, rewardData)
    self.lock_icon:SetActive(rewardState == HeroMonthCardRewardState.REWARD_STATE_LOCK)
    self.reward_get_icon:SetActive(rewardState == HeroMonthCardRewardState.REWARD_STATE_RECEIVED)
    self.reward_effect:SetActive(rewardState == HeroMonthCardRewardState.REWARD_STATE_CAN_RECEIVE)
    if rewardData.reward ~= nil and table.count(rewardData.reward) > 0 then
      local reward = rewardData.reward[1]
      self.uiCommonResItem:ReInit(reward)
    end
    local coverShowFlag = false
    if rewardState == HeroMonthCardRewardState.REWARD_STATE_LOCK then
      local data = DataCenter.HeroMonthCardManager:GetHeroMonthCardInfo(self.activityId)
      if data ~= nil then
        local now = UITimeManager:GetInstance():GetServerTime()
        if now < OneDayTime * 1000 * (self.day - 1) + data.startTime then
          coverShowFlag = true
        else
          self.showUnlockTip = true
        end
      end
    end
    if rewardState == HeroMonthCardRewardState.REWARD_STATE_UNRECEIVED then
      coverShowFlag = true
    end
    self.cover:SetActive(coverShowFlag)
    local data = DataCenter.HeroMonthCardManager:GetHeroMonthCardInfo(self.activityId)
    local template = DataCenter.HeroMonthCardManager:GetTemplate(data.activityId)
    local isHot = template.hotListTab[self.day]
    self.hotContent:SetActive(isHot)
  end
end

local function OnRewardClick(self)
  local rewardData = DataCenter.HeroMonthCardManager:GetHeroMonthCardReward(self.activityId, self.day)
  if rewardData ~= nil then
    local rewardState = DataCenter.HeroMonthCardManager:GetRewardState(self.activityId, rewardData)
    if rewardState == HeroMonthCardRewardState.REWARD_STATE_CAN_RECEIVE then
      DataCenter.HeroMonthCardManager:GetReward(self.activityId, self.day)
    else
      self.uiCommonResItem:OnBtnClick()
    end
  end
  if self.showUnlockTip == true then
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UICommonMessageBar) then
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UICommonMessageBar)
    end
    UIUtil.ShowTipsId(320358, nil, nil, nil, nil, 200)
  end
end

local function DoWhenDayDataChange(self, day)
  self:RefreshUI()
end

HeroMonthCardItem.OnCreate = OnCreate
HeroMonthCardItem.OnDestroy = OnDestroy
HeroMonthCardItem.ComponentDefine = ComponentDefine
HeroMonthCardItem.ComponentDestroy = ComponentDestroy
HeroMonthCardItem.DataDefine = DataDefine
HeroMonthCardItem.DataDestroy = DataDestroy
HeroMonthCardItem.OnAddListener = OnAddListener
HeroMonthCardItem.OnRemoveListener = OnRemoveListener
HeroMonthCardItem.DoWhenDayDataChange = DoWhenDayDataChange
HeroMonthCardItem.SetItem = SetItem
HeroMonthCardItem.RefreshUI = RefreshUI
HeroMonthCardItem.OnRewardClick = OnRewardClick
return HeroMonthCardItem
