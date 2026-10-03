local UIActEpidemicScorePoints = BaseClass("UIActEpidemicScorePoints", UIAsyncContainer)
local base = UIAsyncContainer
local BattlePointItem = require("UI.UIActivityCenterTable.Component.ActEpidemic.BattleSkill.Component.BattlePointItem")

function UIActEpidemicScorePoints:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIActEpidemicScorePoints:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActEpidemicScorePoints:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnFighting = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnFighting:SetOnClick(function()
    self:OnBtnFightingClick()
  end)
  self.btnSummary = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnSummary:SetOnClick(function()
    self:OnBtnSummaryClick()
  end)
  self.btnCooperation = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnCooperation:SetOnClick(function()
    self:OnBtnCooperationClick()
  end)
  self.btnTactics = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnTactics:SetOnClick(function()
    self:OnBtnTacticsClick()
  end)
  self.compActiveNode = self.viewSkin:AddComponent(self, UIBaseComponent, 5)
  self.textTmpActive = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.scrollViewScorePointsRect = self.viewSkin:AddComponent(self, UIScrollView, 7)
  self.compLine = self.viewSkin:AddComponent(self, UIBaseComponent, 8)
  self.compTitleText1 = self.viewSkin:AddComponent(self, UIBaseComponent, 9)
  self.compTitleText2 = self.viewSkin:AddComponent(self, UIBaseComponent, 10)
  self.scrollViewScorePointsRect:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scrollViewScorePointsRect:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
end

function UIActEpidemicScorePoints:ComponentDestroy()
  self.viewSkin = nil
  self.btnFighting = nil
  self.btnSummary = nil
  self.btnCooperation = nil
  self.btnTactics = nil
  self.compActiveNode = nil
  self.textTmpActive = nil
  self.scrollViewScorePointsRect = nil
  self.compLine = nil
  self.compTitleText1 = nil
  self.compTitleText2 = nil
end

function UIActEpidemicScorePoints:DataDefine()
  self.toggleNames = {
    "YiBianJinQu_reward_tips_13",
    "YiBianJinQu_score_type_name_1",
    "YiBianJinQu_score_type_name_2",
    "YiBianJinQu_score_type_name_3"
  }
  self.comps = {
    self.btnSummary,
    self.btnFighting,
    self.btnCooperation,
    self.btnTactics
  }
  for k, v in ipairs(self.toggleNames) do
    local comp = self.comps[k]
    UIUtil.SetTextLit(comp.transform, "Label", v)
  end
  local myScoreType = ActEpidemicUtils.GetMyBattleScoreType()
  local currentSideTemplates = DataCenter.ActEpidemicZoneManager:GetTemplateScoreTypes(myScoreType)
  self.toggleTemplateGroupById = {}
  if not table.IsNullOrEmpty(currentSideTemplates) then
    for _, v in ipairs(currentSideTemplates) do
      self.toggleTemplateGroupById[v.id] = v
    end
  end
  self.isDirty = true
  self.onTipCb = BindCallback(self, self.OnTipClick)
end

function UIActEpidemicScorePoints:DataDestroy()
  self:ClearScrollScorePoint()
  self.currentToggle = nil
  self.toggleCb = nil
  self.tipCb = nil
  self.pointsList = nil
  self.onTipCb = nil
end

function UIActEpidemicScorePoints:OnAddListener()
  base.OnAddListener(self)
end

function UIActEpidemicScorePoints:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIActEpidemicScorePoints:OnBtnFightingClick()
  self:SetCurrentToggleIndex(2)
end

function UIActEpidemicScorePoints:OnBtnSummaryClick()
end

function UIActEpidemicScorePoints:OnBtnCooperationClick()
  self:SetCurrentToggleIndex(3)
end

function UIActEpidemicScorePoints:OnBtnTacticsClick()
  self:SetCurrentToggleIndex(4)
end

function UIActEpidemicScorePoints:SetClickCb(toggleCb, tipCb)
  self.toggleCb = toggleCb
  self.tipCb = tipCb
end

function UIActEpidemicScorePoints:SetDirty()
  self.isDirty = true
end

function UIActEpidemicScorePoints:LineState(bShow)
  self.compLine:SetActive(bShow)
  self.compTitleText1:SetActive(bShow)
  self.compTitleText2:SetActive(bShow)
end

function UIActEpidemicScorePoints:SetCurrentToggleIndex(index)
  if self.currentToggle == index and not self.isDirty then
    return
  end
  self.isDirty = false
  self.currentToggle = index
  if self.comps[self.currentToggle] then
    self.compActiveNode.transform:SetParent(self.comps[self.currentToggle].transform)
    self.compActiveNode:SetLocalPositionXYZ(0, 0, 0)
  end
  local key = self.toggleNames[self.currentToggle] or ""
  self.textTmpActive:SetLocalText(key)
  self:RefreshScoreItems()
  if self.toggleCb then
    self.toggleCb(index)
  end
end

function UIActEpidemicScorePoints:RefreshScoreItems()
  local temp = self.toggleTemplateGroupById[self.currentToggle - 1]
  self.pointsList = temp and temp.showIds or {}
  if #self.pointsList > 0 then
    self.scrollViewScorePointsRect:SetTotalCount(#self.pointsList)
    self.scrollViewScorePointsRect:RefillCells()
  end
end

function UIActEpidemicScorePoints:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local showId = self.pointsList[index]
  local cellItem = self.scrollViewScorePointsRect:AddComponent(BattlePointItem, itemObj)
  if cellItem ~= nil then
    local temp = self.toggleTemplateGroupById[self.currentToggle - 1]
    local icon = temp and temp.icon or nil
    cellItem:ReInit(showId, icon, self.onTipCb)
  end
end

function UIActEpidemicScorePoints:OnItemMoveOut(itemObj, index)
  self.scrollViewScorePointsRect:RemoveComponent(itemObj.name, BattlePointItem)
end

function UIActEpidemicScorePoints:ClearScrollScorePoint()
  self.scrollViewScorePointsRect:ClearCells()
  self.scrollViewScorePointsRect:RemoveComponents(BattlePointItem)
end

function UIActEpidemicScorePoints:OnTipClick(btn, list)
  if self.tipCb then
    self.tipCb(btn, list)
  end
end

return UIActEpidemicScorePoints
