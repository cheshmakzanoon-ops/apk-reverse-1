local ScratchOffRankingPage = BaseClass("ScratchOffRankingPage", UIBaseContainer)
local base = UIBaseContainer
local UIScratchOffRankItem = require("UI.UIActivityCenterTable.Component.ScratchOffGame.UIScratchOffRankItem")

function ScratchOffRankingPage:OnCreate()
  base.OnCreate(self)
  self._selfInfo = self:AddComponent(UIScratchOffRankItem, "VerticalLayout/SelfPlayerItem")
  self._selfInfo:SetActive(false)
  self.scroll_view = self:AddComponent(UILoopListView2, "VerticalLayout/RankingScroll")
  self.scroll_view:InitListView(0, function(loopView, index)
    return self:OnGetRankItemByIndex(loopView, index)
  end)
  self.scroll_view_content = self:AddComponent(UIBaseContainer, "VerticalLayout/RankingScroll/Viewport/RankingContent")
  self.rewardItems = {}
  self.rankingRewards = self:AddComponent(UIBaseContainer, "VerticalLayout/RankingRewards")
  self.content = self:AddComponent(UIBaseContainer, "VerticalLayout/RankingRewards/RewardsScroll/Viewport/Content")
  self.rankingRewardBtn = self:AddComponent(UIButton, "VerticalLayout/RankingRewards/RankingRewardBtn")
  self.rankingRewardBtn:SetOnClick(function()
    self:OnRankingRewardBtn()
  end)
  self.rankingRewards:SetActive(false)
  self._noRank_txt = self:AddComponent(UIText, "VerticalLayout/NoRankingText")
  self.itemIndex = 0
end

function ScratchOffRankingPage:ClearRewardItems()
  if self.content and not string.IsNullOrEmpty(self.rewardItems) then
    self.content:RemoveComponents(UICommonResItem)
  end
  for i, v in pairs(self.rewardItems) do
    self:GameObjectDestroy(v)
  end
  self.rewardItems = {}
end

function ScratchOffRankingPage:OnDestroy()
  self:ClearRewardItems()
  self:ClearScroll()
  base.OnDestroy(self)
end

function ScratchOffRankingPage:OnEnable()
  base.OnEnable(self)
end

function ScratchOffRankingPage:SetData(activityId, id)
  self.activityId = id
  self.actId = activityId
  if not self.activityId then
    return
  end
  self:RefreshRank(self.actId)
end

function ScratchOffRankingPage:OnDisable()
  base.OnDisable(self)
end

function ScratchOffRankingPage:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ScratchOffGameRankInfoUpdate, self.OnRefresh)
end

function ScratchOffRankingPage:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ScratchOffGameRankInfoUpdate, self.OnRefresh)
end

function ScratchOffRankingPage:RefreshRank(activityId)
  self.activityId = activityId
  SFSNetwork.SendMessage(MsgDefines.GetScratchOffGameRankInfo, activityId)
end

function ScratchOffRankingPage:OnRankingRewardBtn()
  if not table.IsNullOrEmpty(self.rewardArr) then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIScratchOffRankingRewardPage, {anim = true}, DeepCopy(self.rewardArr))
  end
end

function ScratchOffRankingPage:OnRefresh()
  self.actData = DataCenter.ScratchOffGameManager:GetRankInfoByActId(tonumber(self.activityId))
  if self.actData then
    self.rankList = self.actData.rankList
    self.rewardArr = self.actData.rankReward
    local selfRank = self.actData.selfRank
    if selfRank == -1 then
      selfRank = 1
    end
    self:ClearRewardItems()
    if selfRank ~= -1 then
      self.rewardList = {}
      for i = 1, #self.rewardArr do
        if selfRank >= self.rewardArr[i].startN and selfRank <= self.rewardArr[i].endN then
          self.rewardList = self.rewardArr[i].reward
          break
        end
      end
      if self.rewardList and next(self.rewardList) then
        self.rankingRewards:SetActive(true)
        for k, v in pairs(self.rewardList) do
          self.rewardItems[k] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
            if request.isError then
              return
            end
            local go = request.gameObject
            go:SetActive(true)
            go.transform:SetParent(self.content.transform)
            go.transform:Set_localScale(0.75, 0.75, 0.75)
            go.transform:Set_sizeDelta(92, 95)
            go.transform.pivot = Vector2.New(0.5, 0.5)
            local nameStr = tostring(k)
            go.name = nameStr
            local comp = self.content:AddComponent(UICommonResItem, nameStr)
            comp:ReInit(self.rewardList[k])
          end)
        end
      else
        self.rankingRewards:SetActive(false)
      end
    else
      self.rankingRewards:SetActive(false)
    end
    if self.rankList and #self.rankList > 0 then
      self.scroll_view:SetListItemCount(#self.rankList, false, false)
      self.scroll_view:RefreshAllShownItem()
      self._selfInfo:SetActive(true)
      self._noRank_txt:SetActive(false)
      local showData = {}
      showData.score = self.actData.selfScore
      showData.name = LuaEntry.Player.name
      showData.rank = self.actData.selfRank
      showData.uid = LuaEntry.Player.uid
      showData.headBg = LuaEntry.Player:GetHeadBgImg()
      if LuaEntry.Player:IsInAlliance() then
        local allInfo = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
        showData.abbr = allInfo.abbr
      end
      self._selfInfo:RefreshData(showData, true)
    else
      self._noRank_txt:SetActive(true)
      self._noRank_txt:SetLocalText(110534)
      self._selfInfo:SetActive(false)
    end
  end
end

function ScratchOffRankingPage:OnGetRankItemByIndex(loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.rankList then
    return nil
  end
  local item = loopScroll:NewListViewItem("LeaderBoardPlayerItem")
  local script = self.scroll_view_content:GetComponent(item.gameObject.name, UIScratchOffRankItem)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    script = self.scroll_view_content:AddComponent(UIScratchOffRankItem, objectName)
  end
  script:SetActive(true)
  script:RefreshData(self.rankList[index], false)
  return item
end

function ScratchOffRankingPage:ClearScroll()
  self.scroll_view_content:RemoveComponents(UIScratchOffRankItem)
  self.scroll_view:ClearAllItems()
  self.itemIndex = 0
end

function ScratchOffRankingPage:OnClickSelfHead()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, LuaEntry.Player.uid)
end

return ScratchOffRankingPage
