local MailBattleAttrDetailCell = require("UI.UIMailNew.UIMailBattleAttrDetail.Component.MailBattleAttrDetailCell")
local MailBattleAttrDetailTitle = BaseClass("MailBattleAttrDetailTitle", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local txt_left_path = "Maintitlebg/leftName"
local txt_center_path = "Maintitlebg/centerName"
local txt_right_path = "Maintitlebg/rightName"
local content_path = "Content"
local _cp_btnShow = "Maintitlebg/btnShow"
local _cp_imgClose = "Maintitlebg/btnShow/imgClose"
local _cp_imgOpen = "Maintitlebg/btnShow/imgOpen"

function MailBattleAttrDetailTitle:OnCreate()
  base.OnCreate(self)
  self.txt_left = self:AddComponent(UIText, txt_left_path)
  self.txt_center = self:AddComponent(UIText, txt_center_path)
  self.txt_right = self:AddComponent(UIText, txt_right_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self._btnShow = self:AddComponent(UIButton, _cp_btnShow)
  self._btnShow:SetOnClick(BindCallback(self, self.OnClickBtnShow))
  self._imgClose = self:AddComponent(UIImage, _cp_imgClose)
  self._imgOpen = self:AddComponent(UIImage, _cp_imgOpen)
  self._showState = false
  self._imgOpen:SetActive(false)
  self._imgClose:SetActive(true)
  self.content:SetActive(false)
  self.createFinish = false
end

function MailBattleAttrDetailTitle:OnDestroy()
  self:SetAllCellDestroy()
  base.OnDestroy(self)
end

function MailBattleAttrDetailTitle:ReInit(param)
  self:SetAllCellDestroy()
  self.usePercent = true
  if param.showType == BattleSubTitleShowType.HeroAttack or param.showType == BattleSubTitleShowType.HeroDefence or param.showType == BattleSubTitleShowType.MarchLimitAdd then
    self.usePercent = false
  end
  local dialogId = param.dialogId
  self.txt_center:SetText(Localization:GetString(dialogId))
  if param.leftNum > param.rightNum then
    self.txt_left:SetColor(GreenColor)
  elseif param.leftNum < param.rightNum then
    self.txt_left:SetColor(WorldRedColor)
  else
    self.txt_left:SetColorRGBA(0.7176471, 0.4, 0.1882353, 1)
  end
  if self.usePercent == true then
    self.txt_left:SetText(string.GetFormattedPercentStr(param.leftNum / 100))
    self.txt_right:SetText(string.GetFormattedPercentStr(param.rightNum / 100))
  else
    self.txt_left:SetText(string.GetFormattedSeperatorNum(math.floor(param.leftNum)))
    self.txt_right:SetText(string.GetFormattedSeperatorNum(math.floor(param.rightNum)))
  end
  self.list = param.reasonList
end

function MailBattleAttrDetailTitle:OnClickBtnShow()
  self._showState = not self._showState
  self._imgOpen:SetActive(self._showState)
  self._imgClose:SetActive(not self._showState)
  if self._showState == true then
    self.content:SetActive(true)
    if self.createFinish == false then
      self:SetAllCellDestroy()
      local list = self.list
      local totalNum = 0
      local createNum = 0
      for k, v in pairs(list) do
        if 0 < v.leftData.totalNum or 0 < v.rightData.totalNum then
          totalNum = totalNum + 1
          if self.model[k] == nil then
            self.model[k] = self:GameObjectInstantiateAsync(UIAssets.MailBattleAttrDetailCell, function(request)
              if request.isError then
                return
              end
              local go = request.gameObject
              go.gameObject:SetActive(true)
              go.transform:SetParent(self.content.transform)
              go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
              local nameStr = tostring(NameCount)
              go.name = nameStr
              NameCount = NameCount + 1
              local cell = self.content:AddComponent(MailBattleAttrDetailCell, nameStr)
              cell:ReInit(v, k, self.usePercent)
              createNum = createNum + 1
              if createNum >= totalNum then
                self.createFinish = true
              end
            end)
          end
        end
      end
    end
  else
    if self.createFinish == false then
      self:SetAllCellDestroy()
    end
    self.content:SetActive(false)
  end
end

function MailBattleAttrDetailTitle:SetAllCellDestroy()
  self.content:RemoveComponents(MailBattleAttrDetailCell)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.model = {}
end

return MailBattleAttrDetailTitle
