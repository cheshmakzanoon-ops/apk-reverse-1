local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
local UILWAlMemberLeader = BaseClass("UILWAlMemberLeader", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local active_player_panel_path = "ActivePlayerPanel"
local active_player_num_path = "ActivePlayerPanel/ActivePlayerNumText"
local player_go_path = "LeaderInfo"
local player_btn_path = "LeaderInfo/PlayerBtn"
local player_icon_path = "LeaderInfo/PlayerBtn/UIPlayerHead"
local online_txt_path = "LeaderInfo/PlayerBtn/OnLineText"
local offline_alert_btn_path = "LeaderInfo/PlayerBtn/OnLineText/OfflineAlertBtn"
local rank_name_path = "LeaderInfo/RankNameText"
local name_text_path = "LeaderInfo/DescBg/PlayerNameText"
local rank_icon_path = "LeaderInfo/DescBg/RanIcon"
local no_leader_txt_path = "NoLeaderText"

function UILWAlMemberLeader:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWAlMemberLeader:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAlMemberLeader:ComponentDefine()
  self.activePlayerPanel = self:AddComponent(UIBaseContainer, active_player_panel_path)
  self.activePlayerNumText = self:AddComponent(UIText, active_player_num_path)
  self.activePlayerBtn = self:AddComponent(UIButton, active_player_panel_path)
  self.activePlayerBtn:SetOnClick(function()
    self:OnActivePlayerBtnClick()
  end)
  self.leaderGo = self:AddComponent(UIBaseContainer, player_go_path)
  self.leaderIcon = self:AddComponent(UICommonHead, player_icon_path)
  self.leaderOnLineTxt = self:AddComponent(UIText, online_txt_path)
  self.leaderRankNameTxt = self:AddComponent(UIText, rank_name_path)
  self.leaderNameTxt = self:AddComponent(UIText, name_text_path)
  self.leaderRankIcon = self:AddComponent(UIImage, rank_icon_path)
  self.offlineAlertBtn = self:AddComponent(UIButton, offline_alert_btn_path)
  self.offlineAlertBtn:SetOnClick(function()
    self:OnAlertBtnClick()
  end)
  self.noLeaderTxt = self:AddComponent(UIText, no_leader_txt_path)
  self.leaderIcon:SetEnableClickShowInfo(true, true)
  self.leaderBtn = self:AddComponent(UIButton, player_btn_path)
  self.leaderBtn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, self.leaderInfo.uid)
  end)
end

function UILWAlMemberLeader:ComponentDestroy()
  self.leaderGo = nil
  self.leaderIcon = nil
  self.leaderOnLineTxt = nil
  self.leaderNameTxt = nil
  self.leaderRankIcon = nil
  self.noLeaderTxt = nil
  self.leaderRankNameTxt = nil
  self.infoBtn = nil
end

function UILWAlMemberLeader:DataDefine()
  self.leaderInfo = {}
end

function UILWAlMemberLeader:DataDestroy()
  self.leaderInfo = nil
end

function UILWAlMemberLeader:OnEnable()
  base.OnEnable(self)
end

function UILWAlMemberLeader:OnDisable()
  base.OnDisable(self)
end

function UILWAlMemberLeader:OnAddListener()
  base.OnAddListener(self)
end

function UILWAlMemberLeader:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWAlMemberLeader:RefreshContent(leaderInfo)
  self.leaderInfo = leaderInfo
  if leaderInfo.isSelfAlliance then
    self.activePlayerPanel:SetActive(true)
    self.activePlayerNumText:SetText(DataCenter.AllianceMemberDataManager:CountOnlinePlayerNum())
  else
    self.activePlayerPanel:SetActive(false)
  end
  if not leaderInfo or leaderInfo.uid == "" then
    self.leaderGo:SetActive(false)
    self.noLeaderTxt:SetActive(true)
  else
    self.noLeaderTxt:SetActive(false)
    self.leaderGo:SetActive(true)
    self.leaderIcon:SetData(leaderInfo.uid, leaderInfo.pic, leaderInfo.picVer, nil, leaderInfo.headBg)
    local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(leaderInfo.uid, leaderInfo.name)
    self.leaderNameTxt:SetText(showName)
    self.leaderRankIcon:LoadSprite(LWAlMemberRankParam[leaderInfo.rank].Icon)
    if leaderInfo.isSelfAlliance then
      self.leaderOnLineTxt:SetText(leaderInfo.online_time)
      if leaderInfo.isOnline then
        self.leaderOnLineTxt:SetColor(Color.New(0.3607843137254902, 0.8156862745098039, 0.6509803921568628, 1))
      else
        self.leaderOnLineTxt:SetColor(Color.New(0.49, 0.49, 0.49, 1))
      end
      if not string.IsNullOrEmpty(leaderInfo.rankName) then
        self:SetLeaderRankName(leaderInfo.rankName)
      else
        self:SetLeaderRankName("")
      end
    else
      self.leaderOnLineTxt:SetText("")
      if leaderInfo.viewOpen then
        if leaderInfo.viewOpen == 1 then
          self:SetLeaderRankName(leaderInfo.rankName or "")
          self.leaderRankNameTxt:SetText(leaderInfo.rankName or "")
        else
          self:SetLeaderRankName("")
        end
      end
    end
  end
  if leaderInfo.offLineTime and leaderInfo.offLineTime > 0 then
    local deltaTime = UITimeManager:GetInstance():GetServerTime() - leaderInfo.offLineTime
    if 216000000 < deltaTime then
      self.offlineAlertBtn:SetActive(true)
      if not DataCenter.AllianceMemberDataManager.alreadyShowLeaderAlert then
        TimerManager:GetInstance():DelayInvoke(function()
          self:OnAlertBtnClick()
        end, 0.1)
        DataCenter.AllianceMemberDataManager.alreadyShowLeaderAlert = true
      end
    else
      self.offlineAlertBtn:SetActive(false)
    end
  else
    self.offlineAlertBtn:SetActive(false)
  end
end

function UILWAlMemberLeader:OnAlertBtnClick()
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local position = self.offlineAlertBtn.transform.position + Vector3.New(0, 20, 0) * scaleFactor
  local param = UIHeroTipView.Param.New()
  param.content = Localization:GetString("393077")
  param.dir = UIHeroTipView.Direction.ABOVE
  param.defWidth = 180
  param.pivot = 0.5
  param.position = position
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

function UILWAlMemberLeader:OnActivePlayerBtnClick()
  UIUtil.ShowBubbleTipsAuto(Localization:GetString("alliance_member_limit_onlineNum"), self.activePlayerBtn.transform.position, 40 * CommonUtil.ArabicAutoMirrorFactor(), -30, 30)
end

function UILWAlMemberLeader:SetLeaderRankName(name)
  if not string.IsNullOrEmpty(name) and DataCenter.AllianceMemberDataManager:CheckIsRankEditSwitch() then
    self.leaderRankNameTxt:SetText(name)
    self.leaderRankNameTxt:SetActive(true)
  else
    self.leaderRankNameTxt:SetText("")
    self.leaderRankNameTxt:SetActive(false)
  end
end

return UILWAlMemberLeader
