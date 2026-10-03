local UILWTrainBattleEndScienceItemRender = BaseClass("UILWTrainBattleEndScienceItemRender", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local special_bg_path = "ScienceBg/SpecialBg"
local science_icon_path = "ScienceBg/ScienceIcon"
local des_text_path = "DesText "
local go_to_btn_path = "GoToBtn"
local ATTACK_PROPERTY = 130002100
local ATTACK_ADDITIONAL = 130004100

function UILWTrainBattleEndScienceItemRender:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UILWTrainBattleEndScienceItemRender:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWTrainBattleEndScienceItemRender:ComponentDefine()
  self.special_bg = self:AddComponent(UIImage, special_bg_path)
  self.science_icon = self:AddComponent(UIImage, science_icon_path)
  self.des_text = self:AddComponent(UIText, des_text_path)
  self.go_to_btn = self:AddComponent(UIButton, go_to_btn_path)
  self.go_to_btn:SetOnClick(function()
    self:GoToBtnClick()
  end)
end

function UILWTrainBattleEndScienceItemRender:ComponentDestroy()
  self.special_bg = nil
  self.science_icon = nil
  self.des_text = nil
  self.go_to_btn = nil
end

function UILWTrainBattleEndScienceItemRender:SetData(scienceId)
  self.scienceId = scienceId
  self.template = DataCenter.ScienceManager:GetScienceTemplate(scienceId)
  if self.template ~= nil then
    self.science_icon:LoadSprite(string.format(LoadPath.UILWScience, self.template.icon))
    self.special_bg:SetActive(self.template.is_special > 0)
    local curLevel = DataCenter.ScienceManager:GetScienceLevel(scienceId)
    local maxLevel = DataCenter.ScienceManager:GetScienceMaxLevel(scienceId)
    local effectId, effectValue = 0, 0
    if curLevel == 0 then
      local maxLevelTemplate = DataCenter.ScienceTemplateManager:GetScienceTemplate(self.scienceId, maxLevel)
      if maxLevelTemplate ~= nil and not table.IsNullOrEmpty(maxLevelTemplate.effect) then
        effectId = tonumber(maxLevelTemplate.effect[1].effectId)
        effectValue = tonumber(maxLevelTemplate.effect[1].effectValue)
      end
    elseif not table.IsNullOrEmpty(self.template.effect) then
      effectId = tonumber(self.template.effect[1].effectId)
      effectValue = LuaEntry.Effect:GetGameEffect(effectId)
    end
    if effectId == 0 and effectValue == 0 then
      self.des_text:SetText("")
    else
      local buffValueStr = HeroUtils.GetFormattedPropertyValue(effectId, effectValue)
      if self.scienceId == ATTACK_PROPERTY then
        self.des_text:SetText(Localization:GetString("trade_person_tips1015", buffValueStr))
      elseif self.scienceId == ATTACK_ADDITIONAL then
        self.des_text:SetText(Localization:GetString("trade_person_tips1016", buffValueStr))
      end
    end
  end
end

function UILWTrainBattleEndScienceItemRender:GoToBtnClick()
  self.view.ctrl:CloseSelf()
  
  local function afterSwitchScene()
    GoToUtil.GotoScience(self.scienceId, nil, nil, true)
  end
  
  DataCenter.LWBattleManager:Exit(afterSwitchScene, "GoToScience")
end

return UILWTrainBattleEndScienceItemRender
