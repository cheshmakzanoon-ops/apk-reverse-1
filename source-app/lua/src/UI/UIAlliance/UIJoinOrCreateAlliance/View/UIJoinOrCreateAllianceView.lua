local UIJoinOrCreateAllianceView = BaseClass("UIJoinOrCreateAllianceView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local txt_title_path = "ImgBg/TxtTitle"
local close_btn_path = "ImgBg/BtnClose"
local return_btn_path = "Panel"
local create_btn_path = "ImgBg/createButton"
local create_txt_path = "ImgBg/createButton/createText"
local join_btn_path = "ImgBg/joinButton"
local join_txt_path = "ImgBg/joinButton/joinText"

local function OnCreate(self)
  base.OnCreate(self)
  self.txt_title = self:AddComponent(UIText, txt_title_path)
  self.txt_title:SetLocalText(390028)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.join_btn = self:AddComponent(UIButton, join_btn_path)
  self.join_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.ctrl:OnClickJoin()
  end)
  self.join_txt = self:AddComponent(UIText, join_txt_path)
  self.join_txt:SetLocalText(390079)
  self.create_btn = self:AddComponent(UIButton, create_btn_path)
  self.create_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.ctrl:OnClickCreate()
  end)
  self.create_txt = self:AddComponent(UIText, create_txt_path)
  self.create_txt:SetLocalText(390080)
end

local function OnDestroy(self)
  self.txt_title = nil
  self.close_btn = nil
  self.return_btn = nil
  self.join_btn = nil
  self.join_txt = nil
  self.create_btn = nil
  self.create_txt = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

UIJoinOrCreateAllianceView.OnCreate = OnCreate
UIJoinOrCreateAllianceView.OnDestroy = OnDestroy
UIJoinOrCreateAllianceView.OnEnable = OnEnable
UIJoinOrCreateAllianceView.OnDisable = OnDisable
return UIJoinOrCreateAllianceView
