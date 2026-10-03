local GMManager = BaseClass("GMManager")
local rapidjson = require("rapidjson")
local CSGMSwitch = CS.GMSwitch
local GMConst = require("UI.UIGMPanel.GMConst")
local GMHappyWatcher = require("UI.UIGMPanel.GMHappyWatcher")
local gmPrefsKey = "HappyGMSettings"

local function _GetPersistentSettingPath()
  return string.format("%s/Misc/%s.json", CS.UnityEngine.Application.persistentDataPath, gmPrefsKey)
end

local syncCSKeys = {
  [GMConst.DebugClickLogWarning] = true,
  [GMConst.DebugSandFishTroopLineEnable] = true,
  [GMConst.DebugLogProtocolMsg] = true,
  [GMConst.DebugWorldPointGPUInstanceProp] = true,
  [GMConst.EnableLegacyToggle] = true,
  [GMConst.DebugLocalLogEnable] = true,
  [GMConst.DebugLocalLogLevel] = true,
  [GMConst.DebugSendMsg] = true,
  [GMConst.DebugBuildSkinID] = true,
  [GMConst.DebugBuildSkinEffId] = true,
  [GMConst.DebugBuildSkinRandom] = true,
  [GMConst.DebugWorldMarchDataHaha] = true,
  [GMConst.ZhenYueMode] = true,
  [GMConst.RawImageVideoPlayer] = true
}
local saveToLocalJson = {
  [GMConst.ShowGMBar] = true,
  [GMConst.GMBarScale] = true,
  [GMConst.DebugDisplayGameID] = true,
  [GMConst.ShowLitModeDebug] = true,
  [GMConst.ShowLodDebug] = false,
  [GMConst.DebugLogProtocolMsg] = true,
  [GMConst.DebugLocalLogEnable] = true,
  [GMConst.DebugLocalLogLevel] = true,
  [GMConst.ShowPerformanceBar] = true,
  [GMConst.ShowWorldInfo] = true,
  [GMConst.ShowHappyWatcher] = true,
  [GMConst.GirlMode] = true,
  [GMConst.DebugClickLogWarning] = true,
  [GMConst.DebugSendMsg] = true,
  [GMConst.ShowBagMaster] = true,
  [GMConst.DebugUseServerSound] = true,
  [GMConst.ZhenYueMode] = true,
  [GMConst.ShowClock] = true
}

local function _GetFavKey(page, name)
  if not page or not name then
    return nil
  end
  return string.format("%s_%s", page, name)
end

function GMManager:__init()
  self.isValid = false
  self.warningCount = 0
  self.errorCount = 0
  self.gmBoolVal = {}
  self.gmIntVal = {}
  self.gmStrVal = {}
  self.favorites = {}
  self.favoriteSet = {}
  self.happyWatcher = nil
  self.cityZoneDebugNum = 0
end

function GMManager:__delete()
  GMUtils.GMManager = nil
  EventManager:GetInstance():RemoveListener(EventId.GM_GMBarShowStateChanged, self.RefreshGMBarVisible)
  GMUtils.Log("GMManager deleted.")
  self.warningCount = nil
  self.errorCount = nil
  self.gmBoolVal = nil
  self.gmIntVal = nil
  self.gmStrVal = nil
  self.favorites = nil
  self.favoriteSet = nil
  if self.happyWatcher then
    self.happyWatcher:Delete()
    self.happyWatcher = nil
  end
  self.cityZoneDebugNum = nil
end

function GMManager:IsGM()
  return self.isValid
end

function GMManager:GetSettingJson()
  local json = {}
  json.bools = {}
  json.ints = {}
  json.favorites = {}
  for k, v in pairs(self.gmBoolVal) do
    if saveToLocalJson[k] then
      json.bools[k] = v
    end
  end
  for k, v in pairs(self.gmIntVal) do
    if saveToLocalJson[k] then
      json.ints[k] = v
    end
  end
  for k, v in pairs(self.gmStrVal) do
    if saveToLocalJson[k] then
      json.strs[k] = v
    end
  end
  for k, v in ipairs(self.favorites) do
    table.insert(json.favorites, {
      page = v.page,
      name = v.name
    })
  end
  return rapidjson.encode(json)
