local UIPVEAdventure = BaseClass("UIPVEAdventure", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIPVEAdventureBuffItem = require("UI.UIPVE.UIPVEAdventure.Component.UIPVEAdventureBuffItem")
local title_path = "SafeArea/Title"
local reset_desc_path = "SafeArea/ResetDesc"
local state_desc_path = "SafeArea/StateDesc"
local back_btn_path = "SafeArea/Back"
local info_path = "SafeArea/Info"
local restart_btn_path = "SafeArea/Restart"
local restart_text_path = "SafeArea/Restart/RestartText"
local record_btn_path = "SafeArea/BtnList/Record"
local record_text_path = "SafeArea/BtnList/Record/RecordText"
local raid_btn_path = "SafeArea/BtnList/Raid"
local raid_text_path = "SafeArea/BtnList/Raid/RaidText"
local shop_btn_path = "SafeArea/BtnList/Shop"
local shop_text_path = "SafeArea/BtnList/Shop/ShopText"
local buff_go_path = "SafeArea/Buff"
local buff_text_path = "SafeArea/Buff/BuffText"
local buff_info_btn_path = "SafeArea/Buff/BuffInfo"
local buff_info_text_path = "SafeArea/Buff/BuffInfo/BuffInfoText"
local buff_scroll_path = "SafeArea/Buff/BuffScroll"
local reward_scroll_path = "SafeArea/RewardScroll"
local reward_desc_path = "SafeArea/RewardScroll/RewardDesc"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ClearBuffScroll()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.title_text = self:AddComponent(UIText, title_path)
  self.reset_desc_text = self:AddComponent(UIText, reset_desc_path)
  self.state_desc_text = self:AddComponent(UIText, state_desc_path)
  self.back_btn = self:AddComponent(UIButton, back_btn_path)
  self.back_btn:SetOnClick(function()
    self:OnBackClick()
  end)
  self.info_btn = self:AddComponent(UIButton, info_path)
  self.info_btn:SetOnClick(function()
    self:OnInfoClick()
  end)
  self.restart_btn = self:AddComponent(UIButton, restart_btn_path)
  self.restart_btn:SetOnClick(function()
    self:OnRestartClick()
  end)
  self.restart_text = self:AddComponent(UIText, restart_text_path)
  self.restart_text:SetLocalText(150116)
  self.record_btn = self:AddComponent(UIButton, record_btn_path)
  self.record_btn:SetOnClick(function()
    self:OnRecordClick()
  end)
  self.record_text = self:AddComponent(UIText, record_text_path)
  self.record_text:SetLocalText(302252)
  self.raid_btn = self:AddComponent(UIButton, raid_btn_path)
  self.raid_btn:SetOnClick(function()
    self:OnRaidClick()
  end)
  self.raid_text = self:AddComponent(UIText, raid_text_path)
  self.raid_text:SetLocalText(302253)
  self.shop_btn = self:AddComponent(UIButton, shop_btn_path)
  self.shop_btn:SetOnClick(function()
    self:OnShopClick()
  end)
  self.shop_btn:SetActive(LuaEntry.DataConfig:CheckSwitch("APS_shop_explorer"))
  self.shop_text = self:AddComponent(UIText, shop_text_path)
  self.shop_text:SetLocalText(104241)
  self.buff_go = self:AddComponent(UIBaseContainer, buff_go_path)
  self.buff_text = self:AddComponent(UIText, buff_text_path)
  self.buff_text:SetLocalText(302251)
  self.buff_info_btn = self:AddComponent(UIButton, buff_info_btn_path)
  self.buff_info_btn:SetOnClick(function()
    self:OnBuffInfoClick()
  end)
  self.buff_info_text = self:AddComponent(UIText, buff_info_text_path)
  self.buff_info_text:SetLocalText(302274)
  self.buff_scroll = self:AddComponent(UIScrollView, buff_scroll_path)
  self.buff_scroll:SetOnItemMoveIn(function(itemObj, index)
    self:OnBuffItemMoveIn(itemObj, index)
  end)
  self.buff_scroll:SetOnItemMoveOut(function(itemObj, index)
    self:OnBuffItemMoveOut(itemObj, index)
  end)
  self.reward_scroll = self:AddComponent(UIScrollView, reward_scroll_path)
  self.reward_scroll:SetOnItemMoveIn(function(itemObj, index)
    self:OnRewardItemMoveIn(itemObj, index)
  end)
  self.reward_scroll:SetOnItemMoveOut(function(itemObj, index)
    self:OnRewardItemMoveOut(itemObj, index)
  end)
  self.reward_desc_text = self:AddComponent(UIText, reward_desc_path)
  self.reward_desc_text:SetLocalText(302298)
end

local function ComponentDestroy(self)
  self.title_text = nil
  self.reset_desc_text = nil
  self.state_desc_text = nil
  self.back_btn = nil
  self.restart_btn = nil
  self.restart_text = nil
  self.record_btn = nil
  self.record_text = nil
  self.raid_btn = nil
  self.raid_text = nil
  self.buff_go = nil
  self.buff_text = nil
  self.buff_info_btn = nil
  self.buff_scroll = nil
  self.reward_scroll = nil
  self.reward_desc_text = nil
end

local function DataDefine(self)
  self.buffDataList = {}
  self.buffItemList = {}
  self.rewardList = {}
  self.rewardItemList = {}
  self.rewardTimer = nil
end

local function DataDestroy(self)
  self.buffDataList = nil
  self.buffItemList = nil
  self.rewardList = nil
  self.rewardItemList = nil
  if self.rewardTimer ~= nil then
    self.rewardTimer:Stop()
    self.rewardTimer = nil
  end
end

local function OnEnable(self)
  base.OnEnable(self)
  self:ReInit()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.AdventureInfoUpdate, self.OnAdventureInfoUpdate)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.AdventureInfoUpdate, self.OnAdventureInfoUpdate)
  base.OnRemoveListener(self)
