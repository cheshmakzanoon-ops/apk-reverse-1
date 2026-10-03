local base = UIBaseContainer
local UIArenaNewbieAreaWait = BaseClass("UIArenaNewbieAreaWait", base)
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
      Notifier.Dispatch("UIArenaNewbieArea.ShowRules")
    end
  },
  {
    path = "btnRewards",
    name = "btnRewards",
    type = UIButton,
    onClick = function(self)
      Notifier.Dispatch("UIArenaNewbieArea.ShowRewards")
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

function UIArenaNewbieAreaWait:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIArenaNewbieAreaWait:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIArenaNewbieAreaWait:ComponentDefine()
  self:DefineCompsByBook(compBook)
end

function UIArenaNewbieAreaWait:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function UIArenaNewbieAreaWait:OnAddListener()
  base.OnAddListener(self)
end

function UIArenaNewbieAreaWait:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIArenaNewbieAreaWait:Refresh(info)
  self.txtTitle:SetLocalText(LocalController:instance():getValue(TableName.Activity, info.id, "name"))
end

local SEC = 1000
local MIN = 60 * SEC
local HOUR = 60 * MIN

function UIArenaNewbieAreaWait:RefreshTimer(remainTime)
  local hour = math.floor(remainTime / HOUR)
  local min = math.floor((remainTime - hour * HOUR) / MIN)
  local sec = math.floor((remainTime - hour * HOUR - min * MIN) / SEC)
  self.txtHour:SetText(string.format("%02d", hour))
  self.txtMin:SetText(string.format("%02d", min))
  self.txtSec:SetText(string.format("%02d", sec))
end

return UIArenaNewbieAreaWait
