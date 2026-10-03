local UILWAlSwitchJobView = BaseClass("UILWAlSwitchJobView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIAllianceInfoScorePanel = require("UI.UIAlliance.UIAllianceInfo.Component.UIAllianceInfoScorePanel")
local UILWAlSwitchJobInfoCell = require("UI.UILWAlliance.UILWAlSwitchJob.Component.UILWAlSwitchJobInfoCell")
local AllianceRecommendInfo = require("DataCenter.AllianceData.AllianceRecommendInfo")

function UILWAlSwitchJobView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWAlSwitchJobView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAlSwitchJobView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textTopTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.btnOwnInfo = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnOwnInfo:SetOnClick(function()
    self:OnBtnOwnInfoClick()
  end)
  self.imgOwnFlagIcon = self.viewSkin:AddComponent(self, UIImage, 6)
  self.textOwnName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.btnTargetInfo = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnTargetInfo:SetOnClick(function()
    self:OnBtnTargetInfoClick()
  end)
  self.imgTargetFlagIcon = self.viewSkin:AddComponent(self, UIImage, 9)
  self.textTargetName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.compOwnScorePanel = self.viewSkin:AddComponent(self, UIAllianceInfoScorePanel, 11)
  self.compTargetScorePanel = self.viewSkin:AddComponent(self, UIAllianceInfoScorePanel, 12)
  self.textScoreCell = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 13)
  self.compMemberInfoCell = self.viewSkin:AddComponent(self, UILWAlSwitchJobInfoCell, 14)
  self.compPowerInfoCell = self.viewSkin:AddComponent(self, UILWAlSwitchJobInfoCell, 15)
  self.compGiftLvInfoCell = self.viewSkin:AddComponent(self, UILWAlSwitchJobInfoCell, 16)
  self.compGiftNumInfoCell = self.viewSkin:AddComponent(self, UILWAlSwitchJobInfoCell, 17)
  self.compEngagementInfoCell = self.viewSkin:AddComponent(self, UILWAlSwitchJobInfoCell, 18)
  self.btnStay = self.viewSkin:AddComponent(self, UIButton, 19)
  self.btnStay:SetOnClick(function()
    self:OnBtnStayClick()
  end)
  self.textStayBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 20)
  self.btnJoin = self.viewSkin:AddComponent(self, UIButton, 21)
  self.btnJoin:SetOnClick(function()
    self:OnBtnJoinClick()
  end)
  self.textJoinBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 22)
  self.textDownTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 23)
  self.imgJoinBtn = self.viewSkin:AddComponent(self, UIImage, 24)
  self.textTitle:SetLocalText("alliance_switch_title")
  self.textTopTip:SetLocalText("alliance_switch_inactive")
  self.textScoreCell:SetLocalText("alliance_invite_point_average")
  self.textStayBtn:SetLocalText("alliance_switch_btn_stay")
end

function UILWAlSwitchJobView:ComponentDestroy()
  self.viewSkin = nil
  self.btnPanel = nil
  self.textTitle = nil
  self.btnClose = nil
  self.textTopTip = nil
  self.btnOwnInfo = nil
  self.imgOwnFlagIcon = nil
  self.textOwnName = nil
  self.btnTargetInfo = nil
  self.imgTargetFlagIcon = nil
  self.textTargetName = nil
  self.compOwnScorePanel = nil
  self.compTargetScorePanel = nil
  self.textScoreCell = nil
  self.compMemberInfoCell = nil
  self.compPowerInfoCell = nil
  self.compGiftLvInfoCell = nil
  self.compGiftNumInfoCell = nil
  self.compEngagementInfoCell = nil
  self.btnStay = nil
  self.textStayBtn = nil
  self.btnJoin = nil
  self.textJoinBtn = nil
  self.textDownTip = nil
  self.imgJoinBtn = nil
end

function UILWAlSwitchJobView:DataDefine()
  self.data = nil
  self.nowData = nil
  self.switchData = nil
  self.canJoin = false
  local msg = self:GetUserData()
  self:OnAllianceRecommendRefreshJumpNew(msg)
end

