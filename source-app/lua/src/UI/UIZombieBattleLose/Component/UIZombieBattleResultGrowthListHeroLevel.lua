local UIZombieBattleResultGrowthListHeroLevel = BaseClass("UIZombieBattleResultGrowthListHeroLevel", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local title_path = "Title"
local goto_btn_path = "GotoBtn"
local btn_text_path = "GotoBtn/BtnText"
local icon_path = "Icon"
local effSoft_path = "soft_Eff_ui_shibai_saoguang"

function UIZombieBattleResultGrowthListHeroLevel:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIZombieBattleResultGrowthListHeroLevel:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIZombieBattleResultGrowthListHeroLevel:OnEnable()
  base.OnEnable(self)
end

function UIZombieBattleResultGrowthListHeroLevel:OnDisable()
  base.OnDisable(self)
end

function UIZombieBattleResultGrowthListHeroLevel:ComponentDefine()
  self.title = self:AddComponent(UIText, title_path)
  self.goto_btn = self:AddComponent(UIButton, goto_btn_path)
  self.animator = self.goto_btn.gameObject:GetComponent(typeof(CS.UnityEngine.Animator))
  self.btn_text = self:AddComponent(UIText, btn_text_path)
  if not IsNull(self.transform:Find(icon_path)) then
    self.icon = self:AddComponent(UIImage, icon_path)
  end
  self.effSoft = self:AddComponent(UIBaseComponent, effSoft_path)
  self.effSoft:SetActive(false)
  self:OnUpdateSec()
  self.updateSecTimer = TimerManager:GetInstance():GetTimer(3.88, self.OnUpdateSec, self, false, false, false)
  self.updateSecTimer:Start()
end

function UIZombieBattleResultGrowthListHeroLevel:OnUpdateSec()
  self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.effSoft:SetActive(false)
    self.effSoft:SetActive(true)
    self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.animator:Play("V_ui_NewbiesHeroLevelContent", 0, 0)
      self.delayTimer = nil
    end, 1)
  end, 2)
end

function UIZombieBattleResultGrowthListHeroLevel:ComponentDestroy()
  self.title = nil
  self.goto_btn = nil
  self.btn_text = nil
  self.effSoft = nil
  self.animator = nil
  if self.updateSecTimer then
    self.updateSecTimer:Stop()
    self.updateSecTimer = nil
  end
  if self.delayTimer then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
end

function UIZombieBattleResultGrowthListHeroLevel:RefreshView(title, btnText, obj, action)
  self.title:SetText(title)
  self.btn_text:SetLocalText(btnText)
  self.goto_btn:SetOnClick(BindCallback(obj, action))
end

function UIZombieBattleResultGrowthListHeroLevel:RefreshShowView(title, iconPath)
  self.title:SetText(title)
  if self.icon then
    self.icon:LoadSprite(iconPath)
  end
end

return UIZombieBattleResultGrowthListHeroLevel
