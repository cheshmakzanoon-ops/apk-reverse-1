local LWSoundServerTemplate = BaseClass("LWSoundServerTemplate")

local function __init(self)
  self.id = 0
  self.sound_server = ""
end

local function __delete(self)
  self.id = nil
  self.sound_server = nil
  self.curServerSoundId = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.sound_server = row:getValue("sound_server") or {}
  self.sound_server_read = tonumber(row:getValue("sound_server_read")) or 0
end

function LWSoundServerTemplate:GetSoundId()
  if self.curServerSoundId then
    return self.curServerSoundId, self.isContinue
  end
  local curServerId = LuaEntry.Player:GetSourceServerId()
  local targetSoundId
  for k, v in pairs(self.sound_server) do
    if CS.CommonUtils.IsDebug() and not GMUtils.GetBool(GMConst.DebugUseServerSound, false) then
      if k == 1 and self:CheckIsInServerRange(k, curServerId) then
        targetSoundId = v
        break
      end
    elseif 1 < k and self:CheckIsInServerRange(k, curServerId) then
      targetSoundId = v
      break
    end
  end
  self.curServerSoundId = tonumber(targetSoundId)
  self.isContinue = self.sound_server_read == 1
  return self.curServerSoundId, self.isContinue
end

function LWSoundServerTemplate:CheckIsInServerRange(index, curServerId)
  local parsedRanges = DataCenter.LWSoundTemplateManager:GetCacheServerRange(index)
  for _, rangeInfo in ipairs(parsedRanges) do
    if curServerId >= rangeInfo.startServer and curServerId <= rangeInfo.endServer then
      return true
    end
  end
  return false
end

LWSoundServerTemplate.__init = __init
LWSoundServerTemplate.__delete = __delete
LWSoundServerTemplate.InitData = InitData
return LWSoundServerTemplate
