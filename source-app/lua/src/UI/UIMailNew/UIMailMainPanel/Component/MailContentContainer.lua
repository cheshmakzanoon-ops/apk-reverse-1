local MailContentContainer = BaseClass("MailContentContainer", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local MailSystem = require("UI.UIMailNew.UIMailMainPanel.Component.MailTypeContent.MailSystem")
local MailCollect = require("UI.UIMailNew.UIMailMainPanel.Component.MailTypeContent.CollectType.MailCollect")
local MailBossReward = require("UI.UIMailNew.UIMailMainPanel.Component.MailTypeContent.MailBossRewardView")
local MailBattleReportViewNew = require("UI.UIMailNew.UIMailMainPanel.Component.MailTypeContent.MailBattleReportNewView")
local MailScoutResult = require("UI.UIMailNew.UIMailMainPanel.Component.MailTypeContent.MailScoutResult")
local MailResSupport = require("UI.UIMailNew.UIMailMainPanel.Component.MailTypeContent.MailResSupport")
local MailResSupportFail = require("UI.UIMailNew.UIMailMainPanel.Component.MailTypeContent.MailResSupportFail")
local MailAlCompeteWeekResult = require("UI.UIMailNew.UIMailMainPanel.Component.MailTypeContent.MailAlCompeteWeekReport")
local Explore = require("UI.UIMailNew.UIMailMainPanel.Component.MailTypeContent.Explore.ExploreView")
local PickGarbage = require("UI.UIMailNew.UIMailMainPanel.Component.MailTypeContent.PickGarbage.PickGarbageView")
local MailAllianceMark = require("UI.UIMailNew.UIMailMainPanel.Component.MailTypeContent.MailAllianceMark")
local AlLeaderElect = require("UI.UIMailNew.UIMailMainPanel.Component.MailTypeContent.AlLeaderElect.MailAlLeaderElect")
local AlLeaderChange = require("UI.UIMailNew.UIMailMainPanel.Component.MailTypeContent.AlLeaderElect.MailAlLeaderChange")
local AlLeaderVote = require("UI.UIMailNew.UIMailMainPanel.Component.MailTypeContent.AlLeaderElect.MailAlLeaderVote")
local AlCommonMail = require("UI.UIMailNew.UIMailMainPanel.Component.MailTypeContent.AlLeaderElect.MailAllianceCommon")
local MailMonsterReward = require("UI.UIMailNew.UIMailMainPanel.Component.MailTypeContent.MonsterReward.MailMonsterReward")
local AlElectResult = require("UI.UIMailNew.UIMailMainPanel.Component.MailTypeContent.AlElect.MailAlElectResult")
local MailDestroyBuild = require("UI.UIMailNew.UIMailMainPanel.Component.MailTypeContent.MailDestroyBuild")
local MailDestroyRankList = require("UI.UIMailNew.UIMailMainPanel.Component.MailTypeContent.MailDestroyRankList")
local MailAllianceInvite = require("UI.UIMailNew.UIMailMainPanel.Component.MailTypeContent.AllianceInvite.MailAllianceInvite")
local _cp_scrollContent = ""
local eMailConfigType = {
  System_Type = 1,
  BattleReport = 2,
  Collect_Type = 3,
  BossReward_Type = 4,
  ScoutResult_Type = 5,
  AlCompeteWeekReport_Type = 6,
  PickGarbage_Type = 7,
  Explore_Type = 8,
  ResourceHelpFrom_Type = 9,
  ResourceHelpTo_Type = 10,
  ResourceHelpFail_Type = 11,
  AllianceMarkAdd_Type = 12,
  AlLeaderElect = 13,
  AlLeaderVote = 14,
  AlCommonMail = 15,
  AlLeaderChange = 16,
  MonsterReward_Type = 17,
  DestroyBuild_Type = 18,
  AllianceDestroyRankList = 19,
  AlElectResult = 20,
  AllianceInvite = 21
}
local eMailConfig = {
  [eMailConfigType.System_Type] = {
    Prefab = "Assets/Main/Prefabs/UI/Mail/ObjMail/MailSystem.prefab",
    Script = MailSystem
  },
  [eMailConfigType.Collect_Type] = {
    Prefab = "Assets/Main/Prefabs/UI/Mail/ObjMail/MailCollect.prefab",
    Script = MailCollect
  },
  [eMailConfigType.BossReward_Type] = {
    Prefab = "Assets/Main/Prefabs/UI/Mail/ObjMail/MailSystem.prefab",
    Script = MailSystem
  },
  [eMailConfigType.BattleReport] = {
    Prefab = "Assets/Main/Prefabs/UI/Mail/ObjMail/MailBattleReportNew.prefab",
    Script = MailBattleReportViewNew
  },
  [eMailConfigType.ScoutResult_Type] = {
    Prefab = "Assets/Main/Prefabs/UI/Mail/ObjMail/MailScoutResult.prefab",
    Script = MailScoutResult
  },
  [eMailConfigType.AlCompeteWeekReport_Type] = {
    Prefab = "Assets/Main/Prefabs/UI/Mail/ObjMail/MailAlCompeteWeekReport.prefab",
    Script = MailAlCompeteWeekResult
  },
  [eMailConfigType.PickGarbage_Type] = {
    Prefab = "Assets/Main/Prefabs/UI/Mail/ObjMail/PickGarbage.prefab",
    Script = PickGarbage
  },
  [eMailConfigType.Explore_Type] = {
    Prefab = "Assets/Main/Prefabs/UI/Mail/ObjMail/Explore.prefab",
    Script = Explore
  },
  [eMailConfigType.ResourceHelpFrom_Type] = {
    Prefab = "Assets/Main/Prefabs/UI/Mail/ObjMail/MailResSupport.prefab",
    Script = MailResSupport
  },
  [eMailConfigType.ResourceHelpTo_Type] = {
    Prefab = "Assets/Main/Prefabs/UI/Mail/ObjMail/MailResSupport.prefab",
    Script = MailResSupport
  },
  [eMailConfigType.ResourceHelpFail_Type] = {
    Prefab = "Assets/Main/Prefabs/UI/Mail/ObjMail/MailResSupportFail.prefab",
    Script = MailResSupportFail
  },
  [eMailConfigType.AllianceMarkAdd_Type] = {
    Prefab = "Assets/Main/Prefabs/UI/Mail/ObjMail/MailAllianceMark.prefab",
    Script = MailAllianceMark
  },
  [eMailConfigType.AlLeaderElect] = {
    Prefab = "Assets/Main/Prefabs/UI/Mail/ObjMail/AlLeaderElect/MailAlLeaderElect.prefab",
    Script = AlLeaderElect
  },
  [eMailConfigType.AlLeaderChange] = {
    Prefab = "Assets/Main/Prefabs/UI/Mail/ObjMail/AlLeaderElect/MailAlLeaderChange.prefab",
    Script = AlLeaderChange
  },
  [eMailConfigType.AlElectResult] = {
    Prefab = "Assets/Main/Prefabs/UI/Mail/ObjMail/AlElect/MailAlLeaderElectResult.prefab",
    Script = AlElectResult
  },
  [eMailConfigType.AlLeaderVote] = {
    Prefab = "Assets/Main/Prefabs/UI/Mail/ObjMail/AlLeaderElect/MailAlLeaderVote.prefab",
    Script = AlLeaderVote
  },
  [eMailConfigType.AlCommonMail] = {
    Prefab = "Assets/Main/Prefabs/UI/Mail/ObjMail/AlLeaderElect/MailAlCommon.prefab",
    Script = AlCommonMail
  },
  [eMailConfigType.MonsterReward_Type] = {
    Prefab = "Assets/Main/Prefabs/UI/Mail/ObjMail/MailMonsterReward.prefab",
    Script = MailMonsterReward
  },
  [eMailConfigType.DestroyBuild_Type] = {
    Prefab = "Assets/Main/Prefabs/UI/Mail/ObjMail/MailDestroyBuild.prefab",
    Script = MailDestroyBuild
  },
  [eMailConfigType.AllianceDestroyRankList] = {
    Prefab = "Assets/Main/Prefabs/UI/Mail/ObjMail/MailDestroyRankList.prefab",
    Script = MailDestroyRankList
  },
  [eMailConfigType.AllianceInvite] = {
    Prefab = "Assets/Main/Prefabs/UI/Mail/ObjMail/AllianceInvite/MailAllianceInvite.prefab",
    Script = MailAllianceInvite
  }
}

function MailContentContainer:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self._scrollContent = self:AddComponent(UIBaseContainer, _cp_scrollContent)
end

function MailContentContainer:DataDefine()
  self._reqlist = {}
end

function MailContentContainer:ShowData(maildata, showReplay, jumpType)
  self:RecycleAll()
  if maildata == nil then
    return false
  end
  local mailType = maildata.type
  local mailConfigType = -1
  if mailType == MailType.NEW_FIGHT then
    mailConfigType = eMailConfigType.BattleReport
  elseif mailType == MailType.ELITE_FIGHT_MAIL then
    mailConfigType = eMailConfigType.BattleReport
  elseif mailType == MailType.NEW_COLLECT_MAIL then
    mailConfigType = eMailConfigType.Collect_Type
  elseif mailType == MailType.MAIL_BOSS_REWARD then
    mailConfigType = eMailConfigType.BossReward_Type
  elseif mailType == MailType.MAIL_SCOUT_RESULT or mailType == MailType.LW_SEASON_SCOUT_MAIL then
    mailConfigType = eMailConfigType.ScoutResult_Type
  elseif mailType == MailType.RESOURCE_HELP_FROM then
    mailConfigType = eMailConfigType.ResourceHelpFrom_Type
  elseif mailType == MailType.RESOURCE_HELP_TO then
    mailConfigType = eMailConfigType.ResourceHelpTo_Type
  elseif mailType == MailType.RESOURCE_HELP_FAIL then
    mailConfigType = eMailConfigType.ResourceHelpFail_Type
  elseif mailType == MailType.MAIL_ALCOMPETE_WEEK_REPORT then
    mailConfigType = eMailConfigType.AlCompeteWeekReport_Type
  elseif mailType == MailType.MAIL_PICK_GARBAGE then
    mailConfigType = eMailConfigType.PickGarbage_Type
  elseif mailType == MailType.MAIL_EXPLORE then
    mailConfigType = eMailConfigType.Explore_Type
  elseif mailType == MailType.MAIL_ALLIANCE_MARK_ADD then
    mailConfigType = eMailConfigType.AllianceMarkAdd_Type
  elseif mailType == MailType.MAIL_AL_LEADER_ELECT then
    mailConfigType = eMailConfigType.AlLeaderElect
  elseif mailType == MailType.MAIL_AL_LEADER_VOTE then
    mailConfigType = eMailConfigType.AlLeaderVote
  elseif mailType == MailType.MAIL_AL_LEADER_CHANGE then
    mailConfigType = eMailConfigType.AlLeaderChange
  elseif mailType == MailType.MAIL_AL_ELECT_RESULT_R4 then
    mailConfigType = eMailConfigType.AlElectResult
  elseif mailType == MailType.MAIL_AL_ELECT_RESULT_LEADER then
    mailConfigType = eMailConfigType.AlElectResult
  elseif mailType == MailType.MAIL_GOLLOES_TRADE_REWARDS then
    mailConfigType = eMailConfigType.System_Type
  elseif mailType == MailType.MAIL_AL_AL_COMMON then
    mailConfigType = eMailConfigType.AlCommonMail
  elseif mailType == MailType.MONSTER_COLLECT_REWARD then
    mailConfigType = eMailConfigType.MonsterReward_Type
  elseif mailType == MailType.MARCH_DESTROY_MAIL then
    mailConfigType = eMailConfigType.DestroyBuild_Type
  elseif mailType == MailType.ALLIANCE_CITY_RANK then
    mailConfigType = eMailConfigType.AllianceDestroyRankList
  elseif mailType == MailType.MAIL_ALLIANCE_INVITE then
    mailConfigType = eMailConfigType.AllianceInvite
  else
    mailConfigType = eMailConfigType.System_Type
  end
  if mailConfigType == -1 then
    assert("error no prefabpath mailtype: " .. tostring(mailType))
    return false
  end
  self:ShowContent(maildata, mailConfigType, showReplay, jumpType)
  return true
end

function MailContentContainer:ShowContent(maildata, configType, showReplay, jumpType)
  self:RecycleAll()
  local _mailConfig = eMailConfig[configType]
  if _mailConfig == nil then
    return
  end
  local req = self:GameObjectInstantiateAsync(_mailConfig.Prefab, function(request)
    self:onCreateRoom(request, maildata, configType, showReplay, jumpType)
  end)
  self._reqlist[#self._reqlist + 1] = req
end

function MailContentContainer:OnDestroy()
  self:RecycleAll()
end

function MailContentContainer:RecycleAll()
  for k, v in pairs(self._reqlist) do
    if v ~= nil then
      self:GameObjectDestroy(v)
    end
  end
  self._reqlist = {}
  for _, config in pairs(eMailConfig) do
    local component = config.Script
    self._scrollContent:RemoveComponents(component)
  end
end

function MailContentContainer:onCreateRoom(request, maildata, configType, showReplay, jumpType)
  if request.isError then
    return
  end
  local _mailConfig = eMailConfig[configType]
  local prefabName = PathUtil.GetFileNameWithoutExtension(_mailConfig.Prefab)
  local ObjScript = _mailConfig.Script
  local go = request.gameObject
  go.transform:SetParent(self._scrollContent.transform)
  go.transform:SetAsLastSibling()
  go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
  NameCount = NameCount + 1
  go.name = prefabName .. "..." .. NameCount
  local temp = self._scrollContent:AddComponent(ObjScript, go.name)
  go:SetActive(true)
  temp:setData(maildata, showReplay, jumpType)
end

return MailContentContainer
