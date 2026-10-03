local BattleReportUtil = {}
local rapidjson = require("rapidjson")
local Network = CS.GameEntry.Network
local MailBattleReport = require("DataCenter.MailData.DataExtModule.MailBattleReport")
local InRequest = false
local RequestCount = 0
local ToCancelIndex = 0
local EnterType = PVEEnterType.Default
local BattleReportShareHelper = require("DataCenter.MailData.BattleReport.BattleReportShareHelper")
local PreviewEnterType = BattleReportPreviewEnterType.Default

local function UseCDNBattleReport()
  return true
end

local function Create(reportId, enterType, isPreview, isAddressMode, address, previewEnterType)
  if InRequest then
    return
  end
  InRequest = true
  RequestCount = RequestCount + 1
  CommonUtil.PlayerPrefsSetString("LAST_SKIRMISH_MAIL_UUID", tostring(reportId))
  EnterType = enterType
  if isPreview == nil then
    isPreview = false
  end
  address = address or ""
  isAddressMode = isAddressMode or false
  PreviewEnterType = previewEnterType or BattleReportPreviewEnterType.Default
  Network:GetBattleReport(reportId, RequestCount, isPreview, isAddressMode, address)
end

local function Cancel()
  if InRequest then
    ToCancelIndex = RequestCount
    InRequest = false
    Network:CancelBattleReport(ToCancelIndex)
  end
end

local function Handle(t, cancelIndex, uuid)
  InRequest = false
  if cancelIndex <= ToCancelIndex then
    return
  end
  local r = {}
  if t == nil then
    r.errorCode = "fighting_error_tips"
  else
    r.content = t
  end
  if EnterType == PVEEnterType.Debug or BattleReportShareHelper.HasData(PreviewEnterType) then
    BattleReportUtil.OpenMailUI(r)
  else
    BattleReportUtil.HandleMailGetReportDetailMessage(r)
  end
end

function BattleReportUtil.OpenMailUI(r)
  local errCode = r.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  local ext = MailBattleReport.New()
  ext:ParseContentForSkirmish(r)
  local mailInfo = DataCenter.MailDataManager:CreateMailData()
  mailInfo:InitVirtualBattleReportMailData(ext)
  DataCenter.MailDataManager:AddShareMail(mailInfo)
  local fromTag, fromData
  if BattleReportShareHelper.HasData(PreviewEnterType) then
    fromTag = "ConvertBattleReportToVirtualMail"
    fromData = BattleReportShareHelper.GetData(PreviewEnterType)
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWMailMain, {anim = false}, UIMailOpenType.Detail, mailInfo.uid, fromTag, fromData)
end

local function HandleMailGetReportDetailMessage(r)
  local errCode = r.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  local curBattleType = DataCenter.LWBattleManager:GetCurBattleType()
  if curBattleType == PVEType.Skirmish then
    return
  end
  local ext = MailBattleReport.New()
  ext:ParseContentForSkirmish(r)
  local param = {}
  param.type = PVEType.Skirmish
  param.enterType = EnterType
  param.mailExtData = ext
  DataCenter.LWBattleManager:Enter(param)
end

local function DownloadBattleReport(reportId, extra, isAddressMode, address, immediate)
  if string.IsNullOrEmpty(reportId) then
    return
  end
  if type(extra) == "table" then
    extra = rapidjson.encode(extra)
  end
  if isAddressMode == nil then
    isAddressMode = false
  end
  if string.IsNullOrEmpty(address) then
    address = ""
  end
  Network:DownloadBattleReport(reportId, tostring(extra), isAddressMode, address, immediate == true)
end

local function OnBattleReportDownload(code, t, uuid, extra)
  extra = rapidjson.decode(extra)
  if type(extra) ~= "table" then
    extra = {}
  end
  if extra.type == "mail" then
    DataCenter.MailDataManager:OnBattleReportDownload(extra.id, uuid, t, code)
  end
end

local function IsContainsExtraPowerData(player)
  return player.extraPowers ~= nil and #player.extraPowers > 0
end

function BattleReportUtil.IsContainsOtherPowerData(player)
  local isNewOtherPower = BattleReportUtil.IsNewOtherPower(player)
  if isNewOtherPower then
    return player.otherTabPowerInfo and next(player.otherTabPowerInfo.powerInfo) ~= nil
  end
  return IsContainsExtraPowerData(player)
end

function BattleReportUtil.IsNewOtherPower(player)
  return player.otherTabPowerInfo and player.otherTabPowerInfo.isOpen
end

function BattleReportUtil.IsContainsOtherPowerDetailData(player)
  local progress = player.progress
  if not progress then
    return false
  end
  local isExistEffectsDicData = progress.otherEffectsDic and next(progress.otherEffectsDic) ~= nil
  if isExistEffectsDicData then
    return true
  end
  local isNewOtherPower = BattleReportUtil.IsNewOtherPower(player)
  if not isNewOtherPower then
    local isExistEffectsData = progress.extraEffects and table.count(progress.extraEffects) > 0
    return isExistEffectsData or isExistEffectsDicData
  end
  return progress.otherEffects and next(progress.otherEffects) ~= nil
end

local function GetExtraPowerValueByType(player, extraPowerType)
  local ret = 0
  if IsContainsExtraPowerData(player) then
    for _, v in ipairs(player.extraPowers) do
      if v.viewType == extraPowerType then
        ret = v.value or 0
        break
      end
    end
  end
  return ret
end

