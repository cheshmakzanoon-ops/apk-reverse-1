local base = UIBaseView
local UIAttackCityS0SuccessView = BaseClass("UIAttackCityS0SuccessView", base)
local StarItem = require("UI.LWCityAttackS0.SiegeSuccess.Component.StarItem")
local Localization = CS.GameEntry.Localization
local panel_path = "Close"
local city_page_path = "cityPage"
local title1_path = "cityPage/title1"
local icon_path = "cityPage/icon"
local city_name1_path = "cityPage/cityName1"
local flag_path = "cityPage/flag"
local alliance_name_path = "cityPage/allianceName"
local alliance_desc_path = "cityPage/allianceDesc"
local reward_page_path = "rewardPage"
local title2_path = "rewardPage/title2"
local city_name2_path = "rewardPage/cityName2"
local content_path = "rewardPage/StarScroll/Viewport/StarContent"
local reward_node_path = "rewardPage/rewardNode"
local free_reward_text_path = "rewardPage/rewardNode/FreeRewardText"
local join_reward_text_path = "rewardPage/rewardNode/JoinRewardText"
local claim_btn_path = "rewardPage/rewardNode/ClaimBtn"
local claim_btn_text_path = "rewardPage/rewardNode/ClaimBtn/ClaimBtnText"
local free_content_path = "rewardPage/rewardNode/FreeReward/Viewport/FreeContent"
local join_content_path = "rewardPage/rewardNode/JoinReward/Viewport/JoinContent"
local like_btn_path = "rewardPage/LikeBtn"
local like_text_path = "rewardPage/LikeBtn/LikeText"
local reward_btn_path = "rewardPage/rewardBtn"
local star_scroll_path = "rewardPage/StarScroll"
local BidirectionalHLayoutType = typeof(CS.BidirectionalHorizontalLayoutGroup)

function UIAttackCityS0SuccessView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Init()
  self:Refresh()
end

function UIAttackCityS0SuccessView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIAttackCityS0SuccessView:ComponentDefine()
  self.panelAnimator = self:AddComponent(UIAnimator, "")
  self.close = self:AddComponent(UIButton, panel_path)
  self.close:SetOnClick(function()
    self:OnClickCloseBtn()
  end)
  self.reward_btn = self:AddComponent(UIButton, reward_btn_path)
  self.reward_btn:SetOnClick(function()
    self:OnClickClaimBtn()
  end)
  self.city_page = self:AddComponent(UIBaseContainer, city_page_path)
  self.title1 = self:AddComponent(UITextMeshProUGUIEx, title1_path)
  self.title1:SetLocalText("gogncheng_liantu_tittle1007")
  self.icon = self:AddComponent(UIImage, icon_path)
  self.city_name1 = self:AddComponent(UITextMeshProUGUIEx, city_name1_path)
  self.flag = self:AddComponent(UIImage, flag_path)
  self.alliance_name = self:AddComponent(UITextMeshProUGUIEx, alliance_name_path)
  self.alliance_desc = self:AddComponent(UITextMeshProUGUIEx, alliance_desc_path)
  self.reward_page = self:AddComponent(UIBaseContainer, reward_page_path)
  self.title2 = self:AddComponent(UITextMeshProUGUIEx, title2_path)
  self.title2:SetLocalText("city_war_battle_result_01")
  self.city_name2 = self:AddComponent(UITextMeshProUGUIEx, city_name2_path)
  self.star_content = self:AddComponent(UIBaseContainer, content_path)
  self.free_reward_text = self:AddComponent(UITextMeshProUGUIEx, free_reward_text_path)
  self.free_reward_text:SetLocalText("city_war_battle_result_03")
  self.free_content = self:AddComponent(UIBaseContainer, free_content_path)
  self.join_reward_text = self:AddComponent(UITextMeshProUGUIEx, join_reward_text_path)
  self.join_content = self:AddComponent(UIBaseContainer, join_content_path)
  self.claim_btn = self:AddComponent(UIButton, claim_btn_path)
  self.claim_btn:SetOnClick(function()
    self:OnClickClaimBtn()
  end)
  self.claim_btn_text = self:AddComponent(UITextMeshProUGUIEx, claim_btn_text_path)
  self.like_btn = self:AddComponent(UIButton, like_btn_path)
  self.like_btn:SetOnClick(function()
    self:OnClickLikeAllBtn()
  end)
  self.like_text = self:AddComponent(UITextMeshProUGUIEx, like_text_path)
  self.reward_node = self:AddComponent(UIBaseComponent, reward_node_path)
  self.star_scroll = self:AddComponent(UIScrollView, star_scroll_path)
  self.star_scroll:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.star_scroll:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.cellList = {}
  self.star_content_h_layout = self.star_content.gameObject:GetComponent(BidirectionalHLayoutType)
  self.free_content_h_layout = self.free_content.gameObject:GetComponent(BidirectionalHLayoutType)
  self.join_content_h_layout = self.join_content.gameObject:GetComponent(BidirectionalHLayoutType)
  self.freeItem = self:AddComponent(UIBaseContainer, "rewardPage/rewardNode/FreeReward/Viewport/FreeContent/UICommonResItem")
  self.freeItem.gameObject:SetActive(false)
  self.freeItemPool = self.freeItem.gameObject
  self.freeItemPool:GameObjectCreatePool()
  self.freeItems = {}
  self.joinItem = self:AddComponent(UIBaseContainer, "rewardPage/rewardNode/JoinReward/Viewport/JoinContent/UICommonResItemJoin")
  self.joinItem.gameObject:SetActive(false)
  self.joinItemPool = self.joinItem.gameObject
  self.joinItemPool:GameObjectCreatePool()
  self.joinItems = {}
