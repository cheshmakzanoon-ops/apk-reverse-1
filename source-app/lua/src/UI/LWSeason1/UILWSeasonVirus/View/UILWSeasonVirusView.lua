local UILWSeasonVirusView = BaseClass("UILWSeasonVirusView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UILWSeasonVirusHintGroup = require("UI.LWSeason1.UILWSeasonVirus.Component.UILWSeasonVirusHintGroup")
local UILWSeasonVirusTaskGroup = require("UI.LWSeason1.UILWSeasonVirus.Component.UILWSeasonVirusTaskGroup")
local VirusLayerItem = require("UI.LWSeason1.UILWSeasonVirus.Component.UILWSeasonVirusLayerItem")
local VirusHintItem = require("UI.LWSeason1.UILWSeasonVirus.Component.UILWSeasonVirusItem")
local title_path = "PopUpTitle/Content/title"
local desc_path = "PopUpTitle/Content/desc"
local time_path = "PopUpTitle/Content/time"
local history_btn_path = "PopUpTitle/Content/HistoryBtn"
local virus_info_path = "PopUpTitle/Content/desc/VirusInfo"
local content_path = "PopUpTitle/Content"
local virus_layer_root_path = "PopUpTitle/Content/VirusLayerRoot"
local virus_layer_node_path = "PopUpTitle/Content/VirusLayerRoot/VirusLayerNode"
local virus_num_path = "PopUpTitle/Content/VirusLayerRoot/virusNum"
local virus_num_full_path = "PopUpTitle/Content/VirusLayerRoot/virusNumFull"
local tab_item1_path = "PopUpTitle/Tab/TabItem1"
local tab_item2_path = "PopUpTitle/Tab/TabItem2"
local tab_item3_path = "PopUpTitle/Tab/TabItem3"
local red_point_path = "PopUpTitle/Tab/TabItem3/RedPoint"
local red_num_path = "PopUpTitle/Tab/TabItem3/RedPoint/RedNum"
local setting_toggle_path = "PopUpTitle/Content2/SettingToggle"
local help_setting_toggle_path = "PopUpTitle/Content1/SettingToggleAskHelp"
local setting_text_ask_help_path = "PopUpTitle/Content1/SettingToggleAskHelp/SettingTextAskHelp"
local theLevelList
local lastActiveIndex = 1

function UILWSeasonVirusView:OnCreate()
  base.OnCreate(self)
  UIUtil.CheckEventTrigger(OpMode.ClickBtnVirusEntry, 0, 0.5)
  if theLevelList == nil then
    local hasVirus, theEffectId, theVirusMaxEffectId = SeasonUtil.HasVirus()
    theLevelList = {max = theVirusMaxEffectId}
    LocalController:instance():visitTable(TableName.StatusEffect, function(id, lineData)
      if toInt(lineData.father_status) == theEffectId and toInt(lineData.is_show) ~= 1 then
        for level = 1, 300 do
          local key = "level_" .. level
          if lineData[key] ~= nil and lineData[key] ~= "" then
            if theLevelList[level] == nil then
              theLevelList[level] = {}
            end
            table.insert(theLevelList[level], id)
            break
          end
        end
        if lineData.level_max ~= nil and lineData.level_max ~= "" then
          theLevelList.max = id
        end
      end
    end)
  end
  self:ComponentDefine()
  self:UpdateData()
  self:OnReceiveQuestReward()
  if CommonUtil.IsArabic() then
    self.theVirusRoot:SetLocalScaleXYZ(-1, 1, 1)
  else
    self.theVirusRoot:SetLocalScaleXYZ(1, 1, 1)
  end
  local config = DataCenter.SeasonDataManager:GetSeasonConfig()
  if config then
    local ver = config:getIntValue("version")
    if ver == 0 then
      local ppt = LocalController:instance():getLine(TableName.LW_PPT_Show, toInt(config.virus_ppt_show))
      if ppt then
        self.tab1_text:SetActive(true)
        self.tab1_text:SetLocalText(ppt.long_key)
      else
        self.tab1_text:SetActive(false)
        self.tab1_text:SetText("")
      end
      self.tab1_icon:SetActive(true)
    else
      local virus_ppt_show = tostring(config.virus_ppt_show)
      local virus_ppt_show_int = string.split_ii_array(virus_ppt_show or "", ";")
      if virus_ppt_show_int then
        local hasGroup2006 = false
        local dataList = {}
        local virus_hint_group = virus_ppt_show_int[1]
        LocalController:instance():visitTable(TableName.LW_PPT_Show, function(id, lineData)
          local group = lineData:getIntValue("group", 0)
          if group == virus_hint_group then
            if id == 2006 then
              hasGroup2006 = true
            else
              local banner = lineData:getValue("banner")
              local icon = lineData:getValue("icon")
              if not string.IsNullOrEmpty(banner) then
                table.insert(dataList, {
                  type = 1,
                  id = id,
                  order = lineData:getIntValue("order", 1),
                  icon = banner,
                  title = lineData:getValue("title_key"),
                  desc = lineData:getValue("long_key")
                })
              elseif not string.IsNullOrEmpty(icon) then
                table.insert(dataList, {
                  type = 2,
                  id = id,
                  order = lineData:getIntValue("order", 1),
                  icon = icon,
                  title = lineData:getValue("icon_name"),
                  desc = lineData:getValue("icon_des")
                })
              end
            end
          end
        end)
        table.sort(dataList, function(a, b)
          if a.order == b.order then
            return a.id < b.id
          end
          return a.order < b.order
        end)
        local goItem, theItem
        for _, data in ipairs(dataList) do
          if data.type == 1 then
            goItem = self.theHintItem1:GameObjectSpawn(self.content1.transform)
          else
            goItem = self.theHintItem2:GameObjectSpawn(self.content1.transform)
          end
          if goItem ~= nil then
            goItem.name = "item_" .. UIUtil.GetLoopListItemIndex()
            goItem:SetActive(true)
            theItem = self.content1:AddComponent(VirusHintItem, goItem.name)
            theItem:ReInit(data.id, data.type, data.icon, data.name, data.desc)
          end
        end
        if hasGroup2006 then
          local ppt = LocalController:instance():getLine(TableName.LW_PPT_Show, 2006)
          if ppt then
            self.tab1_text:SetActive(true)
            self.tab1_text:SetLocalText(ppt.long_key)
          else
            self.tab1_text:SetActive(false)
          end
        else
          self.tab1_text:SetActive(false)
        end
        self.tab1_icon:SetActive(hasGroup2006)
      else
        self.tab1_text:SetActive(false)
        self.tab1_icon:SetActive(true)
      end
    end
  else
    self.tab1_text:SetText("")
  end
end

function UILWSeasonVirusView:OnEnable()
  base.OnEnable(self)
  if self.setting_toggle then
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.setting_toggle.rectTransform)
  end
  if self.ask_help_setting_btn then
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.ask_help_setting_btn.rectTransform)
  end
