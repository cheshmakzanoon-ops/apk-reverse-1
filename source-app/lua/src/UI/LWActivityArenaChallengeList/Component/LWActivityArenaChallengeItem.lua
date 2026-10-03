local LWActivityArenaChallengeItem = BaseClass("LWActivityArenaChallengeItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Notifier = require("Common.Notifier")
local compBook = {
  {
    path = "head",
    name = "head",
    type = UICommonHead
  },
  {
    path = "txtName",
    name = "txtName",
    type = UIText
  },
  {
    path = "txtPower",
    name = "txtPower",
    type = UIText
  },
  {
    path = "btnChallenge",
    name = "btnChallenge",
    type = UIButton,
    onClick = function(self)
      self:OnClickChallenge()
    end
  },
  {
    path = "btnChallenge/txtChallenge",
    name = "txtChallenge",
    type = UIText,
    textKey = "372258"
  },
  {
    path = "txtRank",
    name = "txtRank",
    type = UIText
  },
  {
    path = "btnCheck",
    name = "btnCheck",
    type = UIButton,
    onClick = function(self)
      self:OnClickCheck()
    end,
    active = true
  },
  {
    path = "soldier",
    name = "objSoldier",
    type = nil
  },
  {
    path = "soldier/imgSoldierBase",
    name = "imgSoldierBase",
    type = UIImage
  },
  {
    path = "soldier/imgSoldierBase/imgSoldier",
    name = "imgSoldier",
    type = UIImage
  },
  {
    path = "soldier/txtSoldier",
    name = "textSoldier",
    type = UITextMeshProUGUIEx
  }
}

function LWActivityArenaChallengeItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function LWActivityArenaChallengeItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWActivityArenaChallengeItem:ComponentDefine()
  self:DefineCompsByBook(compBook)
end

function LWActivityArenaChallengeItem:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function LWActivityArenaChallengeItem:Refresh(rankData, arenaType)
  self.data = rankData
  self.arenaType = arenaType
  self:RefreshUserInfo(rankData)
  if rankData.rankText then
    self.txtRank:SetText(rankData.rankText)
  else
    self.txtRank:SetText(rankData.rank)
  end
  self.btnChallenge:SetActive(rankData.canChallenge)
  if self.objSoldier then
    local soldierId = checknumber(rankData.formationSoldier)
    local showSoldier = 0 < soldierId
    self.objSoldier:SetActive(showSoldier)
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
end

function LWActivityArenaChallengeItem:RefreshUserInfo(rankData)
  if not rankData then
    return
  end
  local shareInfo = rankData.shareInfo
  if shareInfo then
    local nameStr = ""
    if rankData.shareInfo.serverId then
      nameStr = "#" .. rankData.shareInfo.serverId
    end
    if not string.IsNullOrEmpty(rankData.shareInfo.abbr) then
      nameStr = nameStr .. " [" .. rankData.shareInfo.abbr .. "]"
    end
    nameStr = nameStr .. " " .. rankData.shareInfo.name
    self.txtName:SetText(nameStr)
    local power = rankData.formationPower
    if power and 0 < power then
      self.txtPower:SetText(string.GetFormattedStr(power))
    else
      self.txtPower:SetText(string.GetFormattedStr(rankData.shareInfo.power))
    end
    self.head:SetHeadAndFrame(rankData.shareInfo.uid, rankData.shareInfo.pic, rankData.shareInfo.picver, false, rankData.shareInfo.headFrame)
  else
    self.txtName:SetText(Localization:GetString(LocalController:instance():getValue(TableName.LWArmy, rankData.playerId, "name")))
    local powerStr = LocalController:instance():getValue(TableName.LWArmy, rankData.playerId, "pve_power")
    local powerStrArr = string.split(powerStr, "|")
    local totalPower = 0
    for _, power in ipairs(powerStrArr) do
      totalPower = totalPower + tonumber(power)
    end
    self.txtPower:SetText(string.GetFormattedStr(totalPower))
    local iconRes = LoadPath.HeroIconsSmallPath .. LocalController:instance():getValue(TableName.LWArmy, rankData.playerId, "army_icon")
    self.head:SetData(nil, iconRes, nil)
  end
end

function LWActivityArenaChallengeItem:OnClickChallenge()
  if self.arenaType == PVPArenaType.NewbieArenaV2 then
    Notifier.Dispatch("LWNewbieArenaV2PageArea.ChallengeOther", self.data.rank)
  end
end

function LWActivityArenaChallengeItem:OnClickCheck()
  if self.arenaType == PVPArenaType.NewbieArenaV2 then
    Notifier.Dispatch("LWNewbieArenaV2PageArea.CheckOther", self.data.rank)
  end
end

return LWActivityArenaChallengeItem
