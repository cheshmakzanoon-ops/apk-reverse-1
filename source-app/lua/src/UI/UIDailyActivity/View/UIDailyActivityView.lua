local base = UIBaseView
local UIDailyActivity = BaseClass("UIDailyActivity", base)
local Localization = CS.GameEntry.Localization
local BarterShopNoticeMain = require("UI.UIActivityCenterTable.Component.BarterShopNotice.BarterShopNoticeMain")
local MineCaveMain = require("UI.UIActivityCenterTable.Component.MineCave.MineCaveMain")
local PuzzleMain = require("UI.UIActivityCenterTable.Component.Puzzle.PuzzleMain")
local UIIndividualOrder = require("UI.UIActivityCenterTable.Component.IndividualOrder.IndividualOrder")
local ArenaMain = require("UI.UIActivityCenterTable.Component.ArenaMain.ArenaMain")
local PanelConfig = {
  [EnumActivity.RallyBossAct.Type] = {
    Prefab = UIAssets.BarterShopNotice,
    Script = BarterShopNoticeMain
  },
  [EnumActivity.IndividualOrder.Type] = {
    Prefab = UIAssets.IndividualOrder,
    Script = UIIndividualOrder
  },
  [EnumActivity.MineCave.Type] = {
    Prefab = UIAssets.MineCave,
    Script = MineCaveMain
  },
  [EnumActivity.Puzzle.Type] = {
    Prefab = UIAssets.UIActivityPuzzle,
    Script = PuzzleMain
  },
  [EnumActivity.Arena.Type] = {
    Prefab = UIAssets.ArenaMain,
    Script = ArenaMain
  }
}
local panelContainer_path = "ImgBg/RightView"
local backBtn_path = "ImgBg/BtnClose"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitUI()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.backBtnN = self:AddComponent(UIButton, backBtn_path)
  self.backBtnN:SetOnClick(function()
    self:OnClickBackBtn()
  end)
  self.panelContainerN = self:AddComponent(UIBaseContainer, panelContainer_path)
end

local function ComponentDestroy(self)
  self.backBtnN = nil
  self.panelContainerN = nil
end

local function DataDefine(self)
  self.model = nil
  self.activityType = nil
  self.activityId = nil
end

local function DataDestroy(self)
  self.model = nil
  self.activityType = nil
  self.activityId = nil
end

local function InitUI(self)
  local overviewType = self:GetUserData()
  local overviewActParam = OverviewTypeToDailyActivity[overviewType]
  if not overviewActParam then
    return
  end
  self.activityType = overviewActParam.Type
  self.activityId = overviewActParam.ActId
  if not self.activityId then
    local actList = DataCenter.ActivityListDataManager:GetActivityDataByType(self.activityType)
    if actList and 0 < #actList then
      self.activityId = actList[1].id
    end
  end
  self:RefreshAll()
end

local function RefreshAll(self)
  if not PanelConfig[self.activityType] then
    return
  end
  local script = PanelConfig[self.activityType].Script
  local prefab = PanelConfig[self.activityType].Prefab
  self.model = self:GameObjectInstantiateAsync(prefab, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go.transform:SetParent(self.panelContainerN.transform)
    go.transform.localScale = ResetScale
    go.name = self.activityType
    local cell = self.panelContainerN:AddComponent(script, go.name)
    cell:SetActive(true)
    self.curPanel = cell
    self:SetPanelData(self.curPanel)
  end)
end

local function SetPanelData(self)
  if self.curPanel and self.curPanel.SetData then
    self.curPanel:SetData(self.activityId)
  end
end

local function ClearPanel(self)
  self.panelContainerN:RemoveComponents()
  if self.model ~= nil then
    self:GameObjectDestroy(self.model)
  end
  self.model = nil
end

local function OnClickBackBtn(self)
  self.ctrl:CloseSelf()
end

UIDailyActivity.OnCreate = OnCreate
UIDailyActivity.OnDestroy = OnDestroy
UIDailyActivity.ComponentDefine = ComponentDefine
UIDailyActivity.ComponentDestroy = ComponentDestroy
UIDailyActivity.DataDefine = DataDefine
UIDailyActivity.DataDestroy = DataDestroy
UIDailyActivity.InitUI = InitUI
UIDailyActivity.RefreshAll = RefreshAll
UIDailyActivity.ClearPanel = ClearPanel
UIDailyActivity.SetPanelData = SetPanelData
UIDailyActivity.OnClickBackBtn = OnClickBackBtn
return UIDailyActivity
