local BloodBar = BaseClass("BloodBar")
local Resource = CS.GameEntry.Resource
local UnityText = typeof(CS.UnityEngine.UI.Text)
local UnityImage = typeof(CS.UnityEngine.UI.Image)
local UnityRectTransform = typeof(CS.UnityEngine.RectTransform)
local SimpleAnimation = typeof(CS.SimpleAnimation)
local _cp_objPower = "objPower"
local _cp_txtPower = "objPower/txtPower"
local _cp_objLevel = "objLevel"
local _cp_txtLevel = "objLevel/txtLevel"
local _cp_objHp = "objHp"
local _cp_imgHp = "objHp/hp"
local _cp_imgHpRed = "objHp/hpRed"
local _cp_txtHp = "objHp/txtBlood"
local _cp_base = ""
local starBgPrefix = "objLevel/NodeArrow/Stars/star_bg"
local starPrefix = "star"
local starHalfPrefix = "star_half_"
local max_star_num = 5
local full_star_pic = string.format(LoadPath.HeroListPath, "ui_img_starA")
local half_star_pic = string.format(LoadPath.HeroListPath, "ui_img_starB")

function BloodBar:__init(modelObj, gameObj)
  self.m_maxHp = 0
  self.m_curHp = 0
  self.m_hpFactor = 1
  self.m_modelObj = modelObj
  self.m_gameObject = gameObj
  local CanvasNormal = UIManager:GetInstance():GetLayer(UILayer.Background.Name).gameObject
  self.m_gameObject.transform:SetParent(CanvasNormal.transform)
  self.isShowArrow = false
  self:InitComponent()
  self:AddUpdateTimer()
end

function BloodBar:AddUpdateTimer()
  if self.updateTimer == nil then
    function self.updateTimer()
      self:OnUpdate()
    end
    
    UpdateManager:GetInstance():AddUpdate(self.updateTimer)
  end
end

function BloodBar:RemoveUpdateTimer()
  if self.updateTimer then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.updateTimer = nil
  end
end

function BloodBar:OnUpdate()
  self:UpdatePos()
end

function BloodBar:UpdatePos()
  local _modelPos = self.m_modelObj:GetTransform().position + Vector3.New(0, 2, 0)
  local mainCamera = CS.UnityEngine.Camera.main
  local _screenPos = mainCamera:WorldToScreenPoint(_modelPos)
  self.m_objBase.transform.position = Vector3.New(_screenPos.x, _screenPos.y, 0)
end

function BloodBar:GetTransform()
  return self.m_gameObject.transform
end

function BloodBar:InitComponent()
  local transform = self:GetTransform()
  self.m_objPower = transform:Find(_cp_objPower)
  self.m_txtPower = transform:Find(_cp_txtPower):GetComponent(UnityText)
  self.m_objLevel = transform:Find(_cp_objLevel)
  self.m_txtLevel = transform:Find(_cp_txtLevel):GetComponent(UnityText)
  self.m_objHp = transform:Find(_cp_objHp)
  self.anim = transform:Find(_cp_objHp):GetComponent(SimpleAnimation)
  if self.m_modelObj:IsPlayer() then
    transform:Find(_cp_imgHpRed).gameObject:SetActive(false)
    transform:Find(_cp_imgHp).gameObject:SetActive(true)
    self.m_imgHp = transform:Find(_cp_imgHp):GetComponent(UnityImage):GetComponent(UnityRectTransform)
    self.m_imgHp.gameObject:SetActive(true)
  else
    transform:Find(_cp_imgHp).gameObject:SetActive(false)
    transform:Find(_cp_imgHpRed).gameObject:SetActive(true)
    self.m_imgHp = transform:Find(_cp_imgHpRed):GetComponent(UnityImage):GetComponent(UnityRectTransform)
  end
  self.m_txtHp = transform:Find(_cp_txtHp):GetComponent(UnityText)
  self.m_objBase = transform:Find(_cp_base):GetComponent(UnityRectTransform)
  local starObj = transform:Find("objLevel/NodeArrow").gameObject
  starObj:SetActive(true)
  self.componentList = {}
  for index = 0, max_star_num do
    local bgPath = self:GetStarBgPath(index)
    self.componentList[self:GetStarBgComponentName(index)] = transform:Find(bgPath):GetComponent(UnityImage)
  end
