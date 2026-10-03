local ActivityCycleTemplate = BaseClass("ActivityCycleTemplate")

function ActivityCycleTemplate:__init()
  self.id = 0
  self.group = 0
  self.show_item = 0
  self.draw_item = ""
  self.draw_box_get = ""
  self.point_item = 0
  self.single_draw_max = 0
  self.guarantee = 0
  self.ticket_item = 0
  self.ticket_dayadd = 0
  self.reward_weight = ""
  self.like_setting = 0
  self.giver_set = ""
  self.res_aro = ""
  self.res_box = {}
  self.res_tag = {}
  self.res_npcGiver = ""
  self.res_shopbanner = ""
  self.res_main_a = ""
  self.res_main_b = ""
  self.isshow_switch = 0
end

function ActivityCycleTemplate:__delete()
  self.id = nil
  self.group = nil
  self.show_item = nil
  self.draw_item = nil
  self.draw_box_get = nil
  self.point_item = nil
  self.single_draw_max = nil
  self.guarantee = nil
  self.ticket_item = nil
  self.ticket_dayadd = nil
  self.reward_weight = nil
  self.like_setting = nil
  self.giver_set = nil
  self.res_aro = nil
  self.res_box = nil
  self.res_tag = nil
  self.res_npcGiver = nil
  self.res_shopbanner = nil
  self.res_main_a = nil
  self.res_main_b = nil
  self.isshow_switch = nil
end

function ActivityCycleTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.group = rowData:getValue("group") or 0
  self.show_item = rowData:getValue("show_item") or 0
  self.draw_item = rowData:getValue("draw_item") or ""
  self.draw_box_get = rowData:getValue("draw_box_get") or ""
  self.point_item = rowData:getValue("point_item") or 0
  self.single_draw_max = rowData:getValue("single_draw_max") or 0
  self.guarantee = rowData:getValue("guarantee") or 0
  self.ticket_item = rowData:getValue("ticket_item") or 0
  self.ticket_dayadd = rowData:getValue("ticket_dayadd") or 0
  self.reward_weight = rowData:getValue("reward_weight") or ""
  self.like_setting = rowData:getValue("like_setting") or 0
  self.giver_set = rowData:getValue("giver_set") or ""
  self.res_aro = rowData:getValue("res_aro") or ""
  self.res_box = rowData:getValue("res_box") or {}
  self.res_tag = rowData:getValue("res_tag") or {}
  self.res_npcGiver = rowData:getValue("res_npcGiver") or ""
  self.res_shopbanner = rowData:getValue("res_shopbanner") or ""
  self.res_main_a = rowData:getValue("res_main_a") or ""
  self.res_main_b = rowData:getValue("res_main_b") or ""
  self.isshow_switch = rowData:getValue("isshow_switch") or 0
end

function ActivityCycleTemplate:GetCostData()
  if not string.IsNullOrEmpty(self.draw_item) then
    local splitStr = string.split(self.draw_item, "|")
    if #splitStr == 2 then
      return {
        rewardType = RewardType.GOODS,
        itemId = tonumber(splitStr[1]),
        num = tonumber(splitStr[2])
      }
    end
  end
end

function ActivityCycleTemplate:GetBoxItemGetLimit()
  if not string.IsNullOrEmpty(self.draw_box_get) then
    local splitStr = string.split(self.draw_box_get, "|")
    if #splitStr == 3 then
      return tonumber(splitStr[3]) or 0
    end
  end
  return 0
end

function ActivityCycleTemplate:GetBoxItemGetNeedNum()
  if not string.IsNullOrEmpty(self.draw_box_get) then
    local splitStr = string.split(self.draw_box_get, "|")
    if #splitStr == 3 then
      return tonumber(splitStr[2]) or 0
    end
  end
  return 0
end

function ActivityCycleTemplate:GetLotteryProbabilityDataList()
  local res = {}
  if not string.IsNullOrEmpty(self.reward_weight) then
    local splitStr = string.split(self.reward_weight, "|")
    for i = 1, #splitStr do
      local splitStr2 = string.split(splitStr[i], ";")
      if #splitStr2 == 2 then
        local rewardId = checknumber(splitStr2[2])
        local probability = checknumber(splitStr2[1])
        table.insert(res, {
          index = i,
          rewardId = rewardId,
          probability = probability
        })
      end
    end
  end
  table.sort(res, function(a, b)
    return a.index > b.index
  end)
  return res
end

function ActivityCycleTemplate:GetBoxIconPath(quality)
  if self.res_box and self.res_box[quality] and not string.IsNullOrEmpty(self.res_box[quality]) then
    return self.res_box[quality]
  end
end

function ActivityCycleTemplate:GetSelectedTagIconPath()
  if not table.IsNullOrEmpty(self.res_tag) then
    return self.res_tag[1]
  end
end

function ActivityCycleTemplate:GetUnselectedTagIconPath()
  if not table.IsNullOrEmpty(self.res_tag) then
    return self.res_tag[2]
  end
end

function ActivityCycleTemplate:IsShowLotterySwitch()
  return self.isshow_switch == 1
end

return ActivityCycleTemplate
