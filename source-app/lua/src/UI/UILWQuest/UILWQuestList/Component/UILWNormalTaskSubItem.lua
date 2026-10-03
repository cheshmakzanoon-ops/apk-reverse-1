local UILWNormalTaskSubItem = BaseClass("UILWNormalTaskSubItem", UIBaseContainer)
local base = UIBaseContainer
local QuestListItem = require("UI.UILWQuest.UILWQuestList.Component.UILWQuestListItem")
local item_task_path = "item_Task"
local no_main_task_text_path = "noMainTaskText"

function UILWNormalTaskSubItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UILWNormalTaskSubItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWNormalTaskSubItem:ComponentDefine()
  self.item_task = self:AddComponent(QuestListItem, item_task_path)
  self.no_main_task_text = self:AddComponent(UIBaseContainer, no_main_task_text_path)
end

function UILWNormalTaskSubItem:ComponentDestroy()
  self.item_task = nil
  self.no_main_task_text = nil
end

function UILWNormalTaskSubItem:ReInit(data, rewardPrefab)
  self.no_main_task_text:SetActive(data.task == nil)
  self.item_task:SetActive(data.task ~= nil)
  if data.task == nil then
    return
  end
  self.item_task:SetData({
    infos = data.task
  }, rewardPrefab)
end

return UILWNormalTaskSubItem
