local UILuckyRollBox = BaseClass("UILuckyRollBox", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local REACH_TEXT_MAT = "Assets/Main/TMPFont/Main/BodyFontMat/Body-Outline_FF8317-Shadow_793E03_28.mat"
local NORMAL_TEXT_MAT = "Assets/Main/TMPFont/Main/BodyFontMat/Body-Outline_000000_28.mat"

function UILuckyRollBox:OnCreate()
  base.OnCreate(self)
  self._needNum_txt = self:AddComponent(UITextMeshProUGUIEx, "Txt_NeedNum")
  self._box_btn = self:AddComponent(UIButton, "")
  self._box_btn:SetOnClick(function()
    self:OnClickReward()
  end)
  self.item = self:AddComponent(UICommonResItem, "UICommonResItem")
  self.frameIcon = self:AddComponent(UIImage, "FrameIcon")
  self.lineIcon = self:AddComponent(UIImage, "LineIcon")
end

function UILuckyRollBox:OnDestroy()
  self:ClearEffect()
  base.OnDestroy(self)
end

function UILuckyRollBox:OnEnable()
  base.OnEnable(self)
end

function UILuckyRollBox:OnDisable()
  base.OnDisable(self)
end

function UILuckyRollBox:RefreshData(data, allNum, activityId, showLine)
  self.data = data
  self.allNum = allNum
  self.activityId = activityId
  self:RefreshBox(showLine)
end

function UILuckyRollBox:ClearEffect()
  if self.effectRequest then
    self.effectRequest:Destroy()
    self.effectRequest = nil
  end
  self.effectObj = nil
end

function UILuckyRollBox:RefreshBox(showLine)
  self._needNum_txt:SetText(self.data.needLotteryNum)
  local actData = DataCenter.ActLuckyRollInfo:GetInfoByActId(tonumber(self.activityId))
  local reward = DeepCopy(actData.stageArr[self.data.stage].reward)
  if not table.IsNullOrEmpty(reward) then
    for i, v in ipairs(reward) do
      self.item:ReInit(v)
      break
    end
  end
  if self.data.state == 0 then
    CS.UIGray.SetGray(self.item.transform, false, true)
    self.frameIcon:SetActive(self.allNum >= self.data.needLotteryNum)
    if self.allNum >= self.data.needLotteryNum then
      if self.effectObj then
        self.effectObj:SetActive(true)
      else
        self.effectRequest = self:GameObjectInstantiateAsync(UIAssets.BattlePassEffect, function(request)
          if request.isError or IsNull(request.gameObject) then
            return
          end
          local go = request.gameObject
          go:SetActive(true)
          go.transform:SetParent(self.transform)
          go.transform:Set_localScale(0.6, 0.6, 0.6)
          if CommonUtil.IsArabicAutoMirrorOpen() then
            go.transform:Set_anchoredPosition(-19.9, 38.5, 0)
          else
            go.transform:Set_anchoredPosition(19.4, 38.5, 0)
          end
          self.effectObj = go
        end)
      end
    else
      self:ClearEffect()
    end
  else
    CS.UIGray.SetGray(self.item.transform, true, true)
    self.frameIcon:SetActive(false)
    self:ClearEffect()
  end
  self.lineIcon:SetActive(showLine)
end

function UILuckyRollBox:OnClickReward()
  local x = self.transform.position.x
  local y = self.transform.position.y
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local offset = 150 * scaleFactor
  if self.data.state == 0 and self.allNum >= self.data.needLotteryNum then
    SFSNetwork.SendMessage(MsgDefines.ReceiveLuckyRollStageReward, self.activityId, self.data.stage)
  else
  end
end

return UILuckyRollBox
