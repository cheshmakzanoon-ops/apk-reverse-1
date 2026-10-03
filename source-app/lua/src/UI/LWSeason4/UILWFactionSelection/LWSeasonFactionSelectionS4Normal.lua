local base = UIAsyncContainer
local LWSeasonFactionSelectionS4Normal = BaseClass("LWSeasonFactionSelectionS4Normal", base)
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local LWSeasonFactionSelectionItemS4 = require("UI.LWSeason4.UILWFactionSelection.LWSeasonFactionSelectionItemS4")
local UIServerBattleZoneInfo = require("UI.UIGovernment.ServerBattleMain.Component.UIServerBattleZoneInfo")
local act_title_path = "Top/act_title"
local info_btn_path = "Top/InfoBtn"
local title_path = "Top/title"
local time_text_path = "Top/TimeBg/TimeText"
local btn_rule_path = "Top/BtnRule"
local house_path = "Content/Group1/House"
local zone_item_path = "Content/GroupOver1/ZoneItem"
local btn_add1_path = "Content/Group1/BtnAdd1"
local btn_add1_text_path = "Content/Group1/BtnAdd1/BtnAdd1Text"
local btn_add2_path = "Content/Group2/BtnAdd2"
local btn_add2_text_path = "Content/Group2/BtnAdd2/BtnAdd2Text"
local scroll_view_path = "History/ScrollView"
local content_path = "History/ScrollView/Viewport/Content"
local history_item_path = "History/ScrollView/Viewport/Content/HistoryItem"
local btn_post_card_path = "BottomBar/BtnPostCard"
local btn_post_card_text_path = "BottomBar/BtnPostCard/BtnPostCardText"
local tips_path = "BottomBar/Tips"
local group1_path = "Content/Group1"
local group2_path = "Content/Group2"
local group_over1_path = "Content/GroupOver1"
local group_over2_path = "Content/GroupOver2"
local btn_post_rank_path = "BottomBar/BtnPostRank"

