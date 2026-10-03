local UILWMainSubTaskList = BaseClass("UILWMainSubTaskList", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local QuestListItem = require("UI.UILWQuest.UILWQuestList.Component.UILWQuestListItem")
local main_task_text_path = "mainTaskGo/mainTaskText"
local main_task_item_path = "mainTaskGo/mainTaskItem"
local sub_task_text_path = "subTaskGo/titleBg/subTaskText"
local scroll_view_path = "subTaskGo/MScroll"
local no_main_task_text_path = "mainTaskGo/noMainTaskText"
local no_sub_task_text_path = "subTaskGo/noSubTaskText"
local rewardPrefab = "Assets/Main/Prefabs/UI/LWQuest/MainTaskRewardItem.prefab"

function UILWMainSubTaskList:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWMainSubTaskList:OnDestroy()
  self:ClearScroll()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWMainSubTaskList:ComponentDefine()
  self.main_task_text = self:AddComponent(UIText, main_task_text_path)
  self.main_task_text:SetLocalText(170014)
  self.main_task_item = self:AddComponent(QuestListItem, main_task_item_path)
  self.sub_task_text = self:AddComponent(UIText, sub_task_text_path)
  self.sub_task_text:SetLocalText(170016)
  self.ScrollView = self:AddComponent(UIScrollView, scroll_view_path)
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnCellMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnCellMoveOut(itemObj, index)
  end)
  self.no_main_task_text = self:AddComponent(UIText, no_main_task_text_path)
  self.no_sub_task_text = self:AddComponent(UIText, no_sub_task_text_path)
  self.no_main_task_text:SetLocalText(170017)
  self.no_sub_task_text:SetLocalText(170017)
end

function UILWMainSubTaskList:ComponentDestroy()
  self.main_task_text = nil
  self.main_task_item = nil
  self.sub_task_text = nil
  self.no_main_task_text = nil
  self.no_sub_task_text = nil
  self.ScrollView = nil
end

function UILWMainSubTaskList:DataDefine()
  self.m_subList = {}
end

function UILWMainSubTaskList:DataDestroy()
  self.m_subList = nil
end

function UILWMainSubTaskList:OnEnable()
  base.OnEnable(self)
end

function UILWMainSubTaskList:OnDisable()
  base.OnDisable(self)
end

function UILWMainSubTaskList:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.MainTaskSuccess, self.RefreshContent)
end

function UILWMainSubTaskList:OnRemoveListener()
  self:RemoveUIListener(EventId.MainTaskSuccess, self.RefreshContent)
  base.OnRemoveListener(self)
end

function UILWMainSubTaskList:RefreshContent()
  local mainTask, list = self.view.ctrl:GetTasksByTab()
  if mainTask then
    self.main_task_item:SetActive(true)
    self.main_task_item:SetData({infos = mainTask}, rewardPrefab)
  else
    self.main_task_item:SetActive(false)
    self.no_main_task_text:SetActive(true)
  end
  self.m_subList = list
  self:ClearScroll()
  local cnt = table.count(self.m_subList)
  if cnt == 0 then
    self.ScrollView:SetActive(false)
    self.no_sub_task_text:SetActive(true)
  else
    if not self.ScrollView:GetActive() then
      self.ScrollView:SetActive(true)
      self.no_sub_task_text:SetActive(false)
    end
    self.ScrollView:SetTotalCount(#self.m_subList)
    self.ScrollView:RefillCells()
  end
end

function UILWMainSubTaskList:ClearScroll()
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(QuestListItem)
end

function UILWMainSubTaskList:OnCellMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(QuestListItem, itemObj)
  cellItem:SetData({
    infos = self.m_subList[index]
  }, rewardPrefab)
end

function UILWMainSubTaskList:OnCellMoveOut(itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, QuestListItem)
end

return UILWMainSubTaskList
