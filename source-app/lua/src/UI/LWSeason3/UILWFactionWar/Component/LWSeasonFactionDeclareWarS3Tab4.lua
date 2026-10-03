local base = UIAsyncContainer
local LWSeasonFactionDeclareWarS3Tab4 = BaseClass("LWSeasonFactionDeclareWarS3Tab4", base)
local Localization = CS.GameEntry.Localization
local SeasonFactionWarKillRank = require("UI.LWSeason2.Activity.Component.SeasonFactionWar.SeasonFactionWarKillRank")
local SeasonFactionWarPlayerReward = require("UI.LWSeason2.Activity.Component.SeasonFactionWar.SeasonFactionWarPlayerReward")
local SeasonFactionWarZoneReward = require("UI.LWSeason2.Activity.Component.SeasonFactionWar.SeasonFactionWarZoneReward")
local SeasonFactionWarMilitaryCenter = require("UI.LWSeason3.UILWFactionWar.Component.SeasonFactionWarMilitaryCenter")
local SeasonFactionWarAliList = require("UI.LWSeason2.Activity.Component.SeasonFactionWar.SeasonFactionWarAliList")
local InviteItem = require("UI.LWSeason2.Activity.Component.SeasonFactionWar.SeasonFactionWarInviteItem")
local empty_root_path = "EmptyBg"
local empty_path = "EmptyBg/Empty"
local battle_root_path = "BattleRoot"
local bg_path = "BattleRoot/Viewport/Content/VsRoot/Bg/bg"
local title_path = "BattleRoot/Viewport/Content/VsRoot/Title"
local time_text_path = "BattleRoot/Viewport/Content/VsRoot/TimeText"
local info_btn_path = "BattleRoot/Viewport/Content/VsRoot/InfoBtn"
local icon1_path = "BattleRoot/Viewport/Content/VsRoot/icon1"
local icon2_path = "BattleRoot/Viewport/Content/VsRoot/icon2"
local win_lost1_path = "BattleRoot/Viewport/Content/VsRoot/icon1/winLost1"
local win_lost2_path = "BattleRoot/Viewport/Content/VsRoot/icon2/winLost2"
local faction_war_ali_list_path = "BattleRoot/Viewport/Content/FactionWarAliList"
local stove_center_path = "BattleRoot/Viewport/Content/MilitaryCenter"
local zone_reward_info_path = "BattleRoot/Viewport/Content/ZoneRewardInfo"
local kill_rank_path = "BattleRoot/Viewport/Content/KillRank"
local player_reward_info_path = "BattleRoot/Viewport/Content/PlayerRewardInfo"
local invite_root_path = "InviteRoot"
local invite_content_path = "InviteRoot/Viewport/InviteContent"
local invite_item_path = "InviteRoot/Viewport/InviteContent/InviteItem"
local bg_top_path = "BgTop"
local top_bg_path = "BgTop/top_bg"
local top_time_text_path = "BgTop/top_TimeText"
local top_title_path = "BgTop/top_Title"
local top_info_btn_path = "BgTop/top_InfoBtn"
local explain_btn_path = "BgTop/explainBtn"

function LWSeasonFactionDeclareWarS3Tab4:OnCreate()
  base.OnCreate(self)
  self.rectTransform:Set_offsetMin(7, 10)
  self.rectTransform:Set_offsetMax(-7, 0)
  self.explain_btn = self:AddComponent(UIButton, explain_btn_path)
  self.explain_btn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonFactionWarRule, {anim = true}, "DeclareWarTime")
  end)
  self.bg_top = self:AddComponent(UIBaseContainer, bg_top_path)
  self.top_bg = self:AddComponent(UIRawImage, top_bg_path)
  self.top_time_text = self:AddComponent(UITextMeshProUGUIEx, top_time_text_path)
  self.top_title = self:AddComponent(UITextMeshProUGUIEx, top_title_path)
  self.top_info_btn = self:AddComponent(UIButton, top_info_btn_path)
  self.top_info_btn:SetOnClick(function()
    UIUtil.ShowDetail(Localization:GetString("season_s2_faction_war_tips_02"), nil, nil, true)
  end)
  self.bg = self:AddComponent(UIRawImage, bg_path)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.info_btn:SetOnClick(function()
    UIUtil.ShowDetail(Localization:GetString("season_s2_faction_war_tips_02"), nil, nil, true)
  end)
  self.emptyRoot = self:AddComponent(UIImage, empty_root_path)
  self.emptyTxt = self:AddComponent(UITextMeshProUGUIEx, empty_path)
  self.title = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self.time_text = self:AddComponent(UITextMeshProUGUIEx, time_text_path)
  self.battleRoot = self:AddComponent(UIImage, battle_root_path)
  self.icon1 = self:AddComponent(UIImage, icon1_path)
  self.icon2 = self:AddComponent(UIImage, icon2_path)
  self.win_lost1 = self:AddComponent(UIImage, win_lost1_path)
  self.win_lost2 = self:AddComponent(UIImage, win_lost2_path)
  self.faction_war_ali_list = self:AddComponent(SeasonFactionWarAliList, faction_war_ali_list_path)
  self.stove_center = self:AddComponent(SeasonFactionWarMilitaryCenter, stove_center_path)
  self.zone_reward_info = self:AddComponent(SeasonFactionWarZoneReward, zone_reward_info_path)
  self.kill_rank = self:AddComponent(SeasonFactionWarKillRank, kill_rank_path)
  self.player_reward_info = self:AddComponent(SeasonFactionWarPlayerReward, player_reward_info_path)
  self.inviteRoot = self:AddComponent(UIImage, invite_root_path)
  self.theInviteItem = self.transform:Find(invite_item_path).gameObject
  self.theInviteItem:GameObjectCreatePool()
  self.inviteContent = self:AddComponent(UIBaseContainer, invite_content_path)
  self.top_bg:SetFlipX(DataCenter.SeasonFactionWarDataManager:CampIsAttacker(2))
  self.bg:SetFlipX(DataCenter.SeasonFactionWarDataManager:CampIsAttacker(2))
