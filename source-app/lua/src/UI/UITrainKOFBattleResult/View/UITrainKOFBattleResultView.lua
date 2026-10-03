local UITrainKOFBattleResultView = BaseClass("UITrainKOFBattleResultView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UITrainKOFBattleResultViewItem = require("UI.UITrainKOFBattleResult.Component.UITrainKOFBattleResultViewItem")
local LayoutLayer = "Layout/"
local atk_power_text_path = "Layout/AtkPlayer/AtkPlayerPower/AtkPowerText"
local atk_player_name_path = "Layout/AtkPlayer/AtkPlayerName"
local atk_player_head_path = "Layout/AtkPlayer/AtkPlayerHead"
local atk_player_blood_cell_path = "Layout/AtkPlayer/AtkPlayerBloodTip/AtkPlayerBloodCell"
local def_power_text_path = "Layout/DefPlayer/DefPlayerPower/DefPowerText"
local def_player_name_path = "Layout/DefPlayer/DefPlayerName"
local def_player_head_path = "Layout/DefPlayer/DefPlayerHead"
local def_player_blood_tip_path = "Layout/DefPlayer/DefPlayerBloodTip"
local def_player_blood_cell_path = "Layout/DefPlayer/DefPlayerBloodTip/DefPlayerBloodCell"
local atk_team_path = "Layout/battleContent/AtkTeam"
local def_team_path = "Layout/battleContent/DefTeam"
local share_btn_path = "Layout/ShareBtn"

function UITrainKOFBattleResultView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UITrainKOFBattleResultView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UITrainKOFBattleResultView:OnAddListener()
  base.OnAddListener(self)
end

function UITrainKOFBattleResultView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UITrainKOFBattleResultView:ComponentDefine()
  self.backBtn = self:AddComponent(UIButton, LayoutLayer .. "BtnBack")
  self.backBtn:SetOnClick(function()
    self:OnBackBtnClick()
  end)
  self.layout = self:AddComponent(UIBaseContainer, LayoutLayer)
  self.canvasGroup = self.transform:Find(LayoutLayer).gameObject:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
  self.canvasGroup.alpha = 0
  self.content = self:AddComponent(UIBaseContainer, LayoutLayer .. "reward/Viewport/Content")
  self.noReward = self:AddComponent(UIBaseComponent, LayoutLayer .. "reward/noReward")
  self.victoryGo = self:AddComponent(UIBaseContainer, LayoutLayer .. "Title/VictoryGo")
  self.loseGo = self:AddComponent(UIBaseContainer, LayoutLayer .. "Title/LoseGo")
  self.victoryGo:SetActive(false)
  self.loseGo:SetActive(false)
  self.statisticsBtn = self:AddComponent(UIButton, LayoutLayer .. "StatisticsBtn")
  self.statisticsBtn:SetOnClick(function()
    self:OnStatisticsBtnClick()
  end)
  self.atk_power_text = self:AddComponent(UITextMeshProUGUIEx, atk_power_text_path)
  self.atk_player_name = self:AddComponent(UITextMeshProUGUIEx, atk_player_name_path)
  self.atk_player_head = self:AddComponent(UICommonHead, atk_player_head_path)
  self.def_power_text = self:AddComponent(UITextMeshProUGUIEx, def_power_text_path)
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
    local atkTeam = self:AddComponent(UITrainKOFBattleResultViewItem, atk_team_path .. i)
    table.insert(self.atkTeamItems, atkTeam)
    local defTeam = self:AddComponent(UITrainKOFBattleResultViewItem, def_team_path .. i)
    table.insert(self.defTeamItems, defTeam)
  end
  self.share_btn = self:AddComponent(UIButton, share_btn_path)
  self.share_btn:SetOnClick(function()
    self:OnShareBtnClick()
  end)
end

function UITrainKOFBattleResultView:DataDefine()
  self.NameCount = 1
end

function UITrainKOFBattleResultView:ComponentDestroy()
  self.atk_power_text = nil
  self.atk_player_name = nil
  self.atk_player_head = nil
  self.def_power_text = nil
  self.def_player_name = nil
  self.def_player_head = nil
  self.def_player_blood_tip = nil
end

function UITrainKOFBattleResultView:DataDestroy()
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

function UITrainKOFBattleResultView:ReInit()
  self.battleMsg, self.finialAtkLoseNoMap, self.finialDefLoseNoMap, self.atkKillMap, self.defKillMap = self:GetUserData()
  if self.battleMsg == nil then
    return
  end
  local isWin = self.battleMsg.isWin
  self.victoryGo:SetActive(isWin)
  self.loseGo:SetActive(not isWin)
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

function UITrainKOFBattleResultView:RefreshView()
  self:RefreshReward()
  self.opponentData = DataCenter.LWKOFBattleManager.opponentData
  if not self.opponentData then
    return
  end
  self.opponentPlayerInfo = self.opponentData.playerInfo
  local headFramePath = DataCenter.DecorationDataManager:GetHeadFrame(self.opponentPlayerInfo.headSkinId, self.opponentPlayerInfo.headSkinET, false)
  self.def_player_head:SetData(self.opponentPlayerInfo.uid, self.opponentPlayerInfo.pic, self.opponentPlayerInfo.picver, nil, headFramePath)
  local name = UIUtil.FormatServerAllianceName(self.opponentPlayerInfo.serverId, self.opponentPlayerInfo.abbr, self.opponentPlayerInfo.name)
  self.def_player_name:SetText(name)
  self.def_power_text:SetText(string.GetFormattedStr(self.opponentData.power))
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
  name = UIUtil.FormatServerAllianceName(LuaEntry.Player.serverId, selfAllianceAbbr, LuaEntry.Player.name)
  self.atk_player_name:SetText(name)
  local myPower = DataCenter.LWKOFBattleManager:GetAtkTeamPower()
  self.atk_power_text:SetText(string.GetFormattedStr(myPower))
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
end

function UITrainKOFBattleResultView:RefreshReward()
  self:RemoveReward()
  local rewardData = self.battleMsg.showReward
  if not rewardData or table.count(rewardData) <= 0 then
    self.noReward:SetActive(true)
    return
  end
  self.noReward:SetActive(false)
  local container = self.content
  for i = 1, table.length(rewardData) do
    self.model[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      local transform = go.transform
      go:SetActive(true)
      transform:SetParent(container.transform)
      transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      transform:Set_sizeDelta(150, 150)
      transform:Set_pivot(0, 1)
      local nameStr = tostring(self.NameCount)
      go.name = nameStr
      self.NameCount = self.NameCount + 1
      local cell = container:AddComponent(UICommonResItem, nameStr)
      local data = rewardData[i]
      local param = UICommonResItem.Param.New()
      param.rewardType = data.type
      if type(data.value) == "table" then
        param.itemId = data.value.id
        param.count = data.value.num or data.value.count
      else
        param.itemId = data.type
        param.count = data.value
      end
      param.rewardType = data.type
      param.heroUuid = data.heroUuid
      param.isHeroBox = data.isHeroBox
      cell:ReInit(param)
    end)
  end
end

function UITrainKOFBattleResultView:RemoveReward()
  self.content:RemoveComponents(UICommonResItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.model = {}
end

function UITrainKOFBattleResultView:OnBackBtnClick()
  self.ctrl:CloseSelf()
  local curBattleType = DataCenter.LWBattleManager:GetCurBattleType()
  local curEnterType = DataCenter.LWBattleManager:GetPVEEnterType()
  if curBattleType == PVEType.KOF and curEnterType == PVEEnterType.TrainRob then
    DataCenter.LWBattleManager:Exit(function()
    end)
  end
end

function UITrainKOFBattleResultView:OnStatisticsBtnClick()
  if self.battleMsg and self.battleMsg.mailUid then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWMailMain, {anim = false}, UIMailOpenType.Detail, self.battleMsg.mailUid, "KOFBattleResult")
  else
    UIUtil.ShowTips(Localization:GetString("alliance_train_035"))
  end
end

function UITrainKOFBattleResultView:OnShareBtnClick()
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

return UITrainKOFBattleResultView
