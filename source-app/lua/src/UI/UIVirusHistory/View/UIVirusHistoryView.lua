local UIVirusHistoryView = BaseClass("UIVirusHistoryView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local VirusHistoryItem = require("UI.UIVirusHistory.Component.VirusHistoryItem")
local panel_path = "panel"
local close_btn_path = "Root/Common_img_title/CloseBtn"
local no_log_txt_path = "Root/MiddleContent/noLogTxt"
local scroll_view_path = "Root/MiddleContent/ScrollView"

function UIVirusHistoryView:OnCreate()
  base.OnCreate(self)
  self.dataList = {}
  self:ComponentDefine()
  self:UpdateData()
  SFSNetwork.SendMessage(MsgDefines.VirusChangeRecord)
end

function UIVirusHistoryView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIVirusHistoryView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.MyBaseVirusChangeHistory, self.UpdateData)
end

function UIVirusHistoryView:OnRemoveListener()
  self:RemoveUIListener(EventId.MyBaseVirusChangeHistory, self.UpdateData)
  base.OnRemoveListener(self)
end

function UIVirusHistoryView:ComponentDefine()
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.no_log_txt = self:AddComponent(UITextMeshProUGUIEx, no_log_txt_path)
  self.ScrollView = self:AddComponent(UIScrollView, scroll_view_path)
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnRankItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnRankItemMoveOut(itemObj, index)
  end)
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
end

function UIVirusHistoryView:ComponentDestroy()
  self:ClearScroll()
  self.close_btn = nil
  self.no_log_txt = nil
  self.scroll_view = nil
  self.content = nil
end

function UIVirusHistoryView:UpdateData()
  self.dataList = DataCenter.VirusDataManager:GetVirusHistory()
  local dataCount = #self.dataList
  if 0 < dataCount then
    self.no_log_txt:SetActive(false)
    self.ScrollView:SetActive(true)
    self.ScrollView:SetTotalCount(dataCount)
    self.ScrollView:RefillCells()
  else
    self.no_log_txt:SetActive(true)
    self.ScrollView:SetActive(false)
  end
end

function UIVirusHistoryView:OnRankItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(VirusHistoryItem, itemObj)
  if cellItem ~= nil then
    cellItem:ReInit(index, self.dataList[index])
  end
end

function UIVirusHistoryView:OnRankItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, VirusHistoryItem)
end

function UIVirusHistoryView:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(VirusHistoryItem)
end

return UIVirusHistoryView