end

function UIAttackCityS0SuccessView:ComponentDestroy()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  self:ClearAnimTimers()
  self.panelAnimator = nil
  self:ClearStar()
  self:ClearReward()
end

function UIAttackCityS0SuccessView:DataDefine()
  self.animTimerList = {}
  self.cityId = self:GetUserData().cityId
  self.reward = DataCenter.WorldAllianceCityDataManager:GetOccupyRewardByCityId(self.cityId)
  self.cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(self.cityId)
  if self.reward then
    DataCenter.WorldAllianceCityDataManager:RemoveFirstNewOccupy(self.cityId)
  end
  DataCenter.WorldAllianceCityDataManager:SaveOldMyCities(self.cityId)
  DataCenter.ActivityTipsManager:Enqueue(MainUITipCondition.CityWarSuccess)
end

function UIAttackCityS0SuccessView:DataDestroy()
  self.cityId = nil
  self.reward = nil
  self.cityMeta = nil
  self.freeItems = nil
  self.joinItems = nil
  self.ani1 = nil
  self.ani2 = nil
  self.rewardPageShown = nil
  self.rewardReady = nil
end

function UIAttackCityS0SuccessView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.CityRewardRefresh, self.OnCityRewardRefresh)
  self:AddUIListener(EventId.AttackCityThumbsUpRewardRefresh, self.OnCityRewardRefresh)
end

function UIAttackCityS0SuccessView:OnRemoveListener()
  self:RemoveUIListener(EventId.CityRewardRefresh, self.OnCityRewardRefresh)
  self:RemoveUIListener(EventId.AttackCityThumbsUpRewardRefresh, self.OnCityRewardRefresh)
  base.OnRemoveListener(self)
end

function UIAttackCityS0SuccessView:OnCityRewardRefresh(reward)
  if reward and reward.cityId == self.cityId then
    self:Refresh()
  end
end

function UIAttackCityS0SuccessView:Init()
  self.city_page:SetActive(true)
  self.reward_page:SetActive(false)
  self.rewardPageShown = false
  self.rewardReady = false
  if self.reward then
    self.timer = TimerManager:GetInstance():DelayInvoke(function()
      self:RefreshReward()
      self.rewardReady = true
      self.city_page:SetActive(false)
      self.reward_page:SetActive(true)
      self.rewardPageShown = true
      self:StartRewardAnimations()
      self.panelAnimator:Play("V_ui_AttackCityS0_Success_in", 0, 0)
    end, 3)
  end
end

