local DominatorStoryShowTemplate = BaseClass("DominatorStoryShowTemplate")
local Localization = CS.GameEntry.Localization

function DominatorStoryShowTemplate:__init()
  self.id = 0
  self.group_id = 0
  self.title = ""
  self.sub_title = ""
  self.position_num = 0
  self.button_pic = ""
  self.story_key_1 = ""
  self.story_key_2 = ""
  self.story_key_3 = ""
  self.type = 0
  self.para1 = ""
  self.para2 = ""
  self.button_key = ""
end

function DominatorStoryShowTemplate:__delete()
  self.id = nil
  self.group_id = nil
  self.title = nil
  self.sub_title = nil
  self.position_num = nil
  self.button_pic = nil
  self.story_key_1 = nil
  self.story_key_2 = nil
  self.story_key_3 = nil
  self.type = nil
  self.para1 = nil
  self.para2 = nil
  self.button_key = nil
end

function DominatorStoryShowTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.group_id = rowData:getValue("group_id") or 0
  self.title = rowData:getValue("title") or ""
  self.sub_title = rowData:getValue("sub_title") or ""
  self.position_num = rowData:getValue("position_num") or 0
  self.button_pic = rowData:getValue("button_pic") or ""
  self.story_key_1 = rowData:getValue("story_key_1") or ""
  self.story_key_2 = rowData:getValue("story_key_2") or ""
  self.story_key_3 = rowData:getValue("story_key_3") or ""
  self.type = rowData:getValue("type") or 0
  self.para1 = rowData:getValue("para1") or ""
  self.para2 = rowData:getValue("para2") or ""
  self.button_key = rowData:getValue("button_key") or ""
end

function DominatorStoryShowTemplate:GetDetailTitle()
  return Localization:GetString(self.story_key_1)
end

function DominatorStoryShowTemplate:GetDetailMain()
  return Localization:GetString(self.story_key_2)
end

function DominatorStoryShowTemplate:GetDetailFinal()
  return Localization:GetString(self.story_key_3)
end

function DominatorStoryShowTemplate:GetOrder()
  return self.position_num
end

function DominatorStoryShowTemplate:GetLockedTipsText()
  if self.type == 1 then
    local splitStr = string.split(self.para2, "|")
    if #splitStr == 2 then
      return Localization:GetString(splitStr[1], splitStr[2])
    elseif #splitStr == 1 then
      return Localization:GetString(splitStr[1])
    end
  end
  return ""
end

return DominatorStoryShowTemplate
