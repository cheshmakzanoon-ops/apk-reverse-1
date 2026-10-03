local MailTacticalDamageItem = BaseClass("MailTacticalDamageItem", UIBaseContainer)
local base = UIBaseContainer
local UILWTacticalWeaponItem = require("UI.UILWTacticalWeapon.Component.UILWTacticalWeaponItem")
local fill1_path = "left/DamageSlider1/Fill Area/Fill1"
local fill2_path = "right/DamageSlider2/Fill Area/Fill2"

function MailTacticalDamageItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function MailTacticalDamageItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function MailTacticalDamageItem:ComponentDefine()
  self.left = self:AddComponent(UIBaseComponent, "left")
  self.right = self:AddComponent(UIBaseComponent, "right")
  self.tacticalIcon1 = self:AddComponent(UILWTacticalWeaponItem, "left/UILWTacticalWeaponItem1")
  self.tacticalIcon2 = self:AddComponent(UILWTacticalWeaponItem, "right/UILWTacticalWeaponItem2")
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
  self.leftFillImg = self:AddComponent(UIImage, fill1_path)
  self.rightFillImg = self:AddComponent(UIImage, fill2_path)
end

function MailTacticalDamageItem:ComponentDestroy()
  self.HeroCellSmall1 = nil
  self.HeroCellSmall2 = nil
  self.DamageTxt1 = nil
  self.DamageTxt2 = nil
  self.DamageSlider1 = nil
  self.DamageSlider2 = nil
end

function MailTacticalDamageItem:SetData(extData, hero1, hero2, isDamage, maxDamage, maxInjured)
  local realMaxDamage = extData.maxDamage
  if maxDamage then
    realMaxDamage = maxDamage
  end
  local realMaxInjured = extData.maxInjured
  if maxInjured then
    realMaxInjured = maxInjured
  end
  local isLeftEmpty = true
  local isRightEmpty = true
  if hero1 then
    self.left:SetActive(true)
    local weaponId1 = hero1.heroId
    local weaponLevel1 = hero1.heroLevel
    local weaponSkinId1 = hero1.skinId
    self.tacticalIcon1:SetConfigId(weaponId1, weaponLevel1, weaponSkinId1)
    if isDamage then
      self.DamageTxt1:SetText(string.GetFormattedStr(hero1.stat.damage))
      self.DamageSlider1:SetValue(hero1.stat.damage / realMaxDamage)
      isLeftEmpty = hero1.stat.damage == 0
    else
      self.DamageTxt1:SetText(string.GetFormattedStr(hero1.stat.injured))
      self.DamageSlider1:SetValue(hero1.stat.injured / realMaxInjured)
      isLeftEmpty = hero1.stat.injured == 0
    end
  else
    self.left:SetActive(false)
  end
  if hero2 then
    self.right:SetActive(true)
    local weaponId2 = hero2.heroId
    local weaponLevel2 = hero2.heroLevel
    local weaponSkinId2 = hero2.skinId
    self.tacticalIcon2:SetConfigId(weaponId2, weaponLevel2, weaponSkinId2)
    if isDamage then
      self.DamageTxt2:SetText(string.GetFormattedStr(hero2.stat.damage))
      self.DamageSlider2:SetValue(hero2.stat.damage / realMaxDamage)
      isRightEmpty = hero2.stat.damage == 0
    else
      self.DamageTxt2:SetText(string.GetFormattedStr(hero2.stat.injured))
      self.DamageSlider2:SetValue(hero2.stat.injured / realMaxInjured)
      isRightEmpty = hero2.stat.injured == 0
    end
  else
    self.right:SetActive(false)
  end
  self.isDamage = isDamage
  self.hero1 = hero1
  self.hero2 = hero2
  if hero1 then
    self.left_btn:SetActive(HeroUtils.HasDetailStatFromMailTacticalStat(hero1.stat, self.isDamage))
  end
  if hero2 then
    self.right_btn:SetActive(HeroUtils.HasDetailStatFromMailTacticalStat(hero2.stat, self.isDamage))
  end
  local fillImgPath = isDamage and "Assets/Main/Sprites/UI/UILWMail/lyp_zdhf_jindutiao_huang.png" or "Assets/Main/Sprites/UI/UILWMail/lyp_zdhf_jindutiao_hong.png"
  self.leftFillImg:LoadSprite(fillImgPath)
  self.rightFillImg:LoadSprite(fillImgPath)
  if isRightEmpty and isLeftEmpty then
    if self.holder then
      self.holder:SetActive(false)
    end
  elseif self.holder then
    self.holder:SetActive(true)
  end
end

function MailTacticalDamageItem:DataDefine()
end

function MailTacticalDamageItem:DataDestroy()
  self.isDamage = nil
  self.hero1 = nil
  self.hero2 = nil
end

function MailTacticalDamageItem:OnEnable()
  base.OnEnable(self)
end

function MailTacticalDamageItem:OnDisable()
  base.OnDisable(self)
end

function MailTacticalDamageItem:OnAddListener()
  base.OnAddListener(self)
end

function MailTacticalDamageItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function MailTacticalDamageItem:OnClick(isLeft)
  local hero = isLeft and self.hero1 or self.hero2
  if hero and hero.stat then
    local detailStr = HeroUtils.GetDetailStatFromMailTacticalStat(hero.stat, self.isDamage)
    if not string.IsNullOrEmpty(detailStr) then
      local param = DataCenter.ArrowTipParamManager:Get(ArrowTipEnumtype.Type.HeroSimpleTip)
      local titleStrKey = self.isDamage and "power_display_new_102" or "power_display_new_103"
      param.title = UIUtil.GetString("", titleStrKey)
      param.content = detailStr
      param.alignObject = isLeft and self.left_btn_icon.gameObject or self.right_btn_icon.gameObject
      param.width = 400
      param.yPosFix = 10
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroSimpleTip, {anim = true}, param)
    end
  end
end

return MailTacticalDamageItem
