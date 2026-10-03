local base = UIBaseContainer
local BankReportContent = BaseClass("BankReportContent", base)
local Localization = CS.GameEntry.Localization
local cdNumber_path = "cdNumber"
local depositor_path = "depositor"
local bank_path = "bank"
local bankAddress_path = "bankAddress"
local bankAddressBtn_path = "bankAddress"
local currentControl_path = "currentControl"
local currentControlLost_path = "currentControlLost"
local settlementTime_path = "settlementTime"
local depositDate_path = "depositDate"
local lostTime_path = "lostTime"
local refundTime_path = "refundTime"
local depositDuration_path = "depositDuration"
local depositorInterest_path = "depositorInterest"
local depositAmount_path = "depositAmount"
local depositAmountLost_path = "depositAmountLost"
local leftTime_path = "leftTime"
local total_path = "total"
local totalDue_path = "totalDue"
local totalLost_path = "totalLost"
local totalRefund_path = "totalRefund"
local totalIcon_path = "total/totalIcon"
local totalDueIcon_path = "totalDue/totalDueIcon"
local totalLostIcon_path = "totalLost/totalLostIcon"
local totalRefundIcon_path = "totalRefund/totalRefundIcon"
local depositAmountIcon_path = "depositAmount/depositAmountIcon"
local depositAmountLostIcon_path = "depositAmountLost/depositAmountLostIcon"
local tipsText_path = "tipsText"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.cdNumber = self:AddComponent(UIText, cdNumber_path)
  self.depositor = self:AddComponent(UIText, depositor_path)
  self.bank = self:AddComponent(UIText, bank_path)
  self.bankAddress = self:AddComponent(UIText, bankAddress_path)
  self.bankAddressBtn = self:AddComponent(UIButton, bankAddressBtn_path)
  self.currentControl = self:AddComponent(UIText, currentControl_path)
  self.currentControlLost = self:AddComponent(UIText, currentControlLost_path)
  self.settlementTime = self:AddComponent(UIText, settlementTime_path)
  self.depositDate = self:AddComponent(UIText, depositDate_path)
  self.lostTime = self:AddComponent(UIText, lostTime_path)
  self.refundTime = self:AddComponent(UIText, refundTime_path)
  self.depositDuration = self:AddComponent(UIText, depositDuration_path)
  self.depositorInterest = self:AddComponent(UIText, depositorInterest_path)
  self.depositAmount = self:AddComponent(UIText, depositAmount_path)
  self.depositAmountLost = self:AddComponent(UIText, depositAmountLost_path)
  self.leftTime = self:AddComponent(UIText, leftTime_path)
  self.total = self:AddComponent(UIText, total_path)
  self.totalDue = self:AddComponent(UIText, totalDue_path)
  self.totalLost = self:AddComponent(UIText, totalLost_path)
  self.totalRefund = self:AddComponent(UIText, totalRefund_path)
  self.totalIcon = self:AddComponent(UIImage, totalIcon_path)
  self.totalDueIcon = self:AddComponent(UIImage, totalDueIcon_path)
  self.totalLostIcon = self:AddComponent(UIImage, totalLostIcon_path)
  self.totalRefundIcon = self:AddComponent(UIImage, totalRefundIcon_path)
  self.depositAmountIcon = self:AddComponent(UIImage, depositAmountIcon_path)
  self.depositAmountLostIcon = self:AddComponent(UIImage, depositAmountLostIcon_path)
  self.tipsText = self:AddComponent(UIText, tipsText_path)
  self.bankAddressBtn:SetOnClick(function()
    if self.data and self.data.bankAddr then
      local v3 = SceneUtils.TileIndexToWorld(self.data.bankAddr.pointId, ForceChangeScene.World)
      GoToUtil.CloseAllWindows()
      GoToUtil.GotoWorldPos(v3, CS.SceneManager.World.InitZoom, LookAtFocusTime, nil, self.data.bankAddr.serverId, 0)
    end
  end)
end

