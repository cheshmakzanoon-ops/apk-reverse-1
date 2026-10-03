local base = UIBaseContainer
local UILWAlliancePrivilegeItemRender = BaseClass("UILWAlliancePrivilegeItemRender", base)
local UILWScienceDetailDesc = require("UI/UILWScience/UILWScienceDetail/Component/UILWScienceDetailDesc")
local bg_path = "Bg"
local unlockIconBg_path = "UnlockIconBg"
local icon_path = "Icon"
local lockIconBg_path = "LockIconBg"
local lockTipsText_path = "LockTipsText"
local lockTipsImg_path = "LockTipsImg"
local nameText_path = "NameText"
local desText_path = "DesText"
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.unlockIconBg = self:AddComponent(UIBaseContainer, unlockIconBg_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.lockIconBg = self:AddComponent(UIBaseContainer, lockIconBg_path)
  self.lockTipsText = self:AddComponent(UIText, lockTipsText_path)
  self.lockTipsImg = self:AddComponent(UIImage, lockTipsImg_path)
  self.nameText = self:AddComponent(UILWScienceDetailDesc, nameText_path)
  self.desText = self:AddComponent(UIText, desText_path)
end

local function ComponentDestroy(self)
  self.bg = nil
  self.unlockIconBg = nil
  self.icon = nil
  self.lockIconBg = nil
  self.lockTipsText = nil
  self.nameText = nil
  self.desText = nil
end

local function DataDefine(self)
  self.template = nil
end

local function DataDestroy(self)
  self.template = nil
end

local function ReInit(self, template)
  self.template = template
  local curGiftLevel = DataCenter.AllianceGiftDataManager:GetCurLevel()
  local isUnlock = curGiftLevel >= self.template.gift_lv
  self.lockIconBg:SetActive(not isUnlock)
  self.unlockIconBg:SetActive(isUnlock)
  if isUnlock then
    self.bg:SetColorRGBA255(203, 211, 230)
    self.lockTipsText:SetColorRGBA255(95, 240, 135, 255)
    self.lockTipsImg:LoadSprite("Assets/Main/Sprites/UI/UILWAllianceLog/lrb_rumengtiaojian_duihao.png")
    self.lockTipsText:SetLocalText("135203", self.template.gift_lv)
  else
    self.bg:SetColorRGBA255(216, 213, 217)
    self.lockTipsText:SetColorRGBA255(249, 112, 119, 255)
    self.lockTipsImg:LoadSprite("Assets/Main/Sprites/UI/UILWAllianceLog/lrb_rumengtiaojian_suo.png")
    self.lockTipsText:SetLocalText("135203", self.template.gift_lv)
  end
  self.icon:LoadSprite(self.template.icon)
  self.nameText:SetTextAndParam(Localization:GetString(self.template.title))
  self.desText:SetLocalText(self.template.desc)
end

UILWAlliancePrivilegeItemRender.OnCreate = OnCreate
UILWAlliancePrivilegeItemRender.OnDestroy = OnDestroy
UILWAlliancePrivilegeItemRender.OnEnable = OnEnable
UILWAlliancePrivilegeItemRender.OnDisable = OnDisable
UILWAlliancePrivilegeItemRender.ComponentDefine = ComponentDefine
UILWAlliancePrivilegeItemRender.ComponentDestroy = ComponentDestroy
UILWAlliancePrivilegeItemRender.DataDefine = DataDefine
UILWAlliancePrivilegeItemRender.DataDestroy = DataDestroy
UILWAlliancePrivilegeItemRender.ReInit = ReInit
return UILWAlliancePrivilegeItemRender
