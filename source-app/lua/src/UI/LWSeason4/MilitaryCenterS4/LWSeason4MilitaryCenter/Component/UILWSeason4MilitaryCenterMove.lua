local UILWSeason4MilitaryCenterMove = BaseClass("UILWSeason4MilitaryCenterMove", UIAsyncContainer)
local base = UIAsyncContainer
local Localization = CS.GameEntry.Localization
local rapidjson = require("rapidjson")
local base64 = require("Framework.Common.base64")
local info_btn_path = "Root/InfoBtn"
local name_path = "Root/name"
local desc_path = "Root/ScrollView/Viewport/desc"
local build_pos_path = "Root/build_pos"
local hp_bar_path = "Root/HPBar"
local icon_path = "Root/icon"
local build_path = "Root/Build"
local res_info_path = "Root/Build/ResInfo"
local btn_build_path = "Root/Build/btnBuild"
local res_info_num_path = "Root/Build/ResInfoNum"
local building_path = "Root/Building"
local build_pro_path = "Root/Building/buildPro"
local build_info_path = "Root/Building/buildInfo"
local time_text_path = "Root/Building/TimeText"
local btn_go_path = "Root/Building/btnGo"
local move_path = "Root/Move"
local move_info_path = "Root/Move/MoveTips"
local btn_move_path = "Root/Move/btnMove"
local btn_txt_path = "Root/Move/btnMove/btnTxt"
local build_pro2_path = "Root/Move/buildPro2"
local build_info2_path = "Root/Move/buildPro2/buildInfo2"

function UILWSeason4MilitaryCenterMove:OnCreate()
  base.OnCreate(self)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.name = self:AddComponent(UITextMeshProUGUIEx, name_path)
  self.desc = self:AddComponent(UITextMeshProUGUIEx, desc_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.build_pos = self:AddComponent(UITextMeshProUGUIEx, build_pos_path)
  self.hp_bar = self:AddComponent(UISlider, hp_bar_path)
  self.info_btn:SetOnClick(function()
    local meta = DataCenter.AllianceMineManager:GetAllianceMineTemplate(BuildingTypes.SEASON_POWER_CENTER_CARRIER)
    if meta and meta.world_desc then
      UIUtil.ShowDetail(Localization:GetString(meta.world_desc))
    else
      UIUtil.ShowTipsId(120018)
    end
  end)
  self.build_pos:OnPointerClick(function(eventData)
    if self.linkInfo then
      GoToUtil.TryJumpToWorld(self.linkInfo)
    else
      self:OnPointerClick(eventData.position)
    end
  end)
  self.build = self:AddComponent(UIImage, build_path)
  self.res_info = self:AddComponent(UISlider, res_info_path)
  self.btn_build = self:AddComponent(UIButton, btn_build_path)
  self.res_info_num = self:AddComponent(UITextMeshProUGUIEx, res_info_num_path)
  self.btn_build:SetOnClick(function()
    if DataCenter.AllianceBaseDataManager:IsR4orR5() then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeason4CenterCondition, {anim = true}, BuildingTypes.SEASON_POWER_CENTER_CARRIER)
    else
      UIUtil.ShowTipsId(803040)
    end
  end)
  self.building = self:AddComponent(UIImage, building_path)
  self.build_pro = self:AddComponent(UISlider, build_pro_path)
  self.build_info = self:AddComponent(UITextMeshProUGUIEx, build_info_path)
  self.time_text = self:AddComponent(UITextMeshProUGUIEx, time_text_path)
  self.btn_go = self:AddComponent(UIButton, btn_go_path)
  self.btn_go:SetOnClick(function()
    if self.linkInfo then
      GoToUtil.TryJumpToWorld(self.linkInfo)
    end
  end)
  self.move = self:AddComponent(UIImage, move_path)
  self.move_info = self:AddComponent(UITextMeshProUGUIEx, move_info_path)
  self.btn_move = self:AddComponent(UIButton, btn_move_path)
  self.btn_move:SetOnClick(function()
    if self.linkInfo then
      GoToUtil.TryJumpToWorld(self.linkInfo)
    end
  end)
  self.build_pro2 = self:AddComponent(UISlider, build_pro2_path)
  self.build_info2 = self:AddComponent(UITextMeshProUGUIEx, build_info2_path)
  self.btn_move_txt = self:AddComponent(UITextMeshProUGUIEx, btn_txt_path)
  self.btn_move_txt:SetLocalText("2000229")
end

function UILWSeason4MilitaryCenterMove:OnDestroy()
  base.OnDestroy(self)
end

