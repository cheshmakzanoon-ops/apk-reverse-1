local AllyDuelLeagueAllyRewardItem = BaseClass("AllyDuelLeagueAllyRewardItem", UIBaseContainer)
local base = UIBaseContainer
local AllyDuelLeaguePersonalRewardItem = require("UI.LWUIAllyDuel.LWUIAllyDuelRewardPanel.Component.AllyDuelLeaguePersonalRewardItem")

function AllyDuelLeagueAllyRewardItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function AllyDuelLeagueAllyRewardItem:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function AllyDuelLeagueAllyRewardItem:ComponentDefine()
  self.rank = self:AddComponent(UIText, "head/rank")
  self.bg = self:AddComponent(UIImage, "head/bg")
  self.contentN = self:AddComponent(UIBaseContainer, "content")
  self.toggle = self:AddComponent(UIToggle, "head/toggle")
  self.toggle:SetOnValueChanged(function(bool)
    self:SetExpand(bool)
  end)
end

function AllyDuelLeagueAllyRewardItem:ComponentDestroy()
  self:ClearLoadingReq()
  self.seasonRankN = nil
  self.headRankN = nil
  self.headRewardN = nil
  self.contentN = nil
end

function AllyDuelLeagueAllyRewardItem:DataDefine()
  self.rewardList = nil
  self.rewardItems = {}
end

function AllyDuelLeagueAllyRewardItem:DataDestroy()
  self.rewardList = nil
  self.rewardItems = nil
end

function AllyDuelLeagueAllyRewardItem:OnAddListener()
  base.OnAddListener(self)
end

function AllyDuelLeagueAllyRewardItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function AllyDuelLeagueAllyRewardItem:SetData(rewardInfo, index)
  self.rewardInfo = rewardInfo
  self.index = index
  self.rewardList = rewardInfo.userRankRewards or {}
  local from = rewardInfo.start
  local to = rewardInfo["end"]
  self.bg:LoadSprite("Assets/Main/Sprites/UI/UIRank/zyf_paihangban_huisetiao.png")
  self.rank:SetColorRGBA(0, 0, 0, 1)
  if from == to then
    self.rank:SetLocalText(459021, from)
    if from == 1 then
      self.bg:LoadSprite("Assets/Main/Sprites/UI/UIRank/zyf_paihangban_jinsetiao.png")
      self.rank:SetColorRGBA(0.81, 0.48, 0.05, 1)
    elseif from == 2 then
      self.bg:LoadSprite("Assets/Main/Sprites/UI/UIRank/zyf_paihangban_yinsetiao.png")
      self.rank:SetColorRGBA(0.4, 0.45, 0.73, 1)
    elseif from == 3 then
      self.bg:LoadSprite("Assets/Main/Sprites/UI/UIRank/zyf_paihangban_tongsetiao.png")
      self.rank:SetColorRGBA(0.71, 0.47, 0.35, 1)
    end
  else
    self.rank:SetLocalText(459021, from .. "~" .. to)
  end
  local isOn = false
  local myMatchInfo = DataCenter.LeagueMatchManager:GetMyMatchInfo()
  if myMatchInfo and myMatchInfo.duelInfo and myMatchInfo.duelInfo.rankType == self.view.curSegment then
    local myCur = DataCenter.LeagueMatchManager:GetMyAllyCurRank()
    if myCur and from <= myCur and to >= myCur then
      isOn = true
    end
  end
  self.isMine = isOn
  if isOn then
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UIRank/zyf_paihangban_lvsetiao.png")
  else
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UIRank/zyf_paihangban_jinsetiao.png")
  end
  self.toggle:SetIsOn(isOn)
  self:SetExpand(self.toggle:GetIsOn())
end

function AllyDuelLeagueAllyRewardItem:ShowRewards()
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
          cell:SetItem(item, self.isMine)
        else
          self:CreateCell(i, item, i == rCnt)
        end
      elseif cell then
        cell:SetActive(false)
      end
    end
  else
    self:RefreshRewards()
  end
end

function AllyDuelLeagueAllyRewardItem:CreateCell(i, item, bLastOne)
  self.reqList[i] = self:GameObjectInstantiateAsync(UIAssets.AllyDuelLeaguePersonalRewardItem, function(request)
    if request.isError then
      return
    end
    self.reqList[i] = nil
    local go = request.gameObject
    go:SetActive(false)
    go.gameObject:SetActive(true)
    go.transform:SetParent(self.contentN.transform)
    go.transform:Set_localScale(1, 1, 1)
    go.name = "item" .. i
    local cell = self.contentN:AddComponent(AllyDuelLeaguePersonalRewardItem, go.name)
    self.rewardItems[i] = cell
    cell:SetItem(item, self.isMine)
    if bLastOne then
      EventManager:GetInstance():Broadcast(EventId.AllyDuelLeagueRewardDropDown, self.index)
    end
  end)
end

function AllyDuelLeagueAllyRewardItem:RefreshRewards()
  local cnt = #self.rewardList
  for i, v in ipairs(self.rewardItems) do
    if i <= cnt then
      v:SetActive(true)
      v:SetItem(self.rewardList[i], self.isMine)
    else
      v:SetActive(false)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.AllyDuelLeagueRewardDropDown, self.index)
end

function AllyDuelLeagueAllyRewardItem:ClearLoadingReq()
  if self.reqList ~= nil then
    for k, v in pairs(self.reqList) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
    self.reqList = nil
  end
end

function AllyDuelLeagueAllyRewardItem:SetExpand(bool)
  self.contentN:SetActive(bool)
  if bool then
    self:ShowRewards()
  end
end

return AllyDuelLeagueAllyRewardItem
