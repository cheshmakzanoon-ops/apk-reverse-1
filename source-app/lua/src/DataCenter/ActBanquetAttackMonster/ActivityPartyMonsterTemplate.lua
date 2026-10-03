local ActivityPartyMonsterTemplate = BaseClass("ActivityPartyMonsterTemplate")

local function __init(self)
  self.id = 0
  self.level = 0
  self.type = 0
  self.blood = 0
  self.show_reward1 = {}
  self.show_reward2 = {}
  self.show_reward3 = {}
  self.name = ""
  self.desc = ""
  self.model_name = ""
  self.act_1 = ""
  self.act_2 = ""
  self.act_3 = ""
  self.act_4 = ""
  self.act_5 = ""
  self.act_2_text = ""
  self.act_3_text = ""
  self.act_5_text = ""
  self.pic_name = ""
  self.scale = 1
  self.hit_pos = 1
  self.blood_pos = 258
  self.plot_pos = {}
  self.com_attack_angle = {}
  self.show_reward_text = {}
  self.show_reward1_tip = {}
  self.show_reward2_tip = {}
  self.show_reward3_tip = {}
  self.record_tips = nil
  self.quality = 1
  self.record_config = {}
  self.bubble_color = ""
end

local function __delete(self)
  self.id = nil
  self.level = nil
  self.type = nil
  self.blood = nil
  self.show_reward1 = nil
  self.show_reward2 = nil
  self.show_reward3 = nil
  self.name = nil
  self.desc = nil
  self.model_name = nil
  self.act_1 = nil
  self.act_2 = nil
  self.act_3 = nil
  self.act_4 = nil
  self.act_5 = nil
  self.act_2_text = nil
  self.act_3_text = nil
  self.act_5_text = nil
  self.pic_name = nil
  self.scale = nil
  self.hit_pos = nil
  self.blood_pos = nil
  self.plot_pos = nil
  self.com_attack_angle = nil
  self.show_reward_text = nil
  self.show_reward1_tip = nil
  self.show_reward2_tip = nil
  self.show_reward3_tip = nil
  self.record_tips = nil
  self.quality = nil
  self.record_config = nil
  self.bubble_color = nil
end

local function ParseData(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.level = tonumber(row:getValue("level")) or 0
  self.type = tonumber(row:getValue("type")) or 0
  self.blood = tonumber(row:getValue("blood")) or 0
  local show_reward1 = row:getValue("show_reward1")
  if not string.IsNullOrEmpty(show_reward1) then
    self.show_reward1 = string.string2array_i(show_reward1, ";", "|")
  end
  local show_reward2 = row:getValue("show_reward2")
  if not string.IsNullOrEmpty(show_reward2) then
    self.show_reward2 = string.string2array_i(show_reward2, ";", "|")
  end
  local show_reward3 = row:getValue("show_reward3")
  if not string.IsNullOrEmpty(show_reward3) then
    self.show_reward3 = string.string2array_i(show_reward3, ";", "|")
  end
  self.name = row:getValue("name")
  self.desc = row:getValue("desc")
  self.model_name = row:getValue("model_name")
  self.act_1 = row:getValue("act_1")
  self.act_2 = row:getValue("act_2")
  self.act_3 = row:getValue("act_3")
  self.act_4 = row:getValue("act_4")
  self.act_5 = row:getValue("act_5")
  self.act_2_text = row:getValue("act_2_text")
  self.act_3_text = row:getValue("act_3_text")
  self.act_5_text = row:getValue("act_5_text")
  self.pic_name = row:getValue("pic_name")
  self.scale = tonumber(row:getValue("scale")) or 1
  self.hit_pos = tonumber(row:getValue("hit_pos")) or 1
  self.blood_pos = tonumber(row:getValue("blood_pos")) or 258
  local plot_pos = tostring(row:getValue("plot_pos"))
  if not string.IsNullOrEmpty(plot_pos) then
    self.plot_pos = string.string2array_num_oneSep(plot_pos, "|")
  end
  local com_attack_angle = tostring(row:getValue("com_attack_angle"))
  if not string.IsNullOrEmpty(com_attack_angle) then
    self.com_attack_angle = string.string2array_num_oneSep(com_attack_angle, "|")
  end
  local show_reward_text = row:getValue("show_reward_text")
  if not string.IsNullOrEmpty(show_reward_text) then
    local strTab = string.string2array_s(show_reward_text, ";", "|")
    self.show_reward_text = {}
    for i, v in ipairs(strTab) do
      if #v == 4 then
        local data = {
          tonumber(v[1]),
          tonumber(v[2]),
          tonumber(v[3]),
          v[4]
        }
        table.insert(self.show_reward_text, data)
      end
    end
  end
  local show_reward1_tip = row:getValue("show_reward1_tip")
  if not string.IsNullOrEmpty(show_reward1_tip) then
    self.show_reward1_tip = string.string2array_num_oneSep(show_reward1_tip, "|")
  end
  local show_reward2_tip = row:getValue("show_reward2_tip")
  if not string.IsNullOrEmpty(show_reward2_tip) then
    self.show_reward2_tip = string.string2array_num_oneSep(show_reward2_tip, "|")
  end
  local show_reward3_tip = row:getValue("show_reward3_tip")
  if not string.IsNullOrEmpty(show_reward3_tip) then
    self.show_reward3_tip = string.string2array_num_oneSep(show_reward3_tip, "|")
  end
  self.record_tips = row:getValue("record_tips") or {}
  self.quality = row:getValue("quality") or 1
  self.record_config = row:getValue("record_config") or {}
  self.bubble_color = row:getValue("bubble_color") or ""
end

ActivityPartyMonsterTemplate.__init = __init
ActivityPartyMonsterTemplate.__delete = __delete
ActivityPartyMonsterTemplate.ParseData = ParseData
return ActivityPartyMonsterTemplate