end

function UILWSeasonVirusView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonVirusView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.MSG_ITME_STATUS_TIME_CHANGE, self.UpdateData)
  self:AddUIListener(EventId.ReceiveQuestReward, self.OnReceiveQuestReward)
  self:AddUIListener(EventId.UserSettingChanged, self.OnUserSettingChanged)
end

function UILWSeasonVirusView:OnRemoveListener()
  self:RemoveUIListener(EventId.MSG_ITME_STATUS_TIME_CHANGE, self.UpdateData)
  self:RemoveUIListener(EventId.ReceiveQuestReward, self.OnReceiveQuestReward)
  self:RemoveUIListener(EventId.UserSettingChanged, self.OnUserSettingChanged)
  base.OnRemoveListener(self)
end

function UILWSeasonVirusView:ComponentDefine()
  self:AddComponent(UIButton, "PopUpTitle/CloseBtn"):SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self:AddComponent(UIButton, "panel"):SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.title = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self.desc = self:AddComponent(UITextMeshProUGUIEx, desc_path)
  self.time = self:AddComponent(UITextMeshProUGUIEx, time_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.virus_info = self:AddComponent(UIButton, virus_info_path)
  self.virus_info:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWCityBuff, {anim = true})
  end)
  self.history_btn = self:AddComponent(UIButton, history_btn_path)
  self.history_btn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIVirusHistory)
  end)
  self.virus_num = self:AddComponent(UIImage, virus_num_path)
  self.virus_num_full = self:AddComponent(UIImage, virus_num_full_path)
  self.theVirusRoot = self:AddComponent(UIBaseContainer, virus_layer_root_path)
  self.theVirusItem = self.transform:Find(virus_layer_node_path).gameObject
  self.theVirusItem:GameObjectCreatePool()
  self.tab1_icon = self:AddComponent(UIRawImage, "PopUpTitle/Content1/ScrollView/Viewport/Content1/Tab1Icon")
  self.tab1_text = self:AddComponent(UITextMeshProUGUIEx, "PopUpTitle/Content1/ScrollView/Viewport/Content1/Tab1Text")
  self.tab2 = self:AddComponent(UILWSeasonVirusHintGroup, "PopUpTitle/Content2")
  self.tab3 = self:AddComponent(UILWSeasonVirusTaskGroup, "PopUpTitle/Content3")
  self.content1 = self:AddComponent(UIBaseContainer, "PopUpTitle/Content1/ScrollView/Viewport/Content1")
  self.theHintItem1 = self.transform:Find("PopUpTitle/Content1/ScrollView/Viewport/Content1/VirusPopupDetail1").gameObject
  self.theHintItem1:GameObjectCreatePool()
  self.theHintItem2 = self.transform:Find("PopUpTitle/Content1/ScrollView/Viewport/Content1/VirusPopupDetail2").gameObject
  self.theHintItem2:GameObjectCreatePool()
  self.tab_item1 = self:AddComponent(UIToggle, tab_item1_path)
  self.tab_item2 = self:AddComponent(UIToggle, tab_item2_path)
  self.tab_item3 = self:AddComponent(UIToggle, tab_item3_path)
  self.tab_item1:SetOnValueChanged(function(tf)
    if tf then
      self:OnTabChanged(1)
    end
  end)
  self.tab_item2:SetOnValueChanged(function(tf)
    if tf then
      self:OnTabChanged(2)
    end
  end)
  self.tab_item3:SetOnValueChanged(function(tf)
    if tf then
      self:OnTabChanged(3)
    end
  end)
  self.red_point = self:AddComponent(UIImage, red_point_path)
  self.red_num = self:AddComponent(UIText, red_num_path)
  if self.tabActive == nil then
    if lastActiveIndex == nil or lastActiveIndex == 1 then
      self.tab_item1:SetIsOn(true)
      self:OnTabChanged(1)
    elseif lastActiveIndex == 2 then
      self.tab_item2:SetIsOn(true)
      self:OnTabChanged(2)
    elseif lastActiveIndex == 3 then
      self.tab_item3:SetIsOn(true)
      self:OnTabChanged(3)
    else
      self.tab_item1:SetIsOn(true)
      self:OnTabChanged(1)
    end
  end
  self.setting_toggle = self:AddComponent(UIToggle, setting_toggle_path)
  self.setting_toggle_mode = LuaEntry.Player:GetUserSetting(UserSettingKey.EliminateVirus)
  self.setting_toggle:SetIsOn(self.setting_toggle_mode == "1")
  self.setting_toggle:SetOnValueChanged(function(tf)
    if tf then
      SFSNetwork.SendMessage(MsgDefines.UserSetting, UserSettingKey.EliminateVirus, "1")
    else
      SFSNetwork.SendMessage(MsgDefines.UserSetting, UserSettingKey.EliminateVirus, "0")
    end
  end)
  self.setting_text_ask_help = self:AddComponent(UITextMeshProUGUIEx, setting_text_ask_help_path)
  self.ask_help_setting_btn = self:AddComponent(UIButton, help_setting_toggle_path)
  self.ask_help_setting_btn:SetOnClick(function()
    local player = LuaEntry.Player
    local virusLayer = player.VirusLayer
    if 0 < virusLayer then
      if not LuaEntry.Player:IsInAlliance() then
        if LuaEntry.Player:IsInSourceServer() then
          UIUtil.ShowTipsId("800935")
          if LuaEntry.Player:IsFirstJoinAlliance() == true then
            UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceFirstJoin, {anim = true})
          else
            UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, {guide = false})
          end
        else
          UIUtil.ShowTipsId("800935")
        end
        return
      end
      local share_param = {}
      share_param.sid = player:GetSelfServerId()
      share_param.pos = player:GetMainWorldPos()
      share_param.postType = PostType.Text_PointShare
      share_param.uid = player.uid
      share_param.posType = WorldPointUIType.City
      share_param.askVirusHelp = true
      share_param.statusLayer = virusLayer
      share_param.statusIcon = string.format(LoadPath.LodIcon, "Mjc_saiji2_bingdu_icon.png")
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, share_param)
    else
      UIUtil.ShowTipsId("season_virus_no_virus_tip")
    end
  end)
  self.setting_text_ask_help:SetText(string.format("<u>%s</u>", Localization:GetString("season_virus_ask_help")))
