local UIMailTroopInfoItem = require("UI.UIMailNew.UIMailTroopInfoListView.Component.UIMailTroopInfoItem")
local Localization = CS.GameEntry.Localization
local UIMailTroopInfoListView = BaseClass("UIMailTroopInfoListView", UIBaseView)
local base = UIBaseView
local _cp_btnClose = "UICommonPopUpTitle/CloseBtn"
local _cp_txtTitle = "UICommonPopUpTitle/Common_img_title/titleText"
local _cp_content = "ScrollView/Viewport/Content"
local _cp_txtTotalPower = "objTopTitle/txtTotalPower"
local _cp_txtTotalDead = "objTopTitle/txtTotalDead"
local _cp_txtTotalInjure = "objTopTitle/txtTotalInjure"
local _cp_txtTotalWounded = "objTopTitle/txtTotalWounded"
local _cp_txtTotalCurve = "objTopTitle/txtTotalCurve"
local _cp_txtTotalAlive = "objTopTitle/txtTotalAlive"

function UIMailTroopInfoListView:OnCreate()
  base.OnCreate(self)
  self._btnClose = self:AddComponent(UIButton, _cp_btnClose)
  self._btnClose:SetOnClick(BindCallback(self, self.OnClickBtnClose))
  self._txtTitle = self:AddComponent(UIText, _cp_txtTitle)
  self._content = self:AddComponent(UIBaseContainer, _cp_content)
  self._prefab = self.transform:Find("objToopItem").gameObject
  self._txtTotalPower = self:AddComponent(UIText, _cp_txtTotalPower)
  self._txtTotalDead = self:AddComponent(UIText, _cp_txtTotalDead)
  self._txtTotalInjure = self:AddComponent(UIText, _cp_txtTotalInjure)
  self._txtTotalWounded = self:AddComponent(UIText, _cp_txtTotalWounded)
  self._txtTotalAlive = self:AddComponent(UIText, _cp_txtTotalAlive)
  self._txtTotalCurve = self:AddComponent(UIText, _cp_txtTotalCurve)
  self._txtTotalPower:SetLocalText(130068)
  self._txtTotalDead:SetLocalText(310131)
  self._txtTotalInjure:SetLocalText(310132)
  self._txtTotalWounded:SetLocalText(310133)
  self._txtTotalAlive:SetLocalText(310134)
  self._txtTotalCurve:SetLocalText(310130)
end

function UIMailTroopInfoListView:OnClickBtnClose()
  self.ctrl:CloseSelf()
end

function UIMailTroopInfoListView:OnEnable()
  base.OnEnable(self)
  local param = self:GetUserData()
  self.leftFightData = param.leftFightData
  self.rightFightData = param.rightFightData
  self._txtTitle:SetLocalText(310141)
  self.alldatas = {}
  if self.leftFightData.unitData ~= nil and self.leftFightData.afterUnitData ~= nil then
    local oneData = {}
    oneData.fightData = self.leftFightData
    oneData.type = 1
    table.insert(self.alldatas, oneData)
  end
  if self.rightFightData.unitData ~= nil and self.rightFightData.afterUnitData ~= nil then
    local oneData = {}
    oneData.fightData = self.rightFightData
    oneData.type = 2
    table.insert(self.alldatas, oneData)
  end
  self:ShowItems()
end

function UIMailTroopInfoListView:ShowItems()
  self._prefab.gameObject:GameObjectRecycleAll()
  self._content:RemoveComponents(UIMailTroopInfoItem)
  if #self.alldatas > 0 then
    for _, sItem in pairs(self.alldatas) do
      self:AddTroopNode(sItem)
    end
  end
end

function UIMailTroopInfoListView:AddTroopNode(sItemList)
  local item = self._prefab:GameObjectSpawn(self._content.transform)
  NameCount = NameCount + 1
  item.name = NameCount
  local obj = self._content:AddComponent(UIMailTroopInfoItem, item.name)
  obj:SetData(sItemList)
end

function UIMailTroopInfoListView:OnDestroy()
  self._content:RemoveComponents(UIMailTroopInfoItem)
  base.OnDestroy(self)
end

return UIMailTroopInfoListView