end

function BloodBar:SetPower(value)
  self.m_objHp.gameObject:SetActive(false)
  self.m_txtPower.text = string.GetFormattedStr(tonumber(value))
end

function BloodBar:SetHeroLv(value, targetValue)
  self.m_objHp.gameObject:SetActive(false)
  self.m_txtLevel.text = "Lv." .. value
  self.m_txtLevel:Set_color(WhiteColor.r, WhiteColor.g, WhiteColor.b, WhiteColor.a)
end

function BloodBar:SetHeroStar(quality, rarity)
  local data = {}
  local starNum, progressNum = HeroUtils.GetHeroStarAndProgress(quality)
  data.showStarNum = starNum
  data.maxStarNum = 5
  for index = 0, max_star_num do
    local starBGComponentName = self:GetStarBgComponentName(index)
    local bg = self.componentList[starBGComponentName]
    if bg == nil then
      return
    end
    if index == 0 then
      bg.gameObject:SetActive(false)
    else
      bg.gameObject:SetActive(index <= data.showStarNum)
    end
  end
end

function BloodBar:ShowHpObject()
  self.m_objHp.gameObject:SetActive(true)
  self.m_objLevel.gameObject:SetActive(false)
  self.m_objPower.gameObject:SetActive(false)
end

function BloodBar:SetHpFactor(maxHpPercent)
  self.m_hpFactor = maxHpPercent
end

function BloodBar:SetHp(curValue, maxValue)
  maxValue = math.max(maxValue, 1)
  curValue = Mathf.Clamp(curValue * self.m_hpFactor, 0, maxValue)
  local percent = curValue / maxValue * 100.0
  self.m_imgHp:Set_sizeDelta(percent, 16)
  self.m_txtHp.text = string.GetFormattedStr(tonumber(curValue))
end

function BloodBar:SetActive(visible)
  self.m_objBase.gameObject:SetActive(visible)
end

function BloodBar:Destroy()
  self:RemoveUpdateTimer()
end

function BloodBar:StopUpdate()
  self:RemoveUpdateTimer()
end

function BloodBar:GetStarBgPath(index)
  return starBgPrefix .. index
end

function BloodBar:GetStarPath(index)
  return starBgPrefix .. index .. "/" .. starPrefix .. index
end

function BloodBar:GetStarHalfPath(index)
  return starBgPrefix .. index .. "/" .. starHalfPrefix .. index
end

function BloodBar:GetStarBgComponentName(index)
  return starBgPrefix .. index
end

function BloodBar:GetStarComponentName(index)
  return starPrefix .. index
end

function BloodBar:GetStarHalfComponentName(index)
  return starHalfPrefix .. index
end

function BloodBar:SetPlayerShowLevelOrPower()
  local power = CS.GameEntry.Setting:GetPrivateBool("SHOW_PVE_POWER", false)
  if power == true then
    self.m_objLevel.gameObject:SetActive(false)
    self.m_objPower.gameObject:SetActive(true)
  else
    self.m_objLevel.gameObject:SetActive(true)
    self.m_objPower.gameObject:SetActive(false)
  end
end

function BloodBar:SetBarForGuide(power, showArrow)
  self.m_objLevel.gameObject:SetActive(false)
  self.m_objPower.gameObject:SetActive(false)
  self.m_objHp.gameObject:SetActive(true)
  local percent = 100
  self.m_imgHp:Set_sizeDelta(percent, 16)
  self.m_txtHp.text = string.GetFormattedStr(tonumber(power))
  self.anim:Play("pve_blood_default")
  if showArrow then
    self.isShowArrow = true
    local param = {
      arrowType = ArrowType.Normal,
      positionType = PositionType.Screen,
      position = self.m_objHp.gameObject.transform.position,
      clickClose = true,
      useLiteAnim = true,
      UseScale = 1.2
    }
    DataCenter.ArrowManager:ShowArrow(param)
  end
end

function BloodBar:HideBarForGuide()
  self.anim:Play("Default")
  if self.isShowArrow then
    self.isShowArrow = false
    DataCenter.ArrowManager:RemoveArrow()
  end
end

return BloodBar
