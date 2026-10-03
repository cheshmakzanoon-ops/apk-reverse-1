local UITemperatureHistoryView = BaseClass("UITemperatureHistoryView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local TemperatureHistoryItem = require("UI.UITemperatureHistory.Component.TemperatureHistoryItem")
local panel_path = "panel"
local close_btn_path = "Root/Common_img_title/CloseBtn"
local no_log_txt_path = "Root/MiddleContent/noLogTxt"
local scroll_view_path = "Root/MiddleContent/ScrollView"

function UITemperatureHistoryView:OnCreate()
  base.OnCreate(self)
  self.dataList = {}
  self:ComponentDefine()
  self:UpdateData()
  SFSNetwork.SendMessage(MsgDefines.TemperatureChangeRecord)
end

function UITemperatureHistoryView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UITemperatureHistoryView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.MyBaseTempChangeHistory, self.UpdateData)
end

function UITemperatureHistoryView:OnRemoveListener()
  self:RemoveUIListener(EventId.MyBaseTempChangeHistory, self.UpdateData)
  base.OnRemoveListener(self)
end

function UITemperatureHistoryView:ComponentDefine()
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

function UITemperatureHistoryView:ComponentDestroy()
  self:ClearScroll()
  self.close_btn = nil
  self.no_log_txt = nil
  self.scroll_view = nil
  self.content = nil
end

function UITemperatureHistoryView:UpdateData()
  self.dataList = DataCenter.TemperatureManager:GetTemperatureHistory()
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

function UITemperatureHistoryView:OnRankItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(TemperatureHistoryItem, itemObj)
  if cellItem ~= nil then
    cellItem:ReInit(index, self.dataList[index])
  end
end

function UITemperatureHistoryView:OnRankItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, TemperatureHistoryItem)
end

function UITemperatureHistoryView:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(TemperatureHistoryItem)
end

return UITemperatureHistoryView
