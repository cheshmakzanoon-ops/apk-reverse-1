local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local UIAttackCityS0BattlePassView = BaseClass("UIAttackCityS0BattlePassView", base)
local UICityAttackS0PageToggleItem = require("UI.LWCityAttackS0.BattlePass.Component.UICityAttackS0PageToggleItem")
local CompCityTaskComponent = require("UI.LWCityAttackS0.BattlePass.Component.CompCityTaskComponent")
local CompScoreTaskComponent = require("UI.LWCityAttackS0.BattlePass.Component.CompScoreTaskComponent")
local Localization = CS.GameEntry.Localization

function UIAttackCityS0BattlePassView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIAttackCityS0BattlePassView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAttackCityS0BattlePassView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textResourceNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.imgResourceIcon = self.viewSkin:AddComponent(self, UIImage, 2)
  self.btnInfo = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.textTxtTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textTxtTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textTxtInfo = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.togglesRectList = self.viewSkin:AddComponent(self, UIBaseComponent, 7)
  self.listPageTogTab = {}
  self.togTabRed = {}
  for i = 1, 2 do
    local togglePath = "RightView/Rect_Top/Rect_List/Toggle_List" .. i
    self.listPageTogTab[i] = self:AddComponent(UICityAttackS0PageToggleItem, togglePath)
    self.togTabRed[i] = self:AddComponent(UICommonRedPoint, "RightView/Rect_Top/Rect_List/Toggle_List" .. i .. "/CommonRedPoint" .. i)
    self.togTabRed[i]:SetType(CommonRedPointPriority.Level1)
    self.listPageTogTab[i]:SetData(i, function()
      local isOn = self.listPageTogTab[i].Toggle:GetIsOn()
      if isOn and self.childTabIndex ~= i then
        self.childTabIndex = i
        self:RefreshSelectData(i)
      end
    end)
  end
  self.scoreTaskPage = self:AddComponent(CompScoreTaskComponent, "RightView/Rect_Bottom/compScoreTask")
  self.cityTaskPage = self:AddComponent(CompCityTaskComponent, "RightView/Rect_Bottom/compCityTask")
  self.scoreTaskPage.gameObject:SetActive(false)
  self.cityTaskPage.gameObject:SetActive(false)
end

function UIAttackCityS0BattlePassView:ComponentDestroy()
  self.viewSkin = nil
  self.textResourceNum = nil
  self.imgResourceIcon = nil
  self.btnInfo = nil
  self.textTxtTitle = nil
  self.textTxtTime = nil
  self.textTxtInfo = nil
  self.togglesRectList = nil
  self.listPageTogTab = nil
  self.scoreTaskPage = nil
  self.cityTaskPage = nil
end

function UIAttackCityS0BattlePassView:DataDefine()
end

function UIAttackCityS0BattlePassView:DataDestroy()
  self.activityId = nil
  self.activityData = nil
  self.childTabIndex = nil
end

function UIAttackCityS0BattlePassView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AttackCityS0BattlePass, self.UpdateData)
end

function UIAttackCityS0BattlePassView:OnRemoveListener()
  self:RemoveUIListener(EventId.AttackCityS0BattlePass, self.UpdateData)
  base.OnRemoveListener(self)
end

function UIAttackCityS0BattlePassView:OnBtnInfoClick()
  if self.activityData ~= nil and self.activityData.story ~= nil then
    local param = {}
    param.activityId = self.activityId
    param.activityRulesStr = Localization:GetString(self.activityData.story)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end
end

function UIAttackCityS0BattlePassView:SetData(activityId)
  base.SetData(self, activityId)
  self.activityId = activityId
  if not self.activityId then
    return
  end
  self.activityData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  self.textTxtTitle:SetLocalText("city_war_battle_pass_02")
  self.textTxtInfo:SetLocalText("city_war_battle_pass_04")
  self:UpdateData()
end

function UIAttackCityS0BattlePassView:UpdateData()
  self.childTabIndex = -1
  for i = 1, 2 do
    local isOn = self.listPageTogTab[i].Toggle:GetIsOn()
    if isOn and self.childTabIndex ~= i then
      self.childTabIndex = i
    end
  end
  self:RefreshSelectData(self.childTabIndex)
  self:RedDayRefresh()
end

function UIAttackCityS0BattlePassView:RefreshSelectData()
  self:UpdateBattlePassScore()
  for i = 1, 2 do
    if i == self.childTabIndex then
      self.listPageTogTab[i]:OnSelect(true)
    else
      self.listPageTogTab[i]:OnSelect(false)
    end
  end
  if self.childTabIndex == 1 then
    self.scoreTaskPage.gameObject:SetActive(true)
    self.cityTaskPage.gameObject:SetActive(false)
    self.scoreTaskPage:RefreshPage()
  else
    self.scoreTaskPage.gameObject:SetActive(false)
    self.cityTaskPage.gameObject:SetActive(true)
    self.cityTaskPage:RefreshPage()
  end
end

function UIAttackCityS0BattlePassView:UpdateBattlePassScore()
  local score = DataCenter.AttackCityS0DataManager:GetBattlePassScore()
  self.textResourceNum:SetText(score)
end

function UIAttackCityS0BattlePassView:Update1000MS()
  if not self.activityId then
    return
  end
  if self.activityData == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local leftTime = self.activityData.endTime - curTime
  if leftTime < 0 then
    leftTime = 0
  end
  local countDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
  self.textTxtTime:SetText(countDownTimeStr)
end

function UIAttackCityS0BattlePassView:RedDayRefresh()
  local redData = {
    DataCenter.AttackCityS0DataManager:GetBattlePassScoreRedPointNum(),
    DataCenter.AttackCityS0DataManager:GetBattlePassCitySRedPointNum()
  }
  for i = 1, #redData do
    self.togTabRed[i]:SetNum(redData[i])
  end
end

return UIAttackCityS0BattlePassView
