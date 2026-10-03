local UIPVEAdventureRaid = BaseClass("UIPVEAdventureRaid", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIHeroCellSmall = require("UI.UIHero2.Common.UIHeroCellSmall")
local BattlePveConst = require("Scene.BattlePveModule.Const")
local title_path = "UICommonPopUpTitle/Common_img_title/titleText"
local close_path = "UICommonPopUpTitle/CloseBtn"
local return_path = "UICommonPopUpTitle/panel"
local clear_top_path = "ClearBg/ClearGo/ClearTop"
local clear_bottom_path = "ClearBg/ClearGo/ClearBottom"
local hero_desc_path = "HeroBg/HeroDesc"
local power_path = "HeroBg/Power"
local reward_desc_path = "RewardDesc"
local reward_scroll_path = "RewardScroll"
local reward_content_path = "RewardScroll/RewardContent"
local raid_btn_path = "RaidBtn"
local raid_text_path = "RaidBtn/RaidText"
local hero_path = "HeroBg/HeroList/UIHeroCellSmall_"
local HERO_COUNT = 5

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ClearScroll()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.title_text = self:AddComponent(UIText, title_path)
  self.close_btn = self:AddComponent(UIButton, close_path)
  self.close_btn:SetOnClick(function()
    self:OnCloseClick()
  end)
  self.return_btn = self:AddComponent(UIButton, return_path)
  self.return_btn:SetOnClick(function()
    self:OnCloseClick()
  end)
  self.clear_top_text = self:AddComponent(UIText, clear_top_path)
  self.clear_top_text:SetLocalText(302266, "")
  self.clear_bottom_text = self:AddComponent(UIText, clear_bottom_path)
  self.hero_desc_text = self:AddComponent(UIText, hero_desc_path)
  self.hero_desc_text:SetLocalText(302254)
  self.power_text = self:AddComponent(UIText, power_path)
  self.reward_desc_text = self:AddComponent(UIText, reward_desc_path)
  self.reward_scroll_go = self:AddComponent(UIBaseContainer, reward_scroll_path)
  self.reward_content_sv = self:AddComponent(GridInfinityScrollView, reward_content_path)
  local OnInitCell = BindCallback(self, self.OnInitCell)
  local OnUpdateCell = BindCallback(self, self.OnUpdateCell)
  local OnDestroyCell = BindCallback(self, self.OnDestroyCell)
  self.reward_content_sv:Init(OnInitCell, OnUpdateCell, OnDestroyCell)
  self.raid_btn = self:AddComponent(UIButton, raid_btn_path)
  self.raid_btn:SetOnClick(function()
    self:OnRaidClick()
  end)
  self.raid_text = self:AddComponent(UIText, raid_text_path)
  self.heroes = {}
  for i = 1, HERO_COUNT do
    self.heroes[i] = self:AddComponent(UIHeroCellSmall, hero_path .. i)
  end
end

local function ComponentDestroy(self)
  self.title_text = nil
  self.close_btn = nil
  self.return_btn = nil
  self.clear_top_text = nil
  self.clear_bottom_text = nil
  self.hero_desc_text = nil
  self.power_text = nil
  self.reward_desc_text = nil
  self.reward_scroll_go = nil
  self.reward_content_sv = nil
  self.raid_btn = nil
  self.raid_text = nil
  self.heroes = nil
end

local function DataDefine(self)
  self.itemDict = {}
  self.rewardList = {}
end

local function DataDestroy(self)
  self.itemDict = nil
  self.rewardList = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self:ReInit()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.AdventureRaid, self.OnAdventureRaid)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.AdventureRaid, self.OnAdventureRaid)
  base.OnRemoveListener(self)
end

local function ReInit(self)
  local advInfo = DataCenter.AdventureManager:GetAdventureInfo()
  local heroUuidList = DataCenter.AdventureManager:GetHeroUuidList()
  for i = 1, HERO_COUNT do
    if i <= #heroUuidList then
      self.heroes[i]:SetActive(true)
      self.heroes[i]:SetData(heroUuidList[i])
    else
      self.heroes[i]:SetActive(false)
    end
  end
  if DataCenter.AdventureManager.hasRaidResult then
    self.title_text:SetLocalText(302265)
    self.rewardList = DataCenter.RewardManager:ReturnRewardParamForMessage(advInfo.raidReward) or {}
    self.clear_bottom_text:SetText(advInfo.nowLevel)
    self.raid_btn:SetActive(false)
    self.reward_desc_text:SetLocalText(302267, advInfo.nowLevel)
    DataCenter.AdventureManager.hasRaidResult = false
  else
    self.title_text:SetLocalText(302253)
    self.rewardList = DataCenter.AdventureManager:GetRaidPreviewRewardList(advInfo.maxLevel - 1)
    self.clear_bottom_text:SetText(advInfo.maxLevel)
    self.raid_btn:SetActive(true)
    self.raid_btn:SetInteractable(true)
    self.raid_text:SetLocalText(302253)
    local power = PveActorMgr:GetInstance():GetEmBattleTotalPowerAndHp(true)
    self.power_text:SetText(string.GetFormattedSeperatorNum(power))
    self.reward_desc_text:SetLocalText(300131)
  end
  self.reward_content_sv:SetItemCount(#self.rewardList)
end

local function OnInitCell(self, go, index)
  local item = self.reward_scroll_go:AddComponent(UICommonResItem, go)
  self.itemDict[go] = item
end

local function OnUpdateCell(self, go, index)
  local i = index + 1
  local item = self.itemDict[go]
  go.name = tostring(i)
  item:ReInit(self.rewardList[i])
end

local function OnDestroyCell(self, go, index)
end

local function ClearScroll(self)
  self.reward_scroll_go:RemoveComponents(UICommonResItem)
  self.reward_content_sv:DestroyChildNode()
  self.itemDict = {}
end

local function OnCloseClick(self)
  self.ctrl:CloseSelf()
  local state = DataCenter.AdventureManager:GetAdventureState()
  if state == AdventureState.Won then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPVEResult, BattlePveConst.Result.Win)
  elseif state == AdventureState.Lost then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPVEResult, BattlePveConst.Result.Fail)
  end
end

local function OnRaidClick(self)
  self.raid_btn:SetInteractable(false)
  DataCenter.AdventureManager:SendRaid()
end

local function OnAdventureRaid(self)
  self:ReInit()
end

UIPVEAdventureRaid.OnCreate = OnCreate
UIPVEAdventureRaid.OnDestroy = OnDestroy
UIPVEAdventureRaid.OnEnable = OnEnable
UIPVEAdventureRaid.OnDisable = OnDisable
UIPVEAdventureRaid.ComponentDefine = ComponentDefine
UIPVEAdventureRaid.ComponentDestroy = ComponentDestroy
UIPVEAdventureRaid.DataDefine = DataDefine
UIPVEAdventureRaid.DataDestroy = DataDestroy
UIPVEAdventureRaid.OnAddListener = OnAddListener
UIPVEAdventureRaid.OnRemoveListener = OnRemoveListener
UIPVEAdventureRaid.ReInit = ReInit
UIPVEAdventureRaid.OnInitCell = OnInitCell
UIPVEAdventureRaid.OnUpdateCell = OnUpdateCell
UIPVEAdventureRaid.OnDestroyCell = OnDestroyCell
UIPVEAdventureRaid.ClearScroll = ClearScroll
UIPVEAdventureRaid.OnCloseClick = OnCloseClick
UIPVEAdventureRaid.OnRaidClick = OnRaidClick
UIPVEAdventureRaid.OnAdventureRaid = OnAdventureRaid
return UIPVEAdventureRaid
