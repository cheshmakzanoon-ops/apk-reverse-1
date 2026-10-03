local base = UIBaseContainer
local UIAttackCityS0BattlePassScoreItem = BaseClass("UIAttackCityS0BattlePassScoreItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIAttackCityS0BattlePassScoreItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIAttackCityS0BattlePassScoreItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAttackCityS0BattlePassScoreItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgBg = self.viewSkin:AddComponent(self, UIImage, 1)
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 2)
  self.txtNum = self:AddComponent(UITextMeshProUGUIEx, "img_icon/txtNum")
  self.scrollRect = self.viewSkin:AddComponent(self, UIScrollRect, 3)
  self.content = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.btnReward = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnReward:SetOnClick(function()
    self:OnBtnRewardClick()
  end)
  self.btnGray = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnGray:SetOnClick(function()
    self:OnBtnGrayClick()
  end)
  self.imgCompleted = self.viewSkin:AddComponent(self, UIImage, 7)
end

function UIAttackCityS0BattlePassScoreItem:ComponentDestroy()
  self.viewSkin = nil
  self.imgBg = nil
  self.imgIcon = nil
  self.scrollRect = nil
  self.content = nil
  self.btnReward = nil
  self.btnGray = nil
  self.imgCompleted = nil
  self.txtNum = nil
end

function UIAttackCityS0BattlePassScoreItem:DataDefine()
end

function UIAttackCityS0BattlePassScoreItem:DataDestroy()
  self:ClearItems()
end

function UIAttackCityS0BattlePassScoreItem:OnAddListener()
  base.OnAddListener(self)
end

function UIAttackCityS0BattlePassScoreItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIAttackCityS0BattlePassScoreItem:OnBtnRewardClick()
  if self.hasReward == 1 then
    DataCenter.AttackCityS0DataManager:SendBattlePassTaskRewardMsg(-1, self.configId)
  end
end

function UIAttackCityS0BattlePassScoreItem:OnBtnGrayClick()
end

function UIAttackCityS0BattlePassScoreItem:RefreshData(data)
  self.configId = data.configId
  self.rewards = data.reward
  self.txtNum:SetText(data.totalNum)
  self.hasReward = data.hasReward
  self.btnReward.gameObject:SetActive(self.hasReward == 1)
  self.btnGray.gameObject:SetActive(self.hasReward == 0)
  self.imgCompleted.gameObject:SetActive(self.hasReward == 2)
  self:ClearItems()
  if self.rewards ~= nil then
    for i, value in ipairs(self.rewards) do
      self.rewardFreeReqs[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(req)
        if IsNull(req.gameObject) then
          return
        end
        local go = req.gameObject
        local index = i
        local nameStr = "UICommonResItem" .. index
        go.name = nameStr
        local transform = go.transform
        transform:SetParent(self.content.transform)
        transform:Set_sizeDelta(150, 150)
        transform:Set_localScale(0.8, 0.8, 1)
        transform:Set_pivot(0, 1)
        local item = self.content:AddComponent(UICommonResItem, nameStr)
        go:SetActive(true)
        local param = {
          rewardType = value.type,
          itemId = value.value.id,
          count = value.value.num
        }
        item:ReInit(param)
      end)
    end
  end
end

function UIAttackCityS0BattlePassScoreItem:ClearItems()
  self.content:RemoveComponents(UICommonResItem)
  if self.rewardFreeReqs then
    for _, req in pairs(self.rewardFreeReqs) do
      req:Destroy()
    end
  end
  self.rewardFreeReqs = {}
end

return UIAttackCityS0BattlePassScoreItem
