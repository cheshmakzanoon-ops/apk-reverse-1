local UIAllyDuelRewardLeagueSubPanel = BaseClass("UIAllyDuelRewardLeagueSubPanel", UIAsyncContainer)
local base = UIAsyncContainer
local AllyDuelLeagueAllyRewardItem = require("UI.LWUIAllyDuel.LWUIAllyDuelRewardPanel.Component.AllyDuelLeagueAllyRewardItem")

function UIAllyDuelRewardLeagueSubPanel:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIAllyDuelRewardLeagueSubPanel:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIAllyDuelRewardLeagueSubPanel:ComponentDefine()
  self.scrollViewN = self:AddComponent(UIScrollView, "ScrollView")
  self.text = self:AddComponent(UITextMeshProUGUIEx, "Text")
  self.scrollViewN:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scrollViewN:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
end

function UIAllyDuelRewardLeagueSubPanel:ComponentDestroy()
  self:ClearScroll()
  self.scrollViewN = nil
end

function UIAllyDuelRewardLeagueSubPanel:DataDefine()
  self.rewardInfo = nil
  self.curSegment = nil
end

function UIAllyDuelRewardLeagueSubPanel:DataDestroy()
  self.rewardInfo = nil
  self.curSegment = nil
end

function UIAllyDuelRewardLeagueSubPanel:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnLeagueMatchRewardInfoUpdate, self.RefreshAll)
  self:AddUIListener(EventId.AllyDuelLeagueHistory, self.RefreshAll)
  self:AddUIListener(EventId.AllyDuelLeagueRewardDropDown, self.OnDropDown)
end

function UIAllyDuelRewardLeagueSubPanel:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnLeagueMatchRewardInfoUpdate, self.RefreshAll)
  self:RemoveUIListener(EventId.AllyDuelLeagueHistory, self.RefreshAll)
  self:RemoveUIListener(EventId.AllyDuelLeagueRewardDropDown, self.OnDropDown)
end

function UIAllyDuelRewardLeagueSubPanel:ShowPanel(segment)
  self.curSegment = segment
  local weekCount = DataCenter.LeagueMatchManager:GetWeekCount()
  DataCenter.LeagueMatchManager:FetchAlBattleAllWeekVsInfo(weekCount)
  DataCenter.LeagueMatchManager:GetLeagueMatchRewardInfoReq(3)
end

function UIAllyDuelRewardLeagueSubPanel:RefreshAll()
  local require
  self.rewardInfo, require = DataCenter.LeagueMatchManager:GetRewardInfo(3, self.curSegment)
  if table.IsNullOrEmpty(self.rewardInfo) then
    self:ClearScroll()
  else
    self.scrollViewN:SetTotalCount(#self.rewardInfo)
    self.scrollViewN:RefillCells()
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.scrollViewN.transform)
  end
  if require and 0 < require then
    local curScore = DataCenter.LeagueMatchManager:GetMyScoreThisMonth()
    local color = require > curScore and "FF5645" or "25FF00"
    curScore = string.format("<color=#%s> %s </color>", color, string.GetFormattedSeparatorNum(math.floor(curScore)))
    require = string.GetFormattedSeparatorNum(require)
    self.text:SetLocalText("alliance_duel_tips10030", curScore, require)
  end
end

function UIAllyDuelRewardLeagueSubPanel:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scrollViewN:AddComponent(AllyDuelLeagueAllyRewardItem, itemObj)
  cellItem:SetData(self.rewardInfo[index], index)
end

function UIAllyDuelRewardLeagueSubPanel:OnItemMoveOut(itemObj, index)
  self.scrollViewN:RemoveComponent(itemObj.name, AllyDuelLeagueAllyRewardItem)
end

function UIAllyDuelRewardLeagueSubPanel:ClearScroll()
  self.scrollViewN:ClearCells()
  self.scrollViewN:RemoveComponents(AllyDuelLeagueAllyRewardItem)
end

function UIAllyDuelRewardLeagueSubPanel:OnDropDown(index)
  if index == #self.rewardInfo then
    self.scrollViewN:ScrollToCell(index, 2000)
  end
end

return UIAllyDuelRewardLeagueSubPanel
