local base = UIBaseView
local UIDispatchTaskRecordView = BaseClass("UIDispatchTaskRecordView", base)
local UIDispatchTaskRecordItem = require("UI.UIDispatchTask.Record.Component.UIDispatchTaskRecordItem")
local closeBtn_path = "top/btnClose"
local title_path = "top/txtTitle"
local svTask_path = "bg2/MiddleContentContainer/ScrollView"
local no_log_txt_path = "bg2/MiddleContentContainer/noLogTxt"
local black_path = "black"

function UIDispatchTaskRecordView:OnCreate()
  base.OnCreate(self)
  self.showList = self:GetUserData()
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshAll()
end

function UIDispatchTaskRecordView:OnDestroy()
  self:ClearScroll()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIDispatchTaskRecordView:ComponentDefine()
  self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtnN:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.titleN = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self.titleN:SetLocalText("dispatch_des025")
  self.svTaskN = self:AddComponent(UIScrollView, svTask_path)
  self.svTaskN:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.svTaskN:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.no_log_txt = self:AddComponent(UITextMeshProUGUIEx, no_log_txt_path)
  self.black = self:AddComponent(UIButton, black_path)
  self.black:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
end

function UIDispatchTaskRecordView:ComponentDestroy()
  self.closeBtnN = nil
  self.titleN = nil
  self.svTaskN = nil
  self.no_log_txt = nil
  self.black = nil
end

function UIDispatchTaskRecordView:DataDefine()
  self.logList = {}
end

function UIDispatchTaskRecordView:DataDestroy()
  self.logList = nil
end

function UIDispatchTaskRecordView:OnAddListener()
  base.OnAddListener(self)
end

function UIDispatchTaskRecordView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIDispatchTaskRecordView:RefreshAll()
  self:ClearScroll()
  if self.showList and type(self.showList) == "table" then
    self.logList = self.showList
  else
    self.logList = DataCenter.ActDispatchTaskDataManager:GetAllLogList()
  end
  if self.logList and #self.logList > 0 then
    self.no_log_txt:SetActive(false)
    self.svTaskN:SetActive(true)
    self.svTaskN:SetTotalCount(#self.logList)
    self.svTaskN:RefillCells()
  else
    self.no_log_txt:SetLocalText(456221)
    self.no_log_txt:SetActive(true)
    self.svTaskN:SetActive(false)
  end
end

function UIDispatchTaskRecordView:OnCreateCell(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.svTaskN:AddComponent(UIDispatchTaskRecordItem, itemObj)
  local logInfo = self.logList[index]
  cellItem:SetItem(logInfo)
end

function UIDispatchTaskRecordView:OnDeleteCell(itemObj, index)
  self.svTaskN:RemoveComponent(itemObj.name, UIDispatchTaskRecordItem)
end

function UIDispatchTaskRecordView:ClearScroll()
  self.svTaskN:ClearCells()
  self.svTaskN:RemoveComponents(UIDispatchTaskRecordItem)
end

return UIDispatchTaskRecordView
