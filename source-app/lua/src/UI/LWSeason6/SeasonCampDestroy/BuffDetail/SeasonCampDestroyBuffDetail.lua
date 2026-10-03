local SeasonCampDestroyBuffDetail = BaseClass("SeasonCampDestroyBuffDetail", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local SeasonCampDestroyBuffDetailIR = require("UI.LWSeason6.SeasonCampDestroy.BuffDetail.SeasonCampDestroyBuffDetailIR")

function SeasonCampDestroyBuffDetail:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function SeasonCampDestroyBuffDetail:OnDestroy()
  self:ReleasePool()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonCampDestroyBuffDetail:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textPTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.btnPClose = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnPClose:SetOnClick(function()
    self:OnBtnPCloseClick()
  end)
  self.textTmpDescription = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.scrollRectScrollRect = self.viewSkin:AddComponent(self, UIScrollRect, 4)
  self.compScrollRect = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
  self.textTmpTitle0 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textTmpTitle1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.textTmpTitle2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.compItemsContent = self.viewSkin:AddComponent(self, UIBaseContainer, 9)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 10)
  self.compIrTemplate = self.viewSkin:AddComponent(self, SeasonCampDestroyBuffDetailIR, 11)
  self.compIrTemplate.gameObject:GameObjectCreatePool()
  self.compIrTemplate:SetActive(false)
end

function SeasonCampDestroyBuffDetail:ComponentDestroy()
  self.viewSkin = nil
  self.textPTitle = nil
  self.btnPClose = nil
  self.textTmpDescription = nil
  self.scrollRectScrollRect = nil
  self.compScrollRect = nil
  self.textTmpTitle0 = nil
  self.textTmpTitle1 = nil
  self.textTmpTitle2 = nil
  self.compItemsContent = nil
  self.compContent = nil
  self.compIrTemplate = nil
end

function SeasonCampDestroyBuffDetail:DataDefine()
  self.items = {}
  self.args = self:GetUserData()
  self:Refresh(self.args)
end

function SeasonCampDestroyBuffDetail:DataDestroy()
  self.items = nil
  self.contents = nil
  self.args = nil
end

function SeasonCampDestroyBuffDetail:OnAddListener()
  base.OnAddListener(self)
end

function SeasonCampDestroyBuffDetail:OnRemoveListener()
  base.OnRemoveListener(self)
end

function SeasonCampDestroyBuffDetail:OnBtnPCloseClick()
  self.ctrl:CloseSelf()
end

function SeasonCampDestroyBuffDetail:Refresh(args)
  if not args then
    return
  end
  if args.windowTitle then
    self.textPTitle:SetText(args.windowTitle)
  end
  if args.desc then
    self.textTmpDescription:SetText(args.desc)
  end
  if args.titles and #args.titles == 3 then
    self.textTmpTitle0:SetText(args.titles[1])
    self.textTmpTitle1:SetText(args.titles[2])
    self.textTmpTitle2:SetText(args.titles[3])
  end
  self.contents = args.contents or {}
  self:RefreshList()
end

function SeasonCampDestroyBuffDetail:RefreshList()
  for i, data in ipairs(self.contents) do
    local go = self.compIrTemplate.gameObject:GameObjectSpawn(self.compItemsContent.transform)
    go.name = "SeasonCampDestroyBuffDetailIR_" .. i
    local ir = self.compItemsContent:AddComponent(SeasonCampDestroyBuffDetailIR, go.name)
    ir:SetData(data)
    ir:SetActive(true)
    table.insert(self.items, ir)
  end
  self:RefreshLayout()
end

function SeasonCampDestroyBuffDetail:RefreshLayout()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compItemsContent.transform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compContent.transform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.compScrollRect.transform)
end

function SeasonCampDestroyBuffDetail:ReleasePool()
  if self.compIrTemplate and self.compIrTemplate.gameObject then
    self.compIrTemplate.gameObject:GameObjectRecycleAll()
  end
  self.items = {}
end

return SeasonCampDestroyBuffDetail
