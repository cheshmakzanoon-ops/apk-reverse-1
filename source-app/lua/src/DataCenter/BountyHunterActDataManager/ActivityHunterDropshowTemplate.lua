local ActivityHunterDropshowTemplate = BaseClass("ActivityHunterDropshowTemplate")
local Localization = CS.GameEntry.Localization
local Const = require("UI/LWUIActBountyHunter/LWUIActBountyHunterRules/LWUIActBountyHunterRulesConstant")

function ActivityHunterDropshowTemplate:__init()
  self.id = 0
  self.group_id = 0
  self.type = 0
  self.type_name = ""
  self.type_order = 0
  self.type_desc = ""
  self.para1 = ""
  self.para2 = ""
  self.para3 = ""
  self.para4 = ""
  self.drop_show = ""
  self.drop_show_2 = ""
  self.order = 0
end

function ActivityHunterDropshowTemplate:__delete()
  self.id = nil
  self.group_id = nil
  self.type = nil
  self.type_name = nil
  self.type_order = nil
  self.type_desc = nil
  self.para1 = nil
  self.para2 = nil
  self.para3 = nil
  self.para4 = nil
  self.drop_show = nil
  self.drop_show_2 = nil
  self.order = nil
end

function ActivityHunterDropshowTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.group_id = rowData:getValue("group_id") or 0
  self.type = rowData:getValue("type") or 0
  self.type_name = rowData:getValue("type_name") or ""
  self.type_order = rowData:getValue("type_order") or 0
  self.type_desc = rowData:getValue("type_desc") or ""
  self.para1 = rowData:getValue("para1") or ""
  self.para2 = rowData:getValue("para2") or ""
  self.para3 = rowData:getValue("para3") or ""
  self.para4 = rowData:getValue("para4") or ""
  self.drop_show = rowData:getValue("drop_show") or ""
  self.drop_show_2 = rowData:getValue("drop_show_2") or ""
  self.order = rowData:getValue("order") or 0
end

function ActivityHunterDropshowTemplate:GetTitleText()
  if not string.IsNullOrEmpty(self.type_name) then
    return Localization:GetString(self.type_name)
  end
  return ""
end

function ActivityHunterDropshowTemplate:GetSubTitleText()
  if self.type == Const.Type.Monster_Refresh then
    return "100%"
  end
  return ""
end

function ActivityHunterDropshowTemplate:GetDesText()
  if not string.IsNullOrEmpty(self.type_desc) then
    return Localization:GetString(self.type_desc)
  end
  return ""
end

function ActivityHunterDropshowTemplate:GetPara1Data()
  local res = {}
  if not string.IsNullOrEmpty(self.para1) then
    local para1Split1 = string.split(self.para1, "|")
    for i, v in ipairs(para1Split1) do
      local para1Split2 = string.split(v, ";")
      if #para1Split2 == 2 then
        table.insert(res, tonumber(para1Split2[2]))
      end
    end
  end
  return res
end

function ActivityHunterDropshowTemplate:GetPara2Data()
  local res = {}
  if not string.IsNullOrEmpty(self.para2) then
    local para1Split1 = string.split(self.para2, "|")
    for i, v in ipairs(para1Split1) do
      local para1Split2 = string.split(v, ";")
      if #para1Split2 == 3 then
        local data = {
          rewardType = tonumber(para1Split2[1]),
          itemId = tonumber(para1Split2[2]),
          count = tonumber(para1Split2[3])
        }
        table.insert(res, data)
      end
    end
  end
  return res
end

function ActivityHunterDropshowTemplate:GetPara3Data()
  local res = {}
  if not string.IsNullOrEmpty(self.para3) then
    local para1Split1 = string.split(self.para3, "|")
    for i, v in ipairs(para1Split1) do
      local para1Split2 = string.split(v, ";")
      if #para1Split2 == 3 then
        local data = {
          rewardType = tonumber(para1Split2[1]),
          itemId = tonumber(para1Split2[2]),
          count = tonumber(para1Split2[3])
        }
        table.insert(res, data)
      end
    end
  end
  return res
end

function ActivityHunterDropshowTemplate:GetPara4Data()
  local res = {}
  if not string.IsNullOrEmpty(self.para4) then
    local para1Split1 = string.split(self.para4, "|")
    for i, v in ipairs(para1Split1) do
      local para1Split2 = string.split(v, ";")
      if #para1Split2 == 3 then
        local data = {
          rewardType = tonumber(para1Split2[1]),
          itemId = tonumber(para1Split2[2]),
          count = tonumber(para1Split2[3])
        }
        table.insert(res, data)
      end
    end
  end
  return res
end

function ActivityHunterDropshowTemplate:GetPara3ProbabilityData()
  local res = {}
  if not string.IsNullOrEmpty(self.drop_show) then
    local para1Split1 = string.split(self.drop_show, "|")
    for i, v in ipairs(para1Split1) do
      table.insert(res, checknumber(v))
    end
  end
  return res
end

function ActivityHunterDropshowTemplate:GetPara4ProbabilityData()
  local res = {}
  if not string.IsNullOrEmpty(self.drop_show_2) then
    local para1Split1 = string.split(self.drop_show_2, "|")
    for i, v in ipairs(para1Split1) do
      table.insert(res, checknumber(v))
    end
  end
  return res
end

