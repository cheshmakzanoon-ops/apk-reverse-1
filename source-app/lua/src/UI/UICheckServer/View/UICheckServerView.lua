local UICheckServerView = BaseClass("UICheckServerView", UIBaseView)
local AllianceFlagItem = require("UI.UIAlliance.UIAllianceFlag.Component.AllianceFlagItem")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local txt_title_path = "UICommonMiniPopUpTitle/titleText"
local close_btn_path = "UICommonMiniPopUpTitle/CloseBtn"
local return_btn_path = "UICommonMiniPopUpTitle/panel"
local server_des_path = "Image/serverDes"
local open_des_path = "Image/openDes"
local alliance_city_des_path = "Image/allianceCityDes"
local server_num_path = "Image/serverNum"
local open_day_path = "Image/openDay"
local alliance_city_state_path = "Image/allianceCityState"
local no_tips_path = "Image/no_tips"
local alliance_flag_path = "Image/GameObject/AllianceFlag"
local alliance_country_path = "Image/GameObject/country"
local alliance_name_path = "Image/GameObject/firstNameTxt"
local leader_name_path = "Image/GameObject/secondNameTxt"
local goto_btn_path = "BtnGo/LeftBtn"
local goto_txt_path = "BtnGo/LeftBtn/LeftBtnName"

function UICheckServerView:OnCreate()
  base.OnCreate(self)
  local serverId = self:GetUserData()
  self.serverId = tonumber(serverId)
  self:ComponentDefine()
  self:DataDefine()
end

function UICheckServerView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UICheckServerView:ComponentDefine()
  self.txt_title = self:AddComponent(UIText, txt_title_path)
  self.txt_title:SetLocalText(104272)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.server_des = self:AddComponent(UIText, server_des_path)
  self.server_des:SetLocalText(100031)
  self.server_num = self:AddComponent(UIText, server_num_path)
  self.open_des = self:AddComponent(UIText, open_des_path)
  self.open_des:SetLocalText(104267)
  self.open_day = self:AddComponent(UIText, open_day_path)
  self.alliance_city_des = self:AddComponent(UIText, alliance_city_des_path)
  self.alliance_city_des:SetLocalText(104268)
  self.alliance_city_state = self:AddComponent(UIText, alliance_city_state_path)
  self.flag = self:AddComponent(AllianceFlagItem, alliance_flag_path)
  self.country = self:AddComponent(UIImage, alliance_country_path)
  self.alliance_name = self:AddComponent(UIText, alliance_name_path)
  self.leader_name = self:AddComponent(UIText, leader_name_path)
  self.goto_btn = self:AddComponent(UIButton, goto_btn_path)
  self.goto_txt = self:AddComponent(UIText, goto_txt_path)
  self.goto_txt:SetLocalText(110036)
  self.no_tips = self:AddComponent(UIText, no_tips_path)
  self.no_tips:SetLocalText(104271)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.goto_btn:SetOnClick(function()
    self:OnGotoClick()
  end)
end

function UICheckServerView:ComponentDestroy()
end

function UICheckServerView:DataDefine()
  SFSNetwork.SendMessage(MsgDefines.GetCrossServerInfo, self.serverId)
end

function UICheckServerView:DataDestroy()
  self.list = nil
end

function UICheckServerView:OnEnable()
  base.OnEnable(self)
end

function UICheckServerView:OnDisable()
  base.OnDisable(self)
end

function UICheckServerView:OnGotoClick()
  local v2 = {}
  v2.x = math.floor(WorldTileCount / 2)
  v2.y = math.floor(WorldTileCount / 2)
  GoToUtil.GotoPos(SceneUtils.TileToWorld(v2), CS.SceneManager.World.InitZoom, nil, nil, self.serverId)
  GoToUtil.CloseAllWindows()
end

function UICheckServerView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnGetServerDataRefresh, self.RefreshData)
end

function UICheckServerView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnGetServerDataRefresh, self.RefreshData)
end

function UICheckServerView:RefreshData(data)
  local serverData = DataCenter.AllWorldsManager:GetServerListInfo(self.serverId)
  self.server_num:SetText(Localization:GetString("208236", self.serverId))
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local deltaTime = curTime - serverData.openTime
  self.open_day:SetText(UITimeManager:GetInstance():SecondToFmtStringForCountdownByDialog(deltaTime / 1000))
  if serverData ~= nil then
    if serverData:IsHaveAlliance() then
      self.alliance_city_state:SetLocalText(104269)
      self.no_tips:SetActive(false)
      self.flag:SetActive(true)
      self.flag:SetData(serverData.alIcon)
      if not LuaEntry.GlobalData:IsChina() then
        self.country:SetActive(true)
        local country = string.IsNullOrEmpty(serverData.alCountry) and DefaultNation or serverData.alCountry
        local nationTemplate = DataCenter.NationTemplateManager:GetNationTemplate(country)
        if nationTemplate ~= nil then
          self.country:LoadSprite(nationTemplate:GetNationFlagPath())
        end
      else
        self.country:SetActive(false)
      end
      self.alliance_name:SetText("[" .. serverData.alAbbr .. "]" .. serverData.alName)
      self.leader_name:SetText(serverData.leaderName)
    else
      self.alliance_city_state:SetLocalText(104270)
      self.no_tips:SetActive(true)
      self.flag:SetActive(false)
      self.country:SetActive(false)
      self.alliance_name:SetText("")
      self.leader_name:SetText("")
    end
  else
    self.alliance_city_state:SetLocalText(104270)
    self.no_tips:SetActive(true)
    self.flag:SetActive(false)
    self.country:SetActive(false)
    self.alliance_name:SetText("")
    self.leader_name:SetText("")
  end
end

return UICheckServerView
