local UICityVisitorView = BaseClass("UICityVisitorView", UIBaseView)
local base = UIBaseView
local heroIconImg_path = "panel/heroIcon"
local heroNameText_path = "panel/content/nameLatout/heroName/heroNameText"
local agreeBtn_path = "panel/btnLayout/agreeBtn"
local agreeBtnText_path = "panel/btnLayout/agreeBtn/Text"
local refuseBtn_path = "panel/btnLayout/refuseBtn"
local refuseBtnText_path = "panel/btnLayout/refuseBtn/refuseText"
local returnBtn_path = "panel/returnBtn"
local contenText_path = "panel/content/contentImg/contentText"
local nextContenBtn_path = "panel/content/contentImg/nextBtn"
local nextContenImg_path = "panel/content/contentImg/netImg"
local btnLayout_path = "panel/btnLayout"
local Plan_path = "panel"

function UICityVisitorView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UICityVisitorView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UICityVisitorView:DataDestroy()
  self.param = nil
  self.desDataList = nil
end

function UICityVisitorView:ComponentDestroy()
  self.heroIconImg = nil
  self.desScroll = nil
  self.agreeBtn = nil
  self.refuseBtn = nil
  self.returnBtn = nil
end

function UICityVisitorView:ComponentDefine()
  self.heroIconImg = self:AddComponent(UIRawImage, heroIconImg_path)
  self.agreeBtn = self:AddComponent(UIButton, agreeBtn_path)
  self.refuseBtn = self:AddComponent(UIButton, refuseBtn_path)
  self.returnBtn = self:AddComponent(UIButton, returnBtn_path)
  self.heroNameText = self:AddComponent(UIText, heroNameText_path)
  self.agreeBtnText = self:AddComponent(UIText, agreeBtnText_path)
  self.contenText = self:AddComponent(UIText, contenText_path)
  self.nextContenBtn = self:AddComponent(UIButton, nextContenBtn_path)
  self.btnLayout = self:AddComponent(UIButton, btnLayout_path)
  self.nextPlaneBtn = self:AddComponent(UIButton, Plan_path)
  self.nextContenImg = self:AddComponent(UIImage, nextContenImg_path)
  self.refuseBtnText = self:AddComponent(UIText, refuseBtnText_path)
  self.refuseBtn:SetOnClick(function()
    self:OnrefuseBtnClick()
  end)
  self.agreeBtn:SetOnClick(function()
    self:OnAgreeBtnClick()
  end)
  self.nextContenBtn:SetOnClick(function()
    self:OnNextContenBtnClick()
  end)
  self.nextPlaneBtn:SetOnClick(function()
    self:OnNextContenBtnClick()
  end)
  self.returnBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.nextContenImg:SetActive(true)
end

function UICityVisitorView:OnAgreeBtnClick()
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.DialogueClaimedBtn, false)
  if self.param.confirmFun then
    self.param.confirmFun()
  end
end

function UICityVisitorView:OnrefuseBtnClick()
  if self.param.cancelFun then
    self.param.cancelFun()
  end
end

function UICityVisitorView:OnNextContenBtnClick()
  if #self.desDataList >= 1 then
    local text = ""
    if self.desDataList[1].model then
      if self.desDataList[1].model ~= 0 then
        self.heroIconImg:LoadSpriteAuto(HeroUtils.GetHeroIconPath(self.desDataList[1].model, HeroIconType.pose_icon_path), function(texture)
          if self and self.heroIconImg then
            self.heroIconImg:SetNativeSize()
          end
        end)
      end
      text = self.desDataList[1].des
    else
      text = self.desDataList[1]
    end
    self.contenText:SetText(text)
    if #self.desDataList == 1 then
      if self.param.type ~= OptionType.Normal then
        self.btnLayout:SetActive(true)
      else
        self.nextPlaneBtn:SetOnClick(function()
          self:Close()
        end)
      end
      self.nextContenImg:SetActive(false)
    end
    table.remove(self.desDataList, 1)
  elseif self.param.type == OptionType.Normal then
    self:Close()
  end
end

function UICityVisitorView:Close()
  if self.param.closeCallBack then
    self.param.closeCallBack()
  end
  self.ctrl:CloseSelf(self.param.isNotShowMain)
end

function UICityVisitorView:DataDefine()
  self.param = {}
  self.desDataList = {}
end

function UICityVisitorView:ReInit()
  self.param = self:GetUserData()
  self.desDataList = DeepCopy(self.param.desList)
  self.heroIconImg:LoadSpriteAuto(HeroUtils.GetHeroIconPath(self.param.data.modelId, HeroIconType.pose_icon_path), function(texture)
    if self and self.heroIconImg then
      self.heroIconImg:SetNativeSize()
    end
  end)
  self.heroNameText:SetText(self.param.data.name)
  self:OnNextContenBtnClick()
  self.btnLayout:SetActive(false)
  if self.param.type == OptionType.One then
    self.refuseBtn:SetActive(false)
  elseif self.param.type == OptionType.Two then
    self.refuseBtn:SetActive(true)
  end
  if self.param.confirmText then
    self.agreeBtnText:SetLocalText(self.param.confirmText)
  end
  if self.param.cancelText then
    self.refuseBtnText:SetLocalText(self.param.cancelText)
  end
  if self.param.callBack then
    self.param.callBack()
  end
  self.returnBtn:SetActive(not self.param.isHide)
end

return UICityVisitorView
