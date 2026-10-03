local SeasonPhotoTemplate = BaseClass("SeasonPhotoTemplate")
local defaultFrame = "Assets/Main/SeasonRes/Shared/Sprites/UISeasonPhoto/ljq_s3_heying_touxiangkuanglv1.png"

function SeasonPhotoTemplate:__init()
  self.id = 0
  self.photo_name = ""
  self.photo_icon = ""
  self.season_alliance_photo_size = {}
  self.season_alliance_photo_border = {}
  self.season_alliance_photo_task = {}
  self.photo_cd = 0
  self.message_board_cd = 0
  self.character_limit = 0
  self.icon_size = {}
  self.icon_size_builders_alliance = 3
  self.icon_size_builders_alliance_leader = 6
  self.tier_icon = {}
  self.tier_icon_builders_alliance = ""
  self.qr_code = ""
  self.season_icon = ""
end

function SeasonPhotoTemplate:__delete()
  self.id = nil
  self.photo_name = nil
  self.photo_icon = nil
  self.season_alliance_photo_size = nil
  self.season_alliance_photo_border = nil
  self.season_alliance_photo_task = nil
  self.photo_cd = nil
  self.message_board_cd = nil
  self.character_limit = nil
  self.icon_size = nil
  self.icon_size_builders_alliance = nil
  self.icon_size_builders_alliance_leader = nil
  self.tier_icon = nil
  self.tier_icon_builders_alliance = nil
  self.qr_code = nil
  self.season_icon = nil
end

function SeasonPhotoTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.photo_name = rowData:getValue("photo_name") or ""
  self.photo_icon = rowData:getValue("photo_icon") or ""
  local param = rowData:getValue("season_alliance_photo_size") or ""
  param = string.split(param, "|")
  for i, v in ipairs(param) do
    self.season_alliance_photo_size[i] = toInt(v)
  end
  param = rowData:getValue("season_alliance_photo_border") or ""
  param = string.split(param, "|")
  for i, v in ipairs(param) do
    self.season_alliance_photo_border[i] = toInt(v)
  end
  param = rowData:getValue("season_alliance_photo_task") or ""
  param = string.split(param, "|")
  for i, v in ipairs(param) do
    self.season_alliance_photo_task[i] = toInt(v)
  end
  self.photo_cd = tonumber(rowData:getValue("photo_cd") or 0)
  self.message_board_cd = tonumber(rowData:getValue("message_board_cd") or 0)
  self.character_limit = tonumber(rowData:getValue("character_limit") or 0)
  param = rowData:getValue("icon_size") or ""
  param = string.split(param, "|")
  for i, v in ipairs(param) do
    local temp = string.split(v, ";")
    self.icon_size[i] = {
      type = tonumber(temp[1] or 0),
      size = tonumber(temp[2] or 3),
      frame = temp[3] or ""
    }
  end
  param = rowData:getValue("icon_size_builders_alliance") or ""
  param = string.split(param, "|")
  for i, v in ipairs(param) do
    local temp = string.split(v, ";")
    if tonumber(temp[1] or 0) == 1 then
      self.icon_size_builders_alliance_leader = tonumber(temp[2] or 6)
    else
      self.icon_size_builders_alliance = tonumber(temp[2] or 3)
    end
  end
  param = rowData:getValue("tier_icon") or ""
  param = string.split(param, "|")
  for i, v in ipairs(param) do
    local temp = string.split(v, ";")
    self.tier_icon[i] = {
      rank = toInt(temp[1]),
      icon = temp[2] or ""
    }
  end
  self.tier_icon_builders_alliance = rowData:getValue("tier_icon_builders_alliance") or ""
  self.qr_code = rowData:getValue("qr_code") or ""
  self.season_icon = rowData:getValue("season_icon") or ""
end