function UIAttackCityS0SuccessView:Refresh()
  local cityName = Localization:GetString("140205", self.cityMeta.level, Localization:GetString(self.cityMeta.name))
  self.city_name1:SetText(cityName)
  self.city_name2:SetLocalText("city_war_battle_result_02", self.cityMeta.level)
  self.icon:LoadSprite(self.cityMeta:GetIconPath(false))
  local allianceBase = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  self.flag:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, tostring(allianceBase.icon)))
  self.alliance_name:SetText(UIUtil.FormatAllianceAndName(allianceBase.abbr, allianceBase.allianceName))
  local descStr = DataCenter.AllianceCityTemplateManager:GetAllianceCityBuffDescByCityId(self.cityMeta.id)
  self.alliance_desc:SetText(descStr)
  if self.rewardReady then
    self:RefreshReward()
    if self.rewardPageShown then
      self:StartRewardAnimations()
    end
  end
end

function UIAttackCityS0SuccessView:RefreshReward()
  if not self.reward then
    return
  end
  if not self.reward.firstAllianceReward then
    self.reward_node:SetActive(false)
    return
  else
    self.reward_node:SetActive(true)
  end
  if self.reward.rewardComplete then
    CS.UIGray.SetGray(self.claim_btn.transform, true, true)
    self.claim_btn_text:SetLocalText("2000502")
  else
    CS.UIGray.SetGray(self.claim_btn.transform, false, true)
    self.claim_btn_text:SetLocalText("2000501")
  end
  self.join_reward_text:SetLocalText(self.reward.firstReward and "city_war_battle_result_04" or "new_city_activity_battle_tips1051")
  local starNum = self.reward.ranks and #self.reward.ranks or 0
  self.like_btn:SetActive(false)
  if starNum <= 0 then
    self:ClearStar()
  else
    self.star_scroll:SetTotalCount(starNum)
    self.star_scroll:RefillCells()
  end
  local freeReward = DataCenter.RewardManager:ParseRewardsStr(self.cityMeta.show_alliance_reward) or {}
  local joinReward = DataCenter.RewardManager:ParseRewardsStr(self.cityMeta.show_reward) or {}
  self:ClearReward()
  self.ani1 = {}
  for i, data in ipairs(freeReward) do
    local parent = self.free_content
    local item = self.freeItems[i]
    if item == nil then
      local go = self.freeItemPool:GameObjectSpawn(parent.transform)
      go.name = "item" .. i
      local transform = go.transform
      transform:Set_sizeDelta(150, 150)
      transform:Set_localScale(1, 1, 1)
      transform:Set_pivot(0, 1)
      item = parent:AddComponent(UICommonResItem, go.name)
      self.freeItems[i] = item
    else
      item.gameObject.transform:SetParent(parent.transform)
    end
    item:SetActive(true)
    item:ReInit(data)
    item:SetRewardAlpha(0)
  end
  self.ani2 = {}
  for i, data in ipairs(joinReward) do
    local parent = self.join_content
    local item = self.joinItems[i]
    if item == nil then
      local go = self.joinItemPool:GameObjectSpawn(parent.transform)
      go.name = "join" .. i
      local transform = go.transform
      transform:Set_sizeDelta(150, 150)
      transform:Set_localScale(0.8, 0.8, 1)
      transform:Set_pivot(0, 1)
      item = parent:AddComponent(UICommonResItem, go.name)
      self.joinItems[i] = item
    else
      item.gameObject.transform:SetParent(parent.transform)
    end
    item:SetActive(true)
    item:ReInit(data)
    item:SetRewardAlpha(0)
  end
  if starNum <= 3 then
    self.star_content_h_layout.childAlignment = CS.UnityEngine.TextAnchor.UpperCenter
  else
    self.star_content_h_layout.childAlignment = CS.UnityEngine.TextAnchor.UpperLeft
  end
  if #freeReward <= 5 then
    self.free_content_h_layout.childAlignment = CS.UnityEngine.TextAnchor.UpperCenter
  else
    self.free_content_h_layout.childAlignment = CS.UnityEngine.TextAnchor.UpperLeft
  end
  if #joinReward <= 6 then
    self.join_content_h_layout.childAlignment = CS.UnityEngine.TextAnchor.UpperCenter
  else
    self.join_content_h_layout.childAlignment = CS.UnityEngine.TextAnchor.UpperLeft
  end
