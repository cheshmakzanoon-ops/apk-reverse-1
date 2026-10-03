local ActivityThanksgivingLotteryTemplate = BaseClass("ActivityThanksgivingLotteryTemplate")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.id = 0
  self.draw_weight = {}
  self.thanksgiving_activity_id = 0
  self.big_reward = {}
  self.convert_reward = {}
  self.show_reward = {}
  self.ticket = 0
  self.getmore_way = {}
  self.tickets_NumShow_tab = {}
end

local function __delete(self)
  self.id = nil
  self.draw_weight = nil
  self.thanksgiving_activity_id = nil
  self.big_reward = nil
  self.convert_reward = nil
  self.show_reward = nil
  self.ticket = nil
  self.getmore_way = nil
  self.tickets_NumShow_tab = nil
end

local function InitConfig(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  local draw_weight_str = row:getValue("draw_weight") or ""
  if not string.IsNullOrEmpty(draw_weight_str) then
    self.draw_weight = string.string2array_num(draw_weight_str, ";", "|")
  end
  self.thanksgiving_activity_id = tonumber(row:getValue("thanksgiving_activity_id")) or 0
  local big_reward_str = row:getValue("big_reward") or ""
  if not string.IsNullOrEmpty(big_reward_str) then
    self.big_reward = string.string2array_i_oneSep(big_reward_str, ";")
  end
  local convert_reward_str = row:getValue("convert_reward") or ""
  if not string.IsNullOrEmpty(convert_reward_str) then
    self.convert_reward = string.string2array_i_oneSep(convert_reward_str, ";")
  end
  local show_reward_str = row:getValue("show_reward") or ""
  if not string.IsNullOrEmpty(show_reward_str) then
    self.show_reward = string.string2array_i_oneSep(show_reward_str, ";")
  end
  self.ticket = tonumber(row:getValue("ticket")) or 0
  local getmore_way_str = row:getValue("getmore_way") or ""
  if not string.IsNullOrEmpty(getmore_way_str) then
    self.getmore_way = string.string2array_s(getmore_way_str, ";", "|")
  end
  local tickets_NumShow = row:getValue("tickets_NumShow") or ""
  if not string.IsNullOrEmpty(tickets_NumShow) then
    self.tickets_NumShow_tab = {}
    local dataStrList = string.split(tickets_NumShow, "|")
    for i, v in ipairs(dataStrList) do
      local dataTab = string.split(v, ";")
      if #dataTab == 2 then
        local num = tonumber(dataTab[2]) or 0
        table.insert(self.tickets_NumShow_tab, {
          num = num,
          icon = dataTab[1]
        })
      end
    end
  end
end

local function GetIconNameByNum(self, num)
  local iconName = ""
  local targetIndex = 0
  if #self.tickets_NumShow_tab == 0 then
    return ""
  end
  for i, v in ipairs(self.tickets_NumShow_tab) do
    if num <= v.num then
      targetIndex = i
      iconName = v.icon
      break
    end
  end
  if targetIndex == 0 then
    targetIndex = #self.tickets_NumShow_tab
    iconName = self.tickets_NumShow_tab[#self.tickets_NumShow_tab].icon
  end
  return iconName
end

ActivityThanksgivingLotteryTemplate.__init = __init
ActivityThanksgivingLotteryTemplate.__delete = __delete
ActivityThanksgivingLotteryTemplate.InitConfig = InitConfig
ActivityThanksgivingLotteryTemplate.GetIconNameByNum = GetIconNameByNum
return ActivityThanksgivingLotteryTemplate
