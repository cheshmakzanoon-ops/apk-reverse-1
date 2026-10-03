local UILWUserPromptView = BaseClass("UILWUserPromptView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local title_text_path = "PopUpTitle/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local right_btn_path = "BtnGo/RightBtn"
local left_btn_path = "BtnGo/LeftBtn"
local des_name_path = "Content/DesName"
local res_num_path = "Content/ResNum"
local res_item_path = "Content/ResNum/ResItem"
local pic_icon_path = "Content/ResNum/PicIcon"
local today_toggle_path = "Content/TodayToggle"

function UILWUserPromptView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:UpdateData()
end

function UILWUserPromptView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWUserPromptView:ComponentDefine()
  self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.right_btn = self:AddComponent(UIButton, right_btn_path)
  self.left_btn = self:AddComponent(UIButton, left_btn_path)
  self.des_name = self:AddComponent(UITextMeshProUGUIEx, des_name_path)
  self.res_num = self:AddComponent(UITextMeshProUGUIEx, res_num_path)
  self.res_icon = self:AddComponent(UIButton, pic_icon_path)
  self.res_item = self:AddComponent(UICommonResItem, res_item_path)
  self.today_toggle = self:AddComponent(UIToggle, today_toggle_path)
  self.right_btn:SetOnClick(function()
    self:OnBtnClick(self.funCancel)
  end)
  self.left_btn:SetOnClick(function()
    self:OnBtnClick(self.funConfirm)
  end)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.res_icon:SetOnClick(function()
  end)
  self.today_toggle:SetOnValueChanged(function(tf)
    if tf and self.todayNotShown then
      UIUtil.GetTodayActiveCount(self.todayNotShown, true)
    else
      Setting:SetPrivateString(self.todayNotShown, "0")
    end
  end)
end

function UILWUserPromptView:ComponentDestroy()
  self.title_text = nil
  self.close_btn = nil
  self.right_btn = nil
  self.left_btn = nil
  self.des_name = nil
  self.res_num = nil
  self.res_icon = nil
  self.res_item = nil
  self.today_toggle = nil
  self.param = nil
end

function UILWUserPromptView:UpdateData()
  local param = self:GetUserData()
  if param then
    if param.todayNotShown then
      self.todayNotShown = param.todayNotShown
      self.today_toggle:SetActive(true)
    else
      self.today_toggle:SetActive(false)
    end
    if param.res then
      local resHas = toInt(param.res.countHas)
      local resNeed = toInt(param.res.countNeed)
      if 0 < resNeed and 0 < resHas then
        local strHas = string.GetFormattedSeparatorNum(resHas)
        local strNeed = string.GetFormattedSeparatorNum(resNeed)
        if resHas < resNeed then
          self.res_num:SetText(string.format("<color=#E52727>%s/%s</color>", strHas, strNeed))
        else
          self.res_num:SetText(string.format("<color=#79FF42>%s/%s</color>", strHas, strNeed))
        end
        self.res_num:SetActive(true)
        if param.res.id and param.res.type then
          local item = DataCenter.RewardManager:ParseOneReward(param.res.id, tonumber(param.res.type), resHas)
          self.res_icon:SetActive(false)
          self.res_item:SetActive(true)
          self.res_item:ReInit(item)
        elseif param.res.iconPath then
          self.res_icon:LoadSprite(param.res.iconPath)
          self.res_icon:SetActive(true)
          self.res_item:SetActive(false)
        else
          self.res_icon:SetActive(false)
          self.res_item:SetActive(false)
        end
      else
        self.res_num:SetActive(false)
      end
    else
      self.res_num:SetActive(false)
    end
    self.des_name:SetText(param.desc)
    self.title_text:SetText(param.title or Localization:GetString("100378"))
    self.funConfirm = param.funConfirm
    self.funCancel = param.funCancel
  end
  self.param = param
end

function UILWUserPromptView:OnBtnClick(callback)
  self.ctrl:CloseSelf()
  if callback ~= nil and type(callback) == "function" then
    CommonUtil.ProtectCall(function()
      callback()
    end)
  end
end

local ResParamDefine, ParamDefine
return UILWUserPromptView
