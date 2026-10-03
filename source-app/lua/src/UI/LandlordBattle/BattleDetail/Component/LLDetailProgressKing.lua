local base = require("UI.LandlordBattle.BattleDetail.Component.LLDetailProgressBase")
local LLDetailProgressKing = BaseClass("LLDetailProgressKing", base)
local Localization = CS.GameEntry.Localization

function LLDetailProgressKing:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LLDetailProgressKing:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LLDetailProgressKing:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.slider = self.viewSkin:AddComponent(self, UISlider, 1)
  self.textProgress = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnDetail = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnDetail:SetOnClick(function()
    self:OnBtnDetailClick()
  end)
  self.imgProgress = self.viewSkin:AddComponent(self, UIImage, 4)
  self.imgBg = self.viewSkin:AddComponent(self, UIImage, 5)
end

function LLDetailProgressKing:ComponentDestroy()
  self.viewSkin = nil
  self.slider = nil
  self.textProgress = nil
  self.btnDetail = nil
  self.imgProgress = nil
  self.imgBg = nil
end

function LLDetailProgressKing:DataDefine()
  self.isThroneCity = true
  local myGroup = DataCenter.LandlordMgr:GetMyGroup()
  local blue = "cfm_tongyong_jindutiao_lan.png"
  local red = "lrb_tongyong_jindutiao_hong.png"
  local bgPath = myGroup == LLConst.LandLordGroup.LORD and blue or red
  local progressPath = myGroup == LLConst.LandLordGroup.LORD and red or blue
  self.imgBg:LoadSpriteAuto(string.format(LoadPath.CommonNewPath, bgPath))
  self.imgProgress:LoadSpriteAuto(string.format(LoadPath.CommonNewPath, progressPath))
end

function LLDetailProgressKing:DataDestroy()
  base.DataDestroy(self)
end

function LLDetailProgressKing:OnAddListener()
  base.OnAddListener(self)
end

function LLDetailProgressKing:OnRemoveListener()
  base.OnRemoveListener(self)
end

return LLDetailProgressKing
