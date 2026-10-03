local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local SeasonSynthesis = BaseClass("SeasonSynthesis", base)
local Localization = CS.GameEntry.Localization
local SeasonSynthesisItem = require("UI.LWSeason.LWSeasonMain.Component.SeasonSynthesis.SeasonSynthesisItem")
local title_path = "BgTop/title"
local info_btn_path = "BgTop/InfoBtn"
local remain_time_path = "BgTop/TimeBg/remainTime"
local btn_active_path = "BtnActive"
local btn_active_text_path = "BtnActive/BtnActiveText"
local btn_active_text2_path = "BtnActive/BtnActiveText2"
local itemPosTable = {
  {
    x = -218,
    y = 184,
    z = 0
  },
  {
    x = -319,
    y = 0,
    z = 0
  },
  {
    x = -218,
    y = -182,
    z = 0
  },
  {
    x = 218,
    y = 184,
    z = 0
  },
  {
    x = 319,
    y = 0,
    z = 0
  },
  {
    x = 218,
    y = -182,
    z = 0
  }
}

function SeasonSynthesis:OnCreate()
  base.OnCreate(self)
  self.title = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.remain_time = self:AddComponent(UITextMeshProUGUIEx, remain_time_path)
  self.btn_active = self:AddComponent(UIButton, btn_active_path)
  self.btn_active_text = self:AddComponent(UITextMeshProUGUIEx, btn_active_text_path)
  self.btn_active_text2 = self:AddComponent(UITextMeshProUGUIEx, btn_active_text2_path)
  self.swap_btn = self:AddComponent(UIButton, "BgTop/swapBtn")
  self.swap_btn_text = self:AddComponent(UITextMeshProUGUIEx, "BgTop/swapBtn/swapImg/swapBtnText")
  self.infoText1 = self:AddComponent(UITextMeshProUGUIEx, "InfoText1")
  self.infoText2 = self:AddComponent(UITextMeshProUGUIEx, "InfoText2")
  self.info_btn:SetOnClick(BindCallback(self, self.OnInfoClick))
  self.swap_btn:SetOnClick(BindCallback(self, self.OnSwapClick))
  self.btn_active:SetSafeClickMode(true)
  self.btn_active:SetOnClick(BindCallback(self, self.OnGoToClick))
  self.btn_active_text:SetLocalText("season_activity1000014_desc009")
  self.infoText1:SetLocalText("season_activity1000014_desc007")
  self.swap_btn_text:SetLocalText("season_activity1000014_desc016")
  self.itemContent = self:AddComponent(UIButton, "BgFull/ItemContent")
  self.center_image = self:AddComponent(UIButton, "BgFull/CenterImage")
  self.center_image:SetOnClick(BindCallback(self, self.OnRateClick))
  self.itemTemplateGO = self.transform:Find("ItemTemplate").gameObject
  self.itemTemplateGO:GameObjectCreatePool()
  self.items = {}
  for i = 1, #itemPosTable do
    local goItem = self.itemTemplateGO:GameObjectSpawn(self.itemContent.transform)
    goItem.name = "item_" .. i
    local item = self.itemContent:AddComponent(SeasonSynthesisItem, goItem.name)
    item:SetItemCount(0)
    item:SetLocalPosition(itemPosTable[i])
    self.items[i] = item
  end
  self.itemTemplateGO:SetActive(false)
  self.infoText2:SetActive(true)
  self.hasCountdown = true
  self.bg_full = self:AddComponent(UIBaseContainer, "BgFull")
  self.bg_full_Animator = self.bg_full.gameObject:GetComponent(typeof(CS.UnityEngine.Animator))
  self.toggle = self:AddComponent(UIToggle, "ToggleText/SkipToggle")
  self.toggle:SetOnValueChanged(function(tf)
    self:ToggleControlBorS(tf)
  end)
  self._jumpAnim_txt = self:AddComponent(UIText, "ToggleText")
  self._jumpAnim_txt:SetLocalText(372228)
  local state = Setting:GetBool(SettingKeys.SEASON_SYNTHESIS_JUMP_ANIM .. LuaEntry.Player.uid, false)
  self.toggle:SetIsOn(state)
end

function SeasonSynthesis:OnDestroy()
  self.itemContent:RemoveComponents(SeasonSynthesisItem)
  self.itemTemplateGO:GameObjectRecycleAll()
  if self.asset1 ~= nil then
    self.asset1:Destroy()
    self.asset1 = nil
  end
  if self.asset2 ~= nil then
    self.asset2:Destroy()
    self.asset2 = nil
  end
  base.OnDestroy(self)
end

function SeasonSynthesis:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonActivitySynthesisUpdate, self.RefreshViewByEvent)
  self:AddUIListener(EventId.RefreshItems, self.RefreshView)
end

function SeasonSynthesis:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonActivitySynthesisUpdate, self.RefreshViewByEvent)
  self:RemoveUIListener(EventId.RefreshItems, self.RefreshView)
  base.OnRemoveListener(self)
end

function SeasonSynthesis:SetData(activityId)
  base.SetData(self, activityId)
  local data = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if data == nil then
    return
  end
  self.activityData = data
  self.title:SetLocalText(data.name)
  self.fightStartTime = data.startTime
  self.fightEndTime = data.endTime
  local para3Split = string.split(data.para_3, "|")
  if #para3Split ~= #itemPosTable then
    return
  end
  for i = 1, #para3Split do
    local itemID = tonumber(para3Split[i])
    self.items[i].itemID = itemID
  end
  self:RefreshView()