local function ComponentDestroy(self)
  self.cdNumber = nil
  self.depositor = nil
  self.bank = nil
  self.bankAddress = nil
  self.bankAddressBtn = nil
  self.currentControl = nil
  self.currentControlLost = nil
  self.settlementTime = nil
  self.depositDate = nil
  self.lostTime = nil
  self.refundTime = nil
  self.depositDuration = nil
  self.depositorInterest = nil
  self.depositAmount = nil
  self.depositAmountLost = nil
  self.leftTime = nil
  self.total = nil
  self.totalDue = nil
  self.totalLost = nil
  self.totalRefund = nil
  self.totalIcon = nil
  self.totalDueIcon = nil
  self.totalLostIcon = nil
  self.totalRefundIcon = nil
  self.depositAmountIcon = nil
  self.depositAmountLostIcon = nil
  self.tipsText = nil
end

local function DataDefine(self)
  self.__TypeInfo = {
    depositor = {
      show = {
        true,
        true,
        true,
        true
      }
    },
    bank = {
      show = {
        true,
        true,
        true,
        true
      }
    },
    bankAddress = {
      show = {
        true,
        true,
        true,
        true
      }
    },
    currentControl = {
      show = {
        false,
        false,
        true,
        false
      }
    },
    currentControlLost = {
      show = {
        false,
        true,
        false,
        false
      }
    },
    depositDate = {
      show = {
        true,
        true,
        true,
        true
      }
    },
    settlementTime = {
      show = {
        true,
        false,
        false,
        true
      }
    },
    lostTime = {
      show = {
        false,
        true,
        false,
        false
      }
    },
    refundTime = {
      show = {
        false,
        false,
        true,
        false
      }
    },
    depositDuration = {
      show = {
        true,
        true,
        true,
        true
      }
    },
    depositorInterest = {
      show = {
        true,
        true,
        true,
        true
      }
    },
    depositAmount = {
      show = {
        true,
        false,
        true,
        true
      },
      icon = "depositAmountIcon"
    },
    depositAmountLost = {
      show = {
        false,
        true,
        false,
        false
      },
      icon = "depositAmountLostIcon"
    },
    leftTime = {
      show = {
        true,
        false,
        false,
        false
      }
    },
    total = {
      show = {
        true,
        false,
        false,
        false
      },
      icon = "totalIcon"
    },
    totalDue = {
      show = {
        false,
        false,
        false,
        true
      },
      icon = "totalDueIcon"
    },
    totalLost = {
      show = {
        false,
        true,
        false,
        false
      },
      icon = "totalLostIcon"
    },
    totalRefund = {
      show = {
        false,
        false,
        true,
        false
      },
      icon = "totalRefundIcon"
    }
  }
end

local Convert = {
  [SeasonBankReportType.DEPOSIT_TO] = 1,
  [SeasonBankReportType.DEPOSIT_DUE] = 4,
  [SeasonBankReportType.RETURE] = 3,
  [SeasonBankReportType.BE_ROBBED] = 2
}

local function DataDestroy(self)
end

