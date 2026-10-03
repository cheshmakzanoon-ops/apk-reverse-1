local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
local FormationShareCell = require("UI.UIFormationShare.Component.FormationShareCell")
local CampDetailItem = require("UI.UIFormation.UIFormationTableNew.Component.CampDetailItem")
local UIFormationShareView = BaseClass("UIFormationShareView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local title_path = "UICommonPopUpTitle/Common_img_title/titleText"
local return_btn_path = "UICommonPopUpTitle/panel"
local close_btn_path = "UICommonPopUpTitle/CloseBtn"
local soldier_btn_path = "layout/numObj"
local atk_btn_path = "layout/attackObj"
local def_btn_path = "layout/defenceObj"
local soldier_txt_path = "layout/numObj/Num"
local atk_txt_path = "layout/attackObj/attackNum"
local def_txt_path = "layout/defenceObj/defenceNum"
local atk_icon_path = "layout/attackObj/attackIcon"
local def_icon_path = "layout/defenceObj/defenceIcon"
local soldier_icon_path = "layout/numObj/numIcon"
local camp_btn_path = "campBtn"
local camp_icon_path = "campBtn/scaleNode/campIcon"
local camp_des_path = "campBtn/scaleNode/campDesText"
local camp_num_path = "campBtn/scaleNode/campDesText/campText"
local hero_index_obj_1_path = "GameObject/Cell1"
local hero_index_obj_2_path = "GameObject/Cell2"
local hero_index_obj_3_path = "GameObject/Cell3"
local hero_index_obj_4_path = "GameObject/Cell4"
local hero_index_obj_5_path = "GameObject/Cell5"

local function OnCreate(self)
  base.OnCreate(self)
  self.formationData = self:GetUserData()
  self.title = self:AddComponent(UIText, title_path)
  if self.formationData ~= nil and self.formationData.fromMail ~= nil and self.formationData.fromMail == 1 then
    self.title:SetLocalText(310141)
  else
    self.title:SetLocalText(110184)
  end
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.camp_des = self:AddComponent(UIText, camp_des_path)
  self.camp_num = self:AddComponent(UIText, camp_num_path)
  self.camp_icon = self:AddComponent(CampDetailItem, camp_icon_path)
  self.camp_btn = self:AddComponent(UIButton, camp_btn_path)
  self.camp_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnCampClick()
  end)
  self.atk_btn = self:AddComponent(UIButton, atk_btn_path)
  self.atk_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnAtkDesClick()
  end)
  self.atk_txt = self:AddComponent(UIText, atk_txt_path)
  self.atk_icon = self:AddComponent(UIImage, atk_icon_path)
  self.def_btn = self:AddComponent(UIButton, def_btn_path)
  self.def_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnDefDesClick()
  end)
  self.def_txt = self:AddComponent(UIText, def_txt_path)
  self.def_icon = self:AddComponent(UIImage, def_icon_path)
  self.soldier_btn = self:AddComponent(UIButton, soldier_btn_path)
  self.soldier_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnSoldierDesClick()
  end)
  self.soldier_txt = self:AddComponent(UIText, soldier_txt_path)
  self.soldier_icon = self:AddComponent(UIImage, soldier_icon_path)
  self.heroIndexObj = {}
  local index1 = self:AddComponent(FormationShareCell, hero_index_obj_1_path)
  self.heroIndexObj[1] = index1
  local index2 = self:AddComponent(FormationShareCell, hero_index_obj_2_path)
  self.heroIndexObj[2] = index2
  local index3 = self:AddComponent(FormationShareCell, hero_index_obj_3_path)
  self.heroIndexObj[3] = index3
  local index4 = self:AddComponent(FormationShareCell, hero_index_obj_4_path)
  self.heroIndexObj[4] = index4
  local index5 = self:AddComponent(FormationShareCell, hero_index_obj_5_path)
  self.heroIndexObj[5] = index5
end

