local AllianceMemberRankItem = require("UI.UIAlliance.UIAllianceMemberDetail.Component.AllianceMemberRankItem")
local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
local AllianceMember = BaseClass("AllianceMember", UIBaseContainer)
local AllianceOfficialPosItem = require("UI.UIAlliance.UIAllianceMemberDetail.Component.AlliancePositionItem")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local leaderContainer_path = "leader"
local active_player_panel_path = "leader/ActivePlayerPanel"
local active_player_num_path = "leader/ActivePlayerPanel/ActivePlayerNumText"
local leader_name_path = "leader/LeaderInfo/DescBg/leaderNameTxt"
local show_btn_path = "leader/LeaderInfo/PlayerBtn"
local icon_path = "leader/LeaderInfo/PlayerBtn/UIPlayerHead"
local onlineState_path = "leader/LeaderInfo/PlayerBtn/OnLineText"
local rank_name_path = "leader/LeaderInfo/RankNameText"
local noLeaderContainer_path = "GameObject/vote"
local voteBtn_path = "GameObject/vote/voteBtn"
local voteBtnTxt_path = "GameObject/vote/voteBtn/Txt"
local noLeaderTip_path = "GameObject/vote/tip"
local noLeaderTime_path = "GameObject/vote/countDown"
local leaderEmpty_path = "GameObject/leaderEmpty"
local leaderEmptyTxt_path = "GameObject/leaderEmpty/tip1"
local closeTipBtn_path = "closeMemberTipBtn"
local svRanks_path = "GameObject/ScrollView"
local content_path = "GameObject/ScrollView/Viewport/Content"
local rank_4_path = "GameObject/ScrollView/Viewport/Content/AllianceMemberBtnItem4"
local rank_3_path = "GameObject/ScrollView/Viewport/Content/AllianceMemberBtnItem3"
local rank_2_path = "GameObject/ScrollView/Viewport/Content/AllianceMemberBtnItem2"
local rank_1_path = "GameObject/ScrollView/Viewport/Content/AllianceMemberBtnItem1"
local officialPosContainer_path = "r4Position"
local officialPos_path = "r4Position/pos"
local content_title_root_path = "GameObject/ScrollView/Viewport/TitleContent"
local content_title_leader_path = "GameObject/ScrollView/Viewport/TitleContent/leader"
local content_title_rank_name_path = "GameObject/ScrollView/Viewport/TitleContent/ListNameText"
local content_title_people_path = "GameObject/ScrollView/Viewport/TitleContent/people"
local content_title_img_arrow_normal_path = "GameObject/ScrollView/Viewport/TitleContent/ImgArrowNormal"
local content_title_img_arrow_select_path = "GameObject/ScrollView/Viewport/TitleContent/ImgArrowSelect"
local content_title_show_button_path = "GameObject/ScrollView/Viewport/TitleContent/showButton"

