local base = UIBaseContainer
local LWSeasonAllianceReward = BaseClass("LWSeasonAllianceReward", base)
local Localization = CS.GameEntry.Localization
local LWSeasonAllianceRewardItem = require("UI.LWSeason.LWSeasonReward.Component.LWSeasonAllianceRewardItem")
local SeasonRedPointUtils = require("UI.LWSeason.LWSeasonMain.Utils.SeasonRedPointUtils")
local SeasonRewardTopEightPrefab = "Assets/Main/Prefabs/UI/LWSeason2/Component/SeasonRewardTopEight.prefab"
local S1SeasonRewardTopEight = "Assets/Main/Prefabs/UI/LWSeason1/Component/S1SeasonRewardTopEight.prefab"
local S3SeasonRewardTopEight = "Assets/Main/SeasonRes/S3/Prefabs/UI/LWSeasonReward/S3SeasonRewardTopEight.prefab"
local S4SeasonRewardTopEight = "Assets/Main/SeasonRes/S4/Prefabs/UI/LWSeasonReward/S4SeasonRewardTopEight.prefab"
local topEight = require("UI.LWSeason.LWSeasonReward.Component.SeasonAllianceRewardTop")
local level_path = "root/Top/Level%d"
local normal_path = "root/Top/Level%d/normal%d"
local selected_path = "root/Top/Level%d/selected%d"
local reward_tier_red_point_path = "root/Top/Level%d/RedPoint%d"
local Count = 4
local bottom_path = "root/Bottom"
local condition_tips_path = "root/Bottom/conditionTips"
local condition_root_path = "root/Bottom/condition"
local condition_bg1_path = "root/Bottom/condition/conditionItem1/conditionBg1"
local condition_des_finish1_path = "root/Bottom/condition/conditionItem1/conditionDesFinish1"
local condition_des_not_finish1_path = "root/Bottom/condition/conditionItem1/conditionDesNotFinish1"
local condition_bg2_path = "root/Bottom/condition/conditionItem2/conditionBg2"
local condition_des_finish2_path = "root/Bottom/condition/conditionItem2/conditionDesFinish2"
local condition_des_not_finish2_path = "root/Bottom/condition/conditionItem2/conditionDesNotFinish2"
local condition_item1_path = "root/Bottom/condition/conditionItem1"
local condition_item2_path = "root/Bottom/condition/conditionItem2"
local alliance_reward_item_path = "root/AllianceRewardItem"
local scroll_view_path = "root/Bottom/ScrollView"
local coutndown_path = "root/Bottom/coutndown"
local completed_path = "root/Bottom/Completed"
local top_path = "root/Top"
local btn_reward_path = "root/BtnReward"
local red_point_path = "root/BtnReward/RedPoint"
local join_alliance_path = "root/JoinAlliance"
local des_btn_path = "root/DesBtn"
local farmer_tip_path = "root/farmerTip"
local dyamic_root_path = "root/dyamicRoot"
local TopType = {
  None = 0,
  Old4 = 1,
  New8 = 2
}

