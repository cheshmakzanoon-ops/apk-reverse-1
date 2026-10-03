local LWSeasonBuildComboxItem = BaseClass("LWSeasonBuildComboxItem", UIToggle)
local base = UIToggle

function LWSeasonBuildComboxItem:OnCreate()
  base.OnCreate(self)
  self.txt_color_select = {
    r = 0.16470588235294117,
    g = 0.1568627450980392,
    b = 0.18823529411764706,
    a = 1
  }
  self.txt_color_gray = {
    r = 0.49019607843137253,
    g = 0.47843137254901963,
    b = 0.5411764705882353,
    a = 1
  }
  self.bg_color_1 = {
    r = 0.8941176470588236,
    g = 0.8901960784313725,
    b = 0.9215686274509803,
    a = 1
  }
  self.bg_color_2 = {
    r = 0.9803921568627451,
    g = 0.9764705882352941,
    b = 1.0,
    a = 1
  }
  self.txt = self:AddComponent(UIText, "txt")
  self.activeImg = self:AddComponent(UIImage, "active")
  self.bg = self:AddComponent(UIImage, "")
  self.bg:SetColor(self.bg_color_1)
  self.txt:SetColor(self.txt_color_gray)
  self:SetOnValueChanged(function(selected)
    self.activeImg:SetActive(selected)
    self.txt:SetColor(selected and self.txt_color_select or self.txt_color_gray)
    if selected and self.view and self.view.content1 then
      self.view.content1:SetFilter(self.data)
    end
  end)
end

function LWSeasonBuildComboxItem:SetIsOn(tf)
  base.SetIsOn(self, tf)
  self.activeImg:SetActive(tf)
  self.txt:SetColor(tf and self.txt_color_select or self.txt_color_gray)
end

function LWSeasonBuildComboxItem:OnDestroy()
  base.OnDestroy(self)
end

function LWSeasonBuildComboxItem:ReInit(index, data)
  self.data = data
  if data == nil or data == -1 then
    self.txt:SetLocalText("season_desert_UI002")
  elseif data == 0 then
    self.txt:SetLocalText("110245")
  else
    self.txt:SetLocalText("140002", data)
  end
  self.bg:SetColor(index % 2 == 0 and self.bg_color_2 or self.bg_color_1)
end

return LWSeasonBuildComboxItem
