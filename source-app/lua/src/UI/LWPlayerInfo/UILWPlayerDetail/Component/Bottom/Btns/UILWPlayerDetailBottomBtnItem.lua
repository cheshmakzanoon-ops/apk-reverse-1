local UIPLayerDetailBottomBtnItem = BaseClass("UIPLayerDetailBottomBtnItem", UIBaseContainer)
local base = UIBaseContainer
local BirthdayBtnItem = require("UI.LWPlayerInfo.UILWPlayerDetail.Component.Bottom.Btns.BirthdayBtnItem")

function UIPLayerDetailBottomBtnItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:ReInit()
end

function UIPLayerDetailBottomBtnItem:OnAddListener()
  base.OnAddListener(self)
end

function UIPLayerDetailBottomBtnItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIPLayerDetailBottomBtnItem:ComponentDefine()
  self.icon = self:AddComponent(UIImage, "Image")
  self.text = self:AddComponent(UIText, "name")
  self.btn = self:AddComponent(UIButton, "")
  self.redDot = self:AddComponent(UIImage, "RedDotRecord")
  self.prefabRoot = self:AddComponent(UIBaseContainer, "prefabRoot")
  self.redDotNumRoot = self:AddComponent(UIBaseContainer, "RedDotNumRoot")
  self.redDotNum = self:AddComponent(UIText, "RedDotNumRoot/RedDotNum")
  self.btn:SetOnClick(function()
    self:OnClick()
  end)
end

function UIPLayerDetailBottomBtnItem:OnClick()
  if not self.config then
    return
  end
  self.redDot:SetActive(false)
  self.redDotNumRoot:SetActive(false)
  self.view.ctrl:OnBottomBtnClick(self.view.data, self.config.type)
end

function UIPLayerDetailBottomBtnItem:ReInit(config)
  if not config then
    return
  end
  self.config = config
  self.icon:LoadSprite(self.config.icon)
  self.text:SetLocalText(self.config.text)
  self.redDot:SetActive(false)
  self.redDotNumRoot:SetActive(false)
  self:TrySetPrefabContent()
end

function UIPLayerDetailBottomBtnItem:SetData(data)
  local isOn = self.view.ctrl:GetRedDotIsOpenByType(self.config.type, data) or false
  self.redDot:SetActive(isOn)
  local num = self.view.ctrl:GetRedDotNumIsOpenByType(self.config.type, data) or -1
  self.redDotNumRoot:SetActive(0 < num)
  if 0 < num then
    self.redDotNum:SetText(num)
  end
  self:TrySetPrefabContent()
end

function UIPLayerDetailBottomBtnItem:ComponentDestroy()
  self.icon = nil
  self.text = nil
  self.btn = nil
end

function UIPLayerDetailBottomBtnItem:OnDestroy()
  self:DestroyPrefabContent()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIPLayerDetailBottomBtnItem:DataDestroy()
  self.config = nil
end

function UIPLayerDetailBottomBtnItem:TrySetPrefabContent()
  self:SetIconShow(true)
  if not self.config then
    return
  end
  self.text:SetLocalText(self.config.text)
  self:DestroyPrefabContent()
  if self.config.type == PlayerDetailBottomBtnType.Like then
    self:TrySetLikePrefabContent()
  end
end

function UIPLayerDetailBottomBtnItem:TrySetLikePrefabContent()
  local data = self.view.data
  if not data then
    return
  end
  if data.uid == LuaEntry.Player.uid then
    return
  end
  local haveSet = false
  if not string.IsNullOrEmpty(data.birthday) and DataCenter.BirthdayDataManager:CheckIsPassSetShowArea(data.uid, data.allianceId, data.birthdayDisplay) then
    haveSet = true
  end
  local isShow = false
  if haveSet and not DataCenter.BirthdayDataManager:GetIsHaveBirthdayHistoriey(data.uid) then
    local isInBirthday = DataCenter.BirthdayDataManager:CheckIsSameTime(data.birthday)
    if isInBirthday then
      isShow = true
    end
  end
  if isShow then
    self.prefabContentReq = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWPlayerInfo/PlayerDetailBtnPrefab/birthdayBtn.prefab", function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.transform:SetParent(self.prefabRoot.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
      local btnItem = self.prefabRoot:AddComponent(BirthdayBtnItem, go)
      btnItem:SetData(data)
      btnItem:SetActive(true)
      self.text:SetLocalText("birthday_tips_25")
      self:SetIconShow(false)
    end)
  end
end

function UIPLayerDetailBottomBtnItem:SetIconShow(isShow)
  self.btn:SetEnable(isShow)
  self.icon:SetActive(isShow)
  self.prefabRoot:SetActive(not isShow)
end

function UIPLayerDetailBottomBtnItem:DestroyPrefabContent()
  self.prefabRoot:RemoveComponents(BirthdayBtnItem)
  if self.prefabContentReq then
    self:GameObjectDestroy(self.prefabContentReq)
    self.prefabContentReq = nil
  end
end

return UIPLayerDetailBottomBtnItem
