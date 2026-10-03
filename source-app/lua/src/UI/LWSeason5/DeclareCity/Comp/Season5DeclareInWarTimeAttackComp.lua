local p_content_attack_path = "p_content_attack"
local p_text_declare_attack_path = "p_text_declare_attack"
local p_text_declare_time_title_path = "p_content_attack/p_text_declare_time_title"
local p_text_declare_time_path = "p_content_attack/p_text_declare_time"
local p_text_declare_belong_alliance_path = "p_content_attack/p_text_declare_belong_alliance"
local p_img_declare_city_icon_path = "p_content_attack/p_img_declare_city_icon"
local p_go_declare_occupied_path = "p_content_attack/content_city/p_go_declare_occupied"
local p_text_declare_occupied_path = "p_content_attack/content_city/p_go_declare_occupied/p_text_declare_occupied"
local p_text_declare_city_name_path = "p_content_attack/content_city/p_text_declare_city_name"
local p_text_declare_location_path = "p_content_attack/content_city/p_text_declare_location"
local p_btn_declare_goto_path = "p_content_attack/content_city/p_btn_declare_goto"
local p_text_declare_goto_path = "p_content_attack/content_city/p_btn_declare_goto/img_btn/p_text_declare_goto"
local p_text_declare_congratulation_path = "p_content_attack/p_text_declare_congratulation"
local base = UIBaseContainer
local Season5DeclareInWarTimeAttackComp = BaseClass("Season5DeclareInWarTimeAttackComp", UIBaseContainer)

function Season5DeclareInWarTimeAttackComp:ComponentDefine()
  self.p_content_attack = self:AddComponent(UIBaseContainer, p_content_attack_path)
  self.p_text_declare_attack = self:AddComponent(UITextMeshProUGUIEx, p_text_declare_attack_path)
  self.p_text_declare_time_title = self:AddComponent(UITextMeshProUGUIEx, p_text_declare_time_title_path)
  self.p_text_declare_time = self:AddComponent(UITextMeshProUGUIEx, p_text_declare_time_path)
  self.p_text_declare_belong_alliance = self:AddComponent(UITextMeshProUGUIEx, p_text_declare_belong_alliance_path)
  self.p_img_declare_city_icon = self:AddComponent(UIImage, p_img_declare_city_icon_path)
  self.p_go_declare_occupied = self:AddComponent(UIBaseContainer, p_go_declare_occupied_path)
  self.p_text_declare_occupied = self:AddComponent(UITextMeshProUGUIEx, p_text_declare_occupied_path)
  self.p_text_declare_city_name = self:AddComponent(UITextMeshProUGUIEx, p_text_declare_city_name_path)
  self.p_text_declare_location = self:AddComponent(UITextMeshProUGUIEx, p_text_declare_location_path)
  self.p_btn_declare_goto = self:AddComponent(UIButton, p_btn_declare_goto_path)
  self.p_btn_declare_goto:SetOnClick(BindCallback(self, self.OnGotoClicked))
  self.p_text_declare_goto = self:AddComponent(UITextMeshProUGUIEx, p_text_declare_goto_path)
  self.p_text_declare_congratulation = self:AddComponent(UITextMeshProUGUIEx, p_text_declare_congratulation_path)
end

function Season5DeclareInWarTimeAttackComp:ComponentDestroy()
  self.p_content_attack = nil
  self.p_text_declare_attack = nil
  self.p_text_declare_time_title = nil
  self.p_text_declare_time = nil
  self.p_text_declare_belong_alliance = nil
  self.p_img_declare_city_icon = nil
  self.p_go_declare_occupied = nil
  self.p_text_declare_occupied = nil
  self.p_text_declare_city_name = nil
  self.p_text_declare_location = nil
  self.p_btn_declare_goto = nil
  self.p_text_declare_goto = nil
  self.p_text_declare_congratulation = nil
end

function Season5DeclareInWarTimeAttackComp:DataDefine()
end

function Season5DeclareInWarTimeAttackComp:DataDestroy()
end

function Season5DeclareInWarTimeAttackComp:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function Season5DeclareInWarTimeAttackComp:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function Season5DeclareInWarTimeAttackComp:OnAddListener()
  base.OnAddListener(self)
end

function Season5DeclareInWarTimeAttackComp:OnRemoveListener()
  base.OnRemoveListener(self)
end

function Season5DeclareInWarTimeAttackComp:ReInit(data)
  self:ResetUi()
  if self:InitData(data) then
    self:InitUi()
    if self:UpdateData() then
      self:UpdateUi()
    end
  end
end

function Season5DeclareInWarTimeAttackComp:ResetUi()
  self.p_content_attack:SetActive(false)
  self.p_text_declare_attack:SetActive(true)
  self.p_text_declare_attack:SetLocalText("season_s5_activity_1200059_desc19")
end

function Season5DeclareInWarTimeAttackComp:InitData(data)
  self.Data = data
  local info = DataCenter.SeasonDataManager.CrossDeclareWarInfo
  if info ~= nil and table.count(info.declareList) > 0 then
    self.DeclareInfo = info.declareList[1]
    self.CityInfo = DataCenter.AllianceCityTemplateManager:GetTemplate(self.DeclareInfo.cityId)
    self.CityId = self.DeclareInfo.cityId
    self.ServerId = self.DeclareInfo.serverId
    self.PointId = self.CityInfo:GetPointId()
    self.CityInfo = self.CityInfo
    self.EndTime = self.DeclareInfo.endTime
    return true
  end
  return false
end

function Season5DeclareInWarTimeAttackComp:InitUi()
  if self.DeclareInfo.result == 2 then
    return
  end
  self.p_content_attack:SetActive(true)
  self.p_text_declare_attack:SetActive(false)
  local isWin = self.DeclareInfo.result == 1
  self.p_go_declare_occupied:SetActive(isWin)
  self.p_text_declare_congratulation:SetActive(isWin)
  self.p_btn_declare_goto:SetActive(not isWin)
  self.p_text_declare_belong_alliance:SetActive(false)
  if self.DeclareInfo.result ~= 1 and self.DeclareInfo.def ~= nil then
    self.p_text_declare_belong_alliance:SetActive(true)
    local def = self.DeclareInfo.def
    local allianceName = string.format("#%s [%s] %s", def.serverId, def.abbr, def.name)
    self.p_text_declare_belong_alliance:SetText(allianceName)
  end
  self.p_text_declare_goto:SetLocalText("240502")
  self.p_text_declare_city_name:SetLocalText("310128", self.CityInfo.level, self.CityInfo:GetName())
  self.p_img_declare_city_icon:LoadSpriteAsync(self.CityInfo:GetIconPath(false))
  self.p_text_declare_location:SetText(string.format("#%s (X:%s Y:%s)", self.DeclareInfo.serverId, self.CityInfo.pos.x, self.CityInfo.pos.y))
end

function Season5DeclareInWarTimeAttackComp:UpdateData()
end

function Season5DeclareInWarTimeAttackComp:UpdateUi()
end

function Season5DeclareInWarTimeAttackComp:Update1000MS()
  if self.EndTime then
    local deltaTime = self.EndTime - UITimeManager:GetInstance():GetServerTime()
    if 0 < deltaTime then
      local showTime = UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime)
      self.p_text_declare_time:SetText(showTime)
    else
      self.p_text_declare_time:SetText("")
    end
  end
end

function Season5DeclareInWarTimeAttackComp:OnGotoClicked()
  if self.CityInfo ~= nil then
    self.CityInfo:JumpTo()
  end
end

return Season5DeclareInWarTimeAttackComp
