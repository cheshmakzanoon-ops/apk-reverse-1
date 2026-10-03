local NewPeakArenaKOFBattleResultView = BaseClass("NewPeakArenaKOFBattleResultView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local NewPeakArenaKOFBattleResultViewItem = require("UI.NewPeakArenaKOFBattleResult.Component.NewPeakArenaKOFBattleResultViewItem")
local LayoutLayer = "Layout/"
local atk_score_text_path = "Layout/AtkPlayer/AtkPlayerScore/AtkScoreText"
local atk_score_add_text_path = "Layout/AtkPlayer/AtkPlayerScore/AtkScoreAddText"
local atk_player_name_path = "Layout/AtkPlayer/AtkPlayerName"
local atk_player_head_path = "Layout/AtkPlayer/AtkPlayerHead"
local atk_player_blood_cell_path = "Layout/AtkPlayer/AtkPlayerBloodTip/AtkPlayerBloodCell"
local def_score_text_path = "Layout/DefPlayer/DefPlayerScore/DefScoreText"
local def_score_add_text_path = "Layout/DefPlayer/DefPlayerScore/DefScoreAddText"
local def_player_name_path = "Layout/DefPlayer/DefPlayerName"
local def_player_head_path = "Layout/DefPlayer/DefPlayerHead"
local def_player_blood_tip_path = "Layout/DefPlayer/DefPlayerBloodTip"
local def_player_blood_cell_path = "Layout/DefPlayer/DefPlayerBloodTip/DefPlayerBloodCell"
local atk_team_path = "Layout/battleContent/AtkTeam"
local def_team_path = "Layout/battleContent/DefTeam"
local share_btn_path = "Layout/ShareBtn"
local old_rank_path = "Layout/rankChange/oldRank"
local new_rank_path = "Layout/rankChange/newRank"

function NewPeakArenaKOFBattleResultView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function NewPeakArenaKOFBattleResultView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function NewPeakArenaKOFBattleResultView:OnAddListener()
  base.OnAddListener(self)
end

function NewPeakArenaKOFBattleResultView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function NewPeakArenaKOFBattleResultView:ComponentDefine()
  self.backBtn = self:AddComponent(UIButton, LayoutLayer .. "BtnBack")
  self.backBtn:SetOnClick(function()
    self:OnBackBtnClick()
  end)
  self.layout = self:AddComponent(UIBaseContainer, LayoutLayer)
  self.canvasGroup = self.transform:Find(LayoutLayer).gameObject:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
  self.canvasGroup.alpha = 0
  self.victoryGo = self:AddComponent(UIBaseContainer, LayoutLayer .. "Title/VictoryGo")
  self.loseGo = self:AddComponent(UIBaseContainer, LayoutLayer .. "Title/LoseGo")
  self.victoryGo:SetActive(false)
  self.loseGo:SetActive(false)
  self.victoryAllGo = self:AddComponent(UIBaseContainer, LayoutLayer .. "Title/VictoryAllGo")
  self.victoryAllGo:SetActive(false)
  self.victoryAllText = self:AddComponent(UIText, LayoutLayer .. "Title/VictoryAllGo/VictoryAllText")
  self.victoryAllText:SetLocalText("new_arena_tips_90")
  self.victoryAllScoreText = self:AddComponent(UIText, LayoutLayer .. "Title/VictoryAllGo/VictoryAllScoreText")
  self.statisticsBtn = self:AddComponent(UIButton, LayoutLayer .. "StatisticsBtn")
  self.statisticsBtn:SetOnClick(function()
    self:OnStatisticsBtnClick()
  end)
  self.atk_player_name = self:AddComponent(UITextMeshProUGUIEx, atk_player_name_path)
  self.atk_player_head = self:AddComponent(UICommonHead, atk_player_head_path)
  self.def_player_name = self:AddComponent(UITextMeshProUGUIEx, def_player_name_path)
  self.def_player_head = self:AddComponent(UICommonHead, def_player_head_path)
  self.def_player_blood_tip = self:AddComponent(UIImage, def_player_blood_tip_path)
  self.atkPlayerBloodTipCells = {}
  for i = 1, 3 do
    local cell = self:AddComponent(UIImage, atk_player_blood_cell_path .. i)
    cell:SetActive(true)
    table.insert(self.atkPlayerBloodTipCells, cell)
  end
  self.defPlayerBloodTipCells = {}
  for i = 1, 3 do
    local cell = self:AddComponent(UIImage, def_player_blood_cell_path .. i)
    cell:SetActive(true)
    table.insert(self.defPlayerBloodTipCells, cell)
  end
  self.atkTeamItems = {}
  self.defTeamItems = {}
  for i = 1, 3 do
    local atkTeam = self:AddComponent(NewPeakArenaKOFBattleResultViewItem, atk_team_path .. i)
    table.insert(self.atkTeamItems, atkTeam)
    local defTeam = self:AddComponent(NewPeakArenaKOFBattleResultViewItem, def_team_path .. i)
    table.insert(self.defTeamItems, defTeam)
  end
  self.share_btn = self:AddComponent(UIButton, share_btn_path)
  self.share_btn:SetOnClick(function()
    self:OnShareBtnClick()
  end)
  self.atk_score_text = self:AddComponent(UIText, atk_score_text_path)
  self.atk_score_add_text = self:AddComponent(UIText, atk_score_add_text_path)
  self.def_score_text = self:AddComponent(UIText, def_score_text_path)
  self.def_score_add_text = self:AddComponent(UIText, def_score_add_text_path)
  self.old_rank = self:AddComponent(UIText, old_rank_path)
  self.new_rank = self:AddComponent(UIText, new_rank_path)
end

function NewPeakArenaKOFBattleResultView:DataDefine()
  self.NameCount = 1
end

function NewPeakArenaKOFBattleResultView:ComponentDestroy()
  self.atk_player_name = nil
  self.atk_player_head = nil
  self.def_player_name = nil
  self.def_player_head = nil
  self.def_player_blood_tip = nil
  self.atk_score_text = nil
  self.atk_score_add_text = nil
  self.def_score_text = nil
  self.def_score_add_text = nil
  self.old_rank = nil
  self.new_rank = nil
end

function NewPeakArenaKOFBattleResultView:DataDestroy()
  self.atkTeamItems = nil
  self.defTeamItems = nil
  self.battleMsg = nil
  self.finialAtkLoseNoMap = nil
  self.finialDefLoseNoMap = nil
  self.atkKillMap = nil
  self.defKillMap = nil
  self.atkPlayerBloodTipCells = nil
  self.defPlayerBloodTipCells = nil
  self.share_btn = nil
end

function NewPeakArenaKOFBattleResultView:ReInit()
  self.battleMsg, self.finialAtkLoseNoMap, self.finialDefLoseNoMap, self.atkKillMap, self.defKillMap = self:GetUserData()
  if self.battleMsg == nil then
    return
  end
  local isWin = self.battleMsg.isWin
  if isWin then
    self.loseGo:SetActive(false)
    if self.battleMsg.extraAddScore then
      self.victoryGo:SetActive(false)
      self.victoryAllGo:SetActive(true)
      self.victoryAllScoreText:SetLocalText("new_arena_tips_91", self.battleMsg.extraAddScore)
    else
      self.victoryGo:SetActive(true)
      self.victoryAllGo:SetActive(false)
    end
  else
    self.victoryGo:SetActive(false)
    self.loseGo:SetActive(true)
  end
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_stage_win_bgm)
  if self.delay then
    self.delay:Stop()
    self.delay = nil
  end
  self.delay = TimerManager:GetInstance():DelayInvoke(function()
    self.canvasGroup:DOFade(1, 0.2)
  end, 1.5)
  self:RefreshView()
