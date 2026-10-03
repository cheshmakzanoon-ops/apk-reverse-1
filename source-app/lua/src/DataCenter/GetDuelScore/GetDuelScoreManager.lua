local GetDuelScoreManager = BaseClass("GetDuelScoreManager")
local GetPersonDuelScoreInfo = require("DataCenter.GetDuelScore.GetPersonDuelScoreInfo")
local GetAllyDuelScoreInfo = require("DataCenter.GetDuelScore.GetAllyDuelScoreInfo")
local Setting = CS.GameEntry.Setting

local function __init(self)
  self.duelInfos = {}
end

local function __delete(self)
  self.duelInfos = nil
end

local function GetScriptByType(self, type)
  if type == GetDuelScoreType.Person then
    return GetPersonDuelScoreInfo
  elseif type == GetDuelScoreType.Ally then
    return GetAllyDuelScoreInfo
  end
end

local function GetDuelInfoByType(self, type)
  local duelInfo = self.duelInfos[type]
  if duelInfo == nil then
    local script = self:GetScriptByType(type)
    if script then
      duelInfo = script.New(type)
      self.duelInfos[type] = duelInfo
    end
  end
  return duelInfo
end

local function SetScoreByType(self, type, data)
  local duelInfo = self:GetDuelInfoByType(type)
  if duelInfo then
    duelInfo:OnSetScoreData(data)
  end
end

local function PushScoreChangeByType(self, type, data)
  local isOn = self:GetIsOnByType(type)
  if isOn and UIManager:GetInstance():GetWindow(UIWindowNames.UILWMailMain) == nil then
    local duelInfo = self:GetDuelInfoByType(type)
    if duelInfo then
      duelInfo:OnPushScoreChange(data)
    end
  end
end

local function OpenGetDuelScoreView(self, scoreType, oldScore, newScore, targetGroups, isDiff)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIGetDuelScoreTip, {anim = true})
  local window = UIManager:GetInstance():GetWindow(UIWindowNames.UIGetDuelScoreTip)
  if window ~= nil and window.View ~= nil then
    window.View:AddData(scoreType, oldScore, newScore, targetGroups, isDiff)
    if window.View:GetActive() then
      window.View:RefreshView()
    end
  end
end

local function UseSpeed(self, speedType, itemId, count)
  local speedScoreValue = ItemSpdMenu2SpeedScoreValue[speedType]
  if speedScoreValue then
    local template = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
    if template then
      local temp = string.split(template.para1, ";")
      if temp ~= nil and 1 < #temp then
        local time = DataCenter.ItemTemplateManager:GetShowTime(temp[1], temp[2]) / 60000
        for key, value in pairs(GetDuelScoreType) do
          local duel = self:GetDuelInfoByType(value)
          if duel and self:GetIsOnByType(value) and UIManager:GetInstance():GetWindow(UIWindowNames.UILWMailMain) == nil then
            duel:OnUseSpeed(speedScoreValue, count * time)
          end
        end
      end
    end
  end
end

local function ClearAllDuelInfo(self)
  for key, value in pairs(GetDuelScoreType) do
    local duelInfo = self.duelInfos[value]
    if duelInfo then
      duelInfo:Clear()
    end
  end
end

local function ClearDuelInfoByType(self, type)
  local duelInfo = self:GetDuelInfoByType(type)
  if duelInfo then
    duelInfo:Clear()
  end
end

local function GetIsOnByType(self, type)
  local key = GetDuelScoreType2SettingKey[type]
  return Setting:GetBool(key, true)
end

local function SetIsOnByType(self, type, isOn)
  local key = GetDuelScoreType2SettingKey[type]
  Setting:SetBool(key, isOn)
end

GetDuelScoreManager.__init = __init
GetDuelScoreManager.__delete = __delete
GetDuelScoreManager.GetScriptByType = GetScriptByType
GetDuelScoreManager.GetDuelInfoByType = GetDuelInfoByType
GetDuelScoreManager.OpenGetDuelScoreView = OpenGetDuelScoreView
GetDuelScoreManager.SetScoreByType = SetScoreByType
GetDuelScoreManager.PushScoreChangeByType = PushScoreChangeByType
GetDuelScoreManager.UseSpeed = UseSpeed
GetDuelScoreManager.ClearAllDuelInfo = ClearAllDuelInfo
GetDuelScoreManager.GetIsOnByType = GetIsOnByType
GetDuelScoreManager.SetIsOnByType = SetIsOnByType
GetDuelScoreManager.ClearDuelInfoByType = ClearDuelInfoByType
return GetDuelScoreManager