local function OnDestroy(self)
  self.title = nil
  self.close_btn = nil
  self.return_btn = nil
  self.camp_des = nil
  self.camp_num = nil
  self.camp_icon = nil
  self.camp_btn = nil
  self.atk_btn = nil
  self.atk_txt = nil
  self.atk_icon = nil
  self.def_btn = nil
  self.def_txt = nil
  self.def_icon = nil
  self.soldier_btn = nil
  self.soldier_txt = nil
  self.soldier_icon = nil
  self.heroIndexObj = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:InitData()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function InitData(self)
  if self.formationData == nil then
    return
  end
  self.soldier_txt:SetText(string.GetFormattedSeperatorNum(self.formationData.totalSoliderNum))
  self.atk_txt:SetText(string.GetFormattedSeperatorNum(self.formationData.totalAtkNum))
  self.def_txt:SetText(string.GetFormattedSeperatorNum(self.formationData.totalDefNum))
  local campDataList = self.formationData.campData
  if campDataList ~= nil then
    if 0 < #campDataList then
      self.camp_des:SetLocalText(150222)
      local attackNum = 0
      for i = 1, #campDataList do
        attackNum = attackNum + campDataList[i].addEffectNum
      end
      self.camp_num:SetText("+" .. math.floor(attackNum) .. "%")
      self.camp_icon:InitData(campDataList)
    else
      self.camp_icon:InitData()
      self.camp_des:SetLocalText(130261)
      self.camp_num:SetText("")
    end
  else
    self.camp_icon:InitData()
    self.camp_des:SetLocalText(130261)
    self.camp_num:SetText("")
  end
  local heroList = self.formationData.heroList
  for k, v in pairs(self.heroIndexObj) do
    local key = tostring(k)
    if heroList ~= nil and heroList[key] ~= nil then
      v:ReInit(heroList[key], k)
    else
      v:ReInit()
    end
  end
end

local function OnCampClick(self)
  local str = ""
  local campDataList = self.formationData.campData
  if campDataList ~= nil then
    if 0 < #campDataList then
      self.camp_des:SetLocalText(150222)
      local attackNum = 0
      for i = 1, #campDataList do
        attackNum = attackNum + campDataList[i].addEffectNum
      end
      str = Localization:GetString("150222") .. "+" .. math.floor(attackNum) .. "%"
    else
      str = Localization:GetString("150220")
    end
  else
    str = Localization:GetString("150220")
  end
  local position = self.camp_icon.gameObject.transform.position
  local param = UIHeroTipView.Param.New()
  param.title = Localization:GetString("150221")
  param.content = str
  param.dir = UIHeroTipView.Direction.ABOVE
  param.defWidth = 200
  param.pivot = 0.5
  param.position = position
  param.deltaX = 73
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

local function OnAtkDesClick(self)
  local atkDes = Localization:GetString("150101")
  if atkDes ~= "" then
    local scaleFactor = UIManager:GetInstance():GetScaleFactor()
    local position = self.atk_icon.transform.position + Vector3.New(15, -30, 0) * scaleFactor
    local param = UIHeroTipView.Param.New()
    param.content = atkDes
    param.dir = UIHeroTipView.Direction.BELOW
    param.defWidth = 180
    param.pivot = 0.5
    param.position = position
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
  end
end

local function OnDefDesClick(self)
  local defDes = Localization:GetString("150102")
  if defDes ~= "" then
    local scaleFactor = UIManager:GetInstance():GetScaleFactor()
    local position = self.def_icon.transform.position + Vector3.New(15, -30, 0) * scaleFactor
    local param = UIHeroTipView.Param.New()
    param.content = defDes
    param.dir = UIHeroTipView.Direction.BELOW
    param.defWidth = 180
    param.pivot = 0.5
    param.position = position
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
  end
end

local function OnSoldierDesClick(self)
  local soldierDes = Localization:GetString("130068")
  if soldierDes ~= "" then
    local scaleFactor = UIManager:GetInstance():GetScaleFactor()
    local position = self.soldier_icon.transform.position + Vector3.New(15, -30, 0) * scaleFactor
    local param = UIHeroTipView.Param.New()
    param.content = soldierDes
    param.dir = UIHeroTipView.Direction.BELOW
    param.defWidth = 180
    param.pivot = 0.5
    param.position = position
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
  end
end

UIFormationShareView.OnCreate = OnCreate
UIFormationShareView.OnDestroy = OnDestroy
UIFormationShareView.OnEnable = OnEnable
UIFormationShareView.OnDisable = OnDisable
UIFormationShareView.InitData = InitData
UIFormationShareView.InitData = InitData
UIFormationShareView.OnCampClick = OnCampClick
UIFormationShareView.OnAtkDesClick = OnAtkDesClick
UIFormationShareView.OnDefDesClick = OnDefDesClick
UIFormationShareView.OnSoldierDesClick = OnSoldierDesClick
return UIFormationShareView
