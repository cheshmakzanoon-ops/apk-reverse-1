local DominatorRankShowTemplate = BaseClass("DominatorRankShowTemplate")
local Localization = CS.GameEntry.Localization

function DominatorRankShowTemplate:__init()
  self.id = 0
  self.group_id = 0
  self.star_level = 0
  self.max_level = 0
  self.star_key = ""
  self.rank_pic = 0
  self.dominator_appearance = 0
  self.pic_path = ""
  self.timeline_path = ""
  self.rank_preview_level = 0
  self.train_show_perfab = ""
end

function DominatorRankShowTemplate:__delete()
  self.id = nil
  self.group_id = nil
  self.star_level = nil
  self.max_level = nil
  self.star_key = nil
  self.rank_pic = nil
  self.dominator_appearance = nil
  self.pic_path = nil
  self.timeline_path = nil
  self.rank_preview_level = nil
  self.train_show_perfab = nil
end

function DominatorRankShowTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.group_id = rowData:getValue("group_id") or 0
  self.star_level = rowData:getValue("star_level") or 0
  self.max_level = rowData:getValue("max_level") or 0
  self.star_key = rowData:getValue("star_key") or ""
  self.rank_pic = rowData:getValue("rank_pic") or 0
  self.dominator_appearance = rowData:getValue("dominator_appearance") or 0
  self.pic_path = rowData:getValue("pic_path") or ""
  self.timeline_path = rowData:getValue("timeline_path") or ""
  self.rank_preview_level = rowData:getValue("rank_preview_level") or 0
  self.train_show_perfab = rowData:getValue("train_show_perfab") or ""
end

function DominatorRankShowTemplate:IsMaxBigRank()
  local max = DataCenter.DominatorTemplateManager:GetMaxBigLevelRankShowTemplateByGroup(self.group_id)
  if max then
    return self.star_level >= max.star_level
  end
  return false
end

function DominatorRankShowTemplate:GetName()
  return Localization:GetString(self.star_key)
end

function DominatorRankShowTemplate:GetRankIconPathBig()
  return string.format(LoadPath.UILWDominatorRankShowBigIconPath, self.rank_pic)
end

local DOMINATOR_RANK_PATH = "Assets/Main/Sprites/UI/UIHeroCommon/ljq_zhuzai_duanwei_0%d_s.png"

function DominatorRankShowTemplate:GetRankIconPathSmall()
  return string.format(DOMINATOR_RANK_PATH, self.rank_pic)
end

function DominatorRankShowTemplate:GetHeadIconPath()
  return self.pic_path
end

function DominatorRankShowTemplate:GetMaxLevelRankTemplate()
  return DataCenter.DominatorTemplateManager:GetMaxLevelRankTemplateByRankShowId(self.id)
end

function DominatorRankShowTemplate:GetMinLevelRankTemplate()
  return DataCenter.DominatorTemplateManager:GetMinLevelRankTemplateByRankShowId(self.id)
end

function DominatorRankShowTemplate:GetPreviewShowLevelText()
  return "Lv." .. self.rank_preview_level
end

function DominatorRankShowTemplate:GetShowAppearanceId()
  return self.dominator_appearance
end

return DominatorRankShowTemplate
