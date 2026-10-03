local CampScienceData = BaseClass("CampScienceData")
local Localization = CS.GameEntry.Localization

function CampScienceData:__init()
  self.config = nil
  self.scienceId = nil
  self.maxLevel = nil
  self.icon = nil
  self.name = nil
  self.info = nil
  self.position = nil
  self.rolation = nil
  self.currentPro = 0
  self.curLevel = 0
  self.needPro = 0
  self.resource = 0
  self.resourceNum = 0
  self.nextPara2 = ""
  self.para1 = ""
  self.para2 = ""
  self.camp_map_effect = ""
  self.camp_map_effect_num = ""
  self.science_condition = ""
  self.buff_type = nil
  self.expAdd = 0
end

function CampScienceData:__delete()
  self.config = nil
  self.scienceId = nil
  self.maxLevel = nil
  self.icon = nil
  self.name = nil
  self.info = nil
  self.position = nil
  self.rolation = nil
  self.currentPro = nil
  self.curLevel = nil
  self.needPro = nil
  self.resource = nil
  self.resourceNum = nil
  self.nextPara2 = nil
  self.para1 = nil
  self.para2 = nil
  self.camp_map_effect = nil
  self.camp_map_effect_num = nil
  self.science_condition = nil
  self.buff_type = nil
  self.expAdd = nil
end

function CampScienceData:ParseConfig(data)
  self.config = data
  self.scienceId = data.id
  self.maxLevel = data.max_lv
  self.icon = data.icon
  self.name = data.name
  self.info = data.info
  self.position = data.position
  self.rolation = data.relation
  self:RefreshConfig()
end

function CampScienceData:ParseData(message)
  if message == nil then
    return
  end
  if message.exp ~= nil then
    self.currentPro = message.exp
  end
  if message.level ~= nil then
    self.curLevel = message.level
  end
  self:RefreshConfig()
end

function CampScienceData:GetDetailConfigId()
  return self.scienceId + self.curLevel
end

function CampScienceData:RefreshConfig()
  local detailConfig = DataCenter.CampScienceTemplateManager:GeCampScienceDetailTemplate(self:GetDetailConfigId())
  self.science_condition = detailConfig.condition
  self.para1 = detailConfig.effectKey
  self.para2 = detailConfig.effectNum
  self.camp_map_effect = detailConfig.camp_map_effect
  self.camp_map_effect_num = detailConfig.camp_map_effect_num
  self.needPro = detailConfig.maxProNum
  self.resource = detailConfig.resource
  self.resourceNum = detailConfig.donate_price_start
  self.buff_type = detailConfig.buff_type
  self.expAdd = detailConfig.expAdd
  if self.curLevel < self.maxLevel then
    self.nextPara2 = nil
    local nextDetailConfig = DataCenter.CampScienceTemplateManager:GeCampScienceDetailTemplate(self:GetDetailConfigId() + 1)
    if nextDetailConfig ~= nil then
      self.nextPara2 = nextDetailConfig.effectNum
    end
  end
end

function CampScienceData:GetDesc()
  if self.config ~= nil then
    return self.config:GetDesc()
  end
end

function CampScienceData:GetInfoText(curLevel)
  if string.IsNullOrEmpty(self.info) then
    return ""
  end
  
  local function ProcessValueText(str)
    local strArray = string.split_ss_array(str, ";")
    if 2 <= #strArray then
      local strType = tonumber(strArray[1])
      if strType == 1 then
        return strArray[2] or ""
      elseif strType == 2 then
        if #strArray == 3 then
          return Localization:GetString(strArray[2], strArray[3])
        else
          return Localization:GetString(strArray[2])
        end
      end
    end
    return ""
  end
  
  local info_vec = string.split_ss_array(self.info, "|")
  local infoIndex = 1
  if 1 < #info_vec then
    infoIndex = curLevel + 1
  end
  return ProcessValueText(info_vec[infoIndex])
end

function CampScienceData:GetIsOO()
  return self.expAdd == 0 and 0 < self.needPro
end

function CampScienceData:IsMax()
  return self.curLevel >= self.maxLevel
end

return CampScienceData
