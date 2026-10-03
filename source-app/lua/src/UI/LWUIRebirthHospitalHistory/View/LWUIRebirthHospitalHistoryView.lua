local LWUIRebirthHospitalHistoryView = BaseClass("LWUIRebirthHospitalHistoryView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWUIRebirthHospitalHistoryItemComponent = require("UI/LWUIRebirthHospitalHistory/Component/LWUIRebirthHospitalHistoryItemComponent")

function LWUIRebirthHospitalHistoryView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.compRoot:SetActive(false)
  SFSNetwork.SendMessage(MsgDefines.RebirthHospitalHistory)
end

function LWUIRebirthHospitalHistoryView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIRebirthHospitalHistoryView:ComponentDefine()
  self.textTitle = self:AddComponent(UIText, "UICommonPopUpTitle/Common_img_title/titleText")
  self.textTitle:SetText(Localization:GetString("emergency_center_desc_1012"))
  self.btnClose = self:AddComponent(UIButton, "UICommonPopUpTitle/CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.btnPanel = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.compTemplate = self:AddComponent(LWUIRebirthHospitalHistoryItemComponent, "Root/ScrollView/LWRebirthHospitalHistoryCell")
  self.compContent = self:AddComponent(UIBaseContainer, "Root/ScrollView/Viewport/Content")
  self.textEmpty = self:AddComponent(UIText, "Root/TextEmpty")
  self.textEmpty:SetText(Localization:GetString("avatar_tips004"))
  self.compRoot = self:AddComponent(UIBaseContainer, "Root")
end

function LWUIRebirthHospitalHistoryView:ComponentDestroy()
  self:ClearScroll()
  self.textTitle = nil
  self.btnClose = nil
  self.btnPanel = nil
  self.compLWRebirthHospitalHistoryCell = nil
  self.compContent = nil
  self.textEmpty = nil
end

function LWUIRebirthHospitalHistoryView:DataDefine()
end

function LWUIRebirthHospitalHistoryView:DataDestroy()
end

function LWUIRebirthHospitalHistoryView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RebirthHospitalHistoryUpdate, self.OnHistoryInfoUpdate)
end

function LWUIRebirthHospitalHistoryView:OnRemoveListener()
  self:RemoveUIListener(EventId.RebirthHospitalHistoryUpdate, self.OnHistoryInfoUpdate)
  base.OnRemoveListener(self)
end

function LWUIRebirthHospitalHistoryView:OnHistoryInfoUpdate()
  self.compRoot:SetActive(true)
  self:ClearScroll()
  local historyInfoList = DataCenter.RebirthHospitalManager:GetHistoryInfoList()
  local isShow = not table.IsNullOrEmpty(historyInfoList)
  self.textEmpty:SetActive(not isShow)
  if isShow then
    for i, v in pairs(historyInfoList) do
      self.cells[i] = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/UIBuildDispatching/Hospital/Rebirth/LWRebirthHospitalHistoryCell.prefab", function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.compContent.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.name = "item" .. i
        local cell = self.compContent:AddComponent(LWUIRebirthHospitalHistoryItemComponent, go.name)
        cell:ReInit(v)
      end)
    end
  end
end

function LWUIRebirthHospitalHistoryView:ClearScroll()
  self.compContent:RemoveComponents(LWUIRebirthHospitalHistoryItemComponent)
  if self.cells ~= nil then
    for k, v in pairs(self.cells) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.cells = {}
end

function LWUIRebirthHospitalHistoryView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function LWUIRebirthHospitalHistoryView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

return LWUIRebirthHospitalHistoryView
