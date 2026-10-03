local UILWMainSeasonSubTaskListNew = BaseClass("UILWMainSeasonSubTaskListNew", UIBaseContainer)
local base = UIBaseContainer
local UILWMainTaskTitleSubItem = require("UI.UILWQuest.UILWQuestList.Component.UILWMainTaskTitleSubItem")
local UILWMainTaskSubItem = require("UI.UILWQuest.UILWQuestList.Component.UILWMainTaskSubItem")
local UILWNormalTaskSubItem = require("UI.UILWQuest.UILWQuestList.Component.UILWNormalTaskSubItem")
local new_main_sub_task_holder_path = ""
local content_path = "ViewPort/Content"
local rewardPrefab = "Assets/Main/Prefabs/UI/LWQuest/MainTaskRewardItem.prefab"
local NameCount = 0

function UILWMainSeasonSubTaskListNew:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWMainSeasonSubTaskListNew:OnDestroy()
  self:RemoveItems()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWMainSeasonSubTaskListNew:ComponentDefine()
  self.LoopListView = self:AddComponent(UILoopListView2, new_main_sub_task_holder_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.LoopListView:InitListView(0, function(listview, index)
    return self:GetScrollItem(listview, index)
  end)
end

function UILWMainSeasonSubTaskListNew:ComponentDestroy()
  self.new_main_sub_task_holder = nil
  self.content = nil
end

function UILWMainSeasonSubTaskListNew:DataDefine()
  self.items = {}
end

function UILWMainSeasonSubTaskListNew:DataDestroy()
  self.m_subList = nil
end

function UILWMainSeasonSubTaskListNew:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.MainTaskSuccess, self.RefreshContent)
end

function UILWMainSeasonSubTaskListNew:OnRemoveListener()
  self:RemoveUIListener(EventId.MainTaskSuccess, self.RefreshContent)
  base.OnRemoveListener(self)
end

function UILWMainSeasonSubTaskListNew:RefreshContent()
  self.dataList = {}
  table.insert(self.dataList, {title = true, titleType = 1})
  local mainList, subList = DataCenter.TaskManager:GetMainCountTaskForView(4, true)
  if 0 < #mainList then
    for index = 1, #mainList do
      local task = mainList[index]
      local template = DataCenter.QuestTemplateManager:GetQuestTemplate(task.id)
      if template ~= nil then
        if not string.IsNullOrEmpty(template.icon) then
          table.insert(self.dataList, {
            title = false,
            itemType = 1,
            task = task
          })
        else
          table.insert(self.dataList, {
            title = false,
            itemType = 2,
            task = task
          })
        end
      end
    end
  else
    table.insert(self.dataList, {title = false, itemType = 1})
  end
  table.insert(self.dataList, {title = true, titleType = 2})
  if 0 < #subList then
    for index = 1, #subList do
      table.insert(self.dataList, {
        title = false,
        itemType = 2,
        task = subList[index]
      })
    end
  else
    table.insert(self.dataList, {title = false, itemType = 2})
  end
  self.LoopListView:SetListItemCount(#self.dataList, false, false)
  self.LoopListView:RefreshAllShownItem()
end

function UILWMainSeasonSubTaskListNew:GetScrollItem(listview, index)
  local dataList = self.dataList
  if dataList == nil or #dataList <= 0 then
    return nil
  end
  index = index + 1
  if index < 1 or index > #dataList then
    return nil
  end
  local data = dataList[index]
  local cell_name, cell_lua
  if data.title then
    cell_name = "itemTitle"
    cell_lua = UILWMainTaskTitleSubItem
  elseif data.itemType == 1 then
    cell_name = "itemMainTask"
    cell_lua = UILWMainTaskSubItem
  elseif data.itemType == 2 then
    cell_name = "itemTask"
    cell_lua = UILWNormalTaskSubItem
  end
  local csItem = listview:NewListViewItem(cell_name)
  if self.items[csItem] == nil then
    NameCount = NameCount + 1
    local nameStr = cell_name .. NameCount
    csItem.gameObject.name = nameStr
    self.items[csItem] = self.content:AddComponent(cell_lua, nameStr)
  end
  if self.items[csItem] ~= nil then
    self.items[csItem]:ReInit(data, rewardPrefab)
  end
  return csItem
end

function UILWMainSeasonSubTaskListNew:RemoveItems()
  NameCount = 0
  self.items = {}
  self.LoopListView:ClearAllItems()
end

return UILWMainSeasonSubTaskListNew
