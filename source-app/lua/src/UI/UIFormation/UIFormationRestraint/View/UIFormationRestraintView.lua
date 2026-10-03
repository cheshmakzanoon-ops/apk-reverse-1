local UIFormationRestraintView = BaseClass("UIFormationRestraintView", UIBaseView)
local FormationRestraintItem = require("UI.UIFormation.UIFormationRestraint.Component.FormationRestraintItem")
local base = UIBaseView
local return_btn_path = "Panel"
local des_txt_path = "tips/common_img_tipsbg/desTxt"
local lock_txt_path = "tips/CampObj/lockDesTxt"
local camp_des_txt_path = "tips/desTxtCamp"
local tips_obj_path = "tips"
local camp_1_path = "tips/layout/FormationRestraintCamp1"
local camp_2_path = "tips/layout/FormationRestraintCamp2"
local camp_3_path = "tips/layout/FormationRestraintCamp3"
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  local campIndex, campNum, posX, posY, isOther = self:GetUserData()
  self.campNum = tonumber(campNum)
  self.campIndex = tonumber(campIndex)
  self.posX = tonumber(posX)
  self.posY = tonumber(posY)
  local otherFlag = tonumber(isOther) or 0
  self.isOther = otherFlag == 1
  self.tips = self:AddComponent(UIBaseContainer, tips_obj_path)
  local v3 = self.tips.transform.position
  v3.x = self.posX
  v3.y = self.posY
  self.tips.transform.position = v3
  self.des_txt = self:AddComponent(UIText, des_txt_path)
  self.lock_txt = self:AddComponent(UIText, lock_txt_path)
  self.des_txt:SetLocalText(133115)
  self.lock_txt:SetLocalText(120050)
  self.camp_des_txt = self:AddComponent(UIText, camp_des_txt_path)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  local camp1 = self:AddComponent(FormationRestraintItem, camp_1_path)
  local camp2 = self:AddComponent(FormationRestraintItem, camp_2_path)
  local camp3 = self:AddComponent(FormationRestraintItem, camp_3_path)
  self.campList = {}
  table.insert(self.campList, camp1)
  table.insert(self.campList, camp2)
  table.insert(self.campList, camp3)
end

local function OnDestroy(self)
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:RefreshData()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function RefreshData(self)
  local heroRestraintValue = LuaEntry.DataConfig:TryGetStr("battle_config", "k19")
  local arr = string.split(heroRestraintValue, ";")
  for i = 1, #self.campList do
    if i <= #arr then
      self.campList[i]:SetActive(true)
      self.campList[i]:InitData(self.campIndex, self.campNum, arr[i], i + 2)
    else
      self.campList[i]:SetActive(false)
    end
  end
  if self.isOther then
    self.camp_des_txt:SetText("")
  elseif self.campIndex >= 0 then
    local restraintCamp = HeroUtils.GetHeroRestraintType(self.campIndex)
    local name, desc = HeroUtils.GetCampNameAndDesc(restraintCamp)
    if restraintCamp == HeroCamp.ZELOT then
      name = "<color=#FA8843>" .. name .. "</color>"
    elseif restraintCamp == HeroCamp.UNION then
      name = "<color=#5FA3ED>" .. name .. "</color>"
    elseif restraintCamp == HeroCamp.MAFIA then
      name = "<color=#A66CF0>" .. name .. "</color>"
    end
    self.camp_des_txt:SetText(Localization:GetString("150225", name))
  else
    self.camp_des_txt:SetText(Localization:GetString("150232"))
  end
end

UIFormationRestraintView.OnCreate = OnCreate
UIFormationRestraintView.OnDestroy = OnDestroy
UIFormationRestraintView.OnEnable = OnEnable
UIFormationRestraintView.OnDisable = OnDisable
UIFormationRestraintView.RefreshData = RefreshData
return UIFormationRestraintView