local function OnCreate(self)
  base.OnCreate(self)
  self.activePlayerPanel = self:AddComponent(UIBaseContainer, active_player_panel_path)
  self.activePlayerNumText = self:AddComponent(UIText, active_player_num_path)
  self.activePlayerBtn = self:AddComponent(UIButton, active_player_panel_path)
  self.activePlayerBtn:SetOnClick(function()
    self:OnActivePlayerBtnClick()
  end)
  self.leaderContainer = self:AddComponent(UIBaseContainer, leaderContainer_path)
  self.noLeaderContainer = self:AddComponent(UIBaseContainer, noLeaderContainer_path)
  self.voteBtn = self:AddComponent(UIButton, voteBtn_path)
  self.voteBtn:SetOnClick(function()
    self:OnClickVoteBtn()
  end)
  self.voteBtnTxt = self:AddComponent(UIText, voteBtnTxt_path)
  self.voteBtnTxt_shadow = self:AddComponent(UIShadow, voteBtnTxt_path)
  self.voteBtnTxt:SetLocalText(390861)
  self.noLeaderTip = self:AddComponent(UIText, noLeaderTip_path)
  self.noLeaderTip:SetText("")
  self.noLeaderTime = self:AddComponent(UIText, noLeaderTime_path)
  self.leaderEmpty = self:AddComponent(UIBaseContainer, leaderEmpty_path)
  self.closeTipBtnN = self:AddComponent(UIButton, closeTipBtn_path)
  self.closeTipBtnN:SetOnClick(function()
  end)
  self.leaderEmptyTxt = self:AddComponent(UIText, leaderEmptyTxt_path)
  self.leaderEmptyTxt:SetLocalText(390863)
  self.leader_name = self:AddComponent(UIText, leader_name_path)
  self.leaderRankNameTxt = self:AddComponent(UIText, rank_name_path)
  self.icon = self:AddComponent(UICommonHead, icon_path)
  self.icon:SetEnableClickShowInfo(true, false)
  self.show_btn = self:AddComponent(UIButton, show_btn_path)
  self.show_btn:SetOnClick(function()
    self:OnShowClick()
  end)
  self.onlineStateTxt = self:AddComponent(UIText, onlineState_path)
  self.srEventTrigger = self:AddComponent(UIEventTrigger, svRanks_path)
  self.srEventTrigger:OnPointerDown(function(eventData)
    if UIManager:GetInstance():GetWindow(UIWindowNames.UIAllianceMemberTip) then
      UIManager.Instance:DestroyWindow(UIWindowNames.UIAllianceMemberTip)
    end
  end)
  self.svRanksN = self:AddComponent(UIScrollRect, svRanks_path)
  self.svRanksN:AddValueChangeListener(function(vec2)
    if math.abs(vec2.y) >= 0.001 and UIManager:GetInstance():GetWindow(UIWindowNames.UIAllianceMemberTip) then
      UIManager.Instance:DestroyWindow(UIWindowNames.UIAllianceMemberTip)
    end
    self:OnScrollValueChange()
  end)
  self.contentN = self:AddComponent(UIBaseContainer, content_path)
  self.rank_4 = self:AddComponent(AllianceMemberRankItem, rank_4_path)
  self.rank_3 = self:AddComponent(AllianceMemberRankItem, rank_3_path)
  self.rank_2 = self:AddComponent(AllianceMemberRankItem, rank_2_path)
  self.rank_1 = self:AddComponent(AllianceMemberRankItem, rank_1_path)
  self.officialPosContainerN = self:AddComponent(UIBaseContainer, officialPosContainer_path)
  self.officialPosTbN = {}
  for i = 1, 4 do
    local tempItem = self:AddComponent(AllianceOfficialPosItem, officialPos_path .. i)
    table.insert(self.officialPosTbN, tempItem)
  end
  
  function self.timer_action()
    self:SetStateCountDown()
  end
  
  self.showRanks = {}
  self.content_title_root = self:AddComponent(UIBaseContainer, content_title_root_path)
  self.content_title_leader = self:AddComponent(UIImage, content_title_leader_path)
  self.content_title_rank_name = self:AddComponent(UIText, content_title_rank_name_path)
  self.content_title_people = self:AddComponent(UIText, content_title_people_path)
  self.content_title_img_arrow_normal = self:AddComponent(UIImage, content_title_img_arrow_normal_path)
  self.content_title_img_arrow_select = self:AddComponent(UIImage, content_title_img_arrow_select_path)
  self.content_title_show_button = self:AddComponent(UIButton, content_title_show_button_path)
  self.content_title_root:SetActive(false)
  self.Updating = true
  self.topGroupNode = nil
  self.content_title_show_button:SetOnClick(function()
    if self.topGroupNode then
      self.Updating = true
      self.topGroupNode:OnShowClick()
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.contentN.rectTransform)
      self.Updating = false
      self:OnScrollValueChange()
    end
  end)
end

local function OnDestroy(self)
  self:DeleteTimer()
  self.stateEndTime = nil
  self.leader_name = nil
  self.icon = nil
  self.show_btn = nil
  self.rank_4 = nil
  self.rank_3 = nil
  self.rank_2 = nil
  self.rank_1 = nil
  self.voteBtnTxt_shadow = nil
  self.showRanks = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self.view.ctrl:InitAllianceMemberData()
end

local function OnDisable(self)
  self:DeleteTimer()
  base.OnDisable(self)
end

