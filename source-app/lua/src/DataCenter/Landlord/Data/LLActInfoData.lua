local LLActInfoData = BaseClass("LLActInfoData")
local LLServerData = require("DataCenter.Landlord.Data.LLServerData")

function LLActInfoData:__init()
  self.templateId = 0
  self.configId = 0
  self.startTime = 0
  self.endTime = 0
  self.landlord = 0
  self.landlordNumber = 0
  self.previewStageBoomStartRaw = 0
  self.serverDic = nil
  self.currentStageId = 0
  self.currentWeekNum = 0
  self.nextStageTime = 0
  self.battleWeek = 3
  self.forcePartTime = nil
  self.bpNumber = nil
  self.stageList = nil
  self.allyMsg = ""
  self.translateMsg = ""
  self.translating = false
  self.landlordBuffIds = nil
  self.farmerBuffIds = nil
  self.battleUuids = nil
  self.weekLordScoreInfo = nil
  self.weekFarmerScoreInfo = nil
  self.destroyScore = 0
end

function LLActInfoData:__delete()
  self.serverDic = nil
  self.forcePartTime = nil
  self.bpNumber = nil
  self.stageList = nil
  self.landlordBuffIds = nil
  self.farmerBuffIds = nil
  self.battleUuids = nil
  self.weekLordScoreInfo = nil
  self.weekFarmerScoreInfo = nil
end

