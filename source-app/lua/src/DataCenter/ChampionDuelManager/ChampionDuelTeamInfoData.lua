local ChampionDuelTeamInfoData = BaseClass("ChampionDuelTeamInfoData")
local Localization = CS.GameEntry.Localization
local MyTbNull = table.IsNullOrEmpty
local ChampionDuelTeamData = require("DataCenter.ChampionDuelManager.ChampionDuelTeamData")

function ChampionDuelTeamInfoData:__init()
  self.frame = 0
  self.lv = 0
  self.server = 0
  self.uid = ""
  self.head = ""
  self.name = ""
  self.abbr = ""
  self.teamOrder = {}
  self.skin = {}
  self.team = {}
  self.battleWord = ""
  self.battleWordExpireTime = 0
  self.rank = 0
  self.score = 0
  self.winCount = 0
  self.addScore = 0
  self.power = 0
  self.robot = false
  self.bSeed = false
  self.totalBets = 0
  self.isChooseBet = false
  self.point = 0
  self.group5 = 0
  self.rank5 = 0
end

function ChampionDuelTeamInfoData:__delete()
  self.frame = 0
  self.lv = 0
  self.server = 0
  self.uid = ""
  self.head = ""
  self.name = ""
  self.abbr = ""
  self.teamOrder = {}
  self.skin = {}
  self.team = {}
  self.battleWord = ""
  self.battleWordExpireTime = 0
  self.rank = 0
  self.score = 0
  self.winCount = 0
  self.addScore = 0
  self.power = 0
  self.robot = false
  self.bSeed = false
  self.totalBets = 0
  self.isChooseBet = false
  self.point = 0
  self.group5 = 0
  self.rank5 = 0
end

function ChampionDuelTeamInfoData:ParseData(message)
  if message == nil then
    return
  end
  if message.frame ~= nil then
    self.frame = message.frame
  end
  if message.lv ~= nil then
    self.lv = message.lv
  end
  if message.server ~= nil then
    self.server = message.server
  end
  if message.uid ~= nil then
    self.uid = message.uid
  end
  if message.head ~= nil then
    self.head = message.head
  end
  if message.name ~= nil then
    self.name = message.name
  end
  if message.allianceName ~= nil then
    self.abbr = message.allianceName
  end
  local teamOrder = message.teamOrder
  if teamOrder ~= nil then
    self.teamOrder = string.string2array_i_oneSep(teamOrder, ";")
  end
  local skinArr = message.skin
  if skinArr ~= nil then
    self.skin = {}
    for _, v in pairs(skinArr) do
      local tmpSkin = {}
      tmpSkin.skinId = v.skinId
      tmpSkin.expireTime = v.expireTime
      local type = v.type
      tmpSkin.type = type
      self.skin[type] = tmpSkin
    end
  end
  local teamArr = message.team
  self.realTeamNum = 0
  if teamArr ~= nil then
    self.team = {}
    for _, v in pairs(teamArr) do
      local data = ChampionDuelTeamData.New()
      data:ParseData(v)
      self.team[data.index] = data
    end
    self.realTeamNum = table.count(self.team)
  end
  if message.battleWord ~= nil then
    local newMsg = message.battleWord
    if self.battleWord ~= newMsg then
      self.battleWord = newMsg
      self.translateMsg = ""
      self.translating = false
    end
  end
  if message.battleWordExpireTime ~= nil then
    self.battleWordExpireTime = message.battleWordExpireTime
  end
  if message.rank ~= nil then
    self.rank = message.rank
  end
  if message.score ~= nil then
    self.score = message.score
  end
  if message.winCount ~= nil then
    self.winCount = message.winCount
  end
  if message.addScore ~= nil then
    self.addScore = message.addScore
  end
  if message.power ~= nil then
    self.power = message.power
  end
  if message.robot ~= nil then
    self.robot = message.robot
  end
  if message.bSeed ~= nil then
    self.bSeed = message.bSeed
  end
  if message.totalBets ~= nil then
    self.totalBets = message.totalBets
  end
  if message.isChooseBet ~= nil then
    self.isChooseBet = message.isChooseBet
  end
  if message.point ~= nil then
    self.point = message.point
  end
  if message.group5 ~= nil then
    self.group5 = message.group5
  end
  if message.rank5 ~= nil then
    self.rank5 = message.rank5
  end