function LWSeasonFactionSelectionS4Normal:OnCreate()
  base.OnCreate(self)
  self.rectTransform:Set_offsetMin(0, 0)
  self.rectTransform:Set_offsetMax(0, 0)
  self.act_title = self:AddComponent(UITextMeshProUGUIEx, act_title_path)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.title = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self.time_text = self:AddComponent(UITextMeshProUGUIEx, time_text_path)
  self.info_btn:SetActive(false)
  self.info_btn:SetOnClick(function()
    UIUtil.ShowDetail(Localization:GetString("season_s2_camp_choose_03"))
  end)
  self.btn_add1 = self:AddComponent(UIButton, btn_add1_path)
  self.btn_add1_text = self:AddComponent(UITextMeshProUGUIEx, btn_add1_text_path)
  self.btn_add1_text:SetLocalText("season_s2_camp_choose_06")
  self.btn_add1:SetOnClick(function()
    self:TryAddToGroup(1)
  end)
  self.btn_add2 = self:AddComponent(UIButton, btn_add2_path)
  self.btn_add2_text = self:AddComponent(UITextMeshProUGUIEx, btn_add2_text_path)
  self.btn_add2_text:SetLocalText("season_s2_camp_choose_06")
  self.btn_add2:SetOnClick(function()
    self:TryAddToGroup(2)
  end)
  self.group1 = self:AddComponent(UIBaseContainer, group1_path)
  self.group2 = self:AddComponent(UIBaseContainer, group2_path)
  self.group_over1 = self:AddComponent(UIBaseContainer, group_over1_path)
  self.group_over2 = self:AddComponent(UIBaseContainer, group_over2_path)
  self.house_item = self.transform:Find(house_path).gameObject
  self.house_item:GameObjectCreatePool()
  self.zone_item = self.transform:Find(zone_item_path).gameObject
  self.zone_item:GameObjectCreatePool()
  self.scroll_view = self:AddComponent(UIScrollRect, scroll_view_path)
  self.history_trigger = self:AddComponent(UIEventTrigger, scroll_view_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.history_item = self.transform:Find(history_item_path).gameObject
  self.history_item:GameObjectCreatePool()
  self.history_trigger:OnPointerDown(function(eventData)
    self.lastHistoryPos = self.scroll_view:GetVerticalNormalizedPosition()
  end)
  self.history_trigger:OnPointerClick(function()
    local nowHistoryPos = self.scroll_view:GetVerticalNormalizedPosition()
    if self.lastHistoryPos ~= nil and nowHistoryPos ~= self.lastHistoryPos and math.abs(nowHistoryPos - self.lastHistoryPos) > 0.001 then
      return
    end
    local data = DataCenter.SeasonDataManager.seasonFactionHistory
    if data == nil or data.history == nil or #data.history == 0 then
      return
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonFactionHistory)
  end)
  self.tips = self:AddComponent(UITextMeshProUGUIEx, tips_path)
  self.btn_rule = self:AddComponent(UIButton, btn_rule_path)
  self.btn_post_card = self:AddComponent(UIButton, btn_post_card_path)
  self.btn_post_card_text = self:AddComponent(UITextMeshProUGUIEx, btn_post_card_text_path)
  self.btn_post_card_text:SetLocalText("season_s2_camp_choose_14")
  self.btn_rule:SetOnClick(function()
    if self.activityData ~= nil and self.activityData.story ~= nil then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonFactionWarRule, {anim = true}, self.activityData.story)
    else
      UIUtil.ShowDetail(Localization:GetString("season_s2_camp_choose_03"))
    end
  end)
  self.tips:SetActive(false)
  self.btn_post_card:SetActive(false)
  self.btn_post_card:SetSafeClickMode(true)
  self.btn_post_card:SetOnClick(function()
    if self.group_reward_item1 and self.group_reward_item2 and self.myGroup then
      local item
      if self.myGroup == 1 then
        item = DataCenter.ItemData:GetItemById(self.group_reward_item1)
      elseif self.myGroup == 2 then
        item = DataCenter.ItemData:GetItemById(self.group_reward_item2)
      end
      if item ~= nil then
        UIUtil.ShowTipsId(110271)
      else
        SFSNetwork.SendMessage(MsgDefines.FetchSeasonFactionItems)
      end
    end
  end)
  self.btn_post_rank = self:AddComponent(UIButton, btn_post_rank_path)
  self.btn_post_rank:SetActive(false)
  self.btn_post_rank:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonRank, {anim = true}, 3)
  end)
  SFSNetwork.SendMessage(MsgDefines.GetSeasonFactionHistory, 0, 10)
end

function LWSeasonFactionSelectionS4Normal:OnDestroy()
  self.content:RemoveComponents(UITextMeshProUGUIEx)
  self.history_item:GameObjectRecycleAll()
  self.group1:RemoveComponents(LWSeasonFactionSelectionItemS4)
  self.group2:RemoveComponents(LWSeasonFactionSelectionItemS4)
  self.house_item:GameObjectRecycleAll()
  self.group_over1:RemoveComponents(UIServerBattleZoneInfo)
  self.group_over2:RemoveComponents(UIServerBattleZoneInfo)
  self.zone_item:GameObjectRecycleAll()
  base.OnDestroy(self)
end

function LWSeasonFactionSelectionS4Normal:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonFactionInfoUpdate, self.RefreshGroupData)
  self:AddUIListener(EventId.LWSeasonFactionHistory, self.OnFactionHistory)
end

function LWSeasonFactionSelectionS4Normal:OnRemoveListener()
  self:RemoveUIListener(EventId.LWSeasonFactionInfoUpdate, self.RefreshGroupData)
  self:RemoveUIListener(EventId.LWSeasonFactionHistory, self.OnFactionHistory)
  base.OnRemoveListener(self)
end

