local UIHeroCampRestraintView = BaseClass("UIHeroCampRestraintView", UIBaseView)
local base = UIBaseView
local return_btn_path = "Panel"
local tips_obj_path = "tips"
local des_txt_path = "tips/common_img_tipsbg/desTxt"
local camp_1_path = "tips/CampObj/camp1"
local camp_2_path = "tips/CampObj/camp2"
local camp_3_path = "tips/CampObj/camp3"
local camp_des_txt_path = "tips/desTxtCamp"
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  local campIndex, posX, posY = self:GetUserData()
  self.campIndex = tonumber(campIndex)
  self.posX = tonumber(posX)
  self.posY = tonumber(posY)
  self.tips = self:AddComponent(UIBaseContainer, tips_obj_path)
  local v3 = self.tips.transform.position
  v3.x = self.posX
  v3.y = self.posY
  self.tips.transform.position = v3
  self.des_txt = self:AddComponent(UIText, des_txt_path)
  self.des_txt:SetLocalText(150231)
  self.camp_des_txt = self:AddComponent(UIText, camp_des_txt_path)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.camp1 = self:AddComponent(UIImage, camp_1_path)
  self.camp2 = self:AddComponent(UIImage, camp_2_path)
  self.camp3 = self:AddComponent(UIImage, camp_3_path)
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
  if self.campIndex >= 0 then
    local restraintCamp = HeroUtils.GetHeroRestraintType(self.campIndex)
    local beRestraintCamp = HeroUtils.GetHeroBeRestraintType(self.campIndex)
    local name, desc = HeroUtils.GetCampNameAndDesc(restraintCamp)
    name = self:GetColorStr(restraintCamp, name)
    local bName, bDesc = HeroUtils.GetCampNameAndDesc(beRestraintCamp)
    bName = self:GetColorStr(beRestraintCamp, bName)
    local cName, cDesc = HeroUtils.GetCampNameAndDesc(self.campIndex)
    cName = self:GetColorStr(self.campIndex, cName)
    self.camp1:LoadSprite(HeroUtils.GetCampIconPath(self.campIndex))
    self.camp2:LoadSprite(HeroUtils.GetCampIconPath(beRestraintCamp))
    self.camp3:LoadSprite(HeroUtils.GetCampIconPath(restraintCamp))
    self.camp_des_txt:SetText(Localization:GetString("150227", cName, name, bName))
  end
end

local function GetColorStr(self, camp, name)
  local realName = name
  if camp == HeroCamp.ZELOT then
    realName = "<color=#FA8843>" .. name .. "</color>"
  elseif camp == HeroCamp.UNION then
    realName = "<color=#5FA3ED>" .. name .. "</color>"
  elseif camp == HeroCamp.MAFIA then
    realName = "<color=#A66CF0>" .. name .. "</color>"
  end
  return realName
end

UIHeroCampRestraintView.OnCreate = OnCreate
UIHeroCampRestraintView.OnDestroy = OnDestroy
UIHeroCampRestraintView.OnEnable = OnEnable
UIHeroCampRestraintView.OnDisable = OnDisable
UIHeroCampRestraintView.RefreshData = RefreshData
UIHeroCampRestraintView.GetColorStr = GetColorStr
return UIHeroCampRestraintView
