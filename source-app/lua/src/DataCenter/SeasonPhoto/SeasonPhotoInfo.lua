local SeasonPhotoInfo = BaseClass("SeasonPhotoInfo")
local rapidjson = require("rapidjson")

function SeasonPhotoInfo:__init()
  self.allianceId = ""
  self.season = 0
  self.seasonConfigId = 0
  self.photoConfigId = 0
  self.settleType = 0
  self.leaderUid = ""
  self.serverId = 0
  self.allianceName = ""
  self.abbr = ""
  self.slotId = 0
  self.icon = "1"
  self.picVer = 0
  self.settleRank = 0
  self.memberArr = {}
  self.picData = {}
end

function SeasonPhotoInfo:__delete()
  self.allianceId = nil
  self.season = nil
  self.seasonConfigId = nil
  self.photoConfigId = nil
  self.settleType = nil
  self.leaderUid = nil
  self.serverId = nil
  self.allianceName = nil
  self.abbr = nil
  self.icon = nil
  self.slotId = nil
  self.picVer = nil
  self.settleRank = nil
  self.memberArr = nil
  self.picData = nil
end

function SeasonPhotoInfo:UpdateData(message)
  if message == nil then
    return
  end
  if message.allianceId ~= nil then
    self.allianceId = message.allianceId
  end
  if message.season ~= nil then
    self.season = message.season
  end
  if message.seasonConfigId ~= nil then
    self.seasonConfigId = message.seasonConfigId
  end
  if message.photoConfigId ~= nil then
    self.photoConfigId = message.photoConfigId
  end
  if message.settleType ~= nil then
    self.settleType = message.settleType
  end
  if message.leaderUid ~= nil then
    self.leaderUid = message.leaderUid
  end
  if message.serverId ~= nil then
    self.serverId = message.serverId
  end
  if message.allianceName ~= nil then
    self.allianceName = message.allianceName
  end
  if message.abbr ~= nil then
    self.abbr = message.abbr
  end
  if message.icon ~= nil then
    self.icon = message.icon
  end
  if message.slotId ~= nil then
    self.slotId = message.slotId
  end
  if message.picVer ~= nil then
    self.picVer = message.picVer
  end
  if message.settleRank ~= nil then
    self.settleRank = message.settleRank
  end
  if message.seasonRewardConfigId ~= nil then
    self.seasonRewardConfigId = tonumber(message.seasonRewardConfigId)
  end
  if message.memberArr ~= nil then
    self.memberArr = message.memberArr
  end
  if message.picData ~= nil then
    self.picData = rapidjson.decode(message.picData)
  end
  self.id = DataCenter.SeasonPhotoManager:GetPhotoId(self.season, self.allianceId)
  if table.IsNullOrEmpty(self.picData) then
    self.picData = self:GetDefaultPicData()
  end
end

function SeasonPhotoInfo:GetConfigData()
  return DataCenter.SeasonPhotoTemplateManager:GetConfigData(self.photoConfigId)
end

function SeasonPhotoInfo:GetDefaultPicData()
  local config = DataCenter.SeasonPhotoTemplateManager:GetConfigData(self.photoConfigId)
  local picData = {}
  picData.sizeConfigId = config and config:GetDefaultSizeId(table.count(self.memberArr)) or 0
  picData.borderConfigId = config and config:GetDefaultBorderId(self.settleRank, self.seasonRewardConfigId) or 0
  picData.picUrl = ""
  picData.playerArr = {}
  return picData
end

function SeasonPhotoInfo:GetHeadSize(uid, rewardType, config)
  config = config or DataCenter.SeasonPhotoTemplateManager:GetConfigData(self.photoConfigId)
  if not config then
    return 3
  end
  return config:GetHeadSize(rewardType, uid, self.leaderUid)
end

function SeasonPhotoInfo:GetPhotoSize(picData)
  picData = picData or self.picData
  local config = DataCenter.SeasonPhotoTemplateManager:GetConfigDataSize(picData.sizeConfigId)
  if not config then
    return 10
  end
  return config.size or 10
end

function SeasonPhotoInfo:GetPhotoBorderConfig(picData)
  picData = picData or self.picData
  return DataCenter.SeasonPhotoTemplateManager:GetConfigDataBorder(picData.borderConfigId)
end

function SeasonPhotoInfo:GetMemberSelf()
  local selfUid = LuaEntry.Player.uid
  for i, v in ipairs(self.memberArr) do
    if v.uid == selfUid then
      return v
    end
  end
