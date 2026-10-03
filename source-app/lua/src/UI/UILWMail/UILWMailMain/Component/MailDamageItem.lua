local MailDamageItem = BaseClass("MailDamageItem", UIBaseContainer)
local base = UIBaseContainer
local UIHeroCellSmall = require("UI.UIHero2.Common.UIHeroCellSmall")
local UILWTacticalWeaponItem = require("UI.UILWTacticalWeapon.Component.UILWTacticalWeaponItem")

function MailDamageItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function MailDamageItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function MailDamageItem:ComponentDefine()
  self.left = self:AddComponent(UIBaseComponent, "left")
  self.right = self:AddComponent(UIBaseComponent, "right")
  self.HeroCellSmall1 = self:AddComponent(UIHeroCellSmall, "left/UIHeroCellSmall1")
  self.HeroCellSmall2 = self:AddComponent(UIHeroCellSmall, "right/UIHeroCellSmall2")
  self.DamageTxt1 = self:AddComponent(UIText, "left/DamageTxt1")
  self.DamageTxt2 = self:AddComponent(UIText, "right/DamageTxt2")
  self.DamageSlider1 = self:AddComponent(UISlider, "left/DamageSlider1")
  self.DamageSlider2 = self:AddComponent(UISlider, "right/DamageSlider2")
  self.left_btn = self:AddComponent(UIButton, "left/btn1")
  self.left_btn:SetOnClick(function()
    self:OnClick(true)
  end)
  self.left_btn_icon = self:AddComponent(UIImage, "left/btn1/icon1")
  self.right_btn = self:AddComponent(UIButton, "right/btn2")
  self.right_btn:SetOnClick(function()
    self:OnClick(false)
  end)
  self.right_btn_icon = self:AddComponent(UIImage, "right/btn2/icon2")
end

function MailDamageItem:ComponentDestroy()
  self.HeroCellSmall1 = nil
  self.HeroCellSmall2 = nil
  self.DamageTxt1 = nil
  self.DamageTxt2 = nil
  self.DamageSlider1 = nil
  self.DamageSlider2 = nil
end

function MailDamageItem:SetData(extData, hero1, hero2, isDamage, maxDamage, maxInjured, player1, player2)
  local realMaxDamage = extData.maxDamage
  if maxDamage then
    realMaxDamage = maxDamage
  end
  local realMaxInjured = extData.maxInjured
  if maxInjured then
    realMaxInjured = maxInjured
  end
  if hero1 then
    self.left:SetActive(true)
    if hero1.unitType ~= BattleUnitType.TacticalWeapon then
      self.HeroCellSmall1:SetActive(true)
      self.HeroCellSmall1:InitWithConfigId(hero1.heroId, nil, hero1.heroLevel, hero1.rankLv, hero1.weaponLevel, hero1.awakenLv, hero1.heroSkinId)
      if player1 then
        local armyCfg = DataCenter.LWArmyTemplateManager:TryGetArmyTemplate(player1.contentId)
        if armyCfg and not string.IsNullOrEmpty(armyCfg.replace_icon) then
          self.HeroCellSmall1:SetImgIcon(armyCfg.replace_icon)
        end
      end
    end
    if isDamage then
      self.DamageTxt1:SetText(string.GetFormattedStr(hero1.stat.damage))
      self.DamageSlider1:SetValue(hero1.stat.damage / realMaxDamage)
    else
      self.DamageTxt1:SetText(string.GetFormattedStr(hero1.stat.injured))
      self.DamageSlider1:SetValue(hero1.stat.injured / realMaxInjured)
    end
  else
    self.left:SetActive(false)
  end
  if hero2 then
    self.right:SetActive(true)
    if hero2.unitType ~= BattleUnitType.TacticalWeapon then
      self.HeroCellSmall2:SetActive(true)
      self.HeroCellSmall2:InitWithConfigId(hero2.heroId, nil, hero2.heroLevel, hero2.rankLv, hero2.weaponLevel, hero2.awakenLv, hero2.heroSkinId)
      if player2 then
        local armyCfg = DataCenter.LWArmyTemplateManager:TryGetArmyTemplate(player2.contentId)
        if armyCfg and not string.IsNullOrEmpty(armyCfg.replace_icon) then
          self.HeroCellSmall2:SetImgIcon(armyCfg.replace_icon)
        end
      end
    end
    if isDamage then
      self.DamageTxt2:SetText(string.GetFormattedStr(hero2.stat.damage))
      self.DamageSlider2:SetValue(hero2.stat.damage / realMaxDamage)
    else
      self.DamageTxt2:SetText(string.GetFormattedStr(hero2.stat.injured))
      self.DamageSlider2:SetValue(hero2.stat.injured / realMaxInjured)
    end
  else
    self.right:SetActive(false)
  end
  self.isDamage = isDamage
  self.hero1 = hero1
  self.hero2 = hero2
  if hero1 then
    self.left_btn:SetActive(HeroUtils.HasDetialStatFromMailHeroStat(hero1.stat, self.isDamage))
  end
  if hero2 then
    self.right_btn:SetActive(HeroUtils.HasDetialStatFromMailHeroStat(hero2.stat, self.isDamage))
  end
end

function MailDamageItem:DataDefine()
end

function MailDamageItem:DataDestroy()
  self.isDamage = nil
  self.hero1 = nil
  self.hero2 = nil
end

function MailDamageItem:OnEnable()
  base.OnEnable(self)
end

function MailDamageItem:OnDisable()
  base.OnDisable(self)
end

function MailDamageItem:OnAddListener()
  base.OnAddListener(self)
end

function MailDamageItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function MailDamageItem:OnClick(isLeft)
  local hero = isLeft and self.hero1 or self.hero2
  if hero and hero.stat then
    local detailStr = HeroUtils.GetDetialStatFromMailHeroStat(hero.stat, self.isDamage)
    if not string.IsNullOrEmpty(detailStr) then
      local param = DataCenter.ArrowTipParamManager:Get(ArrowTipEnumtype.Type.HeroSimpleTip)
      param.title = UIUtil.GetString("", "battle_stats_detail1")
      param.content = detailStr
      param.alignObject = isLeft and self.left_btn_icon.gameObject or self.right_btn_icon.gameObject
      param.width = 400
      param.yPosFix = 10
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroSimpleTip, {anim = true}, param)
    end
  end
end

return MailDamageItem
