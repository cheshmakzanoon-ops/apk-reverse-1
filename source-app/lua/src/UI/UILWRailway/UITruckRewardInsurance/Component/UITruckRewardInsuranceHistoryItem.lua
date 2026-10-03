local base = UIBaseContainer
local UITruckRewardInsuranceHistoryItem = BaseClass("UITruckRewardInsuranceHistoryItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local rapidjson = require("rapidjson")

function UITruckRewardInsuranceHistoryItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UITruckRewardInsuranceHistoryItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UITruckRewardInsuranceHistoryItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compRewardScrollContent = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
  self.imgQualityIcon = self.viewSkin:AddComponent(self, UIImage, 2)
  self.textDispatchTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
end

function UITruckRewardInsuranceHistoryItem:ComponentDestroy()
  self.viewSkin = nil
  self.compRewardScrollContent = nil
  self.imgQualityIcon = nil
  self.textDispatchTime = nil
end

function UITruckRewardInsuranceHistoryItem:DataDefine()
  self.itemReqs = {}
end

function UITruckRewardInsuranceHistoryItem:DataDestroy()
  self:ClearRewardContent()
end

function UITruckRewardInsuranceHistoryItem:OnAddListener()
  base.OnAddListener(self)
end

function UITruckRewardInsuranceHistoryItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UITruckRewardInsuranceHistoryItem:SetData(historyPageData)
  local time = UITimeManager:GetInstance():ConvertServerTimeToLocalTime(historyPageData.timestamp or 0)
  self.textDispatchTime:SetText(time)
  local jsonData = rapidjson.decode(historyPageData.content)
  local quality = QualityImagePath[jsonData.color] or QualityImagePath[1]
  self.imgQualityIcon:LoadSprite(quality)
  self.imgQualityIcon:SetNativeSize()
  local freeReward = jsonData.freeReward or {}
  local vipReward = jsonData.vipReward or {}
  local rewards = {}
  for i = 1, #freeReward do
    table.insert(rewards, freeReward[i])
  end
  for i = 1, #vipReward do
    table.insert(rewards, vipReward[i])
  end
  self:ClearRewardContent()
  local rewardsList = DataCenter.RewardManager:ReturnRewardParamForView(rewards)
  self:RefreshRewardList(rewardsList, self.compRewardScrollContent)
end

function UITruckRewardInsuranceHistoryItem:ClearRewardContent()
  self.compRewardScrollContent:RemoveComponents(UICommonResItem)
  if self.itemReqs and table.count(self.itemReqs) then
    for _, req in pairs(self.itemReqs) do
      req:Destroy()
    end
    self.itemReqs = {}
  end
end

function UITruckRewardInsuranceHistoryItem:RefreshRewardList(rewardList, contentScript)
  if not table.IsNullOrEmpty(rewardList) then
    for i, data in pairs(rewardList) do
      local req = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(req)
        if req == nil or IsNull(req.gameObject) then
          return
        end
        local item = req.gameObject
        item.name = "reward_item" .. i
        item:SetActive(true)
        item.transform:SetParent(contentScript.transform)
        item.transform:Set_localScale(0.9, 0.9, 0.9)
        item.transform:Set_sizeDelta(118, 118)
        item.transform:Set_pivot(0.5, 0.5)
        local cell = contentScript:AddComponent(UICommonResItem, item.name)
        cell:ReInit(data)
      end)
      table.insert(self.itemReqs, req)
    end
  end
end

return UITruckRewardInsuranceHistoryItem
