local base = UIBaseContainer
local UIS0AllianceBossBuildRecordItem = BaseClass("UIS0AllianceBossBuildRecordItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UICommonHead = require("Framework.UI.Component.UICommonHead")

function UIS0AllianceBossBuildRecordItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIS0AllianceBossBuildRecordItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIS0AllianceBossBuildRecordItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compUIPlayerHead = self.viewSkin:AddComponent(self, UICommonHead, 1)
  self.textName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textHitTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
end

function UIS0AllianceBossBuildRecordItem:ComponentDestroy()
  self.viewSkin = nil
  self.compUIPlayerHead = nil
  self.textName = nil
  self.textHitTip = nil
  self.textTime = nil
end

function UIS0AllianceBossBuildRecordItem:DataDefine()
end

function UIS0AllianceBossBuildRecordItem:DataDestroy()
end

function UIS0AllianceBossBuildRecordItem:OnAddListener()
  base.OnAddListener(self)
end

function UIS0AllianceBossBuildRecordItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIS0AllianceBossBuildRecordItem:RefreshItem(donateInfo)
  if donateInfo then
    local headBgImg = DataCenter.DecorationDataManager:GetHeadFrame(donateInfo.headSkinId, donateInfo.headSkinET, false)
    self.compUIPlayerHead:SetData(donateInfo.uid, donateInfo.headPic, donateInfo.headPicVer, nil, headBgImg)
    self.textName:SetText(donateInfo.name)
    if donateInfo.multi >= 10 then
      self.textHitTip:SetLocalText("s0_alliance_boss_donate_crit_color_long", donateInfo.name, donateInfo.multi)
    else
      self.textHitTip:SetLocalText("s0_alliance_boss_donate_crit_long", donateInfo.name, donateInfo.multi)
    end
    self.textTime:SetText(UITimeManager:GetInstance():TimeStampToTimeForLocal(donateInfo.time))
  end
end

return UIS0AllianceBossBuildRecordItem
