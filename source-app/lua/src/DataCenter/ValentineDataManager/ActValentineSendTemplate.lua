local ActValentineSendTemplate = BaseClass("ActValentineSendTemplate")

local function __init(self)
  self.id = 0
  self.bubble_good = 0
  self.res_good = {}
  self.gift_good = {}
  self.rank_score = 0
  self.rank_reward = {}
  self.rank_require = 0
  self.send_fast = {}
  self.skipNum = 0
  self.emojiList = {}
  self.rank_max_score = 0
  self.hot_value_like = ""
  self.gift_like_show = {}
  self.love_like = 0
end

local function __delete(self)
  self.id = 0
  self.bubble_good = 0
  self.res_good = {}
  self.gift_good = {}
  self.rank_score = 0
  self.rank_reward = {}
  self.rank_require = 0
  self.send_fast = {}
  self.skipNum = nil
  self.emojiList = nil
  self.rank_max_score = 0
  self.hot_value_like = nil
  self.gift_like_show = nil
  self.love_like = nil
  self.likeAndHotList = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.bubble_good = tonumber(row:getValue("bubble_good")) or 0
  local res_good = row:getValue("res_good")
  if not string.IsNullOrEmpty(res_good) then
    self.res_good = string.string2array_i_oneSep(res_good, ";")
  end
  local gift_good = row:getValue("gift_good")
  if not string.IsNullOrEmpty(gift_good) then
    self.gift_good = string.string2array_i_oneSep(gift_good, ";")
  end
  self.rank_score = tonumber(row:getValue("rank_score")) or 0
  local rank_reward = row:getValue("rank_reward")
  if not string.IsNullOrEmpty(rank_reward) then
    self.rank_reward = string.string2array_i(rank_reward, ";", "|")
  end
  self.rank_require = tonumber(row:getValue("rank_require")) or 0
  local send_fast = row:getValue("send_fast")
  if not string.IsNullOrEmpty(send_fast) then
    self.send_fast = string.string2array_i_oneSep(send_fast, ";")
  end
  self.skipNum = tonumber(row:getValue("skip_num")) or 0
  local emojiList = row:getValue("emoji")
  if not string.IsNullOrEmpty(emojiList) then
    self.emojiList = string.string2array_i_oneSep(emojiList, ",")
  end
  self.rank_max_score = tonumber(row:getValue("rank_max_score")) or 0
  self.hot_value_like = row:getValue("hot_value_like") or ""
  if string.IsNullOrEmpty(self.hot_value_like) then
    Logger.LogError("hot_value_like  is  nil")
  end
  self.gift_like_show = row:getValue("gift_like_show") or {}
  self.love_like = row:getValue("love_like") or 0
end

function ActValentineSendTemplate:GetGiftHotAdd()
  return self.gift_like_show
end

function ActValentineSendTemplate:GetLikeAndHotValueRange()
  if not self.likeAndHotList then
    self.likeAndHotList = {}
    local groups = string.split(self.hot_value_like, "|")
    if groups and 0 < #groups then
      for i, v in ipairs(groups) do
        if not string.IsNullOrEmpty(v) then
          local pairs = string.split(v, ";")
          if pairs and #pairs == 2 and not string.IsNullOrEmpty(pairs[1]) and not string.IsNullOrEmpty(pairs[2]) then
            local rangeStr = pairs[1]
            local ranges = string.split(rangeStr, "-")
            if string.IsNullOrEmpty(ranges[1]) or string.IsNullOrEmpty(ranges[2]) then
              Logger.LogError("\232\191\153\230\128\142\228\185\136\233\133\141\233\148\153\228\186\134\229\149\138 hot_value_like\239\188\154" .. tostring(self.hot_value_like))
            end
            local param = {
              rangeMin = tonumber(ranges[1]),
              rangeMax = tonumber(ranges[2]),
              hotAdd = tonumber(pairs[2])
            }
            table.insert(self.likeAndHotList, param)
          end
        end
      end
    else
      Logger.LogError("hot_value_like  is  error,  value: " .. tostring(self.hot_value_like))
    end
  end
  return self.likeAndHotList
end

ActValentineSendTemplate.__init = __init
ActValentineSendTemplate.__delete = __delete
ActValentineSendTemplate.InitData = InitData
return ActValentineSendTemplate
