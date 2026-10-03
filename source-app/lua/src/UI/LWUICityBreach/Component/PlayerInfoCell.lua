local PlayerInfoCell = BaseClass("PlayerInfoCell", UIBaseContainer)
local base = UIBaseContainer

function PlayerInfoCell:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function PlayerInfoCell:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function PlayerInfoCell:ComponentDefine()
  self.name = self:AddComponent(UIText, "name")
  self.attack = self:AddComponent(UIText, "attack")
  self.head = self:AddComponent(UICommonHead, "head")
end

function PlayerInfoCell:ComponentDestroy()
  self.name = nil
  self.attack = nil
  self.head = nil
end

function PlayerInfoCell:DataDefine()
  self.param = nil
end

function PlayerInfoCell:DataDestroy()
  self.param = nil
end

function PlayerInfoCell:GetNameStr()
  local nameStr
  if self.param.abbr then
    nameStr = "<color=#54c4f2>[%s]%s</color>"
  else
    nameStr = "<color=#54c4f2>%s</color>"
  end
  return nameStr
end

function PlayerInfoCell:ReInit(param)
  self.param = param
  self.head:SetData(self.param.uid, self.param.pic, self.param.picVer)
  self.head:SetEnableClickShowInfo(true)
  self.name:SetText(string.format(self:GetNameStr(), self.param.abbr, self.param.name))
  self.attack:SetText(string.GetFormattedSeperatorNum(math.floor(self.param.power)))
end

return PlayerInfoCell