end

function GMManager:SaveToJson()
  if not self:IsGM() then
    return
  end
  if self.jsonInited then
    CommonUtil.ProtectCall(function()
      local _path = _GetPersistentSettingPath()
      GMUtils.Log("\228\191\157\229\173\152\232\174\190\231\189\174\229\136\176:%s", _path)
      CS.FileUtils.WriteFile(_path, self:GetSettingJson())
    end)
  end
end

function GMManager:InitFromJson()
  if not self:IsGM() then
    return
  end
  self.gmBoolVal = {}
  self.gmIntVal = {}
  self.gmStrVal = {}
  self.favorites = {}
  self.favoriteSet = {}
  CommonUtil.ProtectCall(function()
    local _path = _GetPersistentSettingPath()
    GMUtils.Log("\232\175\187\229\143\150gm\232\174\190\231\189\174\231\138\182\230\128\129:%s", _path)
    local file = io.open(_path, "r")
    if file then
      local content = file:read("*a")
      file:close()
      local data = rapidjson.decode(content)
      if not data then
        GMUtils.Log("\230\137\190\228\184\141\229\136\176\230\156\137\230\149\136\231\154\132\233\133\141\231\189\174")
        return
      end
      if data.bools then
        for k, v in pairs(data.bools) do
          GMUtils.Log("\229\136\157\229\167\139\229\140\150(bool):%s=%s", k, v)
          self:SetBool(k, v)
        end
      end
      if data.ints then
        for k, v in pairs(data.ints) do
          GMUtils.Log("\229\136\157\229\167\139\229\140\150(int):%s=%s", k, v)
          self:SetInt(k, v)
        end
      end
      if data.strs then
        for k, v in pairs(data.strs) do
          GMUtils.Log("\229\136\157\229\167\139\229\140\150(int):%s=%s", k, v)
          self:SetString(k, v)
        end
      end
      if data.favorites then
        for k, v in ipairs(data.favorites) do
          table.insert(self.favorites, {
            page = v.page,
            name = v.name
          })
          self.favoriteSet[_GetFavKey(v.page, v.name)] = true
        end
      end
      self.jsonInited = true
      GMUtils.Log("\229\136\157\229\167\139\229\140\150\229\174\140\230\175\149\229\150\189")
    else
      GMUtils.Log("\230\137\190\228\184\141\229\136\176\230\156\137\230\149\136\231\154\132\233\133\141\231\189\174")
      self.jsonInited = true
    end
  end)
end

function GMManager:Startup()
  self.isValid = CommonUtil.IsDebug()
  CSGMSwitch.IsGM = self.isValid
  GMUtils.Log("GMManager inited, isvalid = %s", self.isValid)
  if not self.isValid then
    return
  end
  GMUtils.GMManager = self
  self:InitFromJson()
  CSGMSwitch.LuaSetBool(GMConst.DebugLocalLogEnable, self:GetBool(GMConst.DebugLocalLogEnable, true))
  CSGMSwitch.LuaSetInt(GMConst.DebugLocalLogLevel, self:GetInt(GMConst.DebugLocalLogLevel, 3))
  EventManager:GetInstance():AddListener(EventId.GM_GMBarShowStateChanged, self.RefreshGMBarVisible)
  self:RefreshGMBarVisible()
end

function GMManager:UpdateLogCount(warning, error)
  if not self.isValid then
    return
  end
  self.warningCount = warning
  self.errorCount = error
  EventManager:GetInstance():Broadcast(EventId.GM_LOG_COUNT_CHANGED)
end

function GMManager:RefreshGMBarVisible()
  local mgr = DataCenter.GMManager
  if not mgr:IsGM() then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGMBar)
    return
  end
  local visible = mgr:GetBool(GMConst.ShowGMBar, true)
  if visible then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGMBar, {anim = true})
  else
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGMBar)
  end
