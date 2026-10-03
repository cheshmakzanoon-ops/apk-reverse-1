local BuffBar = BaseClass("BuffBar", UIBaseContainer)
local base = UIBaseContainer

function BuffBar:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function BuffBar:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function BuffBar:ComponentDefine()
  self.buffIcon = self:AddComponent(UIImage, "")
  self.text = self:AddComponent(UIText, "text")
end

function BuffBar:ComponentDestroy()
  self.buff = nil
end

function BuffBar:OnAddListener()
  base.OnAddListener(self)
end

function BuffBar:OnRemoveListener()
  base.OnRemoveListener(self)
end

function BuffBar:SetData(buff)
  self.buff = buff
  local color = WhiteColor
  if self.buff.meta.sub_type == BuffSubType.ReduceDamage then
    color = CyanColor
  elseif self.buff.target then
    color = RedColor
  end
  self.text:SetColor(color)
  self:OnUpdateSec()
end

function BuffBar:OnUpdateSec()
  local txt
  if self.buff.duration and self.buff.meta.buff_time > 0 then
    local remain = math.floor(self.buff.duration)
    txt = self.buff.meta.id .. "," .. remain
    self.buffIcon:SetFillAmount(self.buff.duration / self.buff.meta.buff_time)
  else
    txt = self.buff.meta.id .. "," .. "\230\151\160\233\153\144"
    self.buffIcon:SetFillAmount(1)
  end
  if self.buff.target and self.buff.target.index then
    txt = txt .. "," .. self.buff.target.index
  end
  self.text:SetText(txt)
end

return BuffBar