end

function LWSeasonFactionDeclareWarS3Tab4:OnDestroy()
  self.inviteContent:RemoveComponents(InviteItem)
  self.theInviteItem:GameObjectRecycleAll()
  self.title = nil
  self.time_text = nil
  self.battleRoot = nil
  self.icon1 = nil
  self.win_lost1 = nil
  self.icon2 = nil
  self.win_lost2 = nil
  self.faction_war_ali_list = nil
  self.emptyTxt = nil
  self.stove_center = nil
  self.zone_reward_info = nil
  self.kill_rank = nil
  self.player_reward_info = nil
  self.bg_top = nil
  self.top_bg = nil
  self.top_time_text = nil
  self.top_title = nil
  self.top_info_btn = nil
  base.OnDestroy(self)
end

function LWSeasonFactionDeclareWarS3Tab4:OnEnable()
  base.OnEnable(self)
end

function LWSeasonFactionDeclareWarS3Tab4:OnDisable()
  base.OnDisable(self)
end

function LWSeasonFactionDeclareWarS3Tab4:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonFactionWarDetailUpdate, self.OnDeclareInfoUpdate)
end

function LWSeasonFactionDeclareWarS3Tab4:OnRemoveListener()
  self:RemoveUIListener(EventId.LWSeasonFactionWarDetailUpdate, self.OnDeclareInfoUpdate)
  base.OnRemoveListener(self)
end

function LWSeasonFactionDeclareWarS3Tab4:UpdateData()
  if IsNull(self.gameObject) then
    return
  end
  self:OnDeclareInfoUpdate()
end

