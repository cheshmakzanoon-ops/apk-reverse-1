local base = UIBaseContainer
local SeasonCampDestroyBattleDetailAtk = BaseClass("SeasonCampDestroyBattleDetailAtk", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function SeasonCampDestroyBattleDetailAtk:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function SeasonCampDestroyBattleDetailAtk:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonCampDestroyBattleDetailAtk:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgPDeclareCityIcon = self.viewSkin:AddComponent(self, UIImage, 1)
  self.textPDeclareTimeTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textPDeclareTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textPDeclareBelongAlliance = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.compContentCity = self.viewSkin:AddComponent(self, UIBaseComponent, 5)
  self.compPGoDeclareOccupied = self.viewSkin:AddComponent(self, UIBaseComponent, 6)
  self.textPDeclareOccupied = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.textPDeclareCityName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.textPDeclareLocation = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.btnPDeclareGoto = self.viewSkin:AddComponent(self, UIButton, 10)
  self.btnPDeclareGoto:SetOnClick(function()
    self:OnBtnPDeclareGotoClick()
  end)
  self.textPDeclareGoto = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.btnPAttack = self.viewSkin:AddComponent(self, UIButton, 12)
  self.btnPAttack:SetOnClick(function()
    self:OnBtnPAttackClick()
  end)
  self.compPGoAttack = self.viewSkin:AddComponent(self, UIBaseComponent, 13)
  self.textPDeclareCongratulation = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 14)
  self.textPDeclareAttack = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 15)
  self.compRoot = self.viewSkin:AddComponent(self, UIBaseComponent, 16)
  self.textPDeclareTimeTitle:SetLocalText("season_s5_activity_1200059_desc21")
  self.textPDeclareAttack:SetActive(false)
  self.textPDeclareOccupied:SetLocalText("zonewar_landlord_limit_1017")
end

function SeasonCampDestroyBattleDetailAtk:ComponentDestroy()
  self.viewSkin = nil
  self.imgPDeclareCityIcon = nil
  self.textPDeclareTimeTitle = nil
  self.textPDeclareTime = nil
  self.textPDeclareBelongAlliance = nil
  self.compContentCity = nil
  self.compPGoDeclareOccupied = nil
  self.textPDeclareOccupied = nil
  self.textPDeclareCityName = nil
  self.textPDeclareLocation = nil
  self.btnPDeclareGoto = nil
  self.textPDeclareGoto = nil
  self.btnPAttack = nil
  self.compPGoAttack = nil
  self.textPDeclareCongratulation = nil
  self.textPDeclareAttack = nil
  self.compRoot = nil
end

function SeasonCampDestroyBattleDetailAtk:DataDefine()
end

function SeasonCampDestroyBattleDetailAtk:DataDestroy()
end

function SeasonCampDestroyBattleDetailAtk:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonCampDestroyActRefresh, self.OnSeasonCampDestroyActRefresh)
end

function SeasonCampDestroyBattleDetailAtk:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonCampDestroyActRefresh, self.OnSeasonCampDestroyActRefresh)
  base.OnRemoveListener(self)
end

function SeasonCampDestroyBattleDetailAtk:OnSeasonCampDestroyActRefresh()
  local declareList = DataCenter.SeasonCampDestroyManager:GetDeclareList()
  self:ReInit(declareList)
end

function SeasonCampDestroyBattleDetailAtk:ReInit(data)
  self:ResetUi()
  if self:InitData(data) then
    self:InitUi()
    if self:UpdateData() then
      self:UpdateUi()
    end
    self.compRoot:SetActive(true)
  end
end

function SeasonCampDestroyBattleDetailAtk:ResetUi()
  self.compRoot:SetActive(false)
  self.textPDeclareAttack:SetActive(true)
  self.textPDeclareAttack:SetLocalText("season_s5_activity_1200059_desc19")
end

function SeasonCampDestroyBattleDetailAtk:InitData(data)
  self.Data = data
  if self.Data ~= nil and table.count(self.Data) > 0 then
    self.DeclareInfo = self.Data[1]
    self.CityInfo = DataCenter.AllianceCityTemplateManager:GetTemplate(self.DeclareInfo.cityId)
    self.CityId = self.DeclareInfo.cityId
    self.ServerId = self.DeclareInfo.serverId
    self.PointId = self.CityInfo:GetPointId()
    self.EndTime = self.DeclareInfo.endTime
    return true
  end
  return false
end

function SeasonCampDestroyBattleDetailAtk:InitUi()
  self.textPDeclareAttack:SetActive(false)
  local isWin = self.DeclareInfo.result == 1
  self.compPGoDeclareOccupied:SetActive(isWin)
  self.textPDeclareCongratulation:SetActive(isWin)
  self.btnPDeclareGoto:SetActive(not isWin)
  self.textPDeclareBelongAlliance:SetActive(false)
  if not isWin and self.DeclareInfo.def ~= nil then
    self.textPDeclareBelongAlliance:SetActive(true)
    local def = self.DeclareInfo.def
    local allianceName = string.format("#%s [%s] %s", def.serverId, def.abbr, def.name)
    self.textPDeclareBelongAlliance:SetText(allianceName)
  end
  self.textPDeclareGoto:SetLocalText("240502")
  self.textPDeclareCityName:SetLocalText("310128", self.CityInfo.level, self.CityInfo:GetName())
  self.imgPDeclareCityIcon:LoadSpriteAsync(self.CityInfo:GetIconPath(false))
  self.textPDeclareLocation:SetText(string.format("#%s (X:%s Y:%s)", self.DeclareInfo.serverId, self.CityInfo.pos.x, self.CityInfo.pos.y))
  self:RefreshAttackBtnState()
end

function SeasonCampDestroyBattleDetailAtk:RefreshAttackBtnState()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local startTime = self.DeclareInfo.startTime
  local endTime = self.DeclareInfo.endTime
  local showAttackBtn = curTime >= startTime and curTime <= endTime
  self.btnPDeclareGoto:SetActive(not showAttackBtn)
  self.btnPAttack:SetActive(showAttackBtn)
  self.compPGoAttack:SetActive(showAttackBtn)
end

function SeasonCampDestroyBattleDetailAtk:UpdateData()
end

function SeasonCampDestroyBattleDetailAtk:UpdateUi()
end

function SeasonCampDestroyBattleDetailAtk:Update1000MS()
  if self.EndTime then
    local deltaTime = self.EndTime - UITimeManager:GetInstance():GetServerTime()
    if 0 < deltaTime then
      local showTime = UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime)
      self.textPDeclareTime:SetText(showTime)
    else
      self.textPDeclareTime:SetText("")
    end
  end
end

function SeasonCampDestroyBattleDetailAtk:OnBtnPDeclareGotoClick()
  if self.CityInfo ~= nil then
    self.CityInfo:JumpTo()
  end
end

function SeasonCampDestroyBattleDetailAtk:OnBtnPAttackClick()
  if self.CityInfo ~= nil then
    self.CityInfo:JumpTo()
  end
end

return SeasonCampDestroyBattleDetailAtk
