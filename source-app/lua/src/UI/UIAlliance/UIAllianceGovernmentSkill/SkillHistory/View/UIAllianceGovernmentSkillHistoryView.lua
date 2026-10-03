local UIAllianceGovernmentSkillHistoryView = BaseClass("UIAllianceGovernmentSkillHistoryView", UIBaseView)
local base = UIBaseView
local hasDataALL = false
local theHistoryData = {}
local HistoryItem = require("UI.UIAlliance.UIAllianceGovernmentSkill.SkillHistory.Component.UIAllianceGovernmentSkillHistoryItem")
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local scroll_view_path = "PopUpTitle/ScrollView"
local content_path = "PopUpTitle/ScrollView/Viewport/Content"
local no_data_path = "PopUpTitle/NoData"

function UIAllianceGovernmentSkillHistoryView:OnCreate()
  base.OnCreate(self)
  self.items = {}
  self.dataList = {}
  self:ComponentDefine()
  self:OnHistory(nil)
  SFSNetwork.SendMessage(MsgDefines.GetAllianceSkillHistory, 0, 100)
end

function UIAllianceGovernmentSkillHistoryView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAllianceGovernmentSkillHistoryView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonGovernmentSkillHistory, self.OnHistory)
end

function UIAllianceGovernmentSkillHistoryView:OnRemoveListener()
  self:RemoveUIListener(EventId.LWSeasonGovernmentSkillHistory, self.OnHistory)
  base.OnRemoveListener(self)
end

function UIAllianceGovernmentSkillHistoryView:ComponentDefine()
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.dialog_title_text:SetLocalText("season_alliance_government_skill_08")
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.ScrollView = self:AddComponent(UILoopListView2, scroll_view_path)
  self.ScrollView:InitListView(0, function(listview, index)
    return self:GetScrollItem(listview, index)
  end)
  self.no_data = self:AddComponent(UITextMeshProUGUIEx, no_data_path)
end

function UIAllianceGovernmentSkillHistoryView:ComponentDestroy()
  self:RemoveItems()
  self.content = nil
  self.scroll_view = nil
  self.close_btn = nil
  self.no_data = nil
end

function UIAllianceGovernmentSkillHistoryView:RemoveItems()
  self.items = {}
  self.content:RemoveComponents(HistoryItem)
  self.ScrollView:ClearAllItems()
end

function UIAllianceGovernmentSkillHistoryView:OnHistory(data)
  local hasNewData = false
  if data and data.pageNum and data.pageSize and data.list then
    for k, v in ipairs(data.list) do
      if theHistoryData[v.eventTime] == nil then
        hasNewData = true
        theHistoryData[v.eventTime] = v
      end
    end
    if hasDataALL and not hasNewData then
      return
    end
    if #data.list >= data.pageSize then
      SFSNetwork.SendMessage(MsgDefines.GetAllianceSkillHistory, toInt(data.pageNum) + 1, 100)
    else
      hasDataALL = true
    end
    if not hasNewData then
      return
    end
  end
  local dataList = {}
  for k, v in pairs(theHistoryData) do
    table.insert(dataList, v)
  end
  local dataCount = #dataList
  if 0 < dataCount then
    table.sort(dataList, function(a, b)
      return a.eventTime > b.eventTime
    end)
    self.dataList = dataList
    self.no_data:SetActive(false)
    self.ScrollView:SetActive(true)
    self.ScrollView:SetListItemCount(#self.dataList, t == nil, false)
    self.ScrollView:RefreshAllShownItem()
  else
    self.ScrollView:SetActive(false)
    self.no_data:SetActive(true)
  end
end

function UIAllianceGovernmentSkillHistoryView:GetScrollItem(listview, index)
  local dataList = self.dataList
  if dataList == nil or #dataList <= 0 then
    return nil
  end
  index = index + 1
  if index < 1 or index > #dataList then
    return nil
  end
  local csItem = listview:NewListViewItem("item")
  if self.items[csItem] == nil then
    NameCount = NameCount + 1
    local nameStr = "HistoryItem" .. NameCount
    csItem.gameObject.name = nameStr
    self.items[csItem] = self.content:AddComponent(HistoryItem, nameStr)
  end
  if self.items[csItem] ~= nil then
    self.items[csItem]:ReInit(index, dataList[index])
  end
  return csItem
end

return UIAllianceGovernmentSkillHistoryView