function LWSeasonFactionSelectionS4Normal:OnFactionHistory(data)
  local goItem, theText
  if data and data.pageNum == 0 and data.pageSize == 10 and 0 < table.count(data.history) then
    self.content:RemoveComponents(UITextMeshProUGUIEx)
    self.history_item:GameObjectRecycleAll()
    local camp_1_name = Localization:GetString("season_s2_camp_choose_04")
    local camp_2_name = Localization:GetString("season_s2_camp_choose_05")
    table.sort(data.history, function(a, b)
      return a.time < b.time
    end)
    for k, v in ipairs(data.history) do
      local StrServerId = "???"
      local StrName = "???"
      local StrCampName = camp_1_name
      local time = UITimeManager:GetInstance():GetServerTimeByUTC(v.time, false)
      if v.serverId ~= nil and v.serverId ~= 0 then
        StrServerId = "#" .. v.serverId
        StrName = v.name or "???"
      end
      if v.campId == SeasonFactionType.Gendarmerie then
        StrCampName = camp_2_name
      end
      goItem = self.history_item:GameObjectSpawn(self.content.transform)
      goItem.name = "history_" .. k
      goItem:SetActive(true)
      theText = self.content:AddComponent(UITextMeshProUGUIEx, goItem.name)
      if v.type == 1 then
        theText:SetLocalText("season_s2_camp_choose_10", time, StrServerId, StrName, StrCampName)
      elseif v.type == 2 then
        local StrServerId2 = "???"
        local StrCampName2 = camp_1_name
        if v.otherServerId ~= nil and v.otherServerId ~= 0 then
          StrServerId2 = "#" .. v.otherServerId
        end
        if v.otherCampId == SeasonFactionType.Gendarmerie then
          StrCampName2 = camp_2_name
        end
        theText:SetLocalText("season_s2_camp_choose_11", time, StrServerId, StrName, StrCampName, StrServerId2, StrCampName2)
      elseif v.type == 3 then
        theText:SetLocalText("season_s2_camp_tip_006", time, StrServerId, StrCampName)
      end
    end
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
    self.scroll_view:AnimVerticalNormalizedPos(0, 0.2)
  else
  end
end

function LWSeasonFactionSelectionS4Normal:SetData(activityId)
  if activityId == nil or activityId == 0 or activityId == "" then
    return
  end
  self.activityId = activityId
  self:UpdateData()
end

function LWSeasonFactionSelectionS4Normal:UpdateData()
  if self.activityId == nil or IsNull(self.gameObject) then
    return
  end
  local hasAlliance = LuaEntry.Player:IsInAlliance()
  local actData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if actData then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local para = toInt(actData.para)
    local para1 = actData.para1
    local para4 = actData.para4
    local para_1 = toInt(actData.para_1)
    local para_2 = toInt(actData.para_2)
    local para_3 = toInt(actData.para_3)
    self.insertCooldown = para_3 * 1000
    local para_4 = actData.para_4
    if para_4 then
      local item1, item2 = string.split_ii(para_4, "|")
      if item1 and item2 then
        self.group_reward_item1 = toInt(item1)
        self.group_reward_item2 = toInt(item2)
      end
    end
    local groupingActInfo = DataCenter.SeasonFactionWarDataManager:GetGroupingActInfo()
    local startTime = actData.startTime
    local endTime = actData.endTime
    self.act_title:SetLocalText(actData.name)
    self.fightStartTime = startTime + toInt(para4) * OneHourTime * 1000
    self.fightEndTime = endTime
    self.activityData = actData
    if para == 0 then
      para = 4
    end
    self.sideCount = para
    local goItem
    local blueBg = "Assets/Main/Sprites/UI/UIGovernment/Sprites/ServerBattle/lrb_zhanqvduijue_fuwuqibg02.png"
    local redBg = "Assets/Main/Sprites/UI/UIGovernment/Sprites/ServerBattle/lrb_zhanqvduijue_difang_fuwuqibg.png"
    for i = 1, para do
      if self["house1" .. i] == nil then
        goItem = self.house_item:GameObjectSpawn(self.group1.transform)
        goItem.name = "house_" .. i
        goItem:SetActive(true)
        self["house1" .. i] = self.group1:AddComponent(LWSeasonFactionSelectionItemS4, goItem.name)
        self["house1" .. i]:SetEmpty(1)
      end
      if self["house2" .. i] == nil then
        goItem = self.house_item:GameObjectSpawn(self.group2.transform)
        goItem.name = "house_" .. i
        goItem:SetActive(true)
        self["house2" .. i] = self.group2:AddComponent(LWSeasonFactionSelectionItemS4, goItem.name)
        self["house2" .. i]:SetEmpty(2)
      end
      if self["zone_item1" .. i] == nil then
        goItem = self.zone_item:GameObjectSpawn(self.group_over1.transform)
        goItem.name = "zone_" .. i
        goItem:SetActive(true)
        self["zone_item1" .. i] = self.group_over1:AddComponent(UIServerBattleZoneInfo, goItem.name)
        self["zone_item1" .. i].serverText:SetText("???")
        self["zone_item1" .. i].server_bg:LoadSprite(blueBg)
      end
      if self["zone_item2" .. i] == nil then
        goItem = self.zone_item:GameObjectSpawn(self.group_over2.transform)
        goItem.name = "zone_" .. i
        goItem:SetActive(true)
        self["zone_item2" .. i] = self.group_over2:AddComponent(UIServerBattleZoneInfo, goItem.name)
        self["zone_item2" .. i].serverText:SetText("???")
        self["zone_item2" .. i].server_bg:LoadSprite(redBg)
      end
    end
    DataCenter.SeasonDataManager.CrossDeclareWarStartTime = self.fightStartTime
    if groupingActInfo == nil then
      self.group1:SetActive(true)
      self.group2:SetActive(true)
      self.group_over1:SetActive(false)
      self.group_over2:SetActive(false)
      UIGray.SetGray(self.btn_add1.transform, true, false)
      UIGray.SetGray(self.btn_add2.transform, true, false)
    else
      self:RefreshGroupData()
    end
  else
    self.title:SetText("???")
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
end

