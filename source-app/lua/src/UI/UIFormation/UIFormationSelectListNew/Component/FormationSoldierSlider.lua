local FormationSoldierSlider = BaseClass("FormationSoldierSlider", UIBaseContainer)
local base = UIBaseContainer
local slider_path = "Slider"
local soldier_num_path = "layoutRoot/soldierNum"
local tip_btn_path = "layoutRoot/tipButton"
local tipBtnBuleBg_path = "layoutRoot/tipButton/Common_btn_buleTip"
local tipBtnRedBg_path = "layoutRoot/tipButton/Common_btn_redTip"
local titleText_path = "SoldierTitle"
local build_icon_path = "stateBtn/BuildIcon"
local state_btn_path = "stateBtn"

function FormationSoldierSlider:OnCreate()
  base.OnCreate(self)
  self.state_btn = self:AddComponent(UIButton, state_btn_path)
  self.state_btn:SetOnClick(function()
    if self.theView then
      self.theView:SwitchFormationSoldier()
    end
  end)
  self.soldier_icon = self:AddComponent(UIImage, build_icon_path)
  self.tip_btn = self:AddComponent(UIButton, tip_btn_path)
  self.tip_btn:SetOnClick(function()
    self:OnClickTipBtn()
  end)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.soldier_num = self:AddComponent(UIText, soldier_num_path)
  self.btnRedBg = self.transform:Find(tipBtnRedBg_path)
  self.btnBuleBg = self.transform:Find(tipBtnBuleBg_path)
  self.titleText = self:AddComponent(UIText, titleText_path)
end

function FormationSoldierSlider:OnDestroy()
  self.state_btn = nil
  base.OnDestroy(self)
end

function FormationSoldierSlider:SetData(theView, data, theLastUseSoldierType)
  self.data = data
  self.theView = theView
  self.theLastUseSoldierType = theLastUseSoldierType
  self.titleText:SetLocalText(458558)
  self:RefeshSoldierNumAndSlider()
  if theLastUseSoldierType == SoldierType.Mummy then
    self.soldier_icon:LoadSprite("Assets/Main/SeasonRes/Shared/Sprites/UIMummy/ljq_saijis3_chuzheng_munaiyi.png")
  else
    self.soldier_icon:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/dl_zhujiemian_chuzheng_yingxiong.png")
  end
end

function FormationSoldierSlider:RefreshTipBtn()
  local flag = false
  if self.data.curSoldierNum < self.data.totalSoldierNum then
    flag = true
  end
  self.btnRedBg.gameObject:SetActive(flag)
  self.btnBuleBg.gameObject:SetActive(not flag)
end

function FormationSoldierSlider:RefeshSoldierNumAndSlider()
  local tempValue = math.min(1, self.data.curSoldierNum / self.data.totalSoldierNum)
  self.slider:SetValue(tempValue)
  self.soldier_num:SetText(string.GetFormattedSeparatorNum(math.floor(self.data.curSoldierNum)) .. "/" .. string.GetFormattedSeparatorNum(math.floor(self.data.totalSoldierNum)))
  self:RefreshTipBtn()
end

function FormationSoldierSlider:CreateParam(totalSoldierNum, curSoldierNum, mySoldiers, armyId)
  local data = {}
  data.totalSoldierNum = tonumber(totalSoldierNum)
  data.curSoldierNum = tonumber(curSoldierNum)
  data.soldierList = mySoldiers
  data.mySoldierMorale = self:CalculateSoldierMorale(mySoldiers, false)
  data.armySoldierMorale = 0
  if armyId ~= nil and armyId ~= 0 then
    local amryConfig = DataCenter.LWArmyTemplateManager:TryGetArmyTemplate(armyId)
    local armySoldierData = amryConfig.line_up
    for k, v in pairs(armySoldierData) do
      data.armySoldierMorale = data.armySoldierMorale + self:CalculateSoldierMorale(v.soldierData, true)
    end
  end
  return data
end

function FormationSoldierSlider:CalculateSoldierMorale(soldierList, isArmy)
  local totalMorale = 0
  local oneTemplate = {}
  if not isArmy then
    for k, v in pairs(soldierList) do
      oneTemplate = LocalController:instance():getLine(TableName.LW_Soldier, tostring(v.id))
      local value = oneTemplate:getValue("level_factor")
      if value then
        local heroData = DataCenter.HeroDataManager:GetHeroByUuid(v.heroId)
        local addEffect = 0
        if heroData ~= nil then
          addEffect = heroData:GetEffectNum(HeroEffectDefine.HeroSoldierMorale)
        end
        totalMorale = totalMorale + value * (1 + addEffect) * v.count
      end
    end
  else
    oneTemplate = LocalController:instance():getLine(TableName.LW_Soldier, tostring(soldierList.metaId))
    local value = oneTemplate:getValue("level_factor")
    totalMorale = totalMorale + value * soldierList.num
  end
  return totalMorale
end

function FormationSoldierSlider:OnClickTipBtn()
  local postion = self.tip_btn.transform.position
  UIUtil:ShowFightSoldierTips(postion, -20, 25, 180, nil, self.data, nil)
end

function FormationSoldierSlider:ShowTipBtn(flag)
  self.tip_btn:SetActive(flag)
end

return FormationSoldierSlider
