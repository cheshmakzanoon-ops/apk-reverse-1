local ActivityRevivalScoreShowTemplate = BaseClass("ActivityRevivalScoreShowTemplate")

function ActivityRevivalScoreShowTemplate:__init()
  self.id = 0
  self.score_pic = ""
  self.score_des = ""
  self.score_value = ""
  self.score_gototype = 0
  self.score_gototype_value = ""
  self.score_extra_value = ""
end

function ActivityRevivalScoreShowTemplate:__delete()
  self.id = nil
  self.score_pic = nil
  self.score_des = nil
  self.score_value = nil
  self.score_gototype = nil
  self.score_gototype_value = nil
  self.score_extra_value = nil
  self.extraValueMap = nil
end

function ActivityRevivalScoreShowTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.score_pic = rowData:getValue("score_pic") or ""
  self.score_des = rowData:getValue("score_des") or ""
  self.score_value = rowData:getValue("score_value") or ""
  self.score_gototype = rowData:getValue("score_gototype") or 0
  self.score_gototype_value = rowData:getValue("score_gototype_value") or ""
  self.score_extra_value = rowData:getValue("score_extra_value") or ""
end

function ActivityRevivalScoreShowTemplate:GetExtraValue(key)
  if self.extraValueMap == nil then
    self.extraValueMap = {}
    if not string.IsNullOrEmpty(self.score_extra_value) then
      local array = string.split(self.score_extra_value, "|")
      for _, v in ipairs(array) do
        local t = string.split(v, ";")
        if #t == 2 then
          local k = tonumber(t[1]) or 0
          local value = t[2]
          self.extraValueMap[k] = value
        end
      end
    end
  end
  return self.extraValueMap[key]
end

return ActivityRevivalScoreShowTemplate
