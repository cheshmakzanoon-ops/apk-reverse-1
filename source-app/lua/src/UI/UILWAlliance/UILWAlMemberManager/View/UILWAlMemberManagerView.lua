local UILWAlMemberManagerView = BaseClass("UILWAlMemberManagerView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local txt_title_path = "Root/Content/UICommonPopBg/bg_3/TitleTxt"
local close_btn_path = "Panel"
local return_btn_path = "Root/Content/UICommonPopBg/bg_3/CloseBtn"
local player_icon_path = "Root/Content/Up/PlayerBtn/UIPlayerHead"
local name_text_path = "Root/Content/Up/NameText"
local rank_icon_path = "Root/Content/Up/RankIcon"
local desc_text_path = "Root/Content/Mid/ScrollView/Viewport/DescTxt"
local point_btn_path = "Root/Content/Up/PointBtn"
local drive_out_btn_path = "Root/Content/Bottom/DriveOutBtn"
local drive_out_txt_btn_path = "Root/Content/Bottom/DriveOutBtn/DriveOutText"
local drive_out_remain_count_text_path = "Root/Content/Bottom/DriveOutBtn/DriveOutRemainCountText"
local upgrade_btn_path = "Root/Content/Bottom/UpgradeBtn"
local upgrade_txt_btn_path = "Root/Content/Bottom/UpgradeBtn/UpgradeText"
local chat_btn_path = "Root/Content/Bottom/ChatBtn"
local chat_txt_btn_path = "Root/Content/Bottom/ChatBtn/ChatText"
local DRIVE_OUT_TXT = 393012
local UPGRADE_TXT = 393013
local CHAT_TXT = 393014
local UIAllianceInfoInactiveNode = require("UI.UIAlliance.UIAllianceInfo.Component.UIAllianceInfoInactiveNode")

function UILWAlMemberManagerView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWAlMemberManagerView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAlMemberManagerView:ComponentDefine()
  self.titleTxt = self:AddComponent(UIText, txt_title_path)
  self.closeBtn = self:AddComponent(UIButton, close_btn_path)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.returnBtn = self:AddComponent(UIButton, return_btn_path)
  self.returnBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.playerIcon = self:AddComponent(UICommonHead, player_icon_path)
  self.nameTxt = self:AddComponent(UIText, name_text_path)
  self.rankIcon = self:AddComponent(UIImage, rank_icon_path)
  self.descTxt = self:AddComponent(UIText, desc_text_path)
  self.pointBtn = self:AddComponent(UIButton, point_btn_path)
  self.pointBtn:SetOnClick(function()
    self:OnPointBtnClick()
  end)
  self.driveOutTxt = self:AddComponent(UIText, drive_out_txt_btn_path)
  self.drive_out_remain_count_text = self:AddComponent(UITextMeshProUGUIEx, drive_out_remain_count_text_path)
  self.driveOutBtn = self:AddComponent(UIButton, drive_out_btn_path)
  self.driveOutBtn:SetOnClick(function()
    self:OnClickDriveOut()
  end)
  self.upgradeTxt = self:AddComponent(UIText, upgrade_txt_btn_path)
  self.upgradeBtn = self:AddComponent(UIButton, upgrade_btn_path)
  self.upgradeBtn:SetOnClick(function()
    self:OnClickUpgrade()
  end)
  self.chatTxt = self:AddComponent(UIText, chat_txt_btn_path)
  self.chatBtn = self:AddComponent(UIButton, chat_btn_path)
  self.chatBtn:SetOnClick(function()
    self:OnClickChat()
  end)
  self.titleTxt:SetLocalText("100333")
  self.driveOutTxt:SetLocalText(DRIVE_OUT_TXT)
  self.upgradeTxt:SetLocalText(UPGRADE_TXT)
  self.chatTxt:SetLocalText(CHAT_TXT)
  self.inactivePanel = self:AddComponent(UIBaseComponent, "Root/Content/Up/InactivePanel")
  self.inactiveNode = self:AddComponent(UIAllianceInfoInactiveNode, "Root/Content/Up/InactivePanel/InactiveNode")
  self.honorTipBtn = self:AddComponent(UIButton, "Root/Content/Up/InactivePanel/HonorTipBtn")
  self.honorSelectBtn = self:AddComponent(UIButton, "Root/Content/Up/InactivePanel/HonorSelectBtn")
  self.honorSelectImg = self:AddComponent(UIImage, "Root/Content/Up/InactivePanel/HonorSelectBtn/HonorSelectImg")
  self.dayText = self:AddComponent(UIText, "Root/Content/Up/DayText")
  self.honorTipBtn:SetOnClick(function()
    UIUtil.ShowBubbleTipsAuto(Localization:GetString("alliance_member_tips_royalMember"), self.honorTipBtn.transform.position, 0, -30, -40, nil, nil)
  end)
  self.honorSelectBtn:SetOnClick(function()
    if self.data and self.data.uid then
      SFSNetwork.SendMessage(MsgDefines.AllianceHonorMemberSet, self.data.uid, not self.isHonorMember)
    end
  end)
end

function UILWAlMemberManagerView:ComponentDestroy()
  self.titleTxt = nil
  self.closeBtn = nil
  self.returnBtn = nil
  self.playerIcon = nil
  self.nameTxt = nil
  self.rankIcon = nil
  self.descTxt = nil
  self.pointBtn = nil
  self.driveOutTxt = nil
  self.driveOutBtn = nil
  self.upgradeTxt = nil
  self.upgradeBtn = nil
  self.chatTxt = nil
  self.chatBtn = nil
  self.inactivePanel = nil
  self.inactiveNode = nil
  self.honorTipBtn = nil
  self.honorSelectBtn = nil
  self.honorSelectImg = nil
  self.dayText = nil
end

function UILWAlMemberManagerView:DataDefine()
  self.ctrl:SetView(self)
  self.data = {}
  self.selfRank = 0
  self.rank = 0
  self.official = ""
  self.kickRemainCount = -1
  local seasonId = SeasonUtil.GetSeason()
  local isR4orR5 = DataCenter.AllianceBaseDataManager:IsR4orR5()
  if 0 < seasonId and isR4orR5 then
    SFSNetwork.SendMessage(MsgDefines.AllianceGetKickTimes)
  end
end

function UILWAlMemberManagerView:DataDestroy()
  self.ctrl:ClearView()
  self.data = nil
  self.selfRank = nil
  self.rank = nil
  self.official = nil
end

function UILWAlMemberManagerView:OnEnable()
  base.OnEnable(self)
  self.data = self:GetUserData()
  self.selfRank = DataCenter.AllianceMemberDataManager:GetAllianceMemberMyself().rank or 0
  self.rank = self.data.rank
  self.official = DataCenter.AllianceMemberDataManager:GetOfficialPosByUid(self.data.uid)
  Logger.Log(self.data.uid)
  self:OnRrefresh()
end

function UILWAlMemberManagerView:OnDisable()
  base.OnDisable(self)
end

function UILWAlMemberManagerView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateAllianceKickTimes, self.OnUpdateAllianceKickTimes)
  self:AddUIListener(EventId.OnKickAllianceMember, self.OnKickAllianceMember)
  self:AddUIListener(EventId.AllianceRefreshMemberHonorState, self.OnAllianceRefreshMemberHonorState)