function AllianceMember:OnScrollValueChange()
  if self.Updating then
    self.content_title_root:SetActive(false)
    self.topGroupNode = nil
    return
  end
  local topNode
  local top = self.contentN:GetAnchoredPositionY()
  local lastY = 0
  for i = 1, 4 do
    topNode = self["rank_" .. i]
    if topNode and topNode:GetActive() then
      local y = topNode:GetAnchoredPositionY() + top
      if 0 < y then
        if i ~= 1 and 0 < lastY + 65 then
          topNode = nil
        end
        break
      end
      lastY = y
    end
    topNode = nil
  end
  if topNode and topNode.rank then
    self.content_title_root:SetActive(true)
    local spr = string.format("Assets/Main/Sprites/UI/UILWAlliance/cfm_lianmeng_tubiao_r%s.png", topNode.rank)
    self.content_title_leader:LoadSprite(spr)
    self.content_title_people:SetText(topNode.num:GetText())
    self.content_title_img_arrow_normal:SetActive(topNode.close_img:GetActive())
    self.content_title_img_arrow_select:SetActive(topNode.open_img:GetActive())
    local isSelfAlliance = self.view.ctrl:GetIsSelfAlliance()
    local viewOpenType = DataCenter.AllianceMemberDataManager:GetAllianceRankVisible()
    local isSwitchOn = DataCenter.AllianceMemberDataManager:CheckIsRankEditSwitch()
    if isSwitchOn and (isSelfAlliance or viewOpenType == 1) then
      local rank_name = DataCenter.AllianceMemberDataManager:GetAllianceRankNameByRank(topNode.rank)
      self.content_title_rank_name:SetText(rank_name or "")
      self.content_title_rank_name:SetActive(not string.IsNullOrEmpty(rank_name))
    else
      self.content_title_rank_name:SetText("")
      self.content_title_rank_name:SetActive(false)
    end
  else
    self.content_title_root:SetActive(false)
  end
  self.topGroupNode = topNode
end

local function OnRefresh(self, playerUid)
  if not string.IsNullOrEmpty(playerUid) then
    return
  end
  self.Updating = true
  self.topGroupNode = nil
  self.content_title_root:SetActive(false)
  self:SetLeaderPart()
  self:SetOfficialPosPart()
  self.rank_4:RefreshData(4)
  self.rank_3:RefreshData(3)
  self.rank_2:RefreshData(2)
  self.rank_1:RefreshData(1)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.contentN.rectTransform)
  self.Updating = false
  self:OnScrollValueChange()
  if self.view:CheckIfShowMemberOnly() then
    self.officialPosContainerN:SetActive(false)
    return
  end
end

local function OnShowRankItem(self, param)
  if not self.leaderData or not self.leaderData.isSelfAlliance then
    return
  end
  local rank = param.rank
  local isShow = param.isShow
  self.showRanks[rank] = isShow
  if self.view.showInactiveTip then
    if isShow then
      local list = self.view.ctrl:GetMemberListByRank(rank)
      local delayT = 0.1
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.contentN.transform)
      TimerManager:GetInstance():DelayInvoke(function()
        self:TryScrollToInactiveMember(rank)
      end, delayT)
    end
    return
  end
  if table.count(self.showRanks) == AllianceMemberRankCount and self.view.ctrl:CheckIsSelfAll() and self.view.CheckIfNeedShowSelfRank then
    local showSelfRank = self.view:CheckIfNeedShowSelfRank(true)
    if showSelfRank then
      self:TryScrollToSelfRank()
      return
    end
  end
end

local function TryScrollToSelfRank(self)
  local selfRank = DataCenter.AllianceBaseDataManager:GetSelfRank()
  local targetY = 12
  local posContainerSize = self.officialPosContainerN:GetSizeDelta()
  targetY = targetY + posContainerSize.y
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.contentN.transform)
  local contentScale = self.contentN:GetSizeDelta()
  local svScale = self.svRanksN:GetSizeDelta()
  for i = 4, 1, -1 do
    if i > selfRank then
      local temp = self["rank_" .. i]:GetSizeDelta()
      targetY = targetY + temp.y
    end
  end
  local prog = 0
  if svScale.y >= contentScale.y then
    prog = 0
  else
    prog = targetY / (contentScale.y - svScale.y)
  end
  self.svRanksN:SetVerticalNormalizedPosition(1 - prog)
end

local function TryScrollToInactiveMember(self, rank)
  local targetY = 12
  local contentScale = self.contentN:GetSizeDelta()
  local svScale = self.svRanksN:GetSizeDelta()
  local posContainerSize = self.officialPosContainerN:GetSizeDelta()
  targetY = targetY + posContainerSize.y
  for i = 4, 1, -1 do
    if rank < i then
      local temp = self["rank_" .. i]:GetSizeDelta()
      targetY = targetY + temp.y
    end
  end
  local list = self.view.ctrl:GetMemberListByRank(rank)
  if #list == 0 then
    return
  end
  local inactiveExist = false
  for i, v in ipairs(list) do
    if v.isInactive then
      inactiveExist = true
      targetY = targetY + 71 + 88 * math.ceil(i / 2)
      break
    end
  end
  if not inactiveExist then
    return
  end
  local prog = 0
  if svScale.y >= contentScale.y then
    prog = 0
  else
    local targetProg = targetY - svScale.y
    targetProg = math.max(0, targetProg)
    prog = targetProg / (contentScale.y - svScale.y)
  end
  self.svRanksN:SetVerticalNormalizedPosition(1 - prog)
