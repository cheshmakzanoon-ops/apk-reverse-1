local SeasonCampDestroyNoticeView = BaseClass("SeasonCampDestroyNoticeView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local SeasonCampDestroyNoticeViewIR = require("UI.LWSeason6.SeasonCampDestroy.DestroyNotice.SeasonCampDestroyNoticeViewIR")

function SeasonCampDestroyNoticeView:OnCreate()
  base.OnCreate(self)
  self.listGO = {}
  self.itemList = {}
  self:ComponentDefine()
  self:DataDefine()
end

function SeasonCampDestroyNoticeView:OnDestroy()
  self:ClearItems()
  self.listGO = nil
  self.itemList = nil
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonCampDestroyNoticeView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitleTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.btnConfirm = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnConfirm:SetOnClick(function()
    self:OnBtnConfirmClick()
  end)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.gridInfinityScrollViewContent = self.viewSkin:AddComponent(self, GridInfinityScrollView, 5)
  self.btnTodaySilence = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnTodaySilence:SetOnClick(function()
    self:OnBtnTodaySilenceClick()
  end)
  self.textTmpBottomNotice = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.textTitleTxt:SetLocalText("100378")
  self.textTmpBottomNotice:SetLocalText("110103")
  self.btnConfirm:SetButtonNameLocal("393010")
  self.silenceToday = not DataCenter.SecondConfirmManager:GetTodayCanShowSecondConfirm(TodayNoSecondConfirmType.SeasonCampDestroyNoticeSilence)
  self.gridInfinityScrollViewContent:Init(BindCallback(self, self.OnInitCell), BindCallback(self, self.OnUpdateCell), BindCallback(self, self.OnDestroyCell))
  self:RefreshList()
  self:RefreshTodaySilence()
end

function SeasonCampDestroyNoticeView:ComponentDestroy()
  self.viewSkin = nil
  self.textTitleTxt = nil
  self.btnClose = nil
  self.btnConfirm = nil
  self.compContent = nil
  self.gridInfinityScrollViewContent = nil
  self.btnTodaySilence = nil
  self.textTmpBottomNotice = nil
end

function SeasonCampDestroyNoticeView:DataDefine()
  local confirmCallback = self:GetUserData()
  self.ctrl:SetConfirmCallback(confirmCallback)
end

function SeasonCampDestroyNoticeView:DataDestroy()
end

function SeasonCampDestroyNoticeView:OnAddListener()
  base.OnAddListener(self)
end

function SeasonCampDestroyNoticeView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function SeasonCampDestroyNoticeView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function SeasonCampDestroyNoticeView:OnBtnConfirmClick()
  if self.silenceToday then
    DataCenter.SecondConfirmManager:SetTodayNoShowSecondConfirm(TodayNoSecondConfirmType.SeasonCampDestroyNoticeSilence, false)
  end
  self.ctrl:DoConfirm()
  self.ctrl:CloseSelf()
end

function SeasonCampDestroyNoticeView:ClearItems()
  self.compContent:RemoveComponents(SeasonCampDestroyNoticeViewIR)
  self.gridInfinityScrollViewContent:DestroyChildNode()
  self.listGO = {}
  self.itemList = {}
end

function SeasonCampDestroyNoticeView:OnInitCell(go, index)
  local item = self.compContent:AddComponent(SeasonCampDestroyNoticeViewIR, go)
  self.listGO[index] = go
  self.itemList[go] = item
end

function SeasonCampDestroyNoticeView:OnUpdateCell(go, index)
  local item = self.itemList[go]
  if item then
    item:Refresh(self.dataList[index + 1])
  end
end

function SeasonCampDestroyNoticeView:OnDestroyCell(go, index)
  local item = self.itemList[go]
  if item then
    self.compContent:RemoveComponent(item)
    self.itemList[go] = nil
  end
  self.listGO[index] = nil
end

function SeasonCampDestroyNoticeView:RefreshList()
  self.dataList = self.ctrl:GetDataList()
  self.gridInfinityScrollViewContent:SetItemCount(#self.dataList)
end

function SeasonCampDestroyNoticeView:OnBtnTodaySilenceClick()
  self.silenceToday = not self.silenceToday
  self:RefreshTodaySilence()
end

function SeasonCampDestroyNoticeView:RefreshTodaySilence()
  self.btnTodaySilence:SetIconVisible(self.silenceToday)
end

return SeasonCampDestroyNoticeView