function LWSeasonFactionSelectionS4Normal:RefreshGroupData()
  local campCount1 = 0
  local campCount2 = 0
  local key
  local data = DataCenter.SeasonFactionWarDataManager:GetGroupingData()
  local groupingActInfo = DataCenter.SeasonFactionWarDataManager:GetGroupingActInfo()
  if groupingActInfo then
    if groupingActInfo.step == 0 then
      self.hideMode = true
    else
      self.hideMode = false
    end
    self.modeEndTime = groupingActInfo.stepEndTime
  end
  if self.hideMode then
    self.title:SetLocalText("season_s2_camp_choose_01")
    self.group1:SetActive(true)
    self.group2:SetActive(true)
    self.group_over1:SetActive(false)
    self.group_over2:SetActive(false)
    self.tips:SetActive(true)
    self.btn_post_card:SetActive(false)
    self.btn_post_rank:SetActive(false)
    for i = 1, self.sideCount do
      if self["house1" .. i] then
        self["house1" .. i]:SetEmpty(1)
      end
      if self["house2" .. i] then
        self["house2" .. i]:SetEmpty(2)
      end
    end
    if data then
      for k, v in pairs(data) do
        if v.campId == SeasonFactionType.Rebels then
          campCount1 = campCount1 + 1
          key = "house1" .. campCount1
        else
          campCount2 = campCount2 + 1
          key = "house2" .. campCount2
        end
        if self[key] then
          self[key]:SetData(v)
        end
      end
    end
    self.btn_add1_text:SetLocalText(campCount1 == 4 and "season_s2_camp_choose_07" or "season_s2_camp_choose_06")
    self.btn_add2_text:SetLocalText(campCount2 == 4 and "season_s2_camp_choose_07" or "season_s2_camp_choose_06")
  else
    self.title:SetLocalText("season_s2_camp_choose_02")
    self.group1:SetActive(false)
    self.group2:SetActive(false)
    self.group_over1:SetActive(true)
    self.group_over2:SetActive(true)
    self.tips:SetActive(false)
    if data then
      for k, v in pairs(data) do
        if v.campId == SeasonFactionType.Rebels then
          campCount1 = campCount1 + 1
          key = "zone_item1" .. campCount1
        else
          campCount2 = campCount2 + 1
          key = "zone_item2" .. campCount2
        end
        local serverId = v.serverId
        local thePresident = DataCenter.GovernmentManager.CrossKingdomKing[serverId]
        local kingInfo = DataCenter.GovernmentManager:GetCrossServerKingInfo(serverId)
        local cfgId = kingInfo and kingInfo.badges.cfgId or 511001
        if serverId == LuaEntry.Player:GetSourceServerId() then
          self.myGroup = v.campId
          self.btn_post_card:SetActive(true)
          self.btn_post_rank:SetActive(true)
          if self[key] then
            self[key]:SetActive(true)
            self[key]:ReInit(kingInfo and kingInfo.king or thePresident, false, 2, serverId, {cfgId = cfgId})
          end
        elseif self[key] then
          self[key]:SetActive(true)
          self[key]:ReInit(kingInfo and kingInfo.king or thePresident, false, 0, serverId, {cfgId = cfgId})
        end
      end
      if campCount1 < 4 then
        for i = campCount1 + 1, 4 do
          key = "zone_item1" .. i
          if self[key] then
            self[key]:SetActive(false)
          end
        end
      end
      if campCount2 < 4 then
        for i = campCount2 + 1, 4 do
          key = "zone_item2" .. i
          if self[key] then
            self[key]:SetActive(false)
          end
        end
      end
    end
  end
  self.btn_post_card:SetActive(false)
  UIGray.SetGray(self.btn_add1.transform, false, true)
  UIGray.SetGray(self.btn_add2.transform, false, true)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
  self:Update1000MS()
