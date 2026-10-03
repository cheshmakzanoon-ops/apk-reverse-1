local UILWMailMainCtrl = BaseClass("UILWMailMainCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function SetView(self, view)
  self.view = view
end

local MailTranslateOpEnum = {
  Cant = 0,
  Can = 1,
  Finish = 2,
  Doing = 3
}

local function OnCustomKeyCodeEscape(self)
  local current_view = self:GetCurrentView()
  if current_view == 1 then
    self.view.closeBtn:Click()
  elseif current_view == 2 then
    self.view.returnBtn1:Click()
  elseif current_view == 3 then
    self.view.returnBtn2:Click()
  elseif current_view == 4 then
    self.view.returnBtn3:Click()
  elseif current_view == 5 then
    if self.convertBattleReportToVirtualMailShow then
      self.view.returnBtn2:Click()
      return
    end
    self.view.closeBtn:Click()
  end
end

local function CloseSelf(self)
  if self.view then
    self.view:AskForPushPermission()
  end
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWMailMain)
end

local function InitData(self)
  self.currentView = 0
  self.currentTab = 0
  self.currentMailUid = nil
  self.convertBattleReportToVirtualMailShow = false
end

local function ClearData(self)
  self.currentView = nil
  self.currentTab = nil
  self.currentMailUid = nil
  self.musterSoloData = nil
  self.convertBattleReportToVirtualMailShow = nil
end

local function SetCurrentView(self, view)
  self.currentView = view
end

local function GetCurrentView(self)
  return self.currentView
end

local function SetCurrentTab(self, tab)
  self.currentTab = tab
end

local function GetCurrentTab(self)
  return self.currentTab
end

local function SetCurrentMail(self, mail_uid)
  self.currentMailUid = mail_uid
  DataCenter.MailDataManager:SaveUIHistory(self.currentMailUid)
end

local function GetCurrentMail(self)
  return self.currentMailUid
end

local function CleanCurrentMailListByType(self)
  if self.currentTab == 0 then
    return
  end
  return DataCenter.MailDataManager:CleanGroupMailList(self.currentTab)
end

local function GetCurrentMailListByType(self)
  if self.currentTab == 0 then
    return {}
  end
  return DataCenter.MailDataManager:GetGroupMailList(self.currentTab)
end

local function GetCurrentUIMailListByType(self)
  if self.currentTab == 0 then
    return {}
  end
  return DataCenter.MailDataManager:GetGroupUIMailList(self.currentTab)
end

local function ClearGroupShowIndex(self)
  if self.currentTab == nil or self.currentTab == 0 then
    return
  end
  return DataCenter.MailDataManager:ClearGroupShowIndex(self.currentTab)
end

local function PullMoreGroupUIData(self, curTab)
  DataCenter.MailDataManager:GetMoreGroupUIMailList(curTab)
end

local function GetMailGroupFilters(self)
  if self.currentTab == nil or self.currentTab == 0 then
    return {}
  end
  return DataCenter.MailDataManager:GetMailGroupFilters(self.currentTab)
end

local function GetCurrentMailData(self)
  if not self.currentMailUid then
    return
  end
  return self:GetOneMailByUid(self.currentMailUid)
end

local function GetOneMailByUid(self, mail_uid)
  local mailData = DataCenter.MailDataManager:GetMailInfoById(mail_uid)
  if mailData == nil then
    MailPrint("mail not found ?" .. mail_uid)
  end
  return mailData
end

local function JudgeRewardByGroup(self, cb)
  if self.currentView == 0 then
    return
  elseif self.currentView == 1 then
    return
  elseif self.currentView == 2 then
    if self.currentTab == 0 then
      return
    end
    self:JudgeRewardByOneGroup(self.currentTab, cb)
  end
end

local function JudgeRewardByOneGroup(self, tab, cb)
  local list = DataCenter.MailDataManager:GetGroupMailList(tab)
  for i = 1, #list do
    if list[i].rewardStatus == 0 and list[i].type ~= MailType.CANT_CLAIM_ALL and list[i].type ~= MailType.Automatic_TranslationRating and list[i].type ~= MailType.TranslationRating then
      cb(true)
      return
    end
  end
  DataCenter.MailDataManager.DB:GetAllCanRewardMailUids(tab, function(uids)
    if 0 < #uids then
      cb(true)
    end
  end)
  return
end

local function GetUnReadMailCountByGroup(self, tab)
  return DataCenter.MailDataManager:GetMailUnReadCountByGroup(tab)
end

local function GetUnRewardMailCountByGroup(self, tab)
  return DataCenter.MailDataManager:GetMailUnRewardCountByGroup(tab)
end

