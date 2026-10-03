local TacticalChipOpenPreTipItem = BaseClass("TacticalChipOpenPreTipItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local PATH = "Assets/Main/Sprites/UI/LWUITacticalWeaponChipFactory/%s.png"

function TacticalChipOpenPreTipItem:OnCreate()
  base.OnCreate(self)
  self.textDesc = self:AddComponent(UIText, "desc")
  self.btn = self:AddComponent(UIButton, "btn")
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.imgIcon = self:AddComponent(UIImage, "icon")
end

function TacticalChipOpenPreTipItem:OnDestroy()
  self.textDesc = nil
  self.btn = nil
  self.imgIcon = nil
  base.OnDestroy(self)
end

function TacticalChipOpenPreTipItem:OnEnable()
  base.OnEnable(self)
end

function TacticalChipOpenPreTipItem:OnDisable()
  base.OnDisable(self)
end

function TacticalChipOpenPreTipItem:SetData(param)
  self.param = param
  self.textDesc:SetLocalText(param.title)
  self.imgIcon:LoadSprite(string.format(PATH, param.icon))
end

function TacticalChipOpenPreTipItem:SetOnClick(onClick)
  self.onClick = onClick
end

function TacticalChipOpenPreTipItem:OnBtnClick()
  if self.onClick then
    self.onClick(self.param.desc)
  end
end

return TacticalChipOpenPreTipItem
