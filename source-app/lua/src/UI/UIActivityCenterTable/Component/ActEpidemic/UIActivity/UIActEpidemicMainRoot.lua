local base = require("UI.UIRaceEntrance.Component.ActDownloadNodeBase")
local UIActEpidemicMainRoot = BaseClass("UIActEpidemicMainRoot", base)
local UIActEpidemicSkillItem = require("UI.UIActEpidemicPopup.Component.UIActEpidemicSkillItem")
local Path_UIActEpidemicMainCompTeamChange = "UI.UIActivityCenterTable.Component.ActEpidemic.UIActivity.UIActEpidemicMainCompTeamChange"
local Path_UIActEpidemicMainCompTimer = "UI.UIActivityCenterTable.Component.ActEpidemic.UIActivity.UIActEpidemicMainCompTimer"
local Path_UIActEpidemicMainCompMVP = "UI.UIActivityCenterTable.Component.ActEpidemic.UIActivity.UIActEpidemicMainCompMVP"
local Path_UIActEpidemicMainCompFighting = "UI.UIActivityCenterTable.Component.ActEpidemic.UIActivity.UIActEpidemicMainCompFighting"
local UIActEpidemicMainHelpTips = require("UI.UIActivityCenterTable.Component.ActEpidemic.UIActivity.UIActEpidemicMainHelpTips")
local Localization = CS.GameEntry.Localization

function UIActEpidemicMainRoot:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIActEpidemicMainRoot:OnDestroy()
  self:DestroyAllHelpTips()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActEpidemicMainRoot:OnDisable()
  base.OnDisable(self)
  self.tryChangeRole = nil
end

function UIActEpidemicMainRoot:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compTopRect = self.viewSkin:AddComponent(self, UIBaseComponent, 1)
  self.compTopRightRect = self.viewSkin:AddComponent(self, UIBaseComponent, 2)
  self.rawImgRImgBackground = self.viewSkin:AddComponent(self, UIRawImage, 3)
  self.btnInfo = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.btnTeaching = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnTeaching:SetOnClick(function()
    self:OnBtnTeachingClick()
  end)
  self.btnReward = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnReward:SetOnClick(function()
    self:OnBtnRewardClick()
  end)
  self.btnShop = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnShop:SetOnClick(function()
    self:OnBtnShopClick()
  end)
  self.btnScore = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnScore:SetOnClick(function()
    self:OnBtnScoreClick()
  end)
  self.compNodeTeamChange = self.viewSkin:AddComponent(self, UIBaseComponent, 9)
  self.compTimerNode = self.viewSkin:AddComponent(self, UIBaseComponent, 10)
  self.compBottomBtns = self.viewSkin:AddComponent(self, UIBaseComponent, 11)
  self.textTmpBottomNotice = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.btnBottomSign = self.viewSkin:AddComponent(self, UIButton, 13)
  self.btnBottomSign:SetOnClick(function()
    self:OnBtnBottomSignClick()
  end)
  self.textBtnBottomSignLabel = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 14)
  self.textTmpCamp0Name = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 15)
  self.imgCamp0Flag = self.viewSkin:AddComponent(self, UIImage, 16)
  self.textTmpCamp1Name = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 17)
  self.textTmpCamp0AllianceName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 18)
  self.textTmpCamp10AllianceName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 19)
  self.textTmpCamp11AllianceName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 20)
  self.imgCamp10Flag = self.viewSkin:AddComponent(self, UIImage, 21)
  self.imgCamp11Flag = self.viewSkin:AddComponent(self, UIImage, 22)
  self.btnBottomTeamB = self.viewSkin:AddComponent(self, UIButton, 23)
  self.btnBottomTeamB:SetOnClick(function()
    self:OnBtnBottomTeamBClick()
  end)
  self.textBtnBottomTeamBLabel = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 24)
  self.imgBottomNotice = self.viewSkin:AddComponent(self, UIImage, 25)
  self.textTmpBottomNotice2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 26)
  self.compMVPNode = self.viewSkin:AddComponent(self, UIBaseComponent, 27)
  self.compFightingNode = self.viewSkin:AddComponent(self, UIBaseComponent, 28)
  self.textTmpActivityName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 29)
  self.compSkillCamp00 = self.viewSkin:AddComponent(self, UIActEpidemicSkillItem, 30)
  self.compSkillCamp01 = self.viewSkin:AddComponent(self, UIActEpidemicSkillItem, 31)
  self.btnArbiterNode = self.viewSkin:AddComponent(self, UIButton, 32)
  self.btnArbiterNode:SetOnClick(function()
    self:OnBtnArbiterNodeClick()
  end)
  self.compPlayerDogHead = self.viewSkin:AddComponent(self, UIPlayerHead, 33)
  self.btnLog = self.viewSkin:AddComponent(self, UIButton, 34)
  self.btnLog:SetOnClick(function()
    self:OnBtnLogClick()
  end)
  self.btnBottomEnterBattle = self.viewSkin:AddComponent(self, UIButton, 35)
  self.btnBottomEnterBattle:SetOnClick(function()
    self:OnBtnBottomEnterBattleClick()
  end)
  self.textBtnBottomEnterBattleLabel = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 36)
  self.compArbiterAdd = self.viewSkin:AddComponent(self, UIBaseComponent, 37)
  self.btnMember = self.viewSkin:AddComponent(self, UIButton, 38)
  self.btnMember:SetOnClick(function()
    self:OnBtnMemberClick()
  end)
  self.btnBottomWatch = self.viewSkin:AddComponent(self, UIButton, 39)
  self.btnBottomWatch:SetOnClick(function()
    self:OnBtnBottomWatchClick()
  end)
  self.textBtnBottomWatchLabel = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 40)
  self.btnImgCamp0Flag = self.viewSkin:AddComponent(self, UIButton, 41)
  self.btnImgCamp0Flag:SetOnClick(function()
    self:OnBtnImgCamp0FlagClick()
  end)
  self.btnImgCamp10Flag = self.viewSkin:AddComponent(self, UIButton, 42)
  self.btnImgCamp10Flag:SetOnClick(function()
    self:OnBtnImgCamp10FlagClick()
  end)
  self.btnImgCamp11Flag = self.viewSkin:AddComponent(self, UIButton, 43)
  self.btnImgCamp11Flag:SetOnClick(function()
    self:OnBtnImgCamp11FlagClick()
  end)
  self.textBtnBottomEnterTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 44)
  self.textTmpArbiterName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 45)
  self.compRedSign = self.viewSkin:AddComponent(self, UIBaseComponent, 46)
  self.compRedEnter = self.viewSkin:AddComponent(self, UIBaseComponent, 47)
  self.compRedWatch = self.viewSkin:AddComponent(self, UIBaseComponent, 48)
  self.compHelpsTipsRoot = self.viewSkin:AddComponent(self, UIBaseComponent, 49)
  self.compArbiterSkill = self.viewSkin:AddComponent(self, UIActEpidemicSkillItem, 50)
  self.compArbiterRed = self.viewSkin:AddComponent(self, UIBaseComponent, 51)
  self.compLordSkillRed = self.viewSkin:AddComponent(self, UIBaseComponent, 52)
  self.btnTmpCamp0Tip = self.viewSkin:AddComponent(self, UIButton, 53)
  self.btnTmpCamp0Tip:SetOnClick(function()
    self:OnBtnTmpCamp0TipClick()
  end)
  self.btnTmpCamp10Tip = self.viewSkin:AddComponent(self, UIButton, 54)
  self.btnTmpCamp10Tip:SetOnClick(function()
    self:OnBtnTmpCamp10TipClick()
  end)
  self.btnTmpCamp11Tip = self.viewSkin:AddComponent(self, UIButton, 55)
  self.btnTmpCamp11Tip:SetOnClick(function()
    self:OnBtnTmpCamp11TipClick()
  end)
  self.compEffChange = self.viewSkin:AddComponent(self, UIBaseComponent, 56)
  self.btnBottomChangeTime = self.viewSkin:AddComponent(self, UIButton, 57)
  self.btnBottomChangeTime:SetOnClick(function()
    self:OnBtnBottomChangeTimeClick()
  end)
  self.textBtnBottomChangeTimeLabel = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 58)
  self.compRedMem = self.viewSkin:AddComponent(self, UIBaseComponent, 59)
  self.compTipGo = self.viewSkin:AddComponent(self, UIBaseComponent, 60)
  self.compBottomBtns:SetActive(true)
  self.textTmpActivityName:SetLocalText("YiBianJinQu_event_name_1")
  UIUtil.SetTextLit(self.btnTeaching.transform, "Label", "458008")
  UIUtil.SetTextLit(self.btnReward.transform, "Label", "YiBianJinQu_event_button_2")
  UIUtil.SetTextLit(self.btnShop.transform, "Label", "458009")
  UIUtil.SetTextLit(self.btnScore.transform, "Label", "458010")
  UIUtil.SetTextLit(self.btnMember.transform, "Label", "YiBianJinQu_event_button_5")
  UIUtil.SetTextLit(self.btnLog.transform, "Label", "Desert_strom_tips1052")
  self.textTmpCamp0Name:SetLocalText("YiBianJinQu_camp_name_1")
  self.textTmpCamp1Name:SetLocalText("YiBianJinQu_camp_name_2")
  self.textBtnBottomChangeTimeLabel:SetLocalText("458018")
  self.roleRenderers = {}
  self.roleRenderers[1] = {
    name = self.textTmpCamp0AllianceName,
    flag = self.imgCamp0Flag,
    btn = self.btnTmpCamp0Tip
  }
  self.roleRenderers[2] = {
    name = self.textTmpCamp10AllianceName,
    flag = self.imgCamp10Flag,
    btn = self.btnTmpCamp10Tip
  }
  self.roleRenderers[3] = {
    name = self.textTmpCamp11AllianceName,
    flag = self.imgCamp11Flag,
    btn = self.btnTmpCamp11Tip
  }
  self.compArbiterSkill:Setup(ActEpidemicUtils.GetLordSkillArbiter())
  self.compArbiterSkill.onClickedCallback = Bind(self, self.OnLordArbiterSkillClicked)
  self.compSkillCamp01.beforeClickedCallback = Bind(self, self.OnRandSkillClicked)
