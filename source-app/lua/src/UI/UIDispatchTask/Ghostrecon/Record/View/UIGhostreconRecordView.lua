local base = UIBaseView
local UIGhostreconRecordView = BaseClass("UIGhostreconRecordView", base)
local UIGhostreconRecordItem = require("UI.UIDispatchTask.Ghostrecon.Record.Component.UIGhostreconRecordItem")
local closeBtn_path = "top/btnClose"
local title_path = "top/txtTitle"
local svTask_path = "bg2/MiddleContentContainer/ScrollView"
local no_log_txt_path = "bg2/MiddleContentContainer/noLogTxt"
local black_path = "black"

function UIGhostreconRecordView:OnCreate()
  base.OnCreate(self)
  self.showList = self:GetUserData()
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshAll()
end

function UIGhostreconRecordView:OnDestroy()
  self:ClearScroll()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIGhostreconRecordView:ComponentDefine()
  self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtnN:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.titleN = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self.titleN:SetLocalText("ghostrecon_020")
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

function UIGhostreconRecordView:ComponentDestroy()
  self.closeBtnN = nil
  self.titleN = nil
  self.svTaskN = nil
  self.no_log_txt = nil
  self.black = nil
end

function UIGhostreconRecordView:DataDefine()
  self.logList = {}
end

function UIGhostreconRecordView:DataDestroy()
  self.logList = nil
end

function UIGhostreconRecordView:OnAddListener()
  base.OnAddListener(self)
end

function UIGhostreconRecordView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIGhostreconRecordView:RefreshAll()
  self:ClearScroll()
  if self.showList and type(self.showList) == "table" then
    self.logList = self.showList
  else
    self.logList = DataCenter.ActGhostreconManager:GetAllLogList()
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

function UIGhostreconRecordView:OnCreateCell(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.svTaskN:AddComponent(UIGhostreconRecordItem, itemObj)
  local logInfo = self.logList[index]
  cellItem:SetItem(logInfo)
end

function UIGhostreconRecordView:OnDeleteCell(itemObj, index)
  self.svTaskN:RemoveComponent(itemObj.name, UIGhostreconRecordItem)
end

function UIGhostreconRecordView:ClearScroll()
  self.svTaskN:ClearCells()
  self.svTaskN:RemoveComponents(UIGhostreconRecordItem)
end

return UIGhostreconRecordView
