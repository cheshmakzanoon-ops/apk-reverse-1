local UIRevivalPlanTaskView = BaseClass("UIRevivalPlanTaskView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIRevivalPlanTaskItemComponent = require("UI.UIActivityRevivalPlan.UIRevivalPlanTask.Component.UIRevivalPlanTaskItemComponent")

function UIRevivalPlanTaskView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UIRevivalPlanTaskView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIRevivalPlanTaskView:ComponentDefine()
  self.btnBlack = self:AddComponent(UIButton, "black")
  self.btnBlack:SetOnClick(function()
    self:OnBtnBlackClick()
  end)
  self.textTxtTitle = self:AddComponent(UIText, "bg/top/txtTitle")
  self.btnClose = self:AddComponent(UIButton, "bg/top/btnClose")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.scrollViewScrollView = self:AddComponent(UIScrollView, "bg/bg2/ScrollView")
  self.scrollCellPool = {}
  self.itemIndex = 1
  self.scrollViewScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemCreateCell(itemObj, index)
  end)
  self.scrollViewScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemDeleteCell(itemObj, index)
  end)
  self.textTxtTitle:SetText(Localization:GetString("revival_plan_030"))
end

function UIRevivalPlanTaskView:ComponentDestroy()
  self.btnBlack = nil
  self.textTxtTitle = nil
  self.btnClose = nil
  self.scrollViewScrollView = nil
end

function UIRevivalPlanTaskView:DataDefine()
end

function UIRevivalPlanTaskView:DataDestroy()
  self:ClearScrollView()
end

function UIRevivalPlanTaskView:OnAddListener()
  base.OnAddListener(self)
end

function UIRevivalPlanTaskView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIRevivalPlanTaskView:ReInit()
  local stageData = self:GetUserData()
  self.stageId = stageData.stageId
  self.hideBtn = stageData.hideBtn
  local cfg = DataCenter.ActivityRevivalConfigTemplateManager:GetTemplate(self.stageId)
  if cfg == nil then
    return
  end
  local data = cfg.get_score_rules
  self.dataList = data or {}
  local count = #self.dataList
  self.scrollViewScrollView:SetTotalCount(count)
  if 0 < count then
    self.scrollViewScrollView:RefillCells()
  end
end

function UIRevivalPlanTaskView:OnItemCreateCell(itemObj, index)
  local item = self.scrollCellPool[itemObj.name]
  if not item then
    local name = tostring(self.itemIndex)
    itemObj.name = name
    item = self.scrollViewScrollView:AddComponent(UIRevivalPlanTaskItemComponent, itemObj)
    self.scrollCellPool[name] = item
    self.itemIndex = self.itemIndex + 1
  end
  item:SetData(self.dataList[index], self.hideBtn)
end

function UIRevivalPlanTaskView:OnItemDeleteCell(itemObj, index)
end

function UIRevivalPlanTaskView:ClearScrollView()
  self.scrollViewScrollView:ClearCells()
  self.scrollViewScrollView:RemoveComponents(UIRevivalPlanTaskItemComponent)
  self.scrollCellPool = {}
end

function UIRevivalPlanTaskView:OnBtnBlackClick()
  self.ctrl:CloseSelf()
end

function UIRevivalPlanTaskView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

return UIRevivalPlanTaskView