function LWSeasonFactionDeclareWarS3Tab4:OnDeclareInfoUpdate()
  local mgr = DataCenter.SeasonFactionWarDataManager
  local actInfo = mgr:GetDeclareWarActInfo()
  if actInfo then
    self.currStep = actInfo.currStep
    self.stepEndTime = actInfo.stepEndTime
    self.round = actInfo.round
    self.isEnd = actInfo.isEnd
    self.win_lost1:SetActive(false)
    self.win_lost2:SetActive(false)
    local prefix = Localization:GetString("312094", actInfo.round or 1)
    local title = Localization:GetString(mgr.StepText[self.currStep + 1] or "season_s2_faction_war_01")
    self.title:SetText(title)
    self.top_title:SetText(title)
    self:Update1000MS()
  end
  local warInfo = mgr.warInfo
  if warInfo == nil then
    self.bg_top:SetActive(true)
    self.battleRoot:SetActive(false)
    self.inviteRoot:SetActive(false)
    self.emptyTxt:SetActive(true)
    self.emptyRoot:SetActive(true)
    self.emptyTxt:SetLocalText("season_s2_faction_war_93")
    return
  end
  if warInfo.battleEndTime and self.currStep == SeasonFactionDeclareWarStep.battle then
    self.stepEndTime = warInfo.battleEndTime
    self:Update1000MS()
  end
  if warInfo.vsInfo and warInfo.s3BuildInfo and warInfo.vsInfo.defence and warInfo.vsInfo.attack then
    local warServerId = warInfo.s3BuildInfo.allianceServer
    local warPointId = warInfo.s3BuildInfo.pointId
    local warAllianceId = warInfo.targetAllianceId or warInfo.s3BuildInfo.allianceId
    self.battleRoot:SetActive(true)
    self.bg_top:SetActive(false)
    self.inviteRoot:SetActive(false)
    self.emptyTxt:SetActive(false)
    self.emptyRoot:SetActive(false)
    if mgr:CampIsAttacker(1) then
      self.icon1:LoadSprite(mgr:GetCampIcon(2, true))
      self.icon2:LoadSprite(mgr:GetCampIcon(1, true))
    else
      self.icon1:LoadSprite(mgr:GetCampIcon(1, true))
      self.icon2:LoadSprite(mgr:GetCampIcon(2, true))
    end
    self.faction_war_ali_list:SetAutoSizeEnable(true)
    self.faction_war_ali_list:CanShowInviteWhenEmpty(self.currStep == SeasonFactionDeclareWarStep.invite)
    self.faction_war_ali_list:ReInit(warInfo.vsInfo.defence, warInfo.vsInfo.attack, warServerId, warAllianceId)
    self.faction_war_ali_list:UpdateResChangeInfo(warInfo.alResChangeInfo)
    if self.currStep > SeasonFactionDeclareWarStep.invite then
      self.faction_war_ali_list:HideEmpty()
    end
    if self.currStep == SeasonFactionDeclareWarStep.invite and warInfo.vsInfo.defence and warInfo.vsInfo.attack and #warInfo.vsInfo.defence == #warInfo.vsInfo.attack then
      local wait_count = 0
      for k, v in ipairs(warInfo.vsInfo.defence) do
        if v and (v.state == 0 or v.state == 1 or v.state == 2) then
          wait_count = wait_count + 1
        end
      end
      if wait_count == 0 then
        self.title:SetLocalText("season_s2_faction_war_preparation")
        self.top_title:SetLocalText("season_s2_faction_war_preparation")
      end
    end
    local fightResult = toInt(warInfo.result or 0)
    if fightResult == 1 or fightResult == 2 then
      self.win_lost1:SetActive(true)
      self.win_lost2:SetActive(true)
      if fightResult == 1 then
        self.win_lost1:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason2/FactionDeclareWar/mjc_xituzhengdui_jiesuan_shengli.png")
        self.win_lost2:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason2/FactionDeclareWar/mjc_xituzhengdui_jiesuan_shibai.png")
      else
        self.win_lost1:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason2/FactionDeclareWar/mjc_xituzhengdui_jiesuan_shibai.png")
        self.win_lost2:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason2/FactionDeclareWar/mjc_xituzhengdui_jiesuan_shengli.png")
      end
    else
      self.win_lost1:SetActive(false)
      self.win_lost2:SetActive(false)
    end
    if warInfo.s3BuildInfo then
      self.stove_center:SetActive(true)
      self.stove_center:ReInit(warInfo.vsInfo, warInfo.s3BuildInfo, warInfo.furnaceChangeInfo, warInfo.s3lootNumChangeObj, fightResult)
      self.stove_center:UpdateResChangeInfo(warInfo.alResChangeInfo)
    else
      self.stove_center:SetActive(false)
    end
    if warInfo.scoreInfo then
      self.zone_reward_info:SetActive(true)
      self.kill_rank:SetActive(warInfo.rank1 ~= nil)
      self.player_reward_info:SetActive(true)
      self.zone_reward_info:ReInit(warInfo.scoreInfo, fightResult)
      self.kill_rank:ReInit(warInfo.rank1)
      self.player_reward_info:ReInit(warInfo.scoreInfo)
    else
      self.zone_reward_info:SetActive(false)
      self.kill_rank:SetActive(false)
      self.player_reward_info:SetActive(false)
    end
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.battleRoot.rectTransform)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
  elseif warInfo.inviteList and 0 < table.count(warInfo.inviteList) then
    local goItem, theItem
    self.bg_top:SetActive(true)
    self.emptyRoot:SetActive(false)
    self.inviteRoot:SetActive(true)
    self.battleRoot:SetActive(false)
    self.emptyTxt:SetActive(false)
    self.inviteContent:RemoveComponents(InviteItem)
    self.theInviteItem:GameObjectRecycleAll()
    for i, inviteInfo in ipairs(warInfo.inviteList) do
      goItem = self.theInviteItem:GameObjectSpawn(self.inviteContent.transform)
      goItem.name = "invite_" .. i
      goItem:SetActive(true)
      theItem = self.inviteContent:AddComponent(InviteItem, goItem.name)
      theItem:ReInit(inviteInfo)
    end
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.inviteRoot.rectTransform)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
  else
    self.bg_top:SetActive(true)
    self.emptyRoot:SetActive(true)
    self.emptyTxt:SetActive(true)
    self.battleRoot:SetActive(false)
    self.inviteRoot:SetActive(false)
    if self.currStep == SeasonFactionDeclareWarStep.battle_after then
      self.emptyTxt:SetText(Localization:GetString("2000223") .. "\n" .. Localization:GetString("800933"))
    else
      self.emptyTxt:SetLocalText("season_s2_faction_war_93")
    end
  end
end

function LWSeasonFactionDeclareWarS3Tab4:Update1000MS()
  if self.stepEndTime then
    local deltaTime = 0
    local curTime = UITimeManager:GetInstance():GetServerTime()
    deltaTime = self.stepEndTime - curTime
    if 0 < deltaTime then
      local showTime = UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime)
      self.time_text:SetText(showTime)
      self.top_time_text:SetText(showTime)
    else
      self.time_text:SetText("")
      self.top_time_text:SetText("")
      if self.currStep == SeasonFactionDeclareWarStep.battle then
        self.title:SetLocalText("season_s2_faction_war_12")
        self.top_title:SetLocalText("season_s2_faction_war_12")
      end
      if self.lastRequest == nil or curTime - self.lastRequest > 3456 then
        SFSNetwork.SendMessage(MsgDefines.FetchSeasonFactionWarVsInfo)
        self.lastRequest = curTime
      end
    end
  end
end

return LWSeasonFactionDeclareWarS3Tab4
