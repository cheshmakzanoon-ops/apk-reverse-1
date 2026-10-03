local base = UIBaseContainer
local UIChatRoomFilterItem = BaseClass("UIChatRoomFilterItem", UIBaseContainer)
local compBook = {
  {
    path = "",
    name = "btnTab",
    type = UIButton,
    onClick = function(self)
      self:OnClick()
    end
  },
  {
    path = "txtOff",
    name = "txtOff",
    type = UITextMeshProUGUIEx
  },
  {
    path = "imgOn",
    name = "imgOn",
    type = UIImage,
    active = false
  },
  {
    path = "imgOn/txtOn",
    name = "txtOn",
    type = UITextMeshProUGUIEx
  },
  {
    path = "reddot",
    name = "reddot",
    type = UIAdaptReddot,
    active = false
  }
}

function UIChatRoomFilterItem:OnCreate()
  base.OnCreate(self)
  self:DefineCompsByBook(compBook)
end

function UIChatRoomFilterItem:ReInit(data, index, callBack, currRoom)
  self.data = data.secondGroups
  self.callBack = callBack
  self.index = index
  self.groupDic = self:CreateGroupDic(self.data)
  self.currGroup = self.data[1]
  self:UpdateTextDisplay(data.langKey)
  self:ChangeRoom(currRoom.group)
end

function UIChatRoomFilterItem:CreateGroupDic(groups)
  local groupDic = {}
  for _, group in ipairs(groups) do
    groupDic[group] = true
  end
  return groupDic
end

function UIChatRoomFilterItem:UpdateTextDisplay(name)
  self.txtOff:SetLocalText(name)
  self.txtOn:SetLocalText(name)
end

function UIChatRoomFilterItem:ChangeRoom(group)
  if self.currGroup ~= group and self.groupDic[group] then
    self.currGroup = group
  end
end

function UIChatRoomFilterItem:OnClick()
  if self.callBack then
    self.callBack(self.index)
  end
end

function UIChatRoomFilterItem:SetState(index)
  self.imgOn:SetActive(index == self.index)
end

function UIChatRoomFilterItem:OnDestroy()
  base.OnDestroy(self)
end

function UIChatRoomFilterItem:GetRoom()
  return ChatInterface.getMoment():GetMomentData(self.currGroup)
end

return UIChatRoomFilterItem
