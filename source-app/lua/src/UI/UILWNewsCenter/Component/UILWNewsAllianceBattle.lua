local base = require("UI.UILWNewsCenter.Component.UILWNewsBase")
local UILWNewsAllianceBattle = BaseClass("UILWNewsAllianceBattle", base)
local Localization = CS.GameEntry.Localization
local compBook = {
  {
    path = "imgInfoBg/imgResultBg/txtNameLeft",
    name = "txtNameLeft",
    type = UIText
  },
  {
    path = "imgInfoBg/imgResultBg/txtNameRight",
    name = "txtNameRight",
    type = UIText
  },
  {
    path = "imgInfoBg/imgBadgeLeft",
    name = "imgBadgeLeft",
    type = UIImage
  },
  {
    path = "imgInfoBg/imgBadgeRight",
    name = "imgBadgeRight",
    type = UIImage
  },
  {
    path = "imgInfoBg/lblLeader",
    name = "lblLeader",
    type = UIText
  },
  {
    path = "imgInfoBg/txtLeaderLeft",
    name = "txtLeaderLeft",
    type = UIText
  },
  {
    path = "imgInfoBg/txtLeaderRight",
    name = "txtLeaderRight",
    type = UIText
  },
  {
    path = "imgInfoBg/lblPower",
    name = "lblPower",
    type = UIText
  },
  {
    path = "imgInfoBg/txtPowerLeft",
    name = "txtPowerLeft",
    type = UIText
  },
  {
    path = "imgInfoBg/txtPowerRight",
    name = "txtPowerRight",
    type = UIText
  },
  {
    path = "imgInfoBg/lblNumber",
    name = "lblNumber",
    type = UIText
  },
  {
    path = "imgInfoBg/txtNumberLeft",
    name = "txtNumberLeft",
    type = UIText
  },
  {
    path = "imgInfoBg/txtNumberRight",
    name = "txtNumberRight",
    type = UIText
  },
  {
    path = "imgInfoBg/lblDamage",
    name = "lblDamage",
    type = UIText
  },
  {
    path = "imgInfoBg/txtDamageLeft",
    name = "txtDamageLeft",
    type = UIText
  },
  {
    path = "imgInfoBg/txtDamageRight",
    name = "txtDamageRight",
    type = UIText
  },
  {
    path = "imgInfoBg/lblDestroy",
    name = "lblDestroy",
    type = UIText
  },
  {
    path = "imgInfoBg/txtDestroyLeft",
    name = "txtDestroyLeft",
    type = UIText
  },
  {
    path = "imgInfoBg/txtDestroyRight",
    name = "txtDestroyRight",
    type = UIText
  }
}

function UILWNewsAllianceBattle:ComponentDefine()
  base.ComponentDefine(self)
  self:DefineCompsByBook(compBook)
  self.txtTitle:SetText(Localization:GetString("800904"))
  self.lblLeader:SetText(Localization:GetString("302336"))
  self.lblPower:SetText(Localization:GetString("800929"))
  self.lblNumber:SetText(Localization:GetString("800930"))
  self.lblDamage:SetText(Localization:GetString("800931"))
  self.lblDestroy:SetText(Localization:GetString("800932"))
end

function UILWNewsAllianceBattle:ComponentDestroy()
  self:ClearCompsByBook(compBook)
  base.ComponentDestroy(self)
end

function UILWNewsAllianceBattle:SetContentViewScript(chatMainView)
  self._contentViewScript = chatMainView
end

function UILWNewsAllianceBattle:UpdateItem(info)
  base.RefreshView(self, info)
  local side1 = self.info.dataObj.side1
  local side2 = self.info.dataObj.side2
  local winner = side1.lost <= side2.lost and side1 or side2
  local loser = side1.lost <= side2.lost and side2 or side1
  local lostRate = winner.lost > 0 and loser.lost / winner.lost or loser.lost
  local side1Abbr = string.IsNullOrEmpty(side1.abbr) and " " or "[" .. side1.abbr .. "] "
  local side2Abbr = string.IsNullOrEmpty(side2.abbr) and " " or "[" .. side2.abbr .. "] "
  local side1Server = LuaEntry.Player.serverId == side1.serverId and "" or "#" .. side1.serverId
  local side2Server = LuaEntry.Player.serverId == side2.serverId and "" or "#" .. side2.serverId
  local side1AlName = side1Server .. side1Abbr .. side1.alliancename
  local side2AlName = side2Server .. side2Abbr .. side2.alliancename
  local winnerAlName = winner == side1 and side1AlName or side2AlName
  local loserAlName = winner == side1 and side2AlName or side1AlName
  self.txtNameLeft:SetText(side1AlName)
  self.txtNameRight:SetText(side2AlName)
  local comment = ""
  if side1.beDestroyBaseNum + side2.beDestroyBaseNum >= 20 then
    comment = Localization:GetString("800916", side1AlName, side2AlName, side1.beDestroyBaseNum + side2.beDestroyBaseNum)
  elseif 3 < lostRate then
    comment = Localization:GetString("800917", side1AlName, side2AlName, winnerAlName, loserAlName)
  elseif lostRate < 1.5 then
    comment = Localization:GetString("800918", side1AlName, side2AlName)
  else
    comment = Localization:GetString("800919", side1AlName, side2AlName, winnerAlName)
  end
  self.txtComment:SetText(comment)
  local showName1 = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(side1.leaderUid, side1.leaderName)
  self.txtLeaderLeft:SetText(side1Server .. side1Abbr .. showName1)
  local showName2 = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(side2.leaderUid, side2.leaderName)
  self.txtLeaderRight:SetText(side2Server .. side2Abbr .. showName2)
  self.txtPowerLeft:SetText(string.GetFormattedStr(side1.power))
  self.txtPowerRight:SetText(string.GetFormattedStr(side2.power))
  self.txtNumberLeft:SetText(side1.playerNum)
  self.txtNumberRight:SetText(side2.playerNum)
  self.txtDamageLeft:SetText(string.GetFormattedStr(side1.lost))
  self.txtDamageRight:SetText(string.GetFormattedStr(side2.lost))
  self.txtDestroyLeft:SetText(side1.beDestroyBaseNum)
  self.txtDestroyRight:SetText(side2.beDestroyBaseNum)
  self.imgBadgeLeft:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, side1.icon))
  self.imgBadgeRight:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, side2.icon))
end

return UILWNewsAllianceBattle
