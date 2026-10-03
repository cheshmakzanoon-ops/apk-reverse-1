local UILWSeasonMapDetailV2View = BaseClass("UILWSeasonMapDetailV2View", UIBaseView)
local base = UIBaseView
local MapAreaItem = require("UI.LWSeason5.UILWSeasonMapDetailV2.Component.UILWSeasonMapDetailV2Item")
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

function UILWSeasonMapDetailV2View:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  local serverId = self:GetUserData()
  local loginServerId = LuaEntry.Player:GetSelfServerId()
  local curServerId = serverId or LuaEntry.Player:GetCurServerId()
  local seasonInfo = SeasonUtil.GetSeasonInfo(curServerId)
  self.myServerId = loginServerId
  self.seasonInfo = seasonInfo
  self.curServerId = curServerId
  self.title_text:SetLocalText("s5_map_ui_3")
  self.detail:SetText("")
  self.my_pos:SetActive(false)
  local strServerList
  for theMapIndex = 1, 9 do
    local mySourceServerId = LuaEntry.Player:GetSourceServerId()
    local theServerId = seasonInfo:GetNinePalacesServer(theMapIndex)
    local info = SeasonUtil.GetSeasonInfo(theServerId)
    local item = self["area" .. theMapIndex]
    if item and info then
      item:ReInit(theMapIndex, theServerId, info, mySourceServerId)
      if loginServerId == theServerId then
        local my_point_id = LuaEntry.Player:GetMainWorldPos()
        local worldPos = SceneUtils.TileIndexToWorld(my_point_id, ForceChangeScene.World, loginServerId)
        local x = worldPos.x / 6000 * 620 - 310
        local y = worldPos.z / 6000 * 620 - 310
        self.my_pos:SetActive(true)
        self.my_pos:SetLocalPositionXYZ(x, y, 0)
      end
      if strServerList == nil then
        strServerList = "#" .. theServerId
      else
        strServerList = strServerList .. " ; #" .. theServerId
      end
    end
  end
  self.strServerList = strServerList
  self.select_index = nil
  self.btn1:SetOnValueChanged(function(tf)
    if tf then
      self:ShowType(1)
    end
  end)
  self.btn2:SetOnValueChanged(function(tf)
    if tf then
      self:ShowType(4)
    end
  end)
  self.btn3:SetOnValueChanged(function(tf)
    if tf then
      self:ShowType(3)
    end
  end)
  self.btn4:SetOnValueChanged(function(tf)
    if tf then
      self:ShowType(2)
    end
  end)
  self.btn1:SetIsOn(true)
  self.btn_how_to:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, {
      howToPlayList = {500005}
    })
  end)
  if self.select_index == nil then
    self:ShowType(1)
  end
end

function UILWSeasonMapDetailV2View:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonMapDetailV2View:ComponentDefine()
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
  self.btn2 = self:AddComponent(UIToggle, btn2_path)
  self.btn3 = self:AddComponent(UIToggle, btn3_path)
  self.btn4 = self:AddComponent(UIToggle, btn4_path)
end

function UILWSeasonMapDetailV2View:ComponentDestroy()
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

function UILWSeasonMapDetailV2View:ShowType(select_index)
  local curServerId = self.curServerId
  local seasonInfo = self.seasonInfo
  local mySourceMapIndex = seasonInfo:GetNinePalacesIndex(curServerId)
  self.select_index = select_index
  self.open_time_tick = nil
  for i = 1, 9 do
    self["area" .. i]:SetSelectMode(select_index)
  end
  self.railway:SetActive(select_index == 3)
  if select_index == 1 then
    self.title:SetLocalText("s5_map_ui_31")
    self.desc:SetText(self.strServerList or "-")
    self.detail:SetText("")
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local YES, timeOpen
    if mySourceMapIndex == 1 then
      YES, timeOpen = seasonInfo:CanMoveCityTo(2)
    else
      YES, timeOpen = seasonInfo:CanMoveCityTo(1)
    end
    if not YES and timeOpen ~= nil and timeOpen ~= 0 and curTime < timeOpen then
      self.open_time_tick = timeOpen
      self.open_time_tick_langId = "s5_map_ui_39"
      self:Update1000MS()
    else
      self.detail:SetText("")
    end
  elseif select_index == 2 then
    self.title:SetLocalText("s5_map_ui_32")
    self.desc:SetLocalText("s5_map_ui_35")
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local YES, timeOpen = seasonInfo:CanMoveCityTo(5)
    if not YES and timeOpen ~= nil and timeOpen ~= 0 and curTime < timeOpen then
      self.open_time_tick = timeOpen
      self.open_time_tick_langId = "s5_map_ui_40"
      self:Update1000MS()
    else
      self.detail:SetText("")
    end
  elseif select_index == 3 then
    self.title:SetLocalText("s5_map_ui_33")
    self.desc:SetLocalText("s5_map_ui_36")
    self.open_time_tick = nil
    self.detail:SetLocalText("s5_map_ui_41")
  elseif select_index == 4 then
    self.title:SetLocalText("s5_map_ui_34")
    self.desc:SetLocalText("s5_map_ui_37")
    self.detail:SetLocalText("s5_map_ui_28")
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.title.rectTransform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.desc.rectTransform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
end

function UILWSeasonMapDetailV2View:Update1000MS()
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

return UILWSeasonMapDetailV2View
