local AllianceApplyItem = BaseClass("AllianceApplyItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local first_name_path = "firstNameTxt"
local accept_btn_path = "acceptBtn"
local refuse_btn_path = "refuseBtn"
local power_txt_path = "power"
local kill_txt_path = "kill"
local head_btn_path = "UIPlayerHead"
local playerHead_path = "UIPlayerHead/HeadIcon"
local playerHeadFg_path = "UIPlayerHead/Foreground"

local function OnCreate(self)
  base.OnCreate(self)
  self.first_txt = self:AddComponent(UIText, first_name_path)
  self.power_txt = self:AddComponent(UIText, power_txt_path)
  self.kill_txt = self:AddComponent(UIText, kill_txt_path)
  self.playerHead = self:AddComponent(UIPlayerHead, playerHead_path)
  self.playerHeadFg = self:AddComponent(UIImage, playerHeadFg_path)
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
end

local function SetItemShow(self, data)
  self.data = data
  self.first_txt:SetText(self.data.name)
  self.power_txt:SetText(string.GetFormattedSeperatorNum(self.data.power))
  self.kill_txt:SetText(string.GetFormattedSeperatorNum(self.data.kill))
  self.playerHead:SetData(self.data.uid, self.data.pic, self.data.picVer)
  if self.data.headBg then
    self.playerHeadFg:SetActive(true)
  else
    self.playerHeadFg:SetActive(false)
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

AllianceApplyItem.OnCreate = OnCreate
AllianceApplyItem.SetItemShow = SetItemShow
AllianceApplyItem.OnHeadClick = OnHeadClick
AllianceApplyItem.OnAcceptClick = OnAcceptClick
AllianceApplyItem.OnRefuseClick = OnRefuseClick
return AllianceApplyItem
