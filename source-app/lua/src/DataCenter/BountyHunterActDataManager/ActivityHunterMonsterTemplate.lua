local ActivityHunterMonsterTemplate = BaseClass("ActivityHunterMonsterTemplate")

function ActivityHunterMonsterTemplate:__init()
  self.id = 0
  self.group = 0
  self.level = 0
  self.type = 0
  self.color = 0
  self.blood = 0
  self.monsterType = 0
  self.scale = 0
  self.drop_box = ""
  self.reward = ""
  self.reward2 = ""
  self.reward_show = ""
  self.reward2_show = ""
  self.name = ""
  self.desc = ""
  self.model_name = ""
  self.idle_act = ""
  self.idle_range = ""
  self.act_2 = ""
  self.act_3 = ""
  self.act_2_text = ""
  self.act_3_text = ""
  self.act_4 = ""
  self.act_5 = ""
  self.act_5_text = ""
  self.head_icon = ""
  self.head_bg = ""
  self.hit_pos = ""
  self.blood_pos = ""
  self.plot_pos = ""
  self.com_attack_angle = ""
  self.effect_list1 = ""
  self.effect_list2 = ""
  self.init_rotation = ""
  self.clickSize = ""
  self.rate_show_tips = 0
  self.clickWidth = 100
  self.clickHeight = 100
  self.dead_ani_param = 0
end

function ActivityHunterMonsterTemplate:__delete()
  self.id = nil
  self.group = nil
  self.level = nil
  self.type = nil
  self.color = nil
  self.blood = nil
  self.monsterType = nil
  self.scale = nil
  self.drop_box = nil
  self.reward = nil
  self.reward2 = nil
  self.reward_show = nil
  self.reward2_show = nil
  self.name = nil
  self.desc = nil
  self.model_name = nil
  self.idle_act = nil
  self.idle_range = nil
  self.act_2 = nil
  self.act_3 = nil
  self.act_2_text = nil
  self.act_3_text = nil
  self.act_4 = nil
  self.act_5 = nil
  self.act_5_text = nil
  self.head_icon = nil
  self.head_bg = nil
  self.hit_pos = nil
  self.blood_pos = nil
  self.plot_pos = nil
  self.com_attack_angle = nil
  self.effect_list1 = nil
  self.effect_list2 = nil
  self.init_rotation = nil
  self.clickHeight = nil
  self.rate_show_tips = nil
  self.mustRewardList = nil
  self.probRewardList = nil
  self.clickWidth = nil
  self.clickSize = nil
  self.dead_ani_param = nil
end

function ActivityHunterMonsterTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.group = rowData:getValue("group") or 0
  self.level = rowData:getValue("level") or 0
  self.type = rowData:getValue("type") or 0
  self.color = rowData:getValue("color") or 0
  self.blood = rowData:getValue("blood") or 0
  self.monsterType = rowData:getValue("monsterType") or 1
  self.scale = rowData:getValue("scale") or 1
  self.drop_box = rowData:getValue("drop_box") or ""
  self.reward = rowData:getValue("reward") or ""
  self.reward2 = rowData:getValue("reward2") or ""
  self.reward_show = rowData:getValue("reward_show") or ""
  self.reward2_show = rowData:getValue("reward2_show") or ""
  self.name = rowData:getValue("name") or ""
  self.desc = rowData:getValue("desc") or ""
  self.model_name = rowData:getValue("model_name") or ""
  self.idle_act = rowData:getValue("idle_act") or ""
  self.idle_range = rowData:getValue("idle_range") or ""
  self.act_2 = rowData:getValue("act_2") or ""
  self.act_3 = rowData:getValue("act_3") or ""
  self.act_2_text = rowData:getValue("act_2_text") or ""
  self.act_3_text = rowData:getValue("act_3_text") or ""
  self.act_4 = rowData:getValue("act_4") or ""
  self.act_5 = rowData:getValue("act_5") or ""
  self.act_5_text = rowData:getValue("act_5_text") or ""
  self.head_icon = rowData:getValue("head_icon") or ""
  self.head_bg = rowData:getValue("head_bg") or ""
  self.hit_pos = rowData:getValue("hit_pos") or ""
  self.blood_pos = rowData:getValue("blood_pos") or ""
  self.plot_pos = rowData:getValue("plot_pos") or ""
  self.com_attack_angle = rowData:getValue("com_attack_angle") or ""
  self.effect_list1 = rowData:getValue("effect_list1") or ""
  self.effect_list2 = rowData:getValue("effect_list2") or ""
  self.init_rotation = rowData:getValue("init_rotation") or ""
  self.clickSize = rowData:getValue("clickSize") or ""
  self.rate_show_tips = rowData:getValue("rate_show_tips") or 0
  self.mustRewardList = {}
  if not string.IsNullOrEmpty(self.reward_show) then
    local info = string.split(self.reward_show, "|")
    for _, v in ipairs(info) do
      local info2 = string.split(v, ";")
      if #info2 == 3 then
        local rewardData = {}
        rewardData.rewardType = toInt(info2[1])
        rewardData.itemId = toInt(info2[2])
        rewardData.count = toInt(info2[3])
        table.insert(self.mustRewardList, rewardData)
      end
    end
  end
  self.probRewardList = {}
  if not string.IsNullOrEmpty(self.reward2_show) then
    local info = string.split(self.reward2_show, "|")
    for _, v in ipairs(info) do
      local info2 = string.split(v, ";")
      if #info2 == 4 then
        local rewardData = {}
        rewardData.rewardType = toInt(info2[1])
        rewardData.itemId = toInt(info2[2])
        rewardData.count = toInt(info2[3])
        table.insert(self.probRewardList, rewardData)
      end
    end
  end
  if not string.IsNullOrEmpty(self.clickSize) then
    local info = string.split(self.clickSize, "|")
    if #info == 2 then
      self.clickWidth = toInt(info[1])
      self.clickHeight = toInt(info[2])
    end
  end
  self.dead_ani_param = rowData:getValue("dead_ani_param") or 0
end

return ActivityHunterMonsterTemplate