end

function UIActEpidemicMainRoot:ComponentDestroy()
  self.viewSkin = nil
  self.compTopRect = nil
  self.compTopRightRect = nil
  self.rawImgRImgBackground = nil
  self.btnInfo = nil
  self.btnTeaching = nil
  self.btnReward = nil
  self.btnShop = nil
  self.btnScore = nil
  self.compNodeTeamChange = nil
  self.compTimerNode = nil
  self.compBottomBtns = nil
  self.textTmpBottomNotice = nil
  self.btnBottomSign = nil
  self.textBtnBottomSignLabel = nil
  self.textTmpCamp0Name = nil
  self.imgCamp0Flag = nil
  self.textTmpCamp1Name = nil
  self.textTmpCamp0AllianceName = nil
  self.textTmpCamp10AllianceName = nil
  self.textTmpCamp11AllianceName = nil
  self.imgCamp10Flag = nil
  self.imgCamp11Flag = nil
  self.btnBottomTeamB = nil
  self.textBtnBottomTeamBLabel = nil
  self.imgBottomNotice = nil
  self.textTmpBottomNotice2 = nil
  self.compMVPNode = nil
  self.compFightingNode = nil
  self.textTmpActivityName = nil
  self.compSkillCamp00 = nil
  self.compSkillCamp01 = nil
  self.btnArbiterNode = nil
  self.compPlayerDogHead = nil
  self.btnLog = nil
  self.btnBottomEnterBattle = nil
  self.textBtnBottomEnterBattleLabel = nil
  self.compArbiterAdd = nil
  self.btnMember = nil
  self.btnBottomWatch = nil
  self.textBtnBottomWatchLabel = nil
  self.btnImgCamp0Flag = nil
  self.btnImgCamp10Flag = nil
  self.btnImgCamp11Flag = nil
  self.textBtnBottomEnterTime = nil
  self.textTmpArbiterName = nil
  self.compRedSign = nil
  self.compRedEnter = nil
  self.compRedWatch = nil
  self.compHelpsTipsRoot = nil
  self.compArbiterSkill = nil
  self.compArbiterRed = nil
  self.compLordSkillRed = nil
  self.btnTmpCamp0Tip = nil
  self.btnTmpCamp10Tip = nil
  self.btnTmpCamp11Tip = nil
  self.compEffChange = nil
  self.btnBottomChangeTime = nil
  self.textBtnBottomChangeTimeLabel = nil
  self.compRedMem = nil
  self.compTipGo = nil
  self.compTeamChange = nil
  self.roleRenderers = nil
  self.enterBattleBtnState = nil
end

function UIActEpidemicMainRoot:GetDefaultGroup()
  local myGroupIndex = ActEpidemicUtils.GetMyGroupIndex()
  if myGroupIndex and myGroupIndex ~= ActEpidemicUtils.GroupNone then
    return myGroupIndex
  end
  return ActEpidemicUtils.Group1
end

function UIActEpidemicMainRoot:DataDefine()
  self.groupSelect = self:GetDefaultGroup()
end

function UIActEpidemicMainRoot:DataDestroy()
end

function UIActEpidemicMainRoot:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActEpidemicOnActInfoRefresh, self.OnActInfoRefresh)
  self:AddUIListener(EventId.Al_UpdateSelfRank, self.RefreshSelfRank)
  self:AddUIListener(EventId.EpidemicActTryChangeRole, self.OnTryChangeRole)
  self:AddUIListener(EventId.EpidemicActChangeRoleSuccess, self.OnChangeRoleSuccess)
  self:AddUIListener(EventId.EpidemicActPlayerListRefresh, self.OnActInfoRefresh)
  self:AddUIListener(EventId.ActEpidemicOnActInfoStageChanged, self.OnActStageChanged)
  self:AddUIListener(EventId.EpidemicActTeamBStateChanged, self.RefreshTeamB)
  self:AddUIListener(EventId.BattleFieldCanEnterPush, self.OnBattleFieldCanEnterPush)
  for i = 1, 2 do
    LittleRedUtils.AddListener(LittleRedConst.NameActEpidemicMain, LittleRedConst.NameActEpidemicMainApply .. i, self, self.RefreshLittleRed)
    LittleRedUtils.AddListener(LittleRedConst.NameActEpidemicMain, LittleRedConst.NameActEpidemicMainFight .. i, self, self.RefreshLittleRed)
    LittleRedUtils.AddListener(LittleRedConst.NameActEpidemicMain, LittleRedConst.NameActEpidemicMainArbiterNotSet .. i, self, self.RefreshLittleRed)
    LittleRedUtils.AddListener(LittleRedConst.NameActEpidemicOther, LittleRedConst.NameActEpidemicMainCommanderNotSet .. i, self, self.RefreshLittleRed)
    LittleRedUtils.AddListener(LittleRedConst.NameActEpidemicOther, LittleRedConst.NameActEpidemicMainContact .. i, self, self.RefreshLittleRed)
  end
end

function UIActEpidemicMainRoot:OnRemoveListener()
  self:RemoveUIListener(EventId.ActEpidemicOnActInfoRefresh, self.OnActInfoRefresh)
  self:RemoveUIListener(EventId.Al_UpdateSelfRank, self.RefreshSelfRank)
  self:RemoveUIListener(EventId.EpidemicActTryChangeRole, self.OnTryChangeRole)
  self:RemoveUIListener(EventId.EpidemicActChangeRoleSuccess, self.OnChangeRoleSuccess)
  self:RemoveUIListener(EventId.EpidemicActPlayerListRefresh, self.OnActInfoRefresh)
  self:RemoveUIListener(EventId.ActEpidemicOnActInfoStageChanged, self.OnActStageChanged)
  self:RemoveUIListener(EventId.EpidemicActTeamBStateChanged, self.RefreshTeamB)
  self:RemoveUIListener(EventId.BattleFieldCanEnterPush, self.OnBattleFieldCanEnterPush)
  LittleRedUtils.ClearListener(LittleRedConst.NameActEpidemicMain, self)
  LittleRedUtils.ClearListener(LittleRedConst.NameActEpidemicOther, self)
  base.OnRemoveListener(self)
