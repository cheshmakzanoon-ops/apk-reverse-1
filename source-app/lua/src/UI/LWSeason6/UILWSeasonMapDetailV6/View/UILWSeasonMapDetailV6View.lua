local UILWSeasonMapDetailV6View = BaseClass("UILWSeasonMapDetailV6View", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local MapAreaItem = require("UI.LWSeason6.UILWSeasonMapDetailV6.Component.UILWSeasonMapDetailV6Item")
local btn_how_to_path = "PopUpTitle/BtnHowTo"
local panel_path = "panel"
local title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local area1_path = "PopUpTitle/MapRoot/Area1"
local area2_path = "PopUpTitle/MapRoot/Area2"
local area3_path = "PopUpTitle/MapRoot/Area3"
local area4_path = "PopUpTitle/MapRoot/Area4"
local area5_path = "PopUpTitle/MapRoot/Area5"
local area6_path = "PopUpTitle/MapRoot/Area6"
local area7_path = "PopUpTitle/MapRoot/Area7"
local area8_path = "PopUpTitle/MapRoot/Area8"
local area9_path = "PopUpTitle/MapRoot/Area9"
local railway_path = "PopUpTitle/MapRoot/Railway"
local my_pos_path = "PopUpTitle/MapRoot/my_pos"
local btn1_path = "PopUpTitle/BtnList/Btn1"
local btn2_path = "PopUpTitle/BtnList/Btn2"
local btn3_path = "PopUpTitle/BtnList/Btn3"
local btn4_path = "PopUpTitle/BtnList/Btn4"
local content_path = "PopUpTitle/PopUpRoot/ScrollView/Viewport/Content"
local title_path = "PopUpTitle/PopUpRoot/ScrollView/Viewport/Content/title"
local desc_path = "PopUpTitle/PopUpRoot/ScrollView/Viewport/Content/desc"
local detail_path = "PopUpTitle/PopUpRoot/detail"

function UILWSeasonMapDetailV6View:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  local curServerId, serverZoneCamp, myCampId = self:GetUserData()
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local loginServerId = LuaEntry.Player:GetSelfServerId()
  local seasonInfo = SeasonUtil.GetSeasonInfo(curServerId)
  self.seasonInfo = seasonInfo
  self.curServerId = curServerId
  self.serverZoneCamp = serverZoneCamp
  self.title_text:SetLocalText("s5_map_ui_3")
  self.detail:SetText("")
  self.my_pos:SetActive(false)
  local campId1 = 0
  local campId2 = 0
  if serverZoneCamp ~= nil then
    local camp1List = {}
    local camp2List = {}
    for _, data in pairs(serverZoneCamp) do
      local theServerId = data.serverId
      local info = SeasonUtil.GetSeasonInfo(theServerId)
      local item = self["area" .. data.mapIndex]
      if item then
        item:ReInit(data.mapIndex, theServerId, info, mySourceServerId, data, myCampId)
      end
      if mySourceServerId == theServerId then
        myCampId = data.campId
      end
      if data.campId == 1 then
        table.insert(camp1List, data.serverId)
      elseif data.campId == 2 then
        table.insert(camp2List, data.serverId)
      end
      if data.mapIndex == 1 then
        campId1 = data.campId
      elseif data.mapIndex == 2 then
        campId2 = data.campId
      end
    end
    table.sort(camp1List, function(a, b)
      return a < b
    end)
    table.sort(camp2List, function(a, b)
      return a < b
    end)
    local msg1 = "#" .. table.concat(camp1List, ";#")
    local msg2 = "#" .. table.concat(camp2List, ";#")
    self.strServerList = Localization:GetString("s6_map_ui_02", msg1) .. "\n" .. Localization:GetString("s6_map_ui_03", msg2)
  else
    for theMapIndex = 1, 9 do
      local theServerId = seasonInfo:GetNinePalacesServer(theMapIndex)
      local info = SeasonUtil.GetSeasonInfo(theServerId)
      local item = self["area" .. theMapIndex]
      if item and info then
        item:ReInit(theMapIndex, theServerId, info, mySourceServerId)
      end
      if loginServerId == theServerId then
        local my_point_id = LuaEntry.Player:GetMainWorldPos()
        local worldPos = SceneUtils.TileIndexToWorld(my_point_id, ForceChangeScene.World, loginServerId)
        local x = worldPos.x / 6000 * 620 - 310
        local y = worldPos.z / 6000 * 620 - 310
        self.my_pos:SetActive(true)
        self.my_pos:SetLocalPositionXYZ(x, y, 0)
      end
    end
    if seasonInfo:IsInBattleServerGroupInt_IgnoreSplitServer(mySourceServerId) then
      myCampId = seasonInfo:GetCampIdByServerId(mySourceServerId)
      campId1 = seasonInfo:GetCampIdByMapIndex(1)
      campId2 = seasonInfo:GetCampIdByMapIndex(2)
    end
  end
  if myCampId == 1 or myCampId == 2 then
    if campId1 ~= myCampId then
      if campId2 ~= myCampId then
        self.btn1Bg:LoadSprite("Assets/Main/SeasonRes/S5/Sprites/MiniMap/v3/ljq_s6_zhenyingditu_mode_003.png")
        self.btn2Bg:LoadSprite("Assets/Main/SeasonRes/S5/Sprites/MiniMap/v3/ljq_s6_zhenyingditu_mode_004.png")
      else
        self.btn1Bg:LoadSprite("Assets/Main/SeasonRes/S5/Sprites/MiniMap/v3/ljq_s6_zhenyingditu_mode_001.png")
        self.btn2Bg:LoadSprite("Assets/Main/SeasonRes/S5/Sprites/MiniMap/v3/ljq_s6_zhenyingditu_mode_002.png")
      end
    elseif campId2 ~= myCampId then
      self.btn1Bg:LoadSprite("Assets/Main/SeasonRes/S5/Sprites/MiniMap/v3/ljq_s6_zhenyingditu_mode_002.png")
      self.btn2Bg:LoadSprite("Assets/Main/SeasonRes/S5/Sprites/MiniMap/v3/ljq_s6_zhenyingditu_mode_001.png")
    else
      self.btn1Bg:LoadSprite("Assets/Main/SeasonRes/S5/Sprites/MiniMap/v3/ljq_s6_zhenyingditu_mode_004.png")
      self.btn2Bg:LoadSprite("Assets/Main/SeasonRes/S5/Sprites/MiniMap/v3/ljq_s6_zhenyingditu_mode_003.png")
    end
    self.btn2:SetActive(true)
  else
    self.btn1Bg:LoadSprite("Assets/Main/SeasonRes/S5/Sprites/MiniMap/v3/ljq_s6_zhenyingditu_dikuai01.png")
    self.btn2:SetActive(false)
  end
  self.select_index = nil
  self.btn1:SetOnValueChanged(function(tf)
    if tf then
      self:ShowType(1, true)
    end
  end)
  self.btn2:SetOnValueChanged(function(tf)
    if tf then
      self:ShowType(4, true)
    end
  end)
  self.btn3:SetOnValueChanged(function(tf)
    if tf then
      self:ShowType(3, true)
    end
  end)
  self.btn4:SetOnValueChanged(function(tf)
    if tf then
      self:ShowType(2, true)
    end
  end)
  self.btn1:SetIsOn(true)
  self.btn_how_to:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, {
      howToPlayList = {600005}
    })
  end)
  if self.select_index == nil then
    self:ShowType(1)
  end
