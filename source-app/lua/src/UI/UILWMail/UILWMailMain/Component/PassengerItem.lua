local PassengerItem = BaseClass("PassengerItem", UIBaseContainer)
local base = UIBaseContainer

function PassengerItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function PassengerItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function PassengerItem:ComponentDefine()
  self.name = self:AddComponent(UIText, "name")
  self.level = self:AddComponent(UIText, "level")
  self.head = self:AddComponent(UICommonHead, "head")
end

function PassengerItem:ComponentDestroy()
end

function PassengerItem:Refresh(data)
  self.name:SetText(UIUtil.FormatAllianceAndName(data.abbr, data.name))
  self.head:SetHeadAndFrame(data.uid, data.headPic, data.headPicVer, nil, data.headSkinId, data.headSkinET)
  self.level:SetText("Lv." .. data.level)
end

return PassengerItem
