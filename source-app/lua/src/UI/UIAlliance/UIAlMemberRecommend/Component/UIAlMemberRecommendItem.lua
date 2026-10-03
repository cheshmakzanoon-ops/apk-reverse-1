local UIAlMemberRecommendItem = BaseClass("UIAlMemberRecommendItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local playerHeadIcon_path = "Bg/UIPlayerHead/HeadIcon"
local playerFg_path = "Bg/UIPlayerHead/Foreground"
local playerName_path = "Bg/name"
local playerPower_path = "Bg/power"
local btnInvite_path = "Bg/btn"
local btnInviteTxt_path = "Bg/btn/confirmBtnTxt"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.playerHeadN = self:AddComponent(UIPlayerHead, playerHeadIcon_path)
  self.HeadFgN = self:AddComponent(UIImage, playerFg_path)
  self.playerNameN = self:AddComponent(UIText, playerName_path)
  self.playerPowerN = self:AddComponent(UIText, playerPower_path)
  self.btnInviteN = self:AddComponent(UIButton, btnInvite_path)
  self.btnInviteN:SetOnClick(function()
    self:OnClickInviteBtn()
  end)
  self.btnInviteTxtN = self:AddComponent(UIText, btnInviteTxt_path)
  self.btnInviteTxtN:SetLocalText(390198)
end

local function ComponentDestroy(self)
  self.playerHeadN = nil
  self.HeadFgN = nil
  self.playerNameN = nil
  self.playerPowerN = nil
  self.btnInviteN = nil
  self.btnInviteTxtN = nil
end

local function DataDefine(self)
  self.recommendInfo = nil
end

local function DataDestroy(self)
  self.recommendInfo = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function SetItem(self, recommendInfo)
  self.recommendInfo = recommendInfo
  self:RefreshItem()
end

local function RefreshItem(self)
  self.playerHeadN:SetData(self.recommendInfo.uid, self.recommendInfo.pic, self.recommendInfo.picVer)
  local headFg = self.recommendInfo:GetHeadBgImg()
  if headFg then
    self.HeadFgN:SetActive(true)
  else
    self.HeadFgN:SetActive(false)
  end
  self.playerNameN:SetText(self.recommendInfo.name)
  self.playerPowerN:SetText(self.recommendInfo.power)
end

local function OnClickInviteBtn(self)
  SFSNetwork.SendMessage(MsgDefines.AlInviteRecommendUser, self.recommendInfo.uid)
  self.recommendInfo.isInvited = true
  UIGray.SetGray(self.transform, self.recommendInfo.isInvited, not self.recommendInfo.isInvited)
end

local function OnInviteCallBack(self, userUid)
end

UIAlMemberRecommendItem.OnCreate = OnCreate
UIAlMemberRecommendItem.OnDestroy = OnDestroy
UIAlMemberRecommendItem.OnEnable = OnEnable
UIAlMemberRecommendItem.OnDisable = OnDisable
UIAlMemberRecommendItem.ComponentDefine = ComponentDefine
UIAlMemberRecommendItem.ComponentDestroy = ComponentDestroy
UIAlMemberRecommendItem.DataDefine = DataDefine
UIAlMemberRecommendItem.DataDestroy = DataDestroy
UIAlMemberRecommendItem.OnAddListener = OnAddListener
UIAlMemberRecommendItem.OnRemoveListener = OnRemoveListener
UIAlMemberRecommendItem.SetItem = SetItem
UIAlMemberRecommendItem.RefreshItem = RefreshItem
UIAlMemberRecommendItem.OnClickInviteBtn = OnClickInviteBtn
UIAlMemberRecommendItem.OnInviteCallBack = OnInviteCallBack
return UIAlMemberRecommendItem
