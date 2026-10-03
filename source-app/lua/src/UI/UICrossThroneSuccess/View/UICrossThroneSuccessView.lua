local base = UIBaseView
local UICrossThroneSuccessView = BaseClass("UICrossThroneSuccessView", base)
local Localization = CS.GameEntry.Localization
local panel_path = "Close"
local city_page_path = "cityPage"
local title1_path = "cityPage/title1"
local icon_path = "cityPage/icon"
local city_name1_path = "cityPage/cityName1"
local player_path = "cityPage/player"
local name_path = "cityPage/name"
local desc_path = "cityPage/desc"
local red_bag_btn_path = "cityPage/desc/RedBagBtn"
local red_bag_btn_text_path = "cityPage/desc/RedBagBtn/RedBagBtnText"
local red_bag_btn_desc_path = "cityPage/desc/RedBagBtn/RedBagBtnDesc"
local alliance_desc_path = "cityPage/allianceDesc"

function UICrossThroneSuccessView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Refresh()
end

function UICrossThroneSuccessView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UICrossThroneSuccessView:ComponentDefine()
  self.close = self:AddComponent(UIButton, panel_path)
  self.close:SetOnClick(function()
    self:OnClickCloseBtn()
  end)
  self.city_page = self:AddComponent(UIBaseContainer, city_page_path)
  self.title1 = self:AddComponent(UITextMeshProUGUIEx, title1_path)
  self.title1:SetLocalText("gogncheng_liantu_tittle1007")
  self.icon = self:AddComponent(UIImage, icon_path)
  self.city_name1 = self:AddComponent(UITextMeshProUGUIEx, city_name1_path)
  self.player = self:AddComponent(UICommonHead, player_path)
  self.player:SetEnableClickShowInfo(true, true)
  self.name = self:AddComponent(UITextMeshProUGUIEx, name_path)
  self.desc = self:AddComponent(UITextMeshProUGUIEx, desc_path)
  self.redBagBtn = self:AddComponent(UIButton, red_bag_btn_path)
  self.redBagBtn:SetOnClick(function()
    self:OnClickRedBagBtn()
  end)
  self.redBagBtn:SetActive(false)
  self.red_bag_btn_text = self:AddComponent(UITextMeshProUGUIEx, red_bag_btn_text_path)
  self.red_bag_btn_text:SetLocalText("zone_war_government_06")
  self.red_bag_btn_desc = self:AddComponent(UITextMeshProUGUIEx, red_bag_btn_desc_path)
  self.alliance_desc = self:AddComponent(UITextMeshProUGUIEx, alliance_desc_path)
end

function UICrossThroneSuccessView:ComponentDestroy()
  self.serverData = nil
  self.cityMeta = nil
end

function UICrossThroneSuccessView:DataDefine()
  local kingCityId, kingCityPosIndex = SeasonUtil.GetKingCityId(LuaEntry.Player:GetCurServerId())
  self.serverData = self:GetUserData()
  self.cityId = kingCityId
  self.cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(self.cityId)
end

function UICrossThroneSuccessView:DataDestroy()
  self.cityId = nil
  self.cityMeta = nil
end

function UICrossThroneSuccessView:OnAddListener()
  base.OnAddListener(self)
end

function UICrossThroneSuccessView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UICrossThroneSuccessView:Refresh()
  local cityName = Localization:GetString("140205", self.cityMeta.level, Localization:GetString(self.cityMeta.name))
  self.city_name1:SetText(cityName)
  self.icon:LoadSprite(self.cityMeta:GetIconPath(false))
  local king = self.serverData.king
  self.player:SetHeadAndFrame(king.uid, king.headPic, king.headPicVer, nil, king.headSkinId, king.headSkinET)
  self.name:SetText(UIUtil.FormatServerAllianceName(self.serverData.winServerId, king.abbr, king.name))
  local descStr = Localization:GetString("zone_war_government_05", self.serverData.winServerId, self.serverData.lostServerId, king.name)
  self.desc:SetLocalText(descStr)
  local buffDescStr = DataCenter.AllianceCityTemplateManager:GetAllianceCityBuffDescByCityId(self.cityMeta.id, self.serverData.lostServerId)
  self.alliance_desc:SetText(buffDescStr)
  if LuaEntry.Player.uid == king.uid then
    self.redBagBtn:SetActive(true)
    self.time = self.serverData.sendRedPackTimeout
    self:Update1000MS()
  end
end

function UICrossThroneSuccessView:Update1000MS()
  if self.time then
    local now = UITimeManager:GetInstance():GetServerTime()
    if now < self.time then
      self.red_bag_btn_desc:SetLocalText("zone_war_government_07", UITimeManager:GetInstance():MilliSecondToFmtStringWithoutDay(self.time - now))
    else
      self.time = nil
      self.redBagBtn:SetActive(false)
    end
  end
end

function UICrossThroneSuccessView:OnClickCloseBtn()
  self.ctrl:CloseSelf()
end

function UICrossThroneSuccessView:OnClickRedBagBtn()
  SFSNetwork.SendMessage(MsgDefines.CrossThroneSendRedPacket)
  self.ctrl:CloseSelf()
end

return UICrossThroneSuccessView
