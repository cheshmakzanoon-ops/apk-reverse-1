local UISettingAllianceCtrl = BaseClass("UISettingAllianceCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISettingAlliance)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function GetCurrentAllianceData(self)
  local oneData = {}
  oneData.abbr = ""
  oneData.name = ""
  oneData.intro = ""
  oneData.recruitTotal = 0
  oneData.language = "390759"
  oneData.castleRestrictionN = 1
  oneData.powerRestrictionN = 0
  oneData.country = DefaultNation
  local data = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  if data ~= nil then
    oneData.abbr = data.abbr
    oneData.icon = data.icon
    oneData.name = data.allianceName
    oneData.intro = data.intro
    oneData.country = data.country
    oneData.recruitTotal = data.recruitTotal
    oneData.recommendFunc = data.recommendFunc
    oneData.castleRestrictionN = data.castleRestrictionN
    oneData.powerRestrictionN = data.powerRestrictionN
    if data.language ~= nil and data.language ~= "" then
      oneData.language = data.language
    end
    oneData.lookForCareers = data.lookForCareers
  end
  return oneData
end

local function OnChangeAbbrClick(self, abbr)
  local param = {}
  param.curAbbr = abbr
  local alBaseInfo = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  param.cost = 0
  if alBaseInfo and 0 < alBaseInfo.abbrRename then
    local k2 = LuaEntry.DataConfig:TryGetStr("alliance_cost", "k2")
    param.cost = tonumber(k2)
  end
  
  function param.callback(value)
    SFSNetwork.SendMessage(MsgDefines.AllianceChangeAttributes, "", value, -1, "", "")
  end
  
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceChangeAbbr, {anim = true}, param)
end

local function OnChangeNameClick(self, name)
  local param = {}
  param.curName = name
  local alBaseInfo = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  param.cost = alBaseInfo and alBaseInfo.rename == 0 and 0 or CreateAllianceCostGold
  
  function param.callback(value)
    SFSNetwork.SendMessage(MsgDefines.AllianceChangeAttributes, value, "", -1, "", "")
  end
  
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceChangeName, {anim = true}, param)
end

local function OnLanguageClick(self, language)
  local param = {}
  param.curLanguage = language
  
  function param.callback(value)
    EventManager:GetInstance():Broadcast(EventId.AllianceLanguage, value)
    SFSNetwork.SendMessage(MsgDefines.AllianceChangeAttributes, "", "", -1, "", value)
  end
  
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceChangeLanguage, {anim = true}, param)
end

local function OnCareerClick(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILookForCareer, {anim = true})
end

local function OnChangeClick(self, joinSetting)
  SFSNetwork.SendMessage(MsgDefines.AllianceChangeAttributes, "", "", joinSetting)
end

local function OnRecommendClick(self, recommendState)
  SFSNetwork.SendMessage(MsgDefines.AllianceChangeAttributes, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, recommendState)
end

local function OnIntroClick(self, intro)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceChangeAnnounce, {anim = true}, 1, intro)
end

local function OnLevelClick(self, levelRestriction, powerRestriction)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceChangeRestriction, {anim = true}, levelRestriction, powerRestriction)
end

UISettingAllianceCtrl.CloseSelf = CloseSelf
UISettingAllianceCtrl.Close = Close
UISettingAllianceCtrl.GetCurrentAllianceData = GetCurrentAllianceData
UISettingAllianceCtrl.OnChangeAbbrClick = OnChangeAbbrClick
UISettingAllianceCtrl.OnChangeNameClick = OnChangeNameClick
UISettingAllianceCtrl.OnLanguageClick = OnLanguageClick
UISettingAllianceCtrl.OnCareerClick = OnCareerClick
UISettingAllianceCtrl.OnChangeClick = OnChangeClick
UISettingAllianceCtrl.OnIntroClick = OnIntroClick
UISettingAllianceCtrl.OnLevelClick = OnLevelClick
UISettingAllianceCtrl.OnRecommendClick = OnRecommendClick
return UISettingAllianceCtrl
