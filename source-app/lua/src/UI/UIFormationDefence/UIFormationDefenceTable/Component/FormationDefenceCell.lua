local FormationDefenceCell = BaseClass("FormationDefenceCell", UIBaseContainer)
local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
local base = UIBaseContainer
local FormationDefenceHeroItem = require("UI.UIFormationDefence.UIFormationDefenceTable.Component.FormationDefenceHeroItem")
local FormationHeroAdd = require("UI.UIFormationDefence.UIFormationDefenceTable.Component.FormationHeroAdd")
local Localization = CS.GameEntry.Localization
local formation_name_path = "name"
local attack_num_path = "attack_num"
local defence_num_path = "defence_num"
local hero_1_obj_path = "hero1"
local hero_2_obj_path = "hero2"
local hero_3_obj_path = "hero3"
local hero_4_obj_path = "hero4"
local hero_5_obj_path = "hero5"
local select_img_path = "selectImg"
local edit_btn_path = "editBtn"
local attack_obj_path = "attack"
local defence_obj_path = "defence"

local function OnCreate(self)
  base.OnCreate(self)
  self.playerHeadIcon = self:AddComponent(UIPlayerHead, "UIPlayerHead/HeadIcon")
  self.formation_name = self:AddComponent(UIText, formation_name_path)
  self.formation_capacity = self:AddComponent(UIText, "capacityNum/capacity")
  self.formation_capacity:SetLocalText(GameDialogDefine.FORMATION_CAPACITY)
  self.formation_capacity_num = self:AddComponent(UIText, "capacityNum")
  self.attack_num = self:AddComponent(UIText, attack_num_path)
  self.defence_num = self:AddComponent(UIText, defence_num_path)
  self.select_img = self:AddComponent(UIImage, select_img_path)
  self.select_img:SetActive(false)
  self.heroIndexObj = {}
  local index1 = self:AddComponent(UIBaseContainer, hero_1_obj_path)
  self.heroIndexObj[1] = index1
  local index2 = self:AddComponent(UIBaseContainer, hero_2_obj_path)
  self.heroIndexObj[2] = index2
  local index3 = self:AddComponent(UIBaseContainer, hero_3_obj_path)
  self.heroIndexObj[3] = index3
  local index4 = self:AddComponent(UIBaseContainer, hero_4_obj_path)
  self.heroIndexObj[4] = index4
  local index5 = self:AddComponent(UIBaseContainer, hero_5_obj_path)
  self.heroIndexObj[5] = index5
  self.attack_obj = self:AddComponent(UIButton, attack_obj_path)
  self.attack_obj:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnAttackClick()
  end)
  self.defence_obj = self:AddComponent(UIButton, defence_obj_path)
  self.defence_obj:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnDefenceClick()
  end)
  self.edit_btn = self:AddComponent(UIButton, edit_btn_path)
  self.edit_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnEditClick()
  end)
  self.kick_btn = self:AddComponent(UIButton, "kickBtn")
  self.kick_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnKickClick()
  end)
  self.model = {}
end

local function Clear(self)
  table.walk(self.heroIndexObj, function(k, v)
    v:RemoveComponents(FormationDefenceHeroItem)
    v:RemoveComponents(FormationHeroAdd)
  end)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
    self.model = {}
  end
end

local function OnDestroy(self)
  Clear(self)
  base.OnDestroy(self)
end

local function CreateHeroByIndex(self, index, heroData)
  if heroData[index] ~= nil then
    if self.model[index] == nil then
      self.model[index] = self:GameObjectInstantiateAsync(UIAssets.FormationDefenceHeroItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.heroIndexObj[index].transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
        go.name = "FormationDefenceHeroItem" .. index
        local cell = self.heroIndexObj[index]:AddComponent(FormationDefenceHeroItem, go.name)
        cell:InitData(heroData[index], index, self.uuid)
      end)
    else
    end
  else
    if self.model[index] == nil then
      self.model[index] = self:GameObjectInstantiateAsync(UIAssets.FormationHeroAdd, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.heroIndexObj[index].transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
        go.name = "FormationHeroAdd" .. index
        local cell = self.heroIndexObj[index]:AddComponent(FormationHeroAdd, go.name)
        local maxNum = self.view.ctrl:GetMaxHeroNumByFormationUuid(self.uuid)
        cell:RefreshData(maxNum < index, self.formationIndex, index, self.uuid)
      end)
    else
    end
  end
end

local function RefreshData(self, formation, index)
  Clear(self)
  self.uuid = formation.uuid
  self.formationIndex = index
  if index == 0 then
    self.formation_name:SetLocalText(GameDialogDefine.MY_DEFENCE_FORMATION)
    local heroData = self.view.ctrl:GetCurHeroData(self.uuid)
    for i = 1, 5 do
      self:CreateHeroByIndex(i, heroData)
    end
    self.formation_capacity_num:SetText(string.GetFormattedSeperatorNum(formation:GetTotalCapacity()))
  else
    self.formation_name:SetText(formation.ownerName)
    self.playerHeadIcon:SetData(formation.ownerUid, formation.ownerIcon, formation.ownerIconVer)
    self.formation_capacity_num:SetText(string.GetFormattedSeperatorNum(formation.power))
    local heroData = {}
    for k, v in pairs(formation.armyInfos.heros) do
      heroData[v.index] = v
    end
    for i = 1, 5 do
      self:CreateHeroByIndex(i, heroData)
    end
  end
end

local function OnSelectHeroFinish(self, index)
end

local function OnSelectClick(self)
  self.view:OnSelectClick(self.uuid)
end

local function SetSelectState(self, isSelect)
  self.select_img:SetActive(isSelect)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAttackClick(self)
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local position = self.attack_obj.transform.position + Vector3.New(0, 30, 0) * scaleFactor
  local param = UIHeroTipView.Param.New()
  param.content = Localization:GetString("220097")
  param.dir = UIHeroTipView.Direction.ABOVE
  param.defWidth = 180
  param.pivot = 0.5
  param.position = position
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

local function OnDefenceClick(self)
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local position = self.defence_obj.transform.position + Vector3.New(0, 30, 0) * scaleFactor
  local param = UIHeroTipView.Param.New()
  param.content = Localization:GetString("220101")
  param.dir = UIHeroTipView.Direction.ABOVE
  param.defWidth = 180
  param.pivot = 0.5
  param.position = position
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

local function OnEditClick(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPVPFormation, {anim = true}, EnterHeroSquadPanelWay.Gate)
end

local function OnKickClick(self)
end

FormationDefenceCell.OnCreate = OnCreate
FormationDefenceCell.OnDestroy = OnDestroy
FormationDefenceCell.RefreshData = RefreshData
FormationDefenceCell.OnEnable = OnEnable
FormationDefenceCell.OnDisable = OnDisable
FormationDefenceCell.OnSelectHeroFinish = OnSelectHeroFinish
FormationDefenceCell.CreateHeroByIndex = CreateHeroByIndex
FormationDefenceCell.OnSelectClick = OnSelectClick
FormationDefenceCell.SetSelectState = SetSelectState
FormationDefenceCell.OnAttackClick = OnAttackClick
FormationDefenceCell.OnDefenceClick = OnDefenceClick
FormationDefenceCell.OnEditClick = OnEditClick
FormationDefenceCell.OnKickClick = OnKickClick
return FormationDefenceCell
