local AlAutoInviteItem = BaseClass("AlAutoInviteItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local AllianceFlagItem = require("UI.UIAlliance.UIAllianceFlag.Component.AllianceFlagItem")
local chatShareNode_path = "ChatShareNode"
local shareTitle_path = "ChatShareNode/Image/ShareTitle"
local countryFlag_path = "ChatShareNode/inviteNode/countryFlag"
local allianceFlag_path = "ChatShareNode/inviteNode/AllianceFlag"
local recruitTip_path = "ChatShareNode/inviteNode/announce"
local peopleNum_path = "ChatShareNode/inviteNode/people/peopleNum"
local detailBtn_path = "ChatShareNode/inviteNode/detailBtn"
local detailBtnTxt_path = "ChatShareNode/inviteNode/detailBtn/detailBtnTxt"
local joinBtn_path = "ChatShareNode/inviteNode/joinBtn"
local joinBtnTxt_path = "ChatShareNode/inviteNode/joinBtn/joinBtnTxt"
local playerName_path = "ChatNameLayout/Line/NameText"
local playerHead_path = "ChatHead/Image"
local playerHeadFg_path = "ChatHead/Foreground"
local playerNation_path = "ChatHead/nation"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.chatShareNodeN = self:AddComponent(UIBaseContainer, chatShareNode_path)
  self.shareTitleN = self:AddComponent(UIText, shareTitle_path)
  self.countryFlagN = self:AddComponent(UIImage, countryFlag_path)
  self.allianceFlagN = self:AddComponent(AllianceFlagItem, allianceFlag_path)
  self.recruitTipN = self:AddComponent(UIText, recruitTip_path)
  self.peopleNumN = self:AddComponent(UIText, peopleNum_path)
  self.detailBtnN = self:AddComponent(UIButton, detailBtn_path)
  self.detailBtnN:SetOnClick(function()
    self:OnClickDetailBtn()
  end)
  self.detailBtnTxtN = self:AddComponent(UIText, detailBtnTxt_path)
  self.detailBtnTxtN:SetLocalText(100092)
  self.joinBtnN = self:AddComponent(UIButton, joinBtn_path)
  self.joinBtnN:SetOnClick(function()
    self:OnClickJoinBtn()
  end)
  self.joinBtnTxtN = self:AddComponent(UIText, joinBtnTxt_path)
  self.joinBtnTxtN:SetLocalText(110037)
  self.playerNameN = self:AddComponent(UIText, playerName_path)
  self.playerHeadN = self:AddComponent(UIPlayerHead, playerHead_path)
  self.playerHeadFgN = self:AddComponent(UIImage, playerHeadFg_path)
  self.playerNationN = self:AddComponent(UIImage, playerNation_path)
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function SetItem(self, inviteInfo)
  self.inviteInfo = inviteInfo
  if not LuaEntry.GlobalData:IsChina() then
    self.countryFlagN:SetActive(true)
    local nationTemplate = DataCenter.NationTemplateManager:GetNationTemplate(inviteInfo.country)
    self.countryFlagN:LoadSprite(nationTemplate:GetNationFlagPath())
  else
    self.countryFlagN:SetActive(false)
  end
  self.allianceFlagN:SetData(inviteInfo.icon)
  self.shareTitleN:SetText("[" .. inviteInfo.abbr .. "]" .. inviteInfo.allianceName)
  if string.IsNullOrEmpty(inviteInfo.intro) then
    self.recruitTipN:SetLocalText(390799)
  else
    self.recruitTipN:SetText(inviteInfo.intro)
  end
  self.peopleNumN:SetText(inviteInfo.curMember .. "/" .. inviteInfo.maxMember)
  self.playerNameN:SetText("[" .. inviteInfo.abbr .. "]" .. inviteInfo.playerName)
  self.playerHeadN:SetData(inviteInfo.playerUid, inviteInfo.pic, inviteInfo.picVer)
  local tempFg = inviteInfo:GetHeadBgImg()
  if tempFg then
    self.playerHeadFgN:SetActive(true)
    self.playerHeadFgN:LoadSprite(tempFg)
  else
    self.playerHeadFgN:SetActive(false)
  end
  if not LuaEntry.GlobalData:IsChina() then
    self.playerNationN:SetActive(true)
    local playerNation = DataCenter.NationTemplateManager:GetNationTemplate(inviteInfo.playerNation)
    local flagPath = playerNation:GetNationFlagPath()
    self.playerNationN:LoadSprite(flagPath)
  else
    self.playerNationN:SetActive(false)
  end
end

local function OnClickDetailBtn(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceDetail, {anim = true}, self.inviteInfo.allianceName, self.inviteInfo.allianceId)
end

local function OnClickJoinBtn(self)
  if LuaEntry.Player:IsInAlliance() then
    UIUtil.ShowLeaveAllianceTips(function()
      DataCenter.AllianceAutoInviteManager:AcceptAllianceAutoInviteReq(self.inviteInfo.allianceId)
      self.view.ctrl:CloseSelf()
    end)
  else
    DataCenter.AllianceAutoInviteManager:AcceptAllianceAutoInviteReq(self.inviteInfo.allianceId)
    self.view.ctrl:CloseSelf()
  end
end

AlAutoInviteItem.OnCreate = OnCreate
AlAutoInviteItem.OnDestroy = OnDestroy
AlAutoInviteItem.ComponentDefine = ComponentDefine
AlAutoInviteItem.ComponentDestroy = ComponentDestroy
AlAutoInviteItem.DataDefine = DataDefine
AlAutoInviteItem.DataDestroy = DataDestroy
AlAutoInviteItem.OnAddListener = OnAddListener
AlAutoInviteItem.OnRemoveListener = OnRemoveListener
AlAutoInviteItem.SetItem = SetItem
AlAutoInviteItem.OnClickDetailBtn = OnClickDetailBtn
AlAutoInviteItem.OnClickJoinBtn = OnClickJoinBtn
return AlAutoInviteItem
