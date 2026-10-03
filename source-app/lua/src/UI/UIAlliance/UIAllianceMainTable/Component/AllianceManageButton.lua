local AllianceManageButton = BaseClass("AllianceManageButton", UIBaseContainer)
local base = UIBaseContainer
local img_path = "icon"
local name_path = "name"
local red_pot_path = "ImgWarn"
local red_pot_txt_path = "ImgWarn/TxtNum"

local function OnCreate(self, data)
  base.OnCreate(self)
  self.itemData = data
  self.name = self:AddComponent(UIText, name_path)
  self.img = self:AddComponent(UIImage, img_path)
  self.btn = self:AddComponent(UIButton, img_path)
  self.red_pot = self:AddComponent(UIBaseContainer, red_pot_path)
  self.red_pot_txt = self:AddComponent(UIText, red_pot_txt_path)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.view.ctrl:OnGotoClick(self.itemData.type)
  end)
  self.name:SetText(self.itemData.name)
  self.img:LoadSprite(self.itemData.pic)
end

local function OnDestroy(self)
  self.itemData = nil
  self.name = nil
  self.img = nil
  self.btn = nil
  base.OnDestroy(self)
end

local function OnRefreshRedPot(self, type)
  local count = self.view.ctrl:GetRedPotCount(type)
  if 0 < count then
    self.red_pot:SetActive(true)
    self.red_pot_txt:SetText(count)
  else
    self.red_pot:SetActive(false)
  end
end

AllianceManageButton.OnCreate = OnCreate
AllianceManageButton.OnDestroy = OnDestroy
AllianceManageButton.OnRefreshRedPot = OnRefreshRedPot
return AllianceManageButton
