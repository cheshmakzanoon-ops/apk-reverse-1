local UILWMainTaskSubItem = BaseClass("UILWMainTaskSubItem", UIBaseContainer)
local base = UIBaseContainer
local UILWMainQuestTaskItem = require("UI.UILWQuest.UILWQuestList.Component.UILWMainQuestTaskItem")
local item_task_path = "item_Task"
local no_main_task_text_path = "noMainTaskText"
local bg_path = "bg"
local receive_bg_path = "ReceiveBg"

function UILWMainTaskSubItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UILWMainTaskSubItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWMainTaskSubItem:ComponentDefine()
  self.item_task = self:AddComponent(UILWMainQuestTaskItem, item_task_path)
  self.no_main_task_text = self:AddComponent(UIBaseContainer, no_main_task_text_path)
  self.bg = self:TryAddComponent(UIImage, bg_path)
  self.receive_bg = self:TryAddComponent(UIImage, receive_bg_path)
end

function UILWMainTaskSubItem:ComponentDestroy()
  self.item_task = nil
  self.no_main_task_text = nil
  self.bg = nil
  self.receive_bg = nil
end

function UILWMainTaskSubItem:ReInit(data, rewardPrefab)
  self.no_main_task_text:SetActive(data.task == nil)
  self.item_task:SetActive(data.task ~= nil)
  if data.task == nil then
    if self.bg ~= nil then
      self.bg:SetActive(false)
    end
    if self.receive_bg ~= nil then
      self.receive_bg:SetActive(false)
    end
    return
  end
  self.item_task:SetData({
    infos = data.task
  }, rewardPrefab)
  if data.itemType == 1 then
    self.receive_bg:SetActive(data.task.state == TaskState.CanReceive)
    self.bg:SetActive(true)
  end
end

return UILWMainTaskSubItem
