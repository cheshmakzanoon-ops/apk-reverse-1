local UIHeroSkillMedalNum = BaseClass("UIHeroSkillMedalNum", UIBaseContainer)
local base = UIBaseContainer

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.isSetPic = nil
  self.imgIcon = self:AddComponent(UIImage, "HeroSkillMedalIcon")
  self.textNum = self:AddComponent(UIText, "HeroSkillMedalNum")
  self.btn = self:AddComponent(UIButton, "AddBtn")
  self.btn:SetOnClick(BindCallback(self, self.OnBtnClick))
end

local function ComponentDestroy(self)
  self.imgIcon = nil
  self.textNum = nil
end

local function HideBtn(self)
  self.btn:SetActive(false)
end

local function RefreshView(self)
  local skillMedalId = HeroUtils.GetSkillMedalId()
  local num = DataCenter.ItemData:GetItemCount(skillMedalId)
  num = num or 0
  if self.isSetPic == nil then
    self.isSetPic = true
    self.imgIcon:LoadSprite(DataCenter.ItemTemplateManager:GetIconPath(tonumber(skillMedalId)))
  end
  self.textNum:SetText(string.GetFormattedSeperatorNum(num))
end

local function OnBtnClick(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroBag)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshItems, self.OnRefreshItems)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshItems, self.OnRefreshItems)
  base.OnRemoveListener(self)
end

local function OnRefreshItems(self)
  self:RefreshView()
end

UIHeroSkillMedalNum.OnCreate = OnCreate
UIHeroSkillMedalNum.OnDestroy = OnDestroy
UIHeroSkillMedalNum.ComponentDefine = ComponentDefine
UIHeroSkillMedalNum.ComponentDestroy = ComponentDestroy
UIHeroSkillMedalNum.RefreshView = RefreshView
UIHeroSkillMedalNum.HideBtn = HideBtn
UIHeroSkillMedalNum.OnBtnClick = OnBtnClick
UIHeroSkillMedalNum.OnAddListener = OnAddListener
UIHeroSkillMedalNum.OnRemoveListener = OnRemoveListener
UIHeroSkillMedalNum.OnRefreshItems = OnRefreshItems
return UIHeroSkillMedalNum