end

function UILWSeasonVirusView:OnUserSettingChanged()
  local new_mode = LuaEntry.Player:GetUserSetting(UserSettingKey.EliminateVirus)
  if new_mode ~= self.setting_toggle_mode then
    self.setting_toggle_mode = new_mode
    UIUtil.ShowTipsId("season_s1_add_virus_tips02")
  end
end

function UILWSeasonVirusView:OnReceiveQuestReward()
  local count = DataCenter.TaskManager:GetSeasonVirusTaskFinishCount()
  if 0 < count then
    self.red_point:SetActive(true)
    self.red_num:SetActive(true)
    self.red_num:SetText(tostring(count))
  else
    self.red_point:SetActive(false)
    self.red_num:SetActive(false)
  end
  if self.tabActive == 3 then
    self.tab3:OnReceiveQuestReward()
  end
end

function UILWSeasonVirusView:OnTabChanged(tabIndex)
  self.tabActive = tabIndex
  self.tab3:SetActive(tabIndex == 3)
  self.tab2:SetActive(tabIndex == 2)
  if tabIndex == 1 and self.ask_help_setting_btn then
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.ask_help_setting_btn.rectTransform)
  end
  if tabIndex == 2 and self.tab2 then
    self.tab2:DoRefresh()
    if self.setting_toggle then
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.setting_toggle.rectTransform)
    end
  elseif tabIndex == 3 and self.tab3 then
    SFSNetwork.SendMessage(MsgDefines.GetTempUserAchievementInfo)
    self.tab3:DoRefresh()
  end
  lastActiveIndex = tabIndex
