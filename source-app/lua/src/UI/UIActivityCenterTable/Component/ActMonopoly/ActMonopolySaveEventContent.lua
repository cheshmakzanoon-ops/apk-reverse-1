local ActMonopolySaveEventContent = BaseClass("ActMonopolySaveEventContent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local ActMonopolySaveEventItem = require("UI.UIActivityCenterTable.Component.ActMonopoly.ActMonopolySaveEventItem")
local event_item_path = "bottomContent/Layout/saveEventContent/eventItem"
local event_list_path = "bottomContent/Layout/saveEventContent/eventList"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.event_list = self:AddComponent(UIBaseContainer, event_list_path)
  self.event_item = self:AddComponent(UIButton, event_item_path)
  self.event_item:SetActive(false)
  self.event_item.gameObject:GameObjectCreatePool()
  self.event_item_list = {}
end

local function ComponentDestroy(self)
  self:ClearAllItem()
  self.event_item = nil
  self.event_list = nil
end

local function DataDefine(self)
  self.tryOpenTag = nil
end

local function DataDestroy(self)
  self.tryOpenTag = nil
end

local function SetData(self, mainView, activityId, activityInfo, activityDetailData, costData, isBoss)
  self.mainView = mainView
  self.activityId = activityId
  self.activityInfo = activityInfo
  self.activityDetailData = activityDetailData
  self.costData = costData
  self.isBoss = isBoss
  self:RefreshView()
end

local function RefreshView(self)
  if self.activityDetailData == nil then
    return
  end
  self.showData = self.activityDetailData:GetAutoEventShowData()
  self:RefreshSaveEventView()
end

local function RefreshSaveEventView(self)
  local dataNum = #self.showData
  local itemNum = #self.event_item_list
  if dataNum > itemNum then
    for i = itemNum + 1, dataNum do
      local index = i
      local item = self.event_item.gameObject:GameObjectSpawn(self.event_list.transform)
      item.name = tostring(index)
      local obj = self.event_list:AddComponent(ActMonopolySaveEventItem, item.name)
      self.event_item_list[index] = obj
      obj:SetClickFunc(function(eventId)
        self:OnSaveEventClick(eventId)
      end)
    end
  end
  for i = 1, itemNum do
    if i <= dataNum then
      local item = self.event_item_list[i]
      item:SetActive(true)
      item:SetData(self.showData[i])
    else
      local item = self.event_item_list[i]
      item:SetActive(false)
    end
  end
end

local function OnSaveEventClick(self, eventId)
  if self.activityDetailData == nil then
    return
  end
  local canClick = self.mainView:CanClickBtn()
  if not canClick then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.RichManReceiveEvent, self.activityId, eventId)
  self.tryOpenTag = self:GetTagByEvetId(eventId)
end

local function OnGetDataChangeMsg(self)
  self:RefreshView()
end

local function ClearAllItem(self)
  self.event_list:RemoveComponents(ActMonopolySaveEventItem)
  self.event_item.gameObject:GameObjectRecycleAll()
  self.event_item_list = {}
end

local function GetTagByEvetId(self, eventId)
  local tag
  for _, item in ipairs(self.showData) do
    for _, event in ipairs(item.data) do
      if event.id == eventId then
        tag = item.tag
        break
      end
    end
  end
  return tag
end

local function OnEventTipClose(self)
  local eventId
  if self.tryOpenTag then
    for _, item in ipairs(self.showData) do
      if item.tag == self.tryOpenTag then
        eventId = item.data[1].id
        SFSNetwork.SendMessage(MsgDefines.RichManReceiveEvent, self.activityId, eventId)
        break
      end
    end
    if eventId == nil then
      self.tryOpenTag = nil
    end
  end
end

local function GetItemByEventId(self, eventId)
  local itemCell
  local tag = self:GetTagByEvetId(eventId)
  if tag then
    for _, item in ipairs(self.event_item_list) do
      if item.itemShowData and item.itemShowData.tag == tag then
        itemCell = item
        break
      end
    end
  end
  return itemCell
end

ActMonopolySaveEventContent.OnCreate = OnCreate
ActMonopolySaveEventContent.OnDestroy = OnDestroy
ActMonopolySaveEventContent.ComponentDefine = ComponentDefine
ActMonopolySaveEventContent.ComponentDestroy = ComponentDestroy
ActMonopolySaveEventContent.DataDefine = DataDefine
ActMonopolySaveEventContent.DataDestroy = DataDestroy
ActMonopolySaveEventContent.SetData = SetData
ActMonopolySaveEventContent.RefreshView = RefreshView
ActMonopolySaveEventContent.OnSaveEventClick = OnSaveEventClick
ActMonopolySaveEventContent.RefreshSaveEventView = RefreshSaveEventView
ActMonopolySaveEventContent.OnGetDataChangeMsg = OnGetDataChangeMsg
ActMonopolySaveEventContent.ClearAllItem = ClearAllItem
ActMonopolySaveEventContent.GetTagByEvetId = GetTagByEvetId
ActMonopolySaveEventContent.OnEventTipClose = OnEventTipClose
ActMonopolySaveEventContent.GetItemByEventId = GetItemByEventId
return ActMonopolySaveEventContent