end

function UILWAlMemberManagerView:OnRemoveListener()
  self:RemoveUIListener(EventId.UpdateAllianceKickTimes, self.OnUpdateAllianceKickTimes)
  self:RemoveUIListener(EventId.OnKickAllianceMember, self.OnKickAllianceMember)
  self:RemoveUIListener(EventId.AllianceRefreshMemberHonorState, self.OnAllianceRefreshMemberHonorState)
  base.OnRemoveListener(self)
end

function UILWAlMemberManagerView:OnUpdateAllianceKickTimes(data)
  self.kickRemainCount = data
  self:UpdateAllianceKickRemainCountView()
end

function UILWAlMemberManagerView:OnKickAllianceMember(playerId)
  if self.data and self.data.uid == playerId then
    self.ctrl:CloseSelf()
    UIUtil.ShowTipsId(390091)
  end
end

function UILWAlMemberManagerView:OnRrefresh()
  local data = self.data
  local userId = data.uid
  local userPic = data.pic
  local userPicVer = data.picVer
  local headBg = data.headBg
  self.playerIcon:SetData(userId, userPic, userPicVer, true, headBg)
  local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(data.uid, data.name)
  self.nameTxt:SetText(showName)
  local index = DataCenter.AllianceMemberDataManager:GetTableIndex(self.rank, self.official)
  if index then
    local line = LocalController:instance():getLine(TableName.LW_Alliance_Officer_Info, index)
    local desc = line.desc
    self.descTxt:SetLocalText(desc)
    local icon = line.icon
    self.rankIcon:LoadSprite(icon)
    self.rankIcon:SetNativeSize()
  end
  if self.data and self.data.originData then
    self.dayText:SetLocalText("alliance_member_desc_joined", self.data.originData:GetJoinDay())
  else
    self.dayText:SetText("")
  end
  self:OnRrefreshButtons()
  self:UpdateAllianceKickRemainCountView()
  self:RefreshInactivePanel()
