local NewPeakArenaOtherView = BaseClass("NewPeakArenaOtherView", UIBaseView)
local base = UIBaseView
local UIHeroCellSmall = require("UI.UIHero2.Common.UIHeroCellSmall")
local NewPeakArenaOtherHeroCell = require("UI.NewPeakArenaOther.Component.NewPeakArenaOtherHeroCell")
local Localization = CS.GameEntry.Localization
local compBook = {
  {
    path = "txtTitle",
    name = "txtTitle",
    type = UIText,
    textKey = "500211"
  },
  {
    path = "btnClose",
    name = "btnClose",
    type = UIButton,
    onClick = function(self)
      self.ctrl:CloseSelf()
    end
  },
  {
    path = "black",
    name = "btnBlack",
    type = UIButton,
    onClick = function(self)
      self.ctrl:CloseSelf()
    end
  },
  {
    path = "head",
    name = "head",
    type = UICommonHead
  },
  {
    path = "txtName",
    name = "txtName",
    type = UIText,
    text = ""
  },
  {
    path = "head/Score",
    name = "score",
    type = UIBaseContainer
  },
  {
    path = "head/Score/ScoreText",
    name = "scoreText",
    type = UIText,
    text = ""
  },
  {
    path = "layout",
    name = "layout",
    type = nil
  },
  {
    path = "layout/txtPower",
    name = "txtPower",
    type = UIText,
    text = ""
  },
  {
    path = "layout/Soldier",
    name = "compSoldier",
    type = UIBaseContainer
  },
  {
    path = "layout/Soldier/SoldierBase",
    name = "imgSoldierBase",
    type = UIImage
  },
  {
    path = "layout/Soldier/SoldierBase/SoldierImg",
    name = "imgSoldier",
    type = UIImage
  },
  {
    path = "layout/Soldier/SoldierText",
    name = "textSoldier",
    type = UIText,
    text = ""
  },
  {
    path = "btnChat",
    name = "btnChat",
    type = UIButton,
    onClick = function(self)
      self:OnClickChat()
    end
  },
  {
    path = "btnChat/txtChat",
    name = "txtChat",
    type = UIText,
    textKey = "393014"
  },
  {
    path = "DefTeam1",
    name = "defTeam1",
    type = NewPeakArenaOtherHeroCell
  },
  {
    path = "DefTeam2",
    name = "defTeam2",
    type = NewPeakArenaOtherHeroCell
  },
  {
    path = "DefTeam3",
    name = "defTeam3",
    type = NewPeakArenaOtherHeroCell
  }
}

function NewPeakArenaOtherView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:Refresh(self:GetUserData())
end

function NewPeakArenaOtherView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function NewPeakArenaOtherView:ComponentDefine()
  self.heroCells = {}
  self:DefineCompsByBook(compBook)
  self.defTeams = {
    [1] = self.defTeam1,
    [2] = self.defTeam2,
    [3] = self.defTeam3
  }
end

function NewPeakArenaOtherView:ComponentDestroy()
  self:ClearCompsByBook(compBook)
  self.defTeams = nil
end

function NewPeakArenaOtherView:OnAddListener()
  base.OnAddListener(self)
end

function NewPeakArenaOtherView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function NewPeakArenaOtherView:Refresh(otherInfo)
  self.otherInfo = otherInfo
  local playerInfo = otherInfo.playerInfo
  self.head:SetHeadAndFrame(playerInfo.uid, playerInfo.pic, playerInfo.picver, false, playerInfo.headSkinId)
  local nameStr = ""
  if not string.IsNullOrEmpty(playerInfo.abbr) then
    nameStr = nameStr .. " [" .. playerInfo.abbr .. "]"
  end
  nameStr = nameStr .. " " .. playerInfo.name
  self.txtName:SetText(nameStr)
  if otherInfo.formationPower then
    self.txtPower:SetText(otherInfo.formationPower)
  else
    self.txtPower:SetText(playerInfo.power)
  end
  self.btnChat:SetActive(playerInfo.uid and not string.IsNullOrEmpty(playerInfo.uid) and playerInfo.uid ~= LuaEntry.Player.uid)
  if otherInfo.score then
    self.score:SetActive(true)
    self.scoreText:SetText(otherInfo.score)
  else
    self.score:SetActive(false)
  end
  local soldierId = checknumber(otherInfo.formationSoldier)
  local showSoldier = 0 < soldierId
  if self.compSoldier then
    self.compSoldier:SetActive(showSoldier)
    if showSoldier then
      local soldierTemplate = DataCenter.SoldierDataManager:GetTemplate(soldierId)
      if soldierTemplate ~= nil then
        self.imgSoldierBase:LoadSprite(UIUtil.GetItemQualityBg(soldierTemplate.quality))
        local soldierIcon = string.format(LoadPath.ItemPath, soldierTemplate.icon)
        self.imgSoldier:LoadSprite(soldierIcon)
        self.textSoldier:SetText("Lv." .. soldierTemplate.lv)
      end
    end
  end
  local defTeam1Info = DataCenter.LWKOFBattleManager:GetDefTeamByIndex(playerInfo.uid, 1)
  local defTeam2Info = DataCenter.LWKOFBattleManager:GetDefTeamByIndex(playerInfo.uid, 2)
  local defTeam3Info = DataCenter.LWKOFBattleManager:GetDefTeamByIndex(playerInfo.uid, 3)
  local defTeamsInfo = {}
  defTeamsInfo = {
    [1] = defTeam1Info,
    [2] = defTeam2Info,
    [3] = defTeam3Info
  }
  for i = 1, 3 do
    local teamInfo = defTeamsInfo[i]
    if teamInfo then
      local heroesUuid = teamInfo:GetLocalAllHeroes()
      local heroesData = {}
      for index, uuid in pairs(heroesUuid) do
        local heroData = teamInfo:GetHeroDataByUuid(uuid)
        heroesData[index] = heroData
      end
      local dominatorData = teamInfo:GetDominatorData()
      if dominatorData then
        heroesData[ArmyFormationSlot.Dominator] = dominatorData
      end
      local defTeamItem = self.defTeams[i]
      if defTeamItem then
        if teamInfo.power then
          defTeamItem:SetData(heroesData, string.GetFormattedStr(teamInfo.power))
        else
          defTeamItem:SetData(heroesData, string.GetFormattedStr(teamInfo:GetTotalCapacity()))
        end
      end
    end
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.layout.transform)
end

function NewPeakArenaOtherView:OnClickChat()
  if not self.otherInfo or not self.otherInfo.playerInfo then
    return
  end
  self.ctrl:CloseSelf()
  local userInfo = {}
  userInfo.uid = self.otherInfo.playerInfo.uid
  userInfo.userName = self.otherInfo.playerInfo.name
  GoToUtil.OpenChatView(false, {anim = false}, {privateUserInfo = userInfo})
end

return NewPeakArenaOtherView
