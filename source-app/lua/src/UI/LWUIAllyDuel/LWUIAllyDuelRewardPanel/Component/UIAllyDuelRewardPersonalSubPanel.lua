local LeagueMatchDayRewardPanel = BaseClass("LeagueMatchDayRewardPanel", UIAsyncContainer)
local base = UIAsyncContainer
local UIAllyDuelPersonalRewardItem = require("UI.LWUIAllyDuel.LWUIAllyDuelRewardPanel.Component.UIAllyDuelPersonalRewardItem")
local headRank_path = "BG/TextTitle1"
local headReward_path = "BG/TextTitle2"
local content_path = "RectScroll/ViewPort/Content"

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
  self.headRankN = self:AddComponent(UIText, headRank_path)
  self.headRankN:SetLocalText(302043)
  self.headRewardN = self:AddComponent(UIText, headReward_path)
  self.headRewardN:SetLocalText(302181)
  self.contentN = self:AddComponent(UIBaseContainer, content_path)
end

local function ComponentDestroy(self)
  self:ClearLoadingReq()
  self.headRankN = nil
  self.headRewardN = nil
  self.contentN = nil
end

local function DataDefine(self)
  self.curSegment = nil
  self.rewardList = nil
  self.rewardItems = {}
end

local function DataDestroy(self)
  self.curSegment = nil
  self.rewardList = nil
  self.rewardItems = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnLeagueMatchRewardInfoUpdate, self.RefreshAll)
  self:AddUIListener(EventId.AllianceCompeteRankListUpdated, self.RefreshAll)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnLeagueMatchRewardInfoUpdate, self.RefreshAll)
  self:RemoveUIListener(EventId.AllianceCompeteRankListUpdated, self.RefreshAll)
end

local function ShowPanel(self, segment)
  self.curSegment = segment
  DataCenter.AllianceCompeteDataManager:FetchRankList(0)
end

local function RefreshAll(self)
  self.rewardList = DataCenter.LeagueMatchManager:GetRewardInfo(1, self.curSegment)
  if not self.rewardList then
    return
  end
  local rankList = DataCenter.AllianceCompeteDataManager:GetRankList(0)
  self.myRank = nil
  local myMatchInfo = DataCenter.LeagueMatchManager:GetMyMatchInfo()
  if myMatchInfo and myMatchInfo.duelInfo and myMatchInfo.duelInfo.rankType == self.view.curSegment then
    for i = 1, #rankList do
      local data = rankList[i]
      local uid = data.uid
      if uid ~= nil and uid == LuaEntry.Player.uid then
        self.myRank = i
        break
      end
    end
  end
  local rCnt = #self.rewardList
  local cCnt = #self.rewardItems
  if rCnt > cCnt then
    self:ClearLoadingReq()
    self.reqList = {}
    for i = 1, rCnt do
      local item = self.rewardList[i]
      local cell = self.rewardItems[i]
      if item then
        if cell then
          cell:SetActive(true)
          cell:SetItem(item, self.myRank)
        else
          self:CreateCell(i, item)
        end
      elseif cell then
        cell:SetActive(false)
      end
    end
  else
    self:RefreshRewards()
  end
end

function LeagueMatchDayRewardPanel:CreateCell(index, item)
  self.reqList[index] = self:GameObjectInstantiateAsync(UIAssets.UIAllyDuelPersonalRewardItem, function(request)
    if request.isError then
      return
    end
    self.reqList[index] = nil
    local go = request.gameObject
    go.gameObject:SetActive(true)
    go.transform:SetParent(self.contentN.transform)
    go.transform:Set_localScale(1, 1, 1)
    go.name = "item" .. index
    local cell = self.contentN:AddComponent(UIAllyDuelPersonalRewardItem, go.name)
    self.rewardItems[index] = cell
    cell:SetItem(item, self.myRank)
  end)
end

local function RefreshRewards(self)
  local cnt = #self.rewardList
  for i, v in ipairs(self.rewardItems) do
    if i <= cnt then
      v:SetActive(true)
      v:SetItem(self.rewardList[i], self.myRank)
    else
      v:SetActive(false)
    end
  end
end

local function ClearLoadingReq(self)
  if self.reqList ~= nil then
    for k, v in pairs(self.reqList) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
    self.reqList = nil
  end
end

LeagueMatchDayRewardPanel.OnCreate = OnCreate
LeagueMatchDayRewardPanel.OnDestroy = OnDestroy
LeagueMatchDayRewardPanel.ComponentDefine = ComponentDefine
LeagueMatchDayRewardPanel.ComponentDestroy = ComponentDestroy
LeagueMatchDayRewardPanel.DataDefine = DataDefine
LeagueMatchDayRewardPanel.DataDestroy = DataDestroy
LeagueMatchDayRewardPanel.OnAddListener = OnAddListener
LeagueMatchDayRewardPanel.OnRemoveListener = OnRemoveListener
LeagueMatchDayRewardPanel.ShowPanel = ShowPanel
LeagueMatchDayRewardPanel.RefreshAll = RefreshAll
LeagueMatchDayRewardPanel.ClearLoadingReq = ClearLoadingReq
LeagueMatchDayRewardPanel.RefreshRewards = RefreshRewards
return LeagueMatchDayRewardPanel
