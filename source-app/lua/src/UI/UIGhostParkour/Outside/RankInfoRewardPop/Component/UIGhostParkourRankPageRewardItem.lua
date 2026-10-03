local base = UIBaseContainer
local UIGhostParkourRankPageRewardItem = BaseClass("UIGhostParkourRankPageRewardItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UICommonResItem = require("UI.UICommonResItem.UICommonResItem")

function UIGhostParkourRankPageRewardItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIGhostParkourRankPageRewardItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIGhostParkourRankPageRewardItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.rawImgIcon = self.viewSkin:AddComponent(self, UIRawImage, 1)
  self.textRankingTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.content = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
  self.imgNow = self.viewSkin:AddComponent(self, UIImage, 4)
end

function UIGhostParkourRankPageRewardItem:ComponentDestroy()
  self.viewSkin = nil
  self.rawImgIcon = nil
  self.textRankingTitle = nil
  self.content = nil
  self.imgNow = nil
end

function UIGhostParkourRankPageRewardItem:DataDefine()
end

function UIGhostParkourRankPageRewardItem:DataDestroy()
  self:SetAllCellDestroy()
end

function UIGhostParkourRankPageRewardItem:OnAddListener()
  base.OnAddListener(self)
end

function UIGhostParkourRankPageRewardItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIGhostParkourRankPageRewardItem:SetData(data)
  self:SetAllCellDestroy()
  self.model = {}
  local tier = DataCenter.LWGhostParkourDataManager:GetTier()
  if data and not table.IsNullOrEmpty(data.rewardInfos) then
    self.rawImgIcon:LoadSpriteAsyncWithCallback(data.icon, function(sprite)
      if self.rawImgIcon then
        self.rawImgIcon:SetNativeSize()
      end
    end)
    self.textRankingTitle:SetLocalText(data.name)
    self.imgNow.gameObject:SetActive(tier == data.tier)
    for key, value in pairs(data.rewardInfos) do
      local reward = DataCenter.ParkourScoreTierTemplateManager:GetRewards(value.rewardId)
      if type(reward) == "table" then
        for i, rewardValue in pairs(reward) do
          local index = i
          local keyValue = key
          local rewards = rewardValue
          self.model[index .. keyValue] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
            if request.isError then
              return
            end
            local go = request.gameObject
            go.transform:SetParent(self.content.transform)
            go.transform:Set_localScale(0.78, 0.82, 1)
            go.transform:Set_sizeDelta(91, 97)
            go.transform.pivot = Vector2.New(0.5, 0.5)
            go.name = "item" .. index .. keyValue
            local cell = self.content:AddComponent(UICommonResItem, go.name)
            cell:ReInit(rewards)
          end)
        end
      end
    end
  end
end

function UIGhostParkourRankPageRewardItem:SetAllCellDestroy()
  self.content:RemoveComponents(UICommonResItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.model = nil
end

return UIGhostParkourRankPageRewardItem