end

function UIAttackCityS0SuccessView:SafeDelayInvoke(delay, callback)
  local timer = TimerManager:GetInstance():DelayInvoke(callback, delay)
  table.insert(self.animTimerList, timer)
end

function UIAttackCityS0SuccessView:StartRewardAnimations()
  self:ClearAnimTimers()
  local time1 = 0.6
  local time2 = 0.7
  local delay = 0.015
  for i = 1, #self.freeItems do
    local item = self.freeItems[i]
    if item then
      item:SetRewardAlpha(0)
      self:SafeDelayInvoke(time1 + delay * i, function()
        item:SetRewardAlpha(1)
        item:PlayAnimator("V_ui_AttackCityS0_Success_ResItem_in")
      end)
    end
  end
  for i = 1, #self.joinItems do
    local item = self.joinItems[i]
    if item then
      item:SetRewardAlpha(0)
      self:SafeDelayInvoke(time2 + delay * i, function()
        item:SetRewardAlpha(1)
        item:PlayAnimator("V_ui_AttackCityS0_Success_ResItem_in")
      end)
    end
  end
end

function UIAttackCityS0SuccessView:ClearAnimTimers()
  if self.animTimerList then
    for _, timer in ipairs(self.animTimerList) do
      if timer then
        timer:Stop()
      end
    end
    self.animTimerList = {}
  end
end

function UIAttackCityS0SuccessView:ClearContent()
  self.free_content:RemoveComponents(UICommonResItem)
  self.join_content:RemoveComponents(UICommonResItem)
  self.freeItemPool:GameObjectRecycleAll()
  self.freeItems = {}
  self.joinItemPool:GameObjectRecycleAll()
  self.joinItems = {}
end

function UIAttackCityS0SuccessView:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cell = self.star_scroll:AddComponent(StarItem, itemObj)
  cell:Refresh(self.reward.ranks[index], self.cityMeta.id, index)
  self.cellList[index] = cell
end

function UIAttackCityS0SuccessView:OnItemMoveOut(itemObj, index)
  self.star_scroll:RemoveComponent(itemObj.name, StarItem)
  self.cellList[index] = nil
end

function UIAttackCityS0SuccessView:ClearStar()
  self.cellList = {}
  self.star_scroll:ClearCells()
  self.star_scroll:RemoveComponents(StarItem)
end

function UIAttackCityS0SuccessView:ClearReward()
  self:ClearContent()
  if self.rewardFreeReqs then
    for _, req in pairs(self.rewardFreeReqs) do
      req:Destroy()
    end
  end
  self.rewardFreeReqs = {}
  if self.rewardJoinReqs then
    for _, req in pairs(self.rewardJoinReqs) do
      req:Destroy()
    end
  end
  self.rewardJoinReqs = {}
end

function UIAttackCityS0SuccessView:OnClickCloseBtn()
  if not self.reward then
    self.ctrl:CloseSelf()
  end
end

function UIAttackCityS0SuccessView:OnClickLikeAllBtn()
  DataCenter.AttackCityS0DataManager:SendThumpsUpRewardMsg(self.cityId)
end

function UIAttackCityS0SuccessView:OnClickClaimBtn()
  if self.reward and self.reward.rewardComplete then
    self.ctrl:CloseSelf()
  else
    SFSNetwork.SendMessage(MsgDefines.WorldAllianceCityFirstOccupiedReward, self.cityId)
    self.ctrl:CloseSelf()
  end
end

function UIAttackCityS0SuccessView:OnClickRewardBtn()
  if self.reward then
    if self.reward:HaveFreeRewardToGet() then
      SFSNetwork.SendMessage(MsgDefines.WorldAllianceCityFirstOccupiedReward, self.cityId)
      return
    else
      for i = 1, #self.reward.ranks do
        if not self.reward.ranks[i].isThumbsUp then
          self.star_scroll:ScrollToCell(i, 1000)
          DataCenter.AttackCityS0DataManager:SendThumpsUpRewardMsg(self.cityId, self.reward.ranks[i].uuid)
          return
        end
      end
    end
  end
  self.ctrl:CloseSelf()
end

return UIAttackCityS0SuccessView
