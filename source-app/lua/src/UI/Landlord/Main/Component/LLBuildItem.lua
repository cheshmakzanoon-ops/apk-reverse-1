local base = UIAsyncContainer
local LLBuildItem = BaseClass("LLBuildItem", UIAsyncContainer)
local Localization = CS.GameEntry.Localization
local ActMgr = DataCenter.LandlordMgr

function LLBuildItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LLBuildItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LLBuildItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.text = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.btnIcon = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnIcon:SetOnClick(function()
    self:OnBtnIconClick()
  end)
  self.btnFlag = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnFlag:SetOnClick(function()
    self:OnBtnFlagClick()
  end)
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 4)
end

function LLBuildItem:ComponentDestroy()
  self.viewSkin = nil
  self.text = nil
  self.btnIcon = nil
  self.btnFlag = nil
  self.imgIcon = nil
end

function LLBuildItem:DataDefine()
end

function LLBuildItem:DataDestroy()
  self.template = nil
  self.stage = 0
end

function LLBuildItem:OnAddListener()
  base.OnAddListener(self)
end

function LLBuildItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LLBuildItem:OnBtnIconClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if self.template == nil then
    return
  end
  local cityConfig = ActMgr:GetCityTemplate(self.template.city_id)
  local type = (cityConfig ~= nil and cityConfig.sub_type or 1) % 100
  type = LLConst.RuleType.Build * 10 + type
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILLRule, {anim = true}, type, self.template.city_id)
end

function LLBuildItem:OnBtnFlagClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if self.template == nil then
    return
  end
  ActMgr:JumpToCity(self.template.city_id)
end

function LLBuildItem:SetTemplate(template, stage)
  self.template = template
  self.stage = stage
  self:RefreshView()
end

function LLBuildItem:UpdateData()
  if self.template == nil then
    return
  end
  self:SetAnchoredPositionXY(self.template.position[1] or 0, self.template.position[2] or 0, true)
  local cfgId = self.template.city_id
  local cityConfig = ActMgr:GetCityTemplate(cfgId)
  local name = self.template.name
  if string.IsNullOrEmpty(name) then
    name = cityConfig ~= nil and cityConfig.name or ""
  else
    name = Localization:GetString(name)
  end
  local value = ActMgr:GetActBattleBuildValue(cfgId)
  self.imgIcon:LoadSpriteAsyncWithCallback(1 <= value and self.template.destroy_icon or self.template.icon, function()
    if self.imgIcon ~= nil then
      self.imgIcon:SetAspectSize(120)
    end
  end)
  if self.template.show_hp == 1 then
    name = string.format([[
%s
%s]], name, string.GetFormattedPercentStr(value))
  end
  self.text:SetText(name)
  local flag = false
  if ActMgr:InBattleTime() then
    local curWeek = ActMgr:GetCurWeek()
    local unlockWeek = cityConfig ~= nil and cityConfig.unlock_week or 0
    if 0 < curWeek and curWeek >= unlockWeek and value < 1 then
      flag = true
    end
  end
  self.btnFlag:SetActive(flag)
end

return LLBuildItem
