local MailArmyItem = BaseClass("MailArmyItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function MailArmyItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function MailArmyItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function MailArmyItem:ComponentDefine()
  self.quality1 = self:AddComponent(UIImage, "Left/quality1")
  self.quality2 = self:AddComponent(UIImage, "Right/quality2")
  self.icon1 = self:AddComponent(UIImage, "Left/icon1")
  self.icon2 = self:AddComponent(UIImage, "Right/icon2")
  self.num1 = self:AddComponent(UIText, "Left/num1")
  self.num2 = self:AddComponent(UIText, "Right/num2")
  self.level1 = self:AddComponent(UIText, "Left/level1")
  self.level2 = self:AddComponent(UIText, "Right/level2")
  self.slider1 = self:AddComponent(UISlider, "Left/slider1")
  self.slider2 = self:AddComponent(UISlider, "Right/slider2")
  self.left = self:AddComponent(UIBaseComponent, "Left")
  self.right = self:AddComponent(UIBaseComponent, "Right")
end

function MailArmyItem:ComponentDestroy()
  self.quality1 = nil
  self.quality2 = nil
  self.icon1 = nil
  self.icon2 = nil
  self.num1 = nil
  self.num2 = nil
  self.level1 = nil
  self.level2 = nil
  self.slider1 = nil
  self.slider2 = nil
end

function MailArmyItem:SetData(param1, param2, maxTotalPower)
  if param1 then
    self.left:SetActive(true)
    local meta1 = DataCenter.SoldierDataManager:GetTemplate(param1.soldierId)
    self.quality1:LoadSprite(UIUtil.GetItemQualityBg(meta1.quality))
    self.icon1:LoadSprite(string.format(LoadPath.ItemPath, meta1.icon))
    self.num1:SetText(string.GetFormattedStr(meta1.power * param1.total))
    self.level1:SetText("Lv." .. meta1.lv)
    self.slider1:SetValue(meta1.power * param1.total / maxTotalPower)
  else
    self.left:SetActive(false)
  end
  if param2 then
    self.right:SetActive(true)
    local meta2 = DataCenter.SoldierDataManager:GetTemplate(param2.soldierId)
    self.quality2:LoadSprite(UIUtil.GetItemQualityBg(meta2.quality))
    self.icon2:LoadSprite(string.format(LoadPath.ItemPath, meta2.icon))
    self.num2:SetText(string.GetFormattedStr(meta2.power * param2.total))
    self.level2:SetText("Lv." .. meta2.lv)
    self.slider2:SetValue(meta2.power * param2.total / maxTotalPower)
  else
    self.right:SetActive(false)
  end
end

function MailArmyItem:DataDefine()
end

function MailArmyItem:DataDestroy()
end

function MailArmyItem:OnEnable()
  base.OnEnable(self)
end

function MailArmyItem:OnDisable()
  base.OnDisable(self)
end

function MailArmyItem:OnAddListener()
  base.OnAddListener(self)
end

function MailArmyItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

return MailArmyItem
