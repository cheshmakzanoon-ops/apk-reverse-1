local UIAllianceInviteView = BaseClass("UIAllianceInviteView", UIBaseView)
local UICommonHead = require("Framework.UI.Component.UICommonHead")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local mask_path = "Mask"
local AlPostEventLog = require("DataCenter.AllianceData.AlliancePostEventLog")

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  AlPostEventLog.PostEventLog_Invite_Action(AlPostEventLog.InviteAction.Open)
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.imgAllianceFlag = self:AddComponent(UIImage, "safeArea/MiddleContentContainer/FlagGroup/AllianceFlag")
  self.textRank = self:AddComponent(UIText, "safeArea/MiddleContentContainer/FlagGroup/RankText")
  self.textAllianceName = self:AddComponent(UIText, "safeArea/MiddleContentContainer/InfoGroup/AllianceName")
  self.imgCountry = self:AddComponent(UIImage, "safeArea/MiddleContentContainer/InfoGroup/ItemLanguageInfo/CountryImg")
  self.textLanguageTxt = self:AddComponent(UIText, "safeArea/MiddleContentContainer/InfoGroup/ItemLanguageInfo/LanguageTxt")
  self.textItemMemberInfo = self:AddComponent(UIText, "safeArea/MiddleContentContainer/InfoGroup/MemberGroup/ItemMemberInfo")
  self.textItemPowerInfo = self:AddComponent(UIText, "safeArea/MiddleContentContainer/InfoGroup/PowerGroup/ItemPowerInfo")
  self.textPlayerName = self:AddComponent(UIText, "safeArea/MiddleContentContainer/MessgeGroup/PlayerNameText")
  self.textMsg = self:AddComponent(UIText, "safeArea/MiddleContentContainer/MessgeGroup/MsgText")
  self.compUIPlayerHead = self:AddComponent(UICommonHead, "safeArea/MiddleContentContainer/LeaderInfoGroup/UIPlayerHead")
  self.compUIPlayerHead:SetEnableClickShowInfo(false, false)
  self.textLeaderName = self:AddComponent(UIText, "safeArea/MiddleContentContainer/LeaderInfoGroup/LeaderNameText")
  self.btnMsg = self:AddComponent(UIButton, "safeArea/MiddleContentContainer/LeaderInfoGroup/MsgBtn")
  self.btnMsg:SetOnClick(function()
    self:OnBtnMsgClick()
  end)
  self.btnList = self:AddComponent(UIButton, "safeArea/BottomBar/ListBtn")
  self.btnList:SetOnClick(function()
    self:OnBtnListClick()
  end)
  self.btnJoin = self:AddComponent(UIButton, "safeArea/BottomBar/JoinBtn")
  self.btnJoin:SetOnClick(function()
    self:OnBtnJoinClick()
  end)
  self.mask = self:AddComponent(UIButton, mask_path)
  self.mask:SetOnClick(function()
    self:OnCloseClick()
    AlPostEventLog.PostEventLog_Invite_Action(AlPostEventLog.InviteAction.Close)
  end)
end

local function ComponentDestroy(self)
  self.imgAllianceFlag = nil
  self.textRank = nil
  self.textAllianceName = nil
  self.imgCountry = nil
  self.textLanguageTxt = nil
  self.textItemMemberInfo = nil
  self.textItemPowerInfo = nil
  self.textPlayerName = nil
  self.textMsg = nil
  self.compUIPlayerHead = nil
  self.textLeaderName = nil
  self.btnMsg = nil
  self.btnList = nil
  self.btnJoin = nil
end

local function DataDefine(self)
  self.allianceUid = self:GetUserData()
  self.leaderUid = nil
  self.leaderName = nil
  self:ReInit()
end

local function DataDestroy(self)
  self.allianceUid = nil
  self.leaderUid = nil
  self.leaderName = nil
end

local function ReInit(self)
  if string.IsNullOrEmpty(self.allianceUid) then
    return
  end
  local info = DataCenter.AllianceTempListManager:GetSearchAllianceDataByUid(self.allianceUid)
  local rebuildAlliance = DataCenter.CityRebuildDataManager:GetAllianceInfoInfo()
  if rebuildAlliance and rebuildAlliance.uid then
    info = rebuildAlliance
  end
  if info then
    self.imgAllianceFlag:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, info.icon))
    self.textAllianceName:SetText("[" .. info.abbr .. "]" .. info.allianceName)
    self:GetPlayerRankData()
    self:GetAllianceRankData()
    self.textPlayerName:SetText(Localization:GetString("alliance_invite_content_name", LuaEntry.Player.name))
    if not LuaEntry.GlobalData:IsChina() and not LuaEntry.Player:IsFromBIGCHINAorUsingLangZH() then
      self.imgCountry:SetActive(true)
      local nationTemplate = info:GetCountryFlagTemplate()
      self.imgCountry:LoadSprite(nationTemplate:GetNationFlagPath())
    else
      self.imgCountry:SetActive(false)
    end
    local languageTitleStr
    if not string.IsNullOrEmpty(info.language) then
      local languageId = SuportedLanguagesLocalName[Localization:GetLanguage()] or ""
      if languageId == info.language then
        languageTitleStr = "<color=#099b4a>" .. Localization:GetString(info.language) .. "</color>"
      else
        languageTitleStr = Localization:GetString(info.language)
      end
      self.textLanguageTxt:SetText(languageTitleStr)
    else
      self.textLanguageTxt:SetText(Localization:GetString(390254))
    end
    self.textItemMemberInfo:SetText(info.curMember .. "/" .. info.maxMember)
    self.textItemPowerInfo:SetText(string.GetFormattedStr0(tonumber(info.fightPower)))
    self:SetLeaderHeadInfo(info)
    self.leaderUid = info.leaderUid
    self.leaderName = info.leaderName
    self.textLeaderName:SetText("[" .. info.abbr .. "]" .. info.leaderName)
  else
    Logger.LogError("alliance info is nil, uid is " .. self.allianceUid)
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.PlayerRank, self.GetPlayerRankData)
  self:AddUIListener(EventId.AllianceRank, self.GetAllianceRankData)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.PlayerRank, self.GetPlayerRankData)
  self:RemoveUIListener(EventId.AllianceRank, self.GetAllianceRankData)
  base.OnRemoveListener(self)