end

function ChampionDuelTeamInfoData:CheckBuildOpen(index)
  local type = 0
  if index == 1 then
    type = BuildingTypes.LW_BUILD_PARKINGLOT
  elseif index == 2 then
    type = BuildingTypes.LW_BUILD_PARKINGLOT_TWO
  elseif index == 3 then
    type = BuildingTypes.LW_BUILD_PARKINGLOT_THREE
  elseif index == 4 then
    type = BuildingTypes.LW_BUILD_PARKINGLOT_FOUR
  end
  if 0 < type then
    local buildData = DataCenter.BuildManager:GetFunbuildByItemID(type)
    if buildData and 1 <= buildData.level then
      return true
    end
  end
  return false
end

function ChampionDuelTeamInfoData:CheckTeamIndexUnlocked(index, showTips)
  if index <= self.realTeamNum then
    return true
  end
  local cnt = 1
  for i = 2, 4 do
    if self:CheckBuildOpen(i) then
      cnt = cnt + 1
    end
  end
  if index <= cnt then
    return true
  end
  if showTips then
    local str = Localization:GetString("champion_duel_tips1173", index)
    UIUtil.ShowTips(str)
  end
  return false
end

function ChampionDuelTeamInfoData:GetOneFreeSquadNo()
  local allT = {}
  if self.team ~= nil then
    for _, v in pairs(self.team) do
      allT[v.localSquadNo] = true
    end
  end
  for i = 1, 4 do
    if not allT[i] and self:CheckBuildOpen(i) then
      return i
    end
  end
  return 0
end

function ChampionDuelTeamInfoData:CheckSelfTeamOrderUnlocked(order, showTips)
  local idx = self.teamOrder ~= nil and self.teamOrder[order] or 0
  return self:CheckTeamIndexUnlocked(idx, showTips)
end

function ChampionDuelTeamInfoData:GetTeamDataByIdx(idx)
  if self.team ~= nil then
    local data = self.team[idx]
    if data == nil and self:CheckTeamIndexUnlocked(idx) then
      data = ChampionDuelTeamData.New()
      data.index = idx
      data.localSquadNo = self:GetOneFreeSquadNo()
      self.team[idx] = data
    end
    return data
  end
  return nil
end

function ChampionDuelTeamInfoData:GetTeamDataByOrder(order)
  local idx = self.teamOrder ~= nil and self.teamOrder[order] or 0
  return self:GetTeamDataByIdx(idx)
end

function ChampionDuelTeamInfoData:GetSelfTeamOrderByIndex(index)
  if MyTbNull(self.teamOrder) then
    return 0
  end
  for i, idx in ipairs(self.teamOrder) do
    if idx == index then
      return i
    end
  end
  return 0
end

function ChampionDuelTeamInfoData:GetHeroInSelfTeamOrder(uuid)
  local teams = self.team or {}
  if MyTbNull(teams) then
    return nil
  end
  for index, v in pairs(teams) do
    if v:HasLocalHero(uuid) then
      return self:GetSelfTeamOrderByIndex(index)
    end
  end
  return nil
end

function ChampionDuelTeamInfoData:GetDirtySelfTeams()
  local teams = self.team or {}
  if MyTbNull(teams) then
    return nil
  end
  local changedTeams = {}
  for index, v in pairs(teams) do
    if v:CheckLoacalRemoteDiff() or v.index ~= index then
      changedTeams[index] = v
    end
  end
  return changedTeams
end

function ChampionDuelTeamInfoData:GetSelfEmptyTeam()
  local teams = self.team or {}
  if MyTbNull(teams) then
    return nil
  end
  for index, v in pairs(teams) do
    if MyTbNull(v:GetLocalAllHeroes()) and self:CheckTeamIndexUnlocked(index) then
      return self:GetSelfTeamOrderByIndex(index)
    end
  end
  return nil
