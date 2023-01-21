# sct_curfew

https://youtu.be/7fMgC0p1ir4

# Config
```
// Debug โหมด
Config.Debug = true 

Config.Zones = {
    // ขนาดวง curfew ค่าเป็น float
    Radius = 80.0, 
    // Cooldown ของวง curfew 
    CoolDownTimer = 10 -- sec
}
```
# Export Function
```lua

# Client
exports.sct_curfew.ReqGetZone()
ใช้สำหรับดึงข้อมูล Zone Curfew ทั้งหมด

exports.sct_curfew.ReqCreateZone()
ใช้สำหรับสร้าง Curfew

exports.sct_curfew.ReqSyncZone()
ใช้สำหรับดึงข้อมูล Zone ที่ถูกสร้างหมดทั้งใหม่

exports.sct_curfew.ReqUpdateZone(id: number)
ใช้สำหรับอัพเดพ Zone ซึ่งไอดีในที่นี้ จะหมายถึงไอดี ของผู้สร้าง curfew

exports.sct_curfew.ReqRemoveZone(id: number)
ใช้สำหรับ ลบข้อมูลโซน ซึ่งไอดีในที่นี้ จะหมายถึงไอดี ของผู้สร้าง curfew นั้นๆ
```
