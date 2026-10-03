local base = UIBaseContainer
local UIAttackCityS0BattlePassCityItem = BaseClass("UIAttackCityS0BattlePassCityItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UILWScienceDetailDesc = require("UI/UILWScience/UILWScienceDetail/Component/UILWScienceDetailDesc")

function UIAttackCityS0BattlePassCityItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIAttackCityS0BattlePassCityItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAttackCityS0BattlePassCityItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.scrollRect = self.viewSkin:AddComponent(self, UIScrollRect, 1)
  self.content = self.viewSkin:AddComponent(self, UIBaseContainer, 2)
  self.textTxtName = self.viewSkin:AddComponent(self, UILWScienceDetailDesc, 3)
  self.textTxtTaskTarget = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.btnGo = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnGo:SetOnClick(function()
    self:OnBtnGoClick()
  end)
  self.btnLocked = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnLocked:SetOnClick(function()
    self:OnBtnLockedClick()
  end)
  self.btnReward = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnReward:SetOnClick(function()
    self:OnBtnRewardClick()
  end)
  self.imgCompleted = self.viewSkin:AddComponent(self, UIImage, 8)
end

function UIAttackCityS0BattlePassCityItem:ComponentDestroy()
  self:ClearItems()
  self.viewSkin = nil
  self.scrollRect = nil
  self.content = nil
  self.textTxtName = nil
  self.textTxtTaskTarget = nil
  self.btnGo = nil
  self.btnLocked = nil
  self.btnReward = nil
  self.imgCompleted = nil
end

function UIAttackCityS0BattlePassCityItem:DataDefine()
end

function UIAttackCityS0BattlePassCityItem:DataDestroy()
end

function UIAttackCityS0BattlePassCityItem:OnAddListener()
  base.OnAddListener(self)
end

function UIAttackCityS0BattlePassCityItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIAttackCityS0BattlePassCityItem:OnBtnGoClick()
end

function UIAttackCityS0BattlePassCityItem:OnBtnLockedClick()
end

function UIAttackCityS0BattlePassCityItem:OnBtnRewardClick()
  if self.hasReward == 1 then
    DataCenter.AttackCityS0DataManager:SendBattlePassTaskRewardMsg(self.cityLv, self.configId)
  end
end

function UIAttackCityS0BattlePassCityItem:SetData(data, cityLv)
  self.cityLv = cityLv
  self.configId = data.configId
  local line = LocalController:instance():getLine(TableName.City_Battle_Task, data.configId)
  local total = data.totalNum
  local cur = data.curNum
  local dataType = tonumber(line.type)
  if dataType == CityAttackS0FixedTask.FiveLimitLevel then
    total = DataCenter.AttackCityS0DataManager:GetFixedTaskTypeData(dataType)
    if total == nil then
      total = data.totalNum
    end
    cur = DataCenter.HeroDataManager:GetHeroCountByLevel(data.totalNum)
  elseif dataType == CityAttackS0FixedTask.FiveLimitStar then
    total = DataCenter.AttackCityS0DataManager:GetFixedTaskTypeData(dataType)
    if total == nil then
      total = data.totalNum
    end
    cur = DataCenter.HeroDataManager:GetHeroCountByStar(data.totalNum)
  end
  self.textTxtName:SetTextAndParam(Localization:GetString(line.desc, data.totalNum))
  self.textTxtTaskTarget:SetText(cur .. "/" .. total)
  self.btnGo.gameObject:SetActive(false)
  self.hasReward = data.hasReward
  self.btnReward.gameObject:SetActive(data.hasReward == 1)
  self.btnLocked.gameObject:SetActive(data.hasReward == 0)
  self.imgCompleted.gameObject:SetActive(data.hasReward == 2)
  self.rewards = {}
  for i, item in ipairs(data.reward) do
    local param = {
      rewardType = item.type,
      itemId = item.value.id,
      count = item.value.num
    }
    table.insert(self.rewards, param)
  end
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
        transform:Set_localScale(0.7, 0.7, 1)
        transform:Set_pivot(0, 1)
        local item = self.content:AddComponent(UICommonResItem, nameStr)
        go:SetActive(true)
        item:ReInit(value)
      end)
    end
  end
end

function UIAttackCityS0BattlePassCityItem:ClearItems()
  self.content:RemoveComponents(UICommonResItem)
  if self.rewardFreeReqs then
    for _, req in pairs(self.rewardFreeReqs) do
      req:Destroy()
    end
  end
  self.rewardFreeReqs = {}
end

return UIAttackCityS0BattlePassCityItem
