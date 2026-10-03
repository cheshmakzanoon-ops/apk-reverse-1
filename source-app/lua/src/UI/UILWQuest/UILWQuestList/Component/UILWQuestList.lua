local UILWQuestList = BaseClass("UILWQuestList", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local QuestListItem = require("UI.UILWQuest.UILWQuestList.Component.UILWQuestListItem")
local content_path = "MScroll/MViewport/MContent"
local item_path = "UILWQuestItem"

function UILWQuestList:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWQuestList:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWQuestList:ComponentDefine()
  self.listContent = self:AddComponent(UIBaseContainer, content_path)
  self.listItemPrefab = self.transform:Find(item_path).gameObject
  self.listItemPrefab:GameObjectCreatePool()
end

function UILWQuestList:ComponentDestroy()
  self.listContent = nil
  self.listItemPrefab = nil
end

function UILWQuestList:DataDefine()
end

function UILWQuestList:DataDestroy()
end

function UILWQuestList:OnEnable()
  base.OnEnable(self)
end

function UILWQuestList:OnDisable()
  base.OnDisable(self)
end

function UILWQuestList:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ChapterTask, self.RefreshContent)
end

function UILWQuestList:OnRemoveListener()
  self:RemoveUIListener(EventId.ChapterTask, self.RefreshContent)
  base.OnRemoveListener(self)
end

function UILWQuestList:ClearContent()
  self.listContent:RemoveComponents(QuestListItem)
end

function UILWQuestList:RefreshContent()
  self:ClearContent()
  self.listItemPrefab.gameObject:GameObjectRecycleAll()
  local list = self.view.ctrl:GetTasksByTab()
  for i = 1, table.count(list) do
    local item = self.listItemPrefab:GameObjectSpawn(self.listContent.transform)
    item.name = "quest_item" .. i
    local cell = self.listContent:AddComponent(QuestListItem, item.name)
    local params = {
      infos = list[i]
    }
    cell:SetData(params, "Assets/Main/Prefabs/UI/LWQuest/ChapterTaskRewardItem.prefab")
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.listContent.rectTransform)
end

return UILWQuestList
