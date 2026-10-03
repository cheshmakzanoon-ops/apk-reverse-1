local ActBattlePassTemplate = BaseClass("ActBattlePassTemplate")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.id = 0
  self.actId = 0
  self.level = 0
  self.levelUpExp = 0
  self.type = 0
  self.highReward = ""
  self.effect_show = 0
end

local function __delete(self)
  self.id = nil
  self.actId = nil
  self.level = nil
  self.levelUpExp = nil
  self.highReward = nil
  self.type = 0
  self.effect_show = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.actId = row:getValue("activity_panel_Id")
  self.level = math.floor(tonumber(row:getValue("level"))) or 0
  self.levelUpExp = tonumber(row:getValue("levelup_exp"))
  self.highReward = tonumber(row:getValue("highlight_reward"))
  self.type = row:getValue("type")
  self.effect_show = tonumber(row:getValue("effect_show")) or 0
end

ActBattlePassTemplate.__init = __init
ActBattlePassTemplate.__delete = __delete
ActBattlePassTemplate.InitData = InitData
return ActBattlePassTemplate