function LWSeasonAllianceReward:OnCreate()
  base.OnCreate(self)
  for i = 1, Count do
    self["titleBtn" .. i] = self:AddComponent(UIButton, string.format(level_path, i))
    self["titleBtn" .. i]:SetOnClick(function()
      self:TittleBtnClick(i)
    end)
    self["tittleBg" .. i] = self:AddComponent(UIImage, string.format(normal_path, i, i))
    self["tittleSelect" .. i] = self:AddComponent(UIImage, string.format(selected_path, i, i))
    self["tittleSelect" .. i]:SetActive(false)
    self["reward_tier_red_point" .. i] = self:AddComponent(UIBaseContainer, string.format(reward_tier_red_point_path, i, i))
    self["reward_tier_red_point" .. i]:SetActive(false)
  end
  self.farmer_tip = self:AddComponent(UITextMeshProUGUIEx, farmer_tip_path)
  self.condition_tips = self:AddComponent(UIText, condition_tips_path)
  self.condition_root = self:AddComponent(UIBaseContainer, condition_root_path)
  self.condition_bg1 = self:AddComponent(UIImage, condition_bg1_path)
  self.condition_des_finish1 = self:AddComponent(UIText, condition_des_finish1_path)
  self.condition_des_not_finish1 = self:AddComponent(UIText, condition_des_not_finish1_path)
  self.condition_bg2 = self:AddComponent(UIImage, condition_bg2_path)
  self.condition_des_finish2 = self:AddComponent(UIText, condition_des_finish2_path)
  self.condition_des_not_finish2 = self:AddComponent(UIText, condition_des_not_finish2_path)
  self.condition_item1 = self:AddComponent(UIBaseContainer, condition_item1_path)
  self.condition_item2 = self:AddComponent(UIBaseContainer, condition_item2_path)
  self.top = self:AddComponent(UIBaseContainer, top_path)
  self.alliance_reward_item = self:AddComponent(UIBaseContainer, alliance_reward_item_path)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.completed = self:AddComponent(UIImage, completed_path)
  self.completed:SetActive(false)
  self.bottom = self:AddComponent(UIBaseContainer, bottom_path)
  self.join_alliance = self:AddComponent(UIButton, join_alliance_path)
  self.des_btn = self:AddComponent(UIButton, des_btn_path)
  self.top:SetActive(false)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnRankItemMoveIn(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnRankItemMoveOut(itemObj, index)
  end)
  self.dyamic_root = self:AddComponent(UIBaseContainer, dyamic_root_path)
  self.coutndown = self:AddComponent(UIText, coutndown_path)
  self.btn_reward = self:AddComponent(UIButton, btn_reward_path)
  self.btn_reward:SetOnClick(function()
    self:DistributeReward()
  end)
  self.red_point = self:AddComponent(UIBaseContainer, red_point_path)
  self.red_point:SetActive(false)
  self.join_alliance:SetOnClick(function()
    self:JoinAlliance()
  end)
  self.des_btn:SetOnClick(function()
    if self.selectIndex then
      local configId = DataCenter.SeasonRewardDataManager:GetAllianceRewardConfigData(self.selectIndex)
      if configId then
        local line = LocalController:instance():getLine(TableName.LW_Season_Alliance_Reward, configId)
        if line and not string.IsNullOrEmpty(line.help) then
          local param = {}
          param.activityRulesStr = Localization:GetString(line.help)
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
        end
      end
    end
  end)
end

function LWSeasonAllianceReward:OnDestroy()
  self:ClearScroll()
  for i = 1, Count do
    self["titleBtn" .. i] = nil
    self["tittleBg" .. i] = nil
    self["tittleSelect" .. i] = nil
  end
  self.condition_bg1 = nil
  self.condition_des_finish1 = nil
  self.condition_des_not_finish1 = nil
  self.condition_bg2 = nil
  self.condition_des_finish2 = nil
  self.condition_des_not_finish2 = nil
  self.des_btn = nil
  self.condition_item1 = nil
  self.condition_item2 = nil
  self.completed = nil
  self.alliance_reward_item = nil
  self.scroll_view = nil
  self.farmer_tip = nil
  self.coutndown = nil
  self.btn_reward = nil
  self.red_point = nil
  self.top = nil
  self.bottom = nil
  self.join_alliance = nil
  self.dyamic_root = nil
  self.topEightReq = nil
  self.topEightCom = nil
  base.OnDestroy(self)
end

function LWSeasonAllianceReward:OnEnable()
  base.OnEnable(self)
end

function LWSeasonAllianceReward:OnDisable()
  base.OnDisable(self)
end

function LWSeasonAllianceReward:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonAllianceRewardInfoUpdate, self.RefreshCurIndex)
  self:AddUIListener(EventId.LWSeasonAllianceRewardProgressUpdate, self.RefreshCurIndexCondition)
  self:AddUIListener(EventId.LWSeasonAllianceRewardCountUpdate, self.RefreshCurIndex)
  self:AddUIListener(EventId.AllianceBaseDataUpdated, self.AllianceBaseDataUpdate)