end

function UILWSeasonVirusView:ComponentDestroy()
  self.content1:RemoveComponents(VirusHintItem)
  self.theHintItem1:GameObjectRecycleAll()
  self.theHintItem2:GameObjectRecycleAll()
  self.theVirusRoot:RemoveComponents(VirusLayerItem)
  self.theVirusItem:GameObjectRecycleAll()
  self.btn_back = nil
  self.virus_info = nil
  self.virus_num_full = nil
  self.tab_item1 = nil
  self.tab_item2 = nil
  self.tab_item3 = nil
  self.red_point = nil
  self.red_num = nil
  self.history_btn = nil
  self.setting_text_ask_help = nil
end

function UILWSeasonVirusView:Update1000MS()
  if not self.dirty then
    return
  end
  local nowLayer = LuaEntry.Player.VirusLayer
  if nowLayer == 0 then
    self.time:SetText("")
    self.time:SetActive(false)
    self.virus_num:SetActive(false)
    if self.theVirusItemList then
      for k, v in ipairs(self.theVirusItemList) do
        v:UpdateLayer(0)
      end
    end
    self.virus_info:SetActive(false)
    self.virus_num:SetSizeDeltaXY(0, 4)
    self.virus_num_full:SetActive(false)
    self.desc:SetText(Localization:GetString("season_tips222") .. "<size=60>0</size>")
    self.dirty = false
    return
  end
  if self.theEffectId then
    local list = LuaEntry.Effect:GetStatusMap()
    local endTime = list[self.theEffectId]
    if endTime then
      local fullEndTime = endTime
      nowLayer, endTime, fullEndTime = SeasonUtil.CalcVirusLevel(nowLayer, endTime)
      local curTime = UITimeManager:GetInstance():GetServerTime()
      local deltaTime = fullEndTime - curTime
      if 0 < deltaTime then
        self.time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
      else
        self.time:SetActive(false)
        self.time:SetText("")
      end
    else
      self.time:SetActive(false)
      self.time:SetText("")
    end
  end
  local msg = Localization:GetString("season_tips222") .. string.format("<size=60>%s</size>", nowLayer)
  self.desc:SetText(msg)
  if self.curVirusLayer ~= nowLayer then
    local width = 0
    local maxWidth = 572
    local maxWidthFull = 630
    if self.theVirusItemList then
      local prevLayer = 0
      local prevX = 0
      for k, v in ipairs(self.theVirusItemList) do
        local x = v.rectTransform:Get_localPosition() + maxWidthFull / 2
        v:UpdateLayer(nowLayer)
        if v.level == 0 then
          prevX = 0
          width = 0
        elseif nowLayer >= v.level then
          prevX = x
          width = prevX
        elseif nowLayer > prevLayer and nowLayer < v.level then
          width = width + (x - prevX) * (nowLayer - prevLayer) / (v.level - prevLayer)
        end
        prevLayer = v.level
      end
    end
    self.virus_num:SetSizeDeltaXY(math.min(width, maxWidth), 4)
    self.virus_num:SetActive(0 < nowLayer)
    self.virus_num_full:SetActive(maxWidth <= width)
    self.curVirusLayer = nowLayer
  end
