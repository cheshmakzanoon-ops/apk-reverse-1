local base = UIBaseContainer
local UIBanquetItemDropProbabilityItem_Box_Rate = BaseClass("UIBanquetItemDropProbabilityItem_Box_Rate", base)
local M = UIBanquetItemDropProbabilityItem_Box_Rate
local BanquetAttackMonsterRateRewardItem = require("UI.BanquetAttackMonster.BanquetAttackMonsterRateReward.Component.BanquetAttackMonsterRateRewardItem")

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.compRewardRateItem:SetActive(false)
  self.compRewardRateItem.gameObject:GameObjectCreatePool()
  self.compRewardItem:SetActive(false)
  self.compRewardItem.gameObject:GameObjectCreatePool()
end

function M:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function M:ComponentDefine()
  self.title = self:AddComponent(UIText, "itemTitle1")
  self.scroll = self:AddComponent(UIScrollRect, "Scroll")
  self.content = self:AddComponent(UIBaseContainer, "Scroll/Viewport/Content1")
  self.compRewardRateItem = self:AddComponent(UIBaseContainer, "rewardRateItem")
  self.compRewardItem = self:AddComponent(UIBaseContainer, "rewardItem")
end

function M:ComponentDestroy()
  self:ClearAllItem()
  self.title = nil
  self.content = nil
  self.scroll = nil
end

function M:SetData(data)
  local showRewardData = {}
  self:PrepareRewardData(data, showRewardData)
  self.title:SetLocalText(data.sub_type_name)
  self:ClearAllItem()
  if 0 < #showRewardData then
    for index = 1, #showRewardData do
      local reward = showRewardData[index]
      local rewardItem
      if reward.rateNum == nil then
        rewardItem = self.compRewardItem.gameObject:GameObjectSpawn(self.content.transform)
      else
        rewardItem = self.compRewardRateItem.gameObject:GameObjectSpawn(self.content.transform)
      end
      rewardItem.name = "BanquetAttackMonsterRateRewardItem" .. index
      local rewardObj = self.content:AddComponent(BanquetAttackMonsterRateRewardItem, rewardItem.name)
      rewardObj:SetActive(true)
      rewardObj:SetData(showRewardData[index])
      rewardObj:SetLocalScaleXYZ(1, 1, 1)
    end
  end
  self.scroll:SetEnable(5 < #showRewardData)
end

function M:PrepareRewardData(data, showRewardData)
  if data ~= nil then
    if not string.IsNullOrEmpty(data.sub_item) then
      local rewardCfgList = string.string2array_i(data.sub_item, ";", "|")
      for i = 1, #rewardCfgList do
        local tmpShowData = {}
        if rewardCfgList[i][1] == 1 then
          tmpShowData = {
            rewardType = ResTypeToReward[rewardCfgList[i][2]],
            count = rewardCfgList[i][3]
          }
        else
          tmpShowData = {
            rewardType = rewardCfgList[i][1],
            itemId = rewardCfgList[i][2],
            count = rewardCfgList[i][3]
          }
        end
        table.insert(showRewardData, tmpShowData)
      end
    end
    local rewardRateList = {}
    if not string.IsNullOrEmpty(data.drop_show) then
      rewardRateList = string.split(data.drop_show, "|")
      for i = 1, #rewardRateList do
        if showRewardData[i] then
          showRewardData[i].rateNum = tonumber(rewardRateList[i]) / 100
        end
      end
    end
    if data.sub_type == 12 and (#showRewardData ~= #rewardRateList or table.hasvalue(rewardRateList, "0")) then
      Logger.LogError(string.format("activity_partynew_dropshow \233\133\141\231\189\174%s drop_show\233\133\141\231\189\174\230\156\137\233\151\174\233\162\152", tostring(data.id)))
    end
    if not string.IsNullOrEmpty(data.special) then
      local rewardSpecialList = string.split(data.special, "|")
      for i = 1, #rewardSpecialList do
        if showRewardData[i] then
          showRewardData[i].isTip = tonumber(rewardSpecialList[i]) or 0
        end
      end
    end
  end
end

function M:ClearAllItem()
  self.content:RemoveComponents(BanquetAttackMonsterRateRewardItem)
  self.compRewardRateItem.gameObject:GameObjectRecycleAll()
  self.compRewardItem.gameObject:GameObjectRecycleAll()
end

return UIBanquetItemDropProbabilityItem_Box_Rate
