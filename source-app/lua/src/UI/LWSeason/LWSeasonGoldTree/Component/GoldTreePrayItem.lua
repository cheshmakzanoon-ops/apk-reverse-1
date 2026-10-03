local base = UIBaseContainer
local GoldTreePrayItem = BaseClass("GoldTreePrayItem", base)
local Localization = CS.GameEntry.Localization
local TxtName_path = "TxtName"
local TxtTime_path = "LockRoot/TxtTime"
local Anim_path = ""
local OpenRoot_path = "OpenRoot"
local RewardRoot_path = "RewardRoot"
local ResultRoot_path = "ResultRoot"
local LockRoot_path = "LockRoot"
local Reward_path = "RewardRoot/Reward/UICommonResItem"
local TxtCount_path = "RewardRoot/TxtCount"
local BackBtn_path = "RewardRoot/BackBtn"
local Icon_path = "ResultRoot/Icon"
local IconCount_path = "ResultRoot/IconCount"
local TxtCount2_path = "ResultRoot/TxtCount2"
local IntroBtn_path = "ResultRoot/IntroBtn"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.TxtName = self:AddComponent(UIText, TxtName_path)
  self.TxtTime = self:AddComponent(UIText, TxtTime_path)
  self.Anim = self:AddComponent(UIAnimator, Anim_path)
  self.OpenRoot = self:AddComponent(UIButton, OpenRoot_path)
  self.RewardRoot = self:AddComponent(UIBaseContainer, RewardRoot_path)
  self.ResultRoot = self:AddComponent(UIBaseContainer, ResultRoot_path)
  self.LockRoot = self:AddComponent(UIButton, LockRoot_path)
  self.Reward = self:AddComponent(UIBaseContainer, Reward_path)
  self.TxtCount = self:AddComponent(UIText, TxtCount_path)
  self.BackBtn = self:AddComponent(UIButton, BackBtn_path)
  self.Icon = self:AddComponent(UIImage, Icon_path)
  self.IconCount = self:AddComponent(UIImage, IconCount_path)
  self.TxtCount2 = self:AddComponent(UIText, TxtCount2_path)
  self.IntroBtn = self:AddComponent(UIButton, IntroBtn_path)
  self.IntroBtn:SetOnClick(function()
    self:ShowCard(true)
  end)
  self.BackBtn:SetOnClick(function()
    self:ShowCard(false)
  end)
  self.OpenRoot:SetOnClick(function()
    if not UIUtil.CheckEventTrigger(OpMode.ClickBtnS4TreePray) then
      DataCenter.SeasonGoldTreeManager:OpenCard(self.day)
    end
  end)
  self.LockRoot:SetOnClick(function()
    if self.EndTime then
      local deltaTime = self.EndTime - UITimeManager:GetInstance():GetServerTime()
      local timeStr = UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime)
      UIUtil.ShowTips(Localization:GetString("season_s4_golden_tree_UI_71", timeStr))
    end
  end)
end

local function ComponentDestroy(self)
  self.TxtName = nil
  self.TxtTime = nil
  self.Anim = nil
  self.OpenRoot = nil
  self.RewardRoot = nil
  self.ResultRoot = nil
  self.LockRoot = nil
  self.Reward = nil
  self.TxtCount = nil
  self.BackBtn = nil
  self.Icon = nil
  self.IconCount = nil
  self.TxtCount2 = nil
  self.IntroBtn = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function GoldTreePrayItem:ReInit(prayData, day)
  self.prayData = prayData
  self.day = day
  self.EndTime = nil
  if prayData then
    if self.isAvailable then
      self.Anim:Play("V_ui_GoldTreeMain_yeqian_in")
    end
    self.isAvailable = false
    self:ShowCard(false)
    return
  end
  self.isAvailable = DataCenter.SeasonGoldTreeManager:IsAvailable(day)
  self.RewardRoot:SetActive(false)
  self.ResultRoot:SetActive(false)
  self.LockRoot:SetActive(not self.isAvailable)
  self.OpenRoot:SetActive(self.isAvailable)
  self.TxtName:SetActive(false)
  if self.isAvailable then
    return
  end
  local nowTime = UITimeManager:GetInstance():GetServerTime()
  local today = UITimeManager:GetInstance():GetNowWeekdayIndex()
  local nextTime = UITimeManager:GetInstance():GetFutureDayZero(nowTime, day - today)
  self.EndTime = nextTime
  self:Update1000MS()
end

function GoldTreePrayItem:ShowCard(isBack)
  self.RewardRoot:SetActive(isBack)
  self.ResultRoot:SetActive(not isBack)
  self.LockRoot:SetActive(false)
  self.OpenRoot:SetActive(false)
  self.TxtName:SetActive(true)
  local prayData = self.prayData
  if not prayData then
    return
  end
  local prayConf = DataCenter.SeasonGoldTreeTemplateManager:GetCardTemp(prayData.cardId)
  local multiplierConf = DataCenter.SeasonGoldTreeTemplateManager:GetCardMultiplierTemp(prayData.multiplierId)
  self.TxtName:SetLocalText(prayConf.name)
  self.Icon:LoadSprite(prayConf.icon)
  self.IconCount:LoadSprite(multiplierConf.icon)
  if isBack then
    self.TxtName:SetLocalText("season_s4_golden_tree_UI_40")
    self.TxtCount:SetText(string.format("\195\151%s", multiplierConf.multiplier))
    if not self.rewardItem then
      self.rewardItem = self:AddComponent(UICommonResItem, Reward_path)
    end
    local reward = prayData:GetFirstReward()
    if reward then
      self.rewardItem:ReInit(reward)
      if reward.count > 1 then
        self.rewardItem:SetItemCount(toInt(reward.count / multiplierConf.multiplier))
      end
    end
  else
    self.TxtCount2:SetText(string.format("\195\151%s", multiplierConf.multiplier))
  end
end

function GoldTreePrayItem:Update1000MS()
  if self.EndTime then
    UIUtil.SetLeftTimeText(self.TxtTime, nil, self.EndTime)
  end
end

GoldTreePrayItem.OnCreate = OnCreate
GoldTreePrayItem.OnDestroy = OnDestroy
GoldTreePrayItem.OnEnable = OnEnable
GoldTreePrayItem.OnDisable = OnDisable
GoldTreePrayItem.ComponentDefine = ComponentDefine
GoldTreePrayItem.ComponentDestroy = ComponentDestroy
GoldTreePrayItem.DataDefine = DataDefine
GoldTreePrayItem.DataDestroy = DataDestroy
return GoldTreePrayItem
