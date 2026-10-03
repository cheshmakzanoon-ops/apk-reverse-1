local UIWestwardExpansionMapView = BaseClass("UIWestwardExpansionMapView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local MapAreaItem = require("UI.LWSeason5.UIWestwardExpansionMap.Component.UIWestwardExpansionMapItem")
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
local info1_path = "PopUpTitle/ScrollView/Viewport/Content/info1"
local info2_path = "PopUpTitle/ScrollView/Viewport/Content/info2"
local info3_path = "PopUpTitle/ScrollView/Viewport/Content/info3"
local detail_path = "PopUpTitle/detail"
local bg_path = "PopUpTitle/bg"
local desc_path = "PopUpTitle/Desc"
local time_path = "PopUpTitle/Time"
local my_pos_path = "PopUpTitle/MapRoot/my_pos"
local LangKey = {
  [1] = "activity_1200043_tips36",
  [2] = "activity_1200043_tips37",
  [3] = "activity_1200043_tips38"
}

function UIWestwardExpansionMapView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.detail:SetLocalText("activity_1200043_tips42", "<color=#0C9C4A><u>#" .. LuaEntry.Player:GetSourceServerId() .. "</u></color>")
  local loginServerId = LuaEntry.Player:GetSelfServerId()
  self.title_text:SetLocalText("activity_1200043_tips12")
  self.my_pos:SetActive(false)
  for theMapIndex = 1, 9 do
    local theServerId = DataCenter.SeasonDataManager:GetNinePalacesServer(theMapIndex)
    local info = SeasonUtil.GetSeasonInfo(theServerId)
    local item = self["area" .. theMapIndex]
    if item and info then
      item:ReInit(theMapIndex, info)
      if loginServerId == theServerId then
        self.myMapIndex = theMapIndex
        local my_point_id = LuaEntry.Player:GetMainWorldPos()
        local worldPos = SceneUtils.TileIndexToWorld(my_point_id, ForceChangeScene.World, loginServerId)
        local x = worldPos.x / 6000 * 620 - 310
        local y = worldPos.z / 6000 * 620 - 310
        self.my_pos:SetActive(true)
        self.my_pos:SetLocalPositionXYZ(x, y, 0)
      end
    end
  end
  self.info1:SetIsOn(false)
  self.info2:SetIsOn(false)
  self.info3:SetIsOn(false)
  self.detailBtn:SetIsOn(false)
  self:OnInfoChanged()
  self.info1:SetOnValueChanged(function(tf)
    self:OnInfoChanged()
  end)
  self.info2:SetOnValueChanged(function(tf)
    self:OnInfoChanged()
  end)
  self.info3:SetOnValueChanged(function(tf)
    self:OnInfoChanged()
  end)
  self.detailBtn:SetOnValueChanged(function(tf)
    self:OnInfoChanged()
  end)
  local selectNum = self:GetUserData()
  if selectNum then
    if self["info" .. selectNum] then
      self["info" .. selectNum]:SetIsOn(true)
    end
  else
    local curStageTemp, _ = DataCenter.WestwardExpansionDataManager:GetStageTemplate()
    if curStageTemp and self["info" .. curStageTemp.stage] then
      self["info" .. curStageTemp.stage]:SetIsOn(true)
    end
  end
end

function UIWestwardExpansionMapView:OnDestroy()
  self.unlockTime = nil
  self.info1:SetOnValueChanged(nil)
  self.info2:SetOnValueChanged(nil)
  self.info3:SetOnValueChanged(nil)
  self.detailBtn:SetOnValueChanged(nil)
  self.info1:SetIsOn(false)
  self.info2:SetIsOn(false)
  self.info3:SetIsOn(false)
  self.detailBtn:SetIsOn(false)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIWestwardExpansionMapView:ComponentDefine()
  self.title_text = self:AddComponent(UIText, title_text_path)
  self.my_pos = self:AddComponent(UIImage, my_pos_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.area1 = self:AddComponent(MapAreaItem, area1_path)
  self.area2 = self:AddComponent(MapAreaItem, area2_path)
  self.area3 = self:AddComponent(MapAreaItem, area3_path)
  self.area4 = self:AddComponent(MapAreaItem, area4_path)
  self.area5 = self:AddComponent(MapAreaItem, area5_path)
  self.area6 = self:AddComponent(MapAreaItem, area6_path)
  self.area7 = self:AddComponent(MapAreaItem, area7_path)
  self.area8 = self:AddComponent(MapAreaItem, area8_path)
  self.area9 = self:AddComponent(MapAreaItem, area9_path)
  self.railway = self:AddComponent(UIImage, railway_path)
  self.bg = self:AddComponent(UIButton, bg_path)
  self.bg:SetOnClick(function()
  end)
  self.info1 = self:AddComponent(UIToggle, info1_path)
  self.info2 = self:AddComponent(UIToggle, info2_path)
  self.info3 = self:AddComponent(UIToggle, info3_path)
  self.detail = self:AddComponent(UITextMeshProUGUIEx, detail_path)
  self.detailBtn = self:AddComponent(UIToggle, detail_path)
  self.desc = self:AddComponent(UITextMeshProUGUIEx, desc_path)
  self.time = self:AddComponent(UITextMeshProUGUIEx, time_path)
end

function UIWestwardExpansionMapView:ComponentDestroy()
  self.btn_back = nil
  self.panel = nil
  self.title_text = nil
  self.close_btn = nil
  self.area1 = nil
  self.area2 = nil
  self.area3 = nil
  self.area4 = nil
  self.area5 = nil
  self.area6 = nil
  self.area7 = nil
  self.area8 = nil
  self.area9 = nil
  self.railway = nil
  self.info1 = nil
  self.info2 = nil
  self.info3 = nil
  self.detailBtn = nil
  self.detail = nil
  self.bg = nil
  self.desc = nil
  self.time = nil
end

function UIWestwardExpansionMapView:OnInfoChanged(clickMapItem)
  self.unlockTime = nil
  self.desc:SetText("")
  self.time:SetText("")
  if self.doWorking then
    return
  end
  local showType = 0
  self.doWorking = true
  if clickMapItem ~= nil then
    self.info1:SetIsOn(false)
    self.info2:SetIsOn(false)
    self.info3:SetIsOn(false)
    self.detailBtn:SetIsOn(false)
  elseif self.info1:GetIsOn() then
    showType = 1
  elseif self.info2:GetIsOn() then
    showType = 2
  elseif self.info3:GetIsOn() then
    showType = 3
  elseif self.detailBtn:GetIsOn() then
    showType = 4
  else
    local item = self["area" .. self.myMapIndex]
    if item and item:GetIsOn() and item.showGreen then
      showType = 4
    end
  end
  self.railway:SetActive(showType == 2 or showType == 3)
  if showType == 3 or clickMapItem == self.area5 then
    self.area5.name:SetColorHex("#FFFFFF")
  else
    self.area5.name:SetColorHex("#FDC939")
  end
  for i = 1, 9 do
    local item = self["area" .. i]
    if item then
      if i == 5 and showType == 3 then
        item:SetIsOn(true)
        item:ShowSelf(false)
      elseif self.myMapIndex == i and showType == 4 then
        item:SetIsOn(true)
        item:ShowSelf(true)
      elseif showType == 1 and i ~= 5 or clickMapItem == item then
        item:SetIsOn(true)
        item:ShowSelf(false)
      else
        item:SetIsOn(false)
      end
    end
  end
  self.doWorking = false
  if showType == 1 or showType == 2 or showType == 3 then
    local _, _, _, _, unlockTime = DataCenter.WestwardExpansionDataManager:GetMonsterSearchState()
    self.unlockTime = unlockTime[showType]
    self.desc:SetLocalText(LangKey[showType])
    self:Update1000MS()
  end
end

function UIWestwardExpansionMapView:Update1000MS()
  if not self.unlockTime then
    return
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  self.time:SetLocalText("worldboss_tips_01", UITimeManager:GetInstance():MilliSecondToFmtString(self.unlockTime - now))
end

return UIWestwardExpansionMapView
