local SeasonGoldenTreePhaseThirdTemplate = BaseClass("SeasonGoldenTreePhaseThirdTemplate")

local function __init(self)
  self.id = 0
  self.start = 0
  self.prize_pool = ""
  self.limit = ""
  self.refresh = ""
  self.lottery_limit = ""
  self.lottery_price = ""
  self.settlement = 0
  self.lottery_prerequisites = ""
  self.money = 0
  self.extra = ""
  self.help = ""
  self.reward_reissue_email = ""
  self.dialogue = ""
  self.extraData = {}
  self.lotteryData = {}
  self.lottery2Index = {}
  self.prizePool = {}
end

local function __delete(self)
  self.id = 0
  self.start = 0
  self.prize_pool = nil
  self.limit = nil
  self.refresh = nil
  self.lottery_limit = nil
  self.lottery_price = nil
  self.settlement = nil
  self.lottery_prerequisites = nil
  self.money = nil
  self.extra = nil
  self.help = nil
  self.reward_reissue_email = nil
  self.dialogue = nil
  self.extraData = nil
  self.lotteryData = nil
  self.lottery2Index = nil
  self.prizePool = nil
end

function SeasonGoldenTreePhaseThirdTemplate:InitData(row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.start = tonumber(row:getValue("start")) or 0
  self.prize_pool = row:getValue("prize_pool") or ""
  self.limit = row:getValue("limit") or ""
  self.refresh = row:getValue("refresh") or ""
  self.lottery_limit = row:getValue("lottery_limit") or ""
  self.lottery_price = row:getValue("lottery_price") or ""
  self.settlement = tonumber(row:getValue("settlement"))
  self.lottery_prerequisites = row:getValue("lottery_prerequisites") or ""
  self.money = tonumber(row:getValue("money")) or 0
  self.extra = row:getValue("extra") or ""
  self.help = row:getValue("help") or ""
  self.reward_reissue_email = row:getValue("reward_reissue_email") or ""
  self.dialogue = row:getValue("dialogue") or ""
  for item in string.gmatch(self.extra, "([^|]+)|?") do
    local bugCount, rewardCount = string.match(item, "([^;]+);([^;]+)")
    table.insert(self.extraData, {
      buyCount = tonumber(bugCount),
      rewardCount = tonumber(rewardCount)
    })
  end
  for index = 1, #self.extraData do
    local each = self.extraData[index]
    if index == 1 then
      each.addCount = each.rewardCount
    else
      each.addCount = each.rewardCount - self.extraData[index - 1].rewardCount
    end
  end
  local lotteryPrice = string.split(self.lottery_price, ";")
  local lotteryLimit = string.split(self.lottery_limit, ";")
  local lotteryPre = string.split(self.lottery_prerequisites, ";")
  for index = 1, #lotteryPrice do
    local eachData = self.lotteryData[index]
    eachData = eachData or {}
    eachData.price = tonumber(lotteryPrice[index])
    eachData.limit = tonumber(lotteryLimit[index])
    eachData.itemId = self.money
    eachData.hasBuy = false
    eachData.needCardCount = tonumber(lotteryPre[index])
    self.lotteryData[index] = eachData
  end
  for _, v in ipairs(self.lotteryData) do
    self.lottery2Index[v.limit] = v
  end
  self.prizePool = {}
  local prizePool = string.split(self.prize_pool, "|")
  for k, v in ipairs(prizePool) do
    local prizePre = string.split(v, ";")
    self.prizePool[#prizePre] = prizePre
  end
  self.dialogueLoop = string.split(self.dialogue, "|")
end

function SeasonGoldenTreePhaseThirdTemplate:IsStart()
  local active = DataCenter.SeasonGoldTreeManager:IsActive()
  if not active then
    return false
  end
  local day = SeasonUtil.GetSeasonDay()
  return day >= self.start
end

function SeasonGoldenTreePhaseThirdTemplate:GetNpcNextRewardData(alreadyBuyCount)
  for index = 1, #self.extraData do
    local each = self.extraData[index]
    if alreadyBuyCount < each.buyCount then
      return each.buyCount - alreadyBuyCount, each.addCount
    end
  end
  return nil
end

function SeasonGoldenTreePhaseThirdTemplate:GetLotteryData(index)
  return self.lotteryData[index]
end

function SeasonGoldenTreePhaseThirdTemplate:GetPrizePool(prizeCount, index)
  return self.prizePool[prizeCount][index]
end

SeasonGoldenTreePhaseThirdTemplate.__init = __init
SeasonGoldenTreePhaseThirdTemplate.__delete = __delete
return SeasonGoldenTreePhaseThirdTemplate