function UILWAlSwitchJobView:DataDestroy()
end

function UILWAlSwitchJobView:OnAddListener()
  base.OnAddListener(self)
end

function UILWAlSwitchJobView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWAlSwitchJobView:OnBtnPanelClick()
end

function UILWAlSwitchJobView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UILWAlSwitchJobView:Refresh()
  if self.nowData == nil or self.switchData == nil then
    return
  end
  self.canJoin = self.switchData.recruitTotal == 0
  if self.canJoin then
    self.textDownTip:SetLocalText("alliance_switch_desc_join")
    self.textJoinBtn:SetLocalText("110037")
    self.imgJoinBtn:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_2.png")
  else
    self.textDownTip:SetLocalText("alliance_switch_desc_apply")
    self.textJoinBtn:SetLocalText("110090")
    self.imgJoinBtn:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_3.png")
  end
  self.imgOwnFlagIcon:LoadSprite(self.nowData:GetAllianceFlagPath())
  self.textOwnName:SetText(self.nowData:GetAllianceFullName())
  self.imgTargetFlagIcon:LoadSprite(self.switchData:GetAllianceFlagPath())
  self.textTargetName:SetText(self.switchData:GetAllianceFullName())
  self.compOwnScorePanel:SetData(self.nowData)
  self.compTargetScorePanel:SetData(self.switchData)
  self.compMemberInfoCell:SetData(AllianceInvite_CellType.Member, self.nowData, self.switchData, self.data)
  self.compPowerInfoCell:SetData(AllianceInvite_CellType.Power, self.nowData, self.switchData, self.data)
  self.compGiftLvInfoCell:SetData(AllianceInvite_CellType.Gift, self.nowData, self.switchData, self.data)
  self.compGiftNumInfoCell:SetData(AllianceInvite_CellType.GiftNum, self.nowData, self.switchData, self.data)
  self.compEngagementInfoCell:SetData(AllianceInvite_CellType.Engagement, self.nowData, self.switchData, self.data)
end

function UILWAlSwitchJobView:OnAllianceRecommendRefreshJumpNew(msg)
  self.data = msg
  if msg and msg.curAllianceInfo and msg.recommendAllianceInfo then
    self.nowData = AllianceRecommendInfo.New()
    self.nowData:ParseMsg(msg.curAllianceInfo)
    self.switchData = AllianceRecommendInfo.New()
    self.switchData:ParseMsg(msg.recommendAllianceInfo)
    self:Refresh()
  else
    self.nowData = nil
    self.switchData = nil
    self:Refresh()
  end
end

function UILWAlSwitchJobView:OnBtnOwnInfoClick()
  if self.nowData then
    local allianceName = self.nowData.alliancename
    local allianceId = self.nowData.allianceId
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceDetail, {anim = true}, allianceName, allianceId)
  end
end

function UILWAlSwitchJobView:OnBtnTargetInfoClick()
  if self.switchData then
    local allianceName = self.switchData.alliancename
    local allianceId = self.switchData.allianceId
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceDetail, {anim = true}, allianceName, allianceId)
  end
end

function UILWAlSwitchJobView:OnBtnStayClick()
  self.ctrl:CloseSelf()
end

function UILWAlSwitchJobView:OnBtnJoinClick()
  if self.switchData and self.switchData.allianceId ~= LuaEntry.Player.allianceId then
    if self.switchData.recruitTotal == 1 then
      UIUtil.ShowTipsId("alliance_switch_tips_applySucceed")
      SFSNetwork.SendMessage(MsgDefines.AlApply, self.switchData.allianceId, self.switchData.recruitTotal, self.switchData.language, AlApplyCheckType.Switch)
      self.ctrl:CloseSelf()
    else
      UIUtil.ShowLeaveAllianceTips(function()
        SFSNetwork.SendMessage(MsgDefines.AlApply, self.switchData.allianceId, self.switchData.recruitTotal, self.switchData.language, AlApplyCheckType.Switch)
        self.ctrl:CloseSelf()
      end)
    end
  else
    self.ctrl:CloseSelf()
  end
end

return UILWAlSwitchJobView