end

function UIActEpidemicMainRoot:SetData(activityId)
  self.autoRequestTimes = 3
  base.SetData(self, activityId)
end

function UIActEpidemicMainRoot:GetActType()
  return EnumActivity.ActEpidemic.Type
end

function UIActEpidemicMainRoot:OnEnterNode()
  DataCenter.ActEpidemicZoneManager:RequestActivityInfo()
end

function UIActEpidemicMainRoot:GetGroupIndex()
  if not self.groupSelect then
    self.groupSelect = ActEpidemicUtils.Group1
  end
  return self.groupSelect
end

function UIActEpidemicMainRoot:GetCurrentGroup()
  return ActEpidemicUtils.GetGroup(self.groupSelect)
end

function UIActEpidemicMainRoot:GetCurrentGroupRoles()
  local group = ActEpidemicUtils.GetGroup(self.groupSelect)
  if not group then
    return nil
  end
  return group.roles
end

function UIActEpidemicMainRoot:GetCurrentSignState()
  local group = self:GetCurrentGroup()
  if not group then
    return EpidemicZoneSignState.StateSignNone
  end
  return group.state or EpidemicZoneSignState.StateSignNone
end

function UIActEpidemicMainRoot:GetCurrentActStage()
  local stage, et = DataCenter.ActEpidemicZoneManager:FixStage(self.groupSelect)
  self.currentStage = stage
  self.endTime = et
  return stage
end

function UIActEpidemicMainRoot:GetCurrentGroupMemberCount()
  return ActEpidemicUtils.GetSummaryByGroup(self:GetGroupIndex())
end

function UIActEpidemicMainRoot:OnTryChangeRole(args)
  if not args then
    return
  end
  local group = args.group
  local role = args.role
  if args.bSign then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIBattleFieldSelectTime, {anim = true}, self.groupSelect, BattleFieldType.EpidemicZone, function(battlePeriod)
      DataCenter.ActEpidemicZoneManager:RequestActivitySignUp(group, role, battlePeriod)
      self.tryChangeRole = args
    end)
  else
    local groupInfo = ActEpidemicUtils.GetGroup(group)
    local battlePeriod = groupInfo and groupInfo.battlePeriod or 1
    DataCenter.ActEpidemicZoneManager:RequestActivitySignUp(group, role, battlePeriod)
    self.tryChangeRole = args
  end
end

function UIActEpidemicMainRoot:OnChangeRoleSuccess(args)
  if not args then
    return
  end
  if not self.tryChangeRole then
    return
  end
  if args.group == self.tryChangeRole.group and args.role == self.tryChangeRole.role and not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIActEpidemicSelectUserViewV2) then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActEpidemicSelectUserViewV2, {anim = true}, {
      group = args.group,
      role = args.role
    })
  end
  self.tryChangeRole = nil
end

function UIActEpidemicMainRoot:RefreshSelfRank()
  self:RefreshView()
end

function UIActEpidemicMainRoot:UpdateData()
  if self.activityId == nil then
    return
  end
  self:RefreshCompsState()
  self:RefreshCompTeamChange()
  self:RefreshCompTimer()
  self:RefreshCompBottomBtns()
  self:RefreshCompFighting()
  self:RefreshCompMvp()
  self:RefreshCompRoles()
  self:RefreshCompSkills()
  self:RefreshCompArbiter()
  self:RefreshLittleRed()
  self:RefreshHelpTips()
  self:RefreshMisc()
  self:UpdateEnterBattleBtnState()
  self:CheckAssignedStateChange()
end

function UIActEpidemicMainRoot:OnActInfoRefresh()
  ActEpidemicUtils.Log("\230\142\165\229\136\176\230\180\187\229\138\168\230\182\136\230\129\175\230\155\180\230\150\176...")
  self:RefreshView()
  self:CheckRoleNotice()
end

local BtnState = {}
BtnState.Hide = 0
BtnState.Sign = 1
BtnState.PreMembers = 2
BtnState.ShowMembers = 3
BtnState.BanTeam = 4
BtnState.ActiveTeam = 5
BtnState.Contact = 6
BtnState.EnterBattle = 7
BtnState.Watch = 8
local compsState = {}
compsState.showTeamChange = true
compsState.showTimer = false
compsState.showMvp = false
compsState.showFighting = false
compsState.showLordSkill = false
compsState.showFlags = false
compsState.bottomBtnChange = BtnState.Hide
compsState.bottomBtnSign = BtnState.Hide
compsState.bottomBtnBanTeam = BtnState.Hide
compsState.bottomEnterBattle = BtnState.Hide
compsState.bottomWatch = BtnState.Hide
compsState.rightBtnMember = BtnState.Hide
compsState.showArbiter = false
compsState.bottomNotice1 = ""
compsState.bottomNotice2 = ""
compsState.showBottomMemberIcon = false
compsState.bgTexType = 0
compsState.showHelpTips = false
compsState.showArbiterSkill = false

local function _GetMemberCountLabel(main, sub, containSelf)
  return string.format("%s %s", Localization:GetString("YiBianJinQu_event_tips_1", (main or 0) + (sub or 0)), containSelf and Localization:GetString("458284") or "")
end

local function _GetSystemNoticeLabel(role)
  local roleName = string.format("<color=#FFB644>%s</color>", ActEpidemicUtils.GetRoleNameByRoleId(role))
  return Localization:GetString("YiBianJinQu_event_tips_3", roleName)
end

