local UILWTrainDepartureScienceTipsView = BaseClass("UILWTrainDepartureScienceTipsView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local panel_path = "Panel"
local science_des_text_path = "Content/Bg/ScienceDesText"
local go_to_btn_path = "Content/Bg/GoToBtn"
local img_arrow_path = "Content/ImgArrow"
local BASIC_RESOURCE_PRODUCT_PROMOTION = 130001200
local DEFENSE_PROPERTY = 130002300
local ARRIVAL_SPEED_PROMOTION = 130003200
local DEFENSE_ADDITIONAL = 130004300
local FAILURE_LIMITED_TIMES = 130006100
local REINDEER_TRUCKS = 130006300

function UILWTrainDepartureScienceTipsView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.panelParam = self:GetUserData()
  self:ReInit()
end

function UILWTrainDepartureScienceTipsView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWTrainDepartureScienceTipsView:ComponentDefine()
  self.panel = self:AddComponent(UIButton, panel_path)
  self.panel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.science_des_text = self:AddComponent(UIText, science_des_text_path)
  self.go_to_btn = self:AddComponent(UIButton, go_to_btn_path)
  self.go_to_btn:SetOnClick(function()
    self:GoToBtnClick()
  end)
  self.img_arrow = self:AddComponent(UIImage, img_arrow_path)
end

function UILWTrainDepartureScienceTipsView:ComponentDestroy()
  self.panel = nil
  self.science_des_text = nil
  self.go_to_btn = nil
  self.img_arrow = nil
end

function UILWTrainDepartureScienceTipsView:ReInit()
  local arrowX = self.panelParam.position.x
  if self.panelParam.deltaX then
    arrowX = arrowX + self.panelParam.deltaX
  end
  local arrowPos = self.img_arrow:GetPosition()
  self.img_arrow:SetPositionXYZ(arrowX, arrowPos.y, 0)
  local curLevel = DataCenter.ScienceManager:GetScienceLevel(self.panelParam.scienceId)
  local maxLevel = DataCenter.ScienceManager:GetScienceMaxLevel(self.panelParam.scienceId)
  local template = DataCenter.ScienceManager:GetScienceTemplate(self.panelParam.scienceId)
  if template then
    local effectId, effectValue = 0, 0
    if curLevel == 0 then
      local maxLevelTemplate = DataCenter.ScienceTemplateManager:GetScienceTemplate(self.panelParam.scienceId, maxLevel)
      if maxLevelTemplate ~= nil and not table.IsNullOrEmpty(maxLevelTemplate.effect) then
        effectId = tonumber(maxLevelTemplate.effect[1].effectId)
        effectValue = tonumber(maxLevelTemplate.effect[1].effectValue)
      end
    elseif not table.IsNullOrEmpty(template.effect) then
      effectId = tonumber(template.effect[1].effectId)
      effectValue = LuaEntry.Effect:GetGameEffect(effectId)
    end
    if effectId == 0 and effectValue == 0 then
      self.science_des_text:SetText("")
    else
      self.science_des_text:SetText(self:GetScienceDes(effectId, effectValue))
    end
  end
  self.go_to_btn:SetActive(curLevel < maxLevel)
end

function UILWTrainDepartureScienceTipsView:GetScienceDes(effectId, effectValue)
  local key = ""
  if self.panelParam.scienceId == BASIC_RESOURCE_PRODUCT_PROMOTION then
    key = "trade_person_tips1014"
  elseif self.panelParam.scienceId == DEFENSE_PROPERTY then
    key = "trade_person_tips1017"
  elseif self.panelParam.scienceId == ARRIVAL_SPEED_PROMOTION then
    key = "trade_person_tips1004"
  elseif self.panelParam.scienceId == DEFENSE_ADDITIONAL then
    key = "trade_person_tips1002"
  elseif self.panelParam.scienceId == FAILURE_LIMITED_TIMES then
    key = "trade_person_tips1001"
  elseif self.panelParam.scienceId == REINDEER_TRUCKS then
    key = "trade_person_tips1019"
  end
  if not string.IsNullOrEmpty(key) then
    local buffValueStr = HeroUtils.GetFormattedPropertyValue(effectId, effectValue)
    return Localization:GetString(key, buffValueStr)
  end
  return key
end

function UILWTrainDepartureScienceTipsView:GoToBtnClick()
  self.ctrl:CloseSelf()
  GoToUtil.GotoScience(self.panelParam.scienceId, nil, nil, true)
end

return UILWTrainDepartureScienceTipsView