local function ReadMailByGroup(self)
  if self.currentView == 0 then
    return
  elseif self.currentView == 1 then
    for _, tab in ipairs(MailShowGroup) do
      DataCenter.MailDataManager:ReadAndRewardGroupMail(tab)
    end
  elseif self.currentView == 2 then
    if self.currentTab == 0 then
      return
    end
    DataCenter.MailDataManager:ReadAndRewardGroupMail(self.currentTab)
  end
end

local function DeleteMailByGroup(self)
  if self.currentTab == 0 then
    return
  end
  DataCenter.MailDataManager:DeleteGroupMail(self.currentTab)
end

local function ReadCurrentMail(self)
  if not self.currentMailUid then
    return
  end
  return self:ReadOneMail(self.currentMailUid)
end

local function ReadOneMail(self, mail_uid)
  if string.IsNullOrEmpty(mail_uid) then
    return
  end
  DataCenter.MailDataManager:ReadMail(mail_uid)
end

local function ReceiveCurrentMail(self)
  if not self.currentMailUid then
    return
  end
  return self:ReceiveOneMail(self.currentMailUid)
end

local function ReceiveOneMail(self, mail_uid)
  if string.IsNullOrEmpty(mail_uid) then
    return
  end
  DataCenter.MailDataManager:RewardMail(mail_uid)
end

local function DeleteCurrentMail(self)
  if not self.currentMailUid then
    return
  end
  return self:DeleteOneMail(self.currentMailUid)
end

local function DeleteOneMail(self, mail_uid)
  if string.IsNullOrEmpty(mail_uid) then
    return
  end
  DataCenter.MailDataManager:DeleteMail(mail_uid)
end

local function CollectCurrentMail(self)
  if not self.currentMailUid then
    return
  end
  return self:CollectOneMail(self.currentMailUid)
end

local function CollectOneMail(self, mail_uid)
  local mailData = self:GetOneMailByUid(mail_uid)
  if not mailData then
    return
  end
  if mailData.saveFlag and mailData.saveFlag == 1 then
    UIUtil.ShowTipsId(310111)
    return
  end
  DataCenter.MailDataManager:SetFavor(mail_uid)
end