end

local function OnBtnMsgClick(self)
  if self.leaderUid == LuaEntry.Player.uid then
    UIUtil.ShowTips(Localization:GetString("900508"))
    return
  end
  if string.IsNullOrEmpty(self.leaderUid) then
    UIUtil.ShowTipsId(390870)
    return
  end
  local userId = self.leaderUid
  local roomId = ChatManager2:GetInstance().Room:GetPrivateRoomByUserId(userId)
  local param = {}
  param.roomId = roomId
  param.userId = userId
  param.username = self.leaderName
  GoToUtil.OpenChatView(false, {anim = false, immediately = true}, param)
  AlPostEventLog.PostEventLog_Invite_Action(AlPostEventLog.InviteAction.Dm)
end

local function OnBtnListClick(self)
  self.ctrl:CloseSelf()
  local isFreeCreate = UIUtil.IsFreeCreateAllianceInOpenServerTime()
  if isFreeCreate then
    local param = {}
    param.chooseLeader = 1
    param.status = 2
    SFSNetwork.SendMessage(MsgDefines.FirstJoinAlliance, param)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, {showJoin = true})
  end
  AlPostEventLog.PostEventLog_Invite_Action(AlPostEventLog.InviteAction.List)
end

local function OnBtnJoinClick(self)
  if self.allianceUid then
    local alData = DataCenter.AllianceTempListManager:GetSearchAllianceDataByUid(self.allianceUid)
    if alData then
      SFSNetwork.SendMessage(MsgDefines.AlApply, self.allianceUid, alData.recruitTotal, alData.language)
      self:OnCloseClick()
    else
      alData = DataCenter.CityRebuildDataManager:GetAllianceInfoInfo()
      if alData then
        SFSNetwork.SendMessage(MsgDefines.AlApply, self.allianceUid, alData.recruitTotal, alData.language)
        self:OnCloseClick()
      end
    end
    AlPostEventLog.PostEventLog_Invite_Action(AlPostEventLog.InviteAction.Join)
  end
end

local function OnCloseClick(self)
  if self.ctrl then
    self.ctrl:CloseSelf()
  end
end

function UIAllianceInviteView:GetPlayerRankData()
  local list = DataCenter.RankDataManager:GetPlayerRankListByType(0, RankingTypeServer.KILL, LuaEntry.Player:GetSourceServerId())
  if table.IsNullOrEmpty(list) then
    return
  end
  local rebuildAlliance = DataCenter.CityRebuildDataManager:GetAllianceInfoInfo()
  if rebuildAlliance and rebuildAlliance.uid then
    self.textMsg:SetLocalText("alliance_assist_001")
  else
    local selfRanking = DataCenter.RankDataManager.selfRanking
    if 0 < selfRanking and selfRanking <= 50 then
      self.textMsg:SetLocalText("alliance_invite_content_1")
    elseif 50 < selfRanking and selfRanking <= 100 then
      self.textMsg:SetLocalText("alliance_invite_content_2")
    else
      self.textMsg:SetLocalText("alliance_invite_content_3")
    end
  end
end

function UIAllianceInviteView:GetAllianceRankData()
  local list = DataCenter.RankDataManager:GetAllianceRankListByType(0, RankingTypeServer.POWER_ALLIANCE, LuaEntry.Player:GetSourceServerId())
  if table.IsNullOrEmpty(list) then
    return
  end
  local rank = 0
  for _, v in pairs(list) do
    if v and v.uid == self.allianceUid then
      rank = v.rank
      break
    end
  end
  if 0 < rank and rank <= 10 then
    local context = Localization:GetString("alliance_invite_rank", rank)
    self.textRank:SetText(context)
  else
    self.textRank:SetText("")
  end
end

local function SetLeaderHeadInfo(self, info)
  if info then
    self.compUIPlayerHead:SetData(info.leaderUid, info.leaderPic, info.leaderPicVer, nil, nil)
  end
end

UIAllianceInviteView.OnCreate = OnCreate
UIAllianceInviteView.OnDestroy = OnDestroy
UIAllianceInviteView.OnEnable = OnEnable
UIAllianceInviteView.OnDisable = OnDisable
UIAllianceInviteView.ComponentDefine = ComponentDefine
UIAllianceInviteView.ComponentDestroy = ComponentDestroy
UIAllianceInviteView.DataDefine = DataDefine
UIAllianceInviteView.DataDestroy = DataDestroy
UIAllianceInviteView.OnAddListener = OnAddListener
UIAllianceInviteView.OnRemoveListener = OnRemoveListener
UIAllianceInviteView.OnBtnMsgClick = OnBtnMsgClick
UIAllianceInviteView.OnBtnListClick = OnBtnListClick
UIAllianceInviteView.OnBtnJoinClick = OnBtnJoinClick
UIAllianceInviteView.ReInit = ReInit
UIAllianceInviteView.OnCloseClick = OnCloseClick
UIAllianceInviteView.SetLeaderHeadInfo = SetLeaderHeadInfo
return UIAllianceInviteView
