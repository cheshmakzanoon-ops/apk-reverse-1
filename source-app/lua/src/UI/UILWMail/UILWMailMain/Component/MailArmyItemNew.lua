local MailArmyItemNew = BaseClass("MailArmyItemNew", UIBaseContainer)
local base = UIBaseContainer

function MailArmyItemNew:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function MailArmyItemNew:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function MailArmyItemNew:GetMoraleTipContent(army)
  local result = ""
  if not army then
    return result
  end
  result = string.format([[
%s : %d 
%s : %s]], UIUtil.GetString("", "211240"), army.baseMorale, UIUtil.GetString("", "211241"), string.format("%.2f%%", army.moraleRatio * 100))
  if army.cardMoraleRatio and army.cardMoraleRatio > 0 then
    result = string.format([[
%s
%s : %s]], result, UIUtil.GetString("", "battle_card_report_tips"), string.format("%.2f%%", army.cardMoraleRatio * 100))
  end
  return result
end

function MailArmyItemNew:ComponentDefine()
  self.quality = self:AddComponent(UIImage, "Middle/quality")
  self.icon = self:AddComponent(UIImage, "Middle/icon")
  self.level = self:AddComponent(UIText, "Middle/level")
  self.moraleNum1 = self:AddComponent(UIText, "Left/moraleDetail_btn1/MoraleNum1")
  self.moraleNum2 = self:AddComponent(UIText, "Right/moraleDetail_btn2/MoraleNum2")
  self.soldierNum1 = self:AddComponent(UIText, "Left/SoldierNum1")
  self.soldierNum2 = self:AddComponent(UIText, "Right/SoldierNum2")
  self.left = self:AddComponent(UIBaseComponent, "Left")
  self.right = self:AddComponent(UIBaseComponent, "Right")
  self.moraleDetail_btn1 = self:AddComponent(UIButton, "Left/moraleDetail_btn1")
  self.moraleDetail_btn2 = self:AddComponent(UIButton, "Right/moraleDetail_btn2")
  self.moraleDetail_btn1:SetOnClick(function()
    if self.armyInfo.army1 then
      local param = DataCenter.ArrowTipParamManager:Get(ArrowTipEnumtype.Type.HeroSimpleTip)
      param.title = nil
      param.content = self:GetMoraleTipContent(self.armyInfo.army1)
      param.alignObject = self.moraleNum1.transform
      param.width = 400
      param.yPosFix = 10
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroSimpleTip, {anim = true}, param)
    end
  end)
  self.moraleDetail_btn2:SetOnClick(function()
    if self.armyInfo.army2 then
      local param = DataCenter.ArrowTipParamManager:Get(ArrowTipEnumtype.Type.HeroSimpleTip)
      param.title = nil
      param.content = self:GetMoraleTipContent(self.armyInfo.army2)
      param.alignObject = self.moraleNum2.transform
      param.width = 400
      param.yPosFix = 10
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroSimpleTip, {anim = true}, param)
    end
  end)
end

function MailArmyItemNew:ComponentDestroy()
  self.quality = nil
  self.icon = nil
  self.moraleNum1 = nil
  self.moraleNum2 = nil
  self.level = nil
  self.soldierNum1 = nil
  self.soldierNum2 = nil
end

function MailArmyItemNew:SetData(armyInfo)
  if armyInfo.army1 or armyInfo.army2 then
    local soldierId = (not armyInfo.army1 or not armyInfo.army1.soldierId) and armyInfo.army2 and armyInfo.army2.soldierId
    local meta1 = DataCenter.SoldierDataManager:GetTemplate(soldierId)
    self.quality:LoadSprite(UIUtil.GetItemQualityBg(meta1.quality))
    local soldierEleven = (not armyInfo.army1 or not armyInfo.army1.soldierEleven) and armyInfo.army2 and armyInfo.army2.soldierEleven
    local type = T11SoldierType.T11NotUnLock
    local stage = 0
    if soldierEleven then
      stage = soldierEleven and soldierEleven.stage or 0
      type = T11Util.GetSoldierTypeByEffectList(soldierEleven.effects)
    end
    local soldierIcon = DataCenter.SoldierDataManager:GetSoldierIconById(soldierId, {type = type, stage = stage})
    self.icon:LoadSpriteAsync(soldierIcon)
    self.level:SetText("Lv." .. meta1.lv)
  end
  if armyInfo.army1 then
    local moraleNumStr = string.GetFormattedStr2(armyInfo.army1.morale)
    if 0 < armyInfo.army1.morale then
      moraleNumStr = string.format("<u>%s</u>", moraleNumStr)
      self.moraleDetail_btn1:SetEnable(true)
    else
      self.moraleDetail_btn1:SetEnable(false)
    end
    self.moraleNum1:SetText(moraleNumStr)
    self.soldierNum1:SetText(string.GetFormattedSeparatorNum(armyInfo.army1.count))
  else
    self.moraleNum1:SetText(0)
    self.soldierNum1:SetText(0)
  end
  if armyInfo.army2 then
    local moraleNumStr = string.GetFormattedStr2(armyInfo.army2.morale)
    if 0 < armyInfo.army2.morale then
      moraleNumStr = string.format("<u>%s</u>", moraleNumStr)
      self.moraleDetail_btn2:SetEnable(true)
    else
      self.moraleDetail_btn2:SetEnable(false)
    end
    self.moraleNum2:SetText(moraleNumStr)
    self.soldierNum2:SetText(string.GetFormattedSeparatorNum(armyInfo.army2.count))
  else
    self.moraleNum2:SetText(0)
    self.soldierNum2:SetText(0)
  end
  self.armyInfo = armyInfo
end

function MailArmyItemNew:OnEnable()
  base.OnEnable(self)
end

function MailArmyItemNew:OnDisable()
  base.OnDisable(self)
end

function MailArmyItemNew:OnAddListener()
  base.OnAddListener(self)
end

function MailArmyItemNew:OnRemoveListener()
  base.OnRemoveListener(self)
end

return MailArmyItemNew
