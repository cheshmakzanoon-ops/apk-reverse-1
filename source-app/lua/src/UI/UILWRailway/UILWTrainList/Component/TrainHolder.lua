local TrainHolder = BaseClass("TrainHolder", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local NormalTrainItem = require("UI.UILWRailway.UILWTrainList.Component.NormalTrainItem")
local TopTrainItem = require("UI.UILWRailway.UILWTrainList.Component.TopTrainItem")

local function OnGetItemByIndex(self, loopScroll, index)
  index = index + 1
  if index < 1 or index > table.count(self.trainList) then
    return nil
  end
  local data, prefabString, class
  if self.view.ctrl:GetCurrentTab() == TrainTab.Mine then
    data = index
    prefabString = "MyTrainItem"
    class = MyTrainItem
  else
    data = self.trainList[index]
    prefabString = index == 1 and "TopTrainItem" or "NormalTrainItem"
    class = index == 1 and TopTrainItem or NormalTrainItem
    if index == self.itemCount then
    end
  end
  local item = loopScroll:NewListViewItem(prefabString)
  local script = self.content:GetComponent(item.gameObject.name, class)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    if not item.IsInitHandlerCalled then
      item.IsInitHandlerCalled = true
    end
    script = self.content:AddComponent(class, objectName)
  end
  script:SetActive(true)
  script:SetData(data, index)
  return item
end

function TrainHolder:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function TrainHolder:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function TrainHolder:ComponentDefine()
  self.noTrainText = self:AddComponent(UIText, "NoTrain")
  self.noTrainText:SetLocalText(457585)
  self.title = self:AddComponent(UIText, "Title")
  self.subTitle = self:AddComponent(UIText, "SubTitle")
  self.scrollView = self:AddComponent(UILoopListView2, "ScrollView")
  self.scrollView:InitListView(0, function(loopView, index)
    return OnGetItemByIndex(self, loopView, index)
  end)
  self.content = self:AddComponent(UIBaseContainer, "ScrollView/Viewport/Content")
end

function TrainHolder:ComponentDestroy()
  self.content:RemoveComponents(TopTrainItem)
  self.content:RemoveComponents(NormalTrainItem)
  self.scrollView:ClearAllItems()
  self.listContent = nil
  self.listItemPrefab = nil
end

function TrainHolder:DataDefine()
  self.trainList = {}
  self.itemIndex = 0
end

function TrainHolder:DataDestroy()
  self.trainList = nil
end

function TrainHolder:OnEnable()
  base.OnEnable(self)
end

function TrainHolder:OnDisable()
  base.OnDisable(self)
end

function TrainHolder:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshTrainListData, self.RefreshContent)
end

function TrainHolder:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshTrainListData, self.RefreshContent)
  base.OnRemoveListener(self)
end

function TrainHolder:RefreshContent()
  local cur, max = 0, 0
  if self.view.ctrl:GetCurrentTab() == TrainTab.Enemy then
    cur, max = DataCenter.LWMyStationDataManager:GetRobCount()
    self.subTitle:SetText(Localization:GetString(457510) .. ": " .. cur .. "/" .. max)
  end
  self.trainList = self.view:GetTrainsByTab()
  self.itemCount = table.count(self.trainList)
  self.noTrainText:SetActive(0 >= self.itemCount)
  if self.trainList == nil or self.itemCount == 0 then
    self.scrollView:SetActive(false)
    return
  end
  self.scrollView:SetActive(true)
  self.scrollView:SetListItemCount(self.itemCount, false, false)
  self.scrollView:RefreshAllShownItem()
end

return TrainHolder
