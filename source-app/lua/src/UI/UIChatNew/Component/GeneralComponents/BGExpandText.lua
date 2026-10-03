local BGExpandText = BaseClass("BGExpandText", UIBaseContainer)
local base = UIBaseContainer
local compBook = {
  {
    path = "text",
    name = "text",
    type = UITextMeshProUGUIEx
  },
  {
    path = "bg",
    name = "bgImg",
    type = UIImage
  }
}

function BGExpandText:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function BGExpandText:ComponentDefine()
  self:DefineCompsByBook(compBook)
end

function BGExpandText:ReInit(param)
  if not param.interval then
    param.interval = 0
  end
  if param.islocalText then
    self.text:SetLocalText(param.text)
  else
    self.text:SetText(param.text)
  end
  self.textWidth = self.text:GetWidth()
  self.text:SetSizeDeltaXY(self.textWidth, self.text:GetSizeDelta().y)
  self.bgImg:LoadSprite(param.bgPath)
  self.width = self.textWidth + param.interval
  self.bgImg:SetSizeDeltaXY(self.width, self.bgImg:GetSizeDelta().y)
  self:SetSizeDeltaXY(self.width, self.bgImg:GetSizeDelta().y)
end

function BGExpandText:GetWidth()
  return self.width
end

function BGExpandText:OnDestroy()
  self:ClearCompsByBook(compBook)
end

return BGExpandText