function BankReportContent:ReInit(extData, curData)
  local data = extData
  self.data = data
  local reportType = Convert[data.logTypeCode or 1]
  local bankAddr = data.bankAddr or {}
  local userObj = data.userObj or {}
  self.meta = DataCenter.AllianceCityTemplateManager:GetTemplate(bankAddr.id or 0, bankAddr.serverId or 0)
  local uid = extData and extData.orderNum
  if uid and 0 < uid then
    uid = tostring(uid)
  else
    uid = curData and curData.uid or extData.uid or ""
  end
  if string.len(uid) > 12 then
    uid = string.sub(uid, -12)
  end
  self.cdNumber:SetText(uid)
  self.tipsText:SetLocalText(self:GetReportInfo("bankSign", data.logTypeCode))
  if self:Check("depositor", reportType) then
    self.depositor:SetText(string.format("#%s[%s]%s", userObj.serverId, userObj.abbr, userObj.name))
  end
  if self:Check("bank", reportType) then
    if data.oldAllianceObj and data.oldAllianceObj.hasAlliance then
      self.bank:SetText(string.format("#%s[%s]%s", data.oldAllianceObj.serverId, data.oldAllianceObj.abbr, data.oldAllianceObj.name))
    else
      self.bank:SetLocalText("s5_allianceflag_tips04")
    end
  end
  if self:Check("bankAddress", reportType) then
    local location = SceneUtils.IndexToTilePos(bankAddr.pointId or 0, ForceChangeScene.World)
    self.bankAddress:SetText(self:FormatCoordinateText(location, bankAddr.serverId or 0))
  end
  if self:Check("currentControl", reportType) then
    if data.currAllianceObj and data.currAllianceObj.hasAlliance then
      self.currentControl:SetText(string.format("#%s[%s]%s", data.currAllianceObj.serverId, data.currAllianceObj.abbr, data.currAllianceObj.name))
    else
      self.currentControl:SetLocalText("s5_allianceflag_tips04")
    end
  end
  if self:Check("currentControlLost", reportType) then
    if data.currAllianceObj and data.currAllianceObj.hasAlliance then
      self.currentControlLost:SetText(string.format("#%s[%s]%s", data.currAllianceObj.serverId, data.currAllianceObj.abbr, data.currAllianceObj.name))
    else
      self.currentControlLost:SetLocalText("s5_allianceflag_tips04")
    end
  end
  if self:Check("depositDate", reportType) then
    self.depositDate:SetText(UITimeManager:GetInstance():TimeStampToTimeForLocalMinute(data.depositTime))
  end
  if self:Check("settlementTime", reportType) then
    self.settlementTime:SetText(UITimeManager:GetInstance():TimeStampToTimeForLocalMinute(data.settleTime))
  end
  if self:Check("lostTime", reportType) then
    self.lostTime:SetText(UITimeManager:GetInstance():TimeStampToTimeForLocalMinute(data.settleTime))
  end
  if self:Check("refundTime", reportType) then
    self.refundTime:SetText(UITimeManager:GetInstance():TimeStampToTimeForLocalMinute(data.settleTime))
  end
  if self:Check("depositDuration", reportType) then
    self.depositDuration:SetLocalText(320365, data.depositDays)
  end
  if self:Check("depositorInterest", reportType) then
    local curRate = data.rate * 10000
    curRate = curRate - curRate % 0.1
    self.depositorInterest:SetLocalText(320362, math.ceil(curRate * 0.01))
  end
  if self:Check("depositAmount", reportType) then
    self.depositAmount:SetLocalText(390902, data.depositAmount)
  end
  if self:Check("depositAmountLost", reportType) then
    self.depositAmountLost:SetLocalText(390902, data.depositAmount)
  end
  self.EndTime = nil
  if self:Check("leftTime", reportType) then
    if data.settleTime and data.settleTime > UITimeManager:GetInstance():GetServerTime() then
      self.EndTime = data.settleTime
      self:Update1000MS()
    else
      self.leftTime:SetActive(false)
    end
  end
  if self:Check("total", reportType) then
    self.total:SetLocalText(390902, data.settleAmount or 0)
  end
  if self:Check("totalDue", reportType) then
    self.totalDue:SetLocalText(390902, data.settleAmount or 0)
  end
  if self:Check("totalLost", reportType) then
    self.totalLost:SetLocalText(390902, data.settleAmount or 0)
  end
  if self:Check("totalRefund", reportType) then
    self.totalRefund:SetLocalText(390902, data.settleAmount or 0)
  end
end

function BankReportContent:Check(key, reportType)
  local info = self.__TypeInfo[key]
  if info and info.show and info.show[reportType] then
    self[key]:SetActive(true)
    if info.icon and self[info.icon] then
      DataCenter.SeasonBankManager:LoadItemIcon(self[info.icon], self.meta)
    end
    return true
  end
  self[key]:SetActive(false)
  return false
end

function BankReportContent:GetReportInfo(key, reportType)
  local reportInfo = DataCenter.SeasonBankTemplateManager[key]
  return reportInfo and reportInfo[reportType] or nil
end

function BankReportContent:FormatCoordinateText(pos, serverId)
  if serverId and 0 < serverId then
    return string.format("#%s X:%s,Y:%s", serverId, pos.x, pos.y)
  else
    return string.format("X:%s,Y:%s", pos.x, pos.y)
  end
end

function BankReportContent:Update1000MS()
  if self.EndTime and UIUtil.SetLeftTimeText(self.leftTime, nil, self.EndTime) then
    self.leftTime:SetActive(false)
    self.EndTime = nil
  end
end

BankReportContent.OnCreate = OnCreate
BankReportContent.OnDestroy = OnDestroy
BankReportContent.OnEnable = OnEnable
BankReportContent.OnDisable = OnDisable
BankReportContent.ComponentDefine = ComponentDefine
BankReportContent.ComponentDestroy = ComponentDestroy
BankReportContent.DataDefine = DataDefine
BankReportContent.DataDestroy = DataDestroy
return BankReportContent