end

function SeasonPhotoInfo.getters:memberDic()
  if not self.memberArr then
    return {}
  end
  local memberDic = {}
  local config = DataCenter.SeasonPhotoTemplateManager:GetConfigData(self.photoConfigId)
  for i, member in ipairs(self.memberArr) do
    member.headSize, member.frame = self:GetHeadSize(member.uid, member.rewardType, config)
    memberDic[member.uid] = member
  end
  return memberDic
end

function SeasonPhotoInfo.getters:playerDic()
  local playerDic = {}
  if self.picData.playerArr then
    for i, v in ipairs(self.picData.playerArr) do
      playerDic[v.uid] = v
    end
  end
  return playerDic
end

function SeasonPhotoInfo:GetTempPicData()
  local picData = self.picData
  local playerArr = {}
  local tempData = {
    sizeConfigId = picData.sizeConfigId,
    borderConfigId = picData.borderConfigId,
    picUrl = picData.picUrl,
    playerArr = playerArr
  }
  local oldPlayerArr = picData and picData.playerArr
  if oldPlayerArr then
    for i, v in ipairs(oldPlayerArr) do
      playerArr[i] = {
        uid = v.uid,
        posX = v.posX,
        posY = v.posY,
        pic = v.pic,
        picVer = v.picVer
      }
    end
  end
  return tempData
end

function SeasonPhotoInfo:AddPlayerArr(player)
  local playerArr
  if self.picDataTemp then
    playerArr = self.picDataTemp.playerArr
  else
    playerArr = {}
    self.picDataTemp = {
      sizeConfigId = self.picData.sizeConfigId,
      borderConfigId = self.picData.borderConfigId,
      playerArr = playerArr
    }
    local oldPlayerArr = self.picData.playerArr
    if oldPlayerArr then
      for i, v in ipairs(oldPlayerArr) do
        playerArr[i] = v
      end
    end
  end
  return table.insert(playerArr, player)
end

function SeasonPhotoInfo:CheckPicCd(userSettleRecord, showTips_)
  if not userSettleRecord or not userSettleRecord.modifyPicTime then
    return true
  end
  local config = DataCenter.SeasonPhotoTemplateManager:GetConfigData(self.photoConfigId)
  if not config or not config.photo_cd then
    return true
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local deltaTime = userSettleRecord.modifyPicTime + config.photo_cd * 60000 - curTime
  if 0 < deltaTime then
    if showTips_ then
      UIUtil.ShowTips(CS.GameEntry.Localization:GetString("season_alliance_photo_tips_17", UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime)))
    end
    return false
  end
  return true
end

function SeasonPhotoInfo:CheckMessageCd(userSettleRecord, showTips_)
  if not userSettleRecord or not userSettleRecord.commentTime then
    return true
  end
  local config = DataCenter.SeasonPhotoTemplateManager:GetConfigData(self.photoConfigId)
  if not config or not config.message_board_cd then
    return true
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local deltaTime = userSettleRecord.commentTime + config.message_board_cd * 60000 - curTime
  if 0 < deltaTime then
    if showTips_ then
      UIUtil.ShowTips(CS.GameEntry.Localization:GetString("season_alliance_photo_tips_18", UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime)))
    end
    return false
  end
  return true
end

function SeasonPhotoInfo:GetTestPicData()
  local list, index = {}, 1
  local allianceMembers = DataCenter.AllianceMemberDataManager:GetAllMember()
  for uid, v in pairs(allianceMembers) do
    list[index] = {
      uid = uid,
      pic = v.pic,
      picVer = v.picVer,
      rewardIndex = math.random(1, 5)
    }
    index = index + 1
  end
  local count = math.random(10, 30)
  local picData = {}
  index = 1
  for uid, v in pairs(allianceMembers) do
    picData[index] = {
      uid = uid,
      pos = {x = 0, y = 0},
      pic = v.pic,
      picVer = v.picVer
    }
    index = index + 1
    if count < index then
      break
    end
  end
  return picData, list
end

function SeasonPhotoInfo:GetTestMemberData()
  local memberDic = {}
  for i, v in ipairs(data.list) do
    if v.rewardIndex == 4 then
      v.headSize = 5
    elseif v.rewardIndex == 5 then
      v.headSize = 8
    else
      v.headSize = 4
    end
    memberDic[v.uid] = v
  end
  return memberDic
end

return SeasonPhotoInfo