function BattleReportUtil.GetNewOtherPowerValue(player, extraPowerType)
  local ret = 0
  local isNewExtraPower = player.otherTabPowerInfo and player.otherTabPowerInfo.isOpen
  if isNewExtraPower then
    local newOtherPowerType = ExtraPowerType2OtherPowerTypeMap[extraPowerType]
    for _, v in ipairs(player.otherTabPowerInfo.powerInfo) do
      if v.tabType == newOtherPowerType then
        ret = ret + (v.value or 0)
        break
      end
    end
  elseif IsContainsExtraPowerData(player) then
    for _, v in ipairs(player.extraPowers) do
      if v.viewType == extraPowerType then
        ret = v.value or 0
        break
      end
    end
  end
  return ret
end

local function GetExtraPowerStrAfterFormat(player, extraPowerType)
  local value = GetExtraPowerValueByType(player, extraPowerType)
  return string.GetFormattedStr(math.floor(value))
end

function BattleReportUtil.GetNewOtherPowerStrAfterFormat(player, extraPowerType)
  local value = BattleReportUtil.GetNewOtherPowerValue(player, extraPowerType)
  if extraPowerType == ExtraPowerInfoType.Mastery and player and player.otherTabPowerInfo and player.otherTabPowerInfo.isOpen and player.otherTabPowerInfo.powerInfo then
    local campSciencePower = 0
    local militrayPower = 0
    for _, v in ipairs(player.otherTabPowerInfo.powerInfo) do
      if v.tabType == NewOtherPowerInfoType.CampScience then
        campSciencePower = v.value or 0
      elseif v.tabType == NewOtherPowerInfoType.Militray then
        militrayPower = v.value or 0
      end
    end
    value = value + campSciencePower + militrayPower
  end
  return string.GetFormattedStr(math.floor(value))
end

local function IsAddressMode(address)
  return not string.IsNullOrEmpty(address)
end

local function ShowBattleReport(inputStr)
  if not CS.SDKManager.IS_UNITY_EDITOR() and not CS.CommonUtils.IsDebug() then
    return
  end
  if string.IsNullOrEmpty(inputStr) then
    return
  end
  local md5 = CS.StringUtils.GetMD5(inputStr)
  local index = string.lower(string.sub(md5, 1, 2))
  local address = "ali://report/" .. index .. "/" .. inputStr .. ".bin"
  local address1 = "ali://report/" .. inputStr .. ".bin"
  local address_aws1 = "aws://report/" .. index .. "/" .. inputStr .. ".bin"
  local address_aws2 = "aws://report/" .. inputStr .. ".bin"
  local addressList = {}
  table.insert(addressList, address)
  table.insert(addressList, address1)
  table.insert(addressList, address_aws1)
  table.insert(addressList, address_aws2)
  local addressIndex = 0
  local timer
  timer = TimerManager:GetInstance():GetTimer(1, function()
    addressIndex = addressIndex + 1
    local reportAddress = addressList[addressIndex] or ""
    if addressIndex == #addressList then
      timer:Stop()
    end
    BattleReportUtil.Create(inputStr, PVEEnterType.Debug, false, true, reportAddress)
  end)
  if timer then
    timer:Start()
  end
end

local function ShowLocalBattleReport(inputStr)
  if not CS.SDKManager.IS_UNITY_EDITOR() and not CS.CommonUtils.IsDebug() then
    return
  end
  if string.IsNullOrEmpty(inputStr) then
    Logger.LogError("reportId is empty")
    return
  end
  local md5 = CS.StringUtils.GetMD5(inputStr)
  local index = string.lower(string.sub(md5, 1, 2))
  local address = "ali_local://report/" .. index .. "/" .. inputStr .. ".bin"
  local address1 = "ali_local://report/" .. inputStr .. ".bin"
  BattleReportUtil.Create(inputStr, PVEEnterType.Debug, false, true, address)
  TimerManager:GetInstance():DelayInvoke(function()
    BattleReportUtil.Create(inputStr, PVEEnterType.Debug, false, true, address1)
  end, 1)
end

local OTHER_POWER_VERSION = 8

function BattleReportUtil.ShouldHideOtherPower(extData)
  if not extData then
    return false
  end
  local version = extData:GetVersion()
  if version < OTHER_POWER_VERSION then
    return false
  end
  local player1 = extData.player[1]
  local player2 = extData.player[2]
  if not player1 or not player2 then
    return false
  end
  local isPlayer1NewOtherPower = player1.otherTabPowerInfo and player1.otherTabPowerInfo.isOpen
  local isPlayer2NewOtherPower = player2.otherTabPowerInfo and player2.otherTabPowerInfo.isOpen
  if isPlayer1NewOtherPower and isPlayer2NewOtherPower then
    return false
  end
  return true
end

BattleReportUtil.Create = Create
BattleReportUtil.Cancel = Cancel
BattleReportUtil.Handle = Handle
BattleReportUtil.DownloadBattleReport = DownloadBattleReport
BattleReportUtil.OnBattleReportDownload = OnBattleReportDownload
BattleReportUtil.UseCDNBattleReport = UseCDNBattleReport
BattleReportUtil.HandleMailGetReportDetailMessage = HandleMailGetReportDetailMessage
BattleReportUtil.GetExtraPowerValueByType = GetExtraPowerValueByType
BattleReportUtil.IsContainsExtraPowerData = IsContainsExtraPowerData
BattleReportUtil.GetExtraPowerStrAfterFormat = GetExtraPowerStrAfterFormat
BattleReportUtil.IsAddressMode = IsAddressMode
BattleReportUtil.ShowBattleReport = ShowBattleReport
BattleReportUtil.ShowLocalBattleReport = ShowLocalBattleReport
return ConstClass("BattleReportUtil", BattleReportUtil)
