local UILWAlCreateJoinCtrl = BaseClass("UILWAlCreateJoinCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWAlCreateJoin)
end

local function GetStringLength(self, inputstr)
  if not inputstr or type(inputstr) ~= "string" or #inputstr <= 0 then
    return 0
  end
  local length = 0
  local i = 1
  while true do
    local curByte = string.byte(inputstr, i)
    local byteCount = 1
    if 239 < curByte then
      byteCount = 4
    elseif 223 < curByte then
      byteCount = 3
    elseif 128 < curByte then
      byteCount = 2
    else
      byteCount = 1
    end
    i = i + byteCount
    length = length + 1
    if i > #inputstr then
      break
    end
  end
  return length
end

local function CheckAlName(self, value)
  local type = CheckNameType.None
  local len = #value
  if len < MIN_AL_NAME_CHAR then
    type = CheckNameType.MinNameChar
  elseif len > MAX_AL_NAME_CHAR then
    type = CheckNameType.MaxNameChar
  end
  Logger.Log("check al name type", type)
  return type
end

local function SendCheckAlNameMessage(self, value)
  SFSNetwork.SendMessage(MsgDefines.AlName, value)
end

local function CheckAlTag(self, value)
  local type = CheckNameType.None
  local len = #value
  if len < AL_TAG_CHAR then
    type = CheckNameType.MinNameChar
  elseif len > MAX_AL_TAG_CHAR then
    type = CheckNameType.MaxNameChar
  elseif string.match(value, "%W") then
    type = CheckNameType.IllegalChar
  end
  Logger.Log("check al abbr type", type)
  return type
end

local function SendCheckAlTagMessage(self, value)
  SFSNetwork.SendMessage(MsgDefines.AlAbbr, value)
end

local function GetRandom(self, model, length)
  local BC = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  local SC = "abcdefghijklmnopqrstuvwxyz"
  local NO = "0123456789"
  local charList, maxLen
  model = model or 1
  length = length or 1
  if model == 1 then
    charList = BC
    maxLen = 26
  elseif model == 2 then
    charList = SC
    maxLen = 26
  elseif model == 3 then
    charList = NO
    maxLen = 10
  elseif model == 4 then
    charList = NO .. SC
    maxLen = 36
  end
  local result = ""
  for i = 1, length do
    local index = math.random(1, maxLen)
    result = result .. string.sub(charList, index, index)
  end
  return result
end

local function GetRandomAlTag(self)
  return self:GetRandom(4, MAX_AL_TAG_CHAR)
end

local function SendAlSearchMessageToServer(self, type, page, key, language, isRecommend)
  SFSNetwork.SendMessage(MsgDefines.AlSearch, type, page, key, language, isRecommend)
end

local function GetAllSearchAlIdList(self, searchInputValue)
  local searchList = DataCenter.AllianceTempListManager:GetSearchAllianceIdList(searchInputValue)
  local haveCanJoin = false
  local alDataList = {}
  local extendDataList = {}
  if searchList then
    for _, v in ipairs(searchList) do
      local alData = self:GetOneAlByUid(v)
      local extendData = self:GetOneAlExtendData(alData)
      if haveCanJoin == false and extendData and extendData.canJoin then
        haveCanJoin = true
        extendData.showBest = true
      end
      if string.IsNullOrEmpty(searchInputValue) then
        if alData.curMember < alData.maxMember then
          table.insert(alDataList, alData)
          table.insert(extendDataList, extendData)
        end
      else
        table.insert(alDataList, alData)
        table.insert(extendDataList, extendData)
      end
    end
  end
  return alDataList, extendDataList, haveCanJoin
end

local function GetOneAlByUid(self, uid)
  return DataCenter.AllianceTempListManager:GetSearchAllianceDataByUid(uid)
end

local function GetOneAlExtendData(self, alData)
  if alData == nil then
    return nil
  end
  local extendData = {}
  local isEnoughCondition = true
  local canJoin = true
  if alData.applyLevelLimit > 0 or 0 < alData.applyPowerLimit then
    local playerPower = LuaEntry.Player.power
    if playerPower < alData.applyPowerLimit then
      isEnoughCondition = false
    end
    local baseLevel = DataCenter.BuildManager.MainLv
    if baseLevel < alData.applyLevelLimit then
      isEnoughCondition = false
    end
  end
  if not isEnoughCondition then
    canJoin = false
  elseif alData.applied == 1 then
    canJoin = false
  elseif alData.curMember >= alData.maxMember then
    canJoin = false
  else
    local hasAlliance = LuaEntry.Player:IsInAlliance()
    canJoin = alData.recruitTotal == 0 and not hasAlliance
  end
  extendData.isEnoughCondition = isEnoughCondition
  extendData.canJoin = canJoin
  return extendData
end

local function SendAlApplyMessageToServer(self, allianceId, applyType, language)
  SFSNetwork.SendMessage(MsgDefines.AlApply, allianceId, applyType, language)
end

local function SendCancelApplyMessageToServer(self, allianceId)
  SFSNetwork.SendMessage(MsgDefines.AlCancelApply, allianceId)
end

UILWAlCreateJoinCtrl.CloseSelf = CloseSelf
UILWAlCreateJoinCtrl.GetStringLength = GetStringLength
UILWAlCreateJoinCtrl.CheckAlName = CheckAlName
UILWAlCreateJoinCtrl.SendCheckAlNameMessage = SendCheckAlNameMessage
UILWAlCreateJoinCtrl.CheckAlTag = CheckAlTag
UILWAlCreateJoinCtrl.SendCheckAlTagMessage = SendCheckAlTagMessage
UILWAlCreateJoinCtrl.GetRandom = GetRandom
UILWAlCreateJoinCtrl.GetRandomAlTag = GetRandomAlTag
UILWAlCreateJoinCtrl.SendAlSearchMessageToServer = SendAlSearchMessageToServer
UILWAlCreateJoinCtrl.GetAllSearchAlIdList = GetAllSearchAlIdList
UILWAlCreateJoinCtrl.GetOneAlExtendData = GetOneAlExtendData
UILWAlCreateJoinCtrl.GetOneAlByUid = GetOneAlByUid
UILWAlCreateJoinCtrl.SendAlApplyMessageToServer = SendAlApplyMessageToServer
UILWAlCreateJoinCtrl.SendCancelApplyMessageToServer = SendCancelApplyMessageToServer
return UILWAlCreateJoinCtrl
