local SeasonDeclareList = require("UI.LWSeason.LWSeasonMain.Component.DeclareCity.SeasonDeclareList")
local SeasonDeclareMy = BaseClass("SeasonDeclareMy", SeasonDeclareList)
local base = SeasonDeclareList
local UIRewardTipView = require("UI.UIRewardTip.View.UIRewardTipView")
local Localization = CS.GameEntry.Localization
local no_declare_root_path = "NoDeclareRoot"
local no_declare_root_title_path = "NoDeclareRoot/NoDeclareRootTitle"
local no_declare_root_time_path = "NoDeclareRoot/NoDeclareRootTime"
local btn_select_city_path = "NoDeclareRoot/BtnSelectCity"
local win_tip_path = "win_tip"
local season_reward_root_path = "season_reward_root"
local season_reward_icon_path = "season_reward_root/icon/season_reward_icon"
local season_reward_count_path = "season_reward_root/season_reward_count"
local season_reward_path = "season_reward_root/season_reward"
local action_root_path = "ActionRoot"
local action_tips_path = "ActionRoot/actionTips"
local btn_action_path = "ActionRoot/BtnAction"
local btn_txt_path = "ActionRoot/BtnAction/btnTxt"

function SeasonDeclareMy:OnCreate()
  base.OnCreate(self)
  self.action_root = self:AddComponent(UIBaseContainer, action_root_path)
  self.action_tips = self:AddComponent(UIText, action_tips_path)
  self.btn_action = self:AddComponent(UIButton, btn_action_path)
  self.btn_txt = self:AddComponent(UIText, btn_txt_path)
  self.btn_action:SetOnClick(function()
    self:OnActionClick()
  end)
  self.no_declare_root = self:AddComponent(UIBaseContainer, no_declare_root_path)
  self.no_declare_root_title = self:AddComponent(UIText, no_declare_root_title_path)
  self.no_declare_root_time = self:AddComponent(UIText, no_declare_root_time_path)
  self.btn_select_city = self:AddComponent(UIButton, btn_select_city_path)
  self.btn_select_city:SetOnClick(BindCallback(self, self.OnBtnClickCityList))
  self.reward_icon = self:AddComponent(UIButton, season_reward_icon_path)
  self.reward_icon:SetOnClick(function()
    self:OnRewardShowClick()
  end)
  self.win_tip = self:AddComponent(UIText, win_tip_path)
  self.season_reward_root = self:AddComponent(UIBaseContainer, season_reward_root_path)
  self.season_reward_count = self:AddComponent(UIText, season_reward_count_path)
  self.season_reward = self:AddComponent(UIText, season_reward_path)
  self.season_reward:SetLocalText("season_sever_declare_war_012", "")
end

function SeasonDeclareMy:OnDestroy()
  base.OnDestroy(self)
end

function SeasonDeclareMy:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshCityDeclareCount, self.OnRefreshCityDeclareCount)
end

function SeasonDeclareMy:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshCityDeclareCount, self.OnRefreshCityDeclareCount)
  base.OnRemoveListener(self)
end

function SeasonDeclareMy:OnRefreshCityDeclareCount()
  if self.declareData and self.declareData.result == 0 then
    self.btn_txt:SetLocalText("500413")
    self.action_tips:SetText("")
    self.btn_action:SetActive(true)
    self.action_root:SetActive(true)
  else
    local k6 = DataCenter.AllianceDeclareWarManager:GetConfigData("k6")
    local timeDeclare = DataCenter.AllianceDeclareWarManager:GetDeclareTime()
    if k6 > timeDeclare then
      if self.declareData then
        self.btn_txt:SetLocalText("season_sever_declare_war_008")
        self.action_tips:SetLocalText("new_city_activity_battle_tips1011", timeDeclare .. "/" .. k6)
        self.btn_action:SetActive(true)
        self.action_root:SetActive(true)
      else
        self.action_root:SetActive(false)
      end
    else
      self.action_tips:SetLocalText("season_sever_declare_war_027")
      self.btn_action:SetActive(false)
      self.action_root:SetActive(true)
    end
  end
end

function SeasonDeclareMy:ReInit(view, declareList, thePageItem, redPointKey)
  base.ReInit(self, view, declareList, thePageItem, redPointKey)
  self.todayEndTime = view.todayEndTime
  self.declareList = declareList
  self.theView = view
  self.declareData = nil
  if declareList and 0 < #declareList then
    self.no_declare_root:SetActive(false)
    self:OnUpdateScroll(1)
    self:OnRefreshCityDeclareCount()
  else
    self.no_declare_root:SetActive(true)
    self.win_tip:SetActive(false)
    self.season_reward_root:SetActive(false)
    self.action_root:SetActive(false)
  end
end

function SeasonDeclareMy:OnUpdateScroll(index)
  if self.declareList then
    local declareData = self.declareList[index]
    if declareData then
      local cityId = declareData.cityId
      local cityInfo = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId)
      self.win_tip:SetActive(declareData.result == 1)
      if declareData.result == 0 and declareData.firstReward then
        self.season_reward_root:SetActive(true)
        self.season_reward_count:SetText("x" .. cityInfo.sever_loot_reward)
        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.season_reward_root.transform)
      else
        self.season_reward_root:SetActive(false)
      end
      self.declareData = declareData
    else
      self.win_tip:SetActive(false)
      self.season_reward_root:SetActive(false)
    end
  end
end

function SeasonDeclareMy:Update1000MS()
  if self.todayEndTime then
    local deltaTime = 0
    local curTime = UITimeManager:GetInstance():GetServerTime()
    deltaTime = self.todayEndTime - curTime
    if 0 < deltaTime then
      local showTime = UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime)
      self.no_declare_root_time:SetText(showTime)
    else
      self.no_declare_root_time:SetText("")
    end
  else
    self.no_declare_root_time:SetText("")
  end
end

function SeasonDeclareMy:OnRewardShowClick()
  local param = UIRewardTipView.ParamDataClass.New()
  param.position = self.reward_icon:GetPosition()
  local _screenPos = PosConverse.UIWorldToScreenPos(param.position)
  local ScreenSize = CS.UnityEngine.Screen
  if _screenPos.x * 2 < ScreenSize.width then
    param.deltaX = 30
    param.dir = UIRewardTipView.Direction.LEFT
  else
    param.deltaX = -30
    param.dir = UIRewardTipView.Direction.RIGHT
  end
  param.deltaY = 100
  param.rewardList = DataCenter.SeasonDataManager:GetLootRewardList()
  param.totalVal = 0
  if param.rewardList then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIRewardTip, {anim = false}, param)
  end
end

function SeasonDeclareMy:OnBtnClickCityList()
  if self.theView then
    self.theView:OnBtnClickCityList()
  end
end

function SeasonDeclareMy:OnActionClick()
  if self.declareData and self.declareData.result == 0 then
    self:OnBtnClickGotoCity()
  else
    local k6 = DataCenter.AllianceDeclareWarManager:GetConfigData("k6")
    local timeDeclare = DataCenter.AllianceDeclareWarManager:GetDeclareTime()
    if k6 > timeDeclare then
      if self.theView then
        self.theView:OnBtnClickCityList()
      end
    else
      UIUtil.ShowTipsId("302322")
    end
  end
end

return SeasonDeclareMy