end

function NewPeakArenaKOFBattleResultView:RefreshView()
  self.opponentData = DataCenter.LWKOFBattleManager.opponentData
  if not self.opponentData then
    return
  end
  self.opponentPlayerInfo = self.opponentData.playerInfo
  local headFramePath = DataCenter.DecorationDataManager:GetHeadFrame(self.opponentPlayerInfo.headSkinId, self.opponentPlayerInfo.headSkinET, false)
  self.def_player_head:SetData(self.opponentPlayerInfo.uid, self.opponentPlayerInfo.pic, self.opponentPlayerInfo.picver, nil, headFramePath)
  local name = UIUtil.FormatServerAllianceName(self.opponentPlayerInfo.srcServer, self.opponentPlayerInfo.abbr, self.opponentPlayerInfo.name)
  self.def_player_name:SetText(name)
  self.opponentDefTeams = {}
  for i = 1, 3 do
    local defenceTeam = DataCenter.LWKOFBattleManager:GetOpponentDefenceTeam(i)
    table.insert(self.opponentDefTeams, defenceTeam)
  end
  local selfUid = LuaEntry.Player.uid
  local selfPic = LuaEntry.Player.pic
  local selfPicVer = LuaEntry.Player.picVer
  local headFrame = LuaEntry.Player:GetHeadBgImg()
  self.atk_player_head:SetData(selfUid, selfPic, selfPicVer, nil, headFrame)
  local selfAllianceAbbr
  if not string.IsNullOrEmpty(LuaEntry.Player.allianceId) then
    local data = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    selfAllianceAbbr = data.abbr
  end
  name = UIUtil.FormatServerAllianceName(LuaEntry.Player:GetSourceServerId(), selfAllianceAbbr, LuaEntry.Player.name)
  self.atk_player_name:SetText(name)
  self.atkTeams = {}
  for i = 1, 3 do
    local atkTeam = DataCenter.LWKOFBattleManager:GetAtkTeamByIndex(i)
    table.insert(self.atkTeams, atkTeam)
  end
  for i = 1, 3 do
    local defTeam = self.opponentDefTeams[i]
    local atkTeam = self.atkTeams[i]
    local atkTeamPower = 0
    local defTeamPower = 0
    if atkTeam then
      atkTeamPower = atkTeam:GetTotalCapacity()
    end
    if defTeam then
      defTeamPower = defTeam.power
    end
    if defTeam then
      local heroesUuid = defTeam:GetLocalAllHeroes()
      local heroesData = {}
      for index, uuid in pairs(heroesUuid) do
        local heroData = defTeam:GetHeroDataByUuid(uuid)
        heroesData[index] = heroData
      end
      local dominatorData = defTeam:GetDominatorData()
      if dominatorData then
        heroesData[ArmyFormationSlot.Dominator] = dominatorData
      end
      local teamPowerColor = atkTeamPower <= defTeamPower and "#FF7676" or "#FFFFFF"
      local teamPowerStr = string.format("<color=%s>%s</color>", teamPowerColor, string.GetFormattedStr(defTeamPower))
      local lose = self.finialDefLoseNoMap[i] or false
      local killNum = self.defKillMap[i] or 1
      self.defTeamItems[i]:SetData(heroesData, teamPowerStr, i, killNum)
      self.defTeamItems[i]:SetGray(lose)
    else
      self.defTeamItems[i]:SetData(nil, nil, i)
      self.defTeamItems[i]:SetGray(true)
    end
    if atkTeam then
      local heroesUuid = atkTeam:GetLocalAllHeroes()
      local heroesData = {}
      for index, uuid in pairs(heroesUuid) do
        local heroData = {}
        heroData.heroUuid = uuid
        heroesData[index] = heroData
      end
      local dominatorUuid = atkTeam:GetLocalDominatorUuid()
      if dominatorUuid and 0 < dominatorUuid then
        local heroData = {}
        heroData.heroUuid = dominatorUuid
        heroesData[ArmyFormationSlot.Dominator] = heroData
      end
      local lose = self.finialAtkLoseNoMap[i] or false
      local killNum = self.atkKillMap[i] or 1
      self.atkTeamItems[i]:SetData(heroesData, string.GetFormattedStr(atkTeamPower), i, killNum)
      self.atkTeamItems[i]:SetGray(lose)
    else
      self.atkTeamItems[i]:SetData(nil, nil, i)
      self.atkTeamItems[i]:SetGray(true)
    end
  end
  local defLoseCount = table.count(self.finialDefLoseNoMap)
  local defBlood = 3
  for i = 1, defLoseCount do
    local bloodCell = self.defPlayerBloodTipCells[defBlood]
    defBlood = defBlood - 1
    bloodCell:SetActive(false)
  end
  local atkLoseCount = table.count(self.finialAtkLoseNoMap)
  local atkBlood = 3
  for i = 1, atkLoseCount do
    local bloodCell = self.atkPlayerBloodTipCells[atkBlood]
    atkBlood = atkBlood - 1
    bloodCell:SetActive(false)
  end
  if self.battleMsg.curRank and self.battleMsg.oldRank and self.battleMsg.ownerOldScore and self.battleMsg.ownerNewScore and self.battleMsg.otherOldScore and self.battleMsg.otherNewScore then
    self.old_rank:SetText(Localization:GetString("302043") .. "  " .. self.battleMsg.oldRank)
    self.new_rank:SetText(self.battleMsg.curRank)
    local addColor = Color.New(0.37254901960784315, 0.9372549019607843, 0.5294117647058824, 1)
    local delColor = Color.New(0.9764705882352941, 0.4392156862745098, 0.4666666666666667, 1)
    local ownerChangeScore = self.battleMsg.ownerNewScore - self.battleMsg.ownerOldScore
    self.atk_score_text:SetText(self.battleMsg.ownerNewScore)
    local ownerAddStr = 0 <= ownerChangeScore and "+" .. ownerChangeScore or ownerChangeScore
    self.atk_score_add_text:SetText(ownerAddStr)
    local ownerAddColor = 0 <= ownerChangeScore and addColor or delColor
    self.atk_score_add_text:SetColor(ownerAddColor)
    local otherChangeScore = self.battleMsg.otherNewScore - self.battleMsg.otherOldScore
    self.def_score_text:SetText(self.battleMsg.otherNewScore)
    local otherAddStr = 0 <= otherChangeScore and "+" .. otherChangeScore or otherChangeScore
    self.def_score_add_text:SetText(otherAddStr)
    local otherAddColor = 0 <= otherChangeScore and addColor or delColor
    self.def_score_add_text:SetColor(otherAddColor)
  end
