local Base = require("UI.UILWHero.UIHeroSimpleTip.View.UIArrowTipBase")
local UIHeroSimpleTipView = BaseClass("UIHeroSimpleTipView", Base)
local DEFAULT_DESC_COLOR = Color.New(0.2392, 0.2392, 0.2392, 1)

local function ComponentDefine(self)
  Base.ComponentDefine(self)
  self.descText = self:AddComponent(UIText, "Root/ImgBg/Content/DescText")
  self.titleText = self:AddComponent(UIText, "Root/ImgBg/Content/TitleText")
end

local function ComponentDestroy(self)
  self.descText = nil
  self.titleText = nil
  Base.ComponentDestroy(self)
end

local function RefreshShow(self)
  Base.RefreshShow(self)
  if string.IsNullOrEmpty(self.param.title) then
    self.titleText:SetActive(false)
  else
    self.titleText:SetActive(true)
    self.titleText:SetText(self.param.title)
  end
  self.descText:SetText(self.param.content)
  if self.param.descTxtColor then
    self.descText:SetColor(self.param.descTxtColor)
  else
    self.descText:SetColor(DEFAULT_DESC_COLOR)
  end
end

UIHeroSimpleTipView.ComponentDefine = ComponentDefine
UIHeroSimpleTipView.ComponentDestroy = ComponentDestroy
UIHeroSimpleTipView.RefreshShow = RefreshShow
return UIHeroSimpleTipView