end

function UILWSeasonMapDetailV6View:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonMapDetailV6View:ComponentDefine()
  self.btn_how_to = self:AddComponent(UIButton, btn_how_to_path)
  self.title_text = self:AddComponent(UIText, title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.railway = self:AddComponent(UIImage, railway_path)
  self.area1 = self:AddComponent(MapAreaItem, area1_path)
  self.area2 = self:AddComponent(MapAreaItem, area2_path)
  self.area3 = self:AddComponent(MapAreaItem, area3_path)
  self.area4 = self:AddComponent(MapAreaItem, area4_path)
  self.area5 = self:AddComponent(MapAreaItem, area5_path)
  self.area6 = self:AddComponent(MapAreaItem, area6_path)
  self.area7 = self:AddComponent(MapAreaItem, area7_path)
  self.area8 = self:AddComponent(MapAreaItem, area8_path)
  self.area9 = self:AddComponent(MapAreaItem, area9_path)
  self.my_pos = self:AddComponent(UIImage, my_pos_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.title = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self.desc = self:AddComponent(UITextMeshProUGUIEx, desc_path)
  self.detail = self:AddComponent(UITextMeshProUGUIEx, detail_path)
  self.btn1 = self:AddComponent(UIToggle, btn1_path)
  self.btn1Bg = self:AddComponent(UIImage, btn1_path)
  self.btn2 = self:AddComponent(UIToggle, btn2_path)
  self.btn2Bg = self:AddComponent(UIImage, btn2_path)
  self.btn3 = self:AddComponent(UIToggle, btn3_path)
  self.btn4 = self:AddComponent(UIToggle, btn4_path)
end

function UILWSeasonMapDetailV6View:ComponentDestroy()
  self.btn_back = nil
  self.my_pos = nil
  self.btn1 = nil
  self.btn2 = nil
  self.btn3 = nil
  self.btn4 = nil
  self.content = nil
  self.title = nil
  self.desc = nil
  self.detail = nil
  self.btn_how_to = nil
end

function UILWSeasonMapDetailV6View:ShowType(select_index, playAudio)
  if playAudio then
    DataCenter.LWSoundManager:PlaySound(6100022, false)
  end
  local curServerId = self.curServerId
  local seasonInfo = self.seasonInfo
  local isInSeason = seasonInfo:InNormalMode()
  local campInfo = seasonInfo.campInfo
  self.select_index = select_index
  self.open_time_tick = nil
  for i = 1, 9 do
    self["area" .. i]:SetSelectMode(select_index)
  end
  self.railway:SetActive(select_index == 3)
  if select_index == 1 then
    self.title:SetLocalText("s6_map_ui_01")
    local strServerList = self.strServerList
    if strServerList == nil and campInfo then
      local camp1List = {}
      local camp2List = {}
      for _, v in pairs(campInfo) do
        if v.campId == SeasonFactionType.Rebels then
          table.insert(camp1List, v.serverId)
        elseif v.campId == SeasonFactionType.Gendarmerie then
          table.insert(camp2List, v.serverId)
        end
      end
      table.sort(camp1List, function(a, b)
        return a < b
      end)
      table.sort(camp2List, function(a, b)
        return a < b
      end)
      local msg1 = "#" .. table.concat(camp1List, ";#")
      local msg2 = "#" .. table.concat(camp2List, ";#")
      self.strServerList = Localization:GetString("s6_map_ui_02", msg1) .. "\n" .. Localization:GetString("s6_map_ui_03", msg2)
    elseif strServerList == nil and seasonInfo.serverListStr then
      self.strServerList = "#" .. table.concat(table.values(seasonInfo.serverListStr), "; #")
    end
    self.desc:SetText(self.strServerList)
    self.detail:SetText("")
  elseif select_index == 2 then
    self.title:SetLocalText("s6_map_ui_10")
    self.desc:SetLocalText("s6_map_ui_11")
    self.detail:SetText("")
    if isInSeason then
      local cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(999, curServerId)
      if cityMeta then
        local season_start = seasonInfo.seasonStartTime
        local first_open = cityMeta:getIntValue("first_open", 1) - 1
        local open_para = cityMeta:getValue("open_para", "12|60")
        local offsetHour, durationMin = string.split_ii(open_para, "|")
        self.open_time_tick = season_start + first_open * OneDayTime * 1000 + offsetHour * OneHourTime * 1000
        self.open_time_tick_langId = "s6_map_ui_12"
        self:Update1000MS()
      else
        self.detail:SetText("")
      end
    end
  elseif select_index == 3 then
    self.title:SetLocalText("s6_map_ui_07")
    self.desc:SetLocalText("s6_map_ui_08")
    self.detail:SetText("")
    if isInSeason then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      local YES, timeOpen = seasonInfo:CanMoveCityTo(5)
      if not YES and timeOpen ~= nil and timeOpen ~= 0 and curTime < timeOpen then
        self.open_time_tick = timeOpen
        self.open_time_tick_langId = "s6_map_ui_09"
        self:Update1000MS()
      else
        self.detail:SetText("")
      end
    end
  elseif select_index == 4 then
    self.title:SetLocalText("s6_map_ui_04")
    self.desc:SetLocalText("s6_map_ui_05")
    self.detail:SetText("")
    if isInSeason then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      local YES, timeOpen = seasonInfo:CanMoveCityTo(1)
      if not YES and timeOpen ~= nil and timeOpen ~= 0 and curTime < timeOpen then
        self.open_time_tick = timeOpen
        self.open_time_tick_langId = "s6_map_ui_06"
        self:Update1000MS()
      else
        self.detail:SetText("")
      end
    end
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.title.rectTransform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.desc.rectTransform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
end

function UILWSeasonMapDetailV6View:Update1000MS()
  if self.open_time_tick and self.open_time_tick_langId then
    local now = UITimeManager:GetInstance():GetServerTime()
    local countdown = self.open_time_tick - now
    if 0 < countdown then
      self.detail:SetLocalText(self.open_time_tick_langId, UITimeManager:GetInstance():MilliSecondToFmtString(countdown))
    else
      self.detail:SetText("")
      self.open_time_tick = nil
      self.open_time_tick_langId = nil
    end
  end
end

return UILWSeasonMapDetailV6View
