local base = UIBaseContainer
local UIChatRoomFilterBar = BaseClass("UIChatRoomFilterBar", UIBaseContainer)
local OptionData = CS.TMPro.TMP_Dropdown.OptionData
local Localization = CS.GameEntry.Localization
local UIChatRoomFilterItem = require("UI.UIChatNewV2.Component.UIChatRoomFilterItem")
local UIGray = CS.UIGray
local UIDurationDrop = require("UI.UIChatNewV2.Component.UIDurationDrop")

function UIChatRoomFilterBar:OnCreate()
  base.OnCreate(self)
  self.categoryDrop = self:AddComponent(UIDurationDrop, "categoryDrop")
  self.categoryDrop:SetOnValueChanged(function(index)
    self:OnDropChange(index)
  end)
  self.roomTabItem = self:AddComponent(UIBaseComponent, "tabItem")
  self.roomTabsLayout = self:AddComponent(UIBaseContainer, "roomTabs")
  self.itemObj = self.roomTabItem.gameObject
  self.itemObj:GameObjectCreatePool()
end

function UIChatRoomFilterBar:OnDropChange(index)
  self.selectDropIndex = index
  if self.tabItemList and self.dropIndex then
    self.tabItemList[self.dropIndex]:ChangeRoom(self.opList[self.selectDropIndex])
    self.view:MomentChangeSelect(ChatInterface.getMoment():GetMomentData(self.opList[self.selectDropIndex]))
  end
end

function UIChatRoomFilterBar:ReInitRoom(roomSet)
  self.roomSet = roomSet
  self.tabItemList = {}
  self.selectIndex = nil
  self.roomTabsLayout:RemoveComponents(UIChatRoomFilterItem)
  self.itemObj:GameObjectRecycleAll()
  local selectIndex, defIndex = self:CreateRoomTabs(roomSet)
  self:OnItemClick(selectIndex, true)
  self:UpdateDropList(defIndex)
  self.initValue = true
  self.categoryDrop:SetValue(self.selectDropIndex, true)
end

function UIChatRoomFilterBar:CreateRoomTabs(roomSet)
  local index = 1
  local defIndex = 1
  local groups = roomSet.groups
  for i, v in ipairs(groups) do
    local item = self.itemObj:GameObjectSpawn(self.roomTabsLayout.transform)
    item.name = i
    local roomItem = self.roomTabsLayout:AddComponent(UIChatRoomFilterItem, item.name)
    roomItem:SetActive(true)
    table.insert(self.tabItemList, roomItem)
    roomItem:ReInit(groups[i], i, function(index)
      self:OnItemClick(index)
    end, self.roomSet.currRoom)
    for k, group in pairs(groups[i].secondGroups) do
      if group == roomSet.currRoom.group then
        index = i
      end
    end
    if v.defSelect then
      defIndex = i
    end
  end
  return index, defIndex
end

function UIChatRoomFilterBar:UpdateDropList(index)
  self.dropIndex = index
  self.opList = self.roomSet.groups[index].secondGroups
  local textList = {}
  local param = {
    generalColor = Color.New(0.5843137254901961, 0.5764705882352941, 0.6274509803921569, 1),
    selectColor = Color.New(0.16470588235294117, 0.1568627450980392, 0.18823529411764706, 1)
  }
  self.selectDropIndex = 1
  local template
  for i = 1, #self.opList do
    template = DataCenter.GroupChatSetTemplateManager:GetTempByGroupType(self.opList[i])
    if template then
      table.insert(textList, Localization:GetString(template.name))
    end
    if self.roomSet.currRoom.group == self.opList[i] then
      self.selectDropIndex = i
    end
  end
  self.categoryDrop:ReInit(textList, param)
end

function UIChatRoomFilterBar:OnItemClick(index, isInit)
  if self.selectIndex == index then
    return
  end
  for i = 1, #self.tabItemList do
    self.tabItemList[i]:SetState(index)
  end
  self.selectIndex = index
  self:UpdateCategoryDropState(index)
  if not isInit then
    self.view:MomentChangeSelect(self.tabItemList[index]:GetRoom())
  end
end

function UIChatRoomFilterBar:UpdateCategoryDropState(index)
  if #self.roomSet.groups[index].secondGroups > 1 then
    UIGray.SetGray(self.categoryDrop.transform, false, true)
  else
    UIGray.SetGray(self.categoryDrop.transform, true, false)
  end
end

function UIChatRoomFilterBar:OnDestroy()
  base.OnDestroy(self)
end

return UIChatRoomFilterBar
