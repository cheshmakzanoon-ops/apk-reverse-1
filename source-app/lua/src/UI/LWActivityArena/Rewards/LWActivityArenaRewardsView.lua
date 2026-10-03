local LWActivityArenaRewardsView = BaseClass("LWActivityArenaRewardsView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIRewardsItemFinal = require("UI.LWActivityArena.Rewards.Component.LWActivityArenaRewardsItemFinal")
local UIRewardsItemAchieve = require("UI.LWActivityArena.Rewards.Component.LWActivityArenaRewardsItemAchieve")
local compBook = {
  {
    path = "bg",
    name = "bg",
    type = UIBaseContainer
  },
  {
    path = "top/txtTitle",
    name = "txtTitle",
    type = UIText,
    textKey = "302026"
  },
  {
    path = "top/btnClose",
    name = "btnClose",
    type = UIButton,
    onClick = function(self)
      self.ctrl:CloseSelf(false)
    end
  },
  {
    path = "black",
    name = "btnBlack",
    type = UIButton,
    onClick = function(self)
      self.ctrl:CloseSelf(false)
    end
  },
  {
    path = "tabs/tabAchieve",
    name = "tabAchieve",
    type = UIToggle,
    onValueChanged = function(self, isOn)
      if isOn then
        self:ShowAchieveList()
      end
    end
  },
  {
    path = "tabs/tabAchieve/txtAchieveOff",
    name = "txtAchieveOff",
    type = UIText,
    textKey = "500265"
  },
  {
    path = "tabs/tabAchieve/imgOn/txtAchieveOn",
    name = "txtAchieveOn",
    type = UIText,
    textKey = "500265"
  },
  {
    path = "tabs/tabFinal",
    name = "tabFinal",
    type = UIToggle,
    onValueChanged = function(self, isOn)
      if isOn then
        self:ShowFinalList()
      end
    end
  },
  {
    path = "tabs/tabFinal/txtFinalOff",
    name = "txtFinalOff",
    type = UIText,
    textKey = "372815"
  },
  {
    path = "tabs/tabFinal/imgOn/txtFinalOn",
    name = "txtFinalOn",
    type = UIText,
    textKey = "372815"
  },
  {
    path = "scrollAchieve",
    name = "scrollAchieve",
    type = UIScrollView
  },
  {
    path = "layoutFinal",
    name = "layoutFinal",
    type = nil
  },
  {
    path = "layoutFinal/scrollFinal",
    name = "scrollFinal",
    type = UIScrollView
  },
  {
    path = "layoutFinal/nodeSelf",
    name = "nodeSelf",
    type = UIBaseContainer
  },
  {
    path = "layoutFinal/nodeSelf/ItemSelf",
    name = "itemSelf",
    type = UIRewardsItemFinal
  },
  {
    path = "layoutTips",
    name = "layoutTips",
    type = nil
  },
  {
    path = "layoutTips/txtTips1",
    name = "txtTips1",
    type = UIText,
    textKey = "801119"
  },
  {
    path = "layoutTips/txtTips2",
    name = "txtTips2",
    type = UIText,
    textKey = "372256"
  }
}

function LWActivityArenaRewardsView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:Refresh(self:GetUserData())
  self.timer = TimerManager:GetInstance():GetTimer(1, self.OnTick, self, false, false, false)
  self.timer:Start()
  self:OnTick()
end

function LWActivityArenaRewardsView:OnDestroy()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWActivityArenaRewardsView:ComponentDefine()
  self:DefineCompsByBook(compBook)
  self.achieveCellPool = {}
  self.achieveItemIndex = 1
  self.scrollAchieve:SetOnItemMoveIn(function(itemObj, index)
    self:OnAchieveCreateCell(itemObj, index)
  end)
  self.scrollAchieve:SetOnItemMoveOut(function(itemObj, index)
    self:OnAchieveDeleteCell(itemObj, index)
  end)
  self.finalCellPool = {}
  self.finalItemIndex = 1
  self.scrollFinal:SetOnItemMoveIn(function(itemObj, index)
    self:OnFinalCreateCell(itemObj, index)
  end)
  self.scrollFinal:SetOnItemMoveOut(function(itemObj, index)
    self:OnFinalDeleteCell(itemObj, index)
  end)
end

function LWActivityArenaRewardsView:OnAchieveCreateCell(itemObj, index)
  local achieveItem = self.achieveCellPool[itemObj.name]
  if not achieveItem then
    local name = tostring(self.achieveItemIndex)
    itemObj.name = name
    achieveItem = self.scrollAchieve:AddComponent(UIRewardsItemAchieve, itemObj)
    self.achieveCellPool[name] = achieveItem
    self.achieveItemIndex = self.achieveItemIndex + 1
  end
  local data = self.achieveDatas[index]
  achieveItem:Refresh(data)
end

function LWActivityArenaRewardsView:OnAchieveDeleteCell(itemObj, index)
end

function LWActivityArenaRewardsView:OnFinalCreateCell(itemObj, index)
  local finalItem = self.finalCellPool[itemObj.name]
  if not finalItem then
    local name = "finalItem" .. self.finalItemIndex
    itemObj.name = name
    finalItem = self.scrollFinal:AddComponent(UIRewardsItemFinal, itemObj)
    self.finalCellPool[name] = finalItem
    self.finalItemIndex = self.finalItemIndex + 1
  end
  local data = self.finalDatas[index]
  finalItem:Refresh(data)
end

function LWActivityArenaRewardsView:OnFinalDeleteCell(itemObj, index)
end

function LWActivityArenaRewardsView:ComponentDestroy()
  self.scrollAchieve:ClearCells()
  self.scrollAchieve:RemoveComponents(UIRewardsItemAchieve)
  self.achieveCellPool = {}
  self.scrollFinal:ClearCells()
  self.scrollFinal:RemoveComponents(UIRewardsItemFinal)
  self.finalCellPool = {}
  self:ClearCompsByBook(compBook)
end

local __anchorAchieveId

function LWActivityArenaRewardsView:Refresh(msgTbl)
  __anchorAchieveId = msgTbl.anchorAchieveId
  self.finalDatas = {}
  local finalDataList = msgTbl.rankRewards or {}
  self.nodeSelf:SetActive(false)
  for _, v in ipairs(finalDataList) do
    local rank = v.minRank == v.maxRank and tostring(v.minRank) or v.minRank .. "-" .. v.maxRank
    local badge = v.minRank == v.maxRank and v.minRank < 4
    local rewards = DataCenter.RewardManager:ReturnRewardParamForMessage(v.reward) or {}
    if msgTbl.myRank >= v.minRank and msgTbl.myRank <= v.maxRank then
      self.itemSelf:Refresh({
        rank = msgTbl.myRank,
        rewards = rewards,
        badge = false
      })
      self.nodeSelf:SetActive(true)
    end
    table.insert(self.finalDatas, {
      rank = rank,
      rewards = rewards,
      badge = badge
    })
  end
  self.achieveDatas = {}
  local achieveDataList = msgTbl.achieveRewards or {}
  for _, v in ipairs(achieveDataList) do
    v.rewards = DataCenter.RewardManager:ReturnRewardParamForMessage(v.reward) or {}
    v.myTopRank = msgTbl.topRank
    v.activityId = msgTbl.activityId
    table.insert(self.achieveDatas, v)
  end
  if self.tabAchieve:GetIsOn() then
    self:ShowAchieveList()
  else
    self.tabAchieve:SetIsOn(true)
  end
  self.targetTime = msgTbl.targetTime
  self.txtTips1:SetActive(true)
  self.txtTips2:SetActive(msgTbl.state == ActivityArenaState.Fight)
end

function LWActivityArenaRewardsView:ShowAchieveList()
  self.scrollAchieve:SetActive(true)
  self.layoutFinal:SetActive(false)
  self.layoutTips:SetActive(false)
  self.bg:SetSizeDeltaXY(self.bg:GetSizeDelta().x, 1000)
  table.sort(self.achieveDatas, function(a, b)
    if a.state ~= b.state and (a.state > 1 or b.state > 1) then
      return a.state < b.state
    else
      return a.id > b.id
    end
  end)
  local count = #self.achieveDatas
  self.scrollAchieve:SetTotalCount(count)
  if 0 < count then
    self.scrollAchieve:RefillCells()
  end
  if __anchorAchieveId then
    local index = 0
    for i, data in ipairs(self.achieveDatas) do
      if data.id == __anchorAchieveId then
        index = i
        break
      end
    end
    if 0 < index then
      self.scrollAchieve:ScrollToCell(index, 1000)
    end
  end
end

function LWActivityArenaRewardsView:ShowFinalList()
  self.scrollAchieve:SetActive(false)
  self.layoutFinal:SetActive(true)
  self.layoutTips:SetActive(true)
  self.bg:SetSizeDeltaXY(self.bg:GetSizeDelta().x, 1060)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.layoutFinal.transform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.layoutTips.transform)
  local count = #self.finalDatas
  self.scrollFinal:SetTotalCount(count)
  if 0 < count then
    self.scrollFinal:RefillCells()
  end
end

function LWActivityArenaRewardsView:OnTick()
  if not self.targetTime then
    return
  end
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = self.targetTime - serverTime
  if 0 < remainTime then
    self.txtTips2:SetText(Localization:GetString("372256", UITimeManager:GetInstance():MilliSecondToFmtString(remainTime)))
  else
    self.txtTips2:SetText(Localization:GetString("372256", UITimeManager:GetInstance():MilliSecondToFmtString(0)))
  end
end

return LWActivityArenaRewardsView