function UILWSeason4MilitaryCenterMove:UpdateData()
  if IsNull(self.gameObject) then
    return
  end
  local meta = DataCenter.AllianceMineManager:GetAllianceMineTemplate(BuildingTypes.SEASON_POWER_CENTER_CARRIER)
  if meta then
    self.name:SetText(meta:GetName())
    self.desc:SetText(meta:GetDescription())
    self.icon:LoadSprite(meta:GetIconPath())
    self.meta = meta
  end
  local theCarrier = DataCenter.AllianceMineManager:GetAllianceStoveCenterCarrier()
  self.theCarrier = theCarrier
  self.buildEndTime = nil
  if theCarrier == nil or theCarrier.status == AllianceMineStatus.FoldUp then
    self.build:SetActive(true)
    self.building:SetActive(false)
    self.move:SetActive(false)
    self.hp_bar:SetActive(false)
    if meta then
      local hasCount = LuaEntry.Resource:GetCntByResType(ResourceType.AllianceStone)
      local needCount = meta:GetBuildCost(ResourceType.AllianceStone)
      if needCount ~= 0 and theCarrier == nil then
        self.res_info:SetValue(hasCount / needCount)
        self.res_info_num:SetText(string.GetFormattedSeparatorNum(hasCount) .. "<color=#F53C3D> - " .. string.GetFormattedSeparatorNum(needCount) .. "</color>")
      else
        self.res_info:SetValue(1)
        self.res_info_num:SetText("")
      end
    end
  elseif theCarrier.status == AllianceMineStatus.Build then
    self.build:SetActive(false)
    self.building:SetActive(true)
    self.move:SetActive(false)
    self.hp_bar:SetActive(false)
    self.buildEndTime = theCarrier:GetBuildEndTime()
    self:Update1000MS()
  else
    self:TryShowMoveTips()
  end
  if theCarrier ~= nil then
    local serverId = theCarrier.srcServerId or theCarrier.curServerId or LuaEntry.Player:GetSourceServerId()
    local posStr = UIUtil.FormatServerPosition(serverId, theCarrier.posV2.x, theCarrier.posV2.y)
    local link = {
      action = "Jump",
      pointId = theCarrier.pointId,
      server = serverId,
      worldId = 0
    }
    local json = rapidjson.encode(link)
    local strLink = string.format("<link=\"%s\"><u>%s</u></link>", base64.encode(json), posStr)
    self.linkInfo = link
    self.build_pos:SetText(strLink)
    self.build_pos:SetActive(true)
  else
    self.build_pos:SetActive(false)
  end
end

function UILWSeason4MilitaryCenterMove:TryShowMoveTips()
  local theStoveCenter = DataCenter.AllianceMineManager:GetAllianceStoveCenter()
  local theCarrier = DataCenter.AllianceMineManager:GetAllianceStoveCenterCarrier()
  if theCarrier ~= nil and theCarrier.status ~= AllianceMineStatus.Ruin then
    self.build:SetActive(false)
    self.building:SetActive(false)
    self.move:SetActive(true)
    self.isInjuried = theCarrier:Injuried()
    if self.isInjuried then
      self.hp_bar:SetActive(true)
      self.hp_bar:SetValue(theCarrier:GetHPRate())
    else
      self.hp_bar:SetActive(false)
    end
    if theStoveCenter == nil or theStoveCenter:Injuried() then
      self.move_info:SetLocalText("season_s2_alliance_building_tips007")
      self.build_pro2:SetActive(false)
    elseif theCarrier == nil or theCarrier:Injuried() then
      self.move_info:SetLocalText("season_s2_alliance_building_tips008")
      self.build_pro2:SetActive(false)
    else
      self.build_pro2:SetActive(true)
      self.build_info2:SetText(string.GetFormattedSeparatorNum(theCarrier.maxHp) .. "/" .. string.GetFormattedSeparatorNum(theCarrier.maxHp))
      self.move_info:SetText("")
    end
  end
end

function UILWSeason4MilitaryCenterMove:Update1000MS()
  if self.buildEndTime and self.buildEndTime > 0 then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.buildEndTime - curTime
    if remainTime <= 0 then
      self.buildEndTime = nil
      self.build_info:SetText("")
      self.build_pro:SetValue(1)
      self:TryShowMoveTips()
      return
    end
    self.build_info:SetText(string.GetFormattedSeparatorNum(toInt(self.theCarrier:GetDurability())) .. "/" .. string.GetFormattedSeparatorNum(self.theCarrier.maxHp))
    self.build_pro:SetValue(self.theCarrier:GetHPRate())
    self.time_text:SetText(Localization:GetString("100238") .. UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
  elseif self.isInjuried then
    self.hp_bar:SetValue(self.theCarrier:GetHPRate())
  elseif self.meta then
    local theCarrier = DataCenter.AllianceMineManager:GetAllianceStoveCenterCarrier()
    if theCarrier == nil then
      local hasCount = LuaEntry.Resource:GetCntByResType(ResourceType.AllianceStone)
      local needCount = self.meta:GetBuildCost(ResourceType.AllianceStone)
      if needCount ~= 0 then
        self.res_info:SetValue(hasCount / needCount)
        self.res_info_num:SetText(string.GetFormattedSeparatorNum(hasCount) .. "<color=#F53C3D> - " .. string.GetFormattedSeparatorNum(needCount) .. "</color>")
      else
        self.res_info:SetValue(1)
        self.res_info_num:SetText("")
      end
    end
  end
end

function UILWSeason4MilitaryCenterMove:GotoBuild()
  if self.linkInfo then
    GoToUtil.TryJumpToWorld(self.linkInfo)
  elseif DataCenter.AllianceBaseDataManager:IsR4orR5() then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeason4CenterCondition, {anim = true}, BuildingTypes.SEASON_POWER_CENTER_CARRIER)
  else
    UIUtil.ShowTipsId(803040)
  end
end

function UILWSeason4MilitaryCenterMove:OnPointerClick(clickPos)
  if self.build_pos == nil then
    return
  end
  local linkId = self.build_pos:TryGetPointerClickLinkID(clickPos)
  if string.IsNullOrEmpty(linkId) then
    return
  end
  GoToUtil.TryJumpToWorld(rapidjson.decode(base64.decode(linkId)))
end

function UILWSeason4MilitaryCenterMove:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceResourceUpdate, self.OnAllianceResourceUpdate)
end

function UILWSeason4MilitaryCenterMove:OnRemoveListener()
  self:RemoveUIListener(EventId.AllianceResourceUpdate, self.OnAllianceResourceUpdate)
  base.OnRemoveListener(self)
end

function UILWSeason4MilitaryCenterMove:OnAllianceResourceUpdate()
end

return UILWSeason4MilitaryCenterMove
