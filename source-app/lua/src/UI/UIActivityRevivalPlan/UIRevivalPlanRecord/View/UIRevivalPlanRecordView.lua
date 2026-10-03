local UIRevivalPlanRecordView = BaseClass("UIRevivalPlanRecordView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIRevivalPlanRecordItemComponent = require("UI.UIActivityRevivalPlan.UIRevivalPlanRecord.Component.UIRevivalPlanRecordItemComponent")

function UIRevivalPlanRecordView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UIRevivalPlanRecordView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIRevivalPlanRecordView:ComponentDefine()
  self.btnBlack = self:AddComponent(UIButton, "black")
  self.btnBlack:SetOnClick(function()
    self:OnBtnBlackClick()
  end)
  self.textTxtTitle = self:AddComponent(UIText, "bg/top/txtTitle")
  self.btnClose = self:AddComponent(UIButton, "bg/top/btnClose")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textTotalScoreTitle = self:AddComponent(UIText, "bg/bg2/bg3/totalScoreTitle")
  self.textScore = self:AddComponent(UIText, "bg/bg2/bg3/score")
  self.textTotalRankTitle = self:AddComponent(UIText, "bg/bg2/bg3/totalRankTitle")
  self.textRank = self:AddComponent(UIText, "bg/bg2/bg3/rank")
  self.textStageTitle = self:AddComponent(UIText, "bg/bg2/titleRoot/stageTitle")
  self.textRankTitle = self:AddComponent(UIText, "bg/bg2/titleRoot/rankTitle")
  self.textScoreTitle = self:AddComponent(UIText, "bg/bg2/titleRoot/scoreTitle")
  self.scrollViewScrollView = self:AddComponent(UIScrollView, "bg/bg2/ScrollView")
  self.scrollCellPool = {}
  self.itemIndex = 1
  self.scrollViewScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemCreateCell(itemObj, index)
  end)
  self.scrollViewScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemDeleteCell(itemObj, index)
  end)
  self.textTxtTitle:SetText(Localization:GetString("revival_plan_031"))
  self.textTotalScoreTitle:SetText(Localization:GetString("revival_plan_024"))
  self.textTotalRankTitle:SetText(Localization:GetString("revival_plan_023"))
  self.textStageTitle:SetText(Localization:GetString("revival_plan_032"))
  self.textRankTitle:SetText(Localization:GetString("revival_plan_033"))
  self.textScoreTitle:SetText(Localization:GetString("revival_plan_034"))
end

function UIRevivalPlanRecordView:ComponentDestroy()
  self.btnBlack = nil
  self.textTxtTitle = nil
  self.btnClose = nil
  self.textTotalScoreTitle = nil
  self.textScore = nil
  self.textStageTitle = nil
  self.textRankTitle = nil
  self.textScoreTitle = nil
  self.scrollViewScrollView = nil
end

function UIRevivalPlanRecordView:DataDefine()
end

function UIRevivalPlanRecordView:DataDestroy()
  self:ClearScrollView()
end

function UIRevivalPlanRecordView:OnAddListener()
  base.OnAddListener(self)
end

function UIRevivalPlanRecordView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIRevivalPlanRecordView:ReInit()
  self.activityId = self:GetUserData()
  if self.activityId == nil then
    return
  end
  local stages = DataCenter.RevivalPlanManager:GetStages(self.activityId)
  local count = 0
  if stages then
    count = #stages
  end
  self.dataList = stages
  self.curStage = DataCenter.RevivalPlanManager:GetCurStage(self.activityId)
  self.scrollViewScrollView:SetTotalCount(count)
  if 0 < count then
    self.scrollViewScrollView:RefillCells()
  end
  local totalScore = DataCenter.RevivalPlanManager:GetTotalScore(self.activityId)
  self.textScore:SetText(string.GetFormattedSeperatorNum(totalScore))
  local totalRank = DataCenter.RevivalPlanManager:GetTotalRank(self.activityId)
  self.textRank:SetText(totalRank)
end

function UIRevivalPlanRecordView:OnItemCreateCell(itemObj, index)
  local item = self.scrollCellPool[itemObj.name]
  if not item then
    local name = tostring(self.itemIndex)
    itemObj.name = name
    item = self.scrollViewScrollView:AddComponent(UIRevivalPlanRecordItemComponent, itemObj)
    self.scrollCellPool[name] = item
    self.itemIndex = self.itemIndex + 1
  end
  local cur = false
  if self.dataList and self.curStage then
    cur = self.dataList[index] == self.curStage
  end
  item:SetData(self.activityId, index, cur)
end

function UIRevivalPlanRecordView:OnItemDeleteCell(itemObj, index)
end

function UIRevivalPlanRecordView:ClearScrollView()
  self.scrollViewScrollView:ClearCells()
  self.scrollViewScrollView:RemoveComponents(UIRevivalPlanRecordItemComponent)
  self.scrollCellPool = {}
end

function UIRevivalPlanRecordView:OnBtnBlackClick()
  self.ctrl:CloseSelf()
end

function UIRevivalPlanRecordView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

return UIRevivalPlanRecordView
