local WinterStormMainMatchTimeItem = BaseClass("WinterStormMainMatchTimeItem", UIBaseContainer)
local base = UIBaseContainer
local img_bg_path = "Bg"
local txt_cur_group_md_path = "DayText"
local txt_cur_group_h_path = "TimeText"
local img_arr_path = "Arrow"
local img_time_di_path = "lrb_dongjifengbao_zhanzhengshijianduan01a"
local img_time_arr_path = "lrb_dongjifengbao_zhanzhengshijianduan01b"
local img_cur_di_path = "lrb_dongjifengbao_zhanzhengshijianduan02a"
local img_cur_arr_path = "lrb_dongjifengbao_zhanzhengshijianduan02b"
local color_time = Color.New(0.09019607843137255, 0.43529411764705883, 0.7019607843137254, 1)
local color_cur = Color.New(0.7529411764705882, 0.2980392156862745, 0.2196078431372549, 1)

function WinterStormMainMatchTimeItem:OnCreate()
  base.OnCreate(self)
  self:SetActive(false)
  self.bCur = false
  self.img_bg = self:AddComponent(UIImage, img_bg_path)
  self.txt_cur_group_md = self:AddComponent(UIText, txt_cur_group_md_path)
  self.txt_cur_group_h = self:AddComponent(UIText, txt_cur_group_h_path)
  self.img_arr = self:AddComponent(UIImage, img_arr_path)
end

function WinterStormMainMatchTimeItem:OnDestroy()
  self.bCur = false
  self.img_bg = nil
  self.txt_cur_group_md = nil
  self.txt_cur_group_h = nil
  self.img_arr = nil
  base.OnDestroy(self)
end

function WinterStormMainMatchTimeItem:SetTime(bCur, date1, date2)
  self:SetActive(true)
  self.bCur = bCur
  local pColor = bCur == true and color_cur or color_time
  local md = ""
  if date1.day == date2.day then
    md = string.format("%02d/%02d", date1.month, date1.day)
  else
    md = string.format("%02d/%02d~%02d/%02d", date1.month, date1.day, date2.month, date2.day)
  end
  self.txt_cur_group_md:SetText(md)
  self.txt_cur_group_md:SetColor(pColor)
  local h = string.format("%02d:%02d~%02d:%02d", date1.hour, date1.min, date2.hour, date2.min)
  self.txt_cur_group_h:SetText(h)
  self.txt_cur_group_h:SetColor(pColor)
  self.img_bg:LoadSpriteAuto(string.format(LoadPath.LWCommonPath, bCur == true and img_cur_di_path or img_time_di_path))
  self.img_arr:LoadSpriteAuto(string.format(LoadPath.LWCommonPath, bCur == true and img_cur_arr_path or img_time_arr_path))
end

function WinterStormMainMatchTimeItem:SetFixX(fixX)
  local pos = self.img_arr.transform.position
  local baseX = self.transform.position.x
  pos.x = baseX + fixX * CommonUtil.ArabicAutoMirrorFactor()
  self.img_arr.transform.position = pos
end

return WinterStormMainMatchTimeItem
