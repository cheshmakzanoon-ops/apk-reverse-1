local base = UIBaseContainer
local LWS6AllianceReward = BaseClass("LWS6AllianceReward", base)
local Localization = CS.GameEntry.Localization
local LWS6AllianceRewardItem = require("UI.LWSeason6.UILWSeason6Reward.Comp.LWS6AllianceRewardItem")
local SeasonRedPointUtils = require("UI.LWSeason.LWSeasonMain.Utils.SeasonRedPointUtils")
local SeasonRewardTopEightPrefab = "Assets/Main/SeasonRes/S6/Prefabs/UI/AllianceReward/S6SeasonRewardTopEight.prefab"
local topEight = require("UI.LWSeason6.UILWSeason6Reward.Comp.LWS6AllianceRewardTop")
local p_trans_condition_group_path = "root/Bottom/condition/p_trans_condition_group"
local group_script_path = require("UI.LWSeason6.UILWSeason6Reward.Comp.LWS6AllianceRewardConditionGroupComp")
local p_condition_group_template_path = "root/Bottom/condition/p_condition_group_template"
local bottom_path = "root/Bottom"
local condition_tips_path = "root/Bottom/conditionTips"
local condition_root_path = "root/Bottom/condition"
local alliance_reward_item_path = "root/AllianceRewardItem"
local scroll_view_path = "root/Bottom/ScrollView"
local content_countdown_path = "root/Bottom/content_countdown"
local coutndown_path = "root/Bottom/content_countdown/countdown"
local btn_reward_path = "root/Bottom/BtnReward"
local red_point_path = "root/Bottom/BtnReward/RedPoint"
local join_alliance_path = "root/Bottom/JoinAlliance"
local des_btn_path = "root/Bottom/DesBtn"
local dyamic_root_path = "root/dyamicRoot"
local text_task_title_path = "root/Bottom/condition/TitleBg/textTaskTitle"
local p_btn_condition_fold_path = "root/Bottom/condition/p_btn_condition_fold"
local img_condition_fold_path = "root/Bottom/condition/p_btn_condition_fold/img_condition_fold"
local condition_bg_path = "root/Bottom/condition/conditionBg"
local TopType = {None = 0, New8 = 2}

function LWS6AllianceReward:OnCreate()
  base.OnCreate(self)
  self.text_task_title = self:AddComponent(UITextMeshProUGUIEx, text_task_title_path)
  self.condition_tips = self:AddComponent(UIText, condition_tips_path)
  self.condition_root = self:AddComponent(UIBaseContainer, condition_root_path)
  self.alliance_reward_item = self:AddComponent(UIBaseContainer, alliance_reward_item_path)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.bottom = self:AddComponent(UIBaseContainer, bottom_path)
  self.join_alliance = self:AddComponent(UIButton, join_alliance_path)
  self.des_btn = self:AddComponent(UIButton, des_btn_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnRankItemMoveIn(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnRankItemMoveOut(itemObj, index)
  end)
  self.dyamic_root = self:AddComponent(UIBaseContainer, dyamic_root_path)
  self.content_countdown = self:AddComponent(UIBaseContainer, content_countdown_path)
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
  self.p_condition_group_template = self:AddComponent(group_script_path, p_condition_group_template_path)
  self.p_trans_condition_group = self:AddComponent(UIBaseContainer, p_trans_condition_group_path)
  self.goItemTemplate = self.p_condition_group_template.gameObject
  self.goItemTemplate:GameObjectCreatePool()
  self.goItemTemplate:SetActive(false)
  self.condition_bg = self:AddComponent(UIImage, condition_bg_path)
  self.p_btn_condition_fold = self:AddComponent(UIButton, p_btn_condition_fold_path)
  self.img_condition_fold = self:AddComponent(UIImage, img_condition_fold_path)
  self.ImgCollapse = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_lianmeng_anniu_xiala_2.png"
  self.ImgExpand = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_lianmeng_anniu_xiala_1.png"
  self.p_btn_condition_fold:SetOnClick(function()
    self:OnFoldClick()
  end)
  self.IsTaskExpand = true
  self:FoldTask(self.IsTaskExpand)
end

function LWS6AllianceReward:OnDestroy()
  self:ClearScroll()
  self.p_trans_condition_group:RemoveComponents(group_script_path)
  self.goItemTemplate:GameObjectRecycleAll()
  self.text_task_title = nil
  self.condition_bg1 = nil
  self.condition_des_finish1 = nil
  self.condition_des_not_finish1 = nil
  self.condition_bg2 = nil
  self.condition_des_finish2 = nil
  self.condition_des_not_finish2 = nil
  self.des_btn = nil
  self.condition_item1 = nil
  self.condition_item2 = nil
  self.alliance_reward_item = nil
  self.scroll_view = nil
  self.content_countdown = nil
  self.coutndown = nil
  self.btn_reward = nil
  self.red_point = nil
  self.bottom = nil
  self.join_alliance = nil
  self.dyamic_root = nil
  self.topEightReq = nil
  self.topEightCom = nil
  self.p_trans_condition_group = nil
  self.p_condition_group_template = nil
  self.p_btn_condition_fold = nil
  self.condition_bg = nil
  self.img_condition_fold = nil
  base.OnDestroy(self)
end

function LWS6AllianceReward:OnEnable()
  base.OnEnable(self)
end

function LWS6AllianceReward:OnDisable()
  base.OnDisable(self)
end

function LWS6AllianceReward:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonAllianceRewardInfoUpdate, self.RefreshCurIndex)
  self:AddUIListener(EventId.LWSeasonAllianceRewardProgressUpdate, self.RefreshCurIndexCondition)
  self:AddUIListener(EventId.LWSeasonAllianceRewardCountUpdate, self.RefreshCurIndex)
  self:AddUIListener(EventId.AllianceBaseDataUpdated, self.AllianceBaseDataUpdate)