end

local function SetOfficialPosPart(self)
  self.officialPosContainerN:SetActive(true)
  for i = 1, 4 do
    self.officialPosTbN[i]:SetItem(i, self.leaderData.isSelfAlliance)
  end
end

local function SetLeaderPart(self)
  self.leaderData = self.view.ctrl:GetLeaderData()
  if self.leaderData.isSelfAlliance then
    self.activePlayerPanel:SetActive(true)
    self.activePlayerNumText:SetText(DataCenter.AllianceMemberDataManager:CountOnlinePlayerNum())
  else
    self.activePlayerPanel:SetActive(false)
  end
  if not self.leaderData or self.leaderData.uid == "" then
    self.noLeaderContainer:SetActive(false)
    self.leaderContainer:SetActive(false)
    self.leaderEmpty:SetActive(true)
  else
    self.noLeaderContainer:SetActive(false)
    self.leaderEmpty:SetActive(false)
    self.leaderContainer:SetActive(true)
    self.icon:SetData(self.leaderData.uid, self.leaderData.pic, self.leaderData.picVer, nil, self.leaderData.headBg)
    self.leader_name:SetText(self.leaderData.name)
    if self.leaderData.isSelfAlliance then
      self.onlineStateTxt:SetText(self.leaderData.online_time)
      if self.leaderData.isOnline then
        self.onlineStateTxt:SetColor(Color.New(0.3607843137254902, 0.8156862745098039, 0.6509803921568628, 1))
      else
        self.onlineStateTxt:SetColor(Color.New(0.49, 0.49, 0.49, 1))
      end
      local leader_rank_name = DataCenter.AllianceMemberDataManager:GetAllianceRankNameByRank(5)
      if not string.IsNullOrEmpty(leader_rank_name) then
        self:SetAllianceRankName(leader_rank_name)
        self.leaderRankNameTxt:SetText(leader_rank_name)
      else
        self:SetAllianceRankName("")
      end
    else
      local leader_rank_name = DataCenter.AllianceMemberDataManager:GetAllianceRankNameByRank(5)
      local isViewOpen = DataCenter.AllianceMemberDataManager:GetAllianceRankVisible()
      if isViewOpen == 1 and not string.IsNullOrEmpty(leader_rank_name) then
        self:SetAllianceRankName(leader_rank_name)
      else
        self:SetAllianceRankName("")
      end
    end
  end
end

local function AddTimer(self)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
    self.timer:Start()
  end
end

local function SetStateCountDown(self)
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  if serverTime < self.stateEndTime then
    self.noLeaderTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(self.stateEndTime - serverTime))
  else
    self.noLeaderTime:SetText("")
    self:DeleteTimer()
  end
end

local function DeleteTimer(self)
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceMember, self.OnRefresh)
  self:AddUIListener(EventId.AlLeaderVoteStatusChange, self.OnRefresh)
  self:AddUIListener(EventId.ShowAllianceMemberRanks, self.OnShowRankItem)
  self:AddUIListener(EventId.SearchAllianceError, self.SearchAllianceError)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.AllianceMember, self.OnRefresh)
  self:RemoveUIListener(EventId.AlLeaderVoteStatusChange, self.OnRefresh)
  self:RemoveUIListener(EventId.ShowAllianceMemberRanks, self.OnShowRankItem)
  self:RemoveUIListener(EventId.SearchAllianceError, self.SearchAllianceError)
end

local function OnShowClick(self)
  if self.leaderData.uid ~= LuaEntry.Player.uid then
    local x = self.icon.transform.position.x
    local y = self.icon.transform.position.y
    self.view:OnShowAllianceMemberTips(self.leaderData.uid, self.leaderData.rank, x, y, self.leaderData.name)
  end
end

