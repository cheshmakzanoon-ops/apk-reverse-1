local base = UIBaseContainer
local CompCityTaskComponent = BaseClass("CompCityTaskComponent", UIBaseContainer)
local UICityAttackS0CityToggleItem = require("UI.LWCityAttackS0.BattlePass.Component.UICityAttackS0CityToggleItem")
local TargetItem = require("UI.LWCityAttackS0.BattlePass.Component.UIAttackCityS0BattlePassCityItem")
local Localization = CS.GameEntry.Localization
local TOGGLE_INDEX = 6

function CompCityTaskComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function CompCityTaskComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function CompCityTaskComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.scrollRect = self.viewSkin:AddComponent(self, UIScrollRect, 1)
  self.content = self.viewSkin:AddComponent(self, UIBaseContainer, 2)
  self.toggleTab1 = self.viewSkin:AddComponent(self, UICityAttackS0CityToggleItem, 3)
  self.toggleTab2 = self.viewSkin:AddComponent(self, UICityAttackS0CityToggleItem, 4)
  self.toggleTab3 = self.viewSkin:AddComponent(self, UICityAttackS0CityToggleItem, 5)
  self.toggleTab4 = self.viewSkin:AddComponent(self, UICityAttackS0CityToggleItem, 6)
  self.toggleTab5 = self.viewSkin:AddComponent(self, UICityAttackS0CityToggleItem, 7)
  self.toggleTab6 = self.viewSkin:AddComponent(self, UICityAttackS0CityToggleItem, 8)
  self.scrollView = self.viewSkin:AddComponent(self, UIScrollView, 9)
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.cityTogTab = {}
  for i = 1, TOGGLE_INDEX do
    self.cityTogTab[i] = self["toggleTab" .. i]
    self.cityTogTab[i]:ReInit(true)
    self.cityTogTab[i]:SetData(i, function()
      self:ToggleControl(i)
    end)
  end
  self.btnReceiveAll = self:AddComponent(UIButton, "BtnAllCity")
  self.btnReceiveAll:SetOnClick(function()
    self:OnBtnReceiveAllClick()
  end)
end

function CompCityTaskComponent:ComponentDestroy()
  self:ClearScroll()
  self.viewSkin = nil
  self.scrollRect = nil
  self.content = nil
  self.toggleTab1 = nil
  self.toggleTab2 = nil
  self.toggleTab3 = nil
  self.toggleTab4 = nil
  self.toggleTab5 = nil
  self.toggleTab6 = nil
  self.scrollView = nil
end

function CompCityTaskComponent:DataDefine()
  self.cityTabIndex = 1
  self.lastSelect = -1
end

function CompCityTaskComponent:DataDestroy()
  self.cityTabIndex = nil
  self.lastSelect = nil
end

function CompCityTaskComponent:OnAddListener()
  base.OnAddListener(self)
end

function CompCityTaskComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function CompCityTaskComponent:RefreshPage()
  self.curMaxCityLevel = DataCenter.AttackCityS0DataManager:GetMaxCityLevel() + 1
  for i = 1, 6 do
    local isLock = i > self.curMaxCityLevel
    self.cityTogTab[i]:ReInit(isLock, i)
  end
  if self.curMaxCityLevel > TOGGLE_INDEX then
    self.curMaxCityLevel = TOGGLE_INDEX
  end
  if self.lastSelect and self.lastSelect ~= -1 then
    self.cityTogTab[self.lastSelect]:OnSelect(true)
    self:ToggleControl(self.lastSelect)
  else
    self.cityTogTab[self.curMaxCityLevel]:OnSelect(true)
    self:ToggleControl(self.curMaxCityLevel)
  end
end

function CompCityTaskComponent:ToggleControl(index)
  if index > self.curMaxCityLevel then
    UIUtil.ShowTipsId(2000012)
    if self.cityTabIndex then
      self.cityTogTab[self.cityTabIndex]:OnSelect(true)
    end
    self.cityTogTab[index]:OnSelect(false)
    return
  end
  self.lastSelect = index
  self.btnReceiveAll.gameObject:SetActive(DataCenter.AttackCityS0DataManager:GetBattlePassCityRedPoint(index))
  local isOn = self.cityTogTab[index].toggle:GetIsOn()
  if isOn then
    self.cityTabIndex = index
    for i = 1, TOGGLE_INDEX do
      if i == self.cityTabIndex then
        self.cityTogTab[i]:OnSelect(true)
      else
        self.cityTogTab[i]:OnSelect(false)
      end
    end
    self:RefreshSelectData()
  end
end

function CompCityTaskComponent:RefreshSelectData()
  self:ClearScroll()
  self.taskList = DataCenter.AttackCityS0DataManager:GetCityLvTaskInfo(self.cityTabIndex)
  if self.taskList and #self.taskList > 0 then
    table.sort(self.taskList, function(a, b)
      if a.hasReward == 1 and b.hasReward ~= 1 then
        return true
      end
      if b.hasReward == 1 and a.hasReward ~= 1 then
        return false
      end
      if a.hasReward == 2 and b.hasReward ~= 2 then
        return false
      end
      if b.hasReward == 2 and a.hasReward ~= 2 then
        return true
      end
      if a.configId < b.configId then
        return true
      end
      return false
    end)
    self.scrollView:SetTotalCount(#self.taskList)
    self.scrollView:RefillCells()
  else
    self.scrollView.gameObject:SetActive(false)
  end
end

function CompCityTaskComponent:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scrollView:AddComponent(TargetItem, itemObj)
  cellItem:SetData(self.taskList[index], self.cityTabIndex)
end

function CompCityTaskComponent:OnItemMoveOut(itemObj, index)
  self.scrollView:RemoveComponent(itemObj.name, TargetItem)
end

function CompCityTaskComponent:ClearScroll()
  self.scrollView:ClearCells()
  self.scrollView:RemoveComponents(TargetItem)
  self.taskList = {}
end

function CompCityTaskComponent:OnBtnReceiveAllClick()
  DataCenter.AttackCityS0DataManager:SendBattlePassTaskRewardMsg(self.cityTabIndex, -1)
end

return CompCityTaskComponent
