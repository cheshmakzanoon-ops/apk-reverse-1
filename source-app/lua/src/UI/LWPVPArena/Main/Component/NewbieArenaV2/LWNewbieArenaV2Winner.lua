local LWNewbieArenaV2Winner = BaseClass("LWNewbieArenaV2Winner", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Notifier = require("Common.Notifier")
local compBook = {
  {
    path = "imgHead",
    name = "imgHead",
    type = UIImage
  },
  {
    path = "btnHead",
    name = "btnHead",
    type = UIButton
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
    path = "imgBadge/txtRank",
    name = "txtRank",
    type = UIText
  },
  {
    path = "imgBadge/txtLastRank",
    name = "txtLastRank",
    type = UIText
  },
  {
    path = "imgBadge/vfxGlow",
    name = "vfxGlow",
    type = nil,
    active = false
  }
}

function LWNewbieArenaV2Winner:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function LWNewbieArenaV2Winner:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWNewbieArenaV2Winner:ComponentDefine()
  self:DefineCompsByBook(compBook)
  self.compPlayerHead = self.imgHead.gameObject:GetComponent(typeof(CS.UIPlayerHead))
  self.circleImage = self.imgHead.gameObject:GetComponent(typeof(CS.CircleImage))
  self.btnHead:SetOnClick(function()
    if self.data then
      Notifier.Dispatch("LWNewbieArenaV2PageArea.CheckOther", self.data.rank)
    end
  end)
  self.rankCanvasGroup = self.txtRank.gameObject:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
  self.lastRankCanvasGroup = self.txtLastRank.gameObject:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
end

function LWNewbieArenaV2Winner:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function LWNewbieArenaV2Winner:Refresh(rankData)
  self.data = rankData
  self:RefreshUserInfo(rankData)
  self.txtRank:SetText(rankData.rank)
end

function LWNewbieArenaV2Winner:RefreshUserInfo(rankData)
  if not rankData then
    return
  end
  local shareInfo = rankData.shareInfo
  if shareInfo then
    local nameStr = ""
    if not string.IsNullOrEmpty(rankData.shareInfo.abbr) then
      nameStr = nameStr .. " [" .. rankData.shareInfo.abbr .. "]"
    end
    nameStr = nameStr .. "\n" .. rankData.shareInfo.name
    self.txtName:SetText(nameStr)
    local power = rankData.formationPower
    if power and 0 < power then
      self.txtPower:SetText(string.GetFormattedStr(power))
    else
      self.txtPower:SetText(string.GetFormattedStr(rankData.shareInfo.power))
    end
    self.compPlayerHead:SetData(rankData.shareInfo.uid, rankData.shareInfo.pic, rankData.shareInfo.picver)
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
    if iconRes then
      self.circleImage:LoadSprite(iconRes)
    end
  end
end

return LWNewbieArenaV2Winner
