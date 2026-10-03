local UIMineCaveUnlockView = BaseClass("UIMineCaveUnlockView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local title_path = "UICommonRewardPopUp/Panel/ImgTitleBg/TextTitle"
local mineIcon_path = "anim/mine/mineIcon"
local mineLvTxt_path = "anim/mine/lv/lvTxt"
local mineLvNum_path = "anim/mine/lv/lv"
local speedTxt_path = "anim/mine/get/getTxt"
local speedNum_path = "anim/mine/get/getNum"
local anim_path = "anim"
local closeBtn_path = "UICommonRewardPopUp/Panel"
local subTitle_path = "subTitle"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitUI()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.titleN = self:AddComponent(UIText, title_path)
  self.titleN:SetLocalText(130056)
  self.subTitleN = self:AddComponent(UIText, subTitle_path)
  self.subTitleN:SetLocalText(302327)
  self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtnN:SetOnClick(function()
    self:OnClickCloseBtn()
  end)
  self.animN = self:AddComponent(UIAnimator, anim_path)
  self.mineIconN = self:AddComponent(UIImage, mineIcon_path)
  self.mineLvTxtN = self:AddComponent(UIText, mineLvTxt_path)
  self.mineLvNumN = self:AddComponent(UIText, mineLvNum_path)
  self.speedTxtN = self:AddComponent(UIText, speedTxt_path)
  self.speedTxtN:SetText(Localization:GetString("100041") .. ": ")
  self.speedNumN = self:AddComponent(UIText, speedNum_path)
end

local function ComponentDestroy(self)
  self.titleN = nil
  self.closeBtnN = nil
  self.animN = nil
  self.mineIconN = nil
  self.mineLvTxtN = nil
  self.mineLvNumN = nil
  self.speedTxtN = nil
  self.speedNumN = nil
end

local function DataDefine(self)
  self.toUnlockConfList = nil
  self.toUnlockScore = 0
end

local function DataDestroy(self)
  self.toUnlockConfList = nil
  self.toUnlockScore = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function InitUI(self)
  local toUnlockInfo = self:GetUserData()
  if not toUnlockInfo then
    return
  end
  self.toUnlockScore = toUnlockInfo.score
  self.toUnlockConfList = toUnlockInfo.minesConfList
  self:ShowNext()
end

local function ShowNext(self)
  if not self.toUnlockConfList or #self.toUnlockConfList == 0 then
    self.ctrl:CloseSelf()
    return
  end
  local tempConf = self.toUnlockConfList[1]
  table.remove(self.toUnlockConfList, 1)
  self.mineIconN:LoadSprite(string.format("Assets/Main/Sprites/UI/UIMineCave/%s", tempConf.picture))
  self.mineLvTxtN:SetText(Localization:GetString(tempConf.name) .. ": ")
  self.mineLvNumN:SetText(Localization:GetString("300627", tempConf.level))
  local tempSpeed = tempConf:GetResSpeed(DataCenter.BuildManager.MainLv)
  local strSpeed = string.GetFormattedStr(tempSpeed) .. "/h"
  self.speedNumN:SetText(strSpeed)
  self.animN:Play("showNext", 0, 0)
end

local function OnClickCloseBtn(self)
  self:ShowNext()
end

UIMineCaveUnlockView.OnCreate = OnCreate
UIMineCaveUnlockView.OnDestroy = OnDestroy
UIMineCaveUnlockView.ComponentDefine = ComponentDefine
UIMineCaveUnlockView.ComponentDestroy = ComponentDestroy
UIMineCaveUnlockView.DataDefine = DataDefine
UIMineCaveUnlockView.DataDestroy = DataDestroy
UIMineCaveUnlockView.OnAddListener = OnAddListener
UIMineCaveUnlockView.OnRemoveListener = OnRemoveListener
UIMineCaveUnlockView.InitUI = InitUI
UIMineCaveUnlockView.ShowNext = ShowNext
UIMineCaveUnlockView.OnClickCloseBtn = OnClickCloseBtn
return UIMineCaveUnlockView
