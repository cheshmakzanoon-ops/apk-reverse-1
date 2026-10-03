local UILWNewCenterTabItem = BaseClass("UILWNewCenterTabItem", UIBaseContainer)
local base = UIBaseContainer

function UILWNewCenterTabItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.temRed = nil
end

function UILWNewCenterTabItem:OnDestroy()
  self:ComponentDestroy()
  self.temRed = nil
  base.OnDestroy(self)
end

function UILWNewCenterTabItem:ComponentDefine()
  self.nameText = self:AddComponent(UITextMeshProUGUIEx, "tabName")
  self.btn = self:AddComponent(UIButton, "")
  self.bgImg = self:AddComponent(UIImage, "bg")
  self.redNewTip = self:AddComponent(UIImage, "redNew")
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
end

function UILWNewCenterTabItem:ComponentDestroy()
  self.nameText = nil
  self.btn = nil
end

function UILWNewCenterTabItem:OnBtnClick()
  if self.callBack then
    self.callBack(self.data.tabType)
  end
end

function UILWNewCenterTabItem:SetState(tabType)
  if self.data and tabType == self.data.tabType then
    self.nameText:SetColor(self.data.clickColor)
    self.bgImg:LoadSprite(self.data.clickBgPath)
    if self.data.tabType == ChatNewsCenterTabType.News then
      PostEventLog.Track(PostEventLog.Defines.NewsCenterCheck, {})
      self:RefreshRedNew()
    else
      self.redNewTip:SetActive(false)
      self.temRed = true
    end
  else
    self.nameText:SetColor(self.data.color)
    self.bgImg:LoadSprite(self.data.bgPath)
  end
end

function UILWNewCenterTabItem:Refresh(data, callBack)
  self.data = data
  self.callBack = callBack
  self.nameText:SetLocalText(data.textKey)
  self:RefreshRedNew()
end

function UILWNewCenterTabItem:SetActiveNewTip(isOn)
  self.redNewTip:SetActive(isOn)
end

function UILWNewCenterTabItem:RefreshRedNew()
  if self.data.tabType == ChatNewsCenterTabType.StrategyGuide or self.data.tabType == ChatNewsCenterTabType.Announcement then
    local showRed = DataCenter.LWNewsCenterManager:GetRedNew(self.data.tabType)
    self.showNewTip = showRed
    self.redNewTip:SetActive(showRed)
  elseif self.data.tabType == ChatNewsCenterTabType.News then
    local guide = DataCenter.LWNewsCenterManager:GetRedNew(ChatNewsCenterTabType.StrategyGuide)
    local cement = DataCenter.LWNewsCenterManager:GetRedNew(ChatNewsCenterTabType.Announcement)
    self.redNewTip:SetActive(guide or cement)
    self.showNewTip = guide or cement
  else
    self.redNewTip:SetActive(false)
  end
end

function UILWNewCenterTabItem:OnClickBtn()
end

return UILWNewCenterTabItem