end

function GMManager:GetBool(name, default)
  if not self:IsGM() then
    return
  end
  local val = self.gmBoolVal[name]
  if val == nil then
    self:SetBool(name, default)
    val = default
  end
  return val
end

function GMManager:SetBool(name, val)
  if not self:IsGM() then
    return
  end
  if self.gmBoolVal[name] == val then
    return
  end
  self.gmBoolVal[name] = val
  if syncCSKeys[name] then
    CSGMSwitch.LuaSetBool(name, val)
  end
  EventManager:GetInstance():Broadcast(EventId.GM_SomeValChanged, name)
  self:SaveToJson()
end

function GMManager:GetInt(name, default)
  if not self:IsGM() then
    return
  end
  local val = self.gmIntVal[name]
  if val == nil then
    self:SetInt(name, default)
    val = default
  end
  return val
end

function GMManager:SetInt(name, val)
  if not self:IsGM() then
    return
  end
  if self.gmIntVal[name] == val then
    return
  end
  self.gmIntVal[name] = val
  if syncCSKeys[name] then
    CSGMSwitch.LuaSetInt(name, val)
  end
  EventManager:GetInstance():Broadcast(EventId.GM_SomeValChanged, name)
  self:SaveToJson()
end

function GMManager:GetString(name, default)
  if not self:IsGM() then
    return
  end
  local val = self.gmStrVal[name]
  if val == nil then
    self:SetString(name, default)
    val = default
  end
  return val
end

function GMManager:SetString(name, val)
  if not self:IsGM() then
    return
  end
  if self.gmStrVal[name] == val then
    return
  end
  self.gmStrVal[name] = val
  EventManager:GetInstance():Broadcast(EventId.GM_SomeValChanged, name)
  self:SaveToJson()
end

function GMManager:AddFav(data)
  if not self:IsGM() then
    return
  end
  if not (data and data.pageName) or not data.name then
    return false
  end
  local key = _GetFavKey(data.pageName, data.name)
  if self.favoriteSet[key] then
    return false
  end
  table.insert(self.favorites, {
    page = data.pageName,
    name = data.name
  })
  self.favoriteSet[key] = true
  self:SaveToJson()
  return true
end

function GMManager:RemoveFav(data)
  if not self:IsGM() then
    return
  end
  if not (data and data.pageName) or not data.name then
    return false
  end
  local key = _GetFavKey(data.pageName, data.name)
  if not self.favoriteSet[key] then
    return false
  end
  self.favoriteSet[key] = nil
  for k, v in ipairs(self.favorites) do
    if v.page == data.pageName and v.name == data.name then
      table.remove(self.favorites, k)
      self:SaveToJson()
      return true
    end
  end
  return false
end

function GMManager:IsInFav(data)
  if not self:IsGM() then
    return
  end
  if not (data and data.pageName) or not data.name then
    return false
  end
  local key = _GetFavKey(data.pageName, data.name)
  return self.favoriteSet and self.favoriteSet[key]
end

function GMManager:GetFavorites()
  return self.favorites or {}
end

function GMManager:DisableSeasonWeather(isDisable)
  if not self:IsGM() then
    return
  end
  if isDisable then
    DataCenter.SeasonWeatherManager:InitData(nil)
  else
    DataCenter.SeasonWeatherManager:TryRequestData(true)
  end
end

function GMManager:AddHappy(getter)
  if not self:IsGM() then
    return
  end
  if not getter then
    return
  end
  if not self.happyWatcher then
    self.happyWatcher = GMHappyWatcher.New()
  end
  return self.happyWatcher:AddHappy(getter)
end

function GMManager:DelHappy(key)
  if not self.happyWatcher then
    return
  end
  return self.happyWatcher:DelHappy(key)
end

function GMManager:GetHappyInfo()
  if not self.happyWatcher then
    return ""
  end
  return self.happyWatcher:GetHappyInfo()
end

return GMManager
