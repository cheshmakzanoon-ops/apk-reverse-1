local base = UIBaseContainer
local UILWArmedUpgradeInfoContentView = BaseClass("UILWArmedUpgradeInfoContentView", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UILWArmedUpgradeInfoContentView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWArmedUpgradeInfoContentView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWArmedUpgradeInfoContentView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnArmedUpgradeJump = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnArmedUpgradeJump:SetOnClick(function()
    self:OnBtnArmedUpgradeJumpClick()
  end)
  self.sliderProgress = self.viewSkin:AddComponent(self, UISlider, 2)
  self.textProgress = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 4)
end

function UILWArmedUpgradeInfoContentView:ComponentDestroy()
  self.viewSkin = nil
  self.btnArmedUpgradeJump = nil
  self.sliderProgress = nil
  self.textProgress = nil
  self.imgIcon = nil
end

function UILWArmedUpgradeInfoContentView:DataDefine()
  self.heroId = nil
end

function UILWArmedUpgradeInfoContentView:DataDestroy()
  self.heroId = nil
end

function UILWArmedUpgradeInfoContentView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshItems, self.RefreshIsShow)
end

function UILWArmedUpgradeInfoContentView:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshItems, self.RefreshIsShow)
  base.OnRemoveListener(self)
end

function UILWArmedUpgradeInfoContentView:ReInit(heroId)
  self.heroId = heroId
  self:RefreshIsShow()
end

function UILWArmedUpgradeInfoContentView:RefreshIsShow()
  if self.heroId ~= DataCenter.LWArmedUpgradeManager.monicaHeroId then
    self:SetActive(false)
    return
  end
  local levelUpCondition, canLevelUp = DataCenter.LWArmedUpgradeManager:GetArmedUpgradeCanLevelUpData()
  self:SetActive(canLevelUp)
  if canLevelUp then
    self:RefreshArmedUpgradeProgress()
  end
end

function UILWArmedUpgradeInfoContentView:RefreshArmedUpgradeProgress()
  local curLevel = DataCenter.LWArmedUpgradeManager.armedUpgradeLevel
  local maxLevel = DataCenter.LWArmedUpgradeTemplateManager:GetArmedUpgradeMaxLevel()
  local value = Mathf.Clamp01(curLevel / maxLevel)
  self.sliderProgress:SetValue(value)
  self.textProgress:SetText(string.format("%s/%s", curLevel, maxLevel))
  local iconPath = string.format(LoadPath.UILWArmedUpgradeIconPath, "lrb_xinshou_bg")
  if LuaEntry.Player.JPUser then
    iconPath = string.format(LoadPath.UILWArmedUpgradeIconPath, "mjc_xinshou_bg")
  end
  self.imgIcon:LoadSpriteAuto(iconPath)
end

function UILWArmedUpgradeInfoContentView:OnBtnArmedUpgradeJumpClick()
  DataCenter.LWArmedUpgradeManager:JumpToArmedUpgradeCityModel(true)
end

return UILWArmedUpgradeInfoContentView
