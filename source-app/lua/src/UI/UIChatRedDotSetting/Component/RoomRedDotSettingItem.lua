local RoomRedDotSettingItem = BaseClass("RoomRedDotSettingItem", UIBaseContainer)
local base = UIBaseContainer
local OptionData = CS.TMPro.TMP_Dropdown.OptionData
local Localization = CS.GameEntry.Localization
local itemList = {
  UnreadNotificationType.ShowUnreadCount,
  UnreadNotificationType.ShowUnreadDot,
  UnreadNotificationType.NoNotification
}

function RoomRedDotSettingItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function RoomRedDotSettingItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function RoomRedDotSettingItem:ComponentDefine()
  self.txtTitle = self:AddComponent(UITextMeshProUGUIEx, "txtTitle")
  self.drop_round = self:AddComponent(UIDropdown, "Dropdown")
  self.drop_round:Clear()
  for i = 1, #itemList do
    if UnreadNotificationText[itemList[i]] then
      local temp = OptionData()
      temp.text = Localization:GetString(UnreadNotificationText[itemList[i]])
      self.drop_round:Add(temp)
    end
  end
  self.drop_round:SetOnValueChanged(function(selectedIndex)
    self.data.redType = selectedIndex + 1
    if self.callback then
      self.callback(self.index, self.data.redType)
    end
  end)
end

function RoomRedDotSettingItem:UpdateItem(data, callback, index)
  self.data = data
  self.callback = callback
  self.index = index
  if not self.data then
    return
  end
  if self.data.room.group == ChatGroupType.GROUP_ALLIANCE then
    self.txtTitle:SetLocalText(393081)
  else
    self.txtTitle:SetText(self.data.room:getRoomName())
  end
  self.drop_round:SetValue(tonumber(self.data.redType) - 1)
end

function RoomRedDotSettingItem:ComponentDestroy()
  self.txtTitle = nil
  self.drop_round = nil
end

return RoomRedDotSettingItem