end

function LWS6AllianceReward:OnRemoveListener()
  self:RemoveUIListener(EventId.LWSeasonAllianceRewardInfoUpdate, self.RefreshCurIndex)
  self:RemoveUIListener(EventId.LWSeasonAllianceRewardProgressUpdate, self.RefreshCurIndexCondition)
  self:RemoveUIListener(EventId.LWSeasonAllianceRewardCountUpdate, self.RefreshCurIndex)
  self:RemoveUIListener(EventId.AllianceBaseDataUpdated, self.AllianceBaseDataUpdate)
  base.OnRemoveListener(self)
end

function LWS6AllianceReward:SetData()
  self:InitUi()
end

function LWS6AllianceReward:InitUi()
  local allianceFlag = LuaEntry.Player:IsInAlliance()
  self.join_alliance:SetActive(not allianceFlag)
  self.endTime = DataCenter.SeasonDataManager:GetSeasonSettleTime()
  local now = UITimeManager:GetInstance():GetServerTime()
  self.btn_reward:SetActive(allianceFlag and not SeasonUtil.IsInSeasonPrepareMode() and now > self.endTime)
  self.des_btn:SetActive(true)
  local count = DataCenter.SeasonRewardDataManager:GetAllianceRewardTierCount()
  self.topType = TopType.None
  if 8 <= count then
    self.topType = TopType.New8
    if self.topEightCom ~= nil then
      self.topEightCom:SetActive(true)
    end
    self:InitTop()
  end
  self.allianceRewardState = DataCenter.SeasonRewardDataManager:CheckAllianceRewardData() == 1
  if self.topEightCom ~= nil then
    self.topEightCom:SetActive(true)
  end
  self.selectIndex = nil
  local curIndex = self:RefreshTierBg()
  self:SelectTitle(curIndex, true)
  self:RefreshBtnRed()
  self:Update1000MS()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.bottom.rectTransform)
end

function LWS6AllianceReward:InitSwitchState()
end

function LWS6AllianceReward:InitTop()
  local prefabPath = SeasonRewardTopEightPrefab
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
      item.transform:Set_anchoredPosition(0, 0, 0)
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

function LWS6AllianceReward:RefreshTierBg()
  local curIndex = DataCenter.SeasonRewardDataManager:GenerateAllianceRewardTier()
  self.rewardTier = curIndex
  if self.topEightCom then
    self.topEightCom:RefreshTierBg(curIndex)
  end
  local count = DataCenter.SeasonRewardDataManager:GetAllianceRewardTierCount()
  if curIndex < 1 or curIndex > count then
    curIndex = 1
  end
  if self.rewardTier == 0 then
    curIndex = 1
  end
  return curIndex
end

function LWS6AllianceReward:SelectTitle(index, callNewLogic)
  if index and self.selectIndex ~= index then
    if self.allianceRewardState then
      self.selectIndex = index
    else
      self.selectIndex = nil
    end
    if self.topEightCom then
      self.topEightCom:SelectTitle(index)
    end
    self:UpdateTaskInfo(index)
    self:UpdateReward(index)
  end
end

function LWS6AllianceReward:RefreshBtnRed()
  local redFlag = SeasonRedPointUtils.SeasonAllianceRewardDistributeBtnRedState()
  self.red_point:SetActive(redFlag)
  if self.topEightCom then
    self.topEightCom:RefreshBtnRed(self.rewardTier, redFlag)
  end
end

function LWS6AllianceReward:DistributeReward()
  local flag, rewardTier = DataCenter.SeasonRewardDataManager:CheckDistributeRewardTimeAndTier(true)
  if flag then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonAwards, rewardTier)
  end
end

function LWS6AllianceReward:JoinAlliance()
  GoToUtil.CloseAllWindows()
  local params = {guide = false}
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, params)
end

