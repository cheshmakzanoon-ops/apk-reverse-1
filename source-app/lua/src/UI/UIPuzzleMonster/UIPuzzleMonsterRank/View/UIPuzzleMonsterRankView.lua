local UIPuzzleMonsterRankObj = require("UI.UIPuzzleMonster.UIPuzzleMonsterRank.Component.UIPuzzleMonsterRankObj")
local UIPuzzleMonsterRewardObj = require("UI.UIPuzzleMonster.UIPuzzleMonsterRank.Component.UIPuzzleMonsterRewardObj")
local UIPuzzleMonsterRankView = BaseClass("UIPuzzleMonsterRankView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local txt_title_path = "UICommonPopUpTitle/Common_img_title/titleText"
local close_btn_path = "UICommonPopUpTitle/CloseBtn"
local return_btn_path = "UICommonPopUpTitle/panel"
local toggle1_path = "Tab/Toggle1"
local toggle2_path = "Tab/Toggle2"
local boss_rank_obj_path = "bossRankObj"
local boss_reward_obj_path = "bossRewardObj"

local function OnCreate(self)
  base.OnCreate(self)
  local uuid = self:GetUserData()
  self.uuid = tonumber(uuid)
  DataCenter.ActivityPuzzleDataManager:SendUserGetPuzzleBossRank(self.uuid)
  self.txt_title = self:AddComponent(UIText, txt_title_path)
  self.toggle1 = self:AddComponent(UIToggle, toggle1_path)
  self.toggle1:SetIsOn(true)
  self.toggle1.choose = self.toggle1:AddComponent(UIBaseContainer, "Choose")
  self.toggle2 = self:AddComponent(UIToggle, toggle2_path)
  self.toggle2:SetIsOn(false)
  self.toggle2.choose = self.toggle2:AddComponent(UIBaseContainer, "Choose")
  self.toggle1:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS()
    end
  end)
  self.toggle2:SetOnValueChanged(function(tf)
    if tf then
      self:ToggleControlBorS()
    end
  end)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.boss_rank_obj = self:AddComponent(UIPuzzleMonsterRankObj, boss_rank_obj_path)
  self.boss_reward_obj = self:AddComponent(UIPuzzleMonsterRewardObj, boss_reward_obj_path)
end

local function OnDestroy(self)
  self.txt_title = nil
  self.toggle1 = nil
  self.toggle2 = nil
  self.close_btn = nil
  self.return_btn = nil
  DataCenter.ActivityPuzzleDataManager:ResetBossRankReward()
  base.OnDestroy(self)
end

local function ToggleControlBorS(self)
  self.toggle1.choose:SetActive(self.toggle1:GetIsOn())
  self.toggle2.choose:SetActive(self.toggle2:GetIsOn())
  self:RefreshList()
end

local function OnEnable(self)
  base.OnEnable(self)
  self:ToggleControlBorS()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnPuzzleMonsterRankRefresh, self.RefreshList)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnPuzzleMonsterRankRefresh, self.RefreshList)
end

local function RefreshList(self)
  if self.toggle1:GetIsOn() == true then
    self.txt_title:SetLocalText(302179)
    self.boss_rank_obj:SetActive(true)
    self.boss_reward_obj:SetActive(false)
    self.boss_rank_obj:RefreshData(self.uuid)
  elseif self.toggle2:GetIsOn() == true then
    if DataCenter.ActivityPuzzleDataManager:GetBossRankReward() == nil then
      DataCenter.ActivityPuzzleDataManager:SendGetPuzzleBossRankRewardInfo(self.uuid)
      return
    end
    self.txt_title:SetLocalText(302181)
    self.boss_rank_obj:SetActive(false)
    self.boss_reward_obj:SetActive(true)
    self.boss_reward_obj:RefreshData(self.uuid)
  end
end

UIPuzzleMonsterRankView.OnCreate = OnCreate
UIPuzzleMonsterRankView.OnDestroy = OnDestroy
UIPuzzleMonsterRankView.ToggleControlBorS = ToggleControlBorS
UIPuzzleMonsterRankView.OnEnable = OnEnable
UIPuzzleMonsterRankView.OnDisable = OnDisable
UIPuzzleMonsterRankView.OnAddListener = OnAddListener
UIPuzzleMonsterRankView.OnRemoveListener = OnRemoveListener
UIPuzzleMonsterRankView.RefreshList = RefreshList
return UIPuzzleMonsterRankView
