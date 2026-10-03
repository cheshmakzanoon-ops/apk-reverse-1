local UILLGroupChooseView = BaseClass("UILLGroupChooseView", UIBaseView)
local base = UIBaseView
local LLGroupChoosePanelTopItem = require("UI.Landlord.GroupChoose.Component.LLGroupChoosePanelTopItem")
local ActMgr = DataCenter.LandlordMgr
local CLS = "UI.Landlord.GroupChoose.Component.LLGroupChoosePanelItem"
local PREFAB = "Assets/Main/Prefabs/UI/Landlord/LLGroupChoosePanelItem.prefab"

function UILLGroupChooseView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILLGroupChooseView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILLGroupChooseView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.panel = self.viewSkin:AddComponent(self, UIButton, 1)
  self.panel:SetOnClick(function()
    self:OnPanelClick()
  end)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.compTop = self.viewSkin:AddComponent(self, UIHorizontalOrVerticalLayoutGroup, 3)
  self.textTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textTips = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.gridLayout = self.viewSkin:AddComponent(self, UIGridLayoutGroup, 6)
  self.btnInfo = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.compTop4 = self.viewSkin:AddComponent(self, LLGroupChoosePanelTopItem, 8)
  self.compTop2 = self.viewSkin:AddComponent(self, LLGroupChoosePanelTopItem, 9)
  self.compTop1 = self.viewSkin:AddComponent(self, LLGroupChoosePanelTopItem, 10)
  self.compTop3 = self.viewSkin:AddComponent(self, LLGroupChoosePanelTopItem, 11)
  self.compTop5 = self.viewSkin:AddComponent(self, LLGroupChoosePanelTopItem, 12)
  self.compTopList = {
    self.compTop1,
    self.compTop2,
    self.compTop3,
    self.compTop4,
    self.compTop5
  }
end

function UILLGroupChooseView:ComponentDestroy()
  self.viewSkin = nil
  self.panel = nil
  self.btnClose = nil
  self.compTop = nil
  self.textTime = nil
  self.textTips = nil
  self.gridLayout = nil
  self.btnInfo = nil
  self.compTop4 = nil
  self.compTop2 = nil
  self.compTop1 = nil
  self.compTop3 = nil
  self.compTop5 = nil
  self.compTopList = nil
end

function UILLGroupChooseView:DataDefine()
  self:RefreshUI()
end

function UILLGroupChooseView:DataDestroy()
  self.eTime = nil
  self.items = nil
end

function UILLGroupChooseView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LandlordActInfoRefresh, self.RefreshUI)
end

function UILLGroupChooseView:OnRemoveListener()
  self:RemoveUIListener(EventId.LandlordActInfoRefresh, self.RefreshUI)
  base.OnRemoveListener(self)
end

function UILLGroupChooseView:OnPanelClick()
  self.ctrl:CloseSelf()
end

function UILLGroupChooseView:OnBtnCloseClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  self.ctrl:CloseSelf()
end

function UILLGroupChooseView:OnBtnInfoClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILLRule, {anim = true}, LLConst.RuleType.Rule)
end

function UILLGroupChooseView:Update1000MS()
  if self.eTime == nil or self.eTime == 0 then
    return
  end
  local curSec = UITimeManager:GetInstance():GetServerSeconds()
  local remainSec = self.eTime - curSec
  if 0 < remainSec then
    self.textTime:SetText(UITimeManager:GetInstance():SecondToFmtString(remainSec))
  else
    self.eTime = 0
    if self.groupPartIdx == 3 then
      self:OnPanelClick()
    end
  end
end

function UILLGroupChooseView:RefreshUI()
  self.eTime = nil
  local gpInfo = ActMgr:GetCurGroupPartInfo()
  if gpInfo == nil then
    self:OnPanelClick()
    return
  end
  local info = ActMgr:GetActCurStageInfo()
  local stage = info ~= nil and info.stage or LLConst.LandlordStage.PREVIEW
  if stage ~= LLConst.LandlordStage.GROUP then
    self:OnPanelClick()
    return
  end
  self.eTime = gpInfo.eTime
  self.groupPartIdx = gpInfo.partIdx
  local isFarmer = self.groupPartIdx == 2
  local group = isFarmer and LLConst.LandLordGroup.FARMER or LLConst.LandLordGroup.LORD
  local maxTeammate = ActMgr:GetCampMaxTeammateCount(group, true)
  self.compTop:SetSpacing(isFarmer and 0 or 80)
  local lList = ActMgr:GetServersByGroup(group)
  for i, v in ipairs(self.compTopList) do
    v:SetActive(i <= maxTeammate)
    if i <= maxTeammate then
      local lInfo = lList[i]
      v:SetServer(lInfo, i == 1)
    end
  end
  self.items = self.items or {}
  local rList = ActMgr:GetServersByGroup(LLConst.LandLordGroup.NONE)
  local rl = #rList
  local il = #self.items
  local max = math.max(rl, il)
  for i = 1, max do
    local v = rList[rl - (i - 1)]
    local comp = self.items[i]
    if v then
      if comp == nil then
        comp = self:LoadComponentAsync(CLS, PREFAB, self.gridLayout)
        self.items[i] = comp
      end
      comp:SetActive(true)
      comp:SetServer(v)
    elseif comp ~= nil then
      comp:SetActive(false)
    end
  end
  local curBp = gpInfo.curBp
  local defNum = isFarmer and LLConst.INIT_BIG_FARMER_COUNT or LLConst.INIT_BIG_LORD_COUNT
  local totalLimit = gpInfo.totalLimit + defNum
  local cnt = Mathf.Clamp(curBp - (totalLimit - #lList), 0, curBp)
  self.textTips:SetLocalText(isFarmer and "zonewar_landlord_desc_1012" or "zonewar_landlord_desc_1043", cnt, curBp)
  self:Update1000MS()
end

return UILLGroupChooseView
