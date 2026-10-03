local UISeasonOfficialBuffView = BaseClass("UISeasonOfficialBuffView", UIBaseView)
local base = UIBaseView
local SeasonOfficialBuffRow = require("UI.UIGovernment.UISeasonOfficialBuff.SeasonOfficialBuffRow")
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local title_text_path = "Content/TitleText"
local unset_path = "Content/unset"
local player_path = "Content/player"
local name_path = "Content/Name"
local icon_path = "Content/icon"
local effect_path = "Content/effect"
local row_path = "Content/row"
local cd_path = "Content/cd"
local duration_path = "Content/duration"
local back_toggle_path = "Content/backToggle"
local text_path = "Content/backToggle/Text"
local btn_skip_path = "Content/backToggle/btnSkip"

function UISeasonOfficialBuffView:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:InitBuffs()
  self:RefreshView()
end

function UISeasonOfficialBuffView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UISeasonOfficialBuffView:OnAddListener()
  base.OnAddListener(self)
end

function UISeasonOfficialBuffView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UISeasonOfficialBuffView:DataDefine()
  self.serverId, self.buildingId, self.config, self.info = self:GetUserData()
  if not self.info then
    self.info = DataCenter.BuildingOfficialManager:GetOfficial(self.serverId, self.buildingId, self.config.id)
  end
end

function UISeasonOfficialBuffView:DataDestroy()
  self.config = nil
  self.info = nil
end

function UISeasonOfficialBuffView:ComponentDefine()
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.title_text = self:AddComponent(UIText, title_text_path)
  self.unset = self:AddComponent(UIText, unset_path)
  self.player = self:AddComponent(UICommonHead, player_path)
  self.playerName = self:AddComponent(UIText, name_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.cd_time = self:AddComponent(UIText, cd_path)
  self.duration = self:AddComponent(UIText, duration_path)
  self.dialog_title_text:SetLocalText("390003")
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.title_text:SetLocalText(self.config.name)
  self.right_toggle = self:AddComponent(UIToggle, back_toggle_path)
  self.right_toggle:SetActive(false)
  self.right_text = self:AddComponent(UIText, text_path)
  self.right_btn_skip = self:AddComponent(UIButton, btn_skip_path)
  self.right_btn_skip:SetOnClick(function()
    UIUtil.ShowTipsId(393018)
  end)
  self.player:SetEnableClickShowInfo(true, true)
  self.content = self:AddComponent(UIBaseContainer, effect_path)
end

function UISeasonOfficialBuffView:ComponentDestroy()
  self.btn_back = nil
  self.right_toggle = nil
  self.right_btn_skip = nil
  self.right_text = nil
end

function UISeasonOfficialBuffView:InitBuffs()
  local itemNode
  local buffs = DataCenter.GovernmentManager:GetEffectBuffs(self.config.id, 0)
  for index, buff in ipairs(buffs) do
    itemNode = self.content:LoadComponentAsync(SeasonOfficialBuffRow, "Assets/Main/SeasonRes/Shared/Prefabs/UI/Official/SeasonOfficialBuffRow.prefab")
    itemNode:SetData(buff.effectName, buff.buffAddNum)
  end
  if itemNode then
    itemNode:HideLine()
  end
end

function UISeasonOfficialBuffView:RefreshView()
  local isEmpty = true
  self.theCD = nil
  self.endTime = nil
  self.duration:SetText("")
  local positionInfo = self.info
  if positionInfo and positionInfo.uid and positionInfo.uid ~= "" then
    self.playerName:SetText(positionInfo:GetFullName())
    self.player:SetHead(positionInfo.uid, positionInfo.pic, positionInfo.picVer, nil, positionInfo:GetHeadBgImg())
    isEmpty = false
  end
  if positionInfo and positionInfo.IsInAppointTimeCD and positionInfo:IsInAppointTimeCD() then
    self.theCD = positionInfo:GetAppointTimeCD()
    self.cd_time:SetActive(true)
  end
  if positionInfo and positionInfo.endTime > 0 then
    self.endTime = positionInfo.endTime
  end
  self.player:SetActive(not isEmpty)
  self.playerName:SetActive(not isEmpty)
  self.icon:SetActive(isEmpty)
  self.unset:SetActive(isEmpty)
  if isEmpty then
    self.icon:LoadSprite(self.config.icon)
    self.icon:SetNativeSize()
    self.unset:SetLocalText(208255)
  end
  self:Update1000MS()
end

function UISeasonOfficialBuffView:Update1000MS()
  if self.theCD then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.theCD - curTime
    if 0 < remainTime then
      self.cd_time:SetLocalText("officer_apply_009", UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
      self.theCD = nil
      self.cd_time:SetActive(false)
    end
  else
    self.cd_time:SetActive(false)
  end
  if self.endTime then
    local now = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.endTime - now
    if 0 < remainTime then
      self.duration:SetLocalText("zone_war_government_18", UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
      self.endTime = nil
      self.duration:SetText("")
    end
  end
end

return UISeasonOfficialBuffView