function UIActEpidemicMainRoot:RefreshCompsState()
  compsState.showTeamChange = true
  compsState.showTimer = false
  compsState.showMvp = false
  compsState.showFighting = false
  compsState.showLordSkill = false
  compsState.showFlags = false
  compsState.bottomBtnChange = BtnState.Hide
  compsState.bottomBtnSign = BtnState.Hide
  compsState.bottomBtnBanTeam = BtnState.Hide
  compsState.bottomEnterBattle = BtnState.Hide
  compsState.bottomWatch = BtnState.Hide
  compsState.rightBtnMember = BtnState.Hide
  compsState.showArbiter = false
  compsState.bottomNotice1 = ""
  compsState.bottomNotice2 = ""
  compsState.showBottomMemberIcon = false
  compsState.bgTexType = 0
  compsState.showHelpTips = true
  compsState.showArbiterSkill = false
  local actInfo = ActEpidemicUtils.GetActInfo()
  if not actInfo then
    return
  end
  local stage = self:GetCurrentActStage()
  local currentState = self:GetCurrentSignState()
  local authority = ActEpidemicUtils.CanChangeBattlePlayer()
  local mainMember, subMember = self:GetCurrentGroupMemberCount()
  local currentGroup = self:GetCurrentGroup()
  local selfSigned = currentGroup and currentGroup.selfAssigned and currentGroup.selfAssigned ~= EpidemicZonePlayerState.None
  local selfIsMain = selfSigned and currentGroup.selfAssigned == EpidemicZonePlayerState.Main
  local role = self:GetCurrentGroupRole()
  local currentGroupIndex = self:GetGroupIndex()
  if stage == EpidemicZoneStage.SignIn then
    compsState.showTimer = true
    compsState.showArbiterSkill = true
    if currentState == EpidemicZoneSignState.StateSignNone then
      compsState.showLordSkill = true
      compsState.showFlags = true
      compsState.bottomBtnSign = BtnState.Sign
      compsState.bottomNotice1 = Localization:GetString("YiBianJinQu_event_desc_1")
      if authority and currentGroupIndex == ActEpidemicUtils.Group2 then
        compsState.bottomBtnBanTeam = BtnState.BanTeam
      end
    elseif currentState == EpidemicZoneSignState.StateSignSuc then
      compsState.showLordSkill = true
      compsState.showFlags = true
      compsState.bottomBtnChange = BtnState.PreMembers
      compsState.bottomBtnSign = BtnState.PreMembers
      compsState.bottomNotice1 = _GetMemberCountLabel(mainMember, subMember, selfSigned)
      compsState.showBottomMemberIcon = true
      if authority and currentGroupIndex == ActEpidemicUtils.Group2 then
        compsState.bottomBtnBanTeam = BtnState.BanTeam
      end
    elseif currentState == EpidemicZoneSignState.StateBan and authority and currentGroupIndex == ActEpidemicUtils.Group2 then
      compsState.bottomBtnBanTeam = BtnState.ActiveTeam
    end
  elseif stage == EpidemicZoneStage.Matching then
    compsState.showTimer = true
    compsState.showArbiterSkill = true
    if currentState == EpidemicZoneSignState.StateSignNone then
    elseif currentState == EpidemicZoneSignState.StateSignSuc then
      compsState.showLordSkill = true
      compsState.showFlags = true
      compsState.bottomNotice1 = _GetMemberCountLabel(mainMember, subMember, selfSigned)
      compsState.bottomNotice2 = _GetSystemNoticeLabel(role)
      compsState.rightBtnMember = BtnState.ShowMembers
      compsState.showBottomMemberIcon = true
    elseif currentState == EpidemicZoneSignState.StateBan then
      compsState.bottomNotice2 = Localization:GetString("YiBianJinQu_trivial_tips_8")
    end
  elseif stage == EpidemicZoneStage.MatchEnd then
    compsState.showTimer = true
    if currentState == EpidemicZoneSignState.StateMatchSuc then
      compsState.showLordSkill = true
      compsState.showFlags = true
      if role == EpidemicZoneRole.Farmer and selfSigned then
        compsState.bottomWatch = BtnState.Contact
      end
      compsState.bottomBtnSign = BtnState.ShowMembers
      compsState.bottomNotice1 = _GetMemberCountLabel(mainMember, subMember, selfSigned)
      compsState.showBottomMemberIcon = true
      compsState.showArbiterSkill = role == EpidemicZoneRole.Farmer
      if role == EpidemicZoneRole.Lord then
        compsState.showArbiter = true
      end
      compsState.bgTexType = role == EpidemicZoneRole.Lord and 1 or 2
    elseif currentState == EpidemicZoneSignState.StateMatchFailed then
      compsState.bottomNotice2 = Localization:GetString("YiBianJinQu_trivial_tips_9")
    elseif currentState == EpidemicZoneSignState.StateBan then
      compsState.bottomNotice2 = Localization:GetString("YiBianJinQu_trivial_tips_8")
    elseif currentState == EpidemicZoneSignState.StateSignNone then
      compsState.bottomNotice2 = Localization:GetString("YiBianJinQu_trivial_tips_10")
    end
  elseif stage == EpidemicZoneStage.Prepare then
    compsState.showTimer = true
    if currentState == EpidemicZoneSignState.StateMatchSuc then
      compsState.showLordSkill = true
      compsState.showFlags = true
      compsState.showArbiterSkill = role == EpidemicZoneRole.Farmer
      if selfIsMain then
        compsState.bottomEnterBattle = BtnState.EnterBattle
      end
      compsState.bottomBtnSign = BtnState.ShowMembers
      compsState.bottomNotice1 = _GetMemberCountLabel(mainMember, subMember, selfSigned)
      compsState.showBottomMemberIcon = true
      compsState.showArbiter = true
      compsState.bgTexType = role == EpidemicZoneRole.Lord and 1 or 2
    elseif currentState == EpidemicZoneSignState.StateMatchFailed then
      compsState.showTimer = true
      compsState.bottomNotice2 = Localization:GetString("YiBianJinQu_trivial_tips_11")
    elseif currentState == EpidemicZoneSignState.StateBan then
      compsState.showTimer = true
      compsState.bottomNotice2 = Localization:GetString("YiBianJinQu_trivial_tips_8")
    elseif currentState == EpidemicZoneSignState.StateSignNone then
      compsState.showTimer = true
      compsState.bottomNotice2 = Localization:GetString("YiBianJinQu_trivial_tips_10")
    end
  elseif stage == EpidemicZoneStage.Battle then
    if currentState == EpidemicZoneSignState.StateMatchSuc then
      compsState.showArbiterSkill = role == EpidemicZoneRole.Farmer
      compsState.showLordSkill = true
      compsState.showFighting = true
      compsState.showFlags = true
      if selfSigned then
        compsState.bottomEnterBattle = BtnState.EnterBattle
      end
      compsState.bottomWatch = BtnState.Watch
      compsState.rightBtnMember = BtnState.ShowMembers
      compsState.bottomNotice1 = _GetMemberCountLabel(mainMember, subMember, selfSigned)
      compsState.showBottomMemberIcon = true
      compsState.showArbiter = true
      compsState.bgTexType = role == EpidemicZoneRole.Lord and 1 or 2
    elseif currentState == EpidemicZoneSignState.StateMatchFailed then
      compsState.showTimer = true
      compsState.bottomNotice2 = Localization:GetString("YiBianJinQu_trivial_tips_11")
    elseif currentState == EpidemicZoneSignState.StateBan then
      compsState.showTimer = true
      compsState.bottomNotice2 = Localization:GetString("YiBianJinQu_trivial_tips_8")
    elseif currentState == EpidemicZoneSignState.StateSignNone then
      compsState.showTimer = true
      compsState.bottomNotice2 = Localization:GetString("YiBianJinQu_trivial_tips_10")
    end
  elseif stage == EpidemicZoneStage.Show then
    if currentState == EpidemicZoneSignState.StateMatchSuc then
      compsState.showMvp = true
      compsState.showLordSkill = true
      compsState.showFlags = true
      compsState.bgTexType = role == EpidemicZoneRole.Lord and 1 or 2
    elseif currentState == EpidemicZoneSignState.StateMatchFailed then
      compsState.showTimer = true
      compsState.bottomNotice2 = Localization:GetString("YiBianJinQu_trivial_tips_11")
    elseif currentState == EpidemicZoneSignState.StateBan then
      compsState.showTimer = true
      compsState.bottomNotice2 = Localization:GetString("YiBianJinQu_trivial_tips_8")
    elseif currentState == EpidemicZoneSignState.StateSignNone then
      compsState.showTimer = true
      compsState.bottomNotice2 = Localization:GetString("YiBianJinQu_trivial_tips_10")
    end
  else
    if stage == EpidemicZoneStage.End then
    else
    end
  end
  return compsState
end

function UIActEpidemicMainRoot:RefreshLittleRed()
  local actMgr = DataCenter.ActEpidemicZoneManager
  local showSignRed = compsState.bottomBtnSign == BtnState.Sign and actMgr:CheckRedShow(LittleRedConst.NameActEpidemicMain, LittleRedConst.NameActEpidemicMainApply, self.groupSelect)
  local showContactRed = compsState.bottomWatch == BtnState.Contact and actMgr:CheckRedShow(LittleRedConst.NameActEpidemicOther, LittleRedConst.NameActEpidemicMainContact, self.groupSelect)
  local showEnterRed = compsState.bottomEnterBattle == BtnState.EnterBattle and actMgr:CheckRedShow(LittleRedConst.NameActEpidemicMain, LittleRedConst.NameActEpidemicMainFight, self.groupSelect)
  local fixStage = self:GetCurrentActStage()
  local checkStage = fixStage == EpidemicZoneStage.MatchEnd or fixStage == EpidemicZoneStage.Prepare or fixStage == EpidemicZoneStage.Battle
  local showArbiter = checkStage and actMgr:CheckRedShow(LittleRedConst.NameActEpidemicMain, LittleRedConst.NameActEpidemicMainArbiterNotSet, self.groupSelect)
  local comCount = DataCenter.ActEpidemicZoneManager:GetCommanderNum(self.groupSelect)
  local showCommander = (compsState.bottomBtnSign == BtnState.PreMembers or compsState.bottomBtnSign == BtnState.ShowMembers or compsState.rightBtnMember ~= BtnState.Hide) and fixStage < EpidemicZoneStage.Show and comCount == 0 and actMgr:CheckRedShow(LittleRedConst.NameActEpidemicOther, LittleRedConst.NameActEpidemicMainCommanderNotSet, self.groupSelect)
  self.compRedSign:SetActive(showSignRed or showCommander)
  self.compRedWatch:SetActive(showContactRed)
  self.compRedEnter:SetActive(showEnterRed)
  self.compArbiterRed:SetActive(showArbiter)
  self.compRedMem:SetActive(showCommander)