function SeasonPhotoTemplate:GetDefaultSizeId(memberSize)
  if self.season_alliance_photo_size then
    local ret
    for k, configId in pairs(self.season_alliance_photo_size) do
      local line = LocalController:instance():getLine(TableName.LW_SEASON_PHOTO_SIZE, configId)
      local limit = line and toInt(line.limit) or 0
      if memberSize <= limit and (ret == nil or ret == 0 or configId < ret) then
        ret = configId
      end
    end
    return ret or self.season_alliance_photo_size[1] or 30003
  end
  return 30003
end

function SeasonPhotoTemplate:GetDefaultBorderId(settleRank, seasonRewardConfigId)
  if self.season_alliance_photo_border then
    local nSettleRank = toInt(settleRank)
    local ret = self.season_alliance_photo_border[1]
    for k, configId in pairs(self.season_alliance_photo_border) do
      local line = LocalController:instance():getLine(TableName.LW_SEASON_PHOTO_BORDER, configId)
      if line and line.condition then
        local theType, theLevel = string.match(line.condition, "([^;]+);([^;]+)")
        if theType == "2" then
          if ret == nil or ret == 0 or configId > ret then
            ret = configId
          end
        elseif theType == "1" then
          if theLevel then
            local theLevelMin, theLevelMax = string.match(theLevel, "([^-]+)-([^-]+)")
            if theLevelMin and theLevelMax then
              if nSettleRank >= toInt(theLevelMin) and nSettleRank <= toInt(theLevelMax) and (ret == nil or ret == 0 or configId > ret) then
                ret = configId
              end
            elseif theLevel ~= "" and theLevel ~= "0" and nSettleRank >= toInt(theLevel) and (ret == nil or ret == 0 or configId > ret) then
              ret = configId
            end
          end
        elseif theType == "3" then
          if seasonRewardConfigId then
            local rewardIds = string.split(theLevel, ",")
            for _, rid in ipairs(rewardIds) do
              if toInt(rid) == seasonRewardConfigId then
                if ret == nil or ret == 0 or configId > ret then
                  ret = configId
                end
                break
              end
            end
          end
        elseif ret == nil or ret == 0 or configId > ret then
          ret = configId
        end
      end
    end
    return ret
  end
  return 30001
end

function SeasonPhotoTemplate:GetHeadSize(rewardType, uid, leaderUid)
  if not rewardType or rewardType <= 0 then
    if leaderUid == uid then
      return self.icon_size_builders_alliance_leader, defaultFrame
    end
    return self.icon_size_builders_alliance, defaultFrame
  end
  for i, v in ipairs(self.icon_size) do
    if v.type == rewardType then
      return v.size, v.frame or defaultFrame
    end
  end
  return self.icon_size_builders_alliance, defaultFrame
end

function SeasonPhotoTemplate:GetTierIcon(rank, seasonRewardConfigId, settleType)
  if settleType and settleType == 2 then
    return self.tier_icon_builders_alliance
  end
  local rankIcon, tierIndex
  if seasonRewardConfigId and 0 < seasonRewardConfigId then
    local line = LocalController:instance():getLine(TableName.LW_Season_Alliance_Reward, seasonRewardConfigId)
    if line and line.tier then
      tierIndex = toInt(line.tier)
    end
  end
  if not tierIndex then
    local season_group = "0"
    local config = DataCenter.SeasonDataManager:GetSeasonConfig()
    if config ~= nil then
      season_group = tostring(config.alliance_reward)
    end
    LocalController:instance():visitTable(TableName.LW_Season_Alliance_Reward, function(id, line)
      if tierIndex == nil and tostring(line.season_group) == season_group then
        local theType, theMinValue, theMaxValue = string.match(line.rank_condition, "([^;]+);([^;]+);([^;]+)")
        if theType and theMinValue and theMaxValue and rank >= toInt(theMinValue) and rank <= toInt(theMaxValue) then
          tierIndex = toInt(line.tier)
        end
      end
    end)
  end
  for i, v in ipairs(self.tier_icon) do
    rankIcon = v.icon
    if v.rank == tierIndex then
      break
    end
  end
  return rankIcon
end

return SeasonPhotoTemplate
