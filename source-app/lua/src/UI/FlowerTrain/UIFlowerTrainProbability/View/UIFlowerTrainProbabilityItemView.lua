local base = UIBaseContainer
local UIFlowerTrainProbabilityItemView = BaseClass("UIFlowerTrainProbabilityItemView", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UIFlowerTrainProbabilityRateItem = require("UI.FlowerTrain.UIFlowerTrainProbability.View.UIFlowerTrainProbabilityRateItem")
local UIFlowerTrainProbabilityRewardItem = require("UI.FlowerTrain.UIFlowerTrainProbability.View.UIFlowerTrainProbabilityRewardItem")
local RatePrefabPath = "Assets/Main/Prefabs/UI/FlowerTrain/UIFlowerTrainProbabilityRateItem.prefab"
local RewardPrefabPath = "Assets/Main/Prefabs/UI/FlowerTrain/UIFlowerTrainProbabilityRewardItem.prefab"

function UIFlowerTrainProbabilityItemView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
end

function UIFlowerTrainProbabilityItemView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIFlowerTrainProbabilityItemView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgRankIcon = self.viewSkin:AddComponent(self, UIImage, 1)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.infoIcon = self.viewSkin:AddComponent(self, UIRawImage, 3)
  self.infoName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.infoDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.probabilityList = self.viewSkin:AddComponent(self, UIBaseContainer, 6)
end

function UIFlowerTrainProbabilityItemView:ComponentDestroy()
  self:ClearRewards()
  self.viewSkin = nil
  self.imgRankIcon = nil
  self.textTitle = nil
  self.infoIcon = nil
  self.infoName = nil
  self.infoDesc = nil
  self.probabilityList = nil
  self.rewardRateShowItem = nil
  self.genDecoFlag = nil
end

function UIFlowerTrainProbabilityItemView:DataDefine()
  self.rewardList = {}
  self.rewardItemRequests = {}
end

function UIFlowerTrainProbabilityItemView:DataDestroy()
  self.rewardList = {}
  self.rewardItemRequests = {}
end

function UIFlowerTrainProbabilityItemView:OnAddListener()
  base.OnAddListener(self)
end

function UIFlowerTrainProbabilityItemView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIFlowerTrainProbabilityItemView:RefreshView(data, index, resizeFunc)
  self.resizeFunc = resizeFunc
  self.index = index
  self.rewardList = data or {}
  local pageName = ""
  local treasureId
  for _, v in ipairs(self.rewardList) do
    if not string.IsNullOrEmpty(v.page_name) then
      pageName = v.type_name
      treasureId = v.treasure_id
      break
    end
  end
  self.textTitle:SetLocalText(pageName)
  if treasureId then
    local displayMeta = DataCenter.FlowerTrainDataManager:GetFlowerTrainDisplayMeta(treasureId)
    if displayMeta then
      self.infoIcon:LoadSprite(displayMeta.pic6)
      self.infoName:SetLocalText(displayMeta.name)
      self.infoDesc:SetLocalText(displayMeta.desc)
      self.imgRankIcon:LoadSprite(displayMeta.level_icon)
    end
  end
  self:RefreshRewardContent()
end

function UIFlowerTrainProbabilityItemView:RefreshSkin(itemMeta)
  if self.genDecoFlag then
    return
  end
  self.genDecoFlag = true
  if not itemMeta then
    return
  end
  local paraMeta = FlowerTrainUtils.GetFlowerTrainParaMetaByGoodsId(itemMeta.id)
  if not paraMeta or table.IsNullOrEmpty(paraMeta.probability_panel_cfg) then
    return
  end
  FlowerTrainUtils.GeneratePanelDeco(self, paraMeta.probability_panel_cfg)
end

local PrefabIndex = 1

function UIFlowerTrainProbabilityItemView:RefreshRewardContent()
  self:ClearRewards()
  local index = 1
  for i = 1, table.count(self.rewardList) do
    local data = self.rewardList[i]
    local path = RatePrefabPath
    local component = UIFlowerTrainProbabilityRateItem
    local request = self:GameObjectInstantiateAsync(path, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.gameObject:SetActive(true)
      go.transform:SetParent(self.probabilityList.transform)
      go.transform:Set_localScale(1, 1, ResetScale.z)
      go.transform:Set_pivot(0.5, 0.5)
      go.name = "item" .. tostring(PrefabIndex)
      PrefabIndex = PrefabIndex + 1
      local cell = self.probabilityList:AddComponent(component, go.name)
      cell:RefreshView(self.rewardList[index])
      if index == table.count(self.rewardList) then
        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.probabilityList.transform)
        local newHeight = 316 + self.probabilityList.rectTransform.rect.height
        if self.rewardList[1].type == 7 then
          newHeight = 116 + self.probabilityList.rectTransform.rect.height
        end
        self.transform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Vertical, newHeight)
        if self.resizeFunc then
          self.resizeFunc(self.index)
        end
      end
      index = index + 1
    end)
    table.insert(self.rewardItemRequests, request)
  end
end

function UIFlowerTrainProbabilityItemView:ClearRewards()
  if self.rewardItemRequests then
    self.probabilityList:RemoveComponents(UIFlowerTrainProbabilityRateItem)
    for i, v in pairs(self.rewardItemRequests) do
      v:Destroy()
    end
    self.rewardItemRequests = {}
  end
end

return UIFlowerTrainProbabilityItemView