end

function LWSeasonAllianceReward:OnRemoveListener()
  self:RemoveUIListener(EventId.LWSeasonAllianceRewardInfoUpdate, self.RefreshCurIndex)
  self:RemoveUIListener(EventId.LWSeasonAllianceRewardProgressUpdate, self.RefreshCurIndexCondition)
  self:RemoveUIListener(EventId.LWSeasonAllianceRewardCountUpdate, self.RefreshCurIndex)
  self:RemoveUIListener(EventId.AllianceBaseDataUpdated, self.AllianceBaseDataUpdate)
  base.OnRemoveListener(self)
end

function LWSeasonAllianceReward:SetData()
  self:RefreshPanel()
end

function LWSeasonAllianceReward:RefreshPanel()
  local allianceFlag = LuaEntry.Player:IsInAlliance()
  local famer = DataCenter.SeasonFarmerManager:IsActive()
  self.farmer_tip:SetActive(famer)
  self.join_alliance:SetActive(not allianceFlag)
  self.btn_reward:SetActive(allianceFlag and not famer and not SeasonUtil.IsInSeasonPrepareMode())
  self.des_btn:SetActive(allianceFlag and not famer and not SeasonUtil.IsInSeasonPrepareMode())
  self.allianceRewardState = DataCenter.SeasonRewardDataManager:CheckAllianceRewardData() == 1
  local count = DataCenter.SeasonRewardDataManager:GetAllianceRewardTierCount()
  self.topType = TopType.None
  local old = self.bottom.rectTransform.offsetMax
  if count == 4 then
    self.topType = TopType.Old4
    self.top:SetActive(true)
    self.bottom.rectTransform.offsetMax = Vector2.New(old.x, -420)
  elseif count == 8 then
    self.topType = TopType.New8
    if self.topEightCom ~= nil then
      self.topEightCom:SetActive(true)
    end
    self.bottom.rectTransform.offsetMax = Vector2.New(old.x, -500)
    self:TryShowTopEight()
  end
  self.selectIndex = nil
  self.endTime = DataCenter.SeasonDataManager:GetSeasonSettleTime()
  self:Update1000MS()
  local curIndex = self:RefreshTierBg()
  self:SelectTitle(curIndex, true)
  self:RefreshBtnRed()
end

function LWSeasonAllianceReward:TryShowTopEight()
  local prefabPath = SeasonRewardTopEightPrefab
  local severInfo = DataCenter.SeasonDataManager:GetUserSeasonInfo()
  local configId = severInfo.seasonConfigId
  if severInfo:InPreviewMode() then
    configId = severInfo.nextSeasonConfigId
  end
  local seasonConfig = LocalController:instance():getLine(TableName.LW_Season, configId)
  local topReset = false
  if seasonConfig and seasonConfig.type == SeasonMapType.CityStronghold then
    prefabPath = S1SeasonRewardTopEight
  end
  if seasonConfig and seasonConfig.type == SeasonMapType.Mummy then
    prefabPath = S3SeasonRewardTopEight
  end
  if seasonConfig and seasonConfig.type == SeasonMapType.Darkness then
    prefabPath = S4SeasonRewardTopEight
    topReset = true
  end
  if self.topEightReq == nil then
    self.topEightReq = self:GameObjectInstantiateAsync(prefabPath, function(req)
      if req == nil or IsNull(req.gameObject) then
        return
      end
      local item = req.gameObject
      item.name = "topEight"
      item:SetActive(true)
      item.transform:SetParent(self.dyamic_root.transform)
      item.transform:Set_localScale(1, 1, 1)
      item.transform:Set_localPosition(0, 0, 0)
      self.topEightCom = self.dyamic_root:AddComponent(topEight, item.name)
      self.topEightCom:Init(function(i)
        self:TitleClickCallback(i)
      end)
      if self.rewardTier then
        self.topEightCom:RefreshTierBg(self.rewardTier)
      end
      if self.selectIndex then
        self.topEightCom:SelectTitle(self.selectIndex)
      end
      if topReset then
        self.topEightCom:SetAnchoredPositionXY(0, 0)
      end
    end)
  end
