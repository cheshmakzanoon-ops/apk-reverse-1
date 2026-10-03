local UIArenaNewbieRankItemPerson = BaseClass("UIArenaNewbieRankItemPerson", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Notifier = require("Common.Notifier")
local compBook = {
  {
    path = "bg1st",
    name = "bg1",
    type = nil
  },
  {
    path = "bg2nd",
    name = "bg2",
    type = nil
  },
  {
    path = "bg3rd",
    name = "bg3",
    type = nil
  },
  {
    path = "bgSelf",
    name = "bgSelf",
    type = nil
  },
  {
    path = "badge1st",
    name = "badge1",
    type = nil
  },
  {
    path = "badge2nd",
    name = "badge2",
    type = nil
  },
  {
    path = "badge3rd",
    name = "badge3",
    type = nil
  },
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
    path = "btnView",
    name = "btnView",
    type = UIButton,
    onClick = function(self)
      self:OnClickView()
    end
  },
  {
    path = "txtRank",
    name = "txtRank",
    type = UIText
  },
  {
    path = "txtLastRank",
    name = "txtLastRank",
    type = UIText
  },
  {
    path = "txtRank",
    name = "cgRank",
    rawType = CS.UnityEngine.CanvasGroup
  },
  {
    path = "txtLastRank",
    name = "cgLastRank",
    rawType = CS.UnityEngine.CanvasGroup
  },
  {
    path = "vfxGlow",
    name = "vfxGlow",
    type = nil,
    active = false
  },
  {
    path = "btnChest",
    name = "btnChest",
    type = UIButton,
    onClick = function(self)
      self:OnClickChest()
    end,
    active = false
  },
  {
    path = "btnCheck",
    name = "btnCheck",
    type = UIButton,
    onClick = function(self)
      self:OnClickCheck()
    end,
    active = true
  }
}

function UIArenaNewbieRankItemPerson:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIArenaNewbieRankItemPerson:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIArenaNewbieRankItemPerson:ComponentDefine()
  self:DefineCompsByBook(compBook)
end

function UIArenaNewbieRankItemPerson:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function UIArenaNewbieRankItemPerson:Refresh(rankData)
  self.data = rankData
  self:RefreshUserInfo(rankData)
  self.bg1:SetActive(rankData.rank == 1)
  self.bg2:SetActive(rankData.rank == 2)
  self.bg3:SetActive(rankData.rank == 3)
  self.bgSelf:SetActive(rankData.isSelf)
  self.badge1:SetActive(rankData.rank == 1)
  self.badge2:SetActive(rankData.rank == 2)
  self.badge3:SetActive(rankData.rank == 3)
  self.txtRank:SetText(rankData.rank)
  if rankData.rankScale then
    self.txtRank:SetLocalScaleXYZ(rankData.rankScale, rankData.rankScale, rankData.rankScale)
  else
    self.txtRank:SetLocalScaleXYZ(1, 1, 1)
  end
  if rankData.rankAlpha then
    self.cgRank.alpha = rankData.rankAlpha
  else
    self.cgRank.alpha = 1
  end
  if rankData.lastRank then
    self.txtLastRank:SetActive(true)
    self.txtLastRank:SetText(rankData.lastRank)
    self.txtLastRank:SetLocalScaleXYZ(rankData.lastRankScale, rankData.lastRankScale, rankData.lastRankScale)
    self.cgLastRank.alpha = rankData.lastRankAlpha
  else
    self.txtLastRank:SetActive(false)
  end
  if rankData.playVfxGlow then
    rankData.playVfxGlow = nil
    self.vfxGlow:SetActive(false)
    self.vfxGlow:SetActive(true)
  end
  self.btnChallenge:SetActive(rankData.canChallenge)
  self.btnView:SetActive(rankData.canView)
  self.btnChest:SetActive(rankData.chestAchieveId)
end

function UIArenaNewbieRankItemPerson:RefreshUserInfo(rankData)
  if not rankData then
    return
  end
  local shareInfo = rankData.shareInfo
  if shareInfo then
    local nameStr = ""
    if not string.IsNullOrEmpty(rankData.shareInfo.abbr) then
      nameStr = nameStr .. " [" .. rankData.shareInfo.abbr .. "]"
    end
    nameStr = nameStr .. " " .. rankData.shareInfo.name
    self.txtName:SetText(nameStr)
    self.txtPower:SetText(string.GetFormattedStr(rankData.shareInfo.power))
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

function UIArenaNewbieRankItemPerson:OnClickChallenge()
  Notifier.Dispatch("UIArenaNewbieArea.ChallengeOther", self.data.rank)
end

function UIArenaNewbieRankItemPerson:OnClickView()
  Notifier.Dispatch("UIArenaNewbieArea.ViewOther", self.data.rank)
end

function UIArenaNewbieRankItemPerson:OnClickChest()
  Notifier.Dispatch("UIArenaNewbieArea.ShowRewards", self.data.chestAchieveId)
end

function UIArenaNewbieRankItemPerson:OnClickCheck()
  Notifier.Dispatch("UIArenaNewbieArea.CheckOther", self.data.rank)
end

return UIArenaNewbieRankItemPerson