end

local function ReInit(self)
  local state = DataCenter.AdventureManager:GetAdventureState()
  if state == AdventureState.Ready then
    self.state_desc_text:SetText("Ready")
  elseif state == AdventureState.Playing then
    self.state_desc_text:SetText("Playing")
  elseif state == AdventureState.Won then
    self.state_desc_text:SetText("Won")
  elseif state == AdventureState.Lost then
    self.state_desc_text:SetText("Lost")
  end
  local advInfo = DataCenter.AdventureManager:GetAdventureInfo()
  self.title_text:SetLocalText(302248, math.min(DataCenter.AdventureManager.finalLevel, advInfo.nowLevel))
  local resetTime = DataCenter.AdventureManager:GetTodayRestResetTime()
  self.reset_desc_text:SetLocalText(302250, resetTime)
  self:RefreshBuff()
  self:RefreshReward()
end

local function RefreshBuff(self)
  local buffList = DataCenter.AdventureManager:GetBuffList()
  local buffDict = {}
  local buffType = {}
  for _, id in ipairs(buffList) do
    local line = LocalController:instance():getLine(TableName.BattleBuff, id)
    if line ~= nil then
      local strs = string.split(line:getValue("buffId"), "|")
      local localType = tonumber(line:getValue("LocalType")) or 0
      for _, str in ipairs(strs) do
        local spls = string.split(str, ";")
        if #spls == 2 then
          local buff = tonumber(spls[1])
          local val = tonumber(spls[2])
          buffDict[buff] = (buffDict[buff] or 0) + val
          buffType[buff] = localType
        end
      end
    end
  end
  self.buffDataList = {}
  for buff, val in pairs(buffDict) do
    local data = {}
    data.buff = buff
    data.val = val
    data.localType = buffType[buff]
    table.insert(self.buffDataList, data)
  end
  table.sort(self.buffDataList, function(a, b)
    return a.buff < b.buff
  end)
  if not table.IsNullOrEmpty(self.buffItemList) then
    self:ClearBuffScroll()
  end
  if 0 < #self.buffDataList then
    self.buff_go:SetActive(true)
    self.buff_scroll:SetTotalCount(#self.buffDataList)
    self.buff_scroll:RefillCells()
    self.buff_scroll:ScrollToCell(1, 500)
  else
    self.buff_go:SetActive(false)
  end
  DataCenter.BattleLevel:SetBuffEffectDict(buffDict)
end

local function RefreshRewardList(self, immediate)
  local function RefreshInternal()
    if #self.rewardList > 0 then
      self.reward_scroll:SetActive(true)
      
      self.reward_scroll:SetTotalCount(#self.rewardList)
      self.reward_scroll:RefillCells()
    else
      self.reward_scroll:SetActive(false)
    end
  end
  
  if immediate then
    self.rewardList = DataCenter.AdventureManager.totalRewardList
    RefreshInternal()
  else
    local list = DeepCopy(DataCenter.AdventureManager.totalRewardList)
    for _, v1 in ipairs(list) do
      for _, v2 in ipairs(DataCenter.AdventureManager.flyRewardList) do
        if v1.rewardType == v2.rewardType and v1.itemId == v2.itemId then
          v1.count = v1.count - v2.count
          if v1.count <= 0 then
            v1.count = ""
          end
        end
      end
    end
    self.rewardList = list
    RefreshInternal()
    if self.rewardTimer ~= nil then
      self.rewardTimer:Stop()
    end
    self.rewardTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.rewardList = DataCenter.AdventureManager.totalRewardList
      RefreshInternal()
    end, 2.2)
  end
end

local function RefreshReward(self)
  if not DataCenter.AdventureManager.canFlyReward then
    local advInfo = DataCenter.AdventureManager:GetAdventureInfo()
    if self.rewardTimer == nil and table.IsNullOrEmpty(advInfo.raidReward) then
      self:RefreshRewardList(true)
    end
    return
  end
  DataCenter.AdventureManager.canFlyReward = false
  self:RefreshRewardList(false)
  TimerManager:GetInstance():DelayInvoke(function()
    local flyRewardList = DataCenter.AdventureManager.flyRewardList
    for _, reward in ipairs(flyRewardList) do
      local destPos = self:GetRewardPos(reward)
      if destPos ~= nil then
        local srcPos = Vector2.New(Screen.width / 2, Screen.height / 2)
        local icon = DataCenter.RewardManager:GetPicByType(reward.rewardType, reward.itemId)
        UIUtil.DoFlyCustom(icon, nil, 1, srcPos, destPos)
      end
    end
    DataCenter.AdventureManager.flyRewardList = {}
  end, 0.2)
end

local function GetRewardPos(self, reward)
  for _, item in pairs(self.rewardItemList) do
    if item ~= nil and item.param.rewardType == reward.rewardType and item.param.itemId == reward.itemId then
      return item:GetPosition()
    end
  end
  return nil
end

local function OnBuffItemMoveIn(self, itemObj, index)
  local data = self.buffDataList[index]
  itemObj.name = tostring(data.buff)
  local item = self.buff_scroll:AddComponent(UIPVEAdventureBuffItem, itemObj)
  item:SetData(data)
  self.buffItemList[index] = item
end

local function OnBuffItemMoveOut(self, itemObj, index)
  self.buff_scroll:RemoveComponent(itemObj.name, UIPVEAdventureBuffItem)
  self.buffItemList[index] = nil
end

local function ClearBuffScroll(self)
  self.buffItemList = {}
  self.buff_scroll:ClearCells()
  self.buff_scroll:RemoveComponents(UIPVEAdventureBuffItem)
end

local function OnRewardItemMoveIn(self, itemObj, index)
  local reward = self.rewardList[index]
  itemObj.name = tostring(index)
  local item = self.reward_scroll:AddComponent(UICommonResItem, itemObj)
  item:ReInit(reward)
  self.rewardItemList[index] = item
end

local function OnRewardItemMoveOut(self, itemObj, index)
  self.reward_scroll:RemoveComponent(itemObj.name, UICommonResItem)
  self.rewardItemList[index] = nil
end

local function ClearRewardScroll(self)
  self.rewardItemList = {}
  self.reward_scroll:ClearCells()
  self.reward_scroll:RemoveComponents(UICommonResItem)
end

local function OnBackClick(self)
  local tip = Localization:GetString("400001") .. "\n" .. Localization:GetString("302297")
  UIUtil.ShowMessage(tip, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
    DataCenter.AdventureManager.totalRewardList = {}
    DataCenter.BattleLevel:Exit()
  end)
end

local function OnInfoClick(self)
  UIUtil.ShowIntro(Localization:GetString("302246"), Localization:GetString("100239"), Localization:GetString("302272"))
end

local function OnRestartClick(self)
  local resetTime = DataCenter.AdventureManager:GetTodayRestResetTime()
  if 0 < resetTime then
    UIUtil.ShowMessage(Localization:GetString("302255"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      DataCenter.AdventureManager:SendReset()
    end)
  else
    UIUtil.ShowTipsId(302285)
  end
end

local function OnRecordClick(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPVEAdventureRecord)
end

local function OnRaidClick(self)
  local raidState = DataCenter.AdventureManager:GetRaidState()
  if raidState == AdventureRaidState.Ready then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPVEAdventureRaid)
  elseif raidState == AdventureRaidState.NeedLevel then
    UIUtil.ShowTipsId(302273)
  elseif raidState == AdventureRaidState.Started then
    UIUtil.ShowTipsId(302282)
  elseif raidState == AdventureRaidState.LevelMaxed then
    UIUtil.ShowTipsId(302288)
  end
end

local function OnShopClick(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonShop)
end

local function OnBuffInfoClick(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPVEAdventureBuffDetail)
end

local function OnAdventureInfoUpdate(self)
  self:ReInit()
end

UIPVEAdventure.OnCreate = OnCreate
UIPVEAdventure.OnDestroy = OnDestroy
UIPVEAdventure.OnEnable = OnEnable
UIPVEAdventure.OnDisable = OnDisable
UIPVEAdventure.ComponentDefine = ComponentDefine
UIPVEAdventure.ComponentDestroy = ComponentDestroy
UIPVEAdventure.DataDefine = DataDefine
UIPVEAdventure.DataDestroy = DataDestroy
UIPVEAdventure.OnAddListener = OnAddListener
UIPVEAdventure.OnRemoveListener = OnRemoveListener
UIPVEAdventure.ReInit = ReInit
UIPVEAdventure.RefreshBuff = RefreshBuff
UIPVEAdventure.RefreshRewardList = RefreshRewardList
UIPVEAdventure.RefreshReward = RefreshReward
UIPVEAdventure.GetRewardPos = GetRewardPos
UIPVEAdventure.OnBuffItemMoveIn = OnBuffItemMoveIn
UIPVEAdventure.OnBuffItemMoveOut = OnBuffItemMoveOut
UIPVEAdventure.ClearBuffScroll = ClearBuffScroll
UIPVEAdventure.OnRewardItemMoveIn = OnRewardItemMoveIn
UIPVEAdventure.OnRewardItemMoveOut = OnRewardItemMoveOut
UIPVEAdventure.ClearRewardScroll = ClearRewardScroll
UIPVEAdventure.OnBackClick = OnBackClick
UIPVEAdventure.OnInfoClick = OnInfoClick
UIPVEAdventure.OnRestartClick = OnRestartClick
UIPVEAdventure.OnRecordClick = OnRecordClick
UIPVEAdventure.OnRaidClick = OnRaidClick
UIPVEAdventure.OnShopClick = OnShopClick
UIPVEAdventure.OnBuffInfoClick = OnBuffInfoClick
UIPVEAdventure.OnAdventureInfoUpdate = OnAdventureInfoUpdate
return UIPVEAdventure
