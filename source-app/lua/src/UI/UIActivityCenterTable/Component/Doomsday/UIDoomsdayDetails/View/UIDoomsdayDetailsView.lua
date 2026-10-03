local base = UIBaseView
local UIDoomsdayDetailsView = BaseClass("UIDoomsdayDetailsView", base)
local Notifier = require("Common.Notifier")
local Localization = CS.GameEntry.Localization
local AchievePage = require("UI.UIActivityCenterTable.Component.Doomsday.UIDoomsdayDetails.Component.UIDoomsdayAchievePage")
local RankPage = require("UI.UIActivityCenterTable.Component.Doomsday.UIDoomsdayDetails.Component.UIDoomsdayRankPage")
local RewardPage = require("UI.UIActivityCenterTable.Component.Doomsday.UIDoomsdayDetails.Component.UIDoomsdayRewardPage")

local function __SelectTab(self, tab)
  self.currTab = tab
  self.tabAchieveOn:SetActive(tab == "achieve")
  self.pageAchieve:SetActive(tab == "achieve")
  if tab == "achieve" then
    if self.achieveVOs then
      self.pageAchieve:Refresh(self.achieveVOs)
    else
      self.pageAchieve:Clear()
      SFSNetwork.SendMessage(MsgDefines.ActivityDoomsdayQuestInfo)
    end
    self.txtTitle:SetLocalText("500265")
  end
  self.tabRankOn:SetActive(tab == "rank")
  self.pageRank:SetActive(tab == "rank")
  if tab == "rank" then
    if self.rankVOs then
      self.pageRank:Refresh(self.rankVOs)
    else
      self.pageRank:Clear()
      SFSNetwork.SendMessage(MsgDefines.ActivityDoomsdayQuestRankInfo)
    end
    self.txtTitle:SetLocalText("456006")
  end
  self.tabRewardOn:SetActive(tab == "reward")
  self.pageReward:SetActive(tab == "reward")
  if tab == "reward" then
    if self.rewardVOs then
      self.pageReward:Refresh(self.rewardVOs)
    else
      self.pageReward:Clear()
      SFSNetwork.SendMessage(MsgDefines.ActivityDoomsdayQuestRankShowInfo)
    end
    self.txtTitle:SetLocalText("372351")
  end
end

local function __OnNetResp(self, tab, voArr)
  if tab == "achieve" then
    self.achieveVOs = voArr
    if self.currTab == "achieve" then
      self.pageAchieve:Refresh(self.achieveVOs)
    end
  elseif tab == "rank" then
    self.rankVOs = voArr
    if self.currTab == "rank" then
      self.pageRank:Refresh(self.rankVOs)
    end
  elseif tab == "reward" then
    self.rewardVOs = voArr
    if self.currTab == "reward" then
      self.pageReward:Refresh(self.rewardVOs)
    end
  end
end

local function __UpdateSingleQuest(self, uuid, state)
  if self.achieveVOs then
    for _, vo in ipairs(self.achieveVOs) do
      if vo.uuid == uuid then
        vo.canRecieve = state == 1 and not vo.hasRecieved
        if self.currTab == "achieve" then
          self.pageAchieve:Refresh(self.achieveVOs)
        end
        return
      end
    end
  end
end

local compBook = {
  {
    path = "black",
    name = "btnBlack",
    type = UIButton,
    onClick = function(self)
      self.ctrl:CloseSelf()
    end
  },
  {
    path = "root/btnClose",
    name = "btnBlack",
    type = UIButton,
    onClick = function(self)
      self.ctrl:CloseSelf()
    end
  },
  {
    path = "root/txtTitle",
    name = "txtTitle",
    type = UIText
  },
  {
    path = "root/tabs/tabAchieve",
    name = "tabAchieve",
    type = UIButton,
    onClick = function(self)
      __SelectTab(self, "achieve")
    end
  },
  {
    path = "root/tabs/tabRank",
    name = "tabRank",
    type = UIButton,
    onClick = function(self)
      __SelectTab(self, "rank")
    end
  },
  {
    path = "root/tabs/tabReward",
    name = "tabReward",
    type = UIButton,
    onClick = function(self)
      __SelectTab(self, "reward")
    end
  },
  {
    path = "root/tabs/tabAchieve/achieveOn",
    name = "tabAchieveOn",
    type = nil,
    active = false
  },
  {
    path = "root/tabs/tabRank/rankOn",
    name = "tabRankOn",
    type = nil,
    active = false
  },
  {
    path = "root/tabs/tabReward/rewardOn",
    name = "tabRewardOn",
    type = nil,
    active = false
  },
  {
    path = "root/PageAchieve",
    name = "pageAchieve",
    type = AchievePage,
    active = false
  },
  {
    path = "root/PageRank",
    name = "pageRank",
    type = RankPage,
    active = false
  },
  {
    path = "root/PageReward",
    name = "pageReward",
    type = RewardPage,
    active = false
  }
}

function UIDoomsdayDetailsView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  __SelectTab(self, self:GetUserData() or "achieve")
end

function UIDoomsdayDetailsView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIDoomsdayDetailsView:OnAddListener()
  base.OnAddListener(self)
  self.notiBook = {}
  Notifier.AddListener("UIDoomsday.RefreshAchieve", function(self, voArr)
    __OnNetResp(self, "achieve", voArr)
  end, self, self.notiBook)
  Notifier.AddListener("UIDoomsday.RefreshRank", function(self, voArr)
    __OnNetResp(self, "rank", voArr)
  end, self, self.notiBook)
  Notifier.AddListener("UIDoomsday.RefreshReward", function(self, voArr)
    __OnNetResp(self, "reward", voArr)
  end, self, self.notiBook)
  Notifier.AddListener("UIDoomsday.UpdateSingleReward", __UpdateSingleQuest, self, self.notiBook)
end

function UIDoomsdayDetailsView:OnRemoveListener()
  Notifier.RemoveListenerByBook(self.notiBook)
  base.OnRemoveListener(self)
end

function UIDoomsdayDetailsView:ComponentDefine()
  self:DefineCompsByBook(compBook)
end

function UIDoomsdayDetailsView:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

return UIDoomsdayDetailsView
