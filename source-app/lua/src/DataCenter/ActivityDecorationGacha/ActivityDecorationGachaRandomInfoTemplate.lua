local ActivityDecorationGachaRandomInfoTemplate = BaseClass("ActivityDecorationGachaRandomInfoTemplate")
local ActivityDecorationGachaItemData = require("DataCenter/ActivityDecorationGacha/ActivityDecorationGachaItemData")

function ActivityDecorationGachaRandomInfoTemplate:__init()
  self.id = 0
  self.showList = ""
  self.scoreReward = ""
  self.scoreRewardShow = ""
  self.dropinfoId = 0
  self.wishListId = ""
  self.recommend = ""
  self.pity = 0
  self.maxDaily = 0
  self.itemDataList = {}
end

function ActivityDecorationGachaRandomInfoTemplate:__delete()
  self.id = nil
  self.showList = nil
  self.scoreReward = nil
  self.scoreRewardShow = nil
  self.dropinfoId = nil
  self.wishListId = nil
  self.recommend = nil
  self.pity = nil
  self.maxDaily = nil
  self.itemDataList = nil
end

function ActivityDecorationGachaRandomInfoTemplate:InitData(row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.showList = row:getValue("show_list") or ""
  self.scoreReward = row:getValue("score_reward") or ""
  self.scoreRewardShow = row:getValue("score_reward_show") or ""
  self.dropinfoId = tonumber(row:getValue("dropinfo_id")) or 0
  self.wishListId = row:getValue("wish_list_id") or ""
  self.recommend = row:getValue("recommend") or ""
  self.pity = tonumber(row:getValue("pity")) or 0
  self.maxDaily = tonumber(row:getValue("max_daily")) or 0
end

function ActivityDecorationGachaRandomInfoTemplate:GetAllItemDataInOrder()
  local res = {}
  if not string.IsNullOrEmpty(self.showList) then
    local showListStrList = string.split(self.showList, "|")
    if 0 < #showListStrList then
      for i, v in pairs() do
        local strPair = string.split(v, ";")
        if #strPair == 2 then
          local itemData = ActivityDecorationGachaItemData.New()
          itemData:InitDataByItemId(tonumber(strPair[1]), tonumber(strPair[2]))
          table.insert(res, itemData)
        end
      end
    end
  end
  return res
end

function ActivityDecorationGachaRandomInfoTemplate:GetOrder()
end

function ActivityDecorationGachaRandomInfoTemplate:GetItemImagePath()
  return DataCenter.RewardManager:GetPicByType(self.itemType, self.itemId)
end

function ActivityDecorationGachaRandomInfoTemplate:GetItemBaseImagePath()
  local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(self.itemId)
  if itemTemplate ~= nil then
    if itemTemplate.quality == 1 then
      return "Assets/Main/Sprites/UI/LWActivityDecorationGacha/Mjc_huodong_zhuangshiwu_item_bg1.png"
    end
    if itemTemplate.quality == 2 then
      return "Assets/Main/Sprites/UI/LWActivityDecorationGacha/Mjc_huodong_zhuangshiwu_item_bg2.png"
    end
    if itemTemplate.quality == 3 then
      return "Assets/Main/Sprites/UI/LWActivityDecorationGacha/Mjc_huodong_zhuangshiwu_item_bg3.png"
    end
  end
  return "Assets/Main/Sprites/UI/LWActivityDecorationGacha/Mjc_huodong_zhuangshiwu_item_bg3.png"
end

function ActivityDecorationGachaRandomInfoTemplate:GetRecommendItems()
  local res = {}
  if not string.IsNullOrEmpty(self.recommend) then
    local recommendStrs = string.split(self.recommend, "|")
    for i, v in pairs(recommendStrs) do
      if tonumber(v) > 0 then
        table.insert(res, tonumber(v))
      end
    end
  end
  return res
end

function ActivityDecorationGachaRandomInfoTemplate:GetProgressDataInOrder()
  local showDataList = {}
  if not string.IsNullOrEmpty(self.scoreRewardShow) then
    local str1 = string.split(self.scoreRewardShow, "|")
    for i, v in pairs(str1) do
      local str2 = string.split(v, ";")
      if #str2 == 3 then
        local data = {
          rewardType = tonumber(str2[1]),
          itemId = tonumber(str2[2]),
          count = tonumber(str2[3])
        }
        table.insert(showDataList, data)
      end
    end
  end
  local res = {}
  if not string.IsNullOrEmpty(self.scoreReward) then
    local str1 = string.split(self.scoreReward, "|")
    for i, v in pairs(str1) do
      local str2 = string.split(v, ";")
      if #str2 == 2 and showDataList[i] ~= nil then
        local data = showDataList[i]
        data.score = tonumber(str2[1])
        table.insert(res, data)
      end
    end
  end
  return res
end

function ActivityDecorationGachaRandomInfoTemplate:GetProgressMaxScore()
  local progressDataList = self:GetProgressDataInOrder()
  local res = 0
  for i, v in pairs(progressDataList) do
    if res < v.score then
      res = v.score
    end
  end
  return res
end

return ActivityDecorationGachaRandomInfoTemplate
