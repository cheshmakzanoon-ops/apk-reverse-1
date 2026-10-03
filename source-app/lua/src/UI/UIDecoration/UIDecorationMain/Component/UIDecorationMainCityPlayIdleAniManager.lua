local UIDecorationMainCityPlayIdleAniManager = BaseClass("UIDecorationMainCityPlayIdleAniManager")
local AniFrameNum = 30

function UIDecorationMainCityPlayIdleAniManager:__init()
  local idleAniDataStr, idleAniChangeFunc
  local aniDataList = {}
  local curAniIndex, curAniLoopNum, curAniTime, curAniHaveRunTime
  local isPlaying = false
end

function UIDecorationMainCityPlayIdleAniManager:__delete()
end

function UIDecorationMainCityPlayIdleAniManager:InitData(idleAniStr, changeFunc)
  self.idleAniDataStr = idleAniStr
  self.idleAniChangeFunc = changeFunc
  self.curAniIndex = 0
  self.curAniLoopNum = 0
  self.curAniTime = 0
  self.curAniHaveRunTime = 0
  self.isPlaying = false
  self.firstAniNeedMixTime = 0
  self.aniDataList = {}
  local sArry = string.split(idleAniStr, ";")
  for i, v in ipairs(sArry) do
    local aniDataStr = string.split(v, "|")
    if #aniDataStr == 4 then
      local loopNum = 0
      local isMix = 0
      loopNum = toInt(aniDataStr[2])
      isMix = toInt(aniDataStr[3])
      local mixDataStr = aniDataStr[4]
      local mixTimeListData = string.string2array_num(mixDataStr, "-", ",")
      local mixTimeList = {}
      for j = 1, #mixTimeListData do
        mixTimeList[j] = {
          startTime = mixTimeListData[j][1],
          endTime = mixTimeListData[j][2]
        }
      end
      local aniData = {
        aniName = aniDataStr[1],
        aniLoopNum = loopNum,
        isMix = isMix,
        mixTimeList = mixTimeList
      }
      table.insert(self.aniDataList, aniData)
    end
  end
end

function UIDecorationMainCityPlayIdleAniManager:ClearAllData()
  self.idleAniDataStr = nil
  self.idleAniChangeFunc = nil
  self.aniDataList = nil
end

function UIDecorationMainCityPlayIdleAniManager:OnStart(FirstAniNeedMixTime)
  self.curAniIndex = 0
  self.curAniLoopNum = 0
  self.curAniTime = 0
  self.curAniHaveRunTime = 0
  self.isPlaying = true
  local curAniData = self:GetCurAniData()
  self.firstAniNeedMixTime = FirstAniNeedMixTime or 0
  if self.idleAniChangeFunc ~= nil then
    self.curAniTime = self.idleAniChangeFunc(curAniData.aniName, self.firstAniNeedMixTime)
  end
  self.firstAniNeedMixTime = 0
end

function UIDecorationMainCityPlayIdleAniManager:OnUpdate()
  if self.curAniTime <= 0 then
    return
  end
  self.curAniHaveRunTime = self.curAniHaveRunTime + Time.deltaTime
  if self.curAniHaveRunTime > self.curAniTime then
    self:TryToNextAni()
  end
end

function UIDecorationMainCityPlayIdleAniManager:OnStop()
  self.curAniIndex = 0
  self.curAniLoopNum = 0
  self.curAniTime = 0
  self.curAniHaveRunTime = 0
  self.isPlaying = false
end

function UIDecorationMainCityPlayIdleAniManager:GetCurAniData()
  if self.curAniIndex < #self.aniDataList then
    return self.aniDataList[self.curAniIndex + 1]
  end
  return {}
end

function UIDecorationMainCityPlayIdleAniManager:GetCurAniNeedMix()
  local isMix = false
  local aniData = self:GetCurAniData()
  local isIncludeConfig = false
  local curAniFrameNum = AniFrameNum * self.curAniHaveRunTime
  if aniData.mixTimeList ~= nil then
    for i = 1, #aniData.mixTimeList do
      local mixTimeData = aniData.mixTimeList[i]
      if curAniFrameNum > mixTimeData.startTime and curAniFrameNum < mixTimeData.endTime then
        isIncludeConfig = true
        break
      end
    end
  end
  if isIncludeConfig then
    isMix = aniData.isMix > 0
  else
    isMix = not (aniData.isMix > 0)
  end
  return isMix
end

function UIDecorationMainCityPlayIdleAniManager:TryToNextAni()
  local aniData = self:GetCurAniData()
  self.curAniTime = 0
  self.curAniHaveRunTime = 0
  self.curAniLoopNum = self.curAniLoopNum + 1
  if self.curAniLoopNum >= aniData.aniLoopNum then
    self.curAniLoopNum = 0
    self.curAniIndex = self.curAniIndex + 1
    if self.curAniIndex >= #self.aniDataList then
      self.curAniIndex = self.curAniIndex % #self.aniDataList
    end
  end
  local curAniData = self:GetCurAniData()
  if self.idleAniChangeFunc ~= nil then
    self.curAniTime = self.idleAniChangeFunc(curAniData.aniName)
  end
end

return UIDecorationMainCityPlayIdleAniManager
