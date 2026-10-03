local base = UIAsyncContainer
local LWSeasonFactionSelectionS4King = BaseClass("LWSeasonFactionSelectionS4King", base)
local Localization = CS.GameEntry.Localization
local ServerNode = require("UI.LWSeason4.UILWFactionSelection.LWSeasonFactionSelectionItemS4")
local act_title_path = "Top/act_title"
local home_icon1_path = "Top/vs/King1/homeIcon1"
local server_txt1_path = "Top/vs/King1/ServerBg/ServerTxt1"
local home_icon2_path = "Top/vs/king2/homeIcon2"
local server_txt2_path = "Top/vs/king2/ServerBg/ServerTxt2"
local icon_fan_k_path = "Top/vs/iconFanK"
local icon_xian_b_path = "Top/vs/iconXianB"
local coin_icon1_path = "Top/vs/statusL/coin_icon1"
local wtf1_path = "Top/vs/statusL/wtf1"
local btn_select1_path = "Top/vs/statusL/BtnSelect1"
local coin_icon2_path = "Top/vs/statusR/coin_icon2"
local wtf2_path = "Top/vs/statusR/wtf2"
local btn_select2_path = "Top/vs/statusR/BtnSelect2"
local info_btn_path = "Top/InfoBtn"
local scroll_view_path = "History/ScrollView"
local content_path = "History/ScrollView/Viewport/Content"
local history_item_path = "History/ScrollView/Viewport/Content/HistoryItem"
local result_txt_path = "ResultTxt"
local step_tips_path = "Content/house/StepTips"
local house2_path = "Content/house/House2"
local house1_path = "Content/house/House1"
local house3_path = "Content/house/House3"
local house4_path = "Content/house/House4"
local house6_path = "Content/house/House6"
local house5_path = "Content/house/House5"
local tips_path = "BottomBar/Tips"
local btn_refresh1_path = "Top/vs/statusL/BtnRefresh1"
local btn_refresh2_path = "Top/vs/statusR/BtnRefresh2"

function LWSeasonFactionSelectionS4King:OnCreate()
  base.OnCreate(self)
  self.rectTransform:Set_offsetMin(0, 0)
  self.rectTransform:Set_offsetMax(0, 0)
  self.act_title = self:AddComponent(UITextMeshProUGUIEx, act_title_path)
  self.home_icon1 = self:AddComponent(UIButton, home_icon1_path)
  self.server_txt1 = self:AddComponent(UITextMeshProUGUIEx, server_txt1_path)
  self.home_icon2 = self:AddComponent(UIButton, home_icon2_path)
  self.server_txt2 = self:AddComponent(UITextMeshProUGUIEx, server_txt2_path)
  self.icon_fan_k = self:AddComponent(UIImage, icon_fan_k_path)
  self.icon_xian_b = self:AddComponent(UIImage, icon_xian_b_path)
  self.coin_icon1 = self:AddComponent(UIButton, coin_icon1_path)
  self.btn_select1 = self:AddComponent(UIButton, btn_select1_path)
  self.coin_icon2 = self:AddComponent(UIButton, coin_icon2_path)
  self.btn_select2 = self:AddComponent(UIButton, btn_select2_path)
  self.coin_icon1:SetOnClick(function()
    self:TrySelectCoin(self.kingServer1)
  end)
  self.coin_icon2:SetOnClick(function()
    self:TrySelectCoin(self.kingServer2)
  end)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.info_btn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonFactionWarRule, {anim = true}, "season_s3_activity_1000063_desc01")
  end)
  self.btn_select1:SetOnClick(function()
    self:TrySelectCoin(self.kingServer1)
  end)
  self.btn_select2:SetOnClick(function()
    self:TrySelectCoin(self.kingServer2)
  end)
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
    local mgr = DataCenter.SeasonFactionWarDataManager
    local history = mgr.seasonFactionMasterServerHistory
    if table.count(history) > 0 then
      local seasonType = SeasonUtil.GetSeasonType()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonFactionHistory, {anim = true}, {Season = seasonType, Type = "King"})
    end
  end)
  self.btn_refresh1 = self:AddComponent(UIButton, btn_refresh1_path)
  self.btn_refresh2 = self:AddComponent(UIButton, btn_refresh2_path)
  self.btn_refresh1:SetOnClick(function()
    self:TrySelectCoin(self.kingServer1)
  end)
  self.btn_refresh2:SetOnClick(function()
    self:TrySelectCoin(self.kingServer2)
  end)
  self.result_txt = self:AddComponent(UITextMeshProUGUIEx, result_txt_path)
  self.step_tips = self:AddComponent(UITextMeshProUGUIEx, step_tips_path)
  self.house2 = self:AddComponent(ServerNode, house2_path)
  self.house1 = self:AddComponent(ServerNode, house1_path)
  self.house3 = self:AddComponent(ServerNode, house3_path)
  self.house4 = self:AddComponent(ServerNode, house4_path)
  self.house6 = self:AddComponent(ServerNode, house6_path)
  self.house5 = self:AddComponent(ServerNode, house5_path)
  self.tips = self:AddComponent(UITextMeshProUGUIEx, tips_path)
  self.tips:SetLocalText("season_s3_activity_1000063_desc021")
  self.act_title:SetLocalText("season_s3_activity_1000063_desc02")
