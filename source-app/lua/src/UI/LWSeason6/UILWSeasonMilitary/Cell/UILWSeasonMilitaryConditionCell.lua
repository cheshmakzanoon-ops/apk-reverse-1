local base_path = "base"
local p_img_condition_icon_path = "base/p_img_condition_icon"
local p_text_condition_desc_path = "base/p_text_condition_desc"
local p_go_finish_path = "base/p_go_finish"
local base = UIBaseContainer
local UILWSeasonMilitaryConditionCell = BaseClass("UILWSeasonMilitaryConditionCell", UIBaseContainer)

function UILWSeasonMilitaryConditionCell:ComponentDefine()
  self.base = self:AddComponent(UIImage, base_path)
  self.p_img_condition_icon = self:AddComponent(UIImage, p_img_condition_icon_path)
  self.p_text_condition_desc = self:AddComponent(UITextMeshProUGUIEx, p_text_condition_desc_path)
  self.p_go_finish = self:AddComponent(UIImage, p_go_finish_path)
end

function UILWSeasonMilitaryConditionCell:ComponentDestroy()
  self.base = nil
  self.p_img_condition_icon = nil
  self.p_text_condition_desc = nil
  self.p_go_finish = nil
end

function UILWSeasonMilitaryConditionCell:DataDefine()
  self.IconTypeScore = "Assets/Main/SeasonRes/S6/Sprites/Military/ljq_s6junxian_jianying_jungong.png"
  self.IconTypeBuild = "Assets/Main/SeasonRes/S6/Sprites/Military/ljq_s6junxian_jianying_chengshi.png"
  self.IconTypeRank = "Assets/Main/SeasonRes/S6/Sprites/Military/ljq_s6junxian_jianying_paihang.png"
  self.ValidProgressColor = "#099b4a"
  self.InvalidProgressColor = "#f53c3d"
  self.ValidBaseColor = "#b9eab7"
  self.InvalidBaseColor = "#f4dbcb"
end

function UILWSeasonMilitaryConditionCell:DataDestroy()
end

function UILWSeasonMilitaryConditionCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWSeasonMilitaryConditionCell:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonMilitaryConditionCell:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
  end
end

function UILWSeasonMilitaryConditionCell:InitData(data)
  if data ~= nil then
    self.Data = data
    self.InfoData = DataCenter.SeasonMilitaryManager.InfoData
    return true
  end
  return false
end

function UILWSeasonMilitaryConditionCell:InitUi()
  local valid, progressText = self:GetProgress()
  self.p_text_condition_desc:SetText(string.format("%s %s", self:GetDesc(), progressText))
  self.p_img_condition_icon:LoadSpriteAsync(self:GetIcon())
  self.p_go_finish:SetActive(valid)
  self.base:SetColorHex(valid and self.ValidBaseColor or self.InvalidBaseColor)
end

function UILWSeasonMilitaryConditionCell:GetIcon()
  if self.Data ~= nil then
    if self.Data.TaskType == 0 then
      return self.IconTypeScore
    elseif self.Data.TaskType == 1 or self.Data.TaskType == 2 then
      return self.IconTypeBuild
    elseif self.Data.TaskType == 3 then
      return self.IconTypeRank
    end
  end
  return ""
end

function UILWSeasonMilitaryConditionCell:GetDesc()
  if self.Data ~= nil then
    if self.Data.TaskType == 0 then
      return CS.GameEntry.Localization:GetString(self.Data.Cell.unlock_score_desc, string.GetFormattedSeparatorNum(self.Data.Cell.unlock_score))
    elseif self.Data.TaskType == 1 or self.Data.TaskType == 2 then
      return CS.GameEntry.Localization:GetString(self.Data.Cell.unlock_condition_desc, self.Data.Cell.unlock_condition_para)
    elseif self.Data.TaskType == 3 then
      local needValue = checknumber(self.Data.Cell.rank_value)
      local curRankValue = self.InfoData:GetRank()
      if 0 < curRankValue then
        curRankValue = self:GetColoredText(string.GetFormattedSeparatorNum(curRankValue), needValue >= curRankValue)
      else
        curRankValue = self:GetColoredText(CS.GameEntry.Localization:GetString("2800058"), false)
      end
      return CS.GameEntry.Localization:GetString(self.Data.Cell.rank_desc, self.Data.Cell.rank_value, curRankValue)
    end
  end
  return ""
end

function UILWSeasonMilitaryConditionCell:GetProgress()
  if self.Data ~= nil then
    local curValue, needValue = 0, 0
    if self.Data.TaskType == 0 then
      curValue = self.InfoData:GetScore()
      needValue = checknumber(self.Data.Cell.unlock_score)
    elseif self.Data.TaskType == 1 or self.Data.TaskType == 2 then
      curValue = self.InfoData:GetTaskValue(self.Data.TaskType)
      needValue = checknumber(self.Data.Cell.unlock_condition_para)
    elseif self.Data.TaskType == 3 then
      curValue = self.InfoData:GetRank()
      needValue = checknumber(self.Data.Cell.rank_value)
      return 0 < curValue and curValue <= needValue, ""
    end
    local valid = curValue >= needValue
    local curValueStr = self:GetColoredText(string.GetFormattedSeparatorNum(curValue), valid)
    return valid, string.format("(%s/%s)", curValueStr, string.GetFormattedSeparatorNum(needValue))
  end
end

function UILWSeasonMilitaryConditionCell:GetColoredText(text, valid)
  local color = valid and self.ValidProgressColor or self.InvalidProgressColor
  return string.format("<color=%s>%s</color>", color, text)
end

function UILWSeasonMilitaryConditionCell:IsValid()
  local valid, _ = self:GetProgress()
  return valid
end

return UILWSeasonMilitaryConditionCell
