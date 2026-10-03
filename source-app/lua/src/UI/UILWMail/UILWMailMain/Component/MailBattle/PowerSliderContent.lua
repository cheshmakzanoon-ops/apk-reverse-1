local PowerSliderContent = BaseClass("PowerSliderContent", UIBaseContainer)
local base = UIBaseContainer

function PowerSliderContent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function PowerSliderContent:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function PowerSliderContent:ComponentDefine()
  self.left_slider = self:AddComponent(UISlider, "left_slider")
  self.right_slider = self:AddComponent(UISlider, "right_slider")
  self.left_txt = self:AddComponent(UIText, "left_slider/left_txt")
  self.right_txt = self:AddComponent(UIText, "right_slider/right_txt")
  self.title_txt = self:AddComponent(UIText, "title_txt")
  self.title_img = self:AddComponent(UIImage, "title_txt/title_image")
end

function PowerSliderContent:ComponentDestroy()
  self.left_slider = nil
  self.right_slider = nil
  self.left_txt = nil
  self.right_txt = nil
  self.title_txt = nil
  self.title_img = nil
end

function PowerSliderContent:SetData(leftVal, rightVal, title, titleImgPath)
  local maxVal = math.max(leftVal, rightVal)
  self.left_txt:SetText(string.GetFormattedStr(leftVal))
  self.right_txt:SetText(string.GetFormattedStr(rightVal))
  self.left_slider:SetValue(leftVal / maxVal)
  self.right_slider:SetValue(rightVal / maxVal)
  self.title_txt:SetText(title)
  self.title_img:LoadSprite(titleImgPath)
end

return PowerSliderContent