end

function LWSeasonFactionSelectionS4King:TrySelectCoin(kingServer)
  local myServerId = LuaEntry.Player:GetSourceServerId()
  if myServerId == kingServer and LuaEntry.Player:IsPresident(myServerId) then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTeamLeaderSelectCoinS4, {anim = true})
    return
  end
  UIUtil.ShowTipsId("120173")
end

function LWSeasonFactionSelectionS4King:OnDestroy()
  self.content:RemoveComponents(UITextMeshProUGUIEx)
  self.history_item:GameObjectRecycleAll()
  self.act_title = nil
  self.home_icon1 = nil
  self.server_txt1 = nil
  self.home_icon2 = nil
  self.server_txt2 = nil
  self.icon_fan_k = nil
  self.icon_xian_b = nil
  self.coin_icon1 = nil
  self.btn_select1 = nil
  self.coin_icon2 = nil
  self.btn_select2 = nil
  self.info_btn = nil
  self.result_txt = nil
  self.step_tips = nil
  self.house2 = nil
  self.house1 = nil
  self.house3 = nil
  self.house4 = nil
  self.house6 = nil
  self.house5 = nil
  self.tips = nil
  base.OnDestroy(self)
end

function LWSeasonFactionSelectionS4King:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonFactionInfoUpdate, self.RefreshGroupData)
  self:AddUIListener(EventId.LWSeasonFactionHistoryKing, self.OnFactionHistory)
end

function LWSeasonFactionSelectionS4King:OnRemoveListener()
  self:RemoveUIListener(EventId.LWSeasonFactionInfoUpdate, self.RefreshGroupData)
  self:RemoveUIListener(EventId.LWSeasonFactionHistoryKing, self.OnFactionHistory)
  base.OnRemoveListener(self)
end

function LWSeasonFactionSelectionS4King:SetData(activityId)
  if activityId == nil or activityId == 0 or activityId == "" then
    return
  end
  self.requestData = false
  self.activityId = activityId
  self:UpdateData()
end

function LWSeasonFactionSelectionS4King:UpdateData()
  if self.activityId and IsNotNull(self.gameObject) then
    self:RefreshGroupData()
    self:OnFactionHistory()
    self:Update1000MS()
  end
end

