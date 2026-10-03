local base = UIBaseContainer
local LWSeasonBattleFieldReward = BaseClass("LWSeasonBattleFieldReward", base)
local Localization = CS.GameEntry.Localization
local LWSeasonBattleFieldRewardItem = require("UI.LWSeason.LWSeasonReward.Component.LWSeasonBattleFieldRewardItem")
local alliance_reward_item_path = "root/AllianceRewardItem"
local scroll_view_path = "root/Reward/ScrollView"
local des_btn_path = "root/Reward/DesBtn"
local personal_condition_path = "root/bottom/personalCondition"
local coutndown_path = "root/bottom/coutndown"

function LWSeasonBattleFieldReward:OnCreate()
  base.OnCreate(self)
  self.alliance_reward_item = self:AddComponent(UIBaseContainer, alliance_reward_item_path)
  self.personal_condition = self:AddComponent(UITextMeshProUGUIEx, personal_condition_path)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.des_btn = self:AddComponent(UIButton, des_btn_path)
  self.coutndown = self:AddComponent(UITextMeshProUGUIEx, coutndown_path)
  self.des_btn:SetOnClick(function()
    self:DesClick()
  end)
  self.des_btn:SetActive(false)
  self.personal_condition:SetActive(false)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnRankItemMoveIn(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnRankItemMoveOut(itemObj, index)
  end)
end

function LWSeasonBattleFieldReward:OnDestroy()
  self.alliance_reward_item = nil
  self.des_btn = nil
  self.personal_condition = nil
  self:ClearScroll()
  self.scroll_view = nil
  self.coutndown = nil
  base.OnDestroy(self)
end

function LWSeasonBattleFieldReward:OnEnable()
  base.OnEnable(self)
end

function LWSeasonBattleFieldReward:OnDisable()
  base.OnDisable(self)
end

function LWSeasonBattleFieldReward:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonServerCrossForceRankRewardInfoUpdate, self.RewardDataUpdate)
  self:AddUIListener(EventId.LWSeasonCampRankRewardInfoUpdate, self.RewardDataUpdate)
  self:AddUIListener(EventId.LWSeasonServerFarmRankRewardInfoUpdate, self.RewardDataUpdate)
  self:AddUIListener(EventId.SeasonGreenCityRankReward, self.RewardDataUpdate)
end

function LWSeasonBattleFieldReward:OnRemoveListener()
  self:RemoveUIListener(EventId.LWSeasonServerCrossForceRankRewardInfoUpdate, self.RewardDataUpdate)
  self:RemoveUIListener(EventId.LWSeasonCampRankRewardInfoUpdate, self.RewardDataUpdate)
  self:RemoveUIListener(EventId.LWSeasonServerFarmRankRewardInfoUpdate, self.RewardDataUpdate)
  self:RemoveUIListener(EventId.SeasonGreenCityRankReward, self.RewardDataUpdate)
  base.OnRemoveListener(self)
end

function LWSeasonBattleFieldReward:SetData(panelType)
  self.panelType = panelType
  self.endTime = DataCenter.SeasonDataManager:GetSeasonSettleTime()
  if self.panelType == LWSeasonBattleFieldRewardPanelType.BattleField then
    local info = DataCenter.SeasonRewardDataManager:GetServerCrossForceRankRewardInfo()
    if info == nil then
      SFSNetwork.SendMessage(MsgDefines.LWSeasonServerForceRankRewardInfo, SeasonUtil.IsInSeasonPrepareMode())
    end
  elseif self.panelType == LWSeasonBattleFieldRewardPanelType.Camp then
    local data = DataCenter.SeasonRewardDataManager:GetSeasonCampRankRewardInfo()
    if data == nil then
      SFSNetwork.SendMessage(MsgDefines.LWSeasonCampRankRewardInfo, SeasonUtil.IsInSeasonPrepareMode())
    end
  elseif self.panelType == LWSeasonBattleFieldRewardPanelType.FamerReward then
    local info = DataCenter.SeasonRewardDataManager:GetSeasonFamerRankRewardInfo()
    if info == nil then
      SFSNetwork.SendMessage(MsgDefines.SeasonBuilderAllianceRankRewardPreview)
    end
  elseif self.panelType == LWSeasonBattleFieldRewardPanelType.GreenReward then
    self.endTime = nil
    local info = DataCenter.SeasonRewardDataManager:GetSeasonGreenRankRewardInfo()
    if info == nil then
      SFSNetwork.SendMessage(MsgDefines.SeasonGreenCityRankReward)
    end
  end
  self:RefreshReward()
  if self.endTime then
    self:Update1000MS()
    self.coutndown:SetActive(true)
  else
    self.coutndown:SetActive(false)
  end