end

function ChampionDuelTeamInfoData:GetTeamIndexUsingBuff(buffIndex)
  local teams = self.team or {}
  if MyTbNull(teams) then
    return nil
  end
  for index, v in pairs(teams) do
    if v.localSquadNo == buffIndex then
      return self:GetSelfTeamOrderByIndex(index)
    end
  end
  return nil
end

function ChampionDuelTeamInfoData:GetPower()
  if self.power > 0 then
    return self.power
  end
  local power = 0
  if not table.IsNullOrEmpty(self.team) then
    for _, v in pairs(self.team) do
      power = power + v.power
    end
  end
  return power
end

function ChampionDuelTeamInfoData:SetFrameShow(headFrame)
  if headFrame == nil then
    return
  end
  local frameId
  for _, v in pairs(self.skin) do
    if v.type == DecorationType.DecorationType_Head_Frame then
      frameId = v.skinId
      break
    end
  end
  if frameId == nil then
    frameId = DataCenter.DecorationDataManager:GetDefaultSkinIdByType(DecorationType.DecorationType_Head_Frame)
  end
  headFrame:SetFrame(DataCenter.DecorationDataManager:GetHeadFrame(frameId, LongMaxValue))
  headFrame:SetHead(self.uid, self.head, self.frame)
end

function ChampionDuelTeamInfoData:OnHeadClick()
  if self.robot then
    UIUtil.ShowTipsId("champion_duel_tips1093")
    return
  end
  local thePlayerUid = self.uid
  if thePlayerUid ~= nil and thePlayerUid ~= 0 then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true, hideTop = false}, thePlayerUid)
  end
end

function ChampionDuelTeamInfoData:SetNameShow(text_name)
  if text_name == nil then
    return
  end
  local nameStr = self.name
  if self.robot then
    nameStr = Localization:GetString(nameStr)
  end
  nameStr = UIUtil.FormatAllianceAndName(self.abbr, nameStr, self.uid)
  text_name:SetText(nameStr)
end

function ChampionDuelTeamInfoData:SetNameShow2(text_name)
  local nameStr = self.name
  if self.robot then
    nameStr = Localization:GetString(nameStr)
  end
  nameStr = UIUtil.FormatServerAllianceName(self.server, self.abbr, "\n" .. nameStr, self.uid)
  text_name:SetText(nameStr)
end

function ChampionDuelTeamInfoData:OnPraiseClick()
  local thePlayerUid = self.uid
  if thePlayerUid ~= nil and thePlayerUid ~= 0 and thePlayerUid ~= "system" then
    InteractiveUtil.TryThumbsUp(thePlayerUid, InteractiveUtil.ThumbsUpType.ChampionDuel, "ChampionDuel", function()
      UIUtil.ShowTipsId("champion_duel_tips1172")
    end)
  end
end

function ChampionDuelTeamInfoData:SetBattleWord(text, infoIcon)
  local wordStr = self.battleWord
  local flag = true
  if string.IsNullOrEmpty(wordStr) then
    wordStr = "..."
    flag = false
  elseif self.robot then
    wordStr = Localization:GetString(wordStr)
    flag = false
  elseif self.uid == LuaEntry.Player:GetUid() then
    flag = false
  end
  text:SetText(wordStr)
  infoIcon:SetActive(flag)
end

function ChampionDuelTeamInfoData:OnWordClick()
  if self.robot or self.uid == LuaEntry.Player:GetUid() then
    return
  end
  local wordStr = self.battleWord
  if string.IsNullOrEmpty(wordStr) then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIChatReport, {anim = true}, {
    type = ReportType.championDuel,
    uid = self.uid,
    name = self.name,
    msg = wordStr
  })
end

function ChampionDuelTeamInfoData:GetMessage()
  return self.battleWord
end

function ChampionDuelTeamInfoData:SetIsTranslating(translatingFlag)
  self.translating = translatingFlag
end

function ChampionDuelTeamInfoData:SetTranslationMsg(msg)
  self.translateMsg = msg
end

return ChampionDuelTeamInfoData
