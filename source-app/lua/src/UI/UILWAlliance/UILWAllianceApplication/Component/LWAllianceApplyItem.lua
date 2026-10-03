local LWAllianceApplyItem = BaseClass("LWAllianceApplyItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local first_name_path = "Content/firstNameTxt"
local accept_btn_path = "acceptBtn"
local refuse_btn_path = "refuseBtn"
local power_txt_path = "power"
local kill_txt_path = "kill"
local head_btn_path = "UIPlayerHead"
local playerHead_path = "UIPlayerHead"
local gender_icon_path = "Content/GenderIcon"
local MALE_ICON_PATH = "Assets/Main/Sprites/UI/UILWAlliance/cfm_lianmeng_tubiao_nan.png"
local FEMALE_ICON_PATH = "Assets/Main/Sprites/UI/UILWAlliance/cfm_lianmeng_tubiao_nv.png"

local function OnCreate(self)
  base.OnCreate(self)
  self.first_txt = self:AddComponent(UIText, first_name_path)
  self.namePos = self.first_txt:GetLocalPosition()
  self.power_txt = self:AddComponent(UIText, power_txt_path)
  self.kill_txt = self:AddComponent(UIText, kill_txt_path)
  self.playerHead = self:AddComponent(UICommonHead, playerHead_path)
  self.head_btn = self:AddComponent(UIButton, head_btn_path)
  self.head_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnHeadClick()
  end)
  self.accept_btn = self:AddComponent(UIButton, accept_btn_path)
  self.accept_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnAcceptClick()
  end)
  self.refuse_btn = self:AddComponent(UIButton, refuse_btn_path)
  self.refuse_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnRefuseClick()
  end)
  self.genderIcon = self:AddComponent(UIImage, gender_icon_path)
end

local function OnDestroy(self)
  self:ComponentDestroy(self)
  base.OnDestroy(self)
end

local function ComponentDestroy(self)
  self.first_txt = nil
  self.power_txt = nil
  self.kill_txt = nil
  self.playerHead = nil
  self.head_btn = nil
  self.accept_btn = nil
  self.refuse_btn = nil
  self.genderIcon = nil
end

local function SetItemShow(self, data)
  self.data = data
  local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(self.data.uid, self.data.name)
  self.first_txt:SetText(showName .. " " .. Localization:GetString("300665", self.data.level))
  self.power_txt:SetText(Localization:GetString("100253") .. " " .. string.GetFormattedSeperatorNum(self.data.power))
  self.kill_txt:SetText(Localization:GetString("100196") .. " " .. string.GetFormattedSeperatorNum(self.data.kill))
  self.playerHead:SetData(self.data.uid, self.data.pic, self.data.picVer, nil, self.data.headBg)
  if self.data.gender and self.data.gender > 0 and self.data.gender < 3 then
    self.genderIcon:SetActive(true)
    if self.data.gender == 1 then
      self.genderIcon:LoadSprite(MALE_ICON_PATH)
    elseif self.data.gender == 2 then
      self.genderIcon:LoadSprite(FEMALE_ICON_PATH)
    end
  else
    self.genderIcon:SetActive(false)
  end
end

local function OnHeadClick(self)
  self.view.ctrl:OnPlayerDetailClick(self.data.uid)
end

local function OnAcceptClick(self)
  self.view.ctrl:OnAcceptClick(self.data.uid)
end

local function OnRefuseClick(self)
  self.view.ctrl:OnRefuseClick(self.data.uid)
end

LWAllianceApplyItem.OnCreate = OnCreate
LWAllianceApplyItem.OnDestroy = OnDestroy
LWAllianceApplyItem.ComponentDestroy = ComponentDestroy
LWAllianceApplyItem.SetItemShow = SetItemShow
LWAllianceApplyItem.OnHeadClick = OnHeadClick
LWAllianceApplyItem.OnAcceptClick = OnAcceptClick
LWAllianceApplyItem.OnRefuseClick = OnRefuseClick
return LWAllianceApplyItem
