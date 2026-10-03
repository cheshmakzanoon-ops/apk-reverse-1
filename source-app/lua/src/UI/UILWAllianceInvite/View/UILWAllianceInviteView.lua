local LWAllianceInviteView = BaseClass("LWAllianceInviteView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local playerHead_path = "Root/Content/ContentHolder/UIPlayerHead"
local descText_path = "Root/Content/ContentHolder/DescText"
local nameLayout_path = "Root/Content/ContentHolder/ChatNameLayout"
local detailBtn_path = "Root/Content/ContentHolder/DetailBtn"
local accepBtn_path = "Root/Content/ContentHolder/AcceptBtn"

function LWAllianceInviteView:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:ReInit()
end

function LWAllianceInviteView:OnAcceptBtnClick()
  if self.inviteInfo then
    if LuaEntry.Player:IsInAlliance() then
      UIUtil.ShowLeaveAllianceTips(function()
        DataCenter.AllianceAutoInviteManager:AcceptAllianceAutoInviteReq(self.inviteInfo.allianceId)
        self.view.ctrl:CloseSelf()
      end)
    else
      DataCenter.AllianceAutoInviteManager:AcceptAllianceAutoInviteReq(self.inviteInfo.allianceId)
      self.view.ctrl:CloseSelf()
    end
  else
    self.view.ctrl:CloseSelf()
  end
end

function LWAllianceInviteView:OnDetailBtnClick()
  if self.inviteInfo then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceDetail, {anim = true}, self.inviteInfo.allianceName, self.inviteInfo.allianceId)
  end
end

function LWAllianceInviteView:ComponentDefine()
  self.closePanel = self:AddComponent(UIButton, "Panel")
  self.closePanel:SetOnClick(function()
    self.view.ctrl:CloseSelf()
  end)
  self.closeBtn = self:AddComponent(UIButton, "Root/Content/UICommonPopBg/bg_3/CloseBtn")
  self.closeBtn:SetOnClick(function()
    self.view.ctrl:CloseSelf()
  end)
  self.playerHead = self:AddComponent(UICommonHead, playerHead_path)
  self.nameLayout = self:AddComponent(UICommonNameLayout, nameLayout_path)
  self.descText = self:AddComponent(UIText, descText_path)
  self.detailBtn = self:AddComponent(UIButton, detailBtn_path)
  self.accpetBtn = self:AddComponent(UIButton, accepBtn_path)
  self.accpetBtn:SetOnClick(function()
    self:OnAcceptBtnClick()
  end)
  self.detailBtn:SetOnClick(function()
    self:OnDetailBtnClick()
  end)
end

function LWAllianceInviteView:ComponentDestroy()
  self.closePanel = nil
  self.closeBtn = nil
  self.playerHead = nil
  self.nameLayout = nil
  self.descText = nil
  self.detailBtn = nil
  self.accpetBtn = nil
end

function LWAllianceInviteView:DataDefine()
end

function LWAllianceInviteView:UpdateDescText()
  if not self.inviteInfo then
    return
  end
  local allianceName = string.format("[%s]%s", self.inviteInfo.abbr, self.inviteInfo.allianceName)
  local alliancePower = string.GetFormattedStr(self.inviteInfo.alliancePower)
  self.descText:SetLocalText(455120, allianceName, alliancePower)
end

function LWAllianceInviteView:ReInit()
  self.inviteInfo = self:GetUserData()
  if self.inviteInfo then
    local framePath = self.inviteInfo:GetHeadBgImg()
    self.playerHead:SetData(self.inviteInfo.playerUid, self.inviteInfo.pic, self.inviteInfo.picVer, false, framePath)
    self.playerHead:SetFlag(self.inviteInfo.playerNation)
    self.nameLayout:SetData(self.inviteInfo.playerName, self.inviteInfo.abbr, self.inviteInfo.playerGender)
    self:UpdateDescText()
  end
end

function LWAllianceInviteView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWAllianceInviteView:DataDestroy()
end

return LWAllianceInviteView
