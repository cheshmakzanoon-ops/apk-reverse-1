local base = UIBaseView
local UILWDispatchTaskLogView = BaseClass("UILWDispatchTaskLogView", base)
local UILWDispatchTaskLogItem = require("UI.UILWDispatchTaskLog.Component.UILWDispatchTaskLogItem")
local closeBtn_path = "safeArea/BottomBar/BtnBack"
local title_path = "safeArea/TopBar/TextTitle"
local svTask_path = "safeArea/MiddleContentContainer/ScrollView"
local no_log_txt_path = "safeArea/MiddleContentContainer/noLogTxt"

local function OnCreate(self)
  base.OnCreate(self)
  self.panelType = self:GetUserData()
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshAll()
  if self.panelType == 3 then
    SFSNetwork.SendMessage(MsgDefines.LWSeasonUserDesertHistory)
  end
end

local function OnDestroy(self)
  self:ClearScroll()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtnN:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.titleN = self:AddComponent(UIText, title_path)
  self.titleN:SetLocalText(456210)
  self.svTaskN = self:AddComponent(UIScrollView, svTask_path)
  self.svTaskN:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.svTaskN:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.no_log_txt = self:AddComponent(UIText, no_log_txt_path)
end

local function ComponentDestroy(self)
  self.closeBtnN = nil
  self.titleN = nil
  self.svTaskN = nil
  self.no_log_txt = nil
end

local function DataDefine(self)
  self.logList = {}
end

local function DataDestroy(self)
  self.logList = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonUserDesertHistoryInfoUpdate, self.RefreshAll)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.LWSeasonUserDesertHistoryInfoUpdate, self.RefreshAll)
  base.OnRemoveListener(self)
end

local function RefreshAll(self)
  self:ClearScroll()
  self.logList = nil
  if self.panelType == 1 then
    self.logList = DataCenter.ActDispatchTaskDataManager:GetAllLogList()
  elseif self.panelType == 3 then
    self.logList = DataCenter.SeasonUserDesertHistoryDataManager:GetHistoryDataList()
  end
  if self.logList and #self.logList > 0 then
    self.no_log_txt:SetActive(false)
    self.svTaskN:SetActive(true)
    self.svTaskN:SetTotalCount(#self.logList)
    self.svTaskN:RefillCells()
  else
    if self.panelType == 1 then
      self.no_log_txt:SetLocalText(456221)
    else
      self.no_log_txt:SetLocalText(456221)
    end
    self.no_log_txt:SetActive(true)
    self.svTaskN:SetActive(false)
  end
end

local function OnCreateCell(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.svTaskN:AddComponent(UILWDispatchTaskLogItem, itemObj)
  local logInfo = self.logList[index]
  cellItem:SetItem(logInfo)
end

local function OnDeleteCell(self, itemObj, index)
  self.svTaskN:RemoveComponent(itemObj.name, UILWDispatchTaskLogItem)
end

local function ClearScroll(self)
  self.svTaskN:ClearCells()
  self.svTaskN:RemoveComponents(UILWDispatchTaskLogItem)
end

UILWDispatchTaskLogView.OnCreate = OnCreate
UILWDispatchTaskLogView.OnDestroy = OnDestroy
UILWDispatchTaskLogView.OnAddListener = OnAddListener
UILWDispatchTaskLogView.OnRemoveListener = OnRemoveListener
UILWDispatchTaskLogView.ComponentDefine = ComponentDefine
UILWDispatchTaskLogView.ComponentDestroy = ComponentDestroy
UILWDispatchTaskLogView.DataDefine = DataDefine
UILWDispatchTaskLogView.DataDestroy = DataDestroy
UILWDispatchTaskLogView.OnCreateCell = OnCreateCell
UILWDispatchTaskLogView.OnDeleteCell = OnDeleteCell
UILWDispatchTaskLogView.ClearScroll = ClearScroll
UILWDispatchTaskLogView.RefreshAll = RefreshAll
return UILWDispatchTaskLogView
