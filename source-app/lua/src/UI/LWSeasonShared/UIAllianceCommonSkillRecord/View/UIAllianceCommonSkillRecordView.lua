local base = UIBaseView
local UIAllianceCommonSkillRecordView = BaseClass("UIAllianceCommonSkillRecordView", base)
local UICommonToggleListComponent = require("UI.UILWCommon.UICommonToggleList.UICommonToggleListComponent")
local UIAllianceCommonSkillRecordItem = require("UI.LWSeasonShared.UIAllianceCommonSkillRecord.Component.UIAllianceCommonSkillRecordItem")
local btn_InfoBtn_path = "UICommonPopUpTitle/Common_bg_orange/InfoBtn"
local sr_UICommonToggleList_path = "Root/UICommonToggleList"
local btn_CloseBtn_path = "UICommonPopUpTitle/Common_bg_orange/CloseBtn"
local btn_panel_path = "UICommonPopUpTitle/panel"
local sr_UICommonLoopListViewVertical_path = "Root/UICommonLoopListViewVertical"
local txt_empyt_path = "Root/UICommonLoopListViewVertical/empyt"
local theHistoryData = {}
local hasDataALL = false

function UIAllianceCommonSkillRecordView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIAllianceCommonSkillRecordView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAllianceCommonSkillRecordView:ComponentDefine()
  self.btn_InfoBtn = self:AddComponent(UIButton, btn_InfoBtn_path)
  self.btn_CloseBtn = self:AddComponent(UIButton, btn_CloseBtn_path)
  self.btn_panel = self:AddComponent(UIButton, btn_panel_path)
  self.txt_empyt = self:AddComponent(UIText, txt_empyt_path)
  self.sr_UICommonToggleList = self:AddComponent(UICommonToggleListComponent, sr_UICommonToggleList_path)
  self.sr_UICommonLoopListViewVertical = self:AddComponent(UILoopListViewSimple, sr_UICommonLoopListViewVertical_path)
  self.btn_CloseBtn:SetOnClick(BindCallback(self, self.ctrl.CloseSelf))
  self.btn_panel:SetOnClick(BindCallback(self, self.ctrl.CloseSelf))
  self.btn_InfoBtn:SetOnClick(BindCallback(self, self.ClickInfo))
  local skillType = self:GetUserData()
  self:InitToggleList(skillType or nil)
  self.sr_UICommonLoopListViewVertical:Init(UIAllianceCommonSkillRecordItem)
end

function UIAllianceCommonSkillRecordView:ComponentDestroy()
  self.btn_InfoBtn = nil
  self.sr_UICommonToggleList = nil
  self.btn_CloseBtn = nil
  self.btn_panel = nil
  self.sr_UICommonLoopListViewVertical = nil
  self.txt_empyt = nil
end

function UIAllianceCommonSkillRecordView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonGovernmentSkillHistory, self.OnHistory)
end

function UIAllianceCommonSkillRecordView:OnRemoveListener()
  self:RemoveUIListener(EventId.LWSeasonGovernmentSkillHistory, self.OnHistory)
  base.OnRemoveListener(self)
end

function UIAllianceCommonSkillRecordView:ClickInfo()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceCommonSkillInfo, {anim = true})
end

function UIAllianceCommonSkillRecordView:InitToggleList(skillType)
  local data = DataCenter.AllianceGovernmentCommonSkillManager:GetSkillList()
  self.tabs = {}
  for _, v in ipairs(data) do
    local tabData = {}
    tabData.name = CS.GameEntry.Localization:GetString(v.scoreConfig.skill_name)
    tabData.skillFlag = v.config.skill_flag
    tabData.skillId = v.config.id
    tabData.type = v.config.type
    table.insert(self.tabs, tabData)
  end
  table.sort(self.tabs, function(a, b)
    return a.skillId < b.skillId
  end)
  local toggleIndex = 1
  for index, v in ipairs(self.tabs) do
    if v.type == skillType then
      toggleIndex = index
      break
    end
  end
  local toggleListData = {}
  toggleListData.itemsDataList = self.tabs
  toggleListData.defaultSelectIndex = toggleIndex
  
  function toggleListData.onItemSelect(index, itemData)
    self:OnToggle(index)
  end
  
  self.sr_UICommonToggleList:ReInit(toggleListData)
  self.sr_UICommonToggleList.scrollRectUICommonToggleList:SetHorizontalNormalizedPosition((toggleIndex - 1) / (#self.tabs - 1))
  self:OnToggle(toggleIndex)
end

function UIAllianceCommonSkillRecordView:OnHistory(data)
  self:SetData(data)
  self:RefreshList()
end

function UIAllianceCommonSkillRecordView:SetData(data)
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
      local tabInfo = self.tabs[self.curToggleIndex]
      SFSNetwork.SendMessage(MsgDefines.GetAllianceSkillHistory, toInt(data.pageNum) + 1, 100, tabInfo.skillFlag)
    else
      hasDataALL = true
    end
    if not hasNewData then
      return
    end
  end
end

function UIAllianceCommonSkillRecordView:RefreshList()
  local dataList = {}
  for k, v in pairs(theHistoryData) do
    table.insert(dataList, v)
  end
  table.sort(dataList, function(a, b)
    return a.eventTime > b.eventTime
  end)
  self.sr_UICommonLoopListViewVertical:Clear()
  for _, v in ipairs(dataList) do
    self.sr_UICommonLoopListViewVertical:AddData(v)
  end
  self.sr_UICommonLoopListViewVertical:Show()
  self.txt_empyt:SetActive(#dataList == 0)
end

function UIAllianceCommonSkillRecordView:OnToggle(index)
  if self.curToggleIndex ~= nil and self.curToggleIndex == index then
    return
  end
  local tabInfo = self.tabs[index]
  SFSNetwork.SendMessage(MsgDefines.GetAllianceSkillHistory, 0, 100, tabInfo.skillFlag)
  hasDataALL = false
  theHistoryData = {}
  self.curToggleIndex = index
end

return UIAllianceCommonSkillRecordView
