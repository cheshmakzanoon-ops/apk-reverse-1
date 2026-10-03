local UIDeviceManageCell = BaseClass("UIDeviceManageCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIDeviceRoleItem = require("UI.UIAccount2.UIDeviceManage.Component.UIDeviceRoleItem")

function UIDeviceManageCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIDeviceManageCell:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIDeviceManageCell:OnEnable()
  base.OnEnable(self)
end

function UIDeviceManageCell:OnDisable()
  base.OnDisable(self)
end

function UIDeviceManageCell:ComponentDefine()
  self.normalBg = self:AddComponent(UIBaseContainer, "GroupDevice/bgNormal")
  self.selectedBg = self:AddComponent(UIBaseContainer, "GroupDevice/bgSelected")
  self.imageDevice = self:AddComponent(UIImage, "GroupDevice/imageDevice")
  self.imageDeviceSel = self:AddComponent(UIImage, "GroupDevice/imageDeviceSel")
  self.textName = self:AddComponent(UIText, "GroupDevice/textName")
  self.currentSign = self:AddComponent(UIBaseContainer, "GroupDevice/textName/textCurrent")
  self.textModel = self:AddComponent(UIText, "GroupDevice/Scroll View/Viewport/textModel")
  self.textTime = self:AddComponent(UIText, "GroupDevice/textTime")
  self.deleteBtn = self:AddComponent(UIButton, "GroupDevice/btnDelete")
  self.deleteBtn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.expandBtn = self:AddComponent(UIButton, "GroupDevice/btnExpand")
  self.expandBtn:SetOnClick(function()
    self:OnExpandBtnClick()
  end)
  self.btnModel = self:AddComponent(UIButton, "GroupDevice/Scroll View/Viewport/textModel")
  self.btnModel:SetOnClick(function()
    self:OnExpandBtnClick()
  end)
  self.content = self:AddComponent(UIBaseContainer, "GroupHeros")
  self.itemTemplateGo = self:AddComponent(UIBaseContainer, "GroupHeros/RoleItem").gameObject
  self.itemTemplateGo:GameObjectCreatePool()
  self.arrowUp = self:AddComponent(UIBaseContainer, "GroupDevice/imageArrowNormal")
  self.arrowDown = self:AddComponent(UIBaseContainer, "GroupDevice/imageArrowOpen")
  self.leftUpMore = self:AddComponent(UIBaseContainer, "GroupDevice/imageLeftUpMore")
  self.arrowUp:SetActive(true)
  self.arrowDown:SetActive(false)
  self.leftUpMore:SetActive(false)
end

function UIDeviceManageCell:ComponentDestroy()
  self.normalBg = nil
  self.selectedBg = nil
  self.imageDevice = nil
  self.imageDeviceSel = nil
  self.textName = nil
  self.currentSign = nil
  self.textModel = nil
  self.textTime = nil
  self.deleteBtn = nil
  self:ClearScroll()
end

function UIDeviceManageCell:DataDefine()
  self.data = {}
end

function UIDeviceManageCell:DataDestroy()
  self.data = nil
end

function UIDeviceManageCell:SetData(data)
  self.data = data
  local deviceId = CS.GameEntry.Setting:GetString(SettingKeys.DEVICE_ID, "")
  if deviceId == data.deviceId then
    self.normalBg:SetActive(false)
    self.selectedBg:SetActive(true)
    self.currentSign:SetActive(true)
  else
    self.normalBg:SetActive(true)
    self.selectedBg:SetActive(false)
    self.currentSign:SetActive(false)
  end
  if data.modelInfo ~= nil and not string.IsNullOrEmpty(data.modelInfo.model) then
    self.textModel:SetText(data.modelInfo.model)
  else
    self.textModel:SetLocalText(130262)
  end
  if data.modelInfo ~= nil and not string.IsNullOrEmpty(data.modelInfo.pf) then
    if data.modelInfo.pf == "0" then
      self.textName:SetText("iOS")
      self.imageDevice:LoadSprite("Assets/Main/Sprites/UI/UIDeviceManage/lyt_yunying_qingchushebei_ios.png")
      self.imageDeviceSel:LoadSprite("Assets/Main/Sprites/UI/UIDeviceManage/lyt_yunying_qingchushebei_iosdangqian.png")
    elseif data.modelInfo.pf == "1" then
      self.textName:SetText("Android")
      self.imageDevice:LoadSprite("Assets/Main/Sprites/UI/UIDeviceManage/lyt_yunying_qingchushebei_anzuo.png")
      self.imageDeviceSel:LoadSprite("Assets/Main/Sprites/UI/UIDeviceManage/lyt_yunying_qingchushebei_anzuodangqian.png")
    elseif data.modelInfo.pf == "2" then
      self.textName:SetText("PC")
      self.imageDevice:LoadSprite("Assets/Main/Sprites/UI/UIDeviceManage/lyt_yunying_qingchushebei_diannao.png")
      self.imageDeviceSel:LoadSprite("Assets/Main/Sprites/UI/UIDeviceManage/lyt_yunying_qingchushebei_diannaodangqian.png")
    else
      self.textName:SetLocalText(130262)
      self.imageDevice:LoadSprite("Assets/Main/Sprites/UI/UIDeviceManage/wxy_denglu_wenhao.png")
      self.imageDeviceSel:LoadSprite("Assets/Main/Sprites/UI/UIDeviceManage/wxy_denglu_wenhao.png")
    end
  else
    self.textName:SetLocalText(130262)
    self.imageDevice:LoadSprite("Assets/Main/Sprites/UI/UIDeviceManage/wxy_denglu_wenhao.png")
    self.imageDeviceSel:LoadSprite("Assets/Main/Sprites/UI/UIDeviceManage/wxy_denglu_wenhao.png")
  end
  if data.modelInfo ~= nil and data.modelInfo.lastTime ~= 0 then
    local timeStr1 = Localization:GetString("device_manage_desc04") .. UITimeManager:GetInstance():TimeStampToTimeForServerMinute(data.modelInfo.lastTime)
    self.textTime:SetText(timeStr1)
  else
    local timeStr2 = Localization:GetString("device_manage_desc04") .. Localization:GetString("130262")
    self.textTime:SetText(timeStr2)
  end
  self:ClearScroll()
  self.arrowUp:SetActive(true)
  self.arrowDown:SetActive(false)
  self.leftUpMore:SetActive(false)
  self.content:SetActive(false)
  if data.userInfos == nil then
    return
  end
  for k, v in ipairs(data.userInfos) do
    local item = self.itemTemplateGo:GameObjectSpawn(self.content.transform)
    item.name = "hero_item_" .. k
    local cell = self.content:AddComponent(UIDeviceRoleItem, item.name)
    cell:SetData(v, data.deviceId)
  end
end

function UIDeviceManageCell:ClearScroll()
  self.content:RemoveComponents(UIDeviceRoleItem)
  self.itemTemplateGo:GameObjectRecycleAll()
end

function UIDeviceManageCell:OnBtnClick()
  if self.data == nil or self.data.deviceId == nil then
    Logger.Log("UIDeviceManageCell:OnBtnClick() data is nil or deviceId is nil")
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIDeviceManageDelConfirm, {anim = true}, self.data)
end

function UIDeviceManageCell:OnExpandBtnClick()
  if self.content.activeSelf then
    self.arrowUp:SetActive(true)
    self.arrowDown:SetActive(false)
    self.leftUpMore:SetActive(false)
    self.content:SetActive(false)
  else
    self.arrowUp:SetActive(false)
    self.arrowDown:SetActive(true)
    self.leftUpMore:SetActive(false)
    self.content:SetActive(true)
  end
end

return UIDeviceManageCell
