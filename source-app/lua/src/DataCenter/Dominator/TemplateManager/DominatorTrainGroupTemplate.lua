local DominatorTrainGroupTemplate = BaseClass("DominatorTrainGroupTemplate")
local Localization = CS.GameEntry.Localization

function DominatorTrainGroupTemplate:__init()
  self.id = 0
  self.type = 0
  self.level_interval = ""
  self.max_level = 0
  self.banner_pic = ""
  self.train_key = ""
  self.overview_pic = ""
  self.hero_show_id = ""
end

function DominatorTrainGroupTemplate:__delete()
  self.id = nil
  self.type = nil
  self.level_interval = nil
  self.max_level = nil
  self.banner_pic = nil
  self.train_key = nil
  self.overview_pic = nil
  self.hero_show_id = nil
end

function DominatorTrainGroupTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.type = rowData:getValue("type") or 0
  self.level_interval = rowData:getValue("level_interval") or ""
  self.max_level = rowData:getValue("max_level") or 0
  self.banner_pic = rowData:getValue("banner_pic") or ""
  self.train_key = rowData:getValue("train_key") or ""
  self.overview_pic = rowData:getValue("overview_pic") or ""
  self.hero_show_id = rowData:getValue("hero_show_id") or ""
end

function DominatorTrainGroupTemplate:IsMainGroup()
  return self.type == DominatorTrainGroupType.Main
end

function DominatorTrainGroupTemplate:GetName()
  return Localization:GetString(self.train_key)
end

function DominatorTrainGroupTemplate:GetIconPath()
  return self.banner_pic
end

function DominatorTrainGroupTemplate:GetBasicPageIconPath()
  return self.overview_pic
end

function DominatorTrainGroupTemplate:GetTrainSceneHeroAppearanceIdList()
  if not string.IsNullOrEmpty(self.hero_show_id) then
    local strSplit = string.split(self.hero_show_id, ";")
    if 0 < #strSplit then
      local res = {}
      for i, v in ipairs(strSplit) do
        table.insert(res, tonumber(v) or 0)
      end
      return res
    end
  end
end

return DominatorTrainGroupTemplate