end

function UIActEpidemicMainRoot:RefreshCompBottomBtns()
  local bCount = 0
  local showBtnChangeTime = compsState.bottomBtnChange == BtnState.PreMembers
  self.btnBottomChangeTime:SetActive(showBtnChangeTime)
  if showBtnChangeTime then
    bCount = bCount + 1
  end
  if compsState.bottomBtnSign == BtnState.Hide then
    self.btnBottomSign:SetActive(false)
  else
    local showFlag = true
    if compsState.bottomBtnSign == BtnState.Sign then
      self.textBtnBottomSignLabel:SetLocalText("YiBianJinQu_event_button_1")
    elseif compsState.bottomBtnSign == BtnState.PreMembers then
      self.textBtnBottomSignLabel:SetLocalText("YiBianJinQu_event_button_3")
    elseif compsState.bottomBtnSign == BtnState.ShowMembers then
      self.textBtnBottomSignLabel:SetLocalText("YiBianJinQu_event_button_5")
    else
      showFlag = false
    end
    self.btnBottomSign:SetActive(showFlag)
    if showFlag then
      bCount = bCount + 1
    end
  end
  if compsState.bottomBtnBanTeam == BtnState.Hide then
    self.btnBottomTeamB:SetActive(false)
  else
    local showFlag = true
    if compsState.bottomBtnBanTeam == BtnState.BanTeam then
      self.textBtnBottomTeamBLabel:SetLocalText("YiBianJinQu_event_button_4")
    elseif compsState.bottomBtnBanTeam == BtnState.ActiveTeam then
      self.textBtnBottomTeamBLabel:SetLocalText("Desert_strom_tips1082")
    else
      showFlag = false
    end
    self.btnBottomTeamB:SetActive(showFlag)
    if showFlag then
      bCount = bCount + 1
    end
  end
  if compsState.bottomEnterBattle == BtnState.Hide then
    self.btnBottomEnterBattle:SetActive(false)
  else
    local showFlag = true
    if compsState.bottomEnterBattle == BtnState.EnterBattle then
      self.textBtnBottomEnterBattleLabel:SetLocalText("YiBianJinQu_trivial_tips_12")
    else
      showFlag = false
    end
    self.btnBottomEnterBattle:SetActive(showFlag)
    if showFlag then
      bCount = bCount + 1
    end
  end
  if compsState.bottomWatch == BtnState.Hide then
    self.btnBottomWatch:SetActive(false)
  elseif compsState.bottomWatch == BtnState.Contact then
    self.btnBottomWatch:SetActive(true)
    self.textBtnBottomWatchLabel:SetLocalText("YiBianJinQu_event_button_6")
    bCount = bCount + 1
  elseif compsState.bottomWatch == BtnState.Watch then
    self.btnBottomWatch:SetActive(true)
    self.textBtnBottomWatchLabel:SetLocalText("Desert_strom_tips1032")
    bCount = bCount + 1
  else
    self.btnBottomWatch:SetActive(false)
  end
  if compsState.rightBtnMember == BtnState.Hide then
    self.btnMember:SetActive(false)
  else
    self.btnMember:SetActive(true)
  end
  self.textTmpBottomNotice:SetText(compsState.bottomNotice1)
  self.textTmpBottomNotice2:SetText(compsState.bottomNotice2)
  self.imgBottomNotice:SetActive(compsState.showBottomMemberIcon)
  local scale = bCount <= 2 and 0.85 or 0.7
  self.compBottomBtns:SetLocalScaleXYZ(scale, scale, scale)
  local posOff = bCount <= 2 and 0 or 50
  local _, y, z = self.textTmpBottomNotice:GetLocalPositionXYZ()
  self.textTmpBottomNotice:SetLocalPositionXYZ(posOff, y, z)
  _, y, z = self.textTmpBottomNotice2:GetLocalPositionXYZ()
  self.textTmpBottomNotice2:SetLocalPositionXYZ(posOff, y, z)
  _, y, z = self.compBottomBtns:GetLocalPositionXYZ()
  self.compBottomBtns:SetLocalPositionXYZ(posOff, y, z)
  self:RefreshTipGo()
end

function UIActEpidemicMainRoot:RefreshTipGo()
  local bMyGroup = ActEpidemicUtils.GetMyGroupIndex() == self:GetGroupIndex()
  local show = bMyGroup and self.btnBottomEnterBattle:GetActive() and compsState.bottomEnterBattle == BtnState.EnterBattle and BattleFieldUtil.GetBattleFieldCanEnterFlag(BattleFieldType.EpidemicZone)
  self.compTipGo:SetActive(show)
  if not show then
    return
  end
  local x = self.btnBottomEnterBattle:GetPositionXYZ()
  local _, y, z = self.compTipGo:GetPositionXYZ()
  self.compTipGo:SetPositionXYZ(x, y, z)
end

function UIActEpidemicMainRoot:RefreshCompTeamChange(refresh)
  local vs = refresh and self:RefreshCompsState() or compsState
  local visible = vs.showTeamChange
  if self.compTeamChange then
    if self.compTeamChange:AsyncLoadDone() then
      if visible then
        self.compTeamChange:Show()
      else
        self.compTeamChange:Hide()
      end
    end
  elseif visible then
    self.compTeamChange = self:LoadComponentAsync(Path_UIActEpidemicMainCompTeamChange, UIAssets.ActEpidemicCompChangeTeam, self.compNodeTeamChange.transform, function()
      UIUtil.DebugSetName(self.compTeamChange.gameObject, "[Dynamic]compTeamChange")
      self.compTeamChange:SetAnchoredPositionXY(0, 0)
      self:RefreshCompTeamChange(true)
    end, nil, self)
  end
end

function UIActEpidemicMainRoot:RefreshCompTimer(refresh)
  local vs = refresh and self:RefreshCompsState() or compsState
  local visible = vs.showTimer
  if self.compTimer then
    if self.compTimer:AsyncLoadDone() then
      if visible then
        self.compTimer:SetGroup(self.groupSelect)
        self.compTimer:Show()
      else
        self.compTimer:Hide()
      end
    end
  elseif visible then
    self.compTimer = self:LoadComponentAsync(Path_UIActEpidemicMainCompTimer, UIAssets.ActEpidemicCompTimer, self.compTimerNode.transform, function()
      UIUtil.DebugSetName(self.compTimer.gameObject, "[Dynamic]compTimer")
      self.compTimer:SetAnchoredPositionXY(0, 0)
      self:RefreshCompTimer(true)
    end, nil, self)
  end
end

function UIActEpidemicMainRoot:RefreshCompMvp(refresh)
  local vs = refresh and self:RefreshCompsState() or compsState
  local visible = vs.showMvp
  if self.compMvp then
    if self.compMvp:AsyncLoadDone() then
      if visible then
        self.compMvp:Show()
      else
        self.compMvp:Hide()
      end
    end
  elseif visible then
    self.compMvp = self:LoadComponentAsync(Path_UIActEpidemicMainCompMVP, UIAssets.ActEpidemicCompMvp, self.compMVPNode.transform, function()
      UIUtil.DebugSetName(self.compMvp.gameObject, "[Dynamic]compMvp")
      self.compMvp:SetAnchoredPositionXY(0, 0)
      self:RefreshCompMvp(true)
    end, nil, self)
  end
end

