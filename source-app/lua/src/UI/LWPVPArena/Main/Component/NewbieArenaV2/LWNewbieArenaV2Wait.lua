local base = UIBaseContainer
local LWNewbieArenaV2Wait = BaseClass("LWNewbieArenaV2Wait", base)
local Localization = CS.GameEntry.Localization
local Notifier = require("Common.Notifier")
local compBook = {
  {
    path = "txtTitle",
    name = "txtTitle",
    type = UIText
  },
  {
    path = "txtDesc",
    name = "txtDesc",
    type = UIText,
    textKey = "500269"
  },
  {
    path = "txtHour",
    name = "txtHour",
    type = UIText
  },
  {
    path = "txtMin",
    name = "txtMin",
    type = UIText
  },
  {
    path = "txtSec",
    name = "txtSec",
    type = UIText
  },
  {
    path = "btnRules",
    name = "btnRules",
    type = UIButton,
    onClick = function(self)
      Notifier.Dispatch("LWNewbieArenaV2PageArea.ShowRules")
    end
  },
  {
    path = "btnRewards",
    name = "btnRewards",
    type = UIButton,
    onClick = function(self)
      Notifier.Dispatch("LWNewbieArenaV2PageArea.ShowRewards")
    end
  },
  {
    path = "btnRules/txtRules",
    name = "txtRules",
    type = UIText,
    textKey = "372116"
  },
  {
    path = "btnRewards/txtRewards",
    name = "txtRewards",
    type = UIText,
    textKey = "130065"
  }
}

function LWNewbieArenaV2Wait:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function LWNewbieArenaV2Wait:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWNewbieArenaV2Wait:ComponentDefine()
  self:DefineCompsByBook(compBook)
end

function LWNewbieArenaV2Wait:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function LWNewbieArenaV2Wait:OnAddListener()
  base.OnAddListener(self)
end

function LWNewbieArenaV2Wait:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWNewbieArenaV2Wait:Refresh(info)
  self.txtTitle:SetLocalText(LocalController:instance():getValue(TableName.Activity, info.id, "name"))
end

local SEC = 1000
local MIN = 60 * SEC
local HOUR = 60 * MIN

function LWNewbieArenaV2Wait:RefreshTimer(remainTime)
  local hour = math.floor(remainTime / HOUR)
  local min = math.floor((remainTime - hour * HOUR) / MIN)
  local sec = math.floor((remainTime - hour * HOUR - min * MIN) / SEC)
  self.txtHour:SetText(string.format("%02d", hour))
  self.txtMin:SetText(string.format("%02d", min))
  self.txtSec:SetText(string.format("%02d", sec))
end

return LWNewbieArenaV2Wait
