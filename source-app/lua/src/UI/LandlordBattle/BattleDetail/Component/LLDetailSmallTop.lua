local base = UIBaseContainer
local LLDetailSmallTop = BaseClass("LLDetailSmallTop", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function LLDetailSmallTop:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LLDetailSmallTop:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LLDetailSmallTop:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 1)
  self.btn = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.textTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
end

function LLDetailSmallTop:ComponentDestroy()
  self.viewSkin = nil
  self.imgIcon = nil
  self.btn = nil
  self.textTips = nil
end

function LLDetailSmallTop:DataDefine()
  self.showList = false
end

function LLDetailSmallTop:DataDestroy()
end

function LLDetailSmallTop:OnAddListener()
  base.OnAddListener(self)
end

function LLDetailSmallTop:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LLDetailSmallTop:OnBtnClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if self.cb then
    self.showList = not self.showList
    self:RefreshIcon()
    self.cb(self.idx, self.showList)
  end
end

function LLDetailSmallTop:RefreshIcon()
  local imgName = self.showList and "cfm_tongyong_anniu_xiao_1.png" or "cfm_tongyong_anniu_xiao_2.png"
  self.imgIcon:LoadSpriteAuto(string.format(LoadPath.CommonPath, imgName))
end

function LLDetailSmallTop:SetInfo(percent, idx, cb, waitReset)
  self.idx = idx
  self.cb = cb
  local p = percent
  if p == 0 then
    self.textTips:SetLocalText("zonewar_landlord_limit_1017")
  else
    if p == 1 then
      p = 0
    end
    self.textTips:SetLocalText("zonewar_landlord_limit_1018", p .. "%")
  end
  if waitReset then
    self.showList = idx == 1
  end
  self:RefreshIcon()
end

return LLDetailSmallTop