function UIActEpidemicMainRoot:RefreshCompFighting(refresh)
  local vs = refresh and self:RefreshCompsState() or compsState
  local visible = vs.showFighting
  if self.compFighting then
    if self.compFighting:AsyncLoadDone() then
      if visible then
        self.compFighting:Show()
      else
        self.compFighting:Hide()
      end
    end
  elseif visible then
    self.compFighting = self:LoadComponentAsync(Path_UIActEpidemicMainCompFighting, UIAssets.ActEpidemicCompFighting, self.compFightingNode.transform, function()
      UIUtil.DebugSetName(self.compFighting.gameObject, "[Dynamic]compFighting")
      self.compFighting:SetAnchoredPositionXY(0, 0)
      self:RefreshCompFighting(true)
    end, nil, self)
  end
end

function UIActEpidemicMainRoot:RefreshCompRoles()
  local roles = ActEpidemicUtils.GetRolesByGroup(self.groupSelect)
  local _ = {}
  if roles then
    for k, v in ipairs(roles) do
      _[v.side] = v
    end
  end
  local currentStage = self:GetCurrentActStage()
  local bMatchEnd = currentStage >= EpidemicZoneStage.MatchEnd
  for k, v in ipairs(self.roleRenderers) do
    local flag = v.flag
    local name = v.name
    local btn = v.btn
    local roleInfo = _[k]
    if not compsState.showFlags then
      flag:SetActive(false)
      name:SetActive(false)
      btn:SetActive(false)
    else
      flag:SetActive(true)
      do
        local flagIcon = roleInfo and roleInfo.icon or 0
        flag:LoadSpriteAsyncWithCallback(string.format(AL_FLAG_SPRITE_PATH, flagIcon), function()
          if flag then
            flag:SetNativeSize()
          end
        end)
        if roleInfo then
          name:SetActive(true)
          name:SetText(string.format("[%s]", roleInfo.abbr or ""))
          name:SetColor(roleInfo.oneself and ActEpidemicUtils.GetMyColor() or ActEpidemicUtils.GetOtherColor())
          btn:SetActive(roleInfo.oneself and not bMatchEnd)
        else
          name:SetActive(false)
          btn:SetActive(false)
        end
      end
    end
  end
end

function UIActEpidemicMainRoot:SetGroupIndex(idx)
  self.compEffChange:SetActive(false)
  self.compEffChange:SetActive(true)
  self.groupSelect = idx
  if self.compTeamChange then
    self.compTeamChange:RefreshSelection()
  end
  self:RefreshView()
  self:CheckRoleNotice()
end

function UIActEpidemicMainRoot:CheckRoleNotice()
  local actInfo = ActEpidemicUtils.GetActInfo()
  if not actInfo then
    return
  end
  local currentGroupIndex = self:GetGroupIndex()
  local startTime = actInfo:GetActStartTime()
  local key = string.format("EpidemicPapaFace_%s_%s", currentGroupIndex, startTime)
  if CommonUtil.PlayerPrefsGetBool(key, false) then
    return
  end
  local group = self:GetCurrentGroup()
  if not group then
    return
  end
  local currentStage = self:GetCurrentActStage()
  if currentStage == EpidemicZoneStage.MatchEnd or currentStage == EpidemicZoneStage.Prepare or currentStage == EpidemicZoneStage.Battle then
    local currentState = self:GetCurrentSignState()
    if currentState == EpidemicZoneSignState.StateMatchSuc then
      local role = group.selfRole
      if role ~= EpidemicZoneRole.Default then
        CommonUtil.PlayerPrefsSetBool(key, true)
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIActEpidemicCampResultView, {anim = true}, {group = currentGroupIndex})
      end
    end
  end
end

function UIActEpidemicMainRoot:GetCurrentGroupRole()
  local role = ActEpidemicUtils.GetRoleByGroup(self.groupSelect)
  if role == 1 then
    role = 1
  elseif role == 2 then
    role = 2
  elseif role == 3 then
    role = 2
  else
    role = 0
  end
  return role
end

function UIActEpidemicMainRoot:GetCurrentArbiter()
  local roleInfo = ActEpidemicUtils.GetRoleByGroupAndSide(self.groupSelect, EpidemicBattleSide.Lord)
  return roleInfo and roleInfo.arbiter
end

function UIActEpidemicMainRoot:OnBtnBottomChangeTimeClick()
  if not LuaEntry.Player:IsInAlliance() then
    UIUtil.ShowTipsId(390856)
    return
  end
  local authority = ActEpidemicUtils.CanChangeBattlePlayer()
  if compsState.bottomBtnChange == BtnState.PreMembers then
    if authority then
      self:OnTryChangeRole({
        group = self.groupSelect,
        role = self:GetCurrentGroupRole(),
        bSign = true
      })
    else
      UIUtil.ShowTipsId("YiBianJinQu_trivial_tips_13")
    end
  end
end

function UIActEpidemicMainRoot:OnBtnBottomSignClick()
  if not LuaEntry.Player:IsInAlliance() then
    UIUtil.ShowTipsId(390856)
    return
  end
  local role = self:GetCurrentGroupRole()
  local authority = ActEpidemicUtils.CanChangeBattlePlayer()
  if compsState.bottomBtnSign == BtnState.Sign then
    if authority then
      DataCenter.ActEpidemicZoneManager:MarkRed(LittleRedConst.NameActEpidemicMain, LittleRedConst.NameActEpidemicMainApply, self.groupSelect)
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIActEpidemicSelectCampView, {anim = true}, {
        group = self.groupSelect,
        role = role
      })
    else
      UIUtil.ShowTipsId("YiBianJinQu_trivial_tips_13")
    end
  elseif compsState.bottomBtnSign == BtnState.PreMembers then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActEpidemicSelectUserViewV2, {anim = true}, {
      group = self.groupSelect,
      role = role
    })
  elseif compsState.bottomBtnSign == BtnState.ShowMembers then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActEpidemicSelectUserViewV2, {anim = true}, {
      group = self.groupSelect,
      role = role
    })
  end
end

function UIActEpidemicMainRoot:OnBtnBottomTeamBClick()
  if not LuaEntry.Player:IsInAlliance() then
    UIUtil.ShowTipsId(390856)
    return
  end
  if compsState.bottomBtnBanTeam == BtnState.BanTeam then
    local time = DataCenter.ActEpidemicZoneManager:GetNextOperateTeamBSec()
    if 0 < time then
      UIUtil.ShowSecondMessageByParam({
        tipText = Localization:GetString("Desert_strom_tips1081"),
        btnNum = 2,
        showToggle = false,
        cdConfirm = time,
        delayConfirm = {delayTime = time},
        sureAction = function()
          DataCenter.ActEpidemicZoneManager:RequestActivityModifyTeamState(false)
        end
      })
    else
      UIUtil.ShowSecondMessageByParam({
        tipText = Localization:GetString("YiBianJinQu_trivial_tips_14"),
        btnNum = 2,
        showToggle = false,
        sureAction = function()
          DataCenter.ActEpidemicZoneManager:RequestActivityModifyTeamState(false)
        end
      })
    end
  elseif compsState.bottomBtnBanTeam == BtnState.ActiveTeam then
    UIUtil.ShowSecondMessageByParam({
      tipText = Localization:GetString("Desert_strom_tips1080"),
      btnNum = 2,
      showToggle = false,
      sureAction = function()
        DataCenter.ActEpidemicZoneManager:RequestActivityModifyTeamState(true)
      end
    })
  end
end

function UIActEpidemicMainRoot:OnBtnBottomEnterBattleClick()
  if not LuaEntry.Player:IsInAlliance() then
    UIUtil.ShowTipsId(390856)
    return
  end
  if compsState.bottomEnterBattle == BtnState.EnterBattle then
    local cd = self:GetEnterBattleCd()
    if 0 < cd then
      local timeStr = UITimeManager:GetInstance():SecondToFmtString(cd)
      UIUtil.ShowTips(Localization:GetString("YiBianJinQu_battle_tips_5", timeStr))
      return
    end
    BattleFieldUtil.ClearBattleFieldCanEnterFlag(BattleFieldType.EpidemicZone)
    DataCenter.ActEpidemicZoneManager:MarkRed(LittleRedConst.NameActEpidemicMain, LittleRedConst.NameActEpidemicMainFight, self.groupSelect)
    DataCenter.ActEpidemicZoneManager:TryEnterBattlefield()
  end
end