function LWS6AllianceReward:FoldTask(expand)
  self.condition_bg:SetActive(expand)
  self.p_trans_condition_group:SetActive(expand)
  local img = expand and self.ImgExpand or self.ImgCollapse
  self.img_condition_fold:LoadSpriteAsync(img)
end

function LWS6AllianceReward:UpdateTaskInfo(index)
  self.p_trans_condition_group:RemoveComponents(group_script_path)
  self.goItemTemplate:GameObjectRecycleAll()
  if SeasonUtil.IsInSeasonPrepareMode() then
    self.condition_root:SetActive(false)
    self.condition_tips:SetActive(false)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.bottom.rectTransform)
    return
  end
  self:FoldTask(true)
  self.condition_root:SetActive(true)
  self.condition_tips:SetActive(false)
  local conditionGroups = DataCenter.SeasonRewardDataManager:GetAllianceRewardConditionData(index)
  if conditionGroups ~= nil then
    for _, group in pairs(conditionGroups) do
      local go = self.goItemTemplate:GameObjectSpawn(self.p_trans_condition_group.transform)
      go.gameObject:SetActive(true)
      go.transform:Set_localScale(1, 1, 1)
      go.name = "group_" .. NameCount
      NameCount = NameCount + 1
      local cell = self.p_trans_condition_group:AddComponent(group_script_path, go.name)
      local groupData = {}
      groupData.GroupData = group
      cell:ReInit(groupData)
    end
  end
  local configId = DataCenter.SeasonRewardDataManager:GetAllianceRewardConfigData(index)
  if configId ~= nil then
    local cell = LocalController:instance():getLine(TableName.LW_Season_Alliance_Reward, configId)
    if cell ~= nil then
      self.text_task_title:SetLocalText(cell.reward_condition_title)
    end
  end
  self:FoldTask(self.IsTaskExpand)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.p_trans_condition_group.rectTransform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.condition_root.rectTransform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.bottom.rectTransform)
end

function LWS6AllianceReward:UpdateReward(index)
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

function LWS6AllianceReward:OnRankItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scroll_view:AddComponent(LWS6AllianceRewardItem, itemObj)
  if cellItem ~= nil then
    cellItem:SetData(self.reward[index], self)
  end
end

function LWS6AllianceReward:OnRankItemMoveOut(itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, LWS6AllianceRewardItem)
end

function LWS6AllianceReward:ClearScroll()
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(LWS6AllianceRewardItem)
end

function LWS6AllianceReward:Update1000MS()
  if self.endTime then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.endTime - curTime
    if 0 < remainTime then
      local des = Localization:GetString("season_reward_ui_007") .. "<color=#ffcd87>" .. " " .. UITimeManager:GetInstance():MilliSecondToFmtString(remainTime) .. "</color>"
      self.coutndown:SetText(des)
      self.content_countdown:SetActive(true)
    else
      self.coutndown:SetLocalText("season_pre_start_desc01")
      self.endTime = nil
      self.content_countdown:SetActive(SeasonUtil.IsInSeasonPrepareMode())
    end
  end
end

function LWS6AllianceReward:RefreshCurIndex()
  if self.topType == TopType.None then
    local count = DataCenter.SeasonRewardDataManager:GetAllianceRewardTierCount()
    if 8 <= count then
      self.topType = TopType.New8
      if self.topEightCom ~= nil then
        self.topEightCom:SetActive(true)
      end
      self:InitTop()
    end
  end
  local curIndex = self:RefreshTierBg()
  self.allianceRewardState = true
  local index = self.selectIndex and self.selectIndex or curIndex
  self.selectIndex = nil
  self:SelectTitle(index, true)
  self:RefreshBtnRed()
end

function LWS6AllianceReward:RefreshCurIndexCondition()
  if self.selectIndex then
    self:UpdateTaskInfo(self.selectIndex)
  end
end

function LWS6AllianceReward:TitleClickCallback(index)
  self:SelectTitle(index, true)
end

function LWS6AllianceReward:AllianceBaseDataUpdate()
  self.endTime = DataCenter.SeasonDataManager:GetSeasonSettleTime()
  local now = UITimeManager:GetInstance():GetServerTime()
  local allianceFlag = LuaEntry.Player:IsInAlliance()
  self.join_alliance:SetActive(not allianceFlag)
  self.btn_reward:SetActive(allianceFlag and not SeasonUtil.IsInSeasonPrepareMode() and now > self.endTime)
  self.des_btn:SetActive(allianceFlag and not SeasonUtil.IsInSeasonPrepareMode() and now > self.endTime)
end

function LWS6AllianceReward:OnFoldClick()
  self.IsTaskExpand = not self.IsTaskExpand
  self:FoldTask(self.IsTaskExpand)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.p_trans_condition_group.rectTransform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.condition_root.rectTransform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.bottom.rectTransform)
  local count = self.scroll_view:GetTotalCount()
  if 0 < count then
    self.scroll_view:RefillCells()
  end
end

return LWS6AllianceReward
