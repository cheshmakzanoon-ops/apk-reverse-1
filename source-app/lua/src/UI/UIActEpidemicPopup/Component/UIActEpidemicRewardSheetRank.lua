local base = UIAsyncContainer
local UIActEpidemicRewardSheetRank = BaseClass("UIActEpidemicRewardSheetRank", base)
local UIActEpidemicRewardSheetRankItem = require("UI.UIActEpidemicPopup.Component.UIActEpidemicRewardSheetRankItem")
local HEIGHT_1 = 490
local HEIGHT_2 = 350
local sp_prefab = "Assets/Main/Prefabs/UI/BF_Epidemic/UIActivity/UIActEpidemicScorePoints.prefab"
local sp_cls = "UI.UIActEpidemicPopup.Component.UIActEpidemicScorePoints"
local tip_prefab = "Assets/Main/Prefabs/UI/BF_Epidemic/UIActivity/UIActEpidemicScorePointsTipRoot.prefab"
local tip_cls = "UI.UIActEpidemicPopup.Component.UIActEpidemicScorePointsTipRoot"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.ScrollView = self.viewSkin:AddComponent(self, UIScrollView, 1)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseComponent, 2)
  self.compMyRank = self.viewSkin:AddComponent(self, UIActEpidemicRewardSheetRankItem, 3)
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnRankItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnRankItemMoveOut(itemObj, index)
  end)
  self.toggleCb = BindCallback(self, self.SetCurrentToggleIndex)
  self.compScorePoints = self:LoadComponentAsync(sp_cls, sp_prefab, self, function(comp)
    self.compScorePoints:SetAsFirstSibling()
    self.compScorePoints:LineState(false)
    self.compScorePoints:SetAnchoredPositionXY(60, 0)
    if self.compBtnTipRoot ~= nil and self.compBtnTipRoot:AsyncLoadDone() then
      self.compScorePoints:SetClickCb(self.toggleCb, self.compBtnTipRoot.tipCb)
      self.compScorePoints:SetCurrentToggleIndex(2)
    end
  end)
  self.compBtnTipRoot = self:LoadComponentAsync(tip_cls, tip_prefab, self, function(comp)
    self.compBtnTipRoot:SetAsLastSibling()
    self.compBtnTipRoot:SetOffsetMinXY(0, 0)
    self.compBtnTipRoot:SetOffsetMaxXY(0, 0)
    self.compBtnTipRoot:SetSizeDeltaXY(0, 2600)
    self.compBtnTipRoot:SetActive(false)
    if self.compScorePoints ~= nil and self.compScorePoints:AsyncLoadDone() then
      self.compScorePoints:SetClickCb(self.toggleCb, self.compBtnTipRoot.tipCb)
      self.compScorePoints:SetCurrentToggleIndex(2)
    end
  end)
end

local function ComponentDestroy(self)
  self:ClearScroll()
  self.viewSkin = nil
  self.ScrollView = nil
  self.compContent = nil
  self.compMyRank = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.toggleCb = nil
  self.myRank = nil
  self.myRankData = nil
end

function UIActEpidemicRewardSheetRank:RefreshSheet(role)
  self.currentRole = role
  if self.compScorePoints ~= nil and self.compScorePoints:AsyncLoadDone() then
    local target = self.currentToggle == nil and 2 or self.currentToggle
    self.compScorePoints:SetCurrentToggleIndex(target)
  end
end

function UIActEpidemicRewardSheetRank:SetCurrentToggleIndex(index)
  self.currentToggle = index
  self.rankList = DataCenter.ActEpidemicZoneManager:GetRankBattleReward(self.currentRole, self.currentToggle)
  self:RefreshMyRank()
  self:RefreshScrollView()
end

function UIActEpidemicRewardSheetRank:RefreshMyRank()
  local myRankInfo = DataCenter.ActEpidemicZoneManager:GetMyScoreRankInfo()
  self.myRank = 0
  if not myRankInfo then
    self.myRank = 0
  elseif self.currentToggle == 1 then
    self.myRank = myRankInfo.scoreRank or 0
  elseif self.currentToggle == 2 then
    self.myRank = myRankInfo.battleRank or 0
  elseif self.currentToggle == 3 then
    self.myRank = myRankInfo.cooperationRank or 0
  elseif self.currentToggle == 4 then
    self.myRank = myRankInfo.tacticsRank or 0
  end
  self.myRankData = nil
  if self.rankList and self.myRank > 0 then
    for k, v in ipairs(self.rankList) do
      local fR = v.from or 0
      local tR = v.to or 0
      if fR <= self.myRank and tR >= self.myRank then
        self.myRankData = v
        break
      end
    end
  end
  if self.myRankData then
    self.compMyRank:SetActive(true)
    local w, h = self.ScrollView:GetSizeDeltaXY()
    h = HEIGHT_2
    self.ScrollView:SetSizeDeltaXY(w, h)
    self.compMyRank:ReInit(0, self.myRankData, self.myRank)
  else
    self.compMyRank:SetActive(false)
    local w, h = self.ScrollView:GetSizeDeltaXY()
    h = HEIGHT_1
    self.ScrollView:SetSizeDeltaXY(w, h)
  end
end

function UIActEpidemicRewardSheetRank:RefreshScrollView()
  if #self.rankList > 0 then
    self.ScrollView:SetTotalCount(#self.rankList)
    self.ScrollView:RefillCells()
  end
end

function UIActEpidemicRewardSheetRank:OnRankItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(UIActEpidemicRewardSheetRankItem, itemObj)
  if cellItem ~= nil then
    cellItem:ReInit(index, self.rankList[index], self.myRank)
  end
end

function UIActEpidemicRewardSheetRank:OnRankItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, UIActEpidemicRewardSheetRankItem)
end

function UIActEpidemicRewardSheetRank:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(UIActEpidemicRewardSheetRankItem)
end

function UIActEpidemicRewardSheetRank:RefreshCurrentRole(role)
  self.currentRole = role
  if self.compScorePoints ~= nil and self.compScorePoints:AsyncLoadDone() then
    self.compScorePoints:SetDirty()
  end
  self:RefreshSheet(self.currentRole)
end

function UIActEpidemicRewardSheetRank:UpdateCurrentRole(role)
  self.currentRole = role
  if self.compScorePoints ~= nil and self.compScorePoints:AsyncLoadDone() then
    self.compScorePoints:SetDirty()
  end
end

UIActEpidemicRewardSheetRank.OnCreate = OnCreate
UIActEpidemicRewardSheetRank.OnDestroy = OnDestroy
UIActEpidemicRewardSheetRank.OnEnable = OnEnable
UIActEpidemicRewardSheetRank.OnDisable = OnDisable
UIActEpidemicRewardSheetRank.ComponentDefine = ComponentDefine
UIActEpidemicRewardSheetRank.ComponentDestroy = ComponentDestroy
UIActEpidemicRewardSheetRank.DataDefine = DataDefine
UIActEpidemicRewardSheetRank.DataDestroy = DataDestroy
return UIActEpidemicRewardSheetRank