local function OnClickRecruitBtn(self)
  local baseInfo = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  local cdTime = LuaEntry.DataConfig:TryGetNum("alliance_regulation", "k6") * 1000
  local nextTime = baseInfo.lastRecruitTime + cdTime
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  local cdRemainTime = nextTime - serverTime
  if 0 < cdRemainTime then
    UIUtil.ShowTips(Localization:GetString("391094", math.ceil(cdRemainTime / 60000)))
    return
  end
  local param = {}
  param.defaultTip = Localization:GetString(AllianceInviteTipDefault)
  
  function param.callback(strTip)
    local share_param = {}
    share_param.post = PostType.Text_AllianceRecruitShare
    local allianceBase = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    share_param.name = allianceBase.allianceName
    share_param.abbr = allianceBase.abbr
    share_param.recruitTip = strTip
    share_param.country = allianceBase.country
    share_param.memberNum = allianceBase.curMember .. "/" .. allianceBase.maxMember
    share_param.allianceFlag = allianceBase.icon
    share_param.needApply = allianceBase.recruitTotal
    share_param.uid = allianceBase.uid
    share_param.language = allianceBase.language
    share_param.postType = PostType.Text_AllianceRecruitShare
    local _chatRoomManager = ChatInterface.getRoomMgr()
    local totalChatList = _chatRoomManager:GetShareRoom()
    local channel
    for _, chatItem in pairs(totalChatList) do
      if chatItem:isWorldRoom() then
        channel = chatItem
        break
      end
    end
    if channel then
      local chatData = {}
      chatData.roomId = channel:getRoomId()
      chatData.post = share_param.post
      chatData.param = share_param
      EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_SHARE_COMMAND, chatData)
      SFSNetwork.SendMessage(MsgDefines.SendAllianceRecruit)
    end
  end
  
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceInviteTip, {anim = true}, param)
end

local function SearchAllianceError(self)
  UIUtil.ShowTipsId("E100086")
  self.view.ctrl:CloseSelf()
end

local function OnClickShowOfflineTip(self)
  local showTip = self.leaderData.isSelfAlliance and DataCenter.AllianceBaseDataManager:IsR4orR5() and not self.leaderData.isOnline
  if not showTip then
    return
  end
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local position = self.onlineStateBtn.transform.position + Vector3.New(5, 30, 0) * scaleFactor
  local param = UIHeroTipView.Param.New()
  param.content = self.leaderData.online_time
  param.dir = UIHeroTipView.Direction.ABOVE
  param.defWidth = 180
  param.pivot = 0.5
  param.position = position
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

local function OnClickVoteBtn(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAlLeaderVote, {anim = true})
end

function AllianceMember:OnActivePlayerBtnClick()
  UIUtil.ShowBubbleTipsAuto(Localization:GetString("alliance_member_limit_onlineNum"), self.activePlayerBtn.transform.position, 15 * CommonUtil.ArabicAutoMirrorFactor(), -30, 30)
end

function AllianceMember:SetAllianceRankName(name)
  if not string.IsNullOrEmpty(name) and DataCenter.AllianceMemberDataManager:CheckIsRankEditSwitch() then
    self.leaderRankNameTxt:SetText(name)
    self.leaderRankNameTxt:SetActive(true)
  else
    self.leaderRankNameTxt:SetText("")
    self.leaderRankNameTxt:SetActive(false)
  end
end

AllianceMember.OnCreate = OnCreate
AllianceMember.OnDestroy = OnDestroy
AllianceMember.OnRefresh = OnRefresh
AllianceMember.SetLeaderPart = SetLeaderPart
AllianceMember.OnEnable = OnEnable
AllianceMember.OnDisable = OnDisable
AllianceMember.OnAddListener = OnAddListener
AllianceMember.OnRemoveListener = OnRemoveListener
AllianceMember.OnShowClick = OnShowClick
AllianceMember.OnClickShowOfflineTip = OnClickShowOfflineTip
AllianceMember.OnClickVoteBtn = OnClickVoteBtn
AllianceMember.AddTimer = AddTimer
AllianceMember.SetStateCountDown = SetStateCountDown
AllianceMember.DeleteTimer = DeleteTimer
AllianceMember.OnShowRankItem = OnShowRankItem
AllianceMember.TryScrollToInactiveMember = TryScrollToInactiveMember
AllianceMember.TryScrollToSelfRank = TryScrollToSelfRank
AllianceMember.OnClickRecruitBtn = OnClickRecruitBtn
AllianceMember.SetOfficialPosPart = SetOfficialPosPart
AllianceMember.SearchAllianceError = SearchAllianceError
return AllianceMember
