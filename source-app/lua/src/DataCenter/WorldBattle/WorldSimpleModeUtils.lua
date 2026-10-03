local WorldSimpleModeUtils = {}
WorldSimpleModeUtils.TargetType = {CityEffect = 1000}

function WorldSimpleModeUtils.ShowMummyTranslate()
  local showParticle = false
  local showBubble = false
  local showAdd = false
  local lod = DisplaySettings.currentLod or 1
  local smLv = DisplaySettings.GetCurrentDisplayLevel()
  if 0 <= smLv then
    showParticle = lod <= 3
    showBubble = lod <= 4
    showAdd = lod <= 2
  elseif smLv == -1 then
    showAdd = lod <= 2
  elseif smLv == -2 then
  elseif smLv == -3 then
  elseif smLv == -4 then
  end
  return showParticle, showBubble, showAdd
end

function WorldSimpleModeUtils.ShowWarFlag()
  local model = false
  local icon = false
  local lod = DisplaySettings.currentLod or 1
  local smLv = DisplaySettings.GetCurrentDisplayLevel()
  if 0 <= smLv then
    model = lod <= 2
    icon = 2 < lod and lod < 6
  elseif smLv == -1 then
    model = lod <= 1
    icon = 1 < lod and lod < 5
  elseif smLv == -2 then
    model = lod < 0
    icon = lod < 5
  elseif smLv == -3 then
    model = lod < 0
    icon = lod < 5
  elseif smLv == -4 then
    model = lod < 0
    icon = lod < 5
  end
  return model, icon
end

function WorldSimpleModeUtils.ShowMummyMembers()
  local mummyEffDown = false
  local mummyBoss = false
  local mummyGroup = false
  local mummyEffSand = false
  local lod = DisplaySettings.currentLod or 1
  local displayLv = DisplaySettings.GetCurrentDisplayLevel()
  if displayLv == 0 then
    mummyEffDown = lod <= 3
    mummyBoss = lod == 2
    mummyGroup = lod == 1
    mummyEffSand = lod <= 2
  elseif displayLv == -1 then
    mummyEffDown = lod == -1
    mummyBoss = lod <= 2
    mummyGroup = lod == -1
    mummyEffSand = lod == -1
  elseif displayLv == -2 then
    mummyEffDown = lod == -1
    mummyBoss = lod == -1
    mummyGroup = lod == -1
    mummyEffSand = lod == -1
  elseif displayLv == -3 then
    mummyEffDown = lod == -1
    mummyBoss = lod == -1
    mummyGroup = lod == -1
    mummyEffSand = lod == -1
  elseif displayLv == -4 then
    mummyEffDown = lod == -1
    mummyBoss = lod == -1
    mummyGroup = lod == -1
    mummyEffSand = lod == -1
  end
  return mummyEffDown, mummyBoss, mummyGroup, mummyEffSand
end

function WorldSimpleModeUtils.CanShowTroopLight()
  local displayLv = DisplaySettings.GetCurrentDisplayLevel()
  local currentLod = DisplaySettings.currentLod
  local LevelLimit = DisplaySettings.LevelLimit
  if displayLv < 0 then
    return false
  else
    if 3 <= currentLod then
      return false
    end
    if LevelLimit == DisplaySettings.Levels.High then
      return true
    elseif LevelLimit == DisplaySettings.Levels.Mid then
      return true
    else
      return false
    end
  end
end

function WorldSimpleModeUtils.GetDelaySec(targetType, args)
end

return ConstClass("WorldSimpleModeUtils", WorldSimpleModeUtils)