function LLActInfoData:ParseData(msg)
  if msg.configId == nil then
    return
  end
  self.templateId = msg.templateId or 0
  self.configId = msg.configId or 0
  self.startTime = msg.startTime or 0
  self.endTime = msg.endTime or 0
  self.landlord = msg.landlord or 0
  self.landlordNumber = msg.landlordNumber or 0
  self.previewStageBoomStartRaw = msg.previewStageBoomStartRaw or 0
  local csInst = CS.LandlordManager.Instance
  if csInst then
    csInst.previewBoomTime = self.previewStageBoomStartRaw
    csInst:EnsureCenterMapRandomFxSystem()
  end
  local serverList = msg.serverList
  if serverList ~= nil then
    local dic = self.serverDic or {}
    for _, v in ipairs(serverList) do
      local sId = v.serverId
      local data = dic[sId]
      if not data then
        data = LLServerData.New()
        dic[sId] = data
      end
      data:ParseData(v)
    end
    self.serverDic = dic
  end
  self.currentStageId = msg.currentStageId or 0
  self.currentWeekNum = msg.currentWeekNum or 0
  self.nextStageTime = msg.nextStageTime or 0
  self.battleWeek = msg.battleWeek or 3
  self.forcePartTime = {}
  table.insert(self.forcePartTime, msg.forcePartTime1 or 0)
  table.insert(self.forcePartTime, msg.forcePartTime2 or 0)
  table.insert(self.forcePartTime, msg.forcePartTime3 or 0)
  local bpNumber = msg.bpNumber or {}
  self.bpNumber = {}
  table.insert(self.bpNumber, bpNumber[1] or 1)
  table.insert(self.bpNumber, bpNumber[2] or 2)
  table.insert(self.bpNumber, bpNumber[3] or 1)
  self.stageList = {}
  self.battleUuids = {}
  self:AddStageInfo(LLConst.LandlordStage.PREVIEW, msg.previewTime)
  self:AddStageInfo(LLConst.LandlordStage.GROUP, msg.groupTime)
  local battleWeeks = msg.battleWeeks
  if not table.IsNullOrEmpty(battleWeeks) then
    for i, v in ipairs(battleWeeks) do
      self:AddStageInfo(LLConst.LandlordStage.PREPARE, v.prepareTime, i)
      self:AddStageInfo(LLConst.LandlordStage.BATTLE, v.battleTime, i)
      self:AddStageInfo(LLConst.LandlordStage.REST, v.restTime, i)
      self.battleUuids[i] = v.battleUuid
    end
    if 0 < #self.stageList then
      self.stageList[#self.stageList].eTime = self.endTime
    end
  end
  local newMsg = msg.allyMsg or ""
  if self.allyMsg ~= newMsg then
    self.allyMsg = newMsg
    self.translateMsg = ""
    self.translating = false
  end
  local llBuffs = msg.landlordBuffIds
  if llBuffs ~= nil then
    self.landlordBuffIds = {}
    for _, v in ipairs(llBuffs) do
      table.insert(self.landlordBuffIds, v)
    end
  end
  local fBuffs = msg.farmerBuffIds
  if fBuffs ~= nil then
    self.farmerBuffIds = {}
    for _, v in ipairs(fBuffs) do
      table.insert(self.farmerBuffIds, v)
    end
  end
  if msg.ZWLFreeMoveInfo then
    self.freeMoveInfoEndTime = msg.ZWLFreeMoveInfo.cdEndTime ~= 0 and msg.ZWLFreeMoveInfo.cdEndTime or self.startTime * 1000
  else
    self.freeMoveInfoEndTime = 0
  end
  self.weekLordScoreInfo = {}
  self.weekFarmerScoreInfo = {}
  local msgWeekLordScoreInfo = msg.landlordWeekCampScoreInfo or {}
  local msgWeekFarmerScoreInfo = msg.farmerWeekCampScoreInfo or {}
  for i = 1, 3 do
    table.insert(self.weekLordScoreInfo, msgWeekLordScoreInfo[i] or 0)
    table.insert(self.weekFarmerScoreInfo, msgWeekFarmerScoreInfo[i] or 0)
  end
end

function LLActInfoData:AddStageInfo(stage, time, week)
  if time == nil or time == 0 then
    return
  end
  self.stageList = self.stageList or {}
  local l = #self.stageList
  local sTime = time or 0
  table.insert(self.stageList, {
    idx = l + 1,
    stage = stage,
    sTime = sTime,
    week = week or 0
  })
  if 0 < l then
    self.stageList[l].eTime = sTime
  end
end

function LLActInfoData:GetCurStageInfo()
  local curSec = UITimeManager:GetInstance():GetServerSeconds()
  for _, info in ipairs(self.stageList or {}) do
    local sTime = info.sTime or 0
    local eTime = info.eTime or 0
    if curSec >= sTime and curSec < eTime then
      return info
    end
  end
  return nil
end

function LLActInfoData:GetStageInfo(stageIdx)
  for _, info in ipairs(self.stageList or {}) do
    if info.idx == stageIdx then
      return info
    end
  end
  return nil
end

function LLActInfoData:GetNextBattleStartTime(ignoreActEnd)
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  if self.stageList then
    for _, v in ipairs(self.stageList) do
      if v.stage == LLConst.LandlordStage.BATTLE and curTime < v.sTime then
        return v.sTime
      end
    end
  end
  return ignoreActEnd and 0 or self.endTime
end

function LLActInfoData:GetWeekBattleStartTime(week)
  if self.stageList then
    for _, v in ipairs(self.stageList) do
      if v.stage == LLConst.LandlordStage.BATTLE and v.week == week then
        return v.sTime
      end
    end
  end
end

function LLActInfoData:GetNextBattleEndTime(ignoreActEnd)
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  if self.stageList then
    for _, v in ipairs(self.stageList) do
      if v.stage == LLConst.LandlordStage.BATTLE and curTime < v.eTime then
        return v.eTime
      end
    end
  end
  return ignoreActEnd and 0 or self.endTime
end

function LLActInfoData:GetWeekBattleEndTime(week)
  if self.stageList then
    for _, v in ipairs(self.stageList) do
      if v.stage == LLConst.LandlordStage.BATTLE and v.week == week then
        return v.eTime
      end
    end
  end
end

function LLActInfoData:GetActStartTime()
  return self.startTime or 0
end

function LLActInfoData:GetCurBattleUuid()
  local week = self.currentWeekNum or 0
  if week == 0 then
    week = 1
  end
  return self.battleUuids and self.battleUuids[week] or 0
end

function LLActInfoData:GetMessage()
  return self.allyMsg
end

function LLActInfoData:SetIsTranslating(translatingFlag)
  self.translating = translatingFlag
end

function LLActInfoData:SetTranslationMsg(msg)
  self.translateMsg = msg
end

function LLActInfoData:GetWeekCampScore(week, camp)
  if camp == LLConst.LandLordGroup.LORD then
    return self.weekLordScoreInfo ~= nil and self.weekLordScoreInfo[week] or 0
  end
  if camp == LLConst.LandLordGroup.FARMER then
    return self.weekFarmerScoreInfo ~= nil and self.weekFarmerScoreInfo[week] or 0
  end
  return 0
end

function LLActInfoData:Description(sb)
  local mgr = UITimeManager:GetInstance()
  sb:AppendFormatLine("zonewar_landlord_open\233\133\141\231\189\174Id = %s", self.templateId)
  sb:AppendFormatLine("zonewar_landlord_config\233\133\141\231\189\174Id = %s", self.configId)
  sb:AppendFormatLine("\229\164\167\229\156\176\228\184\187serverId = %s", self.landlord)
  sb:AppendFormatLine("\229\156\176\228\184\187\233\152\159\229\143\139\228\186\186\230\149\176 = %s", self.landlordNumber)
  sb:AppendFormatLine("\233\162\132\229\145\138\231\136\134\231\130\184\230\151\182\233\151\180 = %s", mgr:GetServerTimeByUTC(self.previewStageBoomStartRaw))
  sb:AppendFormatLine("\229\189\147\229\137\141\229\145\168\230\149\176 = %s\239\188\140(0=\233\166\150\229\145\168\239\188\1401~N=\230\136\152\230\150\151\229\145\168)", self.currentWeekNum)
  sb:AppendFormatLine("\230\128\187\230\136\152\230\150\151\229\145\168\230\149\176 = %s", self.battleWeek)
  local curSec = mgr:GetServerSeconds()
  sb:AppendFormatLine("\230\180\187\229\138\168\229\188\128\229\167\139\230\151\182\233\151\180\239\188\136\231\167\146\239\188\137 = %s (%s)", mgr:GetServerTimeByUTC(self.startTime * 1000), self.startTime)
  sb:AppendFormatLine("\230\180\187\229\138\168\231\187\147\230\157\159\230\151\182\233\151\180\239\188\136\231\167\146\239\188\137 = %s (%s)", mgr:GetServerTimeByUTC(self.endTime * 1000), self.endTime)
  sb:AppendFormatLine("\229\144\142\231\171\175\232\191\148\229\155\158\231\154\132\229\189\147\229\137\141\233\152\182\230\174\181 = %s", self.currentStageId)
  sb:AppendFormatLine("\229\144\142\231\171\175\232\191\148\229\155\158\231\154\132\228\184\139\228\184\170\233\152\182\230\174\181\230\151\182\233\151\180 = %s (%s)", mgr:GetServerTimeByUTC(self.nextStageTime * 1000), self.nextStageTime)
  sb:AppendFormatLine("\229\189\147\229\137\141\230\151\182\233\151\180\239\188\136\231\167\146\239\188\137 = %s(%s)", mgr:GetServerTimeByUTC(curSec * 1000), curSec)
  sb:AppendFormatLine("\228\184\139\230\172\161\229\133\141\232\180\185\232\191\129\229\159\142\231\154\132\230\151\182\233\151\180\239\188\136\231\167\146\239\188\137 = %s(%s)", mgr:GetServerTimeByUTC(self.freeMoveInfoEndTime), self.freeMoveInfoEndTime / 1000)
  sb:AppendFormatLine("bpNumber : %s", table.IsNullOrEmpty(self.bpNumber) and "nil" or table.concat(self.bpNumber, ","))
  if self.forcePartTime then
    for i, v in ipairs(self.forcePartTime) do
      sb:AppendFormatLine("forcePartTime%s = %s (%s)", i, mgr:GetServerTimeByUTC(v * 1000), v)
    end
  else
    for i = 1, 3 do
      sb:AppendFormatLine("forcePartTime%s = %s (%s)", i, "nil", "nil")
    end
  end
  local curInfo = self:GetCurStageInfo()
  if curInfo ~= nil then
    sb:AppendFormatLine("\229\174\162\230\136\183\231\171\175\232\174\161\231\174\151\229\189\147\229\137\141\233\152\182\230\174\181 idx = %s, stage = %s", curInfo.idx, curInfo.stage)
    sb:AppendLine("\230\136\152\229\140\186\230\150\151\229\156\176\228\184\187\233\152\182\230\174\181:")
    sb:AppendLine("    1. \233\162\132\229\145\138")
    sb:AppendLine("    2. \229\136\134\231\187\132")
    sb:AppendLine("    3. \229\135\134\229\164\135")
    sb:AppendLine("    4. \230\136\152\230\150\151")
    sb:AppendLine("    5. \228\188\145\230\129\175")
  else
    sb:AppendFormatLine("\229\174\162\230\136\183\231\171\175\232\174\161\231\174\151\229\189\147\229\137\141\233\152\182\230\174\181 = %s", "\230\151\160")
  end
  if self.stageList then
    sb:AppendLine("\230\180\187\229\138\168\233\152\182\230\174\181\229\136\151\232\161\168\239\188\154")
    for _, v in ipairs(self.stageList) do
      sb:AppendFormatLine("    %s: stage = %s, week = %s", v.idx, v.stage, v.week)
      sb:AppendFormatLine("        sTime = %s (%s)", mgr:GetServerTimeByUTC(v.sTime * 1000), v.sTime)
      sb:AppendFormatLine("        eTime = %s (%s)", mgr:GetServerTimeByUTC(v.eTime * 1000), v.eTime)
    end
  end
  sb:AppendFormatLine("\230\156\172\230\156\141\231\155\159\228\184\187\229\143\145\229\184\131\231\154\132\233\152\181\232\144\165\229\174\163\232\168\128 = %s", self.allyMsg)
  if table.IsNullOrEmpty(self.landlordBuffIds) then
    sb:AppendLine("\229\156\176\228\184\187buff\239\188\154\231\169\186")
  else
    sb:AppendFormatLine("\229\156\176\228\184\187buff\239\188\154%s", #self.landlordBuffIds)
    for _, v in ipairs(self.landlordBuffIds) do
      sb:AppendFormatLine("    %s", v)
    end
  end
  if table.IsNullOrEmpty(self.farmerBuffIds) then
    sb:AppendLine("\229\134\156\230\176\145buff\239\188\154\231\169\186")
  else
    sb:AppendFormatLine("\229\134\156\230\176\145buff\239\188\154%s", #self.farmerBuffIds)
    for _, v in ipairs(self.farmerBuffIds) do
      sb:AppendFormatLine("    %s", v)
    end
  end
  if table.IsNullOrEmpty(self.battleUuids) then
    sb:AppendLine("9\231\174\177Uid\239\188\154\231\169\186")
  else
    sb:AppendFormatLine("9\231\174\177Uid\239\188\154%s", #self.battleUuids)
    for _, v in ipairs(self.battleUuids) do
      sb:AppendFormatLine("    %s", v)
    end
  end
  if table.IsNullOrEmpty(self.weekLordScoreInfo) then
    sb:AppendLine("\228\184\137\229\145\168\229\156\176\228\184\187\233\152\181\232\144\165\229\136\134\228\191\161\230\129\175\239\188\154\231\169\186")
  else
    sb:AppendFormatLine("\228\184\137\229\145\168\229\156\176\228\184\187\233\152\181\232\144\165\229\136\134\228\191\161\230\129\175\239\188\154%s", table.concat(self.weekLordScoreInfo, ","))
  end
  if table.IsNullOrEmpty(self.weekFarmerScoreInfo) then
    sb:AppendLine("\228\184\137\229\145\168\229\134\156\230\176\145\233\152\181\232\144\165\229\136\134\228\191\161\230\129\175\239\188\154\231\169\186")
  else
    sb:AppendFormatLine("\228\184\137\229\145\168\229\134\156\230\176\145\233\152\181\232\144\165\229\136\134\228\191\161\230\129\175\239\188\154%s", table.concat(self.weekFarmerScoreInfo, ","))
  end
  if table.IsNullOrEmpty(self.serverDic) then
    sb:AppendLine("\230\137\128\230\156\137server\239\188\154\231\169\186")
  else
    sb:AppendFormatLine("\230\137\128\230\156\137server\239\188\154%s", table.count(self.serverDic))
    for _, v in pairs(self.serverDic) do
      v:Description(sb)
    end
  end
end

return LLActInfoData
