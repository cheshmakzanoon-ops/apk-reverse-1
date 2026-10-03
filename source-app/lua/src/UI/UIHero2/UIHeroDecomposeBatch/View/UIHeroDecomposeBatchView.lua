local UIHeroDecomposeBatchView = BaseClass("UIHeroDecomposeBatchView", UIBaseView)
local base = UIBaseView
local UIMedalCell = require("UI.UIHero2.UIHeroDebrisExchange.Component.UIMedalCell")

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:RefreshMedal()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function DataDefine(self)
  self.raritySelect = {}
end

local function ComponentDefine(self)
  self.textTitle = self:AddComponent(UIText, "UICommonMidPopUpTitle/titleText")
  self.textTitle:SetLocalText(129256)
  local panel = self:AddComponent(UIButton, "UICommonMidPopUpTitle/panel")
  panel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  local btnClose = self:AddComponent(UIButton, "UICommonMidPopUpTitle/CloseBtn")
  btnClose:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.itemCell = self:AddComponent(UIMedalCell, "Root/Info/UIItem")
  local composeBtn = self:AddComponent(UIButton, "Root/ComposeBtn")
  composeBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnDecomposeBtnClick()
  end)
  local composeBtnText = self:AddComponent(UIText, "Root/ComposeBtn/ComposeBtnText")
  composeBtnText:SetLocalText(110029)
  local skillItemGetTitle = self:AddComponent(UIText, "Root/Info/ComposeGetItemNumTitle")
  skillItemGetTitle:SetLocalText(100349)
  local rarityCText = self:AddComponent(UIText, "Root/Rarity/RarityC/RarityCText")
  rarityCText:SetLocalText(129259, string.GetFormattedSeperatorNum(self.ctrl:GetDecomposeItemNumByRarity(HeroUtils.RarityType.C)))
  local rarityBText = self:AddComponent(UIText, "Root/Rarity/RarityB/RarityBText")
  rarityBText:SetLocalText(129258, string.GetFormattedSeperatorNum(self.ctrl:GetDecomposeItemNumByRarity(HeroUtils.RarityType.B)))
  local rarityAText = self:AddComponent(UIText, "Root/Rarity/RarityA/RarityAText")
  rarityAText:SetLocalText(129257, string.GetFormattedSeperatorNum(self.ctrl:GetDecomposeItemNumByRarity(HeroUtils.RarityType.A)))
  local rarityABtn = self:AddComponent(UIButton, "Root/Rarity/RarityA/RarityABtn")
  rarityABtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnRarityClick(HeroUtils.RarityType.A)
  end)
  local rarityBBtn = self:AddComponent(UIButton, "Root/Rarity/RarityB/RarityBBtn")
  rarityBBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnRarityClick(HeroUtils.RarityType.B)
  end)
  local rarityCBtn = self:AddComponent(UIButton, "Root/Rarity/RarityC/RarityCBtn")
  rarityCBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnRarityClick(HeroUtils.RarityType.C)
  end)
  self.raritySelectIcons = {}
  self.raritySelectIcons[HeroUtils.RarityType.A] = self:AddComponent(UIImage, "Root/Rarity/RarityA/RarityASelectIcon")
  self.raritySelectIcons[HeroUtils.RarityType.A]:SetActive(false)
  self.raritySelectIcons[HeroUtils.RarityType.B] = self:AddComponent(UIImage, "Root/Rarity/RarityB/RarityBSelectIcon")
  self.raritySelectIcons[HeroUtils.RarityType.B]:SetActive(false)
  self.raritySelectIcons[HeroUtils.RarityType.C] = self:AddComponent(UIImage, "Root/Rarity/RarityC/RarityCSelectIcon")
  self.raritySelectIcons[HeroUtils.RarityType.C]:SetActive(false)
end

local function DataDestroy(self)
end

local function ComponentDestroy(self)
end

local function OnDecomposeBtnClick(self)
  if table.count(self.raritySelect) == 0 then
    return
  end
  self.ctrl:Decompose(self.raritySelect)
end

local function SelectRarity(self, rarity)
  local selectIcon = self.raritySelectIcons[rarity]
  if selectIcon ~= nil then
    self.raritySelect[rarity] = 1
    selectIcon:SetActive(true)
  end
  self:RefreshMedal()
end

local function RefreshMedal(self)
  local id = HeroUtils.GetSkillMedalId()
  local num = self.ctrl:GetDecomposeNum(self.raritySelect)
  self.itemCell:SetData(id, num)
end

local function CancelRarity(self, rarity)
  self.raritySelect[rarity] = nil
  local selectIcon = self.raritySelectIcons[rarity]
  if selectIcon ~= nil then
    selectIcon:SetActive(false)
  end
  self:RefreshMedal()
end

local function OnRarityClick(self, rarity)
  if self.raritySelect[rarity] == nil then
    self:SelectRarity(rarity)
  else
    self:CancelRarity(rarity)
  end
end

UIHeroDecomposeBatchView.OnCreate = OnCreate
UIHeroDecomposeBatchView.OnDestroy = OnDestroy
UIHeroDecomposeBatchView.ComponentDefine = ComponentDefine
UIHeroDecomposeBatchView.ComponentDestroy = ComponentDestroy
UIHeroDecomposeBatchView.OnDecomposeBtnClick = OnDecomposeBtnClick
UIHeroDecomposeBatchView.DataDestroy = DataDestroy
UIHeroDecomposeBatchView.DataDefine = DataDefine
UIHeroDecomposeBatchView.OnRarityClick = OnRarityClick
UIHeroDecomposeBatchView.CancelRarity = CancelRarity
UIHeroDecomposeBatchView.SelectRarity = SelectRarity
UIHeroDecomposeBatchView.RefreshMedal = RefreshMedal
return UIHeroDecomposeBatchView
