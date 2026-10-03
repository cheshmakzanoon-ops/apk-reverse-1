local Base = require("UI.UILWHero.UIHeroSimpleTip.View.UIArrowTipBase")
local UICommonSimpleTipView = BaseClass("UICommonSimpleTipView", Base)
local DEFAULT_DESC_COLOR = Color.New(0.2392, 0.2392, 0.2392, 1)
local Localization = CS.GameEntry.Localization

local function ComponentDefine(self)
  Base.ComponentDefine(self)
  self.descText = self:AddComponent(UITextMeshProUGUIEx, "Root/ImgBg/Content/DescText")
  self.titleText = self:AddComponent(UITextMeshProUGUIEx, "Root/ImgBg/Content/TitleText")
  self.contentLayout = self:AddComponent(UIHorizontalOrVerticalLayoutGroup, "Root/ImgBg/Content")
end

local function ComponentDestroy(self)
  self.descText = nil
  self.titleText = nil
  self.contentLayout = nil
  Base.ComponentDestroy(self)
end

local function RefreshShow(self)
  Base.RefreshShow(self)
  if self.param.isTitleCountDown then
    local timeStr = UITimeManager:GetInstance():MilliSecondToFmtString(self.param.time)
    if not string.IsNullOrEmpty(self.param.title) then
      self.titleText:SetLocalText(self.param.title, timeStr)
    else
      self.titleText:SetText(timeStr)
    end
    self.titleText:SetActive(true)
    self.descText:SetLocalText(self.param.content)
  else
    if string.IsNullOrEmpty(self.param.title) then
      self.titleText:SetActive(false)
    else
      self.titleText:SetActive(true)
      self.titleText:SetText(self.param.title)
    end
    if self.param.time then
      local timeStr = UITimeManager:GetInstance():MilliSecondToFmtString(self.param.time)
      self.descText:SetLocalText(self.param.content, timeStr)
    else
      self.descText:SetLocalText(self.param.content)
    end
  end
  if self.param.descTxtColor then
    self.descText:SetColor(self.param.descTxtColor)
  else
    self.descText:SetColor(DEFAULT_DESC_COLOR)
  end
  self:DelayCallCloseSelf()
  self:Update1000MS()
  if self.param.contentAlignType then
    self.contentLayout:SetChildAlignment(self.param.contentAlignType)
  end
end

function UICommonSimpleTipView:DelayCallCloseSelf()
  if self.param.countDown then
    TimerManager:GetInstance():DelayInvoke(function()
      if self and self.ctrl then
        self.ctrl:CloseSelf()
      end
    end, self.param.countDown)
  end
end

function UICommonSimpleTipView:Update1000MS()
  if self.param.time then
    if not self.param.isTitleCountDown then
      local timeStr = UITimeManager:GetInstance():MilliSecondToFmtString(self.param.time)
      self.descText:SetLocalText(self.param.content, timeStr)
      self.param.time = self.param.time - 1000
    else
      local str = ""
      if not string.IsNullOrEmpty(self.param.title) then
        str = Localization:GetString(self.param.title, self.param.time)
      else
        str = UITimeManager:GetInstance():MilliSecondToFmtString(self.param.time)
      end
      self.titleText:SetText(str)
      self.param.time = self.param.time - 1000
    end
  end
end

UICommonSimpleTipView.ComponentDefine = ComponentDefine
UICommonSimpleTipView.ComponentDestroy = ComponentDestroy
UICommonSimpleTipView.RefreshShow = RefreshShow
return UICommonSimpleTipView