function ActivityHunterDropshowTemplate:GetIconBgPath(id)
  if self.type == Const.Type.Minion_Reward or self.type == Const.Type.Fly_Reward or self.type == Const.Type.Elite_Reward or self.type == Const.Type.Monster_Refresh or self.type == Const.Type.Boss_Reward then
    local lineData = LocalController:instance():getLine(TableName.Bounty_Monster, id)
    if lineData then
      return lineData.head_bg
    end
  elseif self.type == Const.Type.Event_Refresh then
    local lineData = LocalController:instance():getLine(TableName.Bounty_Hunter_Event, id)
    if lineData then
      return lineData.pic_di
    end
  elseif self.type == Const.Type.Box_Reward then
    local lineData = LocalController:instance():getLine(TableName.Bounty_Hunter_FreeChest, id)
    if lineData then
      return lineData.pic_di
    end
  end
end

function ActivityHunterDropshowTemplate:GetIconPath(id)
  if self.type == Const.Type.Minion_Reward or self.type == Const.Type.Fly_Reward or self.type == Const.Type.Elite_Reward or self.type == Const.Type.Monster_Refresh or self.type == Const.Type.Boss_Reward then
    local lineData = LocalController:instance():getLine(TableName.Bounty_Monster, id)
    if lineData then
      return lineData.head_icon
    end
  elseif self.type == Const.Type.Event_Refresh then
    local lineData = LocalController:instance():getLine(TableName.Bounty_Hunter_Event, id)
    if lineData then
      return lineData.small_pic
    end
  elseif self.type == Const.Type.Box_Reward then
    local lineData = LocalController:instance():getLine(TableName.Bounty_Hunter_FreeChest, id)
    if lineData then
      local goodsId = checknumber(lineData.goods)
      return DataCenter.ItemTemplateManager:GetIconPath(goodsId)
    end
  end
end

function ActivityHunterDropshowTemplate:GetTipsTitle(id)
  if self.type == Const.Type.Minion_Reward or self.type == Const.Type.Fly_Reward or self.type == Const.Type.Elite_Reward or self.type == Const.Type.Monster_Refresh or self.type == Const.Type.Boss_Reward then
    local lineData = LocalController:instance():getLine(TableName.Bounty_Monster, id)
    if lineData then
      return Localization:GetString(lineData.name)
    end
  elseif self.type == Const.Type.Event_Refresh then
    local lineData = LocalController:instance():getLine(TableName.Bounty_Hunter_Event, id)
    if lineData then
      return Localization:GetString(lineData.name)
    end
  end
end

function ActivityHunterDropshowTemplate:GetTipsDesc(id)
  if self.type == Const.Type.Minion_Reward or self.type == Const.Type.Fly_Reward or self.type == Const.Type.Elite_Reward or self.type == Const.Type.Monster_Refresh or self.type == Const.Type.Boss_Reward then
    local lineData = LocalController:instance():getLine(TableName.Bounty_Monster, id)
    if lineData then
      return Localization:GetString(lineData.desc)
    end
  elseif self.type == Const.Type.Event_Refresh then
    local lineData = LocalController:instance():getLine(TableName.Bounty_Hunter_Event, id)
    if lineData then
      return Localization:GetString(lineData.desc)
    end
  end
end

function ActivityHunterDropshowTemplate:GetMonsterNameText()
  if self.type == Const.Type.Minion_Reward then
    return Localization:GetString("activity_hunter_dropshow_monstertype1")
  elseif self.type == Const.Type.Fly_Reward then
    return Localization:GetString("activity_hunter_dropshow_monstertype2")
  elseif self.type == Const.Type.Boss_Reward then
    return Localization:GetString("activity_hunter_dropshow_monstertype3")
  elseif self.type == Const.Type.Elite_Reward then
    return Localization:GetString("activity_hunter_dropshow_monstertype2")
  end
  return Localization:GetString("activity_hunter_dropshow_monstertype1")
end

function ActivityHunterDropshowTemplate:GetBannerPath(id)
  local color = 0
  if self.type == Const.Type.Minion_Reward or self.type == Const.Type.Fly_Reward or self.type == Const.Type.Elite_Reward or self.type == Const.Type.Monster_Refresh or self.type == Const.Type.Boss_Reward then
    local lineData = LocalController:instance():getLine(TableName.Bounty_Monster, id)
    if lineData then
      color = tonumber(lineData.color)
    end
  elseif self.type == Const.Type.Box_Reward then
    local lineData = LocalController:instance():getLine(TableName.Bounty_Hunter_FreeChest, id)
    if lineData then
      color = tonumber(lineData.color)
    end
  end
  if color and 0 < color then
    if color == 1 then
      return "Assets/Main/Sprites/UI/BountyHunter/Rules/lrb_SJLR_gailv_boss_bai.png"
    elseif color == 2 then
      return "Assets/Main/Sprites/UI/BountyHunter/Rules/lrb_SJLR_gailv_boss_lv.png"
    elseif color == 3 then
      return "Assets/Main/Sprites/UI/BountyHunter/Rules/lrb_SJLR_gailv_boss_lan.png"
    elseif color == 4 then
      return "Assets/Main/Sprites/UI/BountyHunter/Rules/lrb_SJLR_gailv_boss_zi.png"
    elseif color == 5 then
      return "Assets/Main/Sprites/UI/BountyHunter/Rules/lrb_SJLR_gailv_boss_cheng.png"
    elseif color == 6 then
      return "Assets/Main/Sprites/UI/BountyHunter/Rules/lrb_SJLR_gailv_boss_hong.png"
    end
  end
end

function ActivityHunterDropshowTemplate:IsShowProbabilityTitle()
  if self.type == Const.Type.Box_Reward then
    return false
  end
  return true
end

return ActivityHunterDropshowTemplate
