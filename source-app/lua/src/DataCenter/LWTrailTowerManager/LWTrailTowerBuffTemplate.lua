local LWTrailTowerBuffTemplate = BaseClass("LWTrailTowerBuffTemplate")
local Localization = CS.GameEntry.Localization

function LWTrailTowerBuffTemplate:__init()
  self.id = 0
  self.openServerDay = 0
  self.limitTime = 0
  self.buffResPath = ""
  self.buffList = {}
  self.bufflist_desc = ""
  self.heroBuffList = {}
  self.buffDescList = {}
  self.displayBuffDesList = {}
  self.openServerMilliSecond = 0
  self.limitMilliSecond = 0
end

function LWTrailTowerBuffTemplate:__delete()
  self.id = nil
  self.openServerDay = nil
  self.limitTime = nil
  self.buffResPath = nil
  self.buffList = nil
  self.bufflist_desc = nil
  self.heroBuffList = nil
  self.buffDescList = nil
  self.displayBuffDesList = nil
  self.openServerMilliSecond = nil
  self.limitMilliSecond = nil
end

function LWTrailTowerBuffTemplate:InitData(row)
  self.id = row:getValue("id") or 0
  self.openServerDay = row:getValue("open_serverday") or 0
  self.limitTime = row:getValue("limitTime") or 0
  self.buffResPath = row:getValue("buff_respath") or ""
  self.buffList = row:getValue("bufflist") or {}
  self.bufflist_desc = row:getValue("bufflist_desc") or ""
  self.heroBuffList = row:getValue("herobufflist") or {}
  self.buffDescList = row:getValue("buff_desc") or {}
  self.openServerMilliSecond = self.openServerDay * 24 * 60 * 60 * 1000
  self.limitMilliSecond = self.limitTime * 60 * 1000
end

function LWTrailTowerBuffTemplate:IsOpen()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local serverStartTime = LuaEntry.Player.openServerTime
  local day = UITimeManager:GetInstance().GetDateNum(curTime, serverStartTime)
  return day >= self.openServerDay
end

function LWTrailTowerBuffTemplate:IsEnd()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local endTime = self:GetEndTime()
  local surplusTime = endTime - curTime
  return surplusTime <= 0
end

function LWTrailTowerBuffTemplate:GetEndTime()
  local serverStartTime = LuaEntry.Player.openServerTime
  return serverStartTime + self.openServerMilliSecond + self.limitMilliSecond
end

function LWTrailTowerBuffTemplate:GetDisplayBuffDesList()
  if #self.displayBuffDesList == 0 then
    for k, buffStr in pairs(self.buffList) do
      local buffArr = string.split(buffStr, ";")
      local buffKey = self.bufflist_desc
      if #buffArr == 2 then
        local effectId = tonumber(buffArr[1])
        local effectValue = tonumber(buffArr[2])
        local buffValueStr = HeroUtils.GetFormattedPropertyValue(effectId, effectValue, false)
        local des = Localization:GetString(buffKey, buffValueStr)
        table.insert(self.displayBuffDesList, des)
      end
    end
    for k, buffStr in pairs(self.heroBuffList) do
      local buffArr = string.split(buffStr, ";")
      local buffKey = self.buffDescList[k]
      if #buffArr == 3 then
        local heroId = tonumber(buffArr[1])
        local heroTemplate = DataCenter.HeroTemplateManager:GetTemplate(heroId)
        local heroName = Localization:GetString(heroTemplate.name) or ""
        local effectId = tonumber(buffArr[2])
        local effectValue = tonumber(buffArr[3])
        local buffNameKey = HeroUtils.GetHeroPropertyNameId(effectId)
        local buffName = buffNameKey ~= "" and Localization:GetString(buffNameKey) or buffNameKey
        local buffValueStr = HeroUtils.GetFormattedPropertyValue(effectId, effectValue, false)
        local des = Localization:GetString(buffKey, heroName, buffName, buffValueStr)
        table.insert(self.displayBuffDesList, des)
      end
    end
  end
  return self.displayBuffDesList
end

return LWTrailTowerBuffTemplate