function UIActEpidemicMainRoot:OnBattleFieldCanEnterPush(worldType)
  if worldType ~= nil and toInt(worldType) ~= BattleFieldType.EpidemicZone then
    return
  end
  self:RefreshTipGo()
end

function UIActEpidemicMainRoot:OnBtnBottomWatchClick()
  if not LuaEntry.Player:IsInAlliance() then
    UIUtil.ShowTipsId(390856)
    return
  end
  if compsState.bottomWatch == BtnState.Watch then
    DataCenter.ActEpidemicZoneManager:TryEnterBattlefield(self:GetGroupIndex())
  elseif compsState.bottomWatch == BtnState.Contact then
    DataCenter.ActEpidemicZoneManager:MarkRed(LittleRedConst.NameActEpidemicOther, LittleRedConst.NameActEpidemicMainContact, self.groupSelect)
    local myPlayerState = ActEpidemicUtils.GetMyPlayerState()
    if myPlayerState == EpidemicZonePlayerState.None then
      UIUtil.ShowTipsId("YiBianJinQu_errorcode_17")
      return
    end
    ActEpidemicUtils.GotoChatRoom()
  end
end

function UIActEpidemicMainRoot:OnBtnMemberClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActEpidemicSelectUserViewV2, {anim = true}, {
    group = self.groupSelect,
    role = self:GetCurrentGroupRole()
  })
end

function UIActEpidemicMainRoot:Update1000MS()
  local actInfo = ActEpidemicUtils.GetActInfo()
  if not actInfo then
    return
  end
  local currentStage = self.currentStage
  if currentStage >= EpidemicZoneStage.End then
    return
  end
  if compsState.bottomEnterBattle == BtnState.EnterBattle then
    self:UpdateEnterBattleBtnState()
  end
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  local remainMs = (self.endTime or 0) - curTime
  if remainMs < 0 then
    if self.nextRequest and curTime >= self.nextRequest then
      self.nextRequest = nil
    end
    if not self.nextRequest and 0 < self.autoRequestTimes then
      DataCenter.ActEpidemicZoneManager:RequestActivityInfo()
      self.nextRequest = curTime + 2
      self.autoRequestTimes = self.autoRequestTimes - 1
    end
  end
end

function UIActEpidemicMainRoot:GetEnterBattleCd()
  local actInfo = ActEpidemicUtils.GetActInfo()
  if actInfo == nil then
    return -1
  end
  local cdToEnterBattle = actInfo.leaveCDTime
  local sec = 0
  if cdToEnterBattle <= 0 then
    sec = 0
  else
    local curTime = UITimeManager:GetInstance():GetServerSeconds()
    sec = cdToEnterBattle - curTime
    sec = sec < 0 and 0 or sec
  end
  return sec
end

function UIActEpidemicMainRoot:UpdateEnterBattleBtnState()
  if compsState.bottomEnterBattle ~= BtnState.EnterBattle then
    return
  end
  local actInfo = ActEpidemicUtils.GetActInfo()
  if actInfo == nil then
    return
  end
  local sec = self:GetEnterBattleCd()
  local canEnterBattle = sec <= 0
  if self.enterBattleBtnState ~= canEnterBattle then
    self.enterBattleBtnState = canEnterBattle
    if canEnterBattle then
      CS.UIGray.SetGray(self.btnBottomEnterBattle.transform, false, true)
      self.textBtnBottomEnterBattleLabel:SetAnchoredPositionXY(0, 5)
      self.textBtnBottomEnterTime:SetActive(false)
    else
      CS.UIGray.SetGray(self.btnBottomEnterBattle.transform, true, true)
      self.textBtnBottomEnterTime:SetAnchoredPositionXY(0, 35)
      self.textBtnBottomEnterBattleLabel:SetAnchoredPositionXY(0, -12)
      self.textBtnBottomEnterTime:SetActive(true)
    end
  end
  if not canEnterBattle then
    self.textBtnBottomEnterTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtStringWithoutHour(sec * 1000))
  end
end

function UIActEpidemicMainRoot:OnActStageChanged()
  self.autoRequestTimes = 3
end

function UIActEpidemicMainRoot:RefreshTeamB()
  self:RefreshCompBottomBtns()
end

local bgNames = {
  [0] = "mjc_yibianjinqu_mainUI3_banner",
  [1] = "mjc_yibianjinqu_mainUI_banner",
  [2] = "mjc_yibianjinqu_mainUI2_banner"
}

function UIActEpidemicMainRoot:RefreshMisc()
  if not self.rawImgRImgBackground then
    return
  end
  local bgName = bgNames[compsState.bgTexType] or bgNames[0]
  if self.currentBgName == bgName then
    return
  end
  self.currentBgName = bgName
  self.rawImgRImgBackground:LoadSpriteAuto(string.format(LoadPath.LWBattleFieldEpidemicTexture2Path, bgName))
end

function UIActEpidemicMainRoot:RefreshHelpTips()
  if compsState.showHelpTips then
    self.compHelpsTipsRoot:SetActive(true)
    self:TryLoadHelpTips()
  else
    self.compHelpsTipsRoot:SetActive(false)
  end
end

function UIActEpidemicMainRoot:TryLoadHelpTips()
  if not self.helpTips then
    self.helpTips = {}
    LocalController:instance():visitTable(TableName.LW_Battlefield_tips, function(id, lineData)
      local pos = lineData.pos or {}
      local ruleId = lineData.rulesID
      local _ = {}
      _.pos = pos
      _.ruleId = ruleId
      local child = self.compHelpsTipsRoot.transform:Find(tostring(lineData.id))
      if child then
        local renderer = self:AddComponent(UIActEpidemicMainHelpTips, child.gameObject)
        renderer:Setup(ruleId)
      else
        _.request = self:GameObjectInstantiateAsync(UIAssets.UIActEpidemicHelpTips, function(request)
          if request.isError then
            return
          end
          local config = self.helpTips and self.helpTips[request]
          local go = request.gameObject
          go.transform:SetParent(self.compHelpsTipsRoot.transform)
          go.transform:Set_localScale(1, 1, 1)
          go.name = string.format("[async]helptips_%s_%s_%s", config.ruleId, config.pos[1] or "?", config.pos[2] or "?")
          go:SetActive(true)
          config.renderer = self:AddComponent(UIActEpidemicMainHelpTips, go)
          config.renderer:SetAnchoredPositionXY(config.pos[1] or 0, config.pos[2] or 0)
          config.renderer:Setup(config.ruleId)
        end)
        self.helpTips[_.request] = _
      end
    end)
  end
end

function UIActEpidemicMainRoot:DestroyAllHelpTips()
  if self.helpTips then
    for k, v in pairs(self.helpTips) do
      if k then
        self:GameObjectDestroy(k)
      end
    end
    self.helpTips = nil
  end
end

function UIActEpidemicMainRoot:RefreshCompArbiter()
  local isVisible = compsState.showArbiter
  self.compArbiterSkill:SetActive(compsState.showArbiterSkill)
  local arbiter = self:GetCurrentArbiter()
  if not isVisible then
    self.btnArbiterNode:SetActive(false)
    self.compArbiterRed:SetActive(false)
  else
    local role = self:GetCurrentGroupRole()
    if role == EpidemicZoneRole.Farmer then
      self.btnArbiterNode:SetActive(false)
    else
      self.btnArbiterNode:SetActive(true)
      if arbiter then
        self.compArbiterAdd:SetActive(false)
        self.compPlayerDogHead:SetActive(true)
        self.compPlayerDogHead:SetData(arbiter.uid, arbiter.pic, arbiter.picVer, false)
        self.textTmpArbiterName:SetActive(true)
        self.textTmpArbiterName:SetText(arbiter.name)
      else
        self.compArbiterAdd:SetActive(true)
        self.compPlayerDogHead:SetActive(false)
        self.textTmpArbiterName:SetActive(false)
      end
    end
  end
end

