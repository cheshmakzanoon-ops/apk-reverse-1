local base = UIAsyncContainer
local LLDetailSubCity = BaseClass("LLDetailSubCity", UIAsyncContainer)
local Localization = CS.GameEntry.Localization
local ActMgr = DataCenter.LandlordMgr

function LLDetailSubCity:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LLDetailSubCity:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LLDetailSubCity:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgBg = self.viewSkin:AddComponent(self, UIImage, 1)
  self.btnSkillIcon = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnSkillIcon:SetOnClick(function()
    self:OnBtnSkillIconClick()
  end)
  self.textPos = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.btnBuildingIcon = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnBuildingIcon:SetOnClick(function()
    self:OnBtnBuildingIconClick()
  end)
  self.btnPosText = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnPosText:SetOnClick(function()
    self:OnBtnPosTextClick()
  end)
end

function LLDetailSubCity:ComponentDestroy()
  self.viewSkin = nil
  self.imgBg = nil
  self.btnSkillIcon = nil
  self.textPos = nil
  self.textTime = nil
  self.btnBuildingIcon = nil
  self.btnPosText = nil
end

function LLDetailSubCity:DataDefine()
end

function LLDetailSubCity:DataDestroy()
  self.data = nil
end

function LLDetailSubCity:OnAddListener()
  base.OnAddListener(self)
end

function LLDetailSubCity:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LLDetailSubCity:OnBtnSkillIconClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
end

function LLDetailSubCity:OnBtnBuildingIconClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if self.data == nil then
    return
  end
  ActMgr:JumpToCity(self.data.cityId)
end

function LLDetailSubCity:OnBtnPosTextClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if self.data == nil then
    return
  end
  ActMgr:JumpToCity(self.data.cityId)
end

function LLDetailSubCity:SetData(data)
  self.data = data
  self:RefreshView()
end

function LLDetailSubCity:UpdateData()
  if self.data == nil then
    return
  end
  local data = self.data
  ActMgr:SetDetailSubCityShow(data, self.imgBg, self.textPos)
  local buffId = self.data.buffId
  local line = 0 < buffId and LocalController:instance():getLine(TableName.StatusTab, buffId) or nil
  local haveBuff = line ~= nil and 0 < self:GetBuffRemainTime()
  self.btnSkillIcon:SetActive(haveBuff)
  self.textTime:SetActive(haveBuff)
  if haveBuff then
    local icon = line:getValue("icon")
    self.btnSkillIcon:LoadSpriteAuto(icon)
  end
  local template = ActMgr:GetCityTemplate(data.cityId)
  if template ~= nil then
    local icon = data.state == LLConst.ZWLBuildingState.RUIN and template.ruins_icon or template:GetIconPath()
    self.btnBuildingIcon:LoadSpriteAuto(icon)
    self.btnBuildingIcon:SetAspectSize(150)
    local cityPos = template.pos
    self.textPos:SetLocalText(300015, cityPos.x, cityPos.y)
  end
  self:Update1000MS()
end

function LLDetailSubCity:GetBuffRemainTime()
  local curSec = UITimeManager:GetInstance():GetServerSeconds()
  local time = math.max(0, self.data.refreshBuffTime / 1000 - curSec)
  return time
end

function LLDetailSubCity:Update1000MS()
  if self.data == nil or not self.textTime:GetActive() then
    return
  end
  local time = self:GetBuffRemainTime()
  self.textTime:SetText(UITimeManager:GetInstance():SecondToFmtStringWithoutDay(time))
  if time == 0 then
    self.btnSkillIcon:SetActive(false)
    self.textTime:SetActive(false)
  end
end

return LLDetailSubCity