function LWSeasonFactionSelectionS4King:RefreshGroupData()
  local seasonConfig = DataCenter.SeasonDataManager:GetServerCurrentSeasonConfig()
  local actData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  self.activityData = actData
  if actData and seasonConfig and seasonConfig.camp_sever then
    local king1, king2 = string.split_ii(seasonConfig.camp_sever, "|")
    local groupingActInfo = DataCenter.SeasonFactionWarDataManager:GetGroupingActInfo()
    local serverList = {}
    local shownMode = false
    local modeEndTime
    self.kingServer1 = king1
    self.kingServer2 = king2
    if groupingActInfo then
      serverList = groupingActInfo.serverList
      modeEndTime = groupingActInfo.stepEndTime
      if groupingActInfo.hasSubStep then
        if groupingActInfo.subStep == 0 then
          shownMode = false
        else
          shownMode = true
        end
        modeEndTime = groupingActInfo.subStepEndTime or groupingActInfo.stepEndTime
      else
        shownMode = true
      end
    end
    self.modeEndTime = modeEndTime
    self.shownMode = shownMode
    self:UpdateKingData(king1, self.home_icon1, self.server_txt1, self.coin_icon1, self.btn_select1, serverList, self.btn_refresh1)
    self:UpdateKingData(king2, self.home_icon2, self.server_txt2, self.coin_icon2, self.btn_select2, serverList, self.btn_refresh2)
    local allServerList = string.split_ii_array(seasonConfig.server, ";")
    if allServerList then
      local index = 1
      for _, serverId in ipairs(allServerList) do
        if serverId ~= king1 and serverId ~= king2 and index < 7 then
          local kingInfo = DataCenter.GovernmentManager:GetCrossServerKingInfo(serverId)
          self["house" .. index]:SetData({
            serverId = serverId,
            cfgId = kingInfo and kingInfo.badges.cfgId or 511001
          }, true)
          index = index + 1
        end
      end
      while index < 7 do
        self["house" .. index]:SetData(nil, true)
        index = index + 1
      end
    end
    if shownMode and table.count(serverList) == 2 then
      local d1 = serverList[1]
      local d2 = serverList[2]
      self.v_select_1 = d1.value
      self.v_select_2 = d2.value
      for k, v in pairs(serverList) do
        if v.campResult == 1 then
          self.red_server = v.serverId
        end
      end
      if self.v_select_1 == -1 then
        self.unselect_server = "#" .. d1.serverId
      end
      if self.v_select_2 == -1 then
        self.unselect_server = "#" .. d2.serverId
      end
      self.icon_fan_k:SetActive(false)
      self.icon_xian_b:SetActive(false)
      if d1.serverId == king1 then
        self.coin_icon1:LoadSprite(DataCenter.SeasonFactionWarDataManager:GetCampIcon(d1.campResult))
        self.coin_icon2:LoadSprite(DataCenter.SeasonFactionWarDataManager:GetCampIcon(d2.campResult))
      else
        self.coin_icon1:LoadSprite(DataCenter.SeasonFactionWarDataManager:GetCampIcon(d2.campResult))
        self.coin_icon2:LoadSprite(DataCenter.SeasonFactionWarDataManager:GetCampIcon(d1.campResult))
      end
    end
  end
  SFSNetwork.SendMessage(MsgDefines.GetCampMasterServerHistory, 0, 10)
end

function LWSeasonFactionSelectionS4King:UpdateKingData(serverId, icon, txt, coin, btn, serverData, btn_refresh)
  local kingInfo = DataCenter.GovernmentManager:GetCrossServerKingInfo(serverId)
  local cfgId = kingInfo and kingInfo.badges.cfgId or 511001
  txt:SetText("#" .. serverId)
  if cfgId and icon then
    local itemCfg = DataCenter.ItemTemplateManager:GetItemTemplate(cfgId)
    if itemCfg ~= nil then
      icon:LoadSprite(string.format(LoadPath.ItemPath, itemCfg.icon))
    end
  end
  if coin and btn and serverData then
    local myServerId = LuaEntry.Player:GetSourceServerId()
    local data
    for k, v in pairs(serverData) do
      if v.serverId == serverId then
        data = v
        break
      end
    end
    if self.shownMode then
      btn_refresh:SetActive(false)
      btn:SetActive(false)
      coin:SetActive(true)
      coin:LoadSprite(DataCenter.SeasonFactionWarDataManager:GetCampIcon(data.campResult))
    elseif myServerId == serverId then
      if LuaEntry.Player:IsPresident(myServerId) then
        if data == nil or data.value == -1 then
          btn:SetActive(true)
          coin:SetActive(false)
          btn_refresh:SetActive(false)
        else
          btn:SetActive(false)
          coin:SetActive(true)
          btn_refresh:SetActive(true)
          if data.value == 1 then
            coin:LoadSprite("Assets/Main/SeasonRes/Shared/Sprites/UI/FactionSelection/ljq_s3_jinbi_02_s.png")
          else
            coin:LoadSprite("Assets/Main/SeasonRes/Shared/Sprites/UI/FactionSelection/ljq_s3_jinbi_01_s.png")
          end
        end
      else
        btn:SetActive(false)
        coin:SetActive(true)
        btn_refresh:SetActive(false)
        coin:LoadSprite("Assets/Main/SeasonRes/Shared/Sprites/UI/FactionSelection/ljq_s3_jinbi_03_s.png")
      end
    else
      btn:SetActive(false)
      coin:SetActive(true)
      btn_refresh:SetActive(false)
      coin:LoadSprite("Assets/Main/SeasonRes/Shared/Sprites/UI/FactionSelection/ljq_s3_jinbi_03_s.png")
    end
  end