end

function UILWAlMemberManagerView:OnRrefreshButtons()
  if self.selfRank >= 4 and self.selfRank > self.rank and (self.official == nil or self.official == "") then
    UIGray.SetGray(self.driveOutBtn.transform, false, true)
  else
    UIGray.SetGray(self.driveOutBtn.transform, true, true)
  end
  if self.selfRank >= 3 and self.selfRank > self.rank then
    UIGray.SetGray(self.upgradeBtn.transform, false, true)
  else
    UIGray.SetGray(self.upgradeBtn.transform, true, true)
  end
  self.pointBtn:SetActive(false)
end

function UILWAlMemberManagerView:OnClickDriveOut()
  if self.selfRank >= 4 and self.selfRank > self.rank and (self.official == nil or self.official == "") then
    if self.kickRemainCount == 0 then
      UIUtil.ShowTipsId("alliance_kick_recover")
      self.ctrl:CloseSelf()
      return
    end
    if DataCenter.LWFireworkManager:IsFiringByUid(self.data.uid) or DataCenter.LWFireworkGiftManager:IsHasAvailableBoxByUid(self.data.uid) then
      local todayShow = DataCenter.SecondConfirmManager:GetTodayCanShowSecondConfirm(TodayNoSecondConfirmType.ShowFireworkKickOutAlliance)
      if todayShow then
        UIUtil.ShowSecondMessageByParam({
          tipText = Localization:GetString("firework_tips_1001"),
          btnNum = 2,
          showToggle = true,
          toggleAction = function(isOn)
            DataCenter.SecondConfirmManager:SetTodayNoShowSecondConfirm(TodayNoSecondConfirmType.ShowFireworkKickOutAlliance, isOn)
          end,
          sureAction = function()
            self.ctrl:OnDriveOut(self.data.uid)
            self.ctrl:CloseSelf()
          end
        })
      else
        self.ctrl:OnDriveOut(self.data.uid)
        self.ctrl:CloseSelf()
      end
    else
      self.ctrl:OnDriveOut(self.data.uid)
      self.ctrl:CloseSelf()
    end
  else
    UIUtil.ShowTipsId(393018)
  end
end

function UILWAlMemberManagerView:OnClickUpgrade()
  if self.selfRank >= 3 and self.selfRank > self.rank then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlAuthorityManager, {anim = true}, self.data, self.selfRank, self.rank, self.official)
    self.ctrl:CloseSelf()
  else
    UIUtil.ShowTipsId(393018)
  end
end

function UILWAlMemberManagerView:OnClickChat()
  local userInfo = {}
  userInfo.uid = self.data.uid
  userInfo.userName = self.data.name
  local param = {}
  param.roomId = ""
  param.privateUserInfo = userInfo
  self.ctrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWAlMember)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWAlMain)
  GoToUtil.OpenChatView(true, {anim = false}, param)
end

function UILWAlMemberManagerView:OnPointBtnClick()
  local data = self.data
  local jumpPointId = data.pointId
  if 0 < jumpPointId then
    self.ctrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWAlMember)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWAlMain)
    local pos = SceneUtils.TileIndexToWorld(jumpPointId, ForceChangeScene.World)
    GoToUtil.GotoWorldPos(pos, nil, nil, nil)
  else
    UIUtil.ShowTipsId(454136)
  end
end

function UILWAlMemberManagerView:UpdateAllianceKickRemainCountView()
  self.drive_out_remain_count_text:SetActive(self.kickRemainCount >= 0)
  if self.kickRemainCount >= 0 then
    self.drive_out_remain_count_text:SetLocalText("alliance_kick_limit", self.kickRemainCount)
  end
end

function UILWAlMemberManagerView:RefreshInactivePanel()
  self.isHonorMember = false
  if self.data and self.data.originData then
    if DataCenter.AllianceBaseDataManager:IsR4orR5() and self.data.originData:CheckIfIsInactivePlayer() then
      self.inactivePanel:SetActive(true)
      self.isHonorMember = self.data.originData.isHonorMember
      if self.isHonorMember then
        self.inactiveNode:SetActive(false)
      else
        self.inactiveNode:SetActive(true)
        self.inactiveNode:SetData(not self.isHonorMember)
      end
      self.honorSelectImg:SetActive(self.isHonorMember)
    else
      self.inactivePanel:SetActive(false)
    end
  else
    self.inactivePanel:SetActive(false)
  end
end

function UILWAlMemberManagerView:OnAllianceRefreshMemberHonorState(uid)
  if self.data and self.data.uid == uid then
    self:RefreshInactivePanel()
  end
end

return UILWAlMemberManagerView
