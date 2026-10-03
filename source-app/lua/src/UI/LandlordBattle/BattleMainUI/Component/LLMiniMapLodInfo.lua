local base = UIAsyncContainer
local LLMiniMapLodInfo = BaseClass("LLMiniMapLodInfo", base)
local Localization = CS.GameEntry.Localization

function LLMiniMapLodInfo:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LLMiniMapLodInfo:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LLMiniMapLodInfo:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btn = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
end

function LLMiniMapLodInfo:ComponentDestroy()
  self.viewSkin = nil
  self.btn = nil
end

function LLMiniMapLodInfo:DataDefine()
end

function LLMiniMapLodInfo:DataDestroy()
  self.clickCb = nil
end

function LLMiniMapLodInfo:OnAddListener()
  base.OnAddListener(self)
end

function LLMiniMapLodInfo:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LLMiniMapLodInfo:OnBtnClick()
  if self.clickCb then
    self.clickCb()
  end
end

function LLMiniMapLodInfo:SetClickCb(clickCb)
  self.clickCb = clickCb
end

return LLMiniMapLodInfo
