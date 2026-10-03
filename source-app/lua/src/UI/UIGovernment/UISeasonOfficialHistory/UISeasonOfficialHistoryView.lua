local base = UIBaseView
local UISeasonOfficialHistoryView = BaseClass("UISeasonOfficialHistoryView", base)
local SeasonOfficialHistoryCell = require("UI.UIGovernment.UISeasonOfficialHistory.SeasonOfficialHistoryCell")
local Localization = CS.GameEntry.Localization
local titleText_path = "Root/Content/UICommonPopBg/bg_3/TitleTxt"
local closeBtn_path = "Root/Content/UICommonPopBg/bg_3/CloseBtn"
local scrollView_path = "Root/Content/ContentHolder/ScrollView"
local nonePanel_path = "Root/Content/ContentHolder/NonePanel"
local noneTipText_path = "Root/Content/ContentHolder/NonePanel/NoneTipText"
local closePanel_path = "Panel"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Refresh()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.titleText = self:AddComponent(UIText, titleText_path)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.scrollView = self:AddComponent(UIScrollView, scrollView_path)
  self.nonePanel = self:AddComponent(UIBaseContainer, nonePanel_path)
  self.noneTipText = self:AddComponent(UIText, noneTipText_path)
  self.closePanel = self:AddComponent(UIButton, closePanel_path)
  self.closeBtn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.closePanel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
end

local function ComponentDestroy(self)
  self:ClearScroll()
  self.titleText = nil
  self.closeBtn = nil
  self.scrollView = nil
  self.nonePanel = nil
  self.noneTipText = nil
  self.closePanel = nil
end

local function DataDefine(self)
  self.serverId, self.buildingId, self.config = self:GetUserData()
  DataCenter.BuildingOfficialManager:FetchKingdomBuildingPositionRecord(self.serverId, self.buildingId, self.config.id)
end

local function DataDestroy(self)
  self.config = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.KingdomBuildingPositionHistory, self.Refresh)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.KingdomBuildingPositionHistory, self.Refresh)
  base.OnRemoveListener(self)
end

local function Refresh(self)
  self.appointLogList = DataCenter.BuildingOfficialManager:GetOfficialHistory(self.serverId, self.buildingId, self.config.id)
  if self.appointLogList and #self.appointLogList > 0 then
    self.scrollView:SetActive(true)
    self.nonePanel:SetActive(false)
    self.scrollView:SetTotalCount(#self.appointLogList)
    self.scrollView:RefillCells()
  else
    self.scrollView:SetActive(false)
    self.nonePanel:SetActive(true)
  end
end

local function OnItemMoveIn(self, itemObj, index)
  itemObj.name = tostring("SeasonOfficialHistoryCell" .. index)
  local cellItem = self.scrollView:AddComponent(SeasonOfficialHistoryCell, itemObj)
  cellItem:SetData(self.config.id, self.appointLogList[index])
end

local function OnItemMoveOut(self, itemObj, index)
  self.scrollView:RemoveComponent(itemObj.name, SeasonOfficialHistoryCell)
end

local function ClearScroll(self)
  self.scrollView:RemoveComponents(SeasonOfficialHistoryCell)
  self.scrollView:ClearCells()
end

UISeasonOfficialHistoryView.OnCreate = OnCreate
UISeasonOfficialHistoryView.OnDestroy = OnDestroy
UISeasonOfficialHistoryView.OnEnable = OnEnable
UISeasonOfficialHistoryView.OnDisable = OnDisable
UISeasonOfficialHistoryView.ComponentDefine = ComponentDefine
UISeasonOfficialHistoryView.ComponentDestroy = ComponentDestroy
UISeasonOfficialHistoryView.DataDefine = DataDefine
UISeasonOfficialHistoryView.DataDestroy = DataDestroy
UISeasonOfficialHistoryView.OnItemMoveIn = OnItemMoveIn
UISeasonOfficialHistoryView.OnItemMoveOut = OnItemMoveOut
UISeasonOfficialHistoryView.ClearScroll = ClearScroll
UISeasonOfficialHistoryView.OnAddListener = OnAddListener
UISeasonOfficialHistoryView.OnRemoveListener = OnRemoveListener
UISeasonOfficialHistoryView.Refresh = Refresh
return UISeasonOfficialHistoryView
