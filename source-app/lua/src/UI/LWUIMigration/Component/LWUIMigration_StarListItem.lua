local base = UIBaseContainer
local LWUIMigration_StarListItem = BaseClass("LWUIMigration_StarListItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function LWUIMigration_StarListItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUIMigration_StarListItem:OnDestroy()
  self.info = nil
  self.callback = nil
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIMigration_StarListItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTmpUnderScore = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.imgSeat = self.viewSkin:AddComponent(self, UIImage, 2)
  self.btnLWUIMigrationStarListItem = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnLWUIMigrationStarListItem:SetOnClick(function()
    self:OnBtnLWUIMigrationStarListItemClick()
  end)
  self.compImgServer = self.viewSkin:AddComponent(self, UIBaseComponent, 4)
  self.compImgBg = self.viewSkin:AddComponent(self, UIBaseComponent, 5)
end

function LWUIMigration_StarListItem:ComponentDestroy()
  self.viewSkin = nil
  self.textTmpUnderScore = nil
  self.imgSeat = nil
  self.btnLWUIMigrationStarListItem = nil
  self.compImgServer = nil
  self.compImgBg = nil
end

function LWUIMigration_StarListItem:DataDefine()
end

function LWUIMigration_StarListItem:DataDestroy()
end

function LWUIMigration_StarListItem:OnAddListener()
  base.OnAddListener(self)
end

function LWUIMigration_StarListItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

local identity2IconPath = {
  [0] = "Assets/Main/Sprites/UI/LWUIMigration/mjc_S2_yimin_shenfen_icon_1.png",
  [1] = "Assets/Main/Sprites/UI/LWUIMigration/mjc_S2_yimin_shenfen_icon_2.png",
  [2] = "Assets/Main/Sprites/UI/LWUIMigration/mjc_S2_yimin_shenfen_icon_3.png",
  [3] = "Assets/Main/Sprites/UI/LWUIMigration/mjc_S2_yimin_shenfen_icon_4.png"
}

function LWUIMigration_StarListItem:Setup(info, callback, isSelection)
  if info then
    self.textTmpUnderScore:SetText(string.format("%s-%s", string.GetFormattedStr(info.minPersonScore), string.GetFormattedStr(info.maxPersonScore)))
    self.info = info
    self.imgSeat:LoadSpriteAuto(identity2IconPath[info.identity])
    if isSelection then
      self.compImgBg:SetActive(true)
    else
      self.compImgBg:SetActive(false)
    end
  end
  self.callback = callback
  local myScore = DataCenter.ActMigrationManager:GetMyScore()
  local showMine = myScore >= info.minPersonScore and myScore <= info.maxPersonScore
  self.compImgServer:SetActive(showMine)
end

function LWUIMigration_StarListItem:OnBtnLWUIMigrationStarListItemClick()
  if self.callback then
    self.callback(self.info)
  end
end

return LWUIMigration_StarListItem
