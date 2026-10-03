local SeasonSelectLocationGameRewardTotalComp = BaseClass("SeasonSelectLocationGameRewardTotalComp", UIBaseContainer)
local base = UIBaseContainer
local SeasonSelectLocationGameRewardTotalItem = require("UI.LWSeason5.SeasonSelectLocationGame.Reward.Comp.SeasonSelectLocationGameRewardTotalItem")

function SeasonSelectLocationGameRewardTotalComp:OnCreate()
  base.OnCreate(self)
  self.showDatalist = {}
  self.ScrollView = self:AddComponent(UIScrollView, "")
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
end

function SeasonSelectLocationGameRewardTotalComp:OnDestroy()
  base.OnDestroy(self)
end

function SeasonSelectLocationGameRewardTotalComp:OnEnable()
  base.OnEnable(self)
end

function SeasonSelectLocationGameRewardTotalComp:OnDisable()
  base.OnDisable(self)
end

function SeasonSelectLocationGameRewardTotalComp:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(SeasonSelectLocationGameRewardTotalItem)
  self.showDatalist = {}
end

function SeasonSelectLocationGameRewardTotalComp:RefreshList()
  self:ClearScroll()
  self.showDatalist = {}
  local actCell = DataCenter.SeasonTetrisManager:GetActCell()
  if actCell ~= nil then
    local seasonRankId = checknumber(actCell.rankReward)
    local seasonRankCell = LocalController:instance():getLine(TableName.LW_Season_rank, seasonRankId)
    if seasonRankCell ~= nil then
      local rankArr = string.split(seasonRankCell.rank, "|")
      local rewardArr = string.split(seasonRankCell.reward, "|")
      for i = 1, #rankArr do
        local rankPair = string.split(rankArr[i], "-")
        if #rankPair == 2 then
          local data = {}
          data.minRank = checknumber(rankPair[1])
          data.maxRank = checknumber(rankPair[2])
          data.rewardId = rewardArr[i]
          table.insert(self.showDatalist, data)
        else
          local data = {}
          data.minRank = checknumber(rankArr[i])
          data.maxRank = checknumber(rankArr[i])
          data.rewardId = rewardArr[i]
          table.insert(self.showDatalist, data)
        end
      end
    end
  end
  if #self.showDatalist > 0 then
    self.ScrollView:SetTotalCount(#self.showDatalist)
    self.ScrollView:RefillCells()
  else
  end
end

function SeasonSelectLocationGameRewardTotalComp:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(SeasonSelectLocationGameRewardTotalItem, itemObj)
  cellItem:SetData(self.showDatalist[index])
end

function SeasonSelectLocationGameRewardTotalComp:OnItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, SeasonSelectLocationGameRewardTotalItem)
end

return SeasonSelectLocationGameRewardTotalComp
