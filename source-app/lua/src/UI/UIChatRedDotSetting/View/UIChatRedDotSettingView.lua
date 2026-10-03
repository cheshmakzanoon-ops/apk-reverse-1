local UIChatRedDotSettingView = BaseClass("UIChatRedDotSettingView", UIBaseView)
local roomRedDotSettingItem = require("UI.UIChatRedDotSetting.Component.RoomRedDotSettingItem")
local base = UIBaseView

function UIChatRedDotSettingView:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:ReInit()
end

function UIChatRedDotSettingView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIChatRedDotSettingView:DataDefine()
end

function UIChatRedDotSettingView:DataDestroy()
  local dic = {}
  for i, v in pairs(self.rooms) do
    dic[v.room.group] = v.redType
  end
  ChatManager2:GetInstance().Room:SaveRoomGroupRedDotTypeDic(dic)
end

function UIChatRedDotSettingView:OnAddListener()
  base.OnAddListener(self)
end

function UIChatRedDotSettingView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIChatRedDotSettingView:ComponentDefine()
  self.closePanelBtn = self:AddComponent(UIButton, "curtain")
  self.closeBtn = self:AddComponent(UIButton, "panel/btnClose")
  self.ScrollView = self:AddComponent(UILoopListView2, "panel/ScrollView")
  self.content = self:AddComponent(UIBaseContainer, "panel/ScrollView/Viewport/Content")
  self.closePanelBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.ScrollView:InitListView(0, function(listview, index)
    return self:OnGetItemByIndex(listview, index)
  end)
end

function UIChatRedDotSettingView:OnGetItemByIndex(listview, index)
  if self.rooms == nil or index < 0 or index >= #self.rooms then
    return nil
  end
  index = index + 1
  local item = listview:NewListViewItem("UIChatRedDotSettingItem")
  if item == nil then
    Logger.LogError("\232\161\168\230\131\133\230\187\145\229\138\168\229\136\151\232\161\168\232\142\183\229\143\150Item\228\184\186\231\169\186 UIChatRedDotSettingView")
    return
  end
  local itemScript = roomRedDotSettingItem
  local script = self.content:GetComponent(item.gameObject.name, itemScript)
  if script == nil then
    local objectName = UIUtil.GetLoopListItemIndex(item.gameObject.name)
    item.gameObject.name = objectName
    script = self.content:AddComponent(itemScript, objectName)
  end
  script:SetActive(true)
  script:UpdateItem(self.rooms[index], function(itemIndex, redType)
    self:UpdateRedType(itemIndex, redType)
  end, index)
  return item
end

function UIChatRedDotSettingView:UpdateRedType(index, redType)
  if not redType or not index then
    return
  end
  self.rooms[index].redType = redType
end

function UIChatRedDotSettingView:ComponentDestroy()
  self.content:RemoveComponents(roomRedDotSettingItem)
  self.ScrollView:ClearAllItems()
  self.closePanelBtn = nil
  self.closeBtn = nil
  self.ScrollView = nil
end

function UIChatRedDotSettingView:ReInit()
  self.rooms = self.ctrl:GetAllRoom()
  self.ScrollView:SetListItemCount(#self.rooms, false, false)
  self.ScrollView:RefreshAllShownItem()
  self.ScrollView:MovePanelToItemIndex_Mod(0, 0)
end

return UIChatRedDotSettingView
