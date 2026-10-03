local UILWSeasonServerDetailItemAlliance = BaseClass("UILWSeasonServerDetailItemAlliance", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local BuildInfo = require("UI.LWSeason1.UILWSeasonServerDetail.Component.UILWSeasonServerDetailItemAllianceBuild")

function UILWSeasonServerDetailItemAlliance:OnCreate()
  base.OnCreate(self)
  self.flag = self:AddComponent(UIImage, "flag")
  self.name_txt = self:AddComponent(UITextMeshProUGUIEx, "info/NameTxt")
  self.alliance_rank_txt = self:AddComponent(UITextMeshProUGUIEx, "info/AllianceRankTxt")
  self.alliance_txt = self:AddComponent(UITextMeshProUGUIEx, "info/AllianceTxt")
  self.build1 = self:AddComponent(BuildInfo, "BuildList/build1")
  self.build2 = self:AddComponent(BuildInfo, "BuildList/build2")
  self.build3 = self:AddComponent(BuildInfo, "BuildList/build3")
  self.build4 = self:AddComponent(BuildInfo, "BuildList/build4")
end

function UILWSeasonServerDetailItemAlliance:OnDestroy()
  self.flag = nil
  self.name_txt = nil
  self.alliance_rank_txt = nil
  self.alliance_txt = nil
  self.build1 = nil
  self.build2 = nil
  self.build3 = nil
  self.build4 = nil
  base.OnDestroy(self)
end

function UILWSeasonServerDetailItemAlliance:ReInit(index, data, serverId)
  self.data = data
  self.serverId = serverId
  self.flag:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, data.icon))
  self.name_txt:SetText(UIUtil.FormatServerAllianceName(data.serverId, data.abbr, data.name))
  self.alliance_rank_txt:SetText(Localization:GetString("s1_zone_info_ui08") .. data.allianceRank)
  self.alliance_txt:SetText(Localization:GetString("s1_zone_info_ui10") .. string.GetFormattedStr2(toInt(data.score)))
  local allianceFortressArr = data.allianceFortressArr or {}
  self.build1:ReInit(92000, allianceFortressArr)
  self.build2:ReInit(93000, allianceFortressArr)
  self.build3:ReInit(94000, allianceFortressArr)
  self.build4:ReInit(95000, allianceFortressArr)
end

return UILWSeasonServerDetailItemAlliance