local function CancelFavor(self)
  if not self.currentMailUid then
    return
  end
  local mailData = DataCenter.MailDataManager:GetMailInfoById(self.currentMailUid)
  if mailData.saveFlag and mailData.saveFlag == 0 then
    UIUtil.ShowTips("mail_tips_10002")
    return
  end
  if mailData:IsMailOutOfDate() then
    UIUtil.ShowMessage(Localization:GetString("mail_tips_10003"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      DataCenter.MailDataManager:CancelFavor(self.currentMailUid)
    end, function()
    end)
  else
    DataCenter.MailDataManager:CancelFavor(self.currentMailUid)
  end
end

local function OnJumpClick(self, x, y, serverId)
  if not SceneUtils.CheckCanGotoWorld() then
    return
  end
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local curServerId = LuaEntry.Player:GetCurServerId()
  local loginServerId = LuaEntry.Player:GetSelfServerId()
  local gotoServerId = curServerId
  local isDragon = BattleFieldUtil.InBattleField()
  if serverId and 0 < serverId then
    if isDragon then
      if curServerId ~= serverId then
        UIUtil.ShowTipsId(500018)
        return
      end
    elseif curServerId ~= serverId and serverId ~= loginServerId then
      local isBigMapMode, curSameGroup, srcSameGroup, loginSameGroup = SeasonUtil.InSeasonBigMapMode(serverId)
      if isBigMapMode and (loginSameGroup or curSameGroup) then
        gotoServerId = serverId
      else
        UIUtil.ShowTipsId(500018)
        return
      end
    else
      gotoServerId = serverId
    end
  end
  if CS.SceneManager.World == nil then
    UIUtil.ShowTipsId("alliance_train_tips03")
    return
  end
  local v2 = CS.UnityEngine.Vector2Int(x, y)
  local posIndex = SceneUtils.TilePosToIndex(v2, ForceChangeScene.World)
  self:CloseSelf()
  GoToUtil.CloseAllWindows()
  if isDragon then
    GoToUtil.GotoDragonPos(SceneUtils.TileIndexToWorld(posIndex, ForceChangeScene.World), CS.SceneManager.World.InitZoom)
  else
    local v3 = SceneUtils.TileIndexToWorld(posIndex, ForceChangeScene.World)
    GoToUtil.GotoWorldPos(v3, CS.SceneManager.World.InitZoom, nil, nil, gotoServerId)
  end
end

local function SetMusterSoloMailData(self, musterSoloData)
  self.musterSoloData = musterSoloData
end

local function GetMusterSoloMailData(self)
  return self.musterSoloData
end

local function IsCurTemp(self)
  if self.currentMailUid then
    return DataCenter.MailDataManager:IsShare(self.currentMailUid)
  else
    return false
  end
end

function UILWMailMainCtrl:KickAllInactiveMembers()
  if self.currentMailUid ~= nil then
    DataCenter.MailDataManager:KickAllInactiveMembers(self.currentMailUid)
  end
end

function UILWMailMainCtrl:FormatCoordinateText(pos, _serverId)
  local serverId = toInt(_serverId)
  if 0 < serverId then
    return string.format("#%s(X:%s,Y:%s)", serverId, pos.x, pos.y)
  else
    return string.format("X:%s,Y:%s", pos.x, pos.y)
  end
end

function UILWMailMainCtrl:JudgeMailTranslate()
  local mailData = self:GetCurrentMailData()
  local translationMsg = mailData.translateMsg
  local istranslating = mailData:IsTranslating()
  if istranslating then
    return MailTranslateOpEnum.Doing
  elseif not istranslating and not string.IsNullOrEmpty(translationMsg) then
    return MailTranslateOpEnum.Finish
  elseif not string.IsNullOrEmpty(mailData.contents) and not istranslating and string.IsNullOrEmpty(translationMsg) then
    return MailTranslateOpEnum.Can
  else
    return MailTranslateOpEnum.Cant
  end
end

function UILWMailMainCtrl:DoTranslate(mailData)
  local Translate = DataCenter.MailDataManager.Translate
  local roomGroupType
  if mailData.type == MailType.MAIL_PRESIDENT_SEND then
    roomGroupType = FakeChatGroupType.Fake_GROUP_ALLIANCE_NOTICE
  end
  Translate:Translate(mailData, Translate.TranslateEnum.Mail, roomGroupType)
end

function UILWMailMainCtrl:SetVirtualBattleReportMailShowMark(show)
  self.convertBattleReportToVirtualMailShow = show
end

UILWMailMainCtrl.IsCurTemp = IsCurTemp
UILWMailMainCtrl.SetMusterSoloMailData = SetMusterSoloMailData
UILWMailMainCtrl.GetMusterSoloMailData = GetMusterSoloMailData
UILWMailMainCtrl.CloseSelf = CloseSelf
UILWMailMainCtrl.InitData = InitData
UILWMailMainCtrl.ClearData = ClearData
UILWMailMainCtrl.SetCurrentView = SetCurrentView
UILWMailMainCtrl.GetCurrentView = GetCurrentView
UILWMailMainCtrl.SetCurrentTab = SetCurrentTab
UILWMailMainCtrl.GetCurrentTab = GetCurrentTab
UILWMailMainCtrl.SetCurrentMail = SetCurrentMail
UILWMailMainCtrl.GetCurrentMail = GetCurrentMail
UILWMailMainCtrl.GetCurrentMailListByType = GetCurrentMailListByType
UILWMailMainCtrl.GetCurrentUIMailListByType = GetCurrentUIMailListByType
UILWMailMainCtrl.ClearGroupShowIndex = ClearGroupShowIndex
UILWMailMainCtrl.PullMoreGroupUIData = PullMoreGroupUIData
UILWMailMainCtrl.GetMailGroupFilters = GetMailGroupFilters
UILWMailMainCtrl.GetOneMailByUid = GetOneMailByUid
UILWMailMainCtrl.ReadMailByGroup = ReadMailByGroup
UILWMailMainCtrl.DeleteMailByGroup = DeleteMailByGroup
UILWMailMainCtrl.ReadOneMail = ReadOneMail
UILWMailMainCtrl.DeleteOneMail = DeleteOneMail
UILWMailMainCtrl.CollectOneMail = CollectOneMail
UILWMailMainCtrl.CancelFavor = CancelFavor
UILWMailMainCtrl.JudgeRewardByGroup = JudgeRewardByGroup
UILWMailMainCtrl.JudgeRewardByOneGroup = JudgeRewardByOneGroup
UILWMailMainCtrl.GetUnReadMailCountByGroup = GetUnReadMailCountByGroup
UILWMailMainCtrl.GetUnRewardMailCountByGroup = GetUnRewardMailCountByGroup
UILWMailMainCtrl.GetCurrentMailData = GetCurrentMailData
UILWMailMainCtrl.ReadCurrentMail = ReadCurrentMail
UILWMailMainCtrl.DeleteCurrentMail = DeleteCurrentMail
UILWMailMainCtrl.CollectCurrentMail = CollectCurrentMail
UILWMailMainCtrl.ReceiveCurrentMail = ReceiveCurrentMail
UILWMailMainCtrl.ReceiveOneMail = ReceiveOneMail
UILWMailMainCtrl.OnJumpClick = OnJumpClick
UILWMailMainCtrl.SetView = SetView
UILWMailMainCtrl.OnCustomKeyCodeEscape = OnCustomKeyCodeEscape
UILWMailMainCtrl.CleanCurrentMailListByType = CleanCurrentMailListByType
UILWMailMainCtrl.MailTranslateOpEnum = MailTranslateOpEnum
return UILWMailMainCtrl
