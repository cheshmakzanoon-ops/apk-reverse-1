local AllianceMemberBtnItem = BaseClass("AllianceMemberBtnItem", UIBaseContainer)
local base = UIBaseContainer
local btn_path = "setBtn"
local name_path = "setBtn/setText"

local function OnCreate(self, data)
  base.OnCreate(self)
  self.itemData = data
  self.name = self:AddComponent(UIText, name_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self.view.ctrl:OnMemberBtnClick(self.itemData.type, self.itemData.uid, self.itemData.UIName, self.itemData.playerName, self.itemData.selfRank)
  end)
  self.name:SetText(self.itemData.name)
end

local function OnDestroy(self)
  self.itemData = nil
  self.name = nil
  self.btn = nil
  base.OnDestroy(self)
end

AllianceMemberBtnItem.OnCreate = OnCreate
AllianceMemberBtnItem.OnDestroy = OnDestroy
return AllianceMemberBtnItem
