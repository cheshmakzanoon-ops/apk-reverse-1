local base = UIBaseContainer
local T11SoldierResearchPlanStageNodeComponent = BaseClass("T11SoldierResearchPlanStageNodeComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local State = {
  Unlocked = 1,
  ToUnlock = 2,
  Locked = 3
}
local StateAssetMap = {
  [State.Unlocked] = {
    title = "Assets/Main/TextureEx/UIT11Ex/ljq_t11_biaotidi_01.png",
    icon = "Assets/Main/Sprites/UI/UIT11/ljq_t11_jindutiao_dian_01.png"
  },
  [State.ToUnlock] = {
    title = "Assets/Main/TextureEx/UIT11Ex/ljq_t11_biaotidi_02.png",
    icon = "Assets/Main/Sprites/UI/UIT11/ljq_t11_jindutiao_dian_02.png"
  },
  [State.Locked] = {
    title = "Assets/Main/TextureEx/UIT11Ex/ljq_t11_biaotidi_02.png",
    icon = "Assets/Main/Sprites/UI/UIT11/ljq_t11_jindutiao_dian_03.png"
  }
}

function T11SoldierResearchPlanStageNodeComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function T11SoldierResearchPlanStageNodeComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function T11SoldierResearchPlanStageNodeComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgNode = self.viewSkin:AddComponent(self, UIImage, 1)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.rawImgPlanImage = self.viewSkin:AddComponent(self, UIRawImage, 3)
  self.textPlanDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.btnDetail = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnDetail:SetOnClick(function()
    self:OnBtnDetailClick()
  end)
  self.rawImgTitle = self.viewSkin:AddComponent(self, UIRawImage, 6)
  self.imgBg1 = self.viewSkin:AddComponent(self, UIImage, 7)
  self.rawImgBg2 = self.viewSkin:AddComponent(self, UIRawImage, 8)
end

function T11SoldierResearchPlanStageNodeComponent:ComponentDestroy()
  self.viewSkin = nil
  self.imgNode = nil
  self.textTitle = nil
  self.rawImgPlanImage = nil
  self.textPlanDesc = nil
  self.btnDetail = nil
  self.rawImgTitle = nil
  self.imgBg1 = nil
  self.rawImgBg2 = nil
end

function T11SoldierResearchPlanStageNodeComponent:DataDefine()
  self.previewData = nil
  self.curState = nil
end

function T11SoldierResearchPlanStageNodeComponent:DataDestroy()
  self.previewData = nil
  self.curState = nil
end

function T11SoldierResearchPlanStageNodeComponent:OnAddListener()
  base.OnAddListener(self)
end

function T11SoldierResearchPlanStageNodeComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function T11SoldierResearchPlanStageNodeComponent:OnBtnDetailClick()
end

function T11SoldierResearchPlanStageNodeComponent:ParseInfo(data)
  self.previewData = data
  self.curStage = self.previewData.stage
  self.textTitle:SetLocalText(self.previewData.title)
  self.rawImgPlanImage:LoadSprite(self.previewData.icon)
  self.textPlanDesc:SetLocalText(self.previewData.desc)
  local icon, titleBg = self:GetAssetByStage(self.previewData.stage)
  if icon and titleBg then
    self.imgNode:LoadSprite(icon)
    self.rawImgTitle:LoadSprite(titleBg)
  end
  CS.UIGray.SetGray(self.rawImgTitle.transform, self.curState == State.Locked, true)
  CS.UIGray.SetGray(self.imgBg1.transform, self.curState == State.Locked, true)
  CS.UIGray.SetGray(self.rawImgBg2.transform, self.curState == State.Locked, true)
  CS.UIGray.SetGray(self.rawImgPlanImage.transform, self.curState == State.Locked, true)
  CS.UIGray.SetGray(self.textPlanDesc.transform, self.curState == State.Locked, true)
end

function T11SoldierResearchPlanStageNodeComponent:GetAssetByStage(stage)
  local curStage = T11Util.GetCurStage()
  local state = State.Locked
  if stage <= curStage then
    state = State.Unlocked
  elseif stage - curStage == 1 then
    state = State.ToUnlock
  else
    state = State.Locked
  end
  self.curState = state
  local asset = StateAssetMap[state]
  if asset then
    return asset.icon, asset.title
  end
  return nil, nil
end

return T11SoldierResearchPlanStageNodeComponent