end

function LWSeasonFactionSelectionS4Normal:TryAddToGroup(GroupIndex)
  if not LuaEntry.Player:IsPresident() then
    local title = Localization:GetString("120173")
    local desc = Localization:GetString("season_s2_camp_choose_03")
    UIUtil.ShowMessage("<color=#E52727>" .. title .. "</color>\n" .. desc, 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
    end, function()
    end)
    return
  end
  local data = DataCenter.SeasonFactionWarDataManager:GetGroupingData()
  local count = 0
  local myData
  if data then
    local myServerId = LuaEntry.Player:GetSourceServerId()
    for k, v in pairs(data) do
      if v.campId == GroupIndex then
        count = count + 1
      end
      if v.serverId == myServerId then
        myData = v
      end
    end
  end
  if myData and myData.campId == GroupIndex then
    UIUtil.ShowTips(Localization:GetString("season_s2_camp_tip_005"))
    return
  end
  if count == 4 then
    local now = UITimeManager:GetInstance():GetServerTime()
    if myData and myData.forceOpTime and self.insertCooldown and now + 1000 < self.insertCooldown + myData.forceOpTime then
      local cd = UITimeManager:GetInstance():MilliSecondToFmtString(self.insertCooldown + myData.forceOpTime - now)
      UIUtil.ShowTips(Localization:GetString("season_s2_alliance_building_tips015", cd))
      return
    end
    local msg = Localization:GetString("season_s2_camp_choose_08")
    UIUtil.ShowMessage(msg, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      SFSNetwork.SendMessage(MsgDefines.SelectSeasonFaction, GroupIndex, 1)
    end)
  else
    local msg
    if myData then
      msg = Localization:GetString(GroupIndex == 1 and "season_s2_camp_tip_003" or "season_s2_camp_tip_004")
    else
      msg = Localization:GetString(GroupIndex == 1 and "season_s2_camp_tip_001" or "season_s2_camp_tip_002")
    end
    UIUtil.ShowMessage(msg, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      SFSNetwork.SendMessage(MsgDefines.SelectSeasonFaction, GroupIndex, 0)
    end)
  end
end

function LWSeasonFactionSelectionS4Normal:Update1000MS()
  if self.modeEndTime then
    local deltaTime = 0
    local curTime = UITimeManager:GetInstance():GetServerTime()
    deltaTime = self.modeEndTime - curTime
    if 0 < deltaTime then
      local showTime = UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime)
      self.time_text:SetText(showTime)
    else
      self.time_text:SetText("00:00:00")
    end
  end
end

return LWSeasonFactionSelectionS4Normal