end

function LWSeasonAllianceReward:RefreshTierBg()
  local curIndex = DataCenter.SeasonRewardDataManager:GenerateAllianceRewardTier()
  self.rewardTier = curIndex
  if self.topType == TopType.Old4 then
    for i = 1, Count do
      local path = ""
      if i == curIndex then
        path = string.format("Assets/Main/Sprites/UI/UISeasonReward/Mjc_saijijiangli_lianmengjiangli_%d_1.png", 5 - i)
      else
        path = string.format("Assets/Main/Sprites/UI/UISeasonReward/Mjc_saijijiangli_lianmengjiangli_%d_0.png", 5 - i)
      end
      self["tittleBg" .. i]:LoadSprite(path)
    end
  elseif self.topEightCom then
    self.topEightCom:RefreshTierBg(curIndex)
  end
  if curIndex < 1 or curIndex > Count then
    curIndex = 1
  end
  return curIndex
end

function LWSeasonAllianceReward:ShowNoData()
  self.selectIndex = nil
  self.endTime = nil
  self.coutndown:SetText("")
  for i = 1, Count do
    local path = "Assets/Main/Sprites/UI/UISeasonReward/Mjc_saijijiangli_lianmengjiangli_4_0.png"
    self["tittleBg" .. i]:LoadSprite(path)
    self["tittleSelect" .. i]:SetActive(false)
  end
  for i = 1, 2 do
    self["condition_item" .. i]:SetActive(false)
  end
  self:RefreshReward(-1)
end

function LWSeasonAllianceReward:SelectTitle(index, callNewLogic)
  if index and self.selectIndex ~= index then
    if self.allianceRewardState then
      self.selectIndex = index
    else
      self.selectIndex = nil
    end
    if self.topType == TopType.Old4 then
      for i = 1, Count do
        if i == self.selectIndex then
          self["tittleSelect" .. i]:SetActive(true)
        else
          self["tittleSelect" .. i]:SetActive(false)
        end
      end
    elseif callNewLogic and self.topType == TopType.New8 and self.topEightCom then
      self.topEightCom:SelectTitle(index)
    end
    self:RefreshCondition(index)
    self:RefreshReward(index)
  end
end

function LWSeasonAllianceReward:TittleBtnClick(index)
  self:SelectTitle(index)
end

function LWSeasonAllianceReward:RefreshBtnRed()
  local redFlag = SeasonRedPointUtils.SeasonAllianceRewardDistributeBtnRedState()
  self.red_point:SetActive(redFlag)
  if self.topType == TopType.Old4 then
    for i = 1, Count do
      self["reward_tier_red_point" .. i]:SetActive(redFlag and i == self.rewardTier)
    end
  elseif self.topType == TopType.New8 and self.topEightCom then
    self.topEightCom:RefreshBtnRed(self.rewardTier, redFlag)
  end
end

function LWSeasonAllianceReward:DistributeReward()
  local flag, rewardTier = DataCenter.SeasonRewardDataManager:CheckDistributeRewardTimeAndTier(true)
  if flag then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonAwards, rewardTier)
  end
end

function LWSeasonAllianceReward:JoinAlliance()
  GoToUtil.CloseAllWindows()
  local params = {guide = false}
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, params)
end

