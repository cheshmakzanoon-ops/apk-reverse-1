local ActivityDecorationGachaInfoTemplate = BaseClass("ActivityDecorationGachaInfoTemplate")

function ActivityDecorationGachaInfoTemplate:__init()
  self.id = 0
  self.banner = ""
  self.advertise = ""
  self.freeCoinNumber = 0
  self.exchangeId = 0
  self.freeReward = 0
  self.diamondReward = ""
  self.addScore = 0
  self.scoreItem = 0
  self.buttonPara = 0
  self.costId = 0
  self.costNum = 0
  self.costShowDiamond = 0
  self.freeTime = 0
  self.broadcastId = 0
  self.gachaGroupId = ""
  self.exchangeid_event = 0
end

function ActivityDecorationGachaInfoTemplate:__delete()
  self.id = nil
  self.banner = nil
  self.advertise = nil
  self.freeCoinNumber = nil
  self.exchangeId = nil
  self.freeReward = nil
  self.diamondReward = nil
  self.addScore = nil
  self.scoreItem = nil
  self.buttonPara = nil
  self.costId = nil
  self.costNum = nil
  self.costShowDiamond = nil
  self.freeTime = nil
  self.broadcastId = nil
  self.gachaGroupId = nil
  self.exchangeid_event = nil
end

function ActivityDecorationGachaInfoTemplate:InitData(row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.banner = row:getValue("banner") or ""
  self.advertise = row:getValue("advertise") or ""
  self.freeCoinNumber = tonumber(row:getValue("free_coin_number")) or 0
  self.exchangeId = tonumber(row:getValue("exchangeid")) or 0
  self.freeReward = tonumber(row:getValue("free_reward")) or 0
  self.diamondReward = row:getValue("diamond_reward") or ""
  self.addScore = tonumber(row:getValue("add_score")) or 0
  self.scoreItem = tonumber(row:getValue("score_item")) or 0
  self.buttonPara = tonumber(row:getValue("button_para")) or 0
  self.costId = tonumber(row:getValue("cost_id")) or 0
  self.costNum = tonumber(row:getValue("cost_num")) or 0
  self.costShowDiamond = tonumber(row:getValue("cost_show_diamond")) or 0
  self.freeTime = tonumber(row:getValue("free_time")) or 0
  self.broadcastId = row:getValue("broadcast_id") or ""
  self.gachaGroupId = row:getValue("gachagroup_id") or ""
  self.exchangeid_event = row:getValue("exchangeid_event") or 0
  self.costItemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(self.costId)
end

function ActivityDecorationGachaInfoTemplate:GetCostItemImage()
  if self.costItemTemplate ~= nil then
    return string.format(LoadPath.ItemPath, self.costItemTemplate.icon)
  end
  return ""
end

return ActivityDecorationGachaInfoTemplate
