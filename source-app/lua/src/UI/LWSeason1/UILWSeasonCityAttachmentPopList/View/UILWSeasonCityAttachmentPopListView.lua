local UILWSeasonCityAttachmentPopListView = BaseClass("UILWSeasonCityAttachmentPopListView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local CityAttachmentItem = require("UI.LWSeason1.UILWSeasonCityAttachmentPopList.Component.UILWSeasonCityAttachmentPopListItem")
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"

function UILWSeasonCityAttachmentPopListView:OnCreate()
  base.OnCreate(self)
  local curServerId = LuaEntry.Player:GetCurServerId()
  local cityId, pointId = self:GetUserData()
  self.cityId = toInt(cityId)
  self.cityPointId = toInt(pointId)
  local data = DataCenter.WorldPointDetailManager:GetAllianceCityData(self.cityId)
  if data == nil or data.attachmentList == nil then
    WorldBattleUtil.TryRequestCityInfo(self.cityId, curServerId)
  end
  self:ComponentDefine()
  self:UpdateData()
  DataCenter.AllianceMemberDataManager:TryInitMemberList(false)
end

function UILWSeasonCityAttachmentPopListView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonCityAttachmentPopListView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.WorldAllianceCityDetail, self.OnDetailUpdate)
end

function UILWSeasonCityAttachmentPopListView:OnRemoveListener()
  self:RemoveUIListener(EventId.WorldAllianceCityDetail, self.OnDetailUpdate)
  base.OnRemoveListener(self)
end

function UILWSeasonCityAttachmentPopListView:ComponentDefine()
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.dialog_title_text:SetLocalText("season_builders_alliance_UI_8")
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.build_cell1 = self:AddComponent(CityAttachmentItem, "PopUpTitle/Content/BuildCell1")
  self.build_cell2 = self:AddComponent(CityAttachmentItem, "PopUpTitle/Content/BuildCell2")
  self.build_cell3 = self:AddComponent(CityAttachmentItem, "PopUpTitle/Content/BuildCell3")
  self.info_btn = self:AddComponent(UIButton, "PopUpTitle/Common_img_title/InfoBtn")
  self.info_btn:SetOnClick(function()
    local param = {}
    param.type = "desc"
    param.title = ""
    param.desc = "season_builders_alliance_UI_11"
    param.alignObject = self.info_btn
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
  end)
end

function UILWSeasonCityAttachmentPopListView:ComponentDestroy()
  self.btn_back = nil
  self.build_cell1 = nil
  self.build_cell2 = nil
  self.build_cell3 = nil
  self.info_btn = nil
end

function UILWSeasonCityAttachmentPopListView:OnDetailUpdate()
  local data = DataCenter.WorldPointDetailManager:GetAllianceCityData(self.cityId)
  if data ~= nil and data.attachmentList ~= nil then
    for k, v in ipairs(data.attachmentList) do
      if v and v.slot then
        if v.slot == 0 then
          self.slotData1 = v
        elseif v.slot == 1 then
          self.slotData2 = v
        elseif v.slot == 2 then
          self.slotData3 = v
        end
      end
    end
    self.build_cell1:OnDetailUpdate(self.slotData1)
    self.build_cell2:OnDetailUpdate(self.slotData2)
    self.build_cell3:OnDetailUpdate(self.slotData3)
  end
end

function UILWSeasonCityAttachmentPopListView:UpdateData()
  local hasData = false
  if self.cityId then
    local cfg = DataCenter.SeasonFarmerTemplateManager:GetCityAttachmentTemplate(self.cityId)
    self.cfg = cfg
    if cfg and cfg.build_list and #cfg.build_list >= 3 then
      self.build_cell1:ReInit(1, self.cityId, self.cityPointId, toInt(cfg.build_list[1]), cfg)
      self.build_cell2:ReInit(2, self.cityId, self.cityPointId, toInt(cfg.build_list[2]), cfg)
      self.build_cell3:ReInit(3, self.cityId, self.cityPointId, toInt(cfg.build_list[3]), cfg)
      self:OnDetailUpdate()
      hasData = true
    end
  end
  self.build_cell1:SetActive(hasData)
  self.build_cell2:SetActive(hasData)
  self.build_cell3:SetActive(hasData)
end

return UILWSeasonCityAttachmentPopListView