end

function NewPeakArenaKOFBattleResultView:OnBackBtnClick()
  self.ctrl:CloseSelf()
  local curBattleType = DataCenter.LWBattleManager:GetCurBattleType()
  local curEnterType = DataCenter.LWBattleManager:GetPVEEnterType()
  if curBattleType == PVEType.KOF and curEnterType == PVEEnterType.NewPeakArena then
    DataCenter.LWBattleManager:Exit(function()
    end)
  end
end

function NewPeakArenaKOFBattleResultView:OnStatisticsBtnClick()
  if self.battleMsg and self.battleMsg.mailUid then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWMailMain, {anim = false}, UIMailOpenType.Detail, self.battleMsg.mailUid, "KOFBattleResult")
  else
    UIUtil.ShowTips(Localization:GetString("alliance_train_035"))
  end
end

function NewPeakArenaKOFBattleResultView:OnShareBtnClick()
  if self.battleMsg and self.battleMsg.mailUid then
    local mailData = DataCenter.MailDataManager:GetMailInfoById(self.battleMsg.mailUid)
    if mailData ~= nil then
      local post = PostType.Text_FightReport
      if mailData.type == MailType.MAIL_SCOUT_RESULT or mailData.type == MailType.LW_SEASON_SCOUT_MAIL then
        post = PostType.Text_ScoutReport
      end
      local shareParam = {}
      shareParam.post = post
      shareParam.param = {}
      shareParam.param.reportUid = mailData.uid
      shareParam.param.reportLang = ChatManager2:GetInstance().Translate:GetLangString(ChatInterface.getLanguageName())
      shareParam.param.mailType = mailData.type
      shareParam.param.toUser = mailData.toUser
      if mailData.type == MailType.TRUCK_BATTLE_REPORT then
        local extData = mailData:GetMailExt()
        shareParam.param.train_quality = extData.trainData.train_quality
      end
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, shareParam)
    else
      UIUtil.ShowTips(Localization:GetString("alliance_train_035"))
    end
  end
end

return NewPeakArenaKOFBattleResultView