end

function SeasonSynthesis:RefreshViewByEvent(t)
  local state = Setting:GetBool(SettingKeys.SEASON_SYNTHESIS_JUMP_ANIM .. LuaEntry.Player.uid, false)
  local rare = 1
  if t.id ~= nil then
    rare = GetTableData(TableName.GeneSynthesis, t.id, "merge_level", 1)
  end
  if 2 <= rare and rare <= 5 and not state then
    rare = rare - 1
    local path1 = "Assets/_Art_LastWar/Effect/Prefab/UI/LWseason/Eff_ui_LWSeasonSynthesis2_" .. tostring(rare) .. ".prefab"
    local path2 = "Assets/_Art_LastWar/Effect/Prefab/UI/LWseason/Eff_ui_LWSeasonSynthesis3_" .. tostring(rare) .. ".prefab"
    if self.asset1 ~= nil then
      self.asset1:Destroy()
      self.asset1 = nil
    end
    if self.asset2 ~= nil then
      self.asset2:Destroy()
      self.asset2 = nil
    end
    self.asset1 = CS.GameEntry.Resource:InstantiateAsync(path1)
    self.asset1:completed("+", function(req)
      local _go = req.gameObject
      local transform = _go.transform
      transform:SetParent(self.bg_full.transform)
      transform:Set_localPosition(0, 0, 0)
      transform:Set_localEulerAngles(0, 0, 0)
      transform:Set_localScale(1, 1, 1)
    end)
    self.asset2 = CS.GameEntry.Resource:InstantiateAsync(path2)
    self.asset2:completed("+", function(req)
      local _go = req.gameObject
      local transform = _go.transform
      transform:SetParent(self.bg_full.transform)
      transform:Set_localPosition(0, 0, 0)
      transform:Set_localEulerAngles(0, 0, 0)
      transform:Set_localScale(1, 1, 1)
    end)
    TimerManager:GetInstance():DelayInvoke(function(t)
      if t.reward ~= nil then
        DataCenter.RewardManager:AddRewards(t.reward)
        DataCenter.RewardManager:ShowCommonReward(t)
      end
    end, 2.3, t)
    self.bg_full_Animator:Play("Eff_ui_lwseasonsynthesis")
  elseif t.reward ~= nil then
    DataCenter.RewardManager:AddRewards(t.reward)
    DataCenter.RewardManager:ShowCommonReward(t)
  end
  self:RefreshView()
end

function SeasonSynthesis:RefreshView(t)
  for i = 1, #self.items do
    local itemData = DataCenter.ItemData:GetItemById(self.items[i].itemID)
    if itemData ~= nil then
      self.items[i]:SetItemCount(itemData.count)
    else
      self.items[i]:SetItemCount(0)
    end
  end
  self:Update1000MS()
end

function SeasonSynthesis:Update1000MS()
  if self.activityData ~= nil then
    local deltaTime = 0
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime < self.fightStartTime then
      deltaTime = self.fightStartTime - curTime
    elseif curTime < self.fightEndTime then
      deltaTime = self.fightEndTime - curTime
    end
    if 0 < deltaTime then
      local showTime = UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime)
      self.remain_time:SetText(showTime)
    else
      self.remain_time:SetText("00:00:00")
    end
    local remainTimes, maxCount, recoverInterval, remainRecover = SeasonUtil.SynthesisRemainCount(self.activityData)
    self.btn_active_text2:SetText(string.format("%d/%d", remainTimes, maxCount))
    if maxCount <= remainTimes then
      if self.hasCountdown == true then
        self.infoText2:SetActive(false)
        self.hasCountdown = false
      end
    else
      if self.hasCountdown == false then
        self.infoText2:SetActive(true)
        self.hasCountdown = true
      end
      local showTime = UITimeManager:GetInstance():SecondToFmtStringWithoutDay(recoverInterval - remainRecover)
      self.infoText2:SetLocalText("season_activity1000014_desc010", showTime)
    end
  end
end

function SeasonSynthesis:OnInfoClick()
  local param = {}
  param.activityRulesStr = Localization:GetString(GetTableData(TableName.Activity, self.activityId, "desc"))
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
end

function SeasonSynthesis:OnSwapClick()
  if CrossServerUtil:IsInOtherServer() then
    UIUtil.ShowTipsId("forbidden_exchange_tips")
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISplinterExchange, {anim = true}, SplinterExchangeType.SeasonSynthesiss.Id, 1)
  end
end

function SeasonSynthesis:OnGoToClick()
  local haveAll = true
  for i = 1, #self.items do
    if self.items[i].itemCount == 0 then
      haveAll = false
      break
    end
  end
  if haveAll == false then
    UIUtil.ShowTipsId("season_tips232")
  else
    SFSNetwork.SendMessage(MsgDefines.LWSeasonActivitySynthesis)
  end
end

function SeasonSynthesis:OnRateClick()
  local extraData = DataCenter.ActivityListDataManager:GetExtraData(SEASON_ACTIVITY_SYNTHESIS_REWARD_RATE)
  if extraData == nil then
    SFSNetwork.SendMessage(MsgDefines.LWSeasonActivitySynthesisRewardRate)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISeasonSynthesisRateTip)
  end
end

function SeasonSynthesis:ToggleControlBorS(isJumpPlay)
  Setting:SetBool(SettingKeys.SEASON_SYNTHESIS_JUMP_ANIM .. LuaEntry.Player.uid, isJumpPlay)
end

return SeasonSynthesis