end

function LWSeasonFactionSelectionS4King:Update1000MS()
  if self.modeEndTime ~= nil and self.modeEndTime ~= 0 then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local deltaTime = self.modeEndTime - curTime
    if deltaTime <= 0 then
      deltaTime = 0
    end
    local showTime = UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime)
    if self.shownMode then
      local msg
      self.step_tips:SetActive(false)
      self.result_txt:SetActive(true)
      if self.v_select_1 == -1 and self.v_select_2 == -1 then
        msg = Localization:GetString("season_s3_activity_1000063_desc019", self.red_server, showTime)
      elseif self.v_select_1 == -1 then
        msg = Localization:GetString("season_s3_activity_1000063_desc018", self.unselect_server, self.red_server, showTime)
      elseif self.v_select_2 == -1 then
        msg = Localization:GetString("season_s3_activity_1000063_desc018", self.unselect_server, self.red_server, showTime)
      elseif self.v_select_1 == self.v_select_2 then
        msg = Localization:GetString("season_s3_activity_1000063_desc07", self.red_server, showTime)
      else
        msg = Localization:GetString("season_s3_activity_1000063_desc06", self.red_server, showTime)
      end
      if msg then
        local str1, str2 = string.split_ss(msg, "\n")
        if str1 and str2 then
          self.step_tips:SetActive(true)
          self.result_txt:SetActive(true)
          self.result_txt:SetText(str1)
          self.step_tips:SetText(str2)
        else
          self.result_txt:SetText(msg)
        end
      else
        self.step_tips:SetActive(false)
        self.result_txt:SetText("")
      end
    else
      self.step_tips:SetActive(true)
      self.result_txt:SetActive(false)
      self.step_tips:SetLocalText("season_s3_activity_1000063_desc14", showTime)
    end
  end
end

function LWSeasonFactionSelectionS4King:OnFactionHistory()
  local mgr = DataCenter.SeasonFactionWarDataManager
  local history = mgr.seasonFactionMasterServerHistory
  self.content:RemoveComponents(UITextMeshProUGUIEx)
  self.history_item:GameObjectRecycleAll()
  if history == nil or table.count(history) == 0 then
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
    return
  end
  local goItem, theText
  table.sort(history, function(a, b)
    return a.time < b.time
  end)
  for k, v in ipairs(history) do
    local StrName = ""
    local StrCampName = "???"
    local time = UITimeManager:GetInstance():GetServerTimeByUTC(v.time, false)
    local StrServerId = "#" .. toInt(v.serverId)
    if v.value == 1 then
      StrCampName = Localization:GetString("season_s3_activity_1000063_desc12")
    elseif v.value == 2 then
      StrCampName = Localization:GetString("season_s3_activity_1000063_desc13")
    else
      StrCampName = "???"
    end
    if v.userInfo and v.userInfo.name then
      StrName = v.userInfo.name
    end
    goItem = self.history_item:GameObjectSpawn(self.content.transform)
    goItem.name = "history_" .. k
    goItem:SetActive(true)
    theText = self.content:AddComponent(UITextMeshProUGUIEx, goItem.name)
    theText:SetLocalText("season_s3_activity_1000063_desc05", time, StrServerId, StrName, StrCampName)
    if 10 < k then
      break
    end
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
  self.scroll_view:AnimVerticalNormalizedPos(0, 0.2)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
end

return LWSeasonFactionSelectionS4King