function LWSeasonAllianceReward:RefreshCondition(index)
  if SeasonUtil.IsInSeasonPrepareMode() then
    self.condition_root:SetActive(false)
    self.condition_tips:SetLocalText("season_pre_start_desc01")
    self.condition_tips:SetActive(true)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.bottom.rectTransform)
    return
  end
  local data = DataCenter.SeasonRewardDataManager:GetAllianceRewardConditionData(index)
  local finishAll = true
  if data then
    local conditions = {}
    for _, group in pairs(data) do
      for _, condition in pairs(group.conditions) do
        table.insert(conditions, condition)
      end
    end
    for i = 1, 2 do
      local conditionData = conditions[i]
      if conditionData then
        self["condition_item" .. i]:SetActive(true)
        local bgPath
        if conditionData.isFinish then
          bgPath = "Assets/Main/Sprites/UI/UISeasonReward/Mjc_saijijiangli_lianmengjiangli_list1.png"
        else
          bgPath = "Assets/Main/Sprites/UI/UISeasonReward/Mjc_saijijiangli_lianmengjiangli_list2.png"
          finishAll = false
        end
        self["condition_bg" .. i]:LoadSprite(bgPath)
        self["condition_des_finish" .. i]:SetActive(conditionData.isFinish)
        self["condition_des_not_finish" .. i]:SetActive(not conditionData.isFinish)
        self["condition_des_finish" .. i]:SetText(conditionData.text)
        self["condition_des_not_finish" .. i]:SetText(conditionData.text)
      else
        self["condition_item" .. i]:SetActive(false)
      end
    end
    self.completed:SetActive(finishAll)
  else
    self.completed:SetActive(false)
  end
  self.condition_root:SetActive(true)
  self.condition_tips:SetActive(false)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.condition_root.rectTransform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.bottom.rectTransform)
end

function LWSeasonAllianceReward:RefreshReward(index)
  self:ClearScroll()
  local tmpReward = DataCenter.SeasonRewardDataManager:GetAllianceRewardData(index)
  if tmpReward and 0 < #tmpReward then
    self.reward = {}
    for i, v in ipairs(tmpReward) do
      table.insert(self.reward, v)
    end
    table.sort(self.reward, function(a, b)
      return a.order < b.order
    end)
    self.scroll_view:SetTotalCount(#self.reward)
    self.scroll_view:RefillCells()
  end
end

function LWSeasonAllianceReward:OnRankItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scroll_view:AddComponent(LWSeasonAllianceRewardItem, itemObj)
  if cellItem ~= nil then
    cellItem:SetData(self.reward[index], self)
  end
end

function LWSeasonAllianceReward:OnRankItemMoveOut(itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, LWSeasonAllianceRewardItem)
end

function LWSeasonAllianceReward:ClearScroll()
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(LWSeasonAllianceRewardItem)
end

function LWSeasonAllianceReward:Update1000MS()
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

function LWSeasonAllianceReward:RefreshCurIndex()
  if self.topType == TopType.None then
    local count = DataCenter.SeasonRewardDataManager:GetAllianceRewardTierCount()
    local old = self.bottom.rectTransform.offsetMax
    if count == 4 then
      self.topType = TopType.Old4
      self.top:SetActive(true)
      self.bottom.rectTransform.offsetMax = Vector2.New(old.x, -420)
    elseif count == 8 then
      self.topType = TopType.New8
      if self.topEightCom ~= nil then
        self.topEightCom:SetActive(true)
      end
      self.bottom.rectTransform.offsetMax = Vector2.New(old.x, -500)
      self:TryShowTopEight()
    end
  end
  local curIndex = self:RefreshTierBg()
  self.allianceRewardState = true
  local index = self.selectIndex and self.selectIndex or curIndex
  self.selectIndex = nil
  self:SelectTitle(index, true)
  self:RefreshBtnRed()
end

function LWSeasonAllianceReward:RefreshCurIndexCondition()
  if self.selectIndex then
    self:RefreshCondition(self.selectIndex)
  end
end

function LWSeasonAllianceReward:TitleClickCallback(index)
  self:SelectTitle(index, true)
end

function LWSeasonAllianceReward:AllianceBaseDataUpdate()
  local allianceFlag = LuaEntry.Player:IsInAlliance()
  local famer = DataCenter.SeasonFarmerManager:IsActive()
  self.join_alliance:SetActive(not allianceFlag)
  self.btn_reward:SetActive(allianceFlag and not famer and not SeasonUtil.IsInSeasonPrepareMode())
  self.des_btn:SetActive(allianceFlag and not famer and not SeasonUtil.IsInSeasonPrepareMode())
  self.farmer_tip:SetActive(famer)
end

return LWSeasonAllianceReward
