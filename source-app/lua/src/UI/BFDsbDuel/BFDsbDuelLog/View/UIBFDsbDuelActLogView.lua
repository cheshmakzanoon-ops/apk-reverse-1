local UIBFDsbDuelActLogView = BaseClass("UIBFDsbDuelActLogView", UIBaseView)
local base = UIBaseView
local UIBFDsbDuelActLogItem = require("UI.BFDsbDuel.BFDsbDuelLog.Component.UIBFDsbDuelActLogItem")
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local text_empty_path = "PopUpTitle/Common_bg_orange2/EmptyText"
local scroll_view_path = "PopUpTitle/Common_bg_orange2/ScrollView"
local content_path = "PopUpTitle/Common_bg_orange2/ScrollView/Viewport/Content"

function UIBFDsbDuelActLogView:OnCreate()
  base.OnCreate(self)
  self.itemList = {}
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.dialog_title_text:SetLocalText("Desert_strom_log_tips_1001")
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.text_empty = self:AddComponent(UIText, text_empty_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.scroll_view = self:AddComponent(UILoopListView2, scroll_view_path)
  self.scroll_view:InitListView(0, function(listview, index)
    return self:OnGetItemByIndex(listview, index)
  end)
  BattlefieldDsbDuelUtils.ActInfo:SendActOperatorLogListMsg()
end

function UIBFDsbDuelActLogView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DsbDuelActOnGetOperateList, self.RefreshOperateList)
end

function UIBFDsbDuelActLogView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.DsbDuelActOnGetOperateList, self.RefreshOperateList)
end

function UIBFDsbDuelActLogView:RefreshOperateList()
  self.list = BattlefieldDsbDuelUtils.ActInfo:GetLogList()
  local cnt = #self.list
  self.text_empty:SetActive(cnt == 0)
  if 0 < cnt then
    self.scroll_view:SetListItemCount(cnt, false, false)
    self.scroll_view:RefreshAllShownItem()
  else
    self:ClearScroll()
  end
end

function UIBFDsbDuelActLogView:OnDestroy()
  self:ClearScroll()
  base.OnDestroy(self)
end

function UIBFDsbDuelActLogView:ClearScroll()
  self.content:RemoveComponents(UIBFDsbDuelActLogItem)
  self.scroll_view:ClearAllItems()
  self.scroll_view:SetListItemCount(0, false, false)
  self.scroll_view:RefreshAllShownItem()
  self.itemList = {}
end

function UIBFDsbDuelActLogView:OnGetItemByIndex(listview, index)
  local len = #self.list
  local idx = index + 1
  if idx < 1 or len < idx then
    return nil
  end
  local csItem = listview:NewListViewItem("Item")
  local item = self.itemList[csItem]
  if item == nil then
    local prefabIndex = self.prefabIndex or 0
    local nameStr = "Item" .. prefabIndex
    self.prefabIndex = prefabIndex + 1
    csItem.gameObject.name = nameStr
    item = self.content:AddComponent(UIBFDsbDuelActLogItem, nameStr)
    self.itemList[csItem] = item
  end
  if item ~= nil then
    item:SetItem(self.list[idx])
  end
  return csItem
end

return UIBFDsbDuelActLogView
