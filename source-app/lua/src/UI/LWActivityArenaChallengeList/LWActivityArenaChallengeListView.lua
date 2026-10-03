local LWActivityArenaChallengeListView = BaseClass("LWActivityArenaChallengeList", UIBaseView)
local base = UIBaseView
local ChallengeItem = require("UI.LWActivityArenaChallengeList.Component.LWActivityArenaChallengeItem")
local ItemPath = "Assets/Main/Prefabs/UI/LWPVPArena/LWUIArenaNewbieV2ChallengeItem.prefab"
local Localization = CS.GameEntry.Localization
local compBook = {
  {
    path = "bg/bg_top/txtTitle",
    name = "txtTitle",
    type = UIText
  },
  {
    path = "bg/bg_top/btnClose",
    name = "btnClose",
    type = UIButton
  },
  {
    path = "txtRemainTimes",
    name = "txtRemainTimes",
    type = UIText
  },
  {
    path = "scrollHeros",
    name = "scrollHeros",
    type = UIScrollRect
  },
  {
    path = "scrollHeros/Viewport/Content",
    name = "contentHeros",
    type = UIBaseContainer
  },
  {
    path = "btnFreeRefresh",
    name = "btnFreeRefresh",
    type = UIButton
  },
  {
    path = "btnFreeRefresh/txtFreeRefresh",
    name = "txtFreeRefresh",
    type = UIText
  },
  {
    path = "btnRefresh",
    name = "btnRefresh",
    type = UIButton
  },
  {
    path = "btnRefresh/txtRefresh",
    name = "txtRefresh",
    type = UIText
  },
  {
    path = "btnRefresh/CostLayout/costIcon",
    name = "imgCostIcon",
    type = UIImage
  },
  {
    path = "btnRefresh/CostLayout/costValue",
    name = "txtCostValue",
    type = UIText
  },
  {
    path = "noRefreshTip",
    name = "txtNoRefreshTip",
    type = UIText
  },
  {
    path = "black",
    name = "btnBlack",
    type = UIButton
  }
}

function LWActivityArenaChallengeListView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  local info, arenaType = self:GetUserData()
  self.activityId = info.activityId
  self.arenaType = arenaType or 0
  self:Refresh(info)
end

function LWActivityArenaChallengeListView:OnDestroy()
  self:ClearList()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWActivityArenaChallengeListView:ComponentDefine()
  self.heroCells = {}
  self:DefineCompsByBook(compBook)
  self.txtFreeRefresh:SetText(Localization:GetString("new_arena_refresh_free"))
  self.txtRefresh:SetText(Localization:GetString("new_arena_refresh_normal"))
  self.txtNoRefreshTip:SetText(Localization:GetString("new_arena_refresh_max"))
  self.imgCostIcon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Gold))
  self.btnClose:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.btnFreeRefresh:SetOnClick(function()
    self:OnFreeRefreshBtnClick()
  end)
  self.btnRefresh:SetOnClick(function()
    self:OnRefreshBtnClick()
  end)
  self.btnBlack:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
end

function LWActivityArenaChallengeListView:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function LWActivityArenaChallengeListView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActivityArenaBattleListPush, self.OnBattleListPush)
end

function LWActivityArenaChallengeListView:OnRemoveListener()
  self:RemoveUIListener(EventId.ActivityArenaBattleListPush, self.OnBattleListPush)
  base.OnRemoveListener(self)
end

function LWActivityArenaChallengeListView:OnBattleListPush(msgTbl)
  if not self.activityId then
    return
  end
  local ac = msgTbl.activityId
  if not ac then
    return
  end
  if tonumber(self.activityId) ~= tonumber(ac) then
    return
  end
  self:Refresh(msgTbl)
end

function LWActivityArenaChallengeListView:Refresh(info)
  self.refreshCount = info.refreshCount
  if self.refreshPrice == nil then
    local price = info.refresh_price
    if not string.IsNullOrEmpty(price) then
      local priceList = string.split(price, "|")
      self.refreshPrice = {}
      for i = 1, #priceList do
        table.insert(self.refreshPrice, tonumber(priceList[i]))
      end
    end
  end
  local battleList = info.battleList
  if battleList and 1 < #battleList then
    table.sort(battleList, function(a, b)
      if a.rank ~= b.rank then
        return a.rank < b.rank
      end
      return a.playerId < b.playerId
    end)
  end
  self:RefreshList(battleList)
  self.btnFreeRefresh:SetActive(false)
  self.btnRefresh:SetActive(false)
  self.txtNoRefreshTip:SetActive(false)
  self.costGold = 0
  if self.refreshCount >= #self.refreshPrice then
    self.txtNoRefreshTip:SetActive(true)
  else
    local cost = self.refreshPrice[self.refreshCount + 1]
    self.costGold = cost
    if 0 < cost then
      self.txtCostValue:SetText(string.GetFormattedSeperatorNum(cost))
      self.btnRefresh:SetActive(true)
    else
      self.btnFreeRefresh:SetActive(true)
    end
  end
  if self.arenaType == PVPArenaType.NewbieArenaV2 then
    local arenaInfo = DataCenter.LWNewbieArenaV2Manager.info
    if arenaInfo then
      self.txtRemainTimes:SetActive(arenaInfo.state == ActivityArenaState.Fight)
      self.txtRemainTimes:SetText(Localization:GetString("801109", arenaInfo.remainFree))
    end
  end
end

function LWActivityArenaChallengeListView:ClearList()
  self.contentHeros:RemoveComponents(ChallengeItem)
  if self.heroCells then
    for _, cell in pairs(self.heroCells) do
      if not IsNull(cell) then
        self:GameObjectDestroy(cell)
      end
    end
  end
  self.heroCells = {}
end

function LWActivityArenaChallengeListView:RefreshList(battleList)
  self:ClearList()
  if not battleList then
    return
  end
  local length = #battleList
  for i = 1, length do
    local rankData = battleList[i]
    rankData.canChallenge = DataCenter.LWNewbieArenaV2Manager:GetState() == ActivityArenaState.Fight and tostring(rankData.playerId) ~= tostring(LuaEntry.Player.uid)
    if self.arenaType == PVPArenaType.NewbieArenaV2 then
      local rank = rankData.rank
      if rank >= DataCenter.LWNewbieArenaV2Manager.notRecordRank then
        rankData.rankText = Localization:GetString("new_arena_no_rank")
      end
    end
    if self.heroCells[i] == nil then
      self.heroCells[i] = self:GameObjectInstantiateAsync(ItemPath, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go:SetActive(true)
        go.transform:SetParent(self.contentHeros.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.name = i
        local item = self.contentHeros:AddComponent(ChallengeItem, go)
        item:Refresh(rankData, self.arenaType)
      end)
    end
  end
end

function LWActivityArenaChallengeListView:OnFreeRefreshBtnClick()
  if not self.activityId then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.ActivityArenaRefresh, self.activityId)
end

function LWActivityArenaChallengeListView:OnRefreshBtnClick()
  if not self.activityId then
    return
  end
  local gold = LuaEntry.Player.gold
  if self.costGold > 0 and gold < self.costGold then
    GoToUtil.GotoPayTips(self.costGold)
  else
    SFSNetwork.SendMessage(MsgDefines.ActivityArenaRefresh, self.activityId)
  end
end

return LWActivityArenaChallengeListView
