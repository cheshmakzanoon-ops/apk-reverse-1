local base = UIAsyncContainer
local LLMainUIBattlePercentNotice = BaseClass("LLMainUIBattlePercentNotice", UIAsyncContainer)
local Localization = CS.GameEntry.Localization
local ActMgr = DataCenter.LandlordMgr

function LLMainUIBattlePercentNotice:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LLMainUIBattlePercentNotice:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LLMainUIBattlePercentNotice:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 1)
  self.textPercent = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textPos = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.btnPos = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnPos:SetOnClick(function()
    self:OnBtnPosClick()
  end)
  self.compBg = self.viewSkin:AddComponent(self, UIBaseComponent, 6)
end

function LLMainUIBattlePercentNotice:ComponentDestroy()
  self.viewSkin = nil
  self.imgIcon = nil
  self.textPercent = nil
  self.textPos = nil
  self.textName = nil
  self.btnPos = nil
  self.compBg = nil
end

function LLMainUIBattlePercentNotice:DataDefine()
end

function LLMainUIBattlePercentNotice:DataDestroy()
  if self.delay ~= nil then
    self.delay:Stop()
    self.delay = nil
  end
  self.msg = nil
  self.cityId = nil
end

function LLMainUIBattlePercentNotice:OnAddListener()
  base.OnAddListener(self)
end

function LLMainUIBattlePercentNotice:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LLMainUIBattlePercentNotice:OnBtnPosClick()
  if self.cityId == nil then
    return
  end
  ActMgr:JumpToCity(self.cityId)
end

function LLMainUIBattlePercentNotice:CheckShow(force)
  if not force and self.delay ~= nil then
    return
  end
  self:RefreshView()
end

function LLMainUIBattlePercentNotice:UpdateData()
  local msg = ActMgr:PopBattleCityNoticeMsg(false)
  self:SetActive(msg ~= nil)
  if msg == nil then
    self.cityId = nil
    return
  end
  self.compBg:SetActive(true)
  self.cityId = msg.cityId
  local cityConfig = ActMgr:GetCityTemplate(self.cityId)
  local isBlue = ActMgr:GetMyGroup() == msg.campId
  self.imgIcon:LoadSpriteAuto(string.format(LoadPath.LandlordPath, isBlue and "zyf_jinmai_zhujeimian_jingshi_lan.png" or "zyf_jinmai_zhujeimian_jingshi_hong.png"))
  local name = cityConfig ~= nil and cityConfig:GetName() or ""
  self.textName:SetText(name)
  self.textPercent:SetText(msg.progress .. "%")
  self.textPercent:SetColorHex(isBlue and "#38d7ff" or "#f97077")
  local cityPos = cityConfig ~= nil and cityConfig.pos or Vector2.zero
  self.textPos:SetLocalText(300015, cityPos.x, cityPos.y)
  if self.delay ~= nil then
    self.delay:Stop()
  end
  self.delay = TimerManager:GetInstance():DelayInvoke(function()
    self.compBg:SetActive(false)
    self.delay = TimerManager:GetInstance():DelayInvoke(function()
      self.delay = nil
      self:RefreshView()
    end, 0.5)
  end, 5)
end

return LLMainUIBattlePercentNotice
