local base = require("UI.LandlordBattle.BattleDetail.Component.LLDetailProgressBase")
local LLDetailProgressBuild = BaseClass("LLDetailProgressBuild", base)

function LLDetailProgressBuild:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LLDetailProgressBuild:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LLDetailProgressBuild:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.slider = self.viewSkin:AddComponent(self, UISlider, 1)
  self.textProgress = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnDetail = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnDetail:SetOnClick(function()
    self:OnBtnDetailClick()
  end)
  self.textSpeed = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
end

function LLDetailProgressBuild:ComponentDestroy()
  self.viewSkin = nil
  self.slider = nil
  self.textProgress = nil
  self.btnDetail = nil
  self.textSpeed = nil
end

function LLDetailProgressBuild:DataDefine()
  self.isThroneCity = false
end

function LLDetailProgressBuild:DataDestroy()
  base.DataDestroy(self)
end

function LLDetailProgressBuild:OnAddListener()
  base.OnAddListener(self)
end

function LLDetailProgressBuild:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LLDetailProgressBuild:OnBtnDetailClick()
  base.OnBtnDetailClick(self)
end

return LLDetailProgressBuild
