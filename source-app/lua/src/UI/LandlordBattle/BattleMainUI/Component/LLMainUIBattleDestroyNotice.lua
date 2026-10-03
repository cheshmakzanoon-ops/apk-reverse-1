local base = UIAsyncContainer
local LLMainUIBattleDestroyNotice = BaseClass("LLMainUIBattleDestroyNotice", UIAsyncContainer)
local Localization = CS.GameEntry.Localization
local ActMgr = DataCenter.LandlordMgr
local COLOR_YELLOW = Color.New(1, 0.7529411764705882, 0.21568627450980393, 1)

function LLMainUIBattleDestroyNotice:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LLMainUIBattleDestroyNotice:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LLMainUIBattleDestroyNotice:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgBg = self.viewSkin:AddComponent(self, UIImage, 1)
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 2)
  self.textName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textPos = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textScore = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.btnPos = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnPos:SetOnClick(function()
    self:OnBtnPosClick()
  end)
  self.compZero = self.viewSkin:AddComponent(self, UIBaseContainer, 7)
  self.compDestroyed = self.viewSkin:AddComponent(self, UIBaseContainer, 8)
  self.imgSIcon = self.viewSkin:AddComponent(self, UIImage, 9)
end

function LLMainUIBattleDestroyNotice:ComponentDestroy()
  self.viewSkin = nil
  self.imgBg = nil
  self.imgIcon = nil
  self.textName = nil
  self.textPos = nil
  self.textScore = nil
  self.btnPos = nil
  self.compZero = nil
  self.compDestroyed = nil
  self.imgSIcon = nil
end

function LLMainUIBattleDestroyNotice:DataDefine()
end

function LLMainUIBattleDestroyNotice:DataDestroy()
  if self.delay ~= nil then
    self.delay:Stop()
    self.delay = nil
  end
  self.cityId = nil
end

function LLMainUIBattleDestroyNotice:OnAddListener()
  base.OnAddListener(self)
end

function LLMainUIBattleDestroyNotice:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LLMainUIBattleDestroyNotice:OnBtnPosClick()
  if self.cityId == nil then
    return
  end
  ActMgr:JumpToCity(self.cityId)
end

function LLMainUIBattleDestroyNotice:CheckShow(force)
  if not force and self.delay ~= nil then
    return
  end
  self:RefreshView()
end

function LLMainUIBattleDestroyNotice:UpdateData()
  local msg = ActMgr:PopBattleCityNoticeMsg(true)
  self:SetActive(msg ~= nil)
  if msg == nil then
    self.cityId = nil
    return
  end
  local progress = toInt(msg.progress)
  local isDestroy = progress == 100
  self.imgBg:SetActive(true)
  self.cityId = msg.cityId
  local cityConfig = ActMgr:GetCityTemplate(self.cityId)
  local isFarmer = ActMgr:GetMyGroup() == LLConst.LandLordGroup.FARMER
  if isFarmer then
    self.imgBg:LoadSpriteAuto(string.format(LoadPath.LandlordPath, isDestroy and "zyf_jinmai_zhujeimian_tiao_lan2.png" or "zyf_jinmai_zhujeimian_tiao_hong2.png"))
  else
    self.imgBg:LoadSpriteAuto(string.format(LoadPath.LandlordPath, isDestroy and "zyf_jinmai_zhujeimian_tiao_hong2.png" or "zyf_jinmai_zhujeimian_tiao_lan2.png"))
  end
  if isDestroy then
    self.imgSIcon:LoadSpriteAuto(string.format(LoadPath.LandlordPath, isFarmer and "lrb_jinmai_beizhan_pocheng_lan.png" or "lrb_jinmai_beizhan_pocheng_hong.png"))
  end
  if cityConfig ~= nil then
    self.imgIcon:LoadSpriteAuto(cityConfig.lod_icon)
    self.imgIcon:SetColor(COLOR_YELLOW)
    self.imgIcon:SetAspectSize(110)
  end
  local name = cityConfig ~= nil and cityConfig:GetName() or ""
  self.textName:SetText(name)
  self.compZero:SetActive(not isDestroy)
  self.compDestroyed:SetActive(isDestroy)
  self.textScore:SetActive(isFarmer and isDestroy)
  self.textPos:SetActive(not isFarmer and isDestroy)
  if isDestroy then
    if isFarmer then
      local ruins_points = cityConfig ~= nil and cityConfig.ruins_points or 0
      self.textScore:SetText("+" .. ruins_points)
    else
      local cityPos = cityConfig ~= nil and cityConfig.pos or Vector2.zero
      self.textPos:SetLocalText(300015, cityPos.x, cityPos.y)
    end
  end
  if self.delay ~= nil then
    self.delay:Stop()
  end
  self.delay = TimerManager:GetInstance():DelayInvoke(function()
    self.imgBg:SetActive(false)
    self.delay = TimerManager:GetInstance():DelayInvoke(function()
      self.delay = nil
      self:RefreshView()
    end, 0.5)
  end, 5)
end

return LLMainUIBattleDestroyNotice
