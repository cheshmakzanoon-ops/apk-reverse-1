local base = UIBaseContainer
local ActCalendarEventGroup = BaseClass("ActCalendarEventGroup", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local ActCalendarEventItem = require("UI.ActCalendar.Component.ActCalendarEventItem")
local ITEM_HEIGHT = 112

function ActCalendarEventGroup:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function ActCalendarEventGroup:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ActCalendarEventGroup:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgGroupBg = self.viewSkin:AddComponent(self, UIImage, 1)
  self.imgFilterIcon = self.viewSkin:AddComponent(self, UIImage, 2)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.compLayout = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.compLineVerticalRoot = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
  self.compGroupCtrlNode = self.viewSkin:AddComponent(self, UIBaseContainer, 6)
  self.imgFoldIcon = self.viewSkin:AddComponent(self, UIImage, 7)
  self.btnFold = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnFold:SetOnClick(function()
    self:OnBtnFoldClick()
  end)
  self.lineTransList = {}
  local lineCount = self.compLineVerticalRoot.transform.childCount
  for i = 0, lineCount - 1 do
    local childTrans = self.compLineVerticalRoot.transform:GetChild(i)
    if childTrans then
      table.insert(self.lineTransList, childTrans)
    end
  end
end

function ActCalendarEventGroup:ComponentDestroy()
  self.viewSkin = nil
  self.imgGroupBg = nil
  self.imgFilterIcon = nil
  self.textTitle = nil
  self.compLayout = nil
  self.compLineVerticalRoot = nil
  self.compGroupCtrlNode = nil
  self.imgFoldIcon = nil
  self.btnFold = nil
end

function ActCalendarEventGroup:DataDefine()
  self.height = 0
  self.isFold = false
end

function ActCalendarEventGroup:DataDestroy()
  self.isFold = nil
  self.height = nil
  self.onClickHandler = nil
  self.groupId = nil
  self.groupTemplate = nil
  self.dataList = nil
  self:_clearList()
end

function ActCalendarEventGroup:SetData(groupData, props, onClickHandler)
  if not groupData then
    Logger.LogError("groupData is nil")
    return
  end
  if not groupData.list then
    Logger.LogError("groupData.list is nil")
    return
  end
  if not self.dataList or #self.dataList ~= #groupData.list then
    self:_setHeight(#groupData.list)
  end
  self.groupId = groupData.id
  self.groupTemplate = groupData.template
  self.dataList = groupData.list
  self.onClickHandler = onClickHandler
  self:_setName()
  self:_setIcon(props)
  self:_setFoldIcon()
  self:_setFoldStatus()
  self:_refreshList()
end

function ActCalendarEventGroup:GetHeight()
  return self.height
end

function ActCalendarEventGroup:_setIcon(props)
  if props and props.iconName then
    self.imgFilterIcon:LoadSpriteAsync(props.iconName)
    self.imgFilterIcon:SetActive(true)
  else
    self.imgFilterIcon:SetActive(false)
  end
end

function ActCalendarEventGroup:_setName()
  self.textTitle:SetLocalText(self.groupTemplate.group_name)
end

function ActCalendarEventGroup:_refreshList()
  self:_clearList()
  self.itemReqs = {}
  if self.dataList then
    for i, v in ipairs(self.dataList) do
      table.insert(self.itemReqs, self:_createEventItem(v, i))
    end
  end
end

function ActCalendarEventGroup:_createEventItem(data, index)
  return self:GameObjectInstantiateAsync(UIAssets.ActCalendarEventItem, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    local name = "calendarItem_" .. index
    go.name = name
    go.transform:SetParent(self.compLayout.transform)
    local cell = self.compLayout:AddComponent(ActCalendarEventItem, name)
    cell:SetLocalScaleXYZ(1, 1, 1)
    cell:SetData(data)
    cell:PlayShowAni()
  end)
end

function ActCalendarEventGroup:_setHeight(listCount)
  local titleHeight = self.compGroupCtrlNode:GetSizeDelta().y
  local itemTotalHeight = ITEM_HEIGHT * listCount
  self.height = titleHeight + itemTotalHeight
  self:SetSizeDeltaY(self.height)
  self:_setLineHeight(itemTotalHeight)
end

function ActCalendarEventGroup:_setLineHeight(height)
  if not self.lineTransList then
    return
  end
  for i, v in ipairs(self.lineTransList) do
    local x, y = v:Get_sizeDelta()
    v:Set_sizeDelta(x, height)
  end
end

function ActCalendarEventGroup:_clearList()
  self.compLayout:RemoveComponents(ActCalendarEventItem)
  if self.itemReqs then
    for i, v in ipairs(self.itemReqs) do
      if v then
        v:Destroy()
      end
    end
  end
  self.itemReqs = nil
end

function ActCalendarEventGroup:_onFoldBtnClick()
  self.isFold = not self.isFold
  local oldHeight = self.height
  self:_setFoldStatus()
  self:_setFoldIcon()
  if self.onClickHandler then
    self.onClickHandler(self.height - oldHeight)
  end
end

function ActCalendarEventGroup:_setFoldStatus()
  if self.isFold then
    self:_setHeight(0)
    self.compLayout:SetActive(false)
  else
    if self.dataList then
      self:_setHeight(#self.dataList)
    end
    self.compLayout:SetActive(true)
  end
end

function ActCalendarEventGroup:_setFoldIcon()
  local fullName = self:_getFoldIconFullName()
  self.imgFoldIcon:LoadSpriteAsync(fullName)
end

function ActCalendarEventGroup:_getFoldIconFullName()
  local iconName
  if self.isFold then
    iconName = "zxl_tongyong_xiala_jiantou2"
  else
    iconName = "zxl_tongyong_xiala_jiantou1"
  end
  local fullName = string.format(LoadPath.ActCalendar, iconName)
  return fullName
end

function ActCalendarEventGroup:OnBtnFoldClick()
  self:_onFoldBtnClick()
end

return ActCalendarEventGroup