function UIActEpidemicMainRoot:CanAssignArbiter()
  if not ActEpidemicUtils.CanAssignArbiter() then
    return false
  end
  local currentStage = self:GetCurrentActStage()
  if currentStage == EpidemicZoneStage.MatchEnd or currentStage == EpidemicZoneStage.Prepare or currentStage == EpidemicZoneStage.Battle then
    return true
  end
  return false
end

function UIActEpidemicMainRoot:OnBtnArbiterNodeClick()
  local role = self:GetCurrentGroupRole()
  local arbiter = self:GetCurrentArbiter()
  local canAssign = self:CanAssignArbiter()
  if role == EpidemicZoneRole.Lord then
    if canAssign then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIActEpidemicAssignArbiterView, {anim = true}, {
        group = self.groupSelect,
        arbiter = arbiter
      })
    elseif arbiter and arbiter.uid then
      UIUtil.TryShowPlayerInfo(arbiter.uid)
    else
      UIUtil.ShowTipsId("YiBianJinQu_trivial_tips_15")
    end
  end
end

function UIActEpidemicMainRoot:RefreshCompSkills()
  if not compsState.showLordSkill then
    self.compSkillCamp00:SetActive(false)
    self.compSkillCamp01:SetActive(false)
  else
    self.compSkillCamp00:SetActive(true)
    self.compSkillCamp01:SetActive(true)
    self.compSkillCamp00:Setup(ActEpidemicUtils.GetLordSkillPassive())
    local randomSkillID = ActEpidemicUtils.GetLordSkillRandom(self.groupSelect)
    self.compSkillCamp01:Setup(randomSkillID)
    if randomSkillID < 0 then
      self.compLordSkillRed:SetActive(false)
    else
      self.compLordSkillRed:SetActive(DataCenter.ActEpidemicZoneManager:GetRedState(LittleRedConst.NameActEpidemicMainLordSkill, self.groupSelect) == false)
    end
  end
end

function UIActEpidemicMainRoot:OnBtnLogClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActEpidemicOperateLogView)
end

function UIActEpidemicMainRoot:OnBtnInfoClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIDesertBattleDetail, {anim = true}, BattleFieldType.EpidemicZone)
end

function UIActEpidemicMainRoot:OnBtnTeachingClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIDesertRules, {anim = true}, BattleFieldType.EpidemicZone)
end

function UIActEpidemicMainRoot:OnBtnRewardClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActEpidemicRewardView, {anim = true}, 1)
end

function UIActEpidemicMainRoot:OnBtnShopClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonShop, {anim = true}, CommonShopType.HonorShop)
end

function UIActEpidemicMainRoot:OnBtnScoreClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActEpidemicBattleHistoryView)
end

function UIActEpidemicMainRoot:OnBtnImgCamp0FlagClick()
  self:OnClickedSideFlag(EpidemicBattleSide.Lord, self.btnImgCamp0Flag.transform)
end

function UIActEpidemicMainRoot:OnBtnImgCamp10FlagClick()
  self:OnClickedSideFlag(EpidemicBattleSide.FarmerL, self.btnImgCamp10Flag.transform)
end

function UIActEpidemicMainRoot:OnBtnImgCamp11FlagClick()
  self:OnClickedSideFlag(EpidemicBattleSide.FarmerR, self.btnImgCamp11Flag.transform)
end

function UIActEpidemicMainRoot:OnRandSkillClicked()
  if DataCenter.ActEpidemicZoneManager:GetRedState(LittleRedConst.NameActEpidemicMainLordSkill, self.groupSelect) then
    return
  end
  DataCenter.ActEpidemicZoneManager:SetRedState(LittleRedConst.NameActEpidemicMainLordSkill, self.groupSelect, true)
  self.compLordSkillRed:SetActive(false)
end

function UIActEpidemicMainRoot:OnLordArbiterSkillClicked(item)
  if not item then
    return
  end
  UIUtil.ShowBubbleTips(Localization:GetString("YiBianJinQu_camp_desc_1"), item.transform.position, 0, -30, 0)
end

function UIActEpidemicMainRoot:OnClickedSideFlag(side, tran)
  local tips
  local sideName = ActEpidemicUtils.GetRoleNameBySideId(side)
  local roleInfo = ActEpidemicUtils.GetRoleInfoByGroupAndSide(self:GetGroupIndex(), side)
  local signState = self:GetCurrentSignState()
  local currentStage = self:GetCurrentActStage()
  if not roleInfo then
    if currentStage == EpidemicZoneStage.SignIn or currentStage == EpidemicZoneStage.Matching then
      tips = Localization:GetString("YiBianJinQu_trivial_tips_16", sideName)
    elseif currentStage == EpidemicZoneStage.MatchEnd and signState == EpidemicZoneSignState.StateMatchSuc then
      tips = Localization:GetString("YiBianJinQu_trivial_tips_17")
    end
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceDetail, {anim = true}, roleInfo.name, roleInfo.allianceId)
  end
  if not tips then
    return
  end
  UIUtil.ShowBubbleTips(tips, tran.position, 0, -30, 0, nil, nil)
end

function UIActEpidemicMainRoot:OnBtnTmpCamp0TipClick()
  local strTip = Localization:GetString("YiBianJinQu_camp_select_tips_5")
  UIUtil.ShowBubbleTips(strTip, self.btnTmpCamp0Tip.transform.position, 0, -30, 0)
end

function UIActEpidemicMainRoot:OnBtnTmpCamp10TipClick()
  local strTip = Localization:GetString("YiBianJinQu_camp_select_tips_5")
  UIUtil.ShowBubbleTips(strTip, self.btnTmpCamp10Tip.transform.position, 0, 30, 0, nil, nil, {reversal = true})
end

function UIActEpidemicMainRoot:OnBtnTmpCamp11TipClick()
  local strTip = Localization:GetString("YiBianJinQu_camp_select_tips_5")
  UIUtil.ShowBubbleTips(strTip, self.btnTmpCamp11Tip.transform.position, 0, 30, 0, nil, nil, {reversal = true})
end

function UIActEpidemicMainRoot:CheckAssignedStateChange()
  local actInfo = ActEpidemicUtils.GetActInfo()
  local editorUid = actInfo ~= nil and actInfo.editorUid or nil
  if string.IsNullOrEmpty(editorUid) or editorUid == LuaEntry.Player:GetUid() then
    return
  end
  local myInfo = ActEpidemicUtils.GetMyGroup()
  local sGroup, sAssigned, sPeriod, sETime = BattleFieldUtil.GetAssignedInfo(BattleFieldType.EpidemicZone)
  local curSec = UITimeManager:GetInstance():GetServerSeconds()
  if myInfo == nil then
    if sGroup == 0 then
      return
    end
    local sInfo = ActEpidemicUtils.GetGroup(sGroup)
    local endTime = sInfo ~= nil and sInfo.endTime or 0
    if endTime == 0 or curSec >= endTime then
      return
    end
    local param = {
      bfType = BattleFieldType.EpidemicZone,
      groupIdx = sGroup,
      assigned = sAssigned,
      battlePeriod = sPeriod,
      editorUid = editorUid,
      inGroup = false
    }
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIBattleFieldAssignedState, {anim = false}, param)
    BattleFieldUtil.SaveAssignedInfo(BattleFieldType.EpidemicZone, 0, 0, 0, endTime)
  else
    local assigned = myInfo.selfAssigned or 0
    if assigned == 0 then
      return
    end
    local endTime = myInfo ~= nil and myInfo.endTime or 0
    if endTime == 0 or curSec >= endTime then
      return
    end
    local group = myInfo.group
    local battlePeriod = myInfo.battlePeriod
    if 0 < group and 0 < assigned and (sGroup ~= group or sAssigned ~= assigned or endTime ~= sETime) then
      local param = {
        bfType = BattleFieldType.EpidemicZone,
        groupIdx = group,
        assigned = assigned,
        battlePeriod = battlePeriod,
        editorUid = editorUid,
        inGroup = true
      }
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIBattleFieldAssignedState, {anim = false}, param)
      BattleFieldUtil.SaveAssignedInfo(BattleFieldType.EpidemicZone, group, assigned, battlePeriod, endTime)
    end
  end
end

return UIActEpidemicMainRoot
