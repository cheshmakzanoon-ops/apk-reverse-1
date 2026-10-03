local PresidentHistoryView = BaseClass("PresidentHistoryView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local PresidentHistoryItem = require("UI.UIGovernment.PresidentHistory.Component.PresidentHistoryItem")
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local scroll_view_path = "PopUpTitle/ScrollView"
local content_path = "PopUpTitle/ScrollView/Viewport/Content"
local empty_text_path = "PopUpTitle/EmptyText"

function PresidentHistoryView:OnCreate()
  base.OnCreate(self)
  local param = self:GetUserData()
  self.param = param
  self.count = 0
  self:ComponentDefine()
  local record = DataCenter.GovernmentManager:GetKingsHistoryRecord()
  if record ~= nil then
    self:UpdateData()
  else
    SFSNetwork.SendMessage(MsgDefines.GetKingHistory, LuaEntry.Player:GetSourceServerId(), 1)
    self.empty_text:SetActive(true)
  end
end

function PresidentHistoryView:OnDestroy()
  self:ClearScroll()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function PresidentHistoryView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GovernmentHistoryRecordRefresh, self.UpdateData)
end

function PresidentHistoryView:OnRemoveListener()
  self:RemoveUIListener(EventId.GovernmentHistoryRecordRefresh, self.UpdateData)
  base.OnRemoveListener(self)
end

function PresidentHistoryView:ComponentDefine()
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.dialog_title_text:SetLocalText("457054")
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.ScrollView = self:AddComponent(UIScrollView, scroll_view_path)
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnRankItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnRankItemMoveOut(itemObj, index)
  end)
  self.empty_text = self:AddComponent(UIText, empty_text_path)
end

function PresidentHistoryView:ComponentDestroy()
  self.btn_back = nil
end

function PresidentHistoryView:UpdateData()
  self:ClearScroll()
  local record = DataCenter.GovernmentManager:GetKingsHistoryRecord()
  if record ~= nil then
    self.rankList = record:GetShowList()
    if #self.rankList > 0 then
      self.count = #self.rankList
      self.ScrollView:SetTotalCount(self.count)
      self.ScrollView:RefillCells()
      self.empty_text:SetActive(false)
    else
      self.empty_text:SetActive(true)
    end
  else
    self.empty_text:SetActive(true)
  end
end

function PresidentHistoryView:OnRankItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(PresidentHistoryItem, itemObj)
  if cellItem ~= nil then
    cellItem:ReInit(index, self.rankList[index])
  end
end

function PresidentHistoryView:OnRankItemMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, PresidentHistoryItem)
end

function PresidentHistoryView:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(PresidentHistoryItem)
end

return PresidentHistoryView