end

function LWSeasonBattleFieldReward:RefreshReward()
  self:ClearScroll()
  self.reward = nil
  local info
  if self.panelType == LWSeasonBattleFieldRewardPanelType.BattleField then
    self.des_btn:SetActive(false)
    self.personal_condition:SetActive(false)
    info = DataCenter.SeasonRewardDataManager:GetServerCrossForceRankRewardInfo()
  elseif self.panelType == LWSeasonBattleFieldRewardPanelType.Camp then
    info = DataCenter.SeasonRewardDataManager:GetSeasonCampRankRewardInfo()
    self.des_btn:SetActive(not SeasonUtil.IsInSeasonPrepareMode())
    if info then
      self.personal_condition:SetText(info.personalCondition)
      self.personal_condition:SetActive(not SeasonUtil.IsInSeasonPrepareMode())
    else
      self.personal_condition:SetActive(false)
    end
  elseif self.panelType == LWSeasonBattleFieldRewardPanelType.FamerReward then
    self.des_btn:SetActive(false)
    self.personal_condition:SetActive(false)
    info = DataCenter.SeasonRewardDataManager:GetSeasonFamerRankRewardInfo()
  elseif self.panelType == LWSeasonBattleFieldRewardPanelType.GreenReward then
    info = DataCenter.SeasonRewardDataManager:GetSeasonGreenRankRewardInfo()
    self.des_btn:SetActive(not SeasonUtil.IsInSeasonPrepareMode())
    if info then
      self.personal_condition:SetText(info.personalCondition)
      self.personal_condition:SetActive(true)
    else
      self.personal_condition:SetActive(false)
    end
  end
  if info then
    self.reward = info.rewardInfo
  end
  if self.reward and #self.reward > 0 then
    self.scroll_view:SetTotalCount(#self.reward)
    self.scroll_view:RefillCells()
  end
end

function LWSeasonBattleFieldReward:OnRankItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scroll_view:AddComponent(LWSeasonBattleFieldRewardItem, itemObj)
  if cellItem ~= nil then
    if self.panelType == LWSeasonBattleFieldRewardPanelType.BattleField then
      local title = Localization:GetString("season_tips152", self.reward[index].condition)
      local tittl2 = Localization:GetString("season_reward_ui_021")
      cellItem:SetData(self.reward[index], title, tittl2)
    else
      local title = self.reward[index].title
      local tittl2 = self.reward[index].titleDes
      cellItem:SetData(self.reward[index], title, tittl2)
    end
  end
end

function LWSeasonBattleFieldReward:OnRankItemMoveOut(itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, LWSeasonBattleFieldRewardItem)
end

function LWSeasonBattleFieldReward:ClearScroll()
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(LWSeasonBattleFieldRewardItem)
end

function LWSeasonBattleFieldReward:RewardDataUpdate()
  self:RefreshReward()
end

function LWSeasonBattleFieldReward:DesClick()
  if self.panelType == LWSeasonBattleFieldRewardPanelType.Camp then
    local info = DataCenter.SeasonRewardDataManager:GetSeasonCampRankRewardInfo()
    local param = {}
    param.subTitle = "170001"
    param.activityRulesStr = info.helpDes
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  elseif self.panelType == LWSeasonBattleFieldRewardPanelType.GreenReward then
    local mainCfg = DataCenter.SeasonGreenManager:GetMainCfg()
    local str = mainCfg and mainCfg.grade_reward_help
    local param = {}
    param.activityRulesStr = Localization:GetString(str)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end
end

function LWSeasonBattleFieldReward:Update1000MS()
  if self.endTime then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.endTime - curTime
    if 0 < remainTime then
      local des = Localization:GetString("season_reward_ui_007") .. "<color=#ffcd87>" .. " " .. UITimeManager:GetInstance():MilliSecondToFmtString(remainTime) .. "</color>"
      self.coutndown:SetText(des)
    else
      self.coutndown:SetText("")
      self.endTime = nil
    end
  end
end

return LWSeasonBattleFieldReward
