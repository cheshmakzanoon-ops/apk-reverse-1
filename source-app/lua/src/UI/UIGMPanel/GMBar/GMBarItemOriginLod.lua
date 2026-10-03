local base = UIAsyncContainer
local GMBarItemOriginLod = BaseClass("GMBarItemOriginLod", base)
local Localization = CS.GameEntry.Localization

function GMBarItemOriginLod:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Refresh()
end

function GMBarItemOriginLod:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function GMBarItemOriginLod:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnLod = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnLod:SetOnClick(function()
    self:OnBtnLodClick()
  end)
  self.textTxtLod = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
end

function GMBarItemOriginLod:ComponentDestroy()
  self.viewSkin = nil
  self.btnLod = nil
  self.textTxtLod = nil
end

function GMBarItemOriginLod:DataDefine()
end

function GMBarItemOriginLod:DataDestroy()
end

function GMBarItemOriginLod:OnAddListener()
  base.OnAddListener(self)
end

function GMBarItemOriginLod:OnRemoveListener()
  base.OnRemoveListener(self)
end

function GMBarItemOriginLod:OnBtnLodClick()
  local _, txt = GameQualitySettings.GMToggleLod()
  self.textTxtLod:SetText(txt)
end

function GMBarItemOriginLod:Refresh()
  if IsNull(self.gameObject) then
    return
  end
  self.textTxtLod:SetText("LA")
end

return GMBarItemOriginLod
