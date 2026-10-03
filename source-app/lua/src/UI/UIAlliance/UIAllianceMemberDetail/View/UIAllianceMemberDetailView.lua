local UIAllianceMemberDetailView = BaseClass("UIAllianceMemberDetailView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local AllianceMember = require("UI.UIAlliance.UIAllianceMemberDetail.Component.AllianceMember")
local txt_title_path = "ImgBg/TxtTitle"
local close_btn_path = "ImgBg/BtnClose"
local alliance_member_path = "ImgBg/AllianceMember"

local function OnCreate(self)
  base.OnCreate(self)
  self.allianceId, self.openType = self:GetUserData()
  self.view.ctrl:SetAllianceId(self.allianceId)
  self.txt_title = self:AddComponent(UIText, txt_title_path)
  self.txt_title:SetLocalText(390199)
  self.alliance_member = self:AddComponent(AllianceMember, alliance_member_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.ctrl:CloseSelf()
  end)
end

local function OnDestroy(self)
  self.allianceId = nil
  self.txt_title = nil
  self.alliance_member = nil
  self.close_btn = nil
  self.return_btn = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnShowAllianceMemberTips(self, uid, rank, posX, posY, name)
  self.ctrl:OnShowAllianceMemberTips(uid, rank, posX, posY, name, self.openType)
end

local function CheckIfNeedShowSelfRank(self)
  return false
end

local function CheckIfShowMemberOnly(self)
  return false
end

UIAllianceMemberDetailView.OnCreate = OnCreate
UIAllianceMemberDetailView.OnDestroy = OnDestroy
UIAllianceMemberDetailView.OnEnable = OnEnable
UIAllianceMemberDetailView.OnDisable = OnDisable
UIAllianceMemberDetailView.OnShowAllianceMemberTips = OnShowAllianceMemberTips
UIAllianceMemberDetailView.CheckIfNeedShowSelfRank = CheckIfNeedShowSelfRank
UIAllianceMemberDetailView.CheckIfShowMemberOnly = CheckIfShowMemberOnly
return UIAllianceMemberDetailView
