local UIPuzzleMonsterCreateCell = require("UI.UIPuzzleMonster.UIPuzzleMonsterCreate.Component.UIPuzzleMonsterCreateCell")
local UIPuzzleMonsterCreateView = BaseClass("UIPuzzleMonsterCreateView", UIBaseView)
local PuzzleRewardInfo = require("UI.UIPuzzleMonster.UIPuzzleMonsterCreate.Component.PuzzleRewardInfo")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local txt_title_path = "UICommonMidPopUpTitle/titleText"
local close_btn_path = "UICommonMidPopUpTitle/CloseBtn"
local return_btn_path = "UICommonMidPopUpTitle/panel"
local scroll_path = "ImgBg/ScrollView"
local reward_content_path = "DetectEventInfoGo"
local trigger_path = "trigger"

local function OnCreate(self)
  base.OnCreate(self)
  DataCenter.ActivityPuzzleDataManager:SendGetPuzzleBossMarch()
  self.txt_title = self:AddComponent(UIText, txt_title_path)
  self.txt_title:SetLocalText(372246)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.ScrollView = self:AddComponent(UIScrollView, scroll_path)
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.showDatalist = {}
  self.event_trigger = self:AddComponent(UIEventTrigger, trigger_path)
  self.event_trigger:OnPointerUp(function(eventData)
    self:HideRewardList()
  end)
  self:HideRewardList()
end

local function OnDestroy(self)
  self:HideRewardList()
  self.txt_title = nil
  self.close_btn = nil
  self.return_btn = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:RefreshList()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnPuzzleMonsterDataRefresh, self.RefreshList)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnPuzzleMonsterDataRefresh, self.RefreshList)
end

local function RefreshList(self)
  self:ClearScroll()
  self.showDatalist = self.ctrl:GetPanelData()
  self.ScrollView:SetTotalCount(#self.showDatalist)
  self.ScrollView:RefillCells()
end

local function ClearScroll(self)
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(UIPuzzleMonsterCreateCell)
  self.showDatalist = {}
end

local function OnItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(UIPuzzleMonsterCreateCell, itemObj)
  cellItem:SetItemShow(self.showDatalist[index])
end

local function OnItemMoveOut(self, itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, UIPuzzleMonsterCreateCell)
end

local function ShowRewardInfo(self, rewardList, pos, isLeftArrow)
  if self.rewardInfoPanel == nil then
    self.rewardInfoPanel = self:AddComponent(PuzzleRewardInfo, reward_content_path)
  end
  self.rewardInfoPanel:SetData(rewardList, pos, isLeftArrow)
  self.rewardInfoPanel:SetActive(true)
  self.event_trigger:SetActive(true)
end

local function HideRewardList(self)
  self.event_trigger:SetActive(false)
  if self.rewardInfoPanel ~= nil then
    self.rewardInfoPanel:SetActive(false)
  end
end

UIPuzzleMonsterCreateView.HideRewardList = HideRewardList
UIPuzzleMonsterCreateView.OnCreate = OnCreate
UIPuzzleMonsterCreateView.OnDestroy = OnDestroy
UIPuzzleMonsterCreateView.OnEnable = OnEnable
UIPuzzleMonsterCreateView.OnDisable = OnDisable
UIPuzzleMonsterCreateView.OnAddListener = OnAddListener
UIPuzzleMonsterCreateView.OnRemoveListener = OnRemoveListener
UIPuzzleMonsterCreateView.RefreshList = RefreshList
UIPuzzleMonsterCreateView.ClearScroll = ClearScroll
UIPuzzleMonsterCreateView.OnItemMoveIn = OnItemMoveIn
UIPuzzleMonsterCreateView.OnItemMoveOut = OnItemMoveOut
UIPuzzleMonsterCreateView.ShowRewardInfo = ShowRewardInfo
return UIPuzzleMonsterCreateView
