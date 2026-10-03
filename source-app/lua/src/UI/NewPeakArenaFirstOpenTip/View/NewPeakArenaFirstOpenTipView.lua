local NewPeakArenaFirstOpenTipView = BaseClass("NewPeakArenaFirstOpenTipView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local GaleImgPath = "Assets/Main/TextureEx/NewGaleArena/wxy_jingjichang_haibao.png"
local PeakImgPath = "Assets/Main/TextureEx/NewPeakArena/zxl_jingjichang_haibao.png"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  DataCenter.LWSoundManager:PlaySound(62285, false)
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
  self.btnCloseBg = self:AddComponent(UIButton, "CloseBg")
  self.textTitle = self:AddComponent(UIText, "Root/BgImg/TitleText")
  self.textRight = self:AddComponent(UIText, "Root/BgImg/qipao/RightText")
  self.textDown = self:AddComponent(UIText, "Root/BgImg/DownText")
  self.btnCloseBg:SetOnClick(function()
    self.ctrl:CloseSelf(self.userData and self.userData.type)
  end)
  self.bg1 = self:AddComponent(UIRawImage, "Root/BgImg_background")
  self.bg2 = self:AddComponent(UIRawImage, "Root/BgImg")
  self.userData = self:GetUserData()
  if self.userData and self.userData.type == PVPArenaType.NewGaleArena then
    self.textTitle:SetLocalText("gale_arena_name_1")
    self.textRight:SetLocalText("gale_arena_tips01")
    self.textDown:SetLocalText("gale_arena_tips02")
    self.bg1:LoadSpriteAsync(GaleImgPath)
    self.bg2:LoadSpriteAsync(GaleImgPath)
  else
    self.textTitle:SetLocalText("new_arena_name_1")
    self.textRight:SetLocalText("new_arena_tips_1")
    self.textDown:SetLocalText("new_arena_tips_2")
    self.bg1:LoadSpriteAsync(PeakImgPath)
    self.bg2:LoadSpriteAsync(PeakImgPath)
  end
end

local function ComponentDestroy(self)
  self.btnCloseBg = nil
  self.textTitle = nil
  self.textRight = nil
  self.textDown = nil
end

local function DataDefine(self)
  if self.userData and self.userData.type == PVPArenaType.NewGaleArena then
    CommonUtil.PlayerPrefsSetBool(SettingKeys.POP_NEWGALEARENA_DIALOG, false)
  else
    CommonUtil.PlayerPrefsSetBool(SettingKeys.POP_NEWPEAKARENA_DIALOG, false)
  end
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

NewPeakArenaFirstOpenTipView.OnCreate = OnCreate
NewPeakArenaFirstOpenTipView.OnDestroy = OnDestroy
NewPeakArenaFirstOpenTipView.OnEnable = OnEnable
NewPeakArenaFirstOpenTipView.OnDisable = OnDisable
NewPeakArenaFirstOpenTipView.ComponentDefine = ComponentDefine
NewPeakArenaFirstOpenTipView.ComponentDestroy = ComponentDestroy
NewPeakArenaFirstOpenTipView.DataDefine = DataDefine
NewPeakArenaFirstOpenTipView.DataDestroy = DataDestroy
NewPeakArenaFirstOpenTipView.OnAddListener = OnAddListener
NewPeakArenaFirstOpenTipView.OnRemoveListener = OnRemoveListener
return NewPeakArenaFirstOpenTipView
