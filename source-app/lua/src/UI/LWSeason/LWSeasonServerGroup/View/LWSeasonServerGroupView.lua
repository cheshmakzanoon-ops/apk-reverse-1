local LWSeasonServerGroupView = BaseClass("LWSeasonServerGroupView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local LWSeasonServerGroupItem = require("UI.LWSeason.LWSeasonServerGroup.Component.LWSeasonServerGroupItem")
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local title_text_path = "PopUpTitle/desc"
local bg3_path = "PopUpTitle/bg3"
local bg1_path = "PopUpTitle/bg1"
local bg2_path = "PopUpTitle/bg2"
local bg2_ea_path = "PopUpTitle/bg2_ea"
local scroll_view_path = "PopUpTitle/ScrollView"
local content_path = "PopUpTitle/ScrollView/Viewport/Content"
local snow_group1_path = "PopUpTitle/SnowGroup1"
local snow_group2_path = "PopUpTitle/SnowGroup2"
local server3_path = "PopUpTitle/ScrollView/Viewport/Content/server3"
local server1_path = "PopUpTitle/ScrollView/Viewport/Content/server1"
local icon2_path = "PopUpTitle/SnowGroup2/icon2"
local icon1_path = "PopUpTitle/SnowGroup1/icon1"
local group_title2_path = "PopUpTitle/SnowGroup2/GroupTitle2"
local group_title1_path = "PopUpTitle/SnowGroup1/GroupTitle1"

function LWSeasonServerGroupView:OnCreate()
  base.OnCreate(self)
  local param, data = self:GetUserData()
  self.serverList = {}
  self.listGO = {}
  self.param = param
  self.paramData = data
  self:ComponentDefine()
  self:ShowServerList()
end

function LWSeasonServerGroupView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWSeasonServerGroupView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnGetServerKingData, self.OnGetServerKingData)
end

function LWSeasonServerGroupView:OnRemoveListener()
  self:RemoveUIListener(EventId.OnGetServerKingData, self.OnGetServerKingData)
  base.OnRemoveListener(self)
end

