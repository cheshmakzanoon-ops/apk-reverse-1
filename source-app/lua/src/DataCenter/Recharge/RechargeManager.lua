local RechargeManager = BaseClass("RechargeManager")
local RechargeTemplate = require("DataCenter.Recharge.RechargeTemplate")
local RechargeGiftShowTemplate = require("DataCenter/Recharge/RechargeGiftShowTemplate")
local Localization = CS.GameEntry.Localization
RechargeManager.GiftShowListType = {Single = 1, Multiple = 2}

function RechargeManager:__init()
  self.rechargeDatas = {}
  self.splitedPara1s = {}
  self.hasInitAllLine = false
  self.actMap = {}
  self.rechargeGiftShowTemplateDict = {}
  self.freeRewardInfoDic = {}
end

function RechargeManager:__delete()
  self.rechargeDatas = nil
  self.splitedPara1s = nil
  self.hasInitAllLine = false
  self.actMap = nil
  self.rechargeGiftShowTemplateDict = nil
end

function RechargeManager:InitMessage(data)
  self.freeRewardInfoDic = {}
  if data.freeRewardArr then
    for _, v in ipairs(data.freeRewardArr) do
      self:UpdateFreeRewardInfo(v.type, v.lastTime)
    end
  end
end

function RechargeManager:UpdateFreeRewardInfo(type, lastReceiveTime)
  self.freeRewardInfoDic[type] = lastReceiveTime
end

function RechargeManager:GetIsCanReceiveFreeReward(type)
  local lastReceiveTime = self.freeRewardInfoDic[type]
  if not lastReceiveTime then
    return false
  end
  local todayDayZeroTime = UITimeManager:GetInstance():GetTodayZero()
  return todayDayZeroTime > lastReceiveTime * 1000
end

function RechargeManager:GetLine(id)
  if not id then
    return nil
  end
  local data = self.rechargeDatas[tonumber(id)]
  if not data then
    data = LocalController:instance():getLine(TableName.Recharge, id)
    if data then
      local template = RechargeTemplate.New()
      template:InitData(data)
      self.rechargeDatas[tonumber(id)] = template
    end
  end
  return data
end

function RechargeManager:InitAllLines()
  local tableName = TableName.Recharge
  LocalController:instance():visitTable(tableName, function(id, lineData)
    if not self.rechargeDatas[tonumber(id)] then
      local template = RechargeTemplate.New()
      template:InitData(lineData)
      self.rechargeDatas[tonumber(id)] = template
    end
  end)
end

function RechargeManager:GetAllLines()
  if not self.hasInitAllLine then
    self:InitAllLines()
    self.hasInitAllLine = true
  end
  return self.rechargeDatas
end

function RechargeManager:getStrValue(id, key)
  local line = self:GetLine(id)
  if not line then
    return ""
  end
  return line[key]
end

function RechargeManager:GetSplitedPara1(id, sep)
  if not self.splitedPara1s[id] then
    local para1 = self:getStrValue(id, "para1")
    if para1 then
      local _sep = sep or "|"
      self.splitedPara1s[id] = string.split(para1, _sep)
    end
  end
  return self.splitedPara1s[id]
end

function RechargeManager:GetRechargeGiftShowTemplateById(id)
  if self.rechargeGiftShowTemplateDict[id] == nil then
    local rowData = LocalController:instance():getLine(TableName.RECHARGE_GIFT_SHOW, id)
    if rowData ~= nil then
      local template = RechargeGiftShowTemplate.New()
      template:UpdateData(rowData)
      self.rechargeGiftShowTemplateDict[id] = template
    else
      Logger.LogError("\231\164\188\229\140\133\229\160\134\229\143\160\228\188\152\229\140\150\233\156\128\230\177\130: recharge gift show\232\161\168\230\137\190\228\184\141\229\136\176id\228\184\186" .. id .. "\231\154\132\232\161\140")
    end
  end
  return self.rechargeGiftShowTemplateDict[id]
end

function RechargeManager:GetGiftShowDataById(id)
  local rechargeTemplate = self:GetLine(id)
  if rechargeTemplate == nil then
    return nil
  end
  local packageInfo
  local packages = GiftPackageData.GetAllAvailablePackageByRechargeId(rechargeTemplate.id)
  if not table.IsNullOrEmpty(packages) then
    packageInfo = packages[1]
  end
  if packageInfo ~= nil then
    local giftShowId = rechargeTemplate:GetRechargeGiftShowIdByPackageId(packageInfo:getID())
    if 0 < giftShowId then
      local giftShowTemplate = self:GetRechargeGiftShowTemplateById(giftShowId)
      if giftShowTemplate then
        return giftShowTemplate
      end
    end
  end
  return rechargeTemplate
end

function RechargeManager:SaveLocalRedDotInfo(rechargeId, expireTime)
  if not rechargeId or not expireTime then
    return
  end
  self.localRedDotInfoCacheDic = self.localRedDotInfoCacheDic or {}
  if self.localRedDotInfoCacheDic[rechargeId] and self.localRedDotInfoCacheDic[rechargeId] == expireTime then
    return
  end
  local key = SettingKeys.RECHARGE_RED_DOT_LOCAL_SAVE .. rechargeId
  Setting:SetInt(key, expireTime)
  self.localRedDotInfoCacheDic[rechargeId] = expireTime
end

function RechargeManager:GetLocalRedDotState(rechargeId)
  if not rechargeId then
    return false
  end
  self.localRedDotInfoCacheDic = self.localRedDotInfoCacheDic or {}
  local expireTime = self.localRedDotInfoCacheDic[rechargeId]
  if expireTime == nil then
    local key = SettingKeys.RECHARGE_RED_DOT_LOCAL_SAVE .. rechargeId
    if not Setting:HasSetting(key) then
      return true
    end
    expireTime = Setting:GetInt(key, -1)
  end
  if expireTime < 0 then
    return true
  end
  local now = UITimeManager:GetInstance():GetServerTime() / 1000
  return expireTime < now
end

return RechargeManager
