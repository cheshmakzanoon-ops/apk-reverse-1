local base = UIAsyncContainer
local LLMiniMapProgressBox = BaseClass("LLMiniMapProgressBox", UIAsyncContainer)
local Localization = CS.GameEntry.Localization

function LLMiniMapProgressBox:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LLMiniMapProgressBox:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LLMiniMapProgressBox:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btn = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.textScore = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.imgBox = self.viewSkin:AddComponent(self, UIImage, 3)
end

function LLMiniMapProgressBox:ComponentDestroy()
  self.viewSkin = nil
  self.btn = nil
  self.textScore = nil
  self.imgBox = nil
end

function LLMiniMapProgressBox:DataDefine()
end

function LLMiniMapProgressBox:DataDestroy()
  self.info = nil
  self.curScore = nil
  self.camp = nil
  self.clickJump = nil
end

function LLMiniMapProgressBox:OnAddListener()
  base.OnAddListener(self)
end

function LLMiniMapProgressBox:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LLMiniMapProgressBox:OnBtnClick()
  local id = self.info ~= nil and self.info.id or nil
  if self.clickJump then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILLReward, {anim = true}, {
      camp = self.camp,
      tab = LLConst.RewardTabType.Week,
      openTargetId = id
    })
  else
    EventManager:GetInstance():Broadcast(EventId.LandlordTaskBoxClick, id)
  end
end

function LLMiniMapProgressBox:SetReward(info, curScore, camp, clickJump)
  self.info = info
  self.curScore = curScore
  self.camp = camp
  self.clickJump = clickJump
  self:RefreshView()
end

function LLMiniMapProgressBox:UpdateData()
  if self.info == nil or self.curScore == nil then
    return
  end
  local score = self.info.para[2]
  local flag = score <= self.curScore
  self.btn:LoadSpriteAuto(string.format(LoadPath.LandlordPath, flag and "zyf_jinmai_jindutiao_qipao_lan2.png" or "zyf_jinmai_jindutiao_qipao_bai.png"))
  self.textScore:SetText(score)
end

return LLMiniMapProgressBox
