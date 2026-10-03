local MailCollectItem = BaseClass("MailCollectItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Setting = CS.GameEntry.Setting
local _cp_txtTitle = "txtTitle"
local _cp_btnPos = "txtTitle/txtPos/btnPos"
local _cp_txtPos = "txtTitle/txtPos"
local _cp_txtTime = "txtTime"
local _cp_imgItemIcon = "itemIcon"
local _cp_txtItemCnt = "itemCnt"
local _cp_newFlag = "newFlag"

function MailCollectItem:OnCreate()
  base.OnCreate(self)
  self._txtTitle = self:AddComponent(UIText, _cp_txtTitle)
  self._btnPos = self:AddComponent(UIButton, _cp_btnPos)
  self._btnPos:SetOnClick(BindCallback(self, self.OnClickBtnPos))
  self._txtPos = self:AddComponent(UIText, _cp_txtPos)
  self._txtTime = self:AddComponent(UIText, _cp_txtTime)
  self._txtItemCnt = self:AddComponent(UIText, _cp_txtItemCnt)
  self._imgItemIcon = self:AddComponent(UIImage, _cp_imgItemIcon)
  self._newFlag = self:AddComponent(UIBaseContainer, _cp_newFlag)
end

function MailCollectItem:OnClickBtnPos()
  local pointId = self.mailData.pointId or 0
  GoToUtil.MoveToWorldPoint(pointId)
end

function MailCollectItem:SetData(maildata)
  self.mailData = maildata
  local strName, strItemIcon
  if maildata.resourceParam then
    local name = GetTableData(TableName.GatherResource, maildata.gatherResourceId, "name")
    strName = Localization:GetString(name)
    local icon_full_path = GetTableData(TableName.Aps_Resource_Item, tonumber(maildata.resourceParam), "pic_new")
    if string.IsNullOrEmpty(icon_full_path) then
      local icon = GetTableData(TableName.Aps_Resource_Item, tonumber(maildata.resourceParam), "pic")
      strItemIcon = string.format(LoadPath.ItemPath, icon)
    else
      strItemIcon = icon_full_path
    end
  else
    strName = CommonUtil.GetResourceNameByType(maildata.resourceType)
    strItemIcon = DataCenter.ResourceManager:GetResourceIconByType(maildata.resourceType)
  end
  if maildata.gatherResourceId then
    local lv = GetTableData(TableName.GatherResource, maildata.gatherResourceId, "level")
    strName = Localization:GetString("300665", lv) .. " " .. strName
  end
  local vecPos = SceneUtils.IndexToTilePos(maildata.pointId, ForceChangeScene.World)
  local strPoint = "(" .. vecPos.x .. ", " .. vecPos.y .. ")"
  local strTime = MailShowHelper.GetAbstractCreateTime(maildata)
  local strCnt = "X" .. tostring(maildata.resourceValue)
  self._imgItemIcon:LoadSprite(strItemIcon)
  local lastOpenTime = Setting:GetPrivateInt(SettingKeys.MAIL_COLLECT_LAST_OPEN, 0)
  if lastOpenTime < maildata.createTime / 1000 then
    self._newFlag:SetActive(true)
  else
    self._newFlag:SetActive(false)
  end
  self._txtTitle:SetText(strName)
  self._txtPos:SetText(strPoint)
  self._txtTime:SetText(strTime)
  self._txtItemCnt:SetText(strCnt)
end

return MailCollectItem
