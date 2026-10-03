local base = UIBaseContainer
local DailyContentComponent = BaseClass("DailyContentComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local RewardItem = require("UI/LWAllianceMilitaryPay/Main/Component/MilitaryPayRewardItem")
local RewardUtil = require("Util.RewardUtil")

function DailyContentComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function DailyContentComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function DailyContentComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textPersonalTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.btnPersonal = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnPersonal:SetOnClick(function()
    self:OnBtnPersonalClick()
  end)
  self.textBtnPersonal = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textPersonalDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textPersonalNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.PersonalRewardView = self.viewSkin:AddComponent(self, UIScrollView, 6)
  self.content = self.viewSkin:AddComponent(self, UIBaseContainer, 7)
  self.PersonalRewardView:SetOnItemMoveIn(function(itemObj, index)
    self:OnRewardItemMoveIn(itemObj, index)
  end)
  self.PersonalRewardView:SetOnItemMoveOut(function(itemObj, index)
    self:OnRewardItemMoveOut(itemObj, index)
  end)
  self.textPersonalTitle:SetLocalText("alliance_pay_name_101")
  self.textPersonalDesc:SetLocalText("alliance_pay_conditionName_1")
end

function DailyContentComponent:ComponentDestroy()
  self:ClearRewardScroll()
  self.viewSkin = nil
  self.textPersonalTitle = nil
  self.btnPersonal = nil
  self.textBtnPersonal = nil
  self.textPersonalDesc = nil
  self.textPersonalNum = nil
  self.PersonalRewardView = nil
  self.content = nil
end

function DailyContentComponent:DataDefine()
end

function DailyContentComponent:DataDestroy()
end

function DailyContentComponent:OnAddListener()
  base.OnAddListener(self)
end

function DailyContentComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function DailyContentComponent:OnBtnPersonalClick()
  self.view:OnBtnPersonalRewardClick()
  local canGet = DataCenter.AllianceMilitaryPayDataManager:CanGetDailySalary()
  if canGet then
    DataCenter.AllianceMilitaryPayDataManager:GetAllianceSalaryGainReward(101)
  else
    GoToUtil.GotoOpenView(UIWindowNames.UILWQuestList, UIQuestTab.Daily)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.LWAllianceMilitaryPayMainView)
  end
end

function DailyContentComponent:SetData(data)
  local giftLevel = data.giftLevel
  local template = DataCenter.AlliancePayTemplateManager:GetTemplate(101)
  local rewardId = DataCenter.AlliancePayTemplateManager:GetRewardIdByGiftLevel(template.id, giftLevel)
  self.rewardList = RewardUtil.GetRewardItem(rewardId)
  self:RefreshRewardScrollView()
  local curScore = DataCenter.AllianceMilitaryPayDataManager:GetCurDailySalaryScore()
  local maxScore = DataCenter.AllianceMilitaryPayDataManager:GetMaxDailySalaryScore()
  self.isComplete = curScore >= maxScore
  if self.isComplete then
    self.textPersonalNum:SetText(string.format("<color=#5FEF87>%d</color>/%d", curScore, maxScore))
    self.textBtnPersonal:SetLocalText("2000441")
  else
    self.textPersonalNum:SetText(string.format("<color=#F97077>%d</color>/%d", curScore, maxScore))
    self.textBtnPersonal:SetLocalText("alliance_pay_btn_getPoint")
  end
end

function DailyContentComponent:RefreshRewardScrollView()
  if self.rewardList and #self.rewardList > 0 then
    self.PersonalRewardView:SetTotalCount(#self.rewardList)
    self.PersonalRewardView:RefillCells()
  end
end

function DailyContentComponent:OnRewardItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.PersonalRewardView:AddComponent(RewardItem, itemObj)
  if cellItem ~= nil then
    cellItem:ReInit(self.rewardList[index])
  end
end

function DailyContentComponent:OnRewardItemMoveOut(itemObj, index)
  self.PersonalRewardView:RemoveComponent(itemObj.name, RewardItem)
end

function DailyContentComponent:ClearRewardScroll()
  self.PersonalRewardView:ClearCells()
  self.PersonalRewardView:RemoveComponents(RewardItem)
end

return DailyContentComponent
