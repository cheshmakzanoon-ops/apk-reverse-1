local WorkerRankTemplate = BaseClass("WorkerRankTemplate")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.id = 0
  self.worker_id = 0
  self.rank = 0
  self.power = 0
  self.rank_goods = ""
  self.rank_goods_data = {}
  self.effect = ""
  self.effect_data = {}
  self.rank_effect = ""
  self.rank_effect_data = {}
  self.sep_desc = ""
  self.box_id = 0
  self.max_rank = 0
end

local function __delete(self)
  self.id = nil
  self.worker_id = nil
  self.rank = nil
  self.power = nil
  self.rank_goods = nil
  self.rank_goods_data = nil
  self.effect = nil
  self.effect_data = nil
  self.rank_effect = nil
  self.rank_effect_data = nil
  self.sep_desc = nil
  self.box_id = nil
  self.max_rank = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.worker_id = tonumber(row:getValue("worker_id")) or 0
  self.rank = tonumber(row:getValue("rank")) or 0
  self.power = tonumber(row:getValue("power")) or 0
  self.sep_desc = row:getValue("sep_desc")
  self.box_id = tonumber(row:getValue("box_id")) or 0
  self.max_rank = tonumber(row:getValue("max_rank")) or 0
  self.rank_goods = row:getValue("rank_goods")
  if not string.IsNullOrEmpty(self.rank_goods) then
    self.rank_goods_data = string.string2array_i(self.rank_goods, "|", ",")
  end
  self.effect = row:getValue("effect")
  if not string.IsNullOrEmpty(self.effect) then
    self.effect_data = string.string2array_num(self.effect, ";", "|")
  end
  self.rank_effect = row:getValue("rank_effect")
  if not string.IsNullOrEmpty(self.rank_effect) then
    self.rank_effect_data = string.string2array_num_oneSep(self.rank_effect, ";")
  end
end

WorkerRankTemplate.__init = __init
WorkerRankTemplate.__delete = __delete
WorkerRankTemplate.InitData = InitData
return WorkerRankTemplate