end

function UILWSeasonVirusView:OnClickVirusInfo()
  local stateMeta = LocalController:instance():getLine(TableName.StatusTab, self.theEffectId)
  if stateMeta then
    UIUtil.ShowDetail(Localization:GetString(stateMeta.info), "season_virus_name")
  end
end

function UILWSeasonVirusView:UpdateData()
  local hasVirus, theEffectId = SeasonUtil.HasVirus()
  self.theEffectId = theEffectId
  self.title:SetLocalText("season_virus_name")
  self.curVirusLayer = -1
  self.dirty = true
  self.theVirusRoot:RemoveComponents(VirusLayerItem)
  self.theVirusItem:GameObjectRecycleAll()
  local nowLayer = LuaEntry.Player.VirusLayer
  local maxLayer = math.max(Setting:GetPrivateInt("VirusMax", 1), nowLayer)
  local theVirusItemList = {}
  if theLevelList then
    local goItem, theItem
    goItem = self.theVirusItem:GameObjectSpawn(self.theVirusRoot.transform)
    goItem.name = "layer_0"
    goItem:SetActive(true)
    theItem = self.theVirusRoot:AddComponent(VirusLayerItem, goItem.name)
    theItem:ReInit(0, 0, maxLayer)
    table.insert(theVirusItemList, theItem)
    local effectIdMax = theLevelList.max
    local effectMetaMax
    if effectIdMax then
      effectMetaMax = LocalController:instance():getLine(TableName.StatusTab, effectIdMax)
    end
    for level = 1, 300 do
      if theLevelList[level] and 0 < #theLevelList[level] then
        local effectId = theLevelList[level][1]
        local meta = LocalController:instance():getLine(TableName.StatusTab, effectId)
        if meta then
          goItem = self.theVirusItem:GameObjectSpawn(self.theVirusRoot.transform)
          goItem.name = string.format("layer_%s_%s", level, effectId)
          goItem:SetActive(true)
          theItem = self.theVirusRoot:AddComponent(VirusLayerItem, goItem.name)
          theItem:ReInit(nowLayer, level, maxLayer, effectId, meta, false)
          table.insert(theVirusItemList, theItem)
          if effectIdMax and effectMetaMax then
            if 6 <= #theVirusItemList then
              break
            end
          elseif 7 <= #theVirusItemList then
            break
          end
        end
      end
    end
    local addEffect = LuaEntry.Effect:GetGameEffect(EffectDefine.SEASON_VIRUS_MAX_ADD)
    local defaultMaxLayer = 100 + toInt(addEffect)
    if effectMetaMax then
      goItem = self.theVirusItem:GameObjectSpawn(self.theVirusRoot.transform)
      goItem.name = "layer_max"
      goItem:SetActive(true)
      theItem = self.theVirusRoot:AddComponent(VirusLayerItem, goItem.name)
      theItem:ReInit(nowLayer, defaultMaxLayer, maxLayer, effectIdMax, effectMetaMax, true)
      table.insert(theVirusItemList, theItem)
    end
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.theVirusRoot.transform)
  end
  self.time:SetActive(0 < nowLayer)
  self.virus_info:SetActive(0 < nowLayer)
  self.theVirusItemList = theVirusItemList
  self:Update1000MS()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
end

return UILWSeasonVirusView