function LWSeasonServerGroupView:ComponentDefine()
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.title_text = self:AddComponent(UIText, title_text_path)
  if self.param == JumpServerMode.CrossServerKing then
    self.dialog_title_text:SetLocalText("season_select_server_title")
    self.title_text:SetLocalText("season_main_UI101")
  elseif self.paramData and self.param == JumpServerMode.PutAllianceBuild then
    self.dialog_title_text:SetLocalText("season_select_server_title")
    self.title_text:SetLocalText("season_select_server_desc1")
  else
    self.dialog_title_text:SetLocalText("season_main_UI100")
    self.title_text:SetLocalText("season_main_UI101")
  end
  self.icon2 = self:AddComponent(UIImage, icon2_path)
  self.icon1 = self:AddComponent(UIImage, icon1_path)
  self.group_title2 = self:AddComponent(UITextMeshProUGUIEx, group_title2_path)
  self.group_title1 = self:AddComponent(UITextMeshProUGUIEx, group_title1_path)
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.bg1 = self:AddComponent(UIRawImage, bg1_path)
  self.bg2 = self:AddComponent(UIRawImage, bg2_path)
  self.bg3 = self:AddComponent(UIRawImage, bg3_path)
  self.bg2_ea = self:AddComponent(UIRawImage, bg2_ea_path)
  self.ScrollView = self:AddComponent(UIScrollRect, scroll_view_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.snow_group1 = self:AddComponent(UIBaseContainer, snow_group1_path)
  self.snow_group2 = self:AddComponent(UIBaseContainer, snow_group2_path)
  self.snow_group1:SetActive(false)
  self.snow_group2:SetActive(false)
  self.theItem1 = self.transform:Find(server1_path).gameObject
  self.theItem1:GameObjectCreatePool()
  self.theItem3 = self.transform:Find(server3_path).gameObject
  self.theItem3:GameObjectCreatePool()
  self.ScrollView:SetVerticalNormalizedPosition(1)
end

function LWSeasonServerGroupView:ComponentDestroy()
  self.content:RemoveComponents(LWSeasonServerGroupItem)
  self.theItem1:GameObjectRecycleAll()
  self.theItem3:GameObjectRecycleAll()
  self.listGO = {}
  self.btn_back = nil
  self.bg2_ea = nil
  self.content = nil
  self.snow_group1 = nil
  self.snow_group2 = nil
  self.server3 = nil
  self.server1 = nil
  self.group_title2 = nil
  self.group_title1 = nil
end

function LWSeasonServerGroupView:OnGetServerKingData()
end

function LWSeasonServerGroupView:ShowServerList()
  local serverList = {}
  if self.param == JumpServerMode.CrossServerKing then
    local configSchedule = DataCenter.ZoneWarManager:GetCrossKingSchedule()
    if configSchedule and configSchedule.initServerGroup then
      local group = configSchedule.initServerGroup.group
      if group and group.a and group.b then
        serverList = table.mergeArray(group.a, group.b)
      end
    end
  else
    serverList = DataCenter.SeasonDataManager:GetServerListInt(true)
  end
  local topY = 0
  local fullHeight = 1020
  local theSeasonType = SeasonUtil.GetSeasonType(false, true, ServerEnum.Source)
  local theSeasonTypePreHot = SeasonUtil.GetSeasonType(true, true, ServerEnum.Source)
  local serverListStr = table.concat(serverList, ",")
  SFSNetwork.SendMessage(MsgDefines.GetCrossServerKingInfo, serverListStr)
  self.bg1:SetActive(theSeasonType == SeasonMapType.CityStronghold)
  self.bg2:SetActive(false)
  self.bg2_ea:SetActive(false)
  self.bg3:SetActive(theSeasonType == SeasonMapType.Desert)
  if theSeasonType == SeasonMapType.Desert then
    self.ScrollView:AddValueChangeListener(function()
      local pos = self.content:GetAnchoredPosition()
      self.bg3:SetAnchoredPositionXY(pos.x, pos.y + 100)
    end)
  elseif theSeasonType == SeasonMapType.CityStronghold then
    if theSeasonTypePreHot == SeasonMapType.Snow then
      self.bg2_ea:SetActive(true)
      self.bg2_ea:LoadSpriteAuto("Assets/Main/SeasonRes/S2/Textures/Activity/bg/season2_server_background.png")
    end
  elseif theSeasonType == SeasonMapType.NineNation then
    self.bg2_ea:SetActive(true)
    if theSeasonTypePreHot == SeasonMapType.NineNationRainforest then
      self.bg2_ea:LoadSpriteAuto("Assets/Main/SeasonRes/S6/Textures/Activity/Bg/FX_banner.png")
    else
      self.bg2_ea:LoadSpriteAuto("Assets/Main/SeasonRes/S5/Textures/Activity/Bg/LXYS5_fenzu_banner.png")
    end
  elseif SeasonUtil.SeasonHasFactionWar(theSeasonType) then
    local mgr = DataCenter.SeasonFactionWarDataManager
    local campInfo = mgr:GetGroupingData()
    local camp1 = {}
    local camp2 = {}
    if campInfo ~= nil and mgr:IsGroupingShownMode() then
      for _, serverId in ipairs(serverList) do
        for k, v in pairs(campInfo) do
          if toInt(v.serverId) == toInt(serverId) then
            if v.campId == SeasonFactionType.Rebels then
              table.insert(camp2, serverId)
              break
            end
            if v.campId == SeasonFactionType.Gendarmerie then
              table.insert(camp1, serverId)
            end
            break
          end
        end
      end
    else
      local mySourceServerId = LuaEntry.Player:GetSourceServerId()
      local seasonInfo = SeasonUtil.GetSeasonInfo(mySourceServerId)
      if seasonInfo and seasonInfo.campInfo then
        for _, v in ipairs(seasonInfo.campInfo) do
          if v.campId == SeasonFactionType.Rebels then
            table.insert(camp2, v.serverId)
          elseif v.campId == SeasonFactionType.Gendarmerie then
            table.insert(camp1, v.serverId)
          end
        end
      end
    end
    if 0 < #camp1 or 0 < #camp2 then
      self.snow_group1:SetActive(true)
      self.snow_group2:SetActive(true)
      topY = -105
      fullHeight = 820
      local count = math.max(#camp1, #camp2)
      if 0 < count then
        serverList = {}
        for index = 1, count do
          table.insert(serverList, camp1[index] or 0)
          table.insert(serverList, camp2[index] or 0)
        end
      end
      self.group_title1:SetText(mgr:GetCampName(SeasonFactionType.Rebels))
      self.group_title2:SetText(mgr:GetCampName(SeasonFactionType.Gendarmerie))
      self.icon1:LoadSprite(mgr:GetCampIcon(SeasonFactionType.Rebels, false))
      self.icon2:LoadSprite(mgr:GetCampIcon(SeasonFactionType.Gendarmerie, false))
      if theSeasonType == SeasonMapType.NineNationRainforest then
        self.bg2_ea:SetActive(true)
        self.bg2_ea:LoadSprite("Assets/Main/SeasonRes/S6/Textures/Activity/Bg/ljq_s6_ditu_bg_banner.png")
      else
        self.bg2_ea:SetActive(false)
        self.bg2:SetActive(true)
      end
    else
      self.snow_group1:SetActive(false)
      self.snow_group2:SetActive(false)
      self.bg2:SetActive(false)
      self.bg2_ea:SetActive(false)
      if theSeasonType == SeasonMapType.Darkness then
        self.bg2_ea:LoadSpriteAuto("Assets/Main/SeasonRes/S4/Textures/Common/bg_server_group.png")
        self.bg2_ea:SetActive(true)
      elseif theSeasonType == SeasonMapType.Snow then
        self.bg2_ea:SetActive(true)
        self.bg2_ea:LoadSpriteAuto("Assets/Main/SeasonRes/S2/Textures/Activity/bg/season2_server_background.png")
      elseif theSeasonType == SeasonMapType.NineNationRainforest then
        self.bg2_ea:SetActive(true)
        self.bg2_ea:LoadSpriteAuto("Assets/Main/SeasonRes/S6/Textures/Activity/Bg/FX_banner.png")
      elseif theSeasonType == SeasonMapType.NineNation then
        self.bg2_ea:LoadSpriteAuto("Assets/Main/SeasonRes/S5/Textures/Activity/Bg/LXYS5_fenzu_banner.png")
      else
        self.bg3:SetActive(true)
        self.ScrollView:AddValueChangeListener(function()
          local pos = self.content:GetAnchoredPosition()
          self.bg3:SetAnchoredPositionXY(pos.x, pos.y + 100)
        end)
      end
    end
  end
  self.serverList = serverList
  local goItem, theItem
  self.content:RemoveComponents(LWSeasonServerGroupItem)
  self.theItem1:GameObjectRecycleAll()
  self.theItem3:GameObjectRecycleAll()
  for i, serverId in ipairs(serverList) do
    if toInt(serverId) < 8000 then
      if theSeasonType == SeasonMapType.Desert then
        goItem = self.theItem3:GameObjectSpawn(self.content.transform)
      else
        goItem = self.theItem1:GameObjectSpawn(self.content.transform)
      end
      goItem.name = "item_" .. i
      goItem:SetActive(true)
      theItem = self.content:AddComponent(LWSeasonServerGroupItem, goItem.name)
      theItem:ReInit(i, serverId, theSeasonTypePreHot or theSeasonType)
    end
  end
  self.ScrollView:SetLocalPositionXYZ(0, topY, 0)
  self.ScrollView:SetSizeDeltaXY(730, fullHeight)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
end

return LWSeasonServerGroupView
